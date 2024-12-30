extends Area2D

signal hit


@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var velocity_vector := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity_vector = Input.get_vector("ts1l","ts1r","ts1u","ts1d")
	if velocity_vector.length() > 0:
		velocity_vector = velocity_vector.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity_vector * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity_vector.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_v = velocity_vector.x < 0
	elif velocity_vector.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity_vector.y > 0
	
	if Input.is_action_pressed("ta"):
		pass
	
func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	
