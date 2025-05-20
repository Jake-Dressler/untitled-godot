extends Node3D

@export var width := 100
@export var depth := 100
@export var h_scale := 3.0
@export var seed := 12345

@onready var mesh_instance: MeshInstance3D = $Terrain/MeshInstance3D
@onready var terrain_body: StaticBody3D = $Terrain

signal terrain_ready

func _ready():
	generate_terrain()
	emit_signal("terrain_ready")
	#mat.albedo_color = Color(0.2, 0.8, 0.3)
	#$Terrain.material_override = mat

func generate_terrain():
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for z in range(depth - 1):
		for x in range(width - 1):
			var h0 = noise(x, z)
			var h1 = noise(x + 1, z)
			var h2 = noise(x, z + 1)
			var h3 = noise(x + 1, z + 1)

			var v0 = Vector3(x, h0, z)
			var v1 = Vector3(x + 1, h1, z)
			var v2 = Vector3(x, h2, z + 1)
			var v3 = Vector3(x + 1, h3, z + 1)

			# First triangle
			st.add_vertex(v0)
			st.add_vertex(v2)
			st.add_vertex(v1)

			# Second triangle
			st.add_vertex(v1)
			st.add_vertex(v2)
			st.add_vertex(v3)

	st.generate_normals()
	var mesh = st.commit()
	mesh_instance.mesh = mesh

	# Green material
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.8, 0.3)
	mesh_instance.material_override = mat

	# Collision
	var shape = ConcavePolygonShape3D.new()
	shape.set_faces(mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX])

	var collision = CollisionShape3D.new()
	collision.shape = shape
	terrain_body.add_child(collision)



func noise(x: int, z: int) -> float:
	var fx = float(x) * 0.1
	var fz = float(z) * 0.1
	return sin(fx) * cos(fz) * h_scale
