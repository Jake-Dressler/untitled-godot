extends Node3D

@export var width := 100
@export var depth := 100
@export var hScale := 2.0  # Height scale
@export var seed := 12345  # Optional for repeatable generation

@onready var terrain := $Terrain

func _ready():
	generate_terrain()

func generate_terrain():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var rng = RandomNumberGenerator.new()
	rng.seed = seed

	for z in range(depth - 1):
		for x in range(width - 1):
			var h0 = noise(x, z, rng)
			var h1 = noise(x + 1, z, rng)
			var h2 = noise(x, z + 1, rng)
			var h3 = noise(x + 1, z + 1, rng)

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

	var mesh = st.commit()
	$Terrain.mesh = mesh

func noise(x: float, z: float, rng: RandomNumberGenerator) -> float:
	return sin(x * 0.1 + rng.randf()) * cos(z * 0.1 + rng.randf())
