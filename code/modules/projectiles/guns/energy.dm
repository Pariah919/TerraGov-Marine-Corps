
//-------------------------------------------------------
//ENERGY GUNS/ETC

/obj/item/weapon/gun/energy
	attachable_allowed = list()
	var/obj/item/cell/cell //1000 power.
	charge_cost = 10 //100 shots.
	var/cell_type = /obj/item/cell
	flags_gun_features = GUN_AMMO_COUNTER
	general_codex_key = "energy weapons"

/obj/item/weapon/gun/energy/examine_ammo_count(mob/user)
	var/list/dat = list()
	if(!(flags_gun_features & (GUN_INTERNAL_MAG|GUN_UNUSUAL_DESIGN))) //Internal mags and unusual guns have their own stuff set.
		var/current_shots = get_ammo_count()
		if(cell && current_shots > 0)
			if(flags_gun_features & GUN_AMMO_COUNTER)

				dat += "Ammo counter shows [current_shots] round\s remaining.<br>"
			else
				dat += "It's loaded[in_chamber?" and has a round chambered":""].<br>"
		else
			dat += "It's unloaded[in_chamber?" but has a round chambered":""].<br>"
	if(dat)
		to_chat(user, "[dat.Join(" ")]")

/obj/item/weapon/gun/energy/Initialize()
	. = ..()
	if(cell_type)
		cell = new cell_type(src)

/obj/item/weapon/gun/energy/able_to_fire(mob/living/user)
	. = ..()
	if(!cell || cell.charge - charge_cost < 0)
		return

/obj/item/weapon/gun/energy/load_into_chamber()
	if(!cell || cell.charge - charge_cost < 0)
		return

	cell.charge -= charge_cost
	in_chamber = create_bullet(ammo)
	return in_chamber

/obj/item/weapon/gun/energy/update_icon()
	return

/obj/item/weapon/gun/energy/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/energy/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		cell.charge = min(cell.charge + charge_cost, cell.maxcharge) //Safeguard against 'overcharging' the cell.
	return TRUE

/obj/item/weapon/gun/energy/emp_act(severity)
	cell.use(round(cell.maxcharge / severity))
	update_icon()
	return ..()

/obj/item/weapon/gun/energy/get_ammo_type()
	if(!ammo)
		return list("unknown", "unknown")
	else
		return list(ammo.hud_state, ammo.hud_state_empty)

/obj/item/weapon/gun/energy/get_ammo_count()
	if(!cell)
		return 0
	else
		return FLOOR(cell.charge / max(charge_cost, 1),1)

// energy guns, however, do not use gun rattles.
/obj/item/weapon/gun/energy/play_fire_sound(mob/user)
	if(active_attachable && active_attachable.flags_attach_features & ATTACH_PROJECTILE)
		if(active_attachable.fire_sound) //If we're firing from an attachment, use that noise instead.
			playsound(user, active_attachable.fire_sound, 50)
		return
	if(flags_gun_features & GUN_SILENCED)
		playsound(user, fire_sound, 25)
		return
	playsound(user, fire_sound, 60)


/obj/item/weapon/gun/energy/taser
	name = "taser gun"
	desc = "An advanced stun device capable of firing balls of ionized electricity. Used for nonlethal takedowns."
	icon_state = "taser"
	item_state = "taser"
	muzzle_flash = null //TO DO.
	fire_sound = 'sound/weapons/guns/fire/taser.ogg'
	ammo = /datum/ammo/energy/taser
	charge_cost = 500
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_AMMO_COUNTER|GUN_ALLOW_SYNTHETIC
	gun_skill_category = GUN_SKILL_PISTOLS
	movement_acc_penalty_mult = 0
	cell_type = /obj/item/cell/high

	fire_delay = 10
	accuracy_mult = 1.15
	scatter = 10
	scatter_unwielded = 15


/obj/item/weapon/gun/energy/taser/update_icon()
	if(!cell || cell.charge - charge_cost < 0)
		icon_state = base_gun_icon + "_e"
	else
		icon_state = base_gun_icon

/obj/item/weapon/gun/energy/taser/able_to_fire(mob/living/user)
	. = ..()
	if (.) //Let's check all that other stuff first.
		if(user.skills.getRating("police") < SKILL_POLICE_MP)
			to_chat(user, "<span class='warning'>You don't seem to know how to use [src]...</span>")
			return FALSE


//-------------------------------------------------------
//Lasguns

