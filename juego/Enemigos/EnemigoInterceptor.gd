class_name EnemigoInterceptor
extends EnemigoBase
##Enums
enum ESTADO_IA {IDLE, ATACANDOQ, ATACANDOP, PERSECUCION}

##atributos export

export var potencia_max:float = 800.0
##ATRIBUTOS
var esta_ia_actual:int = ESTADO_IA.IDLE
var potencia_actual:float = 0.0

##Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dir_player.normalized() * potencia_actual * state.get_step()
	linear_velocity.x = clamp(linear_velocity.x, -potencia_max, potencia_max)
	linear_velocity.y = clamp(linear_velocity.y, -potencia_max, potencia_max)


##Metodos custom
func controlador_estados_ia(nuevo_estado:int)-> void:
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canion.set_esta_disparando(false)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOQ:
			canion.set_esta_disparando(true)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOP:
			canion.set_esta_disparando(true)
			potencia_actual = potencia_max
		ESTADO_IA.PERSECUCION:
			canion.set_esta_disparando(false)
			potencia_actual = potencia_max
		_:
			printerr("error de estado")
	esta_ia_actual = nuevo_estado
	
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	
func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)
	
##Señales internas
func _on_AreaDisparo_body_entered(body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.ATACANDOP)

func _on_AreaDisparo_body_exited(body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.PERSECUCION)

func _on_AreaDetencion_body_entered(body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.ATACANDOQ)

func _on_AreaDetencion_body_exited(body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.ATACANDOP)


func _on_EnemigoInterceptor_body_entered(body: Node) -> void:
	if body is Player:
		body.destruir()
		destruir()

