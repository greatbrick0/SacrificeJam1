extends Node3D

@export var itemIndex: int = 0;

@export var Dialogue: Array[Speech] = [Speech.new()]
@export var DialogueL: Array[Speech] = [Speech.new()]
@export var DialogueR: Array[Speech] = [Speech.new()]

var tracker: int = 0
var active: bool = false
var canContinue: bool = false
var choicesVisible: bool = false

func _ready():
	Speak()
	$Dialogue.visible = false

func _process(delta):
	if(active):
		if(choicesVisible and canContinue):
			if(Input.is_action_just_pressed("MoveLeft")):
				_on_left_button_pressed()
			elif(Input.is_action_just_pressed("MoveRight")):
				_on_right_button_pressed()
		elif(Input.is_action_pressed("Jump") and canContinue):
			Progress()

func Progress():
	tracker += 1
	$Dialogue/Choices.visible = false
	if(tracker >= len(Dialogue)):
		End()
	else:
		canContinue = false
		$Timer.start()
		Speak()
		$AudioStreamPlayer.play()

func _on_dialogue_point_area_entered(area):
	$AudioStreamPlayer.play()
	$DialoguePoint/CollisionShape3D.set_deferred("disabled", true)
	$Dialogue.visible = true
	get_tree().get_first_node_in_group("Player").inCutscene = true
	active = true
	$Timer.start()

func _on_timer_timeout():
	canContinue = true

func Speak():
	if(Dialogue[tracker].anim != "" and Dialogue[tracker].anim != null):
		$AnimationPlayer.play(Dialogue[tracker].anim)
	
	%YouPanel.get_child(1).text = Dialogue[tracker].text
	%StrangerPanel.get_child(1).text = Dialogue[tracker].text
	
	choicesVisible = false
	if(Dialogue[tracker].text == ""):
		ShowChoice()
	
	if(Dialogue[tracker].speaker == "P"):
		%YouPanel.visible = true
		%StrangerPanel.visible = false
	elif(Dialogue[tracker].speaker == "S"):
		%YouPanel.visible = false
		%StrangerPanel.visible = true
	elif(Dialogue[tracker].speaker == "N"):
		%YouPanel.visible = false
		%StrangerPanel.visible = false

func ShowChoice():
	$Dialogue/Choices.visible = true
	choicesVisible = true

func End():
	$Dialogue.visible = false
	get_tree().get_first_node_in_group("Player").inCutscene = false

func _on_left_button_pressed():
	Dialogue.append_array(DialogueL)
	get_tree().get_first_node_in_group("Player").donatedItems[itemIndex] = true
	Progress()

func _on_right_button_pressed():
	Dialogue.append_array(DialogueR)
	Progress()
