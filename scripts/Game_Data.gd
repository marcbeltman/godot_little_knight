extends Node

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

var canon_can_shoot: bool

