class_name Player
extends NaveBase

export var potencia_motor:int = 5
export var potencia_rotacion:int = 80
export var estela_maxima:int = 150

var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

onready var laser:RayoLaser = $LaserBeam2D setget ,get_laser
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var escudo:Escudo = $Escudo setget ,get_escudo

##Metodos
func _ready() -> void:
	DatosJuegos.set_player_actual(self)
	controlador_estados(estado_actual)
	
func get_laser() -> RayoLaser:
	return laser
	
func get_escudo() -> Escudo:
	return escudo
func _unhandled_input(event: InputEvent) -> void:
	##disparo rayo
	if event.is_action_pressed("disparo_secundario"):
		laser.set_is_casting(true)
	
	if event.is_action_released("disparo_secundario"):
		laser.set_is_casting(false)
		
	## contorl Escudo
	if event.is_action_pressed("escudo"):
		escudo.activar()
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado():
		escudo.activar()
		
	#control estela y sonido motor
	if event.is_action_released("mover_adelante"):
		estela.set_max_points(estela_maxima)
		motor_sfx.sonido_on()
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
		motor_sfx.sonido_on()
	
	if (event.is_action_released("mover_adelante")
		or event.is_action_released("mover_atras")):
			motor_sfx.sonido_off()

func player_input() -> void:
	if not esta_input_activo():
		empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		 empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("mover_atras"):
		 empuje = Vector2(-potencia_motor, 0)
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_antihorario"):
		 dir_rotacion -= 1
	elif Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1
	
	#disparo
	if Input.is_action_just_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)
	
func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	
func esta_input_activo() -> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false 
		
	return true
	
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
			Eventos.emit_signal("nave_destruida", self, global_position, 3)
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
	
func _process(_delta: float) -> void:
	player_input()

##Señales internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)



func _on_body_exited(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()
		
