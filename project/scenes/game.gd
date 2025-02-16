extends Node

const SCROLL_SPEED : int = 4
const PIPE_DELAY : int = 200
const PIPE_RANGE : int = 200
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
	$Bird.reset()

func start_game() -> void:
	game_running = true
	$Bird.flying = true
	$Bird.flap()

func end_game() -> void:
	game_running = false
	game_over = true

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
