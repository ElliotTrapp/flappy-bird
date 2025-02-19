extends Area2D

signal hit

func _on_body_entered(body: Node2D) -> void:
	print_debug('ground hit!')
	hit.emit()
