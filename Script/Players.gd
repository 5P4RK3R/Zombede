extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score : int = 0
var speed : int = 200
var jumpForce : int = 1000
var gravity : int = 800


# onready - once the node is ready  
var vel : Vector2 = Vector2() #
@onready var sprite :  Sprite2D = $Sprite2D # or get_node("Sprite2D")
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	vel.x = 0
	
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
	if Input.is_action_pressed("move_right"):
		vel.x += speed
	#if Input.is_action_pressed("move_down"):
	#	vel.y += speed
	#if Input.is_action_pressed("move_up"):
	#	vel.y -= speed	
		
#velocity
	set_velocity(vel)
	set_up_direction(Vector2.UP)
	move_and_slide()
	vel = velocity

#gravity
	vel.y = gravity * delta 

#jump 
	if Input.is_action_just_pressed("jump") and  is_on_floor():
		vel.y -= jumpForce

#Sprite2D Direction
	if vel.x < 0:
		sprite.flip_h = true
	if vel.x > 0:
		sprite.flip_h = false
