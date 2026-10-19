extends Node3D

@export var tiempo_apertura: float = 1.5
@export var angulo_apertura_grados: float = 30.0 

var esta_abierta: bool = false

func abrir_puerta():
	if esta_abierta:
		return
		
	esta_abierta = true
	
	var tween = create_tween()
	
	tween.tween_property(self, "rotation:y", deg_to_rad(angulo_apertura_grados), tiempo_apertura)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	## TRANS_SINE -> evita movimiento mecánico
	## EASE_IN_OUT -> el principio y el final de la animación es suave
	
	tween.tween_callback(func(): GameManager.completar_juego())
	
