extends Area2D

signal hit

signal scored


func _on_body_entered(body: Node2D) -> void:
	print_debug('pipe hit!')
	hit.emit()


func _on_score_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print_debug('scored!')
	scored.emit()
