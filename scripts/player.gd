extends CharacterBody2D

class_name Player

@onready var anim_player = $AnimatedSprite2D

const SPEED = 600.0
const JUMP_VELOCITY = -300.0

@export var max_health: float = 100;
var health: float

func _init() -> void:
	health = max_health;
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim_player.play("Jump_Start")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()
	
func takeDamage(damage: float) -> void:
	health -= damage
	print("Player took ", damage, " damage")
	if (health <= 0):
		anim_player.play("Death")
		print("player is dead, long live the player")
