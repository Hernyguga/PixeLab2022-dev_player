class_name EstacionBase
extends Node2D

##atributos export
export var hitpoints = 30.0
export var orbital:PackedScene = null
##Atributos onready
onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX
##Atributos
var esta_destruida:bool = false

##metodos
func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())

func elegir_animacion_aleatoria() ->String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() -1
	var indice_animacion_aleatoria:int = randi() % num_anim + 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_animacion_aleatoria]

##Metodos custom
func recibir_danio(danio:float)->void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		queue_free()
	
	impacto_sfx.play()

func destruir()->void:
	var posiciones_partes =[
		$Sprite/Sprite2.global_position,
		$Sprite/Sprite3.global_position,
		$Sprite/Sprite4.global_position,
		$Sprite/Sprite.global_position
		]
	Eventos.emit_signal("base_destruida", self, posiciones_partes)
	queue_free()

func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
	




func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + $PosicionesSpawn/Norte.global_position,
		self
		)
	Eventos.emit_signal("spawn_orbital", new_orbital)
	
