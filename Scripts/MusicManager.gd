extends Node3D

@export var sadMusic: AudioStream
@export var combatMusic: AudioStream
@export var strangerMusic: AudioStream

func PlaySad():
	$AudioStreamPlayer.stream = sadMusic
	$AudioStreamPlayer.play()

func PlayCombat():
	$AudioStreamPlayer.stream = combatMusic
	$AudioStreamPlayer.play()

func PlayStranger():
	$AudioStreamPlayer.stream = strangerMusic
	$AudioStreamPlayer.play()
