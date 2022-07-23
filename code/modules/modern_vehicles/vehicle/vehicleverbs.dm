/obj/manhattan/vehicle/verb/upshift()
	set name = "Upshift"
	set category = "Vehicle"
	set src in view(1)
	var/obj/item/vehicle_part/gearbox/gearbox = components[VC_GEARBOX]
	gearbox.upshift()

/obj/manhattan/vehicle/verb/downshift()
	set name = "Downshift"
	set category = "Vehicle"
	set src in view(1)
	var/obj/item/vehicle_part/gearbox/gearbox = components[VC_GEARBOX]
	gearbox.downshift()

/obj/manhattan/vehicle/verb/toggle_headlights()
	set name = "Toggle Headlights"
	set category = "Vehicle"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user) || !(user in get_occupants_in_position("driver")))
		to_chat(user,"<span class = 'notice'>You must be the driver of [src] to toggle the headlights.</span>")
		return

/obj/manhattan/vehicle/verb/keys()
	set name = "Insert/Remove keys"
	set category = "Vehicle"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user) || !(user in get_occupants_in_position("driver")))
		to_chat(user,"<span class = 'notice'>You must be the driver of [src] to reach for the keys.</span>")
		return
	if(keys_in_ignition)
		to_chat(user,"<span class = 'notice'>You remove the keys from the ignition.</span>")
		keys_in_ignition = FALSE
	else
		to_chat(user,"<span class = 'notice'>You insert the keys into the ignition.</span>")
		keys_in_ignition = TRUE
	playsound(src, 'sound/vehicles/modern/vehicle_key.ogg', 150, 1)

/obj/manhattan/vehicle/verb/engine()
	set name = "Start/Stop engine"
	set category = "Vehicle"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user) || !(user in get_occupants_in_position("driver")))
		to_chat(user,"<span class = 'notice'>You must be the driver of [src] to reach for the ignition.</span>")
		return
	if(!keys_in_ignition)
		to_chat(user,"<span class = 'notice'>There are no keys in the ignition.</span>")
		return
	var/obj/item/vehicle_part/engine/engine = components[VC_ENGINE]
	if(!engine.needs_processing == TRUE)
		engine.start()
		to_chat(user,"<span class = 'notice'>You attempt to start the engine.</span>")
	else
		engine.stop()
		to_chat(user,"<span class = 'notice'>You stop the engine.</span>")

/obj/manhattan/vehicle/examine(var/mob/user)
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
	set name = "Inspect Components"
	set category = "Vehicle"
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

