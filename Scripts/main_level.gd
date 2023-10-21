extends Node3D

@export var cameraBounds: Vector2 = Vector2(-2, 12)

@export var levelId: int = -1
var betweenLevels: bool = true

var levelSections: Array[Array] = [[],[],[],[],[],[]]
@export var betweenSections: Array[PackedScene]

@export var currentLevel: Node3D
var instanceRef: Node3D

func _ready():
	%Camera.bounds = cameraBounds
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_0.tscn"))
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_0.tscn"))
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_0.tscn"))
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_0.tscn"))
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_0.tscn"))

func _process(delta):
	pass

func ChooseSections() -> Array:
	var fullSet = range(5)
	fullSet.remove_at(randi_range(0, 4))
	fullSet.remove_at(randi_range(0, 3))
	return fullSet


func _on_level_end_area_entered(area):
	%Player.global_position = Vector3(-5, 0, 0)
	%Camera.TeleportToPlayer()
	RemoveCurrentArea()
	if(betweenLevels):
		betweenLevels = false
		levelId += 1
		MakeCombatArea()
		UpdateCameraBounds(0, 75)
	else:
		betweenLevels = true
		MakeRestArea()
		UpdateCameraBounds(0, 0)

func RemoveCurrentArea():
	currentLevel.queue_free()

func MakeRestArea():
	currentLevel = betweenSections[levelId].instantiate()
	$LevelEnd.global_position.x = 15

func MakeCombatArea():
	currentLevel = Node3D.new()
	add_child(currentLevel)
	var buildSections = ChooseSections()
	for ii in 3:
		instanceRef = levelSections[levelId][buildSections[ii]].instantiate()
		currentLevel.add_child(instanceRef)
		instanceRef.global_position.x += 30 * ii
	$LevelEnd.global_position.x = 90

func UpdateCameraBounds(left: float, right: float):
	cameraBounds.x = left
	cameraBounds.y = right
	%Camera.bounds = cameraBounds
