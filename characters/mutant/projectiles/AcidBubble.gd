extends BaseProjectile

const KNOCKBACK_MULTIPLIER = "2.0"

func hit_by(hitbox):
	.hit_by(hitbox)
	if objs_map.has(hitbox.host):
		var host = objs_map[hitbox.host]
		if host:
			if host.id == id:
				var f = fixed.normalized_vec_times(fixed.mul(hitbox.dir_x, str(host.get_facing_int())), hitbox.dir_y, fixed.mul(hitbox.knockback, KNOCKBACK_MULTIPLIER))
				apply_force(f.x, f.y)
			else:
				change_state("Pop")
