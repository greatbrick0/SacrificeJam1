extends Node3D

@export var cameraBounds: Vector2 = Vector2(-2, 12)

@export var levelId: int = 0
var betweenLevels: bool = false

@export var levelSections: Array[Array]
@export var betweenSections: Array[PackedScene]

@export var currentLevel: Node3D
var instanceRef: Node3D

func _ready():
	%Camera.bounds = cameraBounds
	print(ChooseSections())

func _process(delta):
	pass

func ChooseSections() -> Array:
	var fullSet = range(5)
	fullSet.remove_at(randi_range(0, 4))
	fullSet.remove_at(randi_range(0, 3))
	return fullSet


func _on_level_end_area_entered(area):
	if(betweenLevels):
		betweenLevels = false
		levelId += 1
	else:
		betweenLevels = true
