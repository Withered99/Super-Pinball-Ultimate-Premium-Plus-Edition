
extends Control

const SHEET_URL := "https://corsproxy.io/?https://script.google.com/macros/s/AKfycbzUtZLCshfp8PC1sio8KXwWWrnDGG5TpmSgFt11zD6qTvhyNWpYE6Xq9g7FjYdt2zTo/exec"

@onready var http: HTTPRequest = $HTTPRequest
@onready var name_box: VBoxContainer = $CenterContainer/NameBox
@onready var final_score_label: Label = $CenterContainer/NameBox/FinalScoreLabel
@onready var name_input: LineEdit = $CenterContainer/NameBox/NameInput
@onready var submit_button: Button = $CenterContainer/NameBox/SubmitButton

@onready var leaderboard_box: VBoxContainer = $CenterContainer/LeaderboardBox
@onready var leaderboard_label: Label = $CenterContainer/LeaderboardBox/LeaderboardLabel

var request_type := ""
var request_pending := false

func _ready() -> void:
	visible = false
	http.request_completed.connect(_on_request_completed)
	http.timeout = 5.0

func show_game_over() -> void:
	Global.stop_scoring()
	final_score_label.text = "Final Score: %d" % Global.score

	name_box.visible = true
	leaderboard_box.visible = false
	submit_button.disabled = false
	name_input.text = ""

	visible = true
	get_tree().paused = true
	name_input.grab_focus()

func _on_submit_button_pressed() -> void:
	var player_name := name_input.text.strip_edges()

	if player_name.is_empty():
		player_name = "Anonymous"

	submit_button.disabled = true
	name_box.visible = false
	leaderboard_box.visible = true

	# Offline/browser fallback
	if not _can_connect():
		leaderboard_label.text = "Score: %d\n\nOffline mode.\nYour score was not uploaded." % Global.score
		return

	leaderboard_label.text = "Saving score..."
	request_type = "submit"

	var body := JSON.stringify({
		"name": player_name,
		"score": Global.score
	})

	var headers := ["Content-Type: text/plain;charset=utf-8"]
	var error := http.request(
		SHEET_URL,
		headers,
		HTTPClient.METHOD_POST,
		body
	)

	if error != OK:
		_show_offline_message()

func _can_connect() -> bool:
	if OS.has_feature("web"):
		return false

	return true

func _fetch_top_scores() -> void:
	if not _can_connect():
		leaderboard_label.text = "Offline mode.\nLeaderboard unavailable."
		return

	leaderboard_label.text = "Loading top scores..."
	request_type = "fetch"

	var error := http.request(SHEET_URL)

	if error != OK:
		_show_offline_message()

func _show_offline_message() -> void:
	request_type = ""
	leaderboard_label.text = "Score: %d\n\nCould not connect to the leaderboard.\nYou can still play offline!" % Global.score
	submit_button.disabled = false

func _on_request_completed(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
) -> void:

	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		_show_offline_message()
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())

	if request_type == "submit":
		if parsed is Dictionary and parsed.get("status") == "success":
			_fetch_top_scores()
		else:
			_show_offline_message()
		return

	if request_type == "fetch":
		if parsed is Array:
			var display_text := "--- TOP 10 SCORES ---\n"

			for i in range(min(parsed.size(), 10)):
				var entry: Dictionary = parsed[i]
				display_text += "%d. %s - %d\n" % [
					i + 1,
					entry.get("name", "Anonymous"),
					int(entry.get("score", 0))
				]

			leaderboard_label.text = display_text
			request_type = ""
		else:
			_show_offline_message()

func _on_play_again_button_pressed() -> void:
	Global.reset_score()
	get_tree().paused = false
	get_tree().reload_current_scene()
