/obj/manhattan/vehicle/verb/upshift()
	set name = "Повысить передачу"
	set category = "Транспорт"
	set src in view(1)

	if(!ishuman(usr) || !(usr in get_occupants_in_position("driver")))
		to_chat(usr, SPAN_NOTICE("You must be the driver of [src] to shift the gearbox."))
		return

	var/obj/item/vehicle_part/gearbox/gearbox = components[VC_GEARBOX]
	gearbox.upshift()

/client/proc/upshift()
	var/obj/manhattan/vehicle/V = mob?.loc
	if(!(V && istype(V)))
		return FALSE

	V.upshift()
	return TRUE

/client/proc/downshift()
	var/obj/manhattan/vehicle/V = mob?.loc
	if(!(V && istype(V)))
		return FALSE
	V.downshift()
	return TRUE

// God sorry please

/client/Northwest()
	if(!downshift())
		diagonal_action(NORTHWEST)

/obj/manhattan/vehicle/verb/downshift()
	set name = "Понизить передачу"
	set category = "Транспорт"
	set src in view(1)

	if(!ishuman(usr) || !(usr in get_occupants_in_position("driver")))
		to_chat(usr, SPAN_NOTICE("You must be the driver of [src] to shift the gearbox."))
		return

	var/obj/item/vehicle_part/gearbox/gearbox = components[VC_GEARBOX]
	gearbox.downshift()

/obj/manhattan/vehicle/verb/toggle_headlights()
	set name = "Переключить фары"
	set category = "Транспорт"
	set src in view(1)

	if(!ishuman(usr) || !(usr in get_occupants_in_position("driver")))
		to_chat(usr, SPAN_NOTICE("You must be the driver of [src] to toggle the headlights."))
		return

	if(!headlights_overlay)
		to_chat(usr, SPAN_NOTICE("This vehicle has no headlights."))
		return

	if(!headlights)
		headlights = TRUE
		set_light(6, 4)
	else
		headlights = FALSE
		set_light(0, 0)

/obj/manhattan/vehicle/verb/keys()
	set name = "Вставить/достать ключ"
	set category = "Транспорт"
	set src in view(1)
	var/mob/living/carbon/human/user = usr
	if(!istype(user) || !(user in get_occupants_in_position("driver")))
		to_chat(user, SPAN_NOTICE("You must be the driver of [src] to reach for the keys."))
		return
	if(inserted_key)
		if(user.put_in_hands(inserted_key))
			to_chat(user, SPAN_NOTICE("You remove the keys from the ignition."))
			inserted_key = null
		else
			inserted_key.forceMove(src)
			return
	else
		var/obj/item/weapon/key/car/key = user.get_active_hand()
		if(!istype(key))
			return
		if(key.key_data != serial_number)
			to_chat(user, SPAN_WARNING("The key doesn't fit!"))
			return

		to_chat(user, SPAN_NOTICE("You insert the keys into the ignition."))
		user.drop_from_inventory(key)
		inserted_key = key
		key.forceMove(src)
	playsound(src, 'sound/vehicles/modern/vehicle_key.ogg', 150, 1)

/obj/manhattan/vehicle/verb/engine()
	set name = "Зажигание"
	set category = "Транспорт"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user) || !(user in get_occupants_in_position("driver")))
		to_chat(user, SPAN_NOTICE("You must be the driver of [src] to reach for the ignition."))
		return
	if(!inserted_key)
		to_chat(user, SPAN_NOTICE("There are no keys in the ignition."))
		return
	var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]

	if(!engine)
		return

	if(engine.rpm < (RPM_IDLE - 300))
		engine.start()
		to_chat(user, SPAN_NOTICE("You attempt to start the engine."))
	else
		engine.stop()
		to_chat(user, SPAN_NOTICE("You stop the engine."))

/obj/manhattan/vehicle/examine(mob/user)
	. = ..()
	if(!active)
		to_chat(user,"[src]'s engine is inactive.")
	if(guns_disabled)
		to_chat(user,"[src]'s guns are damaged beyond use.")
	if(movement_destroyed)
		to_chat(user,"[src]'s movement is damaged beyond use.")
	if(cargo_capacity)
		if(!src.Adjacent(user))
			if(used_cargo_space > 0)
				to_chat(user,"<span>It looks like there is something in the cargo hold.</span>")
		else
			to_chat(user,"<span>It's cargo hold contains [used_cargo_space] of [cargo_capacity] units of cargo ([round(100*used_cargo_space/cargo_capacity)]% full).</span>")
	if(carried_vehicle)
		to_chat(user,"<span>It has a [carried_vehicle] mounted on it.</span>")

	show_occupants_contained(user)

	display_ammo_status(user)

/obj/manhattan/vehicle/verb/verb_inspect_components()
	set name = "Осмотреть детали"
	set category = "Транспорт"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	comp_prof.inspect_components(user)

/obj/manhattan/vehicle/proc/display_ammo_status(mob/user)
	for(var/m in ammo_containers)
		var/obj/item/ammo_magazine/mag = m
		var/msg = "is full!"
		if(mag.stored_ammo.len >= mag.initial_ammo * 0.75)
			msg = "is about 3 quarters full."
		else if(mag.stored_ammo.len > mag.initial_ammo * 0.5)
			msg = "is about half full."
		else if(mag.stored_ammo.len > mag.initial_ammo * 0.25)
			msg = "is about a quarter full."
		to_chat(user,"<span class = 'notice'>[src]'s [mag] [msg]</span>")

