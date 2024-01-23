@tool
extends Area2D
class_name Asteroid

var direction := Vector2.RIGHT

enum SIZE{
	SMALL,
	MEDIUM,
	BIG 
}

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var size : SIZE = SIZE.BIG:
	set(value):
		if value != size:
			size = value
			size_changed.emit()


@export  var speed = 200.0
@export var torque = 50.0

@export var asteroid_size_array : Array[AsteroidSize]

signal size_changed
signal destroyed


func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
		
	size_changed.connect(uptade_size)

	

func _physics_process(delta: float) -> void:
	var velocity = speed * direction * delta 
	global_position += velocity
	
	rotation_degrees += torque * delta

func uptade_size() -> void:
	if size >= asteroid_size_array.size() or size < 0:
		push_error("Problème")
	
	var asteroid_size = asteroid_size_array[size]

	sprite.texture = asteroid_size.texture
	collision_shape_2d.shape = asteroid_size.shape

func destroy() -> void:
	destroyed.emit()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.destroy() 
