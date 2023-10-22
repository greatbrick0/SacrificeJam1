extends Node3D

@export var cameraBounds: Vector2 = Vector2(-2, 12)

@export var levelId: int = -1
var betweenLevels: bool = true

var levelSections: Array[Array] = [[],[],[],[],[],[]]
@export var sectionWidth: float = 30
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
	$UI/CoinsLabel.text = str(%Player.coinCount) + "/7"

func ChooseSections() -> Array:
	var fullSet = range(5)
	fullSet.remove_at(randi_range(0, 4))
	fullSet.remove_at(randi_range(0, 3))
	return fullSet


func _on_level_end_area_entered(area):
	%Player.global_position = Vector3(-8, 0, 0)
	%Camera.TeleportToPlayer()
	RemoveCurrentArea()
	$UI/CoinsLabel.visible = betweenLevels
	if(betweenLevels):
		betweenLevels = false
		levelId += 1
		MakeCombatArea()
		UpdateCameraBounds(0, sectionWidth * 3 - 15)
	else:
		betweenLevels = true
		MakeRestArea()
		UpdateCameraBounds(0, 0)

func RemoveCurrentArea():
	currentLevel.queue_free()

func MakeRestArea():
	currentLevel = betweenSections[levelId].instantiate()
	%LevelEnd.global_position.x = 15

func MakeCombatArea():
	currentLevel = Node3D.new()
	add_child(currentLevel)
	
	var buildSections = ChooseSections()
	for ii in 3:
		instanceRef = levelSections[levelId][buildSections[ii]].instantiate()
		currentLevel.add_child(instanceRef)
		instanceRef.global_position.x += sectionWidth * ii
	
	instanceRef = load("res://Scenes/Rest Sections/toll_area.tscn").instantiate()
	currentLevel.add_child(instanceRef)
	instanceRef.global_position.x = sectionWidth * 3
	
	%LevelEnd.global_position.x = sectionWidth * 3

func UpdateCameraBounds(left: float, right: float):
	cameraBounds.x = left
	cameraBounds.y = right
	%Camera.bounds = cameraBounds
