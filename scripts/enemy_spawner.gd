extends Node

@export var bat_scene: PackedScene
@export var dwarf_scene: PackedScene

@onready var dwarf_spawn = $dwarf_spawn

var starting_nodes: int
var current_nodes: int

var first_wave = false
var second_wave = false



func _ready():
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	#spawn_enemies()
	
	
	#position_to_next_wave()

func spawn_enemies():
	if current_nodes == starting_nodes:
		#var mob_wait_time : float = 5.0
		spawn_type("bat")
		#spawn_type("dwarf")


func spawn_type(type):
	if type == "bat" :
		var bat_spawn1 = $BatSpawnPoint_1
		var bat_spawn2 = $BatSpawnPoint_2
		var bat_spawn3 = $BatSpawnPoint_3
		var bat_spawn4 = $BatSpawnPoint_4
		
		var bat1 = bat_scene.instantiate() 
		bat1.global_position = bat_spawn1.global_position
		var bat2 = bat_scene.instantiate() 
		bat2.global_position = bat_spawn2.global_position
		var bat3 = bat_scene.instantiate() 
		bat3.global_position = bat_spawn3.global_position
		var bat4 = bat_scene.instantiate() 
		bat4.global_position = bat_spawn4.global_position
		add_child(bat1)
		await get_tree().create_timer(3.0).timeout
		add_child(bat2)
		await get_tree().create_timer(3.0).timeout
		add_child(bat3)
		await get_tree().create_timer(3.0).timeout
		add_child(bat4)
		
		#await get_tree().create_timer(2.0).timeout
	
	elif type == "dwarf":	
		var dwarf_spawn1 = $DwarfSpawnPoint_1
		var dwarf_spawn2 = $DwarfSpawnPoint_2
		var dwarf_spawn3 = $DwarfSpawnPoint_3
		var dwarf_spawn4 = $DwarfSpawnPoint_4
		
		var dwarf1 = dwarf_scene.instantiate() 
		dwarf1.global_position = dwarf_spawn1.global_position
		var dwarf2 = dwarf_scene.instantiate() 
		dwarf2.global_position = dwarf_spawn2.global_position
		var dwarf3 = dwarf_scene.instantiate() 
		dwarf3.global_position = dwarf_spawn3.global_position
		var dwarf4 = dwarf_scene.instantiate() 
		dwarf4.global_position = dwarf_spawn4.global_position
		add_child(dwarf1)
		await get_tree().create_timer(4.0).timeout
		add_child(dwarf2)
		await get_tree().create_timer(4.0).timeout
		add_child(dwarf3)
		await get_tree().create_timer(4.0).timeout
		add_child(dwarf4)
		
		
func _process(delta):
	if GameData.enemy_spawner:
		if not first_wave:
			spawn_type("bat")
			first_wave = true
		current_nodes = get_child_count()
		if current_nodes == starting_nodes:
			#print("BAT ENEMIES ARE DEAD!!!")
			if first_wave and not second_wave:	
				spawn_type("dwarf")
				second_wave = true
			current_nodes = get_child_count()
			if current_nodes == starting_nodes:
				#print("DWARF ENEMIES ARE DEAD!!!")
				GameData.platform_escape_blink = true
			
			#second_wave = true
			
	#elif first_wave and not second_wave:
		#spawn_type("dwarf")
		#current_nodes = get_child_count()
		#if current_nodes == starting_nodes:
			#print("DWARF ENEMIES ARE DEAD!!!")
			#second_wave = true
	
	
	
	
	#current_nodes = get_child_count()
	#if current_nodes == starting_nodes:
		#print("ENEMIES ARE DEAD!!!")
		

#func position_to_next_wave():
	# als alle enemys dood zijn
	#if current_nodes == starting_nodes:
		#prepare_spawn("bats", 4.0, 4.0) #type aantal en aantal spawn plekken
	
#func prepare_spawn(type, multiplier, spawns)
	# mob_wait_time is tijd tussen de spawns 
	#var mob_wait_time : float = 2.0
	#spawn_type()
