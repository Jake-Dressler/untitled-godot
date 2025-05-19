extends Node3D

func _ready():
	GameManager.player = $Player
	GameManager.hub_scene = self
	
	for machine in $Machines.get_children():
		machine.connect("run_selected", Callable(self, "_on_run_selected"))

func _on_run_selected():
	print("Run selected! Loading run...")
	# Replace with actual scene change logic later
