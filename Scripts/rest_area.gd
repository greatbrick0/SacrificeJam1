extends Node3D

@export var anims: Array[String] = [""]
@export var dialogue: Array[String] = [""]
@export var speaking: Array[String] = ["P"]

var tracker: int = 0
var active: bool = false
var canContinue: bool = false

func _ready():
	Speak()
	$Dialogue.visible = false

func _process(delta):
	if(active):
		if(Input.is_action_just_pressed("Jump") and canContinue):
			tracker += 1
			if(tracker >= len(dialogue)):
				End()
			else:
				canContinue = false
				$Timer.start()
				Speak()

func _on_dialogue_point_area_entered(area):
	$DialoguePoint/CollisionShape3D.set_deferred("disabled", true)
	$Dialogue.visible = true
	get_tree().get_first_node_in_group("Player").inCutscene = true
	active = true
	$Timer.start()

func _on_timer_timeout():
	canContinue = true

func Speak():
	if(anims[tracker] != "" and anims[tracker] != null):
		$AnimationPlayer.play(anims[tracker])
	
	%YouPanel.get_child(1).text = dialogue[tracker]
	%StrangerPanel.get_child(1).text = dialogue[tracker]
	if(dialogue[tracker] == ""):
		ShowChoice()
	
	if(speaking[tracker] == "P"):
		%YouPanel.visible = true
		%StrangerPanel.visible = false
	elif(speaking[tracker] == "S"):
		%YouPanel.visible = false
		%StrangerPanel.visible = true
	elif(speaking[tracker] == "N"):
		%YouPanel.visible = false
		%StrangerPanel.visible = false

func ShowChoice():
	pass

func End():
	$Dialogue.visible = false
	get_tree().get_first_node_in_group("Player").inCutscene = false
