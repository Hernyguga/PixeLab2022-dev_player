class_name ExplosionMeteorito
extends Node

func _ready() -> void:
	$ExplosionM.play(elegir_explosion_aleatoria())
	
func elegir_explosion_aleatoria() -> String:
	randomize()
	var num_anim:int = $ExplosionM.get_animation_list().size() -1  
	var indice_anim_aleatoria:int = randi() % num_anim + 1
	var lista_animacion:Array = $ExplosionM.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]
	



func _on_ExplosionM_animation_finished(_anim_name: String) -> void:
	queue_free()
