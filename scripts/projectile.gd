extends Area2D

class_name Projectile

@export var SPEED = 100
@export var damage = 10

# Projectile only "spawn" from enemies, but may transition into
# a player projectile if parried
@export_flags_2d_physics var on_player_parry_layer
@export_flags_2d_physics var on_player_parry_mask

var dir : Vector2
var startPos : Vector2
var startRot : float

func _ready() -> void:
	global_position = startPos
	global_rotation = startRot

func _physics_process(delta: float) -> void:
	position += dir * SPEED * delta;

func _on_body_entered(body: Node2D) -> void:
	# Check if what we hit is player, since we update the collision mask
	# we can assume collisions are always relevant i.e a player projectile
	# will never hit the player
	if body is Player:
		body.takeDamage(damage)
	
