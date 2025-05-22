extends Node3D

@export var seed: int = 0
@export var size: int = 64
@export var s_scale: float = 4.0
@export var height_scale: float = 10.0

var rng: RandomNumberGenerator
var noise: FastNoiseLite

@onready var mesh_instance := $MeshInstance3D
@onready var static_body := $StaticBody3D
@onready var collision_shape := $StaticBody3D/CollisionShape3D

func _ready():
	generate_terrain()

func generate_terrain():
	rng = RandomNumberGenerator.new()
	rng.seed = seed
	
	noise = FastNoiseLite.new()
	noise.seed = seed
	noise.frequency = 0.05
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

	var mesh = ArrayMesh.new()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var vertices = []
	var indices = []

	# Generate vertices
	for x in range(size):
		for z in range(size):
			var y = noise.get_noise_2d(x, z) * height_scale
			var vertex = Vector3(x * s_scale, y, z * s_scale)
			vertices.append(vertex)
			st.add_vertex(vertex)

	# Generate indices
	for x in range(size - 1):
		for z in range(size - 1):
			var i = x * size + z
			var i_right = (x + 1) * size + z
			var i_top = x * size + (z + 1)
			var i_top_right = (x + 1) * size + (z + 1)

			indices.append_array([i, i_top, i_right])
			indices.append_array([i_right, i_top, i_top_right])

	# Add indices to the mesh
	for index in indices:
		st.add_index(index)

	# Commit the mesh to the MeshInstance3D
	st.generate_normals()
	mesh = st.commit()
	mesh_instance.mesh = mesh

	# Commit the mesh and assign it to MeshInstance3D
	st.generate_normals()
	mesh = st.commit()
	mesh_instance.mesh = mesh

	# Get vertices and indices from mesh
	var arrays = mesh.surface_get_arrays(0)
	var face_vertices = arrays[Mesh.ARRAY_VERTEX]
	var face_indices = arrays[Mesh.ARRAY_INDEX]

	if face_vertices.is_empty() or face_indices.is_empty():
		push_error("Mesh arrays are empty, can't generate collision!")
		return

	# Create face array for ConcavePolygonShape3D (triplets of triangle points)
	var faces = PackedVector3Array()
	for i in range(0, face_indices.size(), 3):
		var a = face_vertices[face_indices[i]]
		var b = face_vertices[face_indices[i + 1]]
		var c = face_vertices[face_indices[i + 2]]
		faces.append_array([a, b, c])

	# Create and assign the shape
	var shape = ConcavePolygonShape3D.new()
	shape.set_faces(faces)
	collision_shape.shape = shape
