extends RobotState

func _frame_0():
#	host.start_magnet_fx()
	host.magnet_installed = true
	host.start_hustle_fx()
#	host.armor_pips += 1
#	if host.armor_pips > host.MAX_ARMOR_PIPS:
#			host.armor_pips = host.MAX_ARMOR_PIPS

func is_usable():
	return !host.magnet_installed and .is_usable()