/obj/item/weapon/gun/energy/lasgun
	name = "\improper Lasgun"
	desc = "A laser based firearm. Uses power cells."
	reload_sound = 'sound/weapons/guns/interact/rifle_reload.ogg'
	fire_sound = 'sound/weapons/guns/fire/laser.ogg'
	load_method = CELL //codex
	ammo = /datum/ammo/energy/lasgun
	flags_equip_slot = ITEM_SLOT_BACK
	muzzleflash_iconstate = "muzzle_flash_laser"
	w_class = WEIGHT_CLASS_BULKY
	force = 15
	overcharge = FALSE
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ENERGY|GUN_AMMO_COUNTER
	aim_slowdown = 0.75
	wield_delay = 1 SECONDS
	gun_skill_category = GUN_SKILL_RIFLES
	muzzle_flash_color = COLOR_LASER_RED

	fire_delay = 3
	accuracy_mult = 1.5
	accuracy_mult_unwielded = 0.6
	scatter_unwielded = 80 //Heavy and unwieldy
	damage_falloff_mult = 0.5
	upper_akimbo_accuracy = 5
	lower_akimbo_accuracy = 3

/obj/item/weapon/gun/energy/lasgun/tesla
	name = "\improper M43-T tesla shock rifle"
	desc = "A prototype TGMC energy rifle that fires balls of elecricity that shock all those near them, it is meant to drain the plasma of unidentified creatures from within, limiting their abilities. Handle only with insulated clothing. Reloaded with power cells."
	icon_state = "m43"
	item_state = "m43"
	fire_sound = 'sound/weapons/guns/fire/tesla.ogg'
	ammo = /datum/ammo/energy/tesla
	cell_type = /obj/item/cell/lasgun/tesla
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_ENERGY|GUN_AMMO_COUNTER
	muzzle_flash_color = COLOR_TESLA_BLUE

	charge_cost = 500
	fire_delay = 4 SECONDS

//-------------------------------------------------------
//M43 Sunfury Lasgun MK1

/obj/item/weapon/gun/energy/lasgun/M43
	name = "\improper M43 Sunfury Lasgun MK1"
	desc = "An accurate, recoilless laser based battle rifle with an integrated charge selector. Ideal for longer range engagements. It was the standard lasrifle for TGMC soldiers until it was replaced by the TX-73, due to its extremely modular lens system."
	force = 20 //Large and hefty! Includes stock bonus.
	icon_state = "m43"
	item_state = "m43"
	max_shots = 50 //codex stuff
	load_method = CELL //codex stuff
	ammo = /datum/ammo/energy/lasgun/M43
	ammo_diff = null
	cell_type = /obj/item/cell/lasgun/M43
	charge_cost = ENERGY_STANDARD_AMMO_COST
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonetknife,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/scope,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/focuslens,
		/obj/item/attachable/widelens,
		/obj/item/attachable/heatlens,
		/obj/item/attachable/efflens,
		/obj/item/attachable/pulselens,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade, /obj/item/attachable/stock/lasgun)
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 15, "stock_x" = 22, "stock_y" = 12)

	accuracy_mult_unwielded = 0.5 //Heavy and unwieldy; you don't one hand this.
	scatter_unwielded = 100 //Heavy and unwieldy; you don't one hand this.
	damage_falloff_mult = 0.25
	fire_delay = 3

//variant without ugl attachment
/obj/item/weapon/gun/energy/lasgun/M43/stripped
	starting_attachment_types = list()

/obj/item/weapon/gun/energy/lasgun/M43/unique_action(mob/user)
	return toggle_chargemode(user)

/obj/item/weapon/gun/energy/lasgun/Initialize(mapload, ...)
	. = ..()
	update_icon()


//Toggles Overcharge mode. Overcharge mode significantly increases damage and AP in exchange for doubled ammo usage and increased fire delay.
/obj/item/weapon/gun/energy/lasgun/proc/toggle_chargemode(mob/user)
	//if(in_chamber)
	//	delete_bullet(in_chamber, TRUE)
	if(ammo_diff == null)
		to_chat(user, "[icon2html(src, user)] You need an appropriate lens to enable overcharge mode.")
		return
	if(overcharge == FALSE)
		if(!cell)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s overcharge mode but you have no battery loaded.</span>")
			return
		if(cell.charge < ENERGY_OVERCHARGE_AMMO_COST)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s overcharge mode but your battery pack lacks adequate charge to do so.</span>")
			return
		//While overcharge is active, double ammo consumption, and
		playsound(user, 'sound/weapons/emitter.ogg', 5, 0, 2)
		charge_cost = ENERGY_OVERCHARGE_AMMO_COST
		ammo = GLOB.ammo_list[ammo_diff]
		fire_delay += 7 // 1 shot per second fire rate
		fire_sound = 'sound/weapons/guns/fire/laser3.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s overcharge mode.")
		overcharge = TRUE
	else
		playsound(user, 'sound/weapons/emitter2.ogg', 5, 0, 2)
		charge_cost = ENERGY_STANDARD_AMMO_COST
		ammo = GLOB.ammo_list[/datum/ammo/energy/lasgun/M43]
		fire_delay -= 7
		fire_sound = 'sound/weapons/guns/fire/laser.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s overcharge mode.")
		overcharge = FALSE

	//load_into_chamber()

	if(user)
		var/obj/screen/ammo/A = user.hud_used.ammo //The ammo HUD
		A.update_hud(user)

	return TRUE

