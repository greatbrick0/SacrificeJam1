extends Node3D

var playerRef: Player
var playerHealth: int
var items: Array[bool]
var tracker: int = 0
var cooling: bool = true
@export var maxHealth: int = 100
var health: int = 100

var fireballObj = preload("res://Scenes/boss_ball.tscn")
var fireballRef: Node3D
var playerDirection: Vector3

var visualAnims: Array[String] = ["BossAttack", "BossStompAttack", "BossFireAttack"]

func _on_damage_bound_area_entered(area):
	playerRef.TakeDamage(1)

func _ready():
	health = maxHealth
	playerRef = get_tree().get_first_node_in_group("Player")
	playerHealth = playerRef.health
	items = playerRef.donatedItems
	$"../RogueHolder/Rogue".visible = items[0]
	$FinalBoss/AnimationPlayer.play("BossIdle")

func _process(delta):
	if(playerHealth > playerRef.health):
		print("damage")
		if(!$"../SkeleHolder/SkeleAnim".is_playing() and items[2]):
			$"../SkeleHolder/SkeleAnim".play("Charge")
	playerHealth = playerRef.health
	
	$"../HealthBar/ProgressBar".value = health / float(maxHealth)
	$"../HealthBar/ProgressBar2".value = health / float(maxHealth)
	if(!$FinalBoss/AnimationPlayer.is_playing()):
		if(cooling):
			$FinalBoss/AnimationPlayer.play("BossIdle")
		else:
			tracker += 1
			if(tracker >= len(visualAnims)):
				tracker = 0
			$FinalBoss/AnimationPlayer.play(visualAnims[tracker])
			$FinalBoss/AttackPlayer.play(visualAnims[tracker])
			cooling = true
			if(visualAnims[tracker] == "BossFireAttack" and items[3]):
				$"../KidHolder/KidAnim".play("KidJump")

func TakeDamage(amount: int):
	if(items[0]):
		$"../RogueHolder/RogueAnim".play("RogueStab")
	Damage(amount)
	if(health < 24 and !$"../EdgeHolder/EdgeAnim".is_playing()):
		$"../EdgeHolder/EdgeAnim".play("AlphaStrike")
		$CollisionShape3D.set_deferred("disabled", true)

func Damage(amount: int):
	health -= amount
	print(health)
	$FinalBoss/BossHurt.play()
	if(health <= 0):
		$FinalBoss/AnimationPlayer.play("BossDeath")
		$FinalBoss/AttackPlayer.stop()
		$FinalBoss/BossDeath.play()

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "BossIdle"):
		cooling = false
	elif(anim_name == "BossDeath"):
		Win()

func SpawnFireBall(offset: float):
	fireballRef = fireballObj.instantiate()
	get_parent().add_child(fireballRef)
	fireballRef.global_position = $SpawnPoint.global_position
	fireballRef.playerRef = playerRef
	if(items[3]):
		playerDirection = -($SpawnPoint.global_position - ($"../KidHolder/Kid".global_position + Vector3(0, offset, 0))).normalized()
	else:
		playerDirection = -($SpawnPoint.global_position - (playerRef.global_position + Vector3(0, offset, 0))).normalized()
	fireballRef.direction = Vector3(playerDirection.x, playerDirection.y, 0)
	$FinalBoss/BossFire.play()

func _on_punch_area_area_entered(area):
	if(playerRef.blocking):
		playerRef.ParrySound()
		TakeDamage(2)
	else:
		playerRef.TakeDamage(1)

func NunHealPlayer():
	playerRef.Heal(5)

func _on_nun_timer_timeout():
	if(items[1]):
		$"../NunHolder/NunAnim".play("NunHeal")

func Win():
	var amountDonated: int = 0
	for ii in items:
		if(ii): amountDonated += 1
	
	if(amountDonated == 0):
		get_tree().change_scene_to_file("res://Scenes/End Screens/win_screen_2.tscn")
	elif(amountDonated == 5):
		get_tree().change_scene_to_file("res://Scenes/End Screens/win_screen_1.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/End Screens/win_screen_3.tscn")
