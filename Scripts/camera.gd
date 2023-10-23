extends Camera3D

var playerRef: Player
var bounds: Vector2
@export var speed: float = 6
@export var leadDistance: float = 2

func _ready():
	playerRef = %Player

func _process(delta):
	if(playerRef.velocity.x == 0):
		MoveTowards(playerRef.global_position.x, delta)
	elif(playerRef.velocity.x > 0):
		MoveTowards(playerRef.global_position.x + leadDistance, delta)
	elif(playerRef.velocity.x < 0):
		MoveTowards(playerRef.global_position.x - leadDistance, delta)
	
	if(global_position.x < bounds.x):
		global_position.x = bounds.x
	elif(global_position.x > bounds.y):
		global_position.x = bounds.y

func MoveTowards(newX: float, delta):
	if(abs(global_position.x - newX) <= delta * speed):
		global_position.x = newX
	elif(newX > global_position.x):
		global_position.x += speed * delta
	elif(newX < global_position.x):
		global_position.x -= speed * delta

func TeleportToPlayer():
	global_position.x = playerRef.global_position.x
