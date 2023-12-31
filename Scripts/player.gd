extends CharacterBody3D
class_name Player

@export var depthBounds: Vector2 = Vector2(-1.5, 1.5)
@export var speed: Vector2 = Vector2(4, 2)
@export var ladderSpeed: float = 3
var speedMult: float = 1
@export var smallJumpHeight: float = 4.5
@export var bigJumpHeight: float = 10
@export var facingLeft: bool = false
@export var gravity: float 
@export var airBrakeMult: float = 4

@export var inCutscene: bool = false
var input_dir: Vector2
var holdingJump: bool
var onLadder: bool = false
var alreadyJumped: bool
var timeBlocking: float = 0

var coinCount: int = 0
@export var blocking: bool = false
@export var attacking: bool = false
var canAttack: bool = true
const maxHealth: int = 5
@export var health: int = 5
@export var pendantActive: bool = true
#true is donated, false is equipped [dagger, pendant, shield, boots, sword]
@export var donatedItems: Array[bool] = [false, false, false, false, false]

func _ready():
	%"Player Visual".UpdateItems(donatedItems)

func _process(delta):
	holdingJump = Input.is_action_pressed("Jump")
	input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	if(Input.is_action_pressed("Parry")): timeBlocking += 1.0 * delta
	if(Input.is_action_just_released("Parry")): timeBlocking = 0
	if(Input.is_action_pressed("Ability") and canAttack): StartAttack()
	
	speedMult = 1
	$Visuals/Sprite3D.flip_h = facingLeft
	$Attacks.rotation.y = int(facingLeft) * PI
	if(attacking):
		%"Player Visual".PlayAnim("Attack", false)
		speedMult = 0.3
	elif(blocking):
		if(donatedItems[2]):
			%"Player Visual".PlayAnim("Parry", false)
			speedMult = 0.6
		else:
			%"Player Visual".PlayAnim("Block", false)
			speedMult = 0
	elif(!is_on_floor()):
		%"Player Visual".PlayAnim("Air", true)
	elif(velocity):
		%"Player Visual".PlayAnim("Walk", true)
	else:
		%"Player Visual".PlayAnim("Idle", true)
	
	%"Player Visual".UpdateItems(donatedItems)
	if(donatedItems[1]): pendantActive = false

func _physics_process(delta):
	if(inCutscene):
		velocity.x = 0
		velocity.z = 0
		if(!is_on_floor()):
			velocity.y -= gravity * delta
		move_and_slide()
		return
	
	#jumping
	if(!onLadder):
		if(is_on_floor()):
			alreadyJumped = false
			if(holdingJump):
				alreadyJumped = true
				velocity.y = smallJumpHeight if donatedItems[3] else bigJumpHeight
				$Sounds/Jump.play()
		else:
			velocity.y -= gravity * delta * (airBrakeMult if (velocity.y > 0 and !holdingJump and alreadyJumped) else 1)
	else:
		if(holdingJump):
			velocity.y = ladderSpeed
		else:
			velocity.y = -ladderSpeed
	
	#moving
	if(input_dir.x != 0):
		facingLeft = input_dir.x < 0
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed.x * speedMult
		velocity.z = direction.z * speed.y * speedMult
	else:
		velocity.x = move_toward(velocity.x, 0, speed.x * speedMult)
		velocity.z = move_toward(velocity.z, 0, speed.y * speedMult)
	move_and_slide()
	if(global_position.z < depthBounds.x):
		global_position.z = depthBounds.x
	elif(global_position.z > depthBounds.y):
		global_position.z = depthBounds.y
	
	#blocking
	if(onLadder or attacking):
		blocking = false
		timeBlocking = 0
	elif(timeBlocking > 0.1):
		if(donatedItems[2]):
			blocking = timeBlocking < 0.5
		else:
			blocking = true
	else:
		blocking = false

func Heal(amount: int):
	amount = max(min(maxHealth - health, amount), 0)
	health += amount

func TakeDamage(amount: int):
	if(pendantActive):
		pendantActive = false
		$Sounds/Pendant.play()
	else:
		health -= amount
		velocity.y += 3
		$Sounds/Damage.play()
		if(health <= 0):
			Lose()

func Lose():
	inCutscene = true
	get_tree().change_scene_to_file("res://Scenes/End Screens/loss_screen.tscn")

func _on_attack_animator_animation_finished(anim_name):
	attacking = false
	$Attacks/DamageArea/Sword.disabled = true

func _on_attack_cooldown_timeout():
	canAttack = true

func StartAttack():
	canAttack = false
	attacking = true
	$Attacks/AttackCooldown.start()
	$Attacks/DamageArea/Sword.disabled = false
	
	if(donatedItems[0] and donatedItems[4]):
		$Attacks/AttackAnimator.play("Rock")
	elif(!donatedItems[0]):
		$Attacks/AttackAnimator.play("Dagger")
	else:
		$Attacks/AttackAnimator.play("Sword")

func ParrySound():
	$Sounds/Block.play()


func _on_ladder_box_area_entered(_area):
	onLadder = true

func _on_ladder_box_area_exited(_area):
	onLadder = false

func Cheat():
	if(Input.is_action_just_pressed("1")):
		donatedItems[0] = !donatedItems[0]
	if(Input.is_action_just_pressed("2")):
		donatedItems[1] = !donatedItems[1]
	if(Input.is_action_just_pressed("3")):
		donatedItems[2] = !donatedItems[2]
	if(Input.is_action_just_pressed("4")):
		donatedItems[3] = !donatedItems[3]
	if(Input.is_action_just_pressed("5")):
		donatedItems[4] = !donatedItems[4]

func _on_damage_area_area_entered(area):
	area.TakeDamage(4)

func _on_damage_area_body_entered(body):
	body.TakeDamage(4)
