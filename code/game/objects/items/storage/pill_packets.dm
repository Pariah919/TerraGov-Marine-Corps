// Pill packets, basically pill bottles you can't put pills back into.

/obj/item/storage/pill_bottle/packet
	name = "Pill packet"
	desc = "Containts pills. Once you take them out they don't go back in."
	greyscale_config = null //this line stops pill packets from turning into pill bottles
	icon_state = "pill_packet"
	cant_hold = list(/obj/item/reagent_containers/pill) //Nada. Once you take the pills out. They don't come back in.
	storage_slots = 4
	max_w_class = 0
	max_storage_space = 4

/obj/item/storage/pill_bottle/packet/tricordrazine
	name = "tricordazine pill packet"
	icon_state = "tric_packet"
	desc = "This packet containts tricordazine pills. Heals all types of damage slightly. Once you take them out they don't go back in. No more than 2 pills in a short period."
	pill_type_to_fill = /obj/item/reagent_containers/pill/tricordrazine/packet
	storage_slots = 6
	max_storage_space = 6

/obj/item/storage/pill_bottle/packet/paracetamol
	name = "paracematol pill packet"
	desc = "This packet containts paracetamol pills, also known as tylenol. A long lasting but minor painkiller. Once you take them out they don't go back in. No more than 4 pills in a long period."
	pill_type_to_fill = /obj/item/reagent_containers/pill/paracetamol

/obj/item/storage/pill_bottle/packet/leporazine
	name = "leporazine pill packet"
	desc = "This packet containts leporazine pills. Rapidly stablizes the patients internal temperature. Once you take them out they don't go back in.."
	pill_type_to_fill = /obj/item/reagent_containers/pill/leporazine

/obj/item/storage/pill_bottle/packet/russian_red
	name = "russian red pill packet"
	desc = "This packet containts Russian Red pills. Used for field treatment of critical cases without a medic. Once you take them out they don't go back in.."
	pill_type_to_fill = /obj/item/reagent_containers/pill/russian_red

/obj/item/storage/pill_bottle/packet/ryetalyn
	name = "ryetalyn pill packet"
	desc = "This packet containts Ryetalyn pills. Used to provide a shield against bloodstream toxins. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/ryetalyn

/obj/item/storage/pill_bottle/packet/dylovene
	name = "dylovene pill packet"
	desc = "This packet containts Ryetalyn pills. Used to provide a shield against bloodstream toxins. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/dylovene

/obj/item/storage/pill_bottle/packet/peridaxon
	name = "peridaxon pill packet"
	desc = "This packet containts Peridaxon pills. Used to alleviate organ damage. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/peridaxon

/obj/item/storage/pill_bottle/packet/quickclot
	name = "quickclot pill packet"
	desc = "This packet containts Quickclot pills. Used to alleviate internal bleeding and bleeding in general. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/quickclot

/obj/item/storage/pill_bottle/packet/bicaridine
	name = "bicaridine pill packet"
	icon_state = "bic_packet"
	desc = "This packet containts bicaridine pills. Used to treat minor lacerations. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/bicaridine/packet

/obj/item/storage/pill_bottle/packet/kelotane
	name = "kelotane pill packet"
	icon_state = "kelo_packet"
	desc = "This packet containts kelotane pills. Used to treat surface burns. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/kelotane/packet

/obj/item/storage/pill_bottle/packet/tramadol
	name = "Tramadol pill packet"
	icon_state = "tram_packet"
	desc = "This packet containts tramadol pills. Used as a medium-strength painkiller. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/tramadol/packet

/obj/item/storage/pill_bottle/packet/hypervene
	name = "hypervene pill packet"
	icon_state = "tram_packet"
	desc = "This packet containts hypervene pills. Used as a emergency flusher, use it to remove all chemicals in your system. Once you take them out they don't go back in. No more than 2 pills at once."
	pill_type_to_fill = /obj/item/reagent_containers/pill/hypervene

