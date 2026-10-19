extends FogVolume

func _process(delta):
	# Accedemos al material del volumen
	var mat = material as FogMaterial
	
	# Verificamos si tiene una textura de densidad asignada
	if mat and mat.density_texture:
		# Accedemos al ruido (Noise) dentro de la textura
		var noise = mat.density_texture.noise
		if noise:
			# Movemos el offset para simular movimiento de humo
			# El ruido suele tener una propiedad 'offset' (Vector3)
			noise.offset.x += delta * 0.5
			noise.offset.z += delta * 0.3