/obj/item/weapon/gun/energy/lasgun/load_into_chamber(mob/user)
		//Let's check on the active attachable. It loads ammo on the go, so it never chambers anything
	if(active_attachable && active_attachable.flags_attach_features & ATTACH_PROJECTILE)
		if(active_attachable.current_rounds > 0) //If it's still got ammo and stuff.
			active_attachable.current_rounds--
			return create_bullet(active_attachable.ammo)
		else
			to_chat(user, "<span class='warning'>[active_attachable] is empty!</span>")
			to_chat(user, "<span class='notice'>You disable [active_attachable].</span>")
			playsound(user, active_attachable.activation_sound, 15, 1)
			active_attachable.activate_attachment(null, TRUE)

	if(!cell?.use(charge_cost))
		return
	in_chamber = create_bullet(ammo)
	update_icon(user)
	return in_chamber

/obj/item/weapon/gun/energy/lasgun/reload_into_chamber(mob/user)
	/*
	ATTACHMENT POST PROCESSING
	This should only apply to the masterkey, since it's the only attachment that shoots through Fire()
	instead of its own thing through fire_attachment(). If any other bullet attachments are added, they would fire here.
	*/
	if(active_attachable && active_attachable.flags_attach_features & ATTACH_PROJECTILE)
		make_casing(active_attachable.type_of_casings) // Attachables can drop their own casings.

	if(!active_attachable && cell) //We don't need to check for the mag if an attachment was used to shoot.
		if(cell) //If there is no mag, we can't reload.
			if(overcharge && cell.charge < ENERGY_OVERCHARGE_AMMO_COST && cell.charge >= ENERGY_STANDARD_AMMO_COST) //Revert to standard shot if we don't have enough juice for overcharge, but enough for the standard mode
				toggle_chargemode(user)
				return
			if(cell.charge <= 0 && flags_gun_features & GUN_AUTO_EJECTOR) // This is where the magazine is auto-ejected.
				unload(user,1,1) // We want to quickly autoeject the magazine. This proc does the rest based on magazine type. User can be passed as null.
				playsound(src, empty_sound, 25, 1)

	return TRUE


//Ammo/Charge functions
/obj/item/weapon/gun/energy/lasgun/update_icon(mob/user)
	var/cell_charge = (!cell || cell.charge <= 0) ? 0 : CEILING((cell.charge / max(cell.maxcharge, 1)) * 100, 25)
	icon_state = "[base_gun_icon]_[cell_charge]"
	update_mag_overlay(user)
	update_item_state(user)


/obj/item/weapon/gun/energy/lasgun/update_item_state(mob/user)
	. = item_state
	var/cell_charge = (!cell || cell.charge <= 0) ? 0 : CEILING((cell.charge / max(cell.maxcharge, 1)) * 100, 25)
	item_state = "[initial(icon_state)]_[cell_charge][flags_item & WIELDED ? "_w" : ""]"
	if(. != item_state && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(src == human_user.l_hand)
			human_user.update_inv_l_hand()
		else if (src == human_user.r_hand)
			human_user.update_inv_r_hand()


/obj/item/weapon/gun/energy/lasgun/reload(mob/user, obj/item/cell/lasgun/new_cell)
	if(flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG))
		return

	if(!new_cell || !istype(new_cell))
		to_chat(user, "<span class='warning'>That's not a power cell!</span>")
		return

	if(new_cell.charge <= 0)
		to_chat(user, "<span class='warning'>[cell] is depleted!</span>")
		return

	if(!istype(src, new_cell.gun_type))
		to_chat(user, "<span class='warning'>That power cell doesn't fit in there!</span>")
		return

	if(cell)
		to_chat(user, "<span class='warning'>It's still got something loaded.</span>")
		return

	if(user)
		if(new_cell.reload_delay > 1)
			to_chat(user, "<span class='notice'>You begin reloading [src]. Hold still...</span>")
			if(do_after(user,new_cell.reload_delay, TRUE, src, BUSY_ICON_GENERIC))
				replace_magazine(user, new_cell)
			else
				to_chat(user, "<span class='warning'>Your reload was interrupted!</span>")
				return
		else
			replace_magazine(user, new_cell)
	else
		replace_magazine(null, new_cell)
	return TRUE

