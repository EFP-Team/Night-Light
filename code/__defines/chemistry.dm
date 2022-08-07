#define DEFAULT_HUNGER_FACTOR 0.03 // Factor of how fast mob nutrition decreases
#define DEFAULT_THIRST_FACTOR 0.05 // Factor of how fast mob hydration decreases.
#define DEFAULT_CALORIES_FACTOR 0.05 // Factor of how fast mob calories decreases.

#define REM 0.2 // Means 'Reagent Effect Multiplier'. This is how many ml of reagent are consumed per tick

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_BLOOD 3

#define MINIMUM_CHEMICAL_VOLUME 0.1

#define SOLID 1
#define LIQUID 2
#define GAS 3

#define REAGENTS_OVERDOSE 5000

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

#define CE_REGENERATION  "regeneration" //Affects natural body generation

// Some on_mob_life() procs check for alien races.
#define IS_DIONA   1
#define IS_VOX     2
#define IS_SKRELL  3
#define IS_UNATHI  4
#define IS_TAJARA  5
#define IS_XENOS   6
#define IS_TESHARI 7
#define IS_SLIME   8
#define IS_PRECURSOR 9

#define CE_STABLE        "stable"
#define CE_ANTIBIOTIC    "antibiotic"   // Antibiotics
#define CE_BLOODRESTORE  "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER    "painkiller"
#define CE_ALCOHOL       "alcohol"      // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic"    // Liver damage
#define CE_SPEEDBOOST    "gofast"       // Hyperzine
#define CE_SLOWDOWN      "goslow"       // Slowdown
#define CE_PULSE         "xcardic"      // increases or decreases heart rate
#define CE_PRESSURE      "bpressure"    // increases or decreases gvr
#define CE_CARDIAC_OUTPUT "cardoutput"  // multiplies cardiac output
#define CE_NOPULSE       "heartstop"    // stops heartbeat
#define CE_ANTITOX       "antitox"
#define CE_OXYGENATED    "oxygen"       // Dexalin.
#define CE_BRAIN_REGEN   "brainfix"     // Alkysine.
#define CE_ANTIVIRAL     "antiviral"    // Anti-virus effect.
#define CE_TOXIN         "toxins"       // Generic toxins, stops autoheal.
#define CE_BREATHLOSS    "breathloss"   // Breathing depression, makes you need more air
#define CE_MIND    		 "mindbending"  // Stabilizes or wrecks mind. Used for hallucinations
#define CE_CRYO 	     "cryogenic"    // Prevents damage from being frozen
#define CE_ANTIARRYTHMIC "stablerythme" // Prevents arrythmias.
#define CE_ARRYTHMIC     "arrythmic"    // Causes arrythmia.
#define CE_BETABLOCKER   "betablocker"  // β1-selective beta-blockers.

#define REAGENTS_PER_SHEET 200

// Attached to CE_ANTIBIOTIC
#define ANTIBIO_NORM	1
#define ANTIBIO_OD		2
#define ANTIBIO_SUPER	3

// Chemistry lists.
var/list/tachycardics  = list("coffee", "crank", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "ecstasy", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_chlorophoride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional
