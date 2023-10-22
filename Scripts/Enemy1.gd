extends CharacterBody3D

var playerRef: Player
var aggro: bool = false
@export var aggroRange: float

@export var health: int = 10
var stunTime: float = 0

func _ready():
	playerRef = get_tree().get_first_node_in_group("Player")
	aggroRange = sqrt(aggroRange)

func _process(delta):
	if(!aggro and global_position.distance_squared_to(playerRef.global_position) <= aggroRange):
		aggro = true

func TakeDamage(amount: int):
	health -= amount
	if(amount <= 0):
		Die()

func Die():
	queue_free()
