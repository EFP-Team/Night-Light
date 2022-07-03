//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/datum/browser/panel

	var/selected_job = "Civilian"
	var/job_select_mode = "ALL"	// Options: All, Public or Private

	universal_speak = 1
	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

/mob/new_player/New()
	mob_list += src

/mob/new_player/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", whispering)
	if (client)
		client.ooc(message)

/mob/new_player/verb/new_player_panel()
	set src = usr

	new_player_panel_proc()

/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'>"
	output += "[using_map.get_map_info()]"
	output +="<hr>"

	output += "<a href='byond://?src=\ref[src];show_preferences=1'>Character Panel</A></p>"

	output +="<hr>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \]"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>Citizen's Roster</A><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A>"


	output += "<hr>Current character: <b>[client.prefs.real_name]</b>, [client.prefs.economic_status]<br>"
	output += "Money: <b>[cash2text( client.prefs.money_balance, FALSE, TRUE, TRUE )]</b><br>"
	if(SSbusiness)
		var/datum/business/B = get_business_by_owner_uid(client.prefs.unique_id)
		if(B)
			output += "Business Funds: <b>[cash2text( B.get_funds(), FALSE, TRUE, TRUE )]</b><br>"
	if(SSpersistent_options && SSpersistent_options.get_persistent_formatted_value("president_msg"))
		output += "<b>President Broadcast:</b><br>"
		output += "<div class='statusDisplay'>[SSpersistent_options.get_persistent_formatted_value("president_msg")]</div><br>"
	output += "</div>"

	if(news_data.city_newspaper && !client.seen_news)
		show_latest_news(news_data.city_newspaper)

	panel = new(src, "Welcome","Welcome, [client.prefs.real_name]", 600, 580, src)
	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()
	return


