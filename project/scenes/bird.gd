extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
const START_POS = Vector2(100,400)

var flying : bool = false
var falling: bool = false

func is_hit_obstacle() -> bool:
	return false

func flap() -> void:
	velocity.y = FLAP_SPEED

func reset() -> void:
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)
	
func _ready() -> void:
	reset()

func _physics_process(delta: float) -> void:
	
	# if we're not falling or flying, stop everything
	if not flying and not falling:
		$BirdAnimation.stop()
		return
		
	# gravity with terminal velocity
	velocity.y += clamp(GRAVITY * delta, 0, MAX_VEL)
	if flying:
		set_rotation(deg_to_rad(velocity.y * 0.05))
		$BirdAnimation.play()
	elif falling:
		set_rotation(PI/2)
		$BirdAnimation.stop()
	move_and_collide(velocity * delta)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		flap()
