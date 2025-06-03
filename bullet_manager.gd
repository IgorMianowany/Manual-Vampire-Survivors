class_name BulletManager
extends Node2D

@export var bullet_image : Texture2D
@export var marker_image : Texture2D
var shared_area
var bullets : Array[Bullet] = []
var counter = 20

func _ready() -> void:
	shared_area = $SharedArea
	bullet_image = bullet_image


# Register a new bullet in the array
func spawn_bullet(i_movement: Vector2, speed: float, origin : Vector2) -> void:
	origin = Vector2.ZERO
	# Create the bullet instance
	var bullet : Bullet = Bullet.new()
	bullet.movement_vector = i_movement
	bullet.speed = speed
	bullet.current_position = origin
	bullet.origin = origin
		
	# Configure its collision
	_configure_collision_for_bullet(bullet)
			
	# Register to the array
	bullets.append(bullet)

func _configure_collision_for_bullet(bullet: Bullet) -> void:
	
	# Step 1
	var used_transform := Transform2D(0, position)
	used_transform.origin = bullet.current_position
	  
	# Step 2
	var _circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape, 8)
  # Add the shape to the shared area
	PhysicsServer2D.area_add_shape(
	shared_area.get_rid(), _circle_shape, used_transform
	)
	
	# Step 3
	bullet.shape_id = _circle_shape
	
func _physics_process(delta: float) -> void:
	#counter -= 1
	#if counter <= 0:
		#for i in range(1,20):
			#spawn_bullet(global_position.direction_to(get_global_mouse_position()).rotated(i), 500, Vector2.ZERO)
		#counter = 20
	
	
	
	var used_transform = Transform2D()
	var bullets_queued_for_destruction = []
		
	for i in range(0, bullets.size()):
		# Calculate the new position
		var bullet = bullets[i] as Bullet   
		if bullet.lifetime > 5:
			bullets_queued_for_destruction.append(bullet)
			continue
		var offset : Vector2 = (
		bullet.movement_vector.normalized() * 
		bullet.speed * delta
		)
		
		# Move the Bullet
		bullet.current_position += offset
		used_transform.origin = bullet.current_position
		PhysicsServer2D.area_set_shape_transform(
		shared_area.get_rid(), i, used_transform
		)
				
		# Add the delta to the bullet's lifetime
		bullet.lifetime += delta
	for bullet in bullets_queued_for_destruction:
		PhysicsServer2D.free_rid(bullet.shape_id)
		bullets.erase(bullet)

	queue_redraw()
			
func _draw() -> void:
	var _offset = bullet_image.get_size() / 2.0
	for i in range(0, bullets.size()):
		var bullet = bullets[i]
		var sprite2d = Sprite2D.new()
		sprite2d.texture = bullet_image

		draw_texture(
		sprite2d.texture,
		bullet.current_position
		)
