extends CharacterBody3D

var playerRef: Player
var aggro: bool = false
@export var aggroRange: float
@export var speed: float = 1.5
@export var health: int = 10
@export var gravity: float = 9

func _ready():
	playerRef = get_tree().get_first_node_in_group("Player")
	aggroRange = aggroRange * aggroRange

func _process(delta):
	if(aggro and global_position.distance_squared_to(playerRef.global_position) > aggroRange):
		aggro = false
	elif(!aggro and global_position.distance_squared_to(playerRef.global_position) <= aggroRange):
		aggro = true

func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y -= gravity * delta
	if(aggro):
		var direction = -(global_position - playerRef.global_position).normalized()
		velocity.x = 0
		velocity.z = 0
	move_and_slide()

func TakeDamage(amount: int):
	health -= amount
	if(health <= 0):
		Die()
	else:
		$Sounds/HurtSound.play()

func Die():
	$Sounds/DeathSound.play()
	$CollisionShape3D.set_deferred("disabled", true)
	$DamageArea/CollisionShape3D.set_deferred("disabled", true)
	$Visuals.visible = false
