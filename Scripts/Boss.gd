extends Node3D

var playerRef: Player
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
	items = playerRef.donatedItems
	$FinalBoss/AnimationPlayer.play("BossIdle")

func _process(delta):
	$"../HealthBar/ProgressBar".value = 100 * (health / maxHealth)
	$"../HealthBar/ProgressBar2".value = 100 * (health / maxHealth)
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

func TakeDamage(amount: int):
	Damage(amount)

func Damage(amount: int):
	health -= amount
	if(health <= 0):
		$FinalBoss/AnimationPlayer.play("BossDeath")

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "BossIdle"):
		cooling = false

func SpawnFireBall(offset: float):
	fireballRef = fireballObj.instantiate()
	get_parent().add_child(fireballRef)
	fireballRef.global_position = $SpawnPoint.global_position
	fireballRef.playerRef = playerRef
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
