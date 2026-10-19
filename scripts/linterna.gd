extends SpotLight3D

var is_on = false
var is_flickering = false
var flicker_count = 0 #contador para los parpadeos

#temporizador
var flicker_timer = Timer.new()

#rango de tiempo de un parpadeo individual
const MIN_FLICKER_TIME = 0.05
const MAX_FLICKER_TIME = 0.15

#rango de tiempo de espera
const MIN_WAIT_TIME = 4
const MAX_WAIT_TIME = 15

#rango aleatorio de cuántos parpadeos
const MIN_FLICKER_SEQUENCE_COUNT = 3
const MAX_FLICKER_SEQUENCE_COUNT = 8
var max_flicker_count = 0

func _ready():
	visible = is_on
	
	flicker_timer.one_shot = true
	flicker_timer.autostart = false
	
	flicker_timer.timeout.connect(_on_flicker_timer_timeout) #conexion con el temporizador 
	add_child(flicker_timer)
	
	randomize()

func _input(event):
	if event.is_action_pressed("linterna"):
		toggle_light()

func toggle_light():
	is_on = not is_on
	visible = is_on
	
	if is_on:
		start_wait_cycle()
	else:
		stop_flickering()

func start_wait_cycle():
	visible = true
	is_flickering = false
	
	var wait_time = randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)
	flicker_timer.wait_time = wait_time
	flicker_timer.start()

func _on_flicker_timer_timeout():
	if not is_on:
		return
		
	if not is_flickering:
		start_flicker_sequence()
	else:
		process_flicker_step()

func start_flicker_sequence():
	is_flickering = true
	flicker_count = 0
	
	max_flicker_count = int(randf_range(MIN_FLICKER_SEQUENCE_COUNT, MAX_FLICKER_SEQUENCE_COUNT))
	
	process_flicker_step()

func process_flicker_step():
	flicker_count += 1
	
	if flicker_count <= max_flicker_count:
		visible = not visible
		
		var flicker_time = randf_range(MIN_FLICKER_TIME, MAX_FLICKER_TIME)
		flicker_timer.wait_time = flicker_time
		flicker_timer.start()
	else:
		start_wait_cycle()

func stop_flickering():
	flicker_timer.stop()
	is_flickering = false
	flicker_count = 0
	visible = is_on
