extends Area2D

func body_entered(body: Node) -> void:
	print("Player entered the area!")
	if body.is_in_group("Player"):
		print("Player entered the area!")
