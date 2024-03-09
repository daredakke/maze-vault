extends Node


enum Mode {
	WINDOW_ONE,
	WINDOW_TWO,
	FULLSCREEN,
}

const USER_SETTINGS: String = "user://settings.dat"
const BASE_SETTINGS: Dictionary = {
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"window_scale": Mode.WINDOW_ONE,
}

var settings: Dictionary
var resolutions: Array[Vector2i] = [
	Vector2i(640, 352),
	Vector2i(1280, 704),
]
var game_started: bool = false
var game_paused: bool:
	set(new_value):
		game_paused = new_value
		get_tree().paused = game_paused


func _ready() -> void:
	load_settings()


func pause_game() -> void:
	game_paused = true


func unpause_game() -> void:
	game_paused = false


func save_settings(music_volume: float, sfx_volume: float, window_scale: float) -> void:
	settings = {
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"window_scale": window_scale,
	}
	
	var file = FileAccess.open(USER_SETTINGS, FileAccess.WRITE_READ)
	file.store_var(settings)
	file = null


func load_settings() -> void:
	# Load scores
	if FileAccess.file_exists(USER_SETTINGS):
		var file = FileAccess.open(USER_SETTINGS, FileAccess.READ)
		settings = file.get_var()
		file = null
		
	# Or create scores.dat if it does not exist
	else:
		var file = FileAccess.open(USER_SETTINGS, FileAccess.WRITE_READ)
		settings = BASE_SETTINGS
		file.store_var(BASE_SETTINGS)
		file = null
