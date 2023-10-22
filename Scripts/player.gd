extends CharacterBody3D
class_name Player

@export var speed: Vector2 = Vector2(4, 2)
@export var smallJumpHeight: float = 4.5
@export var bigJumpHeight: float = 10
@export var facingLeft: bool = false
@export var gravity: float 
@export var airBrakeMult: float = 4

var inCutscene: bool = false
var input_dir: Vector2
var holdingJump: bool
var alreadyJumped: bool
var timeBlocking: float = 0

var coinCount: int = 0
@export var blocking: bool = false
const maxHealth: int = 10
@export var health: int = 10
#true is donated, false is equipped [dagger, pendant, shield, boots, sword]
@export var donatedItems: Array[bool] = [false, false, false, false, false]

func _process(delta):
	holdingJump = Input.is_action_pressed("Jump")
	input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	if(Input.is_action_pressed("Parry")): timeBlocking += 1.0 * delta
	if(Input.is_action_just_released("Parry")): timeBlocking = 0

func _physics_process(delta):
	#jumping
	if(is_on_floor()):
		alreadyJumped = false
		if(holdingJump):
			alreadyJumped = true
			velocity.y = smallJumpHeight if donatedItems[3] else bigJumpHeight
	else:
		velocity.y -= gravity * delta * (airBrakeMult if (velocity.y > 0 and !holdingJump and alreadyJumped) else 1)
	
	#moving
	if(input_dir.x != 0):
		facingLeft = input_dir.x < 0
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed.x
		velocity.z = direction.z * speed.y
	else:
		velocity.x = move_toward(velocity.x, 0, speed.x)
		velocity.z = move_toward(velocity.z, 0, speed.y)
	move_and_slide()
	
	#blocking
	if(timeBlocking > 0.1):
		if(donatedItems[2]):
			blocking = true
		else:
			blocking = timeBlocking < 0.5
