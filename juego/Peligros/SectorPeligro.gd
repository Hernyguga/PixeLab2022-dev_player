class_name SectorDePeligro
extends Area2D

export (String, "vacio", "meteorito", "enemigo") var tipo_peligro
export var numero_peligros:int = 3


func _ready() -> void:
	pass # Replace with function body.

##señales
func _on_body_entered(body: Node) -> void:
	$CollisionShape2D.set_deferred("disable", true)
	yield(get_tree().create_timer(0.1), "timeout")
	enviar_senial()


func enviar_senial() ->void:
	Eventos.emit_signal(
		"nave_en_sector_peligro",
		$Position2D.global_position,
		tipo_peligro,
		numero_peligros
	)
	queue_free()
	
