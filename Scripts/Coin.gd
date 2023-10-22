extends Node3D

func _on_collect_area_area_entered(area):
	get_tree().get_first_node_in_group("Player").coinCount += 1
