/// ICC Crash
/datum/game_mode/infestation/crash/breach
	name = "Breach"
	config_tag = "Breach"
	votable = TRUE
	valid_job_types = list(
		/datum/job/icc/squad/standard = -1,
		/datum/job/xenomorph = FREE_XENO_AT_START
	)
	job_points_needed_by_job_type = list(
		/datum/job/xenomorph = CRASH_LARVA_POINTS_NEEDED,
	)
	xenorespawn_time = 3 MINUTES
	blacklist_ground_maps = list(MAP_BIG_RED, MAP_DELTA_STATION, MAP_PRISON_STATION, MAP_LV_624, MAP_WHISKEY_OUTPOST, MAP_OSCAR_OUTPOST, MAP_FORT_PHOBOS)
	starting_squad = "Anatole"


/datum/game_mode/infestation/crash/breach/set_valid_squads()
	SSjob.active_squads[FACTION_ICC] = list()
	for(var/key in SSjob.squads)
		var/datum/squad/squad = SSjob.squads[key]
		if(squad.faction == FACTION_ICC)
			SSjob.active_squads[squad.faction] += squad
	return TRUE
