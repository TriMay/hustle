extends BaseObj

signal got_parried()

class_name BaseProjectile

export var immunity_susceptible = true
export var deletes_other_projectiles = true
export var fizzle_on_ceiling = false
export var movable = true
export var can_be_hit_by_melee = false
export var hit_cancel_on_hit = false
#export var can_be_hit_by_projectiles = false
export var projectile_immune = false
export var hitlag_modifier = "1.0"

var got_parried = false

var stopped = false

func _ready():
	state_variables.append_array(
		["got_parried", "immunity_susceptible", "deletes_other_projectiles", "fizzle_on_ceiling", "movable", "can_be_hit_by_melee", "hit_cancel_on_hit", "projectile_immune", "hitlag_modifier", "stopped"]
	)

func get_opponent():
	if creator:
		return creator.get_opponent()

func disable():
	sprite.hide()
	disabled = true
	for hitbox in get_active_hitboxes():
		hitbox.deactivate()
	stop_particles()

func on_got_parried():
	emit_signal("got_parried")

func _process(delta):
	if !disabled:
		update()

func on_hit_ceiling():
	if fizzle_on_ceiling:
		disable()

func hit_by(hitbox):
	if hitbox:
		if hitbox.throw:
			return
		hitlag_ticks = fixed.round(fixed.mul(hitlag_modifier, str(hitbox.victim_hitlag)))
		if objs_map.has(hitbox.host):
			var host = objs_map[hitbox.host]
			var host_hitlag_ticks = fixed.round(fixed.mul(hitlag_modifier, str(hitbox.hitlag_ticks)))
			if host.hitlag_ticks < host_hitlag_ticks:
				host.hitlag_ticks = host_hitlag_ticks
	.hit_by(hitbox)
