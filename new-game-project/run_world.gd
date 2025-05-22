extends Node3D

@export var width := 100
@export var depth := 100
@export var h_scale := 3.0
@export var seed := 12345

@onready var mesh_instance: MeshInstance3D = $Terrain/MeshInstance3D
@onready var terrain_body: StaticBody3D = $Terrain
@onready var collision_shape: CollisionShape3D = $Terrain/CollisionShape3D

func _ready():
	var player = $Player  # Set this from your player scene
	var spawn = $PlayerSpawn
	player.global_position = spawn.global_position + Vector3.UP * 2
