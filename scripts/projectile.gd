extends Area2D

class_name Projectile

@export var speed = 100
@export var damage = 10
@export var lifetime = 5

# Projectile only "spawn" from enemies, but may transition into
# a player projectile if parried
@export_flags_2d_physics var on_player_parry_layer
@export_flags_2d_physics var on_player_parry_mask

var dir: Vector2
var startPos: Vector2
var startRot: float
var timer: Timer
var is_in_player_damage_queue: bool = false

func _ready() -> void:
	global_position = startPos
	global_rotation = startRot
	timer = get_child(2)
	timer.start(lifetime)

func _physics_process(delta: float) -> void:
	position += dir * speed * delta;

func _on_body_entered(body: Node2D) -> void:
	# Check if what we hit is player, since we update the collision mask
	# we can assume collisions are always relevant i.e a player projectile
	# will never hit the player
	if body is Player:
		is_in_player_damage_queue = true
		body.registerHit(self)

func _on_timer_timeout() -> void:
	if is_in_player_damage_queue == false:
		queue_free()
