extends Node

signal juego_finalizado
signal jugador_danado
signal mostrar_mensaje_interfaz(texto)

#inventario
var tiene_llave = false

#vida
var vida: int = 3 #3 vidas
var max_vida: int = 3

func take_damage():
	vida -= 1
	emit_signal("jugador_danado")
	
	print("Salud restante: ", vida)
	if vida <= 0:
		reinicio()

func reinicio():
	print("Reiniciando nivel...")
	get_tree().call_deferred("reload_current_scene") #termina de calcular las fisicas de la colisión
	vida = max_vida
	tiene_llave = false

func enviar_mensaje(texto):
	emit_signal("mostrar_mensaje_interfaz", texto)

func completar_juego():
	emit_signal("juego_finalizado")
