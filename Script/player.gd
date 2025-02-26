extends CharacterBody2D


const SPEED : float = 200.0
const JUMP_VELOCITY : float = -350.0
var health : int = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float  = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D  # @onready helps to access variable on runtime
func _ready() -> void:
	anim.play("idle")

func _physics_process(delta:float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction:float = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false
	if direction:
		velocity.x = direction * SPEED
		#anim.rotate(direction) # rotate 
		if velocity.y == 0:
			anim.play("run")
		#anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("idle")
	if velocity.y > 0:
		anim.play("idle")
	move_and_slide()
	
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
