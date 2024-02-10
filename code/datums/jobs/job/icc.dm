/datum/job/icc
	job_category = JOB_CAT_MARINE
	access = ALL_ANTAGONIST_ACCESS
	minimal_access = ALL_ANTAGONIST_ACCESS
	skills_type = /datum/skills/craftier
	faction = FACTION_ICC
	minimap_icon = "icc"

//Base job for normal gameplay ICC, not ERT.
/datum/job/icc/squad
	access = ALL_ANTAGONIST_ACCESS
	minimal_access = ALL_ANTAGONIST_ACCESS
	supervisors = "the acting squad leader"
	selection_color = "#ffeeee"
	exp_type_department = EXP_TYPE_MARINES

/datum/job/icc/squad/after_spawn(mob/living/carbon/C, mob/M, latejoin = FALSE)
	. = ..()
	C.hud_set_job(faction)
	if(!ishuman(C))
		return
	var/mob/living/carbon/human/human_spawn = C
	if(!(human_spawn.species.species_flags & ROBOTIC_LIMBS))
		human_spawn.set_nutrition(250)
	if(!human_spawn.assigned_squad)
		CRASH("after_spawn called for a marine without an assigned_squad")
	to_chat(M, {"\nYou have been assigned to: <b><font size=3 color=[human_spawn.assigned_squad.color]>[lowertext(human_spawn.assigned_squad.name)] squad</font></b>.
Make your way to the cafeteria for some post-cryosleep chow, and then get equipped in your squad's prep room."})

/datum/job/icc/squad/equip_spawning_squad(mob/living/carbon/human/new_character, datum/squad/assigned_squad, client/player)
	if(!assigned_squad)
		SSjob.JobDebug("Failed to put marine role in squad. Player: [player.key] Job: [title]")
		return
	assigned_squad.insert_into_squad(new_character)

// Guardsman
/datum/job/icc/squad/standard
	title = ICC_SQUAD_MARINE
	paygrade = "ICC_E1"
	comm_title = "Gdr"
	access = list(ACCESS_MARINE_PREP)
	minimal_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DROPSHIP)
	display_order = JOB_DISPLAY_ORDER_SQUAD_MARINE
	outfit = /datum/outfit/job/icc/squad/standard
	total_positions = -1
	job_flags = JOB_FLAG_LATEJOINABLE|JOB_FLAG_ROUNDSTARTJOINABLE|JOB_FLAG_ALLOWS_PREFS_GEAR|JOB_FLAG_PROVIDES_BANK_ACCOUNT|JOB_FLAG_ADDTOMANIFEST|JOB_FLAG_PROVIDES_SQUAD_HUD|JOB_FLAG_CAN_SEE_ORDERS
	jobworth = list(
//		/datum/job/xenomorph = LARVA_POINTS_REGULAR,
//		/datum/job/terragov/icc/corpsman = SMARTIE_POINTS_REGULAR,
//		/datum/job/terragov/icc/engineer = SMARTIE_POINTS_REGULAR,
	)
	html_description = {"
		<b>Difficulty</b>: Easy<br /><br />
		<b>You answer to the</b> acting Squad Leader<br /><br />
		<b>Unlock Requirement</b>: Starting Role<br /><br />
		<b>Gamemode Availability</b>: Breach <br /><br /><br />
		ICCGF Guardsmen make up the bread and butter of the coaltions fighting forces. They are fitted with the standard arsenal that the ICC offers, and they can take up a variety of roles, being a sniper, a pyrotechnician, a machinegunner, rifleman and more. They’re often high in numbers and divided into squads, but they’re the lowest ranking individuals, with a low degree of skill in anything but shooting and engineering, being rather poor at medical roles. Still, they are not limited to the arsenal they can take on the field to deal whatever threat that lurks against the coalition.
		<br /><br />
		<b>Duty</b>: Carry out orders made by your acting Squad Leader, deal with any threats that oppose the coalition.
	"}
	minimap_icon = "private"

/datum/job/terragov/squad/standard/after_spawn(mob/living/carbon/new_mob, mob/user, latejoin = FALSE)
	. = ..()
	if(!ishuman(new_mob))
		return
	var/mob/living/carbon/human/new_human = new_mob
	var/playtime_mins = user?.client?.get_exp(title)
	if(!playtime_mins || playtime_mins < 1 )
		return
	switch(playtime_mins)
		if(0 to 600) // starting
			new_human.wear_id.paygrade = "ICC_E1"
		if(601 to 6000) // 10hrs
			new_human.wear_id.paygrade = "ICC_E2"
		if(6001 to 18000) // 100 hrs
			new_human.wear_id.paygrade = "ICC_E3"
		if(18001 to 60000) // 300 hrs
			new_human.wear_id.paygrade = "ICC_E3E"
		if(60001 to INFINITY) // 1000 hrs
			new_human.wear_id.paygrade = "ICC_E8"

/datum/outfit/job/icc/squad/standard
	name = "ICC Standard"
	jobtype = /datum/job/icc/squad/standard

	id = /obj/item/card/id/dogtag/som
