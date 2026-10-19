extends CharacterBody3D

@export var speed: float = 5.0
@export var rotation_speed: float = 0.15 

@onready var camera = $CameraFP
@onready var detector_objetos = $CameraFP/Detector

##gravedad
const gravity = 9.8 

var target_velocity: Vector3 = Vector3.ZERO
var rotation_x: float = 0.0
var rotation_y: float = 0.0

var tiempo_bob = 0.0
var intensidad_bob = 0.08
var frecuencia_bob = 12.0

var puede_moverse = true

func _ready():
	GameManager.juego_finalizado.connect(_on_juego_finalizado)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_juego_finalizado():
	puede_moverse = false

func _input(event):
	#vista del raton
	if event is InputEventMouseMotion and puede_moverse:
		#movimiento horizontal del ratón
		rotation.y -= deg_to_rad(event.relative.x * rotation_speed)
		
		#movimiento vertical del ratón
		rotation_x += event.relative.y * rotation_speed
		rotation_x = clamp(rotation_x, -90, 90) #limite
		
		camera.rotation.x = deg_to_rad(-rotation_x) #usa negativo para rotación correcta
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_interaction()

func handle_interaction():
	detector_objetos.force_raycast_update() #actualizacion del raycast
	
	if detector_objetos.is_colliding():
		var objeto_colisionado = detector_objetos.get_collider()
		
		if objeto_colisionado:
			print("Objeto Seleccionado:", objeto_colisionado.name)
			
			if objeto_colisionado.name == "Llave":
				interact_with_key(objeto_colisionado)
			elif objeto_colisionado.name == "Puerta":
				interact_with_door(objeto_colisionado)

func interact_with_key(key_node):
	print("¡Llave detectada! Agarrando...")
	GameManager.tiene_llave = true
	GameManager.enviar_mensaje("Has encontrado una llave!")
	key_node.queue_free()

func interact_with_door(door_node):
	print("¡Puerta detectada! Intentando abrir...")
	if GameManager.tiene_llave:
		print("Abriendo puerta")
		
		var nodo_puerta = door_node.get_parent().get_parent().get_parent()
		nodo_puerta.abrir_puerta()
	
	else:
		print("No tienes la llave")
		GameManager.enviar_mensaje("Te hace falta una llave!")

func _physics_process(delta):
	if not puede_moverse:
		return
	
	if not is_on_floor():
		target_velocity.y -= gravity * delta
		
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	else:
		#parar si no hay entrada
		target_velocity.x = move_toward(target_velocity.x, 0, speed)
		target_velocity.z = move_toward(target_velocity.z, 0, speed)
		
	velocity = target_velocity
	move_and_slide()
	
	if velocity.length() > 0.1 and is_on_floor():
		tiempo_bob += delta * frecuencia_bob
		var pos_camara = camera.position
		pos_camara.y = 0.5 + sin(tiempo_bob) * intensidad_bob #0.5 altura original
		camera.position = pos_camara
	else:
		#volver a la altura original cuando se detiene
		camera.position.y = lerp(camera.position.y, 0.5, delta * 10)
