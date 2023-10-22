extends Node3D

@export var cameraBounds: Vector2 = Vector2(-2, 12)

@export var levelId: int = -1
var betweenLevels: bool = true
var inToll: bool = false

var levelSections: Array[Array] = [[preload("res://Scenes/Combat Sections/section_0_1.tscn")],
[preload("res://Scenes/Combat Sections/section_0_1.tscn")],
[preload("res://Scenes/Combat Sections/section_1_0.tscn")],
[preload("res://Scenes/Combat Sections/section_2_0.tscn")]]
@export var sectionWidth: float = 30
@export var betweenSections: Array[PackedScene]

@export var currentLevel: Node3D
var instanceRef: Node3D

func _ready():
	%Camera.bounds = cameraBounds
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_2.tscn"))
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_3.tscn"))
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_4.tscn"))
	levelSections[0].append(load("res://Scenes/Combat Sections/section_0_5.tscn"))
	
	levelSections[1].append(load("res://Scenes/Combat Sections/section_0_2.tscn"))
	levelSections[1].append(load("res://Scenes/Combat Sections/section_0_3.tscn"))
	levelSections[1].append(load("res://Scenes/Combat Sections/section_0_4.tscn"))
	levelSections[1].append(load("res://Scenes/Combat Sections/section_0_5.tscn"))
	
	levelSections[2].append(load("res://Scenes/Combat Sections/section_1_1.tscn"))
	levelSections[2].append(load("res://Scenes/Combat Sections/section_1_2.tscn"))
	levelSections[2].append(load("res://Scenes/Combat Sections/section_1_3.tscn"))
	levelSections[2].append(load("res://Scenes/Combat Sections/section_0_1.tscn"))
	levelSections[2].append(load("res://Scenes/Combat Sections/section_0_4.tscn"))
	
	levelSections[3].append(load("res://Scenes/Combat Sections/section_2_1.tscn"))
	levelSections[3].append(load("res://Scenes/Combat Sections/section_2_2.tscn"))
	levelSections[3].append(load("res://Scenes/Combat Sections/section_2_3.tscn"))
	

func _process(_delta):
	$UI/CoinsLabel.text = "$ " + str(%Player.coinCount) + "/7"
	$UI/HealthLabel.text = str(%Player.health) + "/" + str(%Player.maxHealth) + " HP"
	for ii in len(%Player.donatedItems):
		$UI/Items.get_child(ii).get_child(0).visible = !%Player.donatedItems[ii]
	
	if(inToll):
		if(Input.is_action_just_pressed("Jump")):
			EndToll()

func ChooseSections(count: int) -> Array:
	var fullSet = range(count)
	while len(fullSet) != 3:
		fullSet.remove_at(randi_range(0, len(fullSet) -1))
	return fullSet


func _on_level_end_area_entered(_area):
	%Player.global_position = Vector3(-12, 0, 0)
	%Camera.TeleportToPlayer()
	RemoveCurrentArea()
	$UI/CoinsLabel.visible = betweenLevels
	if(betweenLevels):
		betweenLevels = false
		levelId += 1
		if(levelId >= len(levelSections)):
			get_tree().change_scene_to_file("res://Scenes/End Screens/win_screen_3.tscn")
			return
		MakeCombatArea()
		UpdateCameraBounds(0, sectionWidth * 3 - 15)
	else:
		betweenLevels = true
		MakeRestArea()
		%Player.Heal(1)
		UpdateCameraBounds(0, 0)
		print(currentLevel)

func RemoveCurrentArea():
	currentLevel.queue_free()

func MakeRestArea():
	currentLevel = betweenSections[levelId].instantiate()
	add_child(currentLevel)
	%LevelEnd.global_position.x = 15

func MakeCombatArea():
	currentLevel = Node3D.new()
	add_child(currentLevel)
	
	var buildSections = ChooseSections(len(levelSections[levelId]))
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

func StartToll():
	%Player.inCutscene = true
	$UI/TollUI.visible = true
	inToll = true
	if(%Player.coinCount >= 7):
		$UI/TollUI/Label2.text = "Press [Space] to pay."
	else:
		$UI/TollUI/Label2.text = "Collect at least $7. Press [Space] to go back."

func EndToll():
	if(%Player.coinCount >= 7):
		%Player.coinCount = 0
		get_tree().get_first_node_in_group("TollBooth").get_child(0).set_deferred("disabled", true)
	else:
		%Player.global_position.x -= 0.5
	%Player.inCutscene = false
	inToll = false
	$UI/TollUI.visible = false
