extends Area2D

@onready var timer: Timer = $Timer

# Signal when a body enters the Area2D

func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	timer.start()


# Signal when the timer times out
func _on_timer_timeout() -> void:
	print("Reloading scene")
	get_tree().reload_current_scene()
