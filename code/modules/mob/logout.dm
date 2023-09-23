/mob/Logout()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_LOGOUT, src)
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	SStgui.on_logout(src)
	unset_machine()
	remove_all_indicators()
	if(interactee)
		unset_interaction()
	remove_typing_indicator()
	GLOB.player_list -= src
	log_message("[key_name(src)] has left mob [src]([type]).", LOG_OOC)
	if(s_active)
		s_active.hide_from(src)
	become_uncliented()
	return ..()
