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
	
	current_run = run_world_scene.instantiate()
	
	current_run.connect("terrain_ready", func():
		var spawn = current_run.get_node("PlayerSpawn")
		player.global_position = spawn.global_position
		#current_run.add_child(player)  # or move it if already added elsewhere
		#print('child added')
)

	get_tree().get_root().add_child(current_run)
