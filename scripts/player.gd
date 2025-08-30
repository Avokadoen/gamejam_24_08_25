extends CharacterBody2D

class_name Player

@onready var audio_player = $Tumble

@onready var anim_player = $AnimatedSprite2D

@export var speed = 600.0
@export var jump_velocity = -300.0

@export var drag = 6000.0

@export var max_health: float = 100;
var health: float

# How long time does the player have to parry a projectile
@export var parry_window: float = 0.2
var damage_queue: Array


enum State {Jump_Start, Jump_Mid, Jump_Land, Run, Death}
var state = State.Run

func _init() -> void:
	health = max_health;

func _process(delta: float) -> void:
	update_state()

	for i in range(damage_queue.size() - 1, -1, -1):
		var damage = damage_queue[i]
		damage["parry_window"] -= delta
		# If we reached zero *last* frame
		if (damage["parry_window"] <= 0):
			takeDamage(damage["projectile"])
			damage_queue.remove_at(i)
			

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = Vector2(0,0)
	if state != State.Death:
		# Handle jump.
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = jump_velocity

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed

	if !direction:
		velocity.x = move_toward(velocity.x, 0, drag * delta)

	move_and_slide()


func update_state() -> void:
	match state:
		State.Jump_Start:
			if anim_player.is_playing() == false:
				anim_player.play("Jump_Mid")
				state = State.Jump_Mid
		State.Jump_Mid:
			if is_on_floor():
				anim_player.play("Jump_Land")
				state = State.Jump_Land
		State.Jump_Land:
			if anim_player.is_playing() == false:
				anim_player.play("Run")
				state = State.Run
		State.Run:
			if velocity.y < -0.01:
				anim_player.play("Jump_Start", 1.5)
				state = State.Jump_Start
			if velocity.y > 0.01:
				anim_player.play("Jump_Mid")
				state = State.Jump_Mid
		State.Death:
			if is_on_floor():
				if anim_player.animation != "Death":
					anim_player.play("Death")
					audio_player.play()


func takeDamage(projectile: Projectile) -> void:
	health -= projectile.damage
	if (health <= 0):
		state = State.Death

	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$Damage_Flash.start(0.1)

	projectile.queue_free()

func registerHit(projectile: Projectile) -> void:
	damage_queue.append({ "parry_window": parry_window, "projectile": projectile })

func _on_damage_flash_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
