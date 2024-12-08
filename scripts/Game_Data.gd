extends Node

var gemstone = {}

var player_name: String
var score = 0

# Check of de player in gevechtsmodus moet gaan
var weapon_equip: bool
var bow_equip: bool


var playerBody: CharacterBody2D

var playerAlive: bool
var playerDamageZone: Area2D
var playerDamageAmount: int
var playerHitBox: Area2D

var batDamageZone: Area2D
var batDamageAmount: int

var is_bat_chase: bool
var is_dwarf_chase: bool

var dwarfDamageZone: Area2D
var dwarfDamageAmount: int

#var canon_can_shoot: bool
var canon_right_can_shoot: bool
var canon_left_can_shoot: bool
var canonDamageAmount: int

# arrow propperties
var arrowDamageZone: Area2D
var arrowDamageAmount: int

var enemy_spawner: bool

var platform_escape_blink: bool
var platform_escape_move: bool

var rock_is_falling: bool

