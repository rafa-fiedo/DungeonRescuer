extends KinematicBody2D

onready var fireball = load("res://scenes/spells/Fireball.tscn")

enum Spell {HOLY, FIRE}

var speed = Vector2(48, 48)
var velocity = Vector2(0, 0)

var offset_weapon_point = Vector2.ZERO
var spell_effect_vec = Vector2.ZERO

var spell_power = 0
var start_fire_light_size = 0
var current_spell = Spell.HOLY

func _ready():
	offset_weapon_point = $Weapon.offset
	start_fire_light_size = $Weapon/FireLight.texture_scale

func _physics_process(delta):
	set_sprites() # set marker, char sprite and collision boxes
	
	var direction = get_direction()
	velocity = speed * direction
	
	spells_logic()
	$Character.set_moving_animation(velocity)
	move_and_slide(velocity)
	
func get_direction():
	return Vector2(
		Input.get_action_strength("game_right") - Input.get_action_strength("game_left"),
		Input.get_action_strength("game_down") - Input.get_action_strength("game_up")
	)

func spells_logic():
	
	if Input.is_action_pressed("use_spell_1"):
		spell_power = min(spell_power + 0.015, 1.0)
		$Weapon/FireLight.texture_scale = start_fire_light_size * (1.0 - (spell_power / 2.0))
	elif Input.is_action_just_released("use_spell_1"):
		create_spell_1(spell_power)
		spell_power = 0
		$Weapon/FireLight.texture_scale = start_fire_light_size * (1.0 - (spell_power / 2.0))
	if spell_power != 0:
		return

	if Input.is_action_just_pressed("spell_1"):
		if $Weapon/HolyLight.visible:
			return
		current_spell = Spell.HOLY
		turn_off_all_spells()
		$Weapon/HolyEffect.restart()
		$Weapon/HolyEffect.emitting = true
		$Weapon/HolyEffect.visible = true
		$Weapon/HolyLight.visible = true
	elif Input.is_action_just_pressed("spell_2"):
		if $Weapon/FireEffect.visible:
			return
		turn_off_all_spells()
		current_spell = Spell.FIRE
		# $Weapon/FireEffect.restart()
		$Weapon/FireEffect.emitting = true
		$Weapon/FireEffect.visible = true
		$Weapon/FireLight.visible = true
		
func turn_off_all_spells():
		$Weapon/HolyEffect.emitting = false
		$Weapon/HolyEffect.visible = false
		$Weapon/FireEffect.emitting = false
		$Weapon/FireEffect.visible = false

		$Weapon/FireLight.visible = false
		$Weapon/HolyLight.visible = false

func create_spell_1(spell_power_percent):
	match current_spell:
		Spell.HOLY:
			return
		Spell.FIRE:
			var spell = fireball.instance()
			spell.global_position = $Weapon/FireLight.global_position
			spell.power = spell_power_percent
			spell.rotation = $Weapon.rotation
			get_parent().add_child(spell)
	

func set_sprites():
	var mouse_p = get_viewport().get_mouse_position()
	
	var weapon_angle = ($".".position + offset_weapon_point).angle_to_point(mouse_p)
	
	$Weapon.rotation = weapon_angle - deg2rad(90)
	# $SpellEffect.position = offset_weapon_point + spell_effect_vec.rotated(weapon_angle - deg2rad(90))
	
	if mouse_p.x > $".".position.x:
		$Character.get_node("Sprite").flip_h = false
		$CollisionShape2D.position.x = 1
	else:
		$Character.get_node("Sprite").flip_h = true
		$CollisionShape2D.position.x = -1