/obj/item/weapon/gun/energy/lasgun/replace_magazine(mob/user, obj/item/cell/lasgun/new_cell)
	cell = new_cell
	if(user)
		user.transferItemToLoc(new_cell, src) //Click!
		user.visible_message("<span class='notice'>[user] loads [new_cell] into [src]!</span>",
		"<span class='notice'>You load [new_cell] into [src]!</span>", null, 3)
		if(reload_sound)
			playsound(user, reload_sound, 25, 1, 5)
		update_icon(user)
	else
		cell.loc = src
		update_icon()

//Drop out the magazine. Keep the ammo type for next time so we don't need to replace it every time.
//This can be passed with a null user, so we need to check for that as well.
/obj/item/weapon/gun/energy/lasgun/unload(mob/user, reload_override = 0, drop_override = 0) //Override for reloading mags after shooting, so it doesn't interrupt burst. Drop is for dropping the magazine on the ground.
	if(!reload_override && (flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG)))
		return FALSE

	if(!cell || cell.loc != src)
		return FALSE

	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		cell.loc = get_turf(src) //Drop it on the ground.
	else
		user.put_in_hands(cell)

	playsound(user, unload_sound, 25, 1, 5)
	user.visible_message("<span class='notice'>[user] unloads [cell] from [src].</span>",
	"<span class='notice'>You unload [cell] from [src].</span>", null, 4)
	cell.update_icon()
	cell = null

	update_icon(user)

	return TRUE

//-------------------------------------------------------
//Deathsquad-only gun -- Model 2419 pulse rifle, the M19C4.

/obj/item/weapon/gun/energy/lasgun/pulse
	name = "\improper M19C4 pulse energy rifle"
	desc = "A heavy-duty, multifaceted energy weapon that uses pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists and front-line combat personnel. This is a testing model issued only for Asset Protection units and offshore elite Nanotrasen squads."
	force = 23 //Slightly more heftier than the M43, but without the stock.
	icon_state = "m19c4"
	item_state = "m19c4"
	fire_sound = 'sound/weapons/guns/fire/pulseenergy.ogg'
	dry_fire_sound = 'sound/weapons/guns/fire/vp70_empty.ogg'
	unload_sound = 'sound/weapons/guns/interact/m41a_unload.ogg'
	reload_sound = 'sound/weapons/guns/interact/m4ra_reload.ogg'
	max_shots = 100//codex stuff
	load_method = CELL //codex stuff
	ammo = /datum/ammo/energy/lasgun/pulsebolt
	muzzleflash_iconstate = "muzzle_flash_pulse"
	cell_type = /obj/item/cell/lasgun/pulse
	charge_cost = ENERGY_STANDARD_AMMO_COST
	muzzle_flash_color = COLOR_PULSE_BLUE

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 15, "stock_x" = 22, "stock_y" = 12)

	fire_delay = 8
	burst_delay = 0.2 SECONDS
	accuracy_mult = 1.15
	accuracy_mult_unwielded = 0.95
	scatter_unwielded = 25

//-------------------------------------------------------
//A practice version of M43, only for the marine hq map.

/obj/item/weapon/gun/energy/lasgun/M43/practice
	name = "\improper M43-P Sunfury Lasgun MK1"
	desc = "An accurate, recoilless laser based battle rifle, based on the outdated M43 design. Only accepts practice power cells and it doesn't have a charge selector. Uses power cells instead of ballistic magazines."
	force = 8 //Well, it's not complicted compared to the original.
	ammo = /datum/ammo/energy/lasgun/M43/practice
	cell_type = /obj/item/cell/lasgun/M43/practice
	attachable_allowed = list()
	starting_attachment_types = list(/obj/item/attachable/stock/lasgun/practice)
	muzzle_flash_color = COLOR_DISABLER_BLUE

	damage_falloff_mult = 1
	fire_delay = 0.33 SECONDS
	aim_slowdown = 0.35

/obj/item/weapon/gun/energy/lasgun/M43/practice/unique_action(mob/user)
	return

