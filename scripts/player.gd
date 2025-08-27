extends CharacterBody2D


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

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_body_entered(body: Node) -> void:
	print("Player entered the area!")
	if body.is_in_group("Player"):
		print("Player entered the area!")


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Player entered the area!")
	if body.is_in_group("enemyProjectile"):
		print("Player entered the area!")
