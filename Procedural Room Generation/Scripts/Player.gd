extends CharacterBody2D

@export var speed = 5000
var horizontalVelocity
var verticalVelocity

func _physics_process(delta):
	horizontalVelocity = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	verticalVelocity = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	velocity = (Vector2(horizontalVelocity,verticalVelocity).normalized())*speed*delta
	move_and_slide()
