class_name SectorMeteorito
extends Node2D

export var cantidad_meteoritos:int = 5

export var intervalo_spawn:float = 1.2
onready var Advertencia:AnimationPlayer = $AnimationPlayer
onready var AdvertenciaSFX:AudioStreamPlayer = $AdvertenciaSFX

var spawners:Array

func _ready() -> void:
	$SpawnTimer.wait_time = intervalo_spawn 
	almacenar_spawners()
	conectar_seniales_detectores()
	
#metodo custom
func crear(pos:Vector2, meteoritos:int) ->void:
	global_position = pos
	cantidad_meteoritos = meteoritos

func conectar_seniales_detectores() -> void:
	for detector in $DetectorFueraZona.get_children():
		detector.connect("body_entered", self, "_on_detector_body_entered")
	
func almacenar_spawners() -> void:
		for spawner in $Spawners.get_children():
			spawners.append(spawner)
	
func spawner_aleatorio() -> int:
	randomize()
	return randi() % spawners.size()
	
##señales internas
func _on_SpawnTimer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$SpawnTimer.stop()
		return
	
	spawners[spawner_aleatorio()].spawnear_meteorito()
	
	
func _on_detector_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)
	

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	Advertencia.stop()
	AdvertenciaSFX.stop()
	
