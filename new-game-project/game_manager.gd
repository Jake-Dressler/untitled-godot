extends Node

var player: Node3D  # Set this from your player scene
var hub_scene: Node = null  # Holds the hub instance
var run_world_scene := preload("res://run_world.tscn")
var current_run: Node = null

func start_run():
	# Remove hub scene
	if hub_scene:
		hub_scene.queue_free()
		hub_scene = null

	# Load and add run world
	current_run = run_world_scene.instantiate()
	get_tree().get_root().add_child(current_run)

	# Move player to spawn
	var spawn = current_run.get_node("PlayerSpawn")
	player.global_transform = spawn.global_transform
