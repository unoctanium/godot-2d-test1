extends Node

@export var mob_scene: PackedScene
var score


# connect from Player, signal hit
func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$UI.hide()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$UI.show()
	$Music.play()

# connect from ScoreTimer signal timeout
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

# connect from StartTimer signal timeout
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
#connect from MobTimer signal timeout
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	

func _ready():
	$UI.hide()
	#new_game()
	#pass