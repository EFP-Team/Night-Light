#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null

#define LIGHTING_FALLOFF 1 // type of falloff to use for lighting; 1 for circular, 2 for square
#define LIGHTING_LAMBERTIAN 0 // use lambertian shading for light sources
#define LIGHTING_HEIGHT 1 // height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone

#define LIGHTING_ICON 'icons/effects/lighting_overlay.dmi' // icon used for lighting shading effects
#define LIGHTING_ICON_STATE_DARK "soft_dark" // Change between "soft_dark" and "dark" to swap soft darkvision

#define LIGHTING_ROUND_VALUE    1 / 64 //Value used to round lumcounts, values smaller than 1/255 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.

#define LIGHTING_SOFT_THRESHOLD 0.054 // If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting overlays.  This also should be the transparancy of the "soft_dark" icon state.

#define LIGHTING_MULT_FACTOR 0.5
// If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list                     \
	(                        \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		0, 0, 0, 1           \
	)                        \

// Helpers so we can (more easily) control the colour matrices.
#define CL_MATRIX_RR 1
#define CL_MATRIX_RG 2
#define CL_MATRIX_RB 3
#define CL_MATRIX_RA 4
#define CL_MATRIX_GR 5
#define CL_MATRIX_GG 6
#define CL_MATRIX_GB 7
#define CL_MATRIX_GA 8
#define CL_MATRIX_BR 9
#define CL_MATRIX_BG 10
#define CL_MATRIX_BB 11
#define CL_MATRIX_BA 12
#define CL_MATRIX_AR 13
#define CL_MATRIX_AG 14
#define CL_MATRIX_AB 15
#define CL_MATRIX_AA 16
#define CL_MATRIX_CR 17
#define CL_MATRIX_CG 18
#define CL_MATRIX_CB 19
#define CL_MATRIX_CA 20

//Some defines to generalise colours used in lighting.
//Important note on colors. Colors can end up significantly different from the basic html picture, especially when saturated

// Triadic Palette
#define LIGHT_COLOR_RED        "#FA6496"
#define LIGHT_COLOR_GREEN      "#96FA64"
#define LIGHT_COLOR_BLUE       "#6496FA"

#define LIGHT_COLOR_BLUEGREEN  "#7DE1AF" //Light blueish green. rgb(125, 225, 175)
#define LIGHT_COLOR_CYAN       "#7DE1E1" //Diluted cyan. rgb(125, 225, 225)
#define LIGHT_COLOR_LIGHT_CYAN "#40CEFF" //More-saturated cyan. rgb(64, 206, 255)
#define LIGHT_COLOR_DARK_BLUE  "#3375f8" //Saturated blue. rgb(51, 117, 248)
#define LIGHT_COLOR_PINK       "#E17DE1" //Diluted, mid-warmth pink. rgb(225, 125, 225)
#define LIGHT_COLOR_YELLOW     "#E1E17D" //Dimmed yellow, leaning kaki. rgb(225, 225, 125)
#define LIGHT_COLOR_BROWN      "#966432" //Clear brown, mostly dim. rgb(150, 100, 50)
#define LIGHT_COLOR_ORANGE     "#FA9632" //Mostly pure orange. rgb(250, 150, 50)
#define LIGHT_COLOR_PURPLE     "#952CF4" //Light Purple. rgb(149, 44, 244)
#define LIGHT_COLOR_LAVENDER   "#9B51FF" //Less-saturated light purple. rgb(155, 81, 255)
#define LIGHT_COLOR_COOPER     "#E69E7F"
#define LIGHT_COLOR_SKYBLUE    "#7DD3FF"

// Neon pallette
#define LIGHT_COLOR_HOTPINK    "#F419A0"
#define LIGHT_COLOR_NEONGREEN  "#1FFF0F"
#define LIGHT_COLOR_NEONRED    "#F72119"
#define LIGHT_COLOR_NEONYELLOW "#FFF01F"
#define LIGHT_COLOR_NEONLIGHTBLUE "#83EEFF"
#define LIGHT_COLOR_NEONBLUE   "#4D4DFF"
#define LIGHT_COLOR_NEONDARKBLUE "#000370"
#define LIGHT_COLOR_NEONORANGE "#FF5733"

//These ones aren't a direct colour like the ones above, because nothing would fit
#define LIGHT_COLOR_FIRE       "#FAA019" //Warm orange color, leaning strongly towards yellow. rgb(250, 160, 25)
#define LIGHT_COLOR_LAVA       "#C48A18" //Very warm yellow, leaning slightly towards orange. rgb(196, 138, 24)
#define LIGHT_COLOR_FLARE      "#FA644B" //Bright, non-saturated red. Leaning slightly towards pink for visibility. rgb(250, 100, 75)
#define LIGHT_COLOR_SLIME_LAMP "#AFC84B" //Weird color, between yellow and green, very slimy. rgb(175, 200, 75)
#define LIGHT_COLOR_TUNGSTEN   "#FAE1AF" //Extremely diluted yellow, close to skin color (for some reason). rgb(250, 225, 175)
#define LIGHT_COLOR_HALOGEN    "#F0FAFA" //Barely visible cyan-ish hue, as the doctor prescribed. rgb(240, 250, 250)

#define LIGHT_COLOR_FLUORESCENT_TUBE "#E0EFFF"
#define LIGHT_COLOR_FLUORESCENT_FLASHLIGHT "#CDDDFF"
#define LIGHT_COLOR_INCANDESCENT_TUBE "#FFFEB8"
#define LIGHT_COLOR_INCANDESCENT_BULB "#FFDDBB"
#define LIGHT_COLOR_INCANDESCENT_FLASHLIGHT "#FFCC66"

#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-3, size=4, color="#04080FAA")

#define LIGHTING_BLOOM filter(type="bloom", size = 6, threshold = "#DDDDDD", offset = 8, alpha = 80)
#define NEON_DECALS_BLOOM filter(type="bloom", size = 6, threshold = "#000000", offset = 8, alpha = 80)

/// Uses vis_overlays to leverage caching so that very few new items need to be made for the overlay. For anything that doesn't change outline or opaque area much or at all.
#define EMISSIVE_BLOCK_GENERIC 1
/// Uses a dedicated render_target object to copy the entire appearance in real time to the blocking layer. For things that can change in appearance a lot from the base state, like humans.
#define EMISSIVE_BLOCK_UNIQUE 2

/// The color matrix applied to all emissive overlays. Should be solely dependent on alpha and not have RGB overlap with [EM_BLOCK_COLOR].
#define EMISSIVE_COLOR list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 1,1,1,0)
/// A globaly cached version of [EMISSIVE_COLOR] for quick access.
GLOBAL_LIST_INIT(emissive_color, EMISSIVE_COLOR)
/// The color matrix applied to all emissive blockers. Should be solely dependent on alpha and not have RGB overlap with [EMISSIVE_COLOR].
#define EM_BLOCK_COLOR list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
/// A globaly cached version of [EM_BLOCK_COLOR] for quick access.
GLOBAL_LIST_INIT(em_block_color, EM_BLOCK_COLOR)
/// The color matrix used to mask out emissive blockers on the emissive plane. Alpha should default to zero, be solely dependent on the RGB value of [EMISSIVE_COLOR], and be independant of the RGB value of [EM_BLOCK_COLOR].
#define EM_MASK_MATRIX list(0,0,0,1/3, 0,0,0,1/3, 0,0,0,1/3, 0,0,0,0, 1,1,1,0)
/// A globaly cached version of [EM_MASK_MATRIX] for quick access.
GLOBAL_LIST_INIT(em_mask_matrix, EM_MASK_MATRIX)
