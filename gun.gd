extends Node2D

@onready var main = get_tree().get_root().get_node("Node2D");
## Bullet Scene/Prefab
@export var bullet_scene: PackedScene

##Distance between gun and muzzle
@export var muzzle_dist = 10

## If this gun is equipped by an enemy
@export var enemyGun: bool
## The target the enemy is shooting at
@export var target: Node2D
## The interval the enemy is shooting at
@export var interval: float = 0.6
## The speed of the bullet
@export var bullet_speed: float = 900.0

var _timer := 0.0

func _process(delta: float) -> void:
	if enemyGun:
		_timer += delta
		if _timer >= interval:
			_timer = 0.0
			shoot()
	elif Input.is_action_just_pressed("shoot"):
		shoot()
	
func shoot():
	var instance = bullet_scene.instantiate()
	var dir: Vector2 = ((target.global_position - global_position).normalized()) if target else (Vector2(1, 0).rotated(rotation))
	instance.dir = dir
	instance.startPos = global_position + dir * muzzle_dist
	instance.startRot = rotation
	instance.SPEED = bullet_speed
	main.add_child.call_deferred(instance)
