extends Node

# general constants
const DEFAULT_MASS: = 2.0
const DEFAULT_MAX_SPEED: = 200.0

# arrive_to constant
const DEFAULT_SLOWDOWN: = 300.0



# move to the specified target
static func follow(velocity: Vector2, global_pos: Vector2, target_pos: Vector2,
			max_speed: = DEFAULT_MAX_SPEED, mass: = DEFAULT_MASS) -> Vector2:
	var target_velocity: = (target_pos - global_pos).normalized() * max_speed
	var steering: = (target_velocity - velocity) / mass
	return velocity + steering


# move to the target, smoothly slow down at distance defined by slowdown
static func arrive_to(velocity: Vector2, global_pos: Vector2, target_pos: Vector2,
			max_speed: = DEFAULT_MAX_SPEED, slowdown: = DEFAULT_SLOWDOWN, mass: = DEFAULT_MASS) -> Vector2:
	var to_target: = global_pos.distance_to(target_pos)
	var target_velocity: = (target_pos - global_pos).normalized() * max_speed
	if to_target < slowdown:
		target_velocity *= (to_target / slowdown) * 0.8 + 0.2 #value is [0, 1]
	var steering: = (target_velocity - velocity) / mass
	return velocity + steering


# move where the target will be in t frames
static func pursuit(velocity: Vector2, global_pos: Vector2, target_pos: Vector2,
			target_velo: Vector2, max_speed: = DEFAULT_MAX_SPEED, mass: = DEFAULT_MASS) -> Vector2:
	var t = global_pos.distance_to(target_pos) / max_speed
	target_pos += target_velo * t
	return follow(velocity, global_pos, target_pos, max_speed, mass)
