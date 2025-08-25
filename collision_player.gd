extends CollisionShape2D
func _on_area_2d_body_entered(area: Area2D) -> void:
	if area.is_in_group("enemyProjectile"):
		print("Player entered the zone!")
