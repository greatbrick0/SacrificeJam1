extends Node2D

var prevAnim: String = ""

func PlayAnim(animName: String, repeat: bool):
	if(!repeat and prevAnim == animName):
		return
	if($AnimationPlayer.current_animation != animName or !$AnimationPlayer.is_playing()):
		$AnimationPlayer.play(animName)
		prevAnim = animName

func UpdateItems(items: Array[bool]):
	$Skeleton2D/Hip/Torso/BackArm/BackForearm/SpriteShield.visible = !items[2]
	
	$Skeleton2D/Hip/Torso/FrontArm/FrontForearm/SpriteDagger.visible = false
	$Skeleton2D/Hip/Torso/FrontArm/FrontForearm/SpriteSword.visible = false
	$Skeleton2D/Hip/Torso/FrontArm/FrontForearm/SpriteRock.visible = false
	if(items[0] and items[4]):
		$Skeleton2D/Hip/Torso/FrontArm/FrontForearm/SpriteRock.visible = true
	elif(!items[0]):
		$Skeleton2D/Hip/Torso/FrontArm/FrontForearm/SpriteDagger.visible = true
	else:
		$Skeleton2D/Hip/Torso/FrontArm/FrontForearm/SpriteRock.visible = true