/mob/new_player/Stat()
	..()

	if(statpanel("Lobby") && ticker)
		if(ticker.hide_mode)
			stat("Game Mode:", "Secret")
		else
			if(ticker.hide_mode == 0)
				stat("Game Mode:", "[config.mode_names[master_mode]]") // Old setting for showing the game mode

		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Time To Start:", "[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in player_list)
				stat("[player.key]", (player.ready)?("(Playing)"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++


/mob/new_player/proc/JoinLate(selected_job_name, antag_type)
	//Prevents people rejoining as same character.
	for (var/mob/living/carbon/human/C in mob_list)
		var/char_name = client.prefs.real_name
		if(char_name == C.real_name)
			to_chat(usr, "<span class='notice'>There is a character that already exists with the same name - <b>[C.real_name]</b>, please join with a different one.</span>")
			return

	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return
	else if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
		to_chat(usr, "<span class='danger'>The city is currently exploding. Joining would go poorly.</span>")
		return

	if(!is_alien_whitelisted(src, all_species[client.prefs.species]))
		src << alert("You are currently not whitelisted to play [client.prefs.species].")
		return 0

	var/datum/species/S = all_species[client.prefs.species]
	if(!(S.spawn_flags & SPECIES_CAN_JOIN))
		src << alert("Your current species, [client.prefs.species], is not available for play on the city.")
		return 0
	if(client.prefs.location)
		AttemptLateSpawn(selected_job_name, client.prefs.location, antag_type)
	else
		AttemptLateSpawn(selected_job_name, client.prefs.spawnpoint, antag_type)

	return TRUE

/mob/new_player/Topic(href, href_list[])
	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.open_load_dialog(src)
		return 1

	if(href_list["ready"])
		ready = !ready
		new_player_panel_proc()

	if(href_list["refresh"])
		//src << browse(null, "window=playersetup") //closes the player setup window
		panel.close()
		new_player_panel_proc()

	if(href_list["late_join"])

		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr,"<font color='red'>The round is either not ready, or has already finished...</font>")
			return

		LateChoices()

	if(href_list["manifest"])
		ViewManifest()


	if(href_list["set_alt_title"])
		var/E = locate(href_list["job"])

		var/datum/job/job = E

		if(!client || !client.prefs || !job)
			return

		var/choices = list(job.title) + job.alt_titles
		var/new_title = input("Choose a title for [job.title].", "Choose Title", client.prefs.GetPlayerAltTitle(job)) as anything in choices|null

		// remove existing entry
		client.prefs.player_alt_titles -= job.title

		if(job.title != new_title)
			client.prefs.player_alt_titles[job.title] = new_title

		LateChoices()
		return

	if(href_list["SelectJob"])	//pre- SelectedJob usage for new menu
		var/E = href_list["SelectJob"]

		var/select_job = "[E]"

		selected_job = select_job
		LateChoices()
		return

	if(href_list["SelectDeptType"])	//pre- SelectedJob usage for new menu
		var/E = href_list["SelectDeptType"]
		var/new_dept = E

		job_select_mode = new_dept
		LateChoices()
		return

	if(href_list["SelectedJob"])
		JoinLate(href_list["SelectedJob"])

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

/mob/new_player/proc/handle_server_news()
	if(!client)
		return
	var/savefile/F = get_server_news()
	if(F)
		client.prefs.lastnews = md5(F["body"])
		client.prefs.save_preferences()

		var/dat = "<html><body><center>"
		dat += "<h1>[F["title"]]</h1>"
		dat += "<br>"
		dat += "[F["body"]]"
		dat += "<br>"
		dat += "<font size='2'><i>Last written by [F["author"]], on [F["timestamp"]].</i></font>"
		dat += "</center></body></html>"
		var/datum/browser/popup = new(src, "Server News", "Server News", 450, 300, src)
		popup.set_content(dat)
		popup.open()

/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = SSjobs.GetJob(rank)
	if(!job)	return 0
	if(!job.enabled) return 0
	if(!job.is_position_available()) return 0
	if(jobban_isbanned(src,rank))	return 0
	if(!is_hard_whitelisted(src, job)) return 0
	if(!job.player_old_enough(src.client))	return 0
	if(job.minimum_character_age && (client.prefs.age < job.minimum_character_age)) return 0
	if(job.title == "Prisoner" && client.prefs.criminal_status != "Incarcerated")	return 0
	if(job.title != "Prisoner" && client.prefs.criminal_status == "Incarcerated")	return 0
	if(job.clean_record_required && client.prefs.crime_record && !isemptylist(client.prefs.crime_record)) return 0
	if(!isemptylist(job.exclusive_employees) && !(client.prefs.unique_id in job.exclusive_employees)) return 0
	if(client.prefs.is_synth() && !job.allows_synths)
		return 0
	if(job.business)
		var/datum/business/biz = get_business_by_biz_uid(job.business)
		if(biz && biz.suspended) return 0

	return 1

/mob/new_player/proc/AttemptLateSpawn(rank, var/turf/spawning_at, antag_type)
	if (src != usr)
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "<font color='red'>The round is either not ready, or has already finished...</font>")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return 0
	if(!client)
		return 0

	var/is_prisoner
	if(rank == "Prisoner")
		is_prisoner = 1

	//Find our spawning point.
	var/turf/T
	var/list/join_props = SSjobs.LateSpawn(client, rank)
	if(spawning_at)
		T = spawning_at
	else
		T = join_props["turf"]
	var/join_message = join_props["msg"]

	if(!T || !join_message)
		return 0

	spawning = 1
	close_spawn_windows()

	SSjobs.AssignRole(src, rank, 1)

	var/mob/living/character = create_character(T)	//creates the human and transfers vars and mind
	character = SSjobs.EquipRank(character, rank, 1)					//equips the human
	UpdateFactionList(character)
	log_game("JOINED [key_name(character)] as \"[rank]\"")

	if(!is_prisoner)
		// Equip our custom items only AFTER deploying to spawn points eh? Also, not as a prisoner, since they can break out.
		equip_custom_items(character)

	// Moving wheelchair if they have one
	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	ticker.mode.latespawn(character)
	//matchmaker.do_matchmaking(character)

	if(character.mind.assigned_role != "Cyborg")

		var/already_joined

		for(var/datum/data/record/R in data_core.general)
			if(character.mind.prefs.unique_id == R.fields["unique_id"])
				already_joined = 1
				break

		if(!already_joined)
			data_core.manifest_inject(character)

		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

		//Grab some data from the character prefs for use in random news procs.
		if(!character.mind.prefs.silent_join)
			AnnounceArrival(character, rank, join_message)

	else
		if(!character.mind.prefs.silent_join)
			AnnounceCyborg(character, rank, join_message)


	//assign antag role, if any
	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		antag.add_antagonist(character.mind,1,0,1)


	qdel(src)

/mob/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message)
	if (ticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived to the city"].", "Arrivals Announcement Computer")


/mob/new_player/proc/create_character(var/turf/T)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_alien_whitelisted(chosen_species))
			new_character = new(T, use_species_name)

	if(!new_character)
		new_character = new(T)

	new_character.lastarea = get_area(T)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character, icon_updates = TRUE)

	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		if(mind.assigned_role == "Clown")				//give them a clownname if they are a clown
			new_character.real_name = pick(clown_names)	//I hate this being here of all places but unfortunately dna is based on real_name!
			new_character.rename_self("clown")
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()

	new_character.unique_id = client.prefs.unique_id

	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			if(is_lang_whitelisted(src,chosen_language) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)
	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_icons_body()
	new_character.update_eyes()

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<div align='center'>"
	dat += data_core.get_manifest(OOC = 1)

	//src << browse(dat, "window=manifest;size=370x420;can_close=1")
	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=News") //closes news window
	src << browse(null, "window=joinasantag") //closes news window
	//src << browse(null, "window=playersetup") //closes the player setup window
	panel.close()

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species)
		return SPECIES_HUMAN

	if(is_alien_whitelisted(chosen_species))
		return chosen_species.name

	return SPECIES_HUMAN

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.biological_gender

/mob/new_player/is_ready()
	return ready && ..()

// Prevents lobby players from seeing say, even with ghostears
/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

// Prevents lobby players from seeing emotes, even with ghosteyes
/mob/new_player/show_message(msg, type, alt, alt_type)
	return

/mob/new_player/hear_radio()
	return

/mob/new_player/MayRespawn()
	return 1
