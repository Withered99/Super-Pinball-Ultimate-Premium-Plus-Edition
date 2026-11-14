extends Control

const SHEET_URL := "https://script.google.com/macros/s/AKfycbzUtZLCshfp8PC1sio8KXwWWrnDGG5TpmSgFt11zD6qTvhyNWpYE6Xq9g7FjYdt2zTo/exec"

@onready var http: HTTPRequest = $HTTPRequest
@onready var name_box: VBoxContainer = $CenterContainer/NameBox
@onready var final_score_label: Label = $CenterContainer/NameBox/FinalScoreLabel
@onready var name_input: LineEdit = $CenterContainer/NameBox/NameInput
@onready var submit_button: Button = $CenterContainer/NameBox/SubmitButton

@onready var leaderboard_box: VBoxContainer = $CenterContainer/LeaderboardBox
@onready var leaderboard_label: Label = $CenterContainer/LeaderboardBox/LeaderboardLabel

func _ready() -> void:
	visible = false
	http.request_completed.connect(_on_request_completed)

func show_game_over() -> void:
	# Access your Global AutoLoad directly by name!
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
	leaderboard_label.text = "Saving score..."
	
	var body := JSON.stringify({
		"name": player_name,
		"score": Global.score
	})
	var headers := ["Content-Type: application/json"]
	http.request(SHEET_URL, headers, HTTPClient.METHOD_POST, body)

func _fetch_top_scores() -> void:
	leaderboard_label.text = "Loading top scores..."
	http.request(SHEET_URL)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		leaderboard_label.text = "Could not load scores (Error %d)" % response_code
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())

	if parsed is Dictionary and parsed.get("status") == "success":
		_fetch_top_scores()
		return

	if parsed is Array:
		var display_text := "--- TOP 10 SCORES ---\n"
		for i in range(parsed.size()):
			var entry: Dictionary = parsed[i]
			display_text += "%d. %s - %d\n" % [i + 1, entry["name"], int(entry["score"])]
		leaderboard_label.text = display_text

func _on_play_again_button_pressed() -> void:
	Global.reset_score()
	get_tree().paused = false
	get_tree().reload_current_scene()