/obj/item/weapon/gun/energy/lasgun/lasrifle
	name = "\improper TX-73 lasrifle MK2"
	desc = "A multifunctional laser based rifle with an integrated mode selector. Ideal for any situation. Uses power cells instead of ballistic magazines."
	force = 20 //Large and hefty! Includes stock bonus.
	icon = 'icons/Marine/gun64.dmi'
	icon_state = "tx73"
	item_state = "tx73"
	max_shots = 50 //codex stuff
	load_method = CELL //codex stuff
	ammo = /datum/ammo/energy/lasgun/M43
	ammo_diff = null
	cell_type = /obj/item/cell/lasgun/lasrifle
	charge_cost = 20
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(GUN_FIREMODE_AUTOMATIC)//Lasrifle has special behavior for fire mode, be carefull
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonetknife,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/marine,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/scope/mini,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 14,"rail_x" = 18, "rail_y" = 18, "under_x" = 23, "under_y" = 10, "stock_x" = 22, "stock_y" = 12)

	accuracy_mult_unwielded = 0.5 //Heavy and unwieldy; you don't one hand this.
	scatter_unwielded = 100 //Heavy and unwieldy; you don't one hand this.
	damage_falloff_mult = 0.25
	fire_delay = 2
	var/static/list/datum/lasrifle/base/mode_list = list(
		"Standard" = /datum/lasrifle/base/standard,
		"Disabler" = /datum/lasrifle/base/disabler,
		"Overcharge" = /datum/lasrifle/base/overcharge,
		"Heat" = /datum/lasrifle/base/heat,
		"Spread" = /datum/lasrifle/base/spread,
	)

/datum/lasrifle/base
	///how much power the gun uses on this mode when shot.
	var/charge_cost = 0
	///the ammo datum this mode is.
	var/ammo = null
	///how long it takes between each shot of that mode, same as gun fire delay.
	var/fire_delay = 0
	///The gun firing sound of this mode.
	var/fire_sound = null
	///What message it sends to the user when you switch to this mode.
	var/message_to_user = ""
	///Used to change the gun firemode, like automatic, semi-automatic and burst.
	var/fire_mode = GUN_FIREMODE_SEMIAUTO
	///what to change the gun icon_state to when switching to this mode.
	var/icon_state = "tx73"
	///Which icon file the radial menu will use.
	var/radial_icon = 'icons/mob/radial.dmi'
	///The icon state the radial menu will use.
	var/radial_icon_state = "laser"

/datum/lasrifle/base/standard
	charge_cost = 20
	ammo = /datum/ammo/energy/lasgun/M43
	fire_delay = 2
	fire_sound = 'sound/weapons/guns/fire/laser.ogg'
	message_to_user = "You set the Lasrifle's charge mode to standard fire."
	fire_mode = GUN_FIREMODE_AUTOMATIC
	icon_state = "tx73"

/datum/lasrifle/base/disabler
	charge_cost = 80
	ammo = /datum/ammo/energy/lasgun/M43/disabler
	fire_delay = 10
	fire_sound = 'sound/weapons/guns/fire/disabler.ogg'
	message_to_user = "You set the Lasrifle's charge mode to disabler fire."
	fire_mode = GUN_FIREMODE_AUTOMATIC
	icon_state = "tx73_auto"
	radial_icon_state = "laser_disabler"

/datum/lasrifle/base/overcharge
	charge_cost = 80
	ammo = /datum/ammo/energy/lasgun/M43/overcharge
	fire_delay = 10
	fire_sound = 'sound/weapons/guns/fire/plasma_precision_3.ogg'
	message_to_user = "You set the Lasrifle's charge mode to overcharge."
	icon_state = "tx73_overcharge"
	radial_icon_state = "laser_overcharge"

/datum/lasrifle/base/heat
	charge_cost = 80
	ammo = /datum/ammo/energy/lasgun/M43/heat
	fire_delay = 15
	fire_sound = 'sound/weapons/guns/fire/laser3.ogg'
	message_to_user = "You set the Lasrifle's charge mode to wave heat."
	icon_state = "tx73_heat"
	radial_icon_state = "laser_heat"

/datum/lasrifle/base/spread
	charge_cost = 80
	ammo = /datum/ammo/energy/lasgun/M43/blast
	fire_delay = 8
	fire_sound = 'sound/weapons/guns/fire/laser_rifle_2.ogg'
	message_to_user = "You set the Lasrifle's charge mode to spread."
	icon_state = "tx73_spread"
	radial_icon_state = "laser_spread"

/obj/item/weapon/gun/energy/lasgun/lasrifle/unique_action(mob/user)
	return switch_modes(user)

/obj/item/weapon/gun/energy/lasgun/lasrifle/proc/switch_modes(mob/user)
	if(!user)
		CRASH("switch_modes called with no user.")

	var/list/available_modes = list()
	for(var/mode in mode_list)
		available_modes += list("[mode]" = image(icon = initial(mode_list[mode].radial_icon), icon_state = initial(mode_list[mode].radial_icon_state)))

	var/datum/lasrifle/base/choice = mode_list[show_radial_menu(user, user, available_modes, null, 64, tooltips = TRUE)]
	if(!choice)
		return


	playsound(user, 'sound/weapons/emitter.ogg', 5, FALSE, 2)


	gun_firemode = initial(choice.fire_mode)


	charge_cost = initial(choice.charge_cost)
	ammo = GLOB.ammo_list[initial(choice.ammo)]
	fire_delay = initial(choice.fire_delay)
	fire_sound = initial(choice.fire_sound)
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay)
	SEND_SIGNAL(src, COMSIG_GUN_FIRE_MODE_TOGGLE, initial(choice.fire_mode), user.client)

	base_gun_icon = initial(choice.icon_state)
	update_icon()

	to_chat(user, initial(choice.message_to_user))

	var/obj/screen/ammo/A = user.hud_used.ammo //The ammo HUD
	A.update_hud(user)

	return TRUE

