extends Node2D

var cam_speed = 20
var selection_start
var mouse
var box = false
var selected_units = []

var sel_rect = RectangleShape2D.new()

var box_color = Color("#ffffff")

onready var click = $Click


func _process(delta):
	mouse = get_global_mouse_position()
	if Input.is_action_just_pressed("alt_command"):
		selection_start = mouse
	if Input.is_action_pressed("alt_command"):
		box = true
		pass
	if Input.is_action_just_released("alt_command"):
		box = false
		select_units()

	if Input.is_action_just_pressed("main_command"):
		var total = Vector2.ZERO
		for unit in selected_units:
			total += unit.position
		var center = total / selected_units.size()
		for unit in selected_units:
			var start_vec = unit.position - center
			unit.move_to(mouse + start_vec.normalized() * 100)

	var cam_move = Vector2.ZERO
	if Input.is_action_pressed("cam_down"):
		cam_move.y += 1
	if Input.is_action_pressed("cam_up"):
		cam_move.y -= 1
	if Input.is_action_pressed("cam_left"):
		cam_move.x -= 1
	if Input.is_action_pressed("cam_right"):
		cam_move.x += 1

	position += cam_move * cam_speed
	update()

func _draw():
	if box:
		draw_rect(Rect2(selection_start - position, mouse - selection_start), box_color, false)


func select_units():
	var new_units = []
	if mouse.distance_squared_to(selection_start) > 0.2:
		new_units = select_units_box(mouse)
	else:
		var u = select_unit_mouse()
		if u != null:
			new_units.append(u)
	for unit in selected_units:
		unit.deselect()
	if new_units.size() > 0:
		for unit in new_units:
			unit.select()
		selected_units = new_units


func select_units_box(drag_end):
	sel_rect.extents = (selection_start - drag_end) / 2
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(sel_rect)
	query.transform = Transform2D(0, (drag_end + selection_start) / 2)
	var unit = get_world_2d().get_direct_space_state().intersect_shape(query)
	var selection = []
	for u in unit:
		if u.get("collider").is_in_group("unit"):
			selection.append(u.get("collider"))
	return selection

func select_unit_mouse():
	var unit = get_world_2d().get_direct_space_state().intersect_point(mouse, 1)
	if not unit.empty():
		var u = unit[0].get("collider")
		if u.is_in_group("unit"):
			return u
	return null
