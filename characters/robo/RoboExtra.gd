extends PlayerExtra

var current_dir = null

var jump_selected

func _ready():
	$"%FlyDir".connect("data_changed", self, "emit_signal", ["data_changed"])
	$"%FlyEnabled".connect("pressed", self, "emit_signal", ["data_changed"])
	$"%ArmorEnabled".connect("pressed", self, "emit_signal", ["data_changed"])
	$"%NadeActive".connect("pressed", self, "emit_signal", ["data_changed"])
	$"%PullEnabled".connect("pressed", self, "emit_signal", ["data_changed"])
	$"%PullEnabled".connect("pressed", $"%ArmorEnabled", "set_pressed_no_signal", [false])
	$"%ArmorEnabled".connect("pressed", $"%PullEnabled", "set_pressed_no_signal", [false])
	$"%DriveCancel".connect("pressed", self, "emit_signal", ["data_changed"])
	
func get_extra():
	current_dir = $"%FlyDir".get_dir()
	return {
		"fly_dir": $"%FlyDir".get_data() if visible else fighter.flying_dir,
		"fly_enabled": $"%FlyEnabled".pressed,
		"armor_enabled": $"%ArmorEnabled".pressed,
		"nade_activated": $"%NadeActive".pressed and $"%NadeActive".visible,
		"pull_enabled": $"%PullEnabled".pressed and $"%PullEnabled".visible,
		"drive_cancel": drive_pressed() if fighter.stance != "Drive" else !drive_pressed()
#		"force_fly": false
	}

func drive_pressed():
	return $"%DriveCancel".pressed and $"%DriveCancel".visible

func update_selected_move(move_state):
	.update_selected_move(move_state)
	$"%ArmorEnabled".disabled = false
	$"%FlyEnabled".disabled = false

	if move_state is CharacterState:
		if move_state.name != "Step" and (\
		move_state.type == CharacterState.ActionType.Defense \
		or move_state.type == CharacterState.ActionType.Movement):
			$"%ArmorEnabled".set_pressed_no_signal(false)
			$"%ArmorEnabled".disabled = true
#	if move_state is GroundedParryState:
#		$"%FlyEnabled".set_pressed_no_signal(false)
#		$"%FlyEnabled".disabled = true

		pass
#	if fighter.is_grounded():
#		$"%FlyDir".hide()
#		$"%FlyEnabled".hide()
#		if move_state and move_state.name == "Jump":
#			jump_selected = true
#			$"%FlyDir".show()
#			$"%FlyEnabled".show()
#		else:
#			$"%FlyEnabled".set_pressed_no_signal(false)

	if move_state:
		$"%DriveCancel".visible = false
		if move_state.get_host_command("try_drive_cancel"):
			$"%DriveCancel".visible = true

func show_options():
	$"%FlyDir".hide()
	$"%FlyEnabled".hide()
	$"%ArmorEnabled".hide()
	$"%NadeActive".hide()
	$"%PullEnabled".hide()
	$"%FlyDir".set_dir("Neutral")
	$"%FlyDir".facing = fighter.get_opponent_dir()
	$"%FlyDir".init()
	$"%DriveCancel".hide()
	if current_dir:
		$"%FlyDir".set_dir(current_dir)
#	$"%FlyEnabled".set_pressed_no_signal(false)
	var nade = fighter.obj_from_name(fighter.grenade_object)
	if nade:
		if !nade.active:
			$"%NadeActive".show()
	if fighter.magnet_installed:
		$"%PullEnabled".show()
	if fighter.is_grounded() and !jump_selected:
		$"%FlyDir".hide()
		$"%FlyEnabled".hide()
	else:
		if fighter.air_movements_left > 0:
			$"%FlyDir".show()
			$"%FlyEnabled".show()
			$"%FlyEnabled".set_pressed_no_signal(fighter.fly_ticks_left > 0)
	if fighter.armor_pips > 0:
		$"%ArmorEnabled".show()
#	if fighter.current_state().state_name == "WhiffInstantCancel":
#		$"%ArmorEnabled".hide()
	return

func reset():
	if fighter.flying_dir:
		$"%FlyDir".set_dir_from_data(fighter.flying_dir)
		$"%FlyEnabled".set_pressed_no_signal(true)
	else:
		$"%FlyEnabled".set_pressed_no_signal(false)
	$"%ArmorEnabled".set_pressed_no_signal(false)
	$"%NadeActive".set_pressed_no_signal(false)
	$"%PullEnabled".set_pressed_no_signal(false)
	$"%DriveCancel".set_pressed_no_signal(fighter.stance == "Drive")

func on_data_changed():
#	if $"%ArmorEnabled".pressed and $"%PullEnabled".pressed:
#		$"%PullEnabled".set_pressed_no_signal(false)
	pass
