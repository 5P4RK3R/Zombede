extends Node
var SAVE_PATH:String = "res://savegame.bin"

func saveGame() -> void:
	var file:FileAccess = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"Gold": Game.Gold,
	}
	var datum:String = JSON.stringify(data)
	file.store_line(datum)
	
func loadGame() -> void:
	var file:FileAccess = FileAccess.open(SAVE_PATH,FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line:Dictionary = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerHP = current_line["playerHP"]
				Game.Gold = current_line["Gold"]
