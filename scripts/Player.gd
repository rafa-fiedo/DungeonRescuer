extends KinematicBody2D

onready var fireball = load("res://scenes/spells/Fireball.tscn")

export(bool) var is_fire_use = false

signal fire_used

enum Spell {HOLY, FIRE}
enum State {MOVING, DEAD}

var speed = Vector2(48, 48)
var velocity = Vector2(0, 0)

var offset_weapon_point = Vector2.ZERO
var spell_effect_vec = Vector2.ZERO

var spell_power = 0
var start_fire_light_size = 0
var current_spell = Spell.HOLY
var state = State.MOVING
var spell_reload = false
var spell_casting = false # to pretend spelling after dialog box

var hit_points = 1

func _ready():
	offset_weapon_point = $Weapon.offset
	start_fire_light_size = $Weapon/FireLight.texture_scale
	set_sprites()
	
func _on_EnemyDetector_body_entered(body):
	var damage = body.attack()
	
	hit_points -= damage
	
	if hit_points <= 0:
		call_die()

func _physics_process(_delta):
	if state == State.DEAD:
		return
	set_sprites() # set marker, char sprite and collision boxes
	var direction = get_direction()
	velocity = speed * direction
	
	spells_logic()
	$Character.set_moving_animation(velocity)
	velocity = move_and_slide(velocity)
	
func get_direction():
	return Vector2(
		Input.get_action_strength("game_right") - Input.get_action_strength("game_left"),
		Input.get_action_strength("game_down") - Input.get_action_strength("game_up")
	)

func spells_logic():
	if spell_reload:
		return
	
	if Input.is_action_just_pressed("use_spell_1"):
		spell_casting = true
	
	if Input.is_action_pressed("use_spell_1") and spell_casting:
		spell_power = min(spell_power + 0.015, 1.0)
		$Weapon/FireLight.texture_scale = start_fire_light_size * (1.0 - (spell_power / 2.0))
	elif Input.is_action_just_released("use_spell_1") and spell_casting:
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
	elif Input.is_action_just_pressed("spell_2") and is_fire_use:
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
			spell_reload = true
			$SpellReloading.play("ReloadFire")
			emit_signal("fire_used")
	
	spell_casting = false
	

func set_sprites():
	var mouse_p = get_viewport().get_mouse_position()
	
	var screen_pos = get_global_transform_with_canvas().origin
	var weapon_angle = (screen_pos + offset_weapon_point).angle_to_point(mouse_p)
	
	$Weapon.rotation = weapon_angle - deg2rad(90)
	# $SpellEffect.position = offset_weapon_point + spell_effect_vec.rotated(weapon_angle - deg2rad(90))
	
	if mouse_p.x > screen_pos.x:
		$Character.get_node("Sprite").flip_h = false
		$CollisionShape2D.position.x = 1
	else:
		$Character.get_node("Sprite").flip_h = true
		$CollisionShape2D.position.x = -1
		
func set_active(active):
	set_physics_process(active)
	set_process(active)
	set_process_input(active)

func die():
	z_index = 0
	state = State.DEAD
	$Character.die_animation()
	$Weapon/AnimationPlayer.play("Die")
	yield($Character.find_node("Anim"), "animation_finished")
	# yield(get_tree().create_timer(1.0), "timeout")
	var err = get_tree().reload_current_scene()
	if err != OK:
		print(err)
		
func spell_reloaded():
	spell_reload = false

func call_die():
	call_deferred("die") 

func get_center():
	return global_position + Vector2(0, -4)

func get_save_data():
	return Global.PlayerData.new(
		global_position,
		is_fire_use
	)

func load_data(player_data : Global.PlayerData):
	global_position = player_data._position
	is_fire_use = player_data._spell_fire_avaliable


