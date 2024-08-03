/obj/item/vehicle_part/engine/taho
	name = "taho's brand engine"

	// Note:
	xs = list(0, 1000, 1500, 2000, 3000, 5000, 6500, 7100)
	ys = list(0, 80,   150,  200,  260,  300,  150,  120)
	max_rpm = 7150

	mass = 60

/obj/item/vehicle_part/gearbox/taho
	name = "taho's brand gearbox"
	mass = 44
	gears = list(
		"R"  = -2.929,
		"N"  = 0,
		"1" = 3.09,
		"2" = 2.438,
		"3" = 1.810,
		"4" = 1.458,
		"5" = 1.185,
		"6" = 0.967
	)
	topgear = 3.7
	efficiency = 0.9

/obj/item/vehicle_part/fueltank/taho
	capacity = 50

/obj/manhattan/vehicle/taho
	name = "taho"
	desc = "Brand new modification of the famous vehicle."

	icon = 'icons/vehicles/taho.dmi'
	icon_state = "taho"

	comp_prof = /datum/component_profile/taho

	light_color = "#f1ffe1"

	weight = 2200

	components = list(
		VC_RIGHT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_RIGHT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_LEFT_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine/taho,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox/taho,
		VC_CARDAN = /obj/item/vehicle_part/cardan,
		VC_FUELTANK = /obj/item/vehicle_part/fueltank/taho
	)

	aerodynamics_coefficent = 0.31
	traction_coefficent = 19.8

/obj/manhattan/vehicle/taho/get_transfer_case()
	return TRANSFER_CASE_AWD

/obj/manhattan/vehicle/taho/get_braking_force()
	return 2000

/obj/manhattan/vehicle/taho/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "43,71"
	else
		bounds = "97,41"
	bound_x = 8
	bound_y = 6

/obj/item/vehicle_component/health_manager/taho
	integrity = 100
	resistances = list("brute"=75,"burn"=70,"emp"=45,"bomb"=30)

/datum/component_profile/taho
	vital_components = newlist(/obj/item/vehicle_component/health_manager/taho)
