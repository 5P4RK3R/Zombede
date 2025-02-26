extends CharacterBody2D


const SPEED:float = 50.0
const JUMP_VELOCITY:float = -400.0
var player:Node
var direction:Vector2
var player_position:Vector2
var chase:bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D # @onready helps to access variable on runtime
#func _ready():
#	anim.play("idle")

# func _on_player_detection_body_entered(body):
	#print(body)
	#if body.name == "player":
	#	print("player")
	#	chase = true 

#func _on_player_detection_body_exited(body):
#	if body.name == "player":
#		print("player")
#		chase = false

func _physics_process(delta:float) -> void:
	velocity.y += gravity * delta 
	# Get the player's position
	if chase == true:
		player = get_node("../Player")  # Adjust the path to the player node as needed.
		player_position = player.global_position
		#print(player_position)
	# Calculate the direction to the player
		direction = (player_position - global_position).normalized()
		if direction.x < 0:
			anim.flip_h = true 
			velocity.x = direction.x * SPEED
			anim.play("walk")
		else:
			anim.flip_h = false
			velocity.x = direction.x * SPEED
			anim.play("walk")
	move_and_slide()
	
	# Move towards the player
	#move_and_slide(direction * SPEED * delta)
# func _process(delta):
	# Add the gravity.
	#if not is_on_floor():
	#	 

	# Handle Jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	# if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	#
func death() -> void:
	chase = false
	self.queue_free()

func _on_player_detection_body_shape_entered(body_rid:RID, body:Node, body_shape_index:int, local_shape_index:int) -> void:
	#print(body.name)
	if body.name == "Player":
		#print("player")
		chase = true # Replace with function body.


func _on_player_detection_body_shape_exited(body_rid:RID, body:Node, body_shape_index:int, local_shape_index:int) -> void:
	if body.name == "Player":
		#print("player")
		chase = false # Replace with function body.


func _on_player_death_body_shape_entered(body_rid:RID, body:Node, body_shape_index:int, local_shape_index:int) -> void:
	if body.name == "Player": # Replace with function body.
		death()


func _on_player_collision_body_shape_entered(body_rid:RID, body:Node, body_shape_index:int, local_shape_index:int) -> void:
	if body.name == "Player":
		body.health -= 5
		death() # Replace with function body.
