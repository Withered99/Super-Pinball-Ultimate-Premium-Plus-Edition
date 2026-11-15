extends Node

var music_player: AudioStreamPlayer

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	music_player.stream = preload("res://Assets/background.mp3")
	music_player.volume_db = -10.0
	music_player.bus = "Music"

	music_player.finished.connect(_on_music_finished)

	music_player.play()

func _on_music_finished() -> void:
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_music() -> void:
	if not music_player.playing:
		music_player.play()

func set_volume(volume: float) -> void:
	music_player.volume_db = linear_to_db(clampf(volume, 0.0, 1.0))
