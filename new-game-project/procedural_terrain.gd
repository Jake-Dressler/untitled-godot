extends Node3D

@onready var terrain_mesh: MeshInstance3D = $StaticBody3D/Terrain

func _ready():
	print(terrain_mesh)
	print()
