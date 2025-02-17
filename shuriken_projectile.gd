class_name ShurikenProjectile
extends Projectile
#TODO zobaczyć czy to dobrze działa z hits/ max_hits
var life = 8
@onready var enemies_hit : Array[String] = []
signal hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit.connect(_on_projectile_death)
	$ProjectileHitbox.hitbox_name = "ShurikenHitbox"
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotation_degrees += 10
	super(delta)
	
func _on_projectile_death():
	life -= 1
	var enemies = $HomingRange.get_overlapping_bodies()
	var min_distance : float = 1000000
	var next_direction
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) < min_distance and global_position.distance_to(enemy.global_position) > 10 and not enemies_hit.has(enemy.name):
			next_direction = enemy
			min_distance = global_position.distance_to(enemy.global_position)
	if next_direction != null:
		enemies_hit.append(next_direction.name)
		direction = global_position.direction_to(next_direction.global_position)
	else:
		direction = direction.rotated(randf_range(180, 360))
	
	if life <= 0:
		super()