// Neat laser gun things

//Ok the rifle

/obj/item/weapon/gun/energy/lasgun/standard_marine
	name = "\improper TEX-R Lasrifle"
	desc = "A TerraGov standard issue Lasrifle with an integrated charge selector for normal and high settings. Uses standardized power cells."
	force = 20
	icon_state = "texr"
	item_state = "texr"
	icon = 'icons/Marine/gun64.dmi'
	w_class = WEIGHT_CLASS_BULKY
	max_shots = 60 //codex stuff
	load_method = CELL //codex stuff
	ammo = /datum/ammo/energy/lasgun/marine
	ammo_diff = /datum/ammo/energy/lasgun/marine/overcharge
	cell_type = /obj/item/cell/lasgun/marine
	charge_cost = 10
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonetknife,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER
	actions_types = list(/datum/action/item_action/aim_mode)
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 15, "stock_x" = 22, "stock_y" = 12)

	fire_delay = 0.2 SECONDS
	aim_slowdown = 0.5
	wield_delay = 0.6 SECONDS
	scatter = 0
	scatter_unwielded = 10 //its a laser gun
	accuracy_mult = 1.15
	accuracy_mult_unwielded = 0.5

// AIM MODE

	aim_fire_delay = 0.2 SECONDS
	aim_speed_modifier = 1.3

/obj/item/weapon/gun/energy/lasgun/standard_marine/unique_action(mob/user)
	return toggle_chargemode(user)

//Toggles Overcharge mode. Overcharge mode significantly increases damage and AP in exchange for doubled ammo usage and increased fire delay.
/obj/item/weapon/gun/energy/lasgun/standard_marine/toggle_chargemode(mob/user)
	if(overcharge == FALSE)
		if(!cell)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s high power mode but you have no battery loaded.</span>")
			return
		if(cell.charge < 20)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s high power mode but your battery pack lacks adequate charge to do so.</span>")
			return
		//While overcharge is active, double ammo consumption, and
		playsound(user, 'sound/weapons/emitter.ogg', 5, 0, 2)
		charge_cost = 20
		ammo = GLOB.ammo_list[ammo_diff]
		fire_delay += 0.2 SECONDS // 0.4 FIRERATE
		fire_sound = 'sound/weapons/guns/fire/laser3.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s high power mode.")
		overcharge = TRUE
	else
		playsound(user, 'sound/weapons/emitter2.ogg', 5, 0, 2)
		charge_cost = 10
		ammo = GLOB.ammo_list[/datum/ammo/energy/lasgun/marine]
		fire_delay -= 0.2 SECONDS
		fire_sound = 'sound/weapons/guns/fire/laser.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s high power mode.")
		overcharge = FALSE

//Ammo/Charge functions
/obj/item/weapon/gun/energy/lasgun/standard_marine/update_icon(mob/user)
	var/cell_charge = (!cell || cell.charge <= 0) ? 0 : CEILING((cell.charge / max(cell.maxcharge, 1)) * 100, 25)
	icon_state = "[base_gun_icon]_[cell_charge]"
	update_mag_overlay(user)


/obj/item/weapon/gun/energy/lasgun/standard_marine/update_item_state(mob/user)// lasgun code thing i don't want so redfined
	. = item_state
	item_state = "[initial(icon_state)][flags_item & WIELDED ? "_w" : ""]"
	if(. != item_state && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(src == human_user.l_hand)
			human_user.update_inv_l_hand()
		else if (src == human_user.r_hand)
			human_user.update_inv_r_hand()

// other rifle

/obj/item/weapon/gun/energy/lasgun/standard_marine/carbine
	name = "\improper TEX-c Lascarbine"
	desc = "A TerraGov standard issue Lascarbine with an integrated charge selector for normal and high settings. Uses standardized power cells."
	force = 20
	icon_state = "texc"
	item_state = "texc"
	icon = 'icons/Marine/gun64.dmi'
	w_class = WEIGHT_CLASS_BULKY
	max_shots = 40 //codex stuff
	load_method = CELL //codex stuff
	ammo = /datum/ammo/energy/lasgun/marine
	ammo_diff = /datum/ammo/energy/lasgun/marine/blast
	cell_type = /obj/item/cell/lasgun/marine
	charge_cost = 15
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonetknife,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER
	actions_types = list(/datum/action/item_action/aim_mode)
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 15, "stock_x" = 22, "stock_y" = 12)

	fire_delay = 0.2 SECONDS
	aim_slowdown = 0.3
	wield_delay = 0.4 SECONDS
	scatter = 0
	scatter_unwielded = 10 //its a laser gun
	accuracy_mult = 1.15
	accuracy_mult_unwielded = 0.55

