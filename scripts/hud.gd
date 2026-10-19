extends CanvasLayer

@onready var flash_rojo = $ColorRectDano
@onready var etiqueta_mensaje = $MensajeTexto
@onready var interfaz_victoria = $InterfazVictoria
@onready var boton_reiniciar = $InterfazVictoria/VBoxContainer/Boton_reiniciar
@onready var boton_cerrar = $InterfazVictoria/VBoxContainer/Boton_cerrar

func _ready():
	GameManager.jugador_danado.connect(_on_jugador_danado) #señal conectada al hacerse daño
	GameManager.mostrar_mensaje_interfaz.connect(mostrar_mensaje) #señal para los mensajes
	GameManager.juego_finalizado.connect(_on_victoria) #señal de reinicio
	
	boton_reiniciar.pressed.connect(_on_reiniciar_pulsado)
	boton_cerrar.pressed.connect(_on_cerrar_juego)
	
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(func(): mostrar_mensaje("Pulsa 'L' para activar la linterna"))
	
func _on_jugador_danado():
	var tween = create_tween()
	
	tween.tween_property(flash_rojo, "color:a", 0.2, 0.1) 
	tween.tween_property(flash_rojo, "color:a", 0.0, 0.5)
	
	
func mostrar_mensaje(texto: String):
	var tween = create_tween()
	
	etiqueta_mensaje.text = texto
	
	etiqueta_mensaje.modulate.a = 0.0
	
	var y_final = etiqueta_mensaje.position.y 
	var y_inicio = y_final + 20 
	
	etiqueta_mensaje.position.y = y_inicio
	
	tween.set_parallel(true) #lo siguiente se hace a la vez
	
	tween.tween_property(etiqueta_mensaje, "modulate:a", 1.0, 0.4)
	tween.tween_property(etiqueta_mensaje, "position:y", y_final, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	tween.set_parallel(false)
	tween.tween_interval(2.0) 
	
	tween.tween_property(etiqueta_mensaje, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(func(): 
		etiqueta_mensaje.text = ""
		etiqueta_mensaje.position.y = y_final
	)


func _on_victoria():
	interfaz_victoria.visible = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var tween = create_tween()
	tween.tween_property(interfaz_victoria, "modulate:a", 1.0, 1.0)


func _on_reiniciar_pulsado():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.reinicio()
	

func _on_cerrar_juego():
	get_tree().quit()
