extends Node3D

var playerRef: Player
var items: Array[bool]
var tracker: int = 0
var cooling: bool = true
@export var health: int = 100

var visualAnims: Array[String] = ["BossAttack", "BossStompAttack", "BossFireAttack"]
func _on_damage_bound_area_entered(area):
	pass # Replace with function body.

func _ready():
	playerRef = get_tree().get_first_node_in_group("Player")
	items = playerRef.donatedItems
	$FinalBoss/AnimationPlayer.play("BossIdle")

func _process(delta):
	if(!$FinalBoss/AnimationPlayer.is_playing()):
		if(cooling):
			$FinalBoss/AnimationPlayer.play("BossIdle")
		else:
			tracker += 1
			if(tracker >= len(visualAnims)):
				tracker = 0
			$FinalBoss/AnimationPlayer.play(visualAnims[tracker])
			cooling = true

func TakeDamage(amount: int):
	health -= amount


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "BossIdle"):
		cooling = false
