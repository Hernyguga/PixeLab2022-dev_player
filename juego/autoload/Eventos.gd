
extends Node

signal disparo(proyectil)
signal nave_destruida(nave, posicion, explosiones)
signal spawn_meteorito(posicion, direccion, tamanio)
signal meteorito_destruido(posicion)
signal nave_en_sector_peligro(centro_camara, tipo_peligro, numero_peligros)
signal base_destruida(base, posicion)
signal spawn_orbital(orbital)



func _ready() -> void:
	pass # Replace with function body.

