class_name ArrowNew
extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	
func change_target(is_target_player : bool):
	if is_target_player:
		$ProjectileHitbox.collision_layer = 32
		$ProjectileImpactDetector.collision_mask = 11
	else:
		$ProjectileHitbox.collision_layer = 16
		$ProjectileImpactDetector.collision_mask = 7
		
