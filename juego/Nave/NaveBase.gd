class_name NaveBase
extends RigidBody2D

## Enums
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}
#atributo export
export var hitpoints = 20.0
#variable
var estado_actual:int = ESTADO.SPAWN
#variable onready
onready var canion:canion = $canion
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX

#metodos
func _ready() -> void:
	controlador_estados(estado_actual)
	
## Metodos Custom
func controlador_estados(nuevo_estado:int) -> void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disable", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disable", false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disable", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disable", true)
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida", self, global_position,3)
			queue_free()
		_:
			printerr("error de estado")
			
			
func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)
	
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	
	impacto_sfx.play()
	
func _on_NaveBase_body_exited(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)
	
