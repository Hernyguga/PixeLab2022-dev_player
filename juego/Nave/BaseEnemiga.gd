class_name BaseEnemiga
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


func spawnear_orbital()->void:
	var pos_spawn:Vector2 = deteccion_cuadrante()
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + pos_spawn,
		self,
		$RutaEnemigo
		)
	Eventos.emit_signal("spawn_orbital", new_orbital)
	
	
func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuegos.get_player_actual()
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
			#entrad por derecha
			$RutaEnemigo.rotation_degrees = 180.0
			return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
			#entrad por izquierda
			$RutaEnemigo.rotation_degrees = 0.0
			return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		#entrad por abajo y arriba
		if sign(angulo_player) > 0:
				#por abajo
				$RutaEnemigo.rotation_degrees = 270.0
				return $PosicionesSpawn/Sur.position
				##por arriba
	return $PosicionesSpawn/Norte.position
	
	
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
	var posicion_partes =[
		$Sprite/Sprite2.global_position,
		$Sprite/Sprite3.global_position,
		$Sprite/Sprite4.global_position,
		$Sprite/Sprite.global_position
		]
	Eventos.emit_signal("base_destruida", self, posicion_partes)
	queue_free()

func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
	


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + $PosicionesSpawn/Norte.global_position,
		self,
		$RutaEnemigo
		)
	
	Eventos.emit_signal("spawn_orbital", new_orbital)