// AIM MODE

	aim_fire_delay = 0.2 SECONDS
	aim_speed_modifier = 1

//Toggles Overcharge mode. Overcharge mode significantly increases damage and AP in exchange for doubled ammo usage and increased fire delay.
/obj/item/weapon/gun/energy/lasgun/standard_marine/carbine/toggle_chargemode(mob/user)
	if(overcharge == FALSE)
		if(!cell)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s high power mode but you have no battery loaded.</span>")
			return
		if(cell.charge < 60)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s high power mode but your battery pack lacks adequate charge to do so.</span>")
			return
		//While overcharge is active, double ammo consumption, and
		playsound(user, 'sound/weapons/emitter.ogg', 5, 0, 2)
		charge_cost = 60
		ammo = GLOB.ammo_list[ammo_diff]
		fire_delay += 1 SECONDS // 0.4 FIRERATE
		fire_sound = 'sound/weapons/guns/fire/laser3.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s high power mode.")
		overcharge = TRUE
	else
		playsound(user, 'sound/weapons/emitter2.ogg', 5, 0, 2)
		charge_cost = 10
		ammo = GLOB.ammo_list[/datum/ammo/energy/lasgun/marine]
		fire_delay -= 1 SECONDS
		fire_sound = 'sound/weapons/guns/fire/laser.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s high power mode.")
		overcharge = FALSE

// pistole


/obj/item/weapon/gun/energy/lasgun/standard_marine/pistol
	name = "\improper TEX-R Laspistol"
	desc = "A TerraGov standard issue Laspistol with an integrated charge selector for normal and disabler settings. Uses standardized power cells."
	force = 10
	icon_state = "texp"
	item_state = "texp"
	icon = 'icons/obj/items/gun.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	max_shots = 25 //codex stuff
	ammo = /datum/ammo/energy/lasgun/marine/pistol
	ammo_diff = /datum/ammo/energy/lasgun/marine/pistol/disabler
	charge_cost = 20
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonetknife,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER
	actions_types = list(/datum/action/item_action/aim_mode)
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 15, "stock_x" = 22, "stock_y" = 12)

	fire_delay = 0.25 SECONDS
	aim_slowdown = 0.2
	wield_delay = 0.3 SECONDS
	scatter = 0
	scatter_unwielded = 10 //its a laser gun
	accuracy_mult = 1.15
	accuracy_mult_unwielded = 1

// AIM MODE

	aim_fire_delay = 0.1 SECONDS
	aim_speed_modifier = 0.5

//Toggles Overcharge mode.
/obj/item/weapon/gun/energy/lasgun/standard_marine/pistol/toggle_chargemode(mob/user)
	if(overcharge == FALSE)
		if(!cell)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s disabler mode but you have no battery loaded.</span>")
			return
		if(cell.charge < 40)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s disabler mode but your battery pack lacks adequate charge to do so.</span>")
			return
		//While overcharge is active, double ammo consumption, and
		playsound(user, 'sound/weapons/emitter.ogg', 5, 0, 2)
		charge_cost = 40
		ammo = GLOB.ammo_list[ammo_diff]
		fire_delay += 0.15 SECONDS // 0.4 FIRERATE
		fire_sound = 'sound/weapons/guns/fire/laser3.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s disabler mode.")
		overcharge = TRUE
	else
		playsound(user, 'sound/weapons/emitter2.ogg', 5, 0, 2)
		charge_cost = 10
		ammo = GLOB.ammo_list[/datum/ammo/energy/lasgun/marine/pistol]
		fire_delay -= 0.15 SECONDS
		fire_sound = 'sound/weapons/guns/fire/laser.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s disabler mode.")
		overcharge = FALSE

//Ok the rifle

