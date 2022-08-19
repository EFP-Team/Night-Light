/obj/item/vehicle_part/engine/xi7
	name = "XI7-MOONSTER's brand engine"

	// Note:
	xs = list(0, 1000, 1500, 2000, 3500, 5000,  6000, 6500)
	ys = list(0, 375,  550,  650,  775,  812.5, 750,  600)
	max_rpm = 6477

	mass = 88

/obj/item/vehicle_part/gearbox/xi7
	name = "XI7-MOONSTER's brand gearbox"
	mass = 12
	gears = list(
		"R"  = -6,
		"N"  = 0,
		"1" = 2.14,
		"2" = 0.967
	)
	topgear = 2.67
	efficiency = 0.98

/obj/manhattan/vehicle/motorcycle/zakatneba
	name = "XI7-MOONSTER"
	desc = "The neon fighter of night roads. It is an exclusive model, they do not produce them anymore. It is considered the benchmark for sports motorcycles. It shimmers with red and turquoise shades when riding. It is the stuff of legends."
	icon = 'icons/vehicles/custom/zakatneba.dmi'
	icon_state = "lights"
	overlay_icon_state = "overlay"

	weight = 680

	components = list(
		VC_FRONT_WHEEL = /obj/item/vehicle_part/wheel,
		VC_BACK_WHEEL = /obj/item/vehicle_part/wheel,
		VC_ENGINE = /obj/item/vehicle_part/engine/xi7,
		VC_GEARBOX = /obj/item/vehicle_part/gearbox/xi7,
		VC_CARDAN = /obj/item/vehicle_part/cardan
	)

	rider_xs = list(
		"east" = 0,
		"west" = 16,
		"north" = 8,
		"south" = 8
	)

	rider_ys = list(
		"east" = 5,
		"west" = 5,
		"north" = 12,
		"south" = 12
	)

	serial_number = "zakatneba"

/obj/manhattan/vehicle/motorcycle/zakatneba/get_braking_force()
	return 2000
