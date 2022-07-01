#define PROCESS_ACCURACY 10

/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/remove_rejuv()
	if(owner)
		owner.internal_organs_by_name -= src
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs_by_name)
			owner.internal_organs_by_name -= null
	..()

// Brain is defined in brain_item.dm.
// Heart is defined in heart.dm
// Lungs are defined in lungs.dm
// Kidneys is defined in kidneys.dm
// Eyes are defined in eyes.dm
// Liver is defined in liver.dm. The process here was different than the process in liver.dm, so I just kept the one in liver.dm
// Appendix is defined in appendix.dm
