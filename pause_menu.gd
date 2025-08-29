extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var viewport_size = get_viewport().get_visible_rect().size
	$Panel.position = viewport_size / 2 - $Panel.size / 2
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game():
	get_tree().paused = true
	visible = true

func resume_game():
	get_tree().paused = false
	visible = false

func _on_resume_pressed() -> void:
	resume_game()

func _on_quit_pressed() -> void:
	get_tree().quit()
