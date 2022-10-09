"""
GunManager keeps track of what guns you are currently holding, and allows you
to switch between them and shoot.
"""

extends Spatial


# Stores scenes of the guns this player currently has equipped, normally
# has three slots (primary, secondary, melee)
export(Array, PackedScene) var gun_scenes
var gun_scene_index = 0

# Reference to the currently active gun Node (not PackedScene).
var gun_active = null


func _ready():
	gun_active = gun_scenes[gun_scene_index].instance()
	add_child(gun_active)

func _input(_event):
	# Switch active gun between primary/secondary/melee
	var gun_scene_index_new = gun_scene_index
	
	if Input.is_action_just_pressed("select_gun_primary"):
		gun_scene_index_new = 0
	elif Input.is_action_just_pressed("select_gun_secondary"):
		gun_scene_index_new = 1
	elif Input.is_action_just_pressed("select_gun_melee"):
		gun_scene_index_new = 2
	elif Input.is_action_just_pressed("select_gun_next"):
		gun_scene_index_new += 1
	elif Input.is_action_just_pressed("select_gun_prev"):
		gun_scene_index_new -= 1
		
	if gun_scene_index_new != gun_scene_index:
		_switch_active_gun(gun_scene_index_new)


# Switches the active gun to the gun with the given index.
# If the index is out of bounds, it will wrap around (e.g. index = -1 means gun_scene_index = 2)
func _switch_active_gun(index):
	remove_child(get_child(0))
	gun_scene_index = index % len(gun_scenes)
	gun_active = gun_scenes[gun_scene_index].instance()
	add_child(gun_active)
	print_tree_pretty()
