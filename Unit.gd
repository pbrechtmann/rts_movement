extends KinematicBody2D

var speed = 1000
var selected = false
var path = []

var path_color = Color("#ffffff")

var move = Vector2.ZERO

onready var nav = get_parent().get_node("Navigation2D")
onready var neighbor_area = $NeighborArea


func _ready():
	add_to_group("unit")


func _physics_process(delta):
	if path.size() > 0:
		move = path[0] - global_position
		rotation = move.angle()
		if move.length() <= 10:
			path.remove(0)
		else:
			var a = alignment()
			var c = cohesion()
			var s = separation()

			move += a + c + s
			move_and_slide(move.normalized() * speed)


func move_to(target):
	path = nav.get_simple_path(global_position, target)


func alignment():
	var alignement_vec = Vector2.ZERO
	var bodies = neighbor_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("unit"):
			alignement_vec += body.get_velocity()
	if bodies.size() == 0:
		return alignement_vec
	alignement_vec / bodies.size()
	return alignement_vec.normalized()


func cohesion():
	var cohesion_vec = Vector2.ZERO
	var bodies = neighbor_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("unit"):
			cohesion_vec += body.position
	if bodies.size() == 0:
		return cohesion_vec
	cohesion_vec / bodies.size()
	cohesion_vec -= position
	return cohesion_vec.normalized()


func separation():
	var separation_vec = Vector2.ZERO
	var bodies = neighbor_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("unit"):
			separation_vec.x += position.x - body.position.x
			separation_vec.y += position.y - body.position.y
	if bodies.size() == 0:
		return separation_vec
	separation_vec / bodies.size()
	separation_vec *= -1
	return separation_vec.normalized()


func get_velocity():
	return move


func select():
	selected = true
	$Selection.show()


func deselect():
	selected = false
	$Selection.hide()
