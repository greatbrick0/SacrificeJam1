extends Node2D

var prevAnim: String = ""

func PlayAnim(animName: String, repeat: bool):
	if(!repeat and prevAnim == animName):
		return
	if($AnimationPlayer.current_animation != animName or !$AnimationPlayer.is_playing()):
		$AnimationPlayer.play(animName)
		prevAnim = animName
