extends Node3D

func _ready():
	iniciar_ciclo()
	
	for trampa in get_children():
		var nodo_tam = trampa.get_node_or_null("Root Scene/tam")
		
		if nodo_tam:
			var zona = nodo_tam.get_node_or_null("trampa")
			if zona and zona is Area3D: #area peligrosa
				zona.body_entered.connect(_on_pinchos_body_entered)
	
	
func iniciar_ciclo():
	var tween = create_tween().set_loops()
	
	tween.tween_property(self, "position:y", -1.3, 1.5).set_trans(Tween.TRANS_SINE)
	
	tween.tween_interval(1.0)
	
	tween.tween_property(self, "position:y", -0.75, 1.5).set_trans(Tween.TRANS_SINE)
	
	
func _on_pinchos_body_entered(body):
	if body.name == "Jugador":
		GameManager.take_damage()
