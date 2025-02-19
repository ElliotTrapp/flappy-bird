extends Node

@export var pipe_scene : PackedScene
@export var ground_scene : PackedScene

const SCROLL_SPEED : int = 3
const PIPE_DELAY : int = 150
const PIPE_RANGE : int = 150
const VALID_BUTTONS = [Key.KEY_SPACE, Key.KEY_ESCAPE, MouseButton.MOUSE_BUTTON_LEFT]

var game_running : bool = false
var game_over : bool = false
var screen_size : Vector2i
var ground_height : int
var pipes : Array
var scroll
var score


func is_valid_input(event: InputEvent) -> bool:
	if event is InputEventKey and event.key_label in VALID_BUTTONS:
		return true
	elif event is InputEventMouseButton and event.button_index in VALID_BUTTONS:
		return true
	return false

func space_pressed(event: InputEvent) -> bool:
	if event is InputEventKey and event.key_label == KEY_SPACE and event.pressed:
			return true
	return false
	
func left_mouse_pressed(event: InputEvent) -> bool:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			return true
	return false

func new_game() -> void:
	print_debug('setting up new game')
	# reset everything
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	#generate starting pipes
	generate_pipes()
	$Bird.reset()

func start_game() -> void:
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeTimer.start()
	# do this after the bird is in place
	var ground = ground_scene.instantiate()
	ground.hit.connect(bird_hit)
	add_child(ground)

func end_game() -> void:
	print_debug('game over!')
	game_running = false
	game_over = true
	$Bird.falling = true
	$Bird.flying = false
	$PipeTimer.stop()
	$GameOver.show()

func bird_hit() -> void:
	end_game()
	
func bird_scored() -> void:
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

func generate_pipes() -> void:
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	print_debug('pipe with height of %s' % pipe.position.y)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(bird_scored)
	add_child(pipe)
	pipes.append(pipe)

func _on_pipe_timer_timeout() -> void:
	generate_pipes()
	
func _on_game_over_restart() -> void:
	new_game()

func _input(event: InputEvent) -> void:
	# if the game is over, do nothing
	if game_over:
		print_debug('game is over')
		return
	
	# whatever was pushed, we don't support
	if not is_valid_input(event):
		print_debug('not valid input')
		return
		
	# we've only implemented left mouse and space, if something else is pushed do nothing
	if not game_running:
		start_game()
	else:
		if $Bird.flying:
			$Bird.flap()	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug('game initializing')
	screen_size = get_window().size
	ground_height = $Ground.get_node("GroundSprite").position.y
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not game_running:
		return
		
	# scroll the env
	scroll += SCROLL_SPEED
	# reset scroll
	if scroll >= screen_size.x:
		scroll = 0
	$Ground.position.x = -scroll
	for pipe in pipes:
		pipe.position.x -= SCROLL_SPEED
