extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
#	Utils.saveGame() 
#	Utils.loadGame()# Replace with function body.
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass


func _on_quit_pressed() -> void:
	get_tree().quit() # Quit the game


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn") # Change scene by file
