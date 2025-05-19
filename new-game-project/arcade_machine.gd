extends Node3D

signal run_selected(machine_name: String)

@export var machine_name: String = "Default Game"
@onready var label = $Label3D

func _ready():
	label.text = machine_name

func interact():
	print("Run started!")
	GameManager.start_run()
	#print("Starting run for:", machine_name)
	#emit_signal("run_selected", machine_name)
