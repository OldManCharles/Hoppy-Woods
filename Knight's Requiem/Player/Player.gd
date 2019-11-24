extends KinematicBody2D

const GRAVITY = 35
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

export var movement_speed = 200
export var jump_force = 700
export var gravity_cap = 90

# node references
onready var animated_sprite : AnimatedSprite = get_node("AnimatedSprite")

var motion = Vector2(0, 0)
var can_jump = false

func _physics_process(delta):
	handle_player_controls()
	pass

func handle_player_controls():
	apply_gravity()
	jump()
	move()
	motion = move_and_slide(motion, UP)
	animate()

func apply_gravity():
	if !is_on_floor():
		motion.y += GRAVITY
		if motion.y >= gravity_cap:
			motion.y = gravity_cap
	else:
		can_jump = true;
	pass

func jump():
	if Input.is_action_just_pressed("jump") and can_jump:
		motion.y -= jump_force
		can_jump = false
	pass

func move():
	if Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		motion.x = -movement_speed
	elif Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
		motion.x = movement_speed
	else:
		motion.x = 0
	pass

func animate():
	if motion.y < 0:
		animated_sprite.play("jump")
	elif motion.y > 0:
		animated_sprite.play("fall")
	elif motion.x != 0 and is_on_floor():
		animated_sprite.set_flip_h(motion.x < 0)
		animated_sprite.play("run")
	elif motion.x == 0 and motion.y == 0 and is_on_floor():
		animated_sprite.play("idle")
	pass