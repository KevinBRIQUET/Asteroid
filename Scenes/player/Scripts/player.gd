extends CharacterBody2D
class_name Player
@export_range(0.0, 1.0) var accel_factor : float = 0.1
@export_range(0.0, 1.0) var rotation_factor : float = 0.1
@export var projectile_scene : PackedScene
@export var max_speed : float = 200.0

var speed : float = 0.0



var direction := Vector2.ZERO
var last_direction := Vector2.ZERO

signal projectile_fired(projectile) 
signal destroyed

func _ready():
	pass
	
	
func _physics_process(delta):     
	move()                     # Deplacer le vaisseau
	rotate_toward_mouse()      # Rotation du vaisseau
	
func _input(event):
	direction = Input.get_vector("move_left", "move_right", "move_up","move_down")

	if direction != Vector2.ZERO:
		last_direction = direction
		
	if event.is_action_pressed("fire"):
		fire()

func fire() -> void:
	var  projectile =  projectile_scene.instantiate()
	
	projectile.transform = global_transform 

	projectile_fired.emit(projectile)
	


func move() -> void: 

	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)
	else:
		speed = lerp(speed, max_speed, accel_factor)		
		
	velocity = last_direction * speed  
	move_and_slide()


func rotate_toward_mouse() -> void:
	var mouse_pos = get_global_mouse_position()             
	var angle = global_position.angle_to_point(mouse_pos)   # La rotation du vaisseau par rapport au curseur
	rotation = lerp_angle(rotation, angle, rotation_factor)
	
func destroy() -> void:
	destroyed.emit()
	queue_free() 
	
	
	
