extends KinematicBody2D

var speed = 1000
var selected = false
var path = []

var path_color = Color("#ffffff")

var distance = Vector2(100, 0)

onready var nav = get_parent().get_node("Navigation2D")
onready var tween = $Tween

func _ready():
	add_to_group("unit")


func _draw():
	if path.size() > 0:
		draw_line(Vector2(), (path[0] - position).rotated(-rotation), path_color)
		for i in path.size() - 1:
			draw_line(path[i] - position, (path[i + 1] - position).rotated(-rotation), path_color)


func _physics_process(delta):
	if path.size() > 0:
		var move = path[0] - global_position
		rotation = move.angle()
		if move.length() <= 10:
			path.remove(0)
		else:
			move_and_slide(move.normalized() * speed)


	update()


func move_to(target):
	path = nav.get_simple_path(global_position, target)


func select():
	selected = true
	$Selection.show()


func deselect():
	selected = false
	$Selection.hide()
