extends Node

@export var bat_scene: PackedScene
@export var dwarf_scene: PackedScene

var starting_nodes: int
var current_nodes: int

func _ready():
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	spawn_enemies()
	
	
	#position_to_next_wave()

func spawn_enemies():
	if current_nodes == starting_nodes:
		var mob_wait_time : float = 2.0
		spawn_type("bats", mob_wait_time)



func spawn_type(type, mob_wait_time):
	if type == "bats" :
		var bat_spawn1 = $BatSpawnPoint_01
		var bat_spawn2 = $BatSpawnPoint_02
		var bat_spawn3 = $BatSpawnPoint_03
		var bat_spawn4 = $BatSpawnPoint_04
		
		var bat1 = bat_scene.instantiate() 
		bat1.global_position = bat_spawn1.global_position
		var bat2 = bat_scene.instantiate() 
		bat2.global_position = bat_spawn2.global_position
		var bat3 = bat_scene.instantiate() 
		bat3.global_position = bat_spawn3.global_position
		var bat4 = bat_scene.instantiate() 
		bat4.global_position = bat_spawn4.global_position
		add_child(bat1)
		add_child(bat2)
		add_child(bat3)
		add_child(bat4)
		
		await get_tree().create_timer(mob_wait_time).timeout
	
	elif type == "dwarf":	
		var dwarf_spawn1 = $DwarfSpawnPoint_01
		var dwarf_spawn2 = $DwarfSpawnPoint_02
		var dwarf_spawn3 = $DwarfSpawnPoint_03
		var dwarf_spawn4 = $DwarfSpawnPoint_04
		
		var dwarf1 = dwarf_scene.instantiate() 
		dwarf1.global_position = dwarf_spawn1.global_position
		var dwarf2 = dwarf_scene.instantiate() 
		dwarf2.global_position = dwarf_spawn2.global_position
		var dwarf3 = dwarf_scene.instantiate() 
		dwarf3.global_position = dwarf_spawn3.global_position
		var dwarf4 = dwarf_scene.instantiate() 
		dwarf4.global_position = dwarf_spawn4.global_position
		add_child(dwarf1)
		add_child(dwarf2)
		add_child(dwarf3)
		add_child(dwarf4)
		
		
func _process(delta):
	current_nodes = get_child_count()
	if current_nodes == starting_nodes:
		print("ENEMIES ARE DEAD!!!")
		

#func position_to_next_wave():
	# als alle enemys dood zijn
	#if current_nodes == starting_nodes:
		#prepare_spawn("bats", 4.0, 4.0) #type aantal en aantal spawn plekken
	
#func prepare_spawn(type, multiplier, spawns)
	# mob_wait_time is tijd tussen de spawns 
	#var mob_wait_time : float = 2.0
	#spawn_type()
