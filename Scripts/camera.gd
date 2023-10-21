extends Camera3D

var playerRef: Player
var bounds: Vector2
var speed: float = 6
@export var leadDistance: float = 2

func _ready():
	playerRef = %Player

func _process(delta):
	if(playerRef.velocity.x == 0):
		MoveTowards(playerRef.global_position.x, delta)
		print("a")
	elif(playerRef.velocity.x > 0):
		MoveTowards(playerRef.global_position.x + leadDistance, delta)
		print("b")
	elif(playerRef.velocity.x < 0):
		MoveTowards(playerRef.global_position.x - leadDistance, delta)
		print("c")

func MoveTowards(newX: float, delta):
	if(abs(global_position.x - newX) <= delta * speed):
		global_position.x = newX
		print("1")
	elif(newX > global_position.x):
		global_position.x += speed * delta
		print("2")
	elif(newX < global_position.x):
		global_position.x -= speed * delta
		print("3")
