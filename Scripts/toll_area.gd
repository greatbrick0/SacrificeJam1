extends Node3D

var playerRef: Player

func _ready():
	playerRef = get_tree().get_first_node_in_group("Player")


func _on_toll_point_area_entered(area):
	get_tree().get_first_node_in_group("Manager").StartToll()
