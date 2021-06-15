/**
 * Allow to representate a suit that has storage
 * This is only able to representate items of type /obj/item/clothing/suit/storage
 * In practice only PAS will use it, but it supports a lot of objects
 */
/datum/item_representation/suit_with_storage
	///The storage of the suit
	var/datum/item_representation/storage/pockets

/datum/item_representation/suit_with_storage/New(obj/item/item_to_copy)
	if(!item_to_copy)
		return
	if(!issuitwithstorage(item_to_copy))
		CRASH("/datum/item_representation/suit_with_storage created from an item that is not a suit with storage")
	..()
	var/obj/item/clothing/suit/storage/suit_to_copy = item_to_copy
	pockets = new /datum/item_representation/storage(suit_to_copy.pockets)

/datum/item_representation/suit_with_storage/instantiate_object(datum/loadout_seller/seller)
	. = ..()
	if(!.)
		return
	var/obj/item/clothing/suit/storage/suit = .
	suit.pockets = pockets.instantiate_object(seller, suit)

/**
 * Allow to representate a XCAS modular armor with its modules
 * This is only able to representate items of type /obj/item/clothing/suit/modular
 */
/datum/item_representation/modular_armor
	/// What modules are installed
	var/datum/item_representation/armor_module/installed_module
	/// What storage is installed
	var/datum/item_representation/armor_module/installed_storage
	///The implementation of the storage
	var/datum/item_representation/storage/storage_implementation

/datum/item_representation/modular_armor/New(obj/item/item_to_copy)
	if(!item_to_copy)
		return
	if(!ismodulararmor(item_to_copy))
		CRASH("/datum/item_representation/modular_armor created from an item that is not a xenonauten")
	..()
	var/obj/item/clothing/suit/modular/xenonauten_to_copy = item_to_copy
	if(xenonauten_to_copy.installed_storage)
		installed_storage = new /datum/item_representation/armor_module(xenonauten_to_copy.installed_storage)
		storage_implementation = new /datum/item_representation/storage(xenonauten_to_copy.storage)
	if(!length(xenonauten_to_copy.installed_modules) || !is_savable_in_loadout(xenonauten_to_copy.installed_modules[1])) //Not supporting mutiple modules, but no object in game has that so
		return
	installed_module = new /datum/item_representation/armor_module(xenonauten_to_copy.installed_modules[1])


/**
 * Allow to representate an module of a XCAS.
 * This is only able to representate items of type /obj/item/armor_module
 */
/datum/item_representation/armor_module

/datum/item_representation/armor_module/New(obj/item/item_to_copy)
	if(!item_to_copy)
		return
	if(!ismodulararmormodule(item_to_copy))
		CRASH("/datum/item_representation/armor_module created from an item that is not a xenonauten module")
	..()

///Attach the instantiated item on an armor
/datum/item_representation/armor_module/proc/install_on_armor(datum/loadout_seller/seller, obj/item/clothing/suit/modular/armor)
	var/obj/item/armor_module/module = instantiate_object(seller)
	module.do_attach(null, armor)

/**
 * Allow to representate an armor piece of a xenonauten, and to color it
 * This is only able to representate items of type /obj/item/armor_module/armor
 */