/obj/item/weapon/gun/energy/lasgun/standard_marine/sniper
	name = "\improper TEX-S Sniper"
	desc = "A TerraGov standard issue Lassniper with an integrated charge selector for normal and high settings. Uses standardized power cells."
	force = 20
	icon_state = "texsniper"
	item_state = "texsniper"
	icon = 'icons/Marine/gun64.dmi'
	w_class = WEIGHT_CLASS_BULKY
	max_shots = 12 //codex stuff
	load_method = CELL //codex stuff
	ammo = /datum/ammo/energy/lasgun/marine/sniper
	ammo_diff = /datum/ammo/energy/lasgun/marine/sniper/fire
	cell_type = /obj/item/cell/lasgun/marine
	charge_cost = 50
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonetknife,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER|GUN_WIELDED_FIRING_ONLY
	actions_types = list(/datum/action/item_action/aim_mode)
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 15, "stock_x" = 22, "stock_y" = 12)

	fire_delay = 1 SECONDS
	aim_slowdown = 0.9
	wield_delay = 0.9 SECONDS
	scatter = 0
	scatter_unwielded = 10 //its a laser gun
	accuracy_mult = 1.35
	accuracy_mult_unwielded = 0.75

// AIM MODE

	aim_fire_delay = 1.5 SECONDS
	aim_speed_modifier = 4

//Toggles Overcharge mode
/obj/item/weapon/gun/energy/lasgun/standard_marine/sniper/toggle_chargemode(mob/user)
	if(overcharge == FALSE)
		if(!cell)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s high power mode but you have no battery loaded.</span>")
			return
		if(cell.charge < 150)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s high power mode but your battery pack lacks adequate charge to do so.</span>")
			return
		//While overcharge is active, double ammo consumption, and
		playsound(user, 'sound/weapons/emitter.ogg', 5, 0, 2)
		charge_cost = 150
		ammo = GLOB.ammo_list[ammo_diff]
		fire_delay += 0.5 SECONDS // 1.5 FIRERATE
		fire_sound = 'sound/weapons/guns/fire/laser3.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s high power mode.")
		overcharge = TRUE
	else
		playsound(user, 'sound/weapons/emitter2.ogg', 5, 0, 2)
		charge_cost = 60
		ammo = GLOB.ammo_list[/datum/ammo/energy/lasgun/marine/sniper]
		fire_delay -= 0.5 SECONDS
		fire_sound = 'sound/weapons/guns/fire/laser.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s high power mode.")
		overcharge = FALSE

//Ok the mg

/obj/item/weapon/gun/energy/lasgun/standard_marine/mg
	name = "\improper TEX-MG Machinegun"
	desc = "A TerraGov standard issue Laser MG with an integrated charge selector for normal and low power settings. Uses standardized power cells."
	force = 30
	icon_state = "texmg"
	item_state = "texmg"
	icon = 'icons/Marine/gun64.dmi'
	w_class = WEIGHT_CLASS_BULKY
	max_shots = 12 //codex stuff
	load_method = CELL //codex stuff
	ammo = /datum/ammo/energy/lasgun/marine/mg
	ammo_diff = /datum/ammo/energy/lasgun/marine/mg/efficent
	cell_type = /obj/item/cell/lasgun/marine
	charge_cost = 3
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonetknife,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY|GUN_AMMO_COUNTER|GUN_WIELDED_FIRING_ONLY
	actions_types = list(/datum/action/item_action/aim_mode)
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 15, "stock_x" = 22, "stock_y" = 12)

	fire_delay = 0.2 SECONDS
	aim_slowdown = 1
	wield_delay = 1.2 SECONDS
	scatter = 0
	scatter_unwielded = 10 //its a laser gun
	accuracy_mult = 1.35
	accuracy_mult_unwielded = 0.75

// AIM MODE

	aim_fire_delay = 0.1 SECONDS
	aim_speed_modifier = 3.5

//Toggles Overcharge mode
/obj/item/weapon/gun/energy/lasgun/standard_marine/mg/toggle_chargemode(mob/user)
	if(overcharge == FALSE)
		if(!cell)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s high power mode but you have no battery loaded.</span>")
			return
		if(cell.charge < 1.5)
			playsound(user, 'sound/machines/buzz-two.ogg', 15, 0, 2)
			to_chat(user, "<span class='warning'>You attempt to toggle on [src]'s low power mode but your battery pack lacks adequate charge to do so.</span>")
			return
		//While overcharge is active, double ammo consumption, and
		playsound(user, 'sound/weapons/emitter.ogg', 5, 0, 2)
		charge_cost = 1.5
		ammo = GLOB.ammo_list[ammo_diff]
		fire_delay -= 0.1 SECONDS // 1, dakka time
		fire_sound = 'sound/weapons/guns/fire/laser3.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s low power mode.")
		overcharge = TRUE
	else
		playsound(user, 'sound/weapons/emitter2.ogg', 5, 0, 2)
		charge_cost = 3
		ammo = GLOB.ammo_list[/datum/ammo/energy/lasgun/marine/mg]
		fire_delay += 0.1 SECONDS
		fire_sound = 'sound/weapons/guns/fire/laser.ogg'
		to_chat(user, "[icon2html(src, user)] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s normal power mode.")
		overcharge = FALSE
