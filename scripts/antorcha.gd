extends OmniLight3D

@export var base_energy: float = 2.0 
@export var flicker_strength: float = 0.6 
@export var movement_scale: float = 0.05
@export var noise_frequency: float = 1

var initial_position: Vector3 
var noise: FastNoiseLite = FastNoiseLite.new()
var start_time: float = 0.0

func _ready():
	noise.seed = randi() #el movimiento de cada antorcha es distinto
	noise.frequency = noise_frequency
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH #evitamos cambios bruscos

	initial_position = position
	base_energy = light_energy
	start_time = Time.get_ticks_msec() / 1000.0

func _process(_delta):
	var current_time = (Time.get_ticks_msec() / 1000.0) - start_time
	
	var intensity_noise = noise.get_noise_1d(current_time * 15.0) * 0.5 + 0.5 
	light_energy = base_energy + (intensity_noise * flicker_strength)

	var pos_noise_x = noise.get_noise_1d(current_time * 10.0)
	var pos_noise_z = noise.get_noise_1d(current_time * 12.0)
	
	position = initial_position + Vector3(pos_noise_x * movement_scale, 0, pos_noise_z * movement_scale)

	var color_variation = sin(current_time * 3.0) * 0.05
	light_color = Color(1.0, 0.7 + color_variation, 0.1)
