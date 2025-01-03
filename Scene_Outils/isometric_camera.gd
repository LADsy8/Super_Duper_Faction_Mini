extends Node3D

#camera_move
@export_range(0,100,1) var vitesse_camera:float = 20.0

#camera_zoom
var camera_zoom_direction:float = 0
@export_range(0,100,1) var camera_zoom_speed = 40.0
@export_range(0,100,1) var camera_zoom_min = 10.0
@export_range(0,100,1) var camera_zoom_max = 25.0
@export_range(0,2,1) var camera_zoom_speed_damp:float = 0.92

#Flags
var camera_peut_process:bool = true;
var camera_peut_bouge_base:bool = true;
var camera_peut_zoom:bool = true;

#Node
@onready var camera_Socket:Node3D = $SocketDeCamera
@onready var camera:Node3D = $SocketDeCamera/Camera3D


func _ready() -> void:
	pass 

func _process(delta:float) -> void:
	if !camera_peut_process:return;
	
	camera_fais_bouge_base(delta);
	camera_zoom_update(delta);
	
func _unhandled_input(event:InputEvent) -> void:
	#Camera zoom
	
	if event.is_action("camera_zoom_in"):
		camera_zoom_direction = -1
	elif event.is_action("camera_zoom_out"):
		camera_zoom_direction = 1
	
	
	#Bouge la base de la camera avec les flèche
func camera_fais_bouge_base(delta:float) -> void:
	if !camera_peut_bouge_base:return
	var velocity_direction:Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("camera_Avant"):		velocity_direction -= transform.basis.z
	if Input.is_action_pressed("camera_Arrière"):	 velocity_direction += transform.basis.z
	if Input.is_action_pressed("camera_Gauche"):	 velocity_direction -= transform.basis.x
	if Input.is_action_pressed("camera_Droite"):	 velocity_direction += transform.basis.x
	
	position += velocity_direction.normalized() * delta * vitesse_camera;
	
func camera_zoom_update(delta:float) -> void: 
	if !camera_peut_zoom:return 
	
	var new_zoom:float = clamp(camera.position.z + camera_zoom_speed * camera_zoom_direction * delta, camera_zoom_min, camera_zoom_max) 
	camera.position.z = new_zoom
	camera_zoom_direction *= camera_zoom_speed_damp
