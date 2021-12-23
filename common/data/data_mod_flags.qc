/*
battleMETAL
Author: Peter Roohr
Date: 12/03/2021
Overview: 
  mod flags
    a formalized list of unit flags that directly affect gameplay mechanics.
    
    This is so players can patch in their own custom mechs to their taste...
*/
.float unitModFlags;
//preloaded flag values
#define MODFLAG_BATTLEMETAL 2007294
#define MODFLAG_METALWARRIOR 8257777
#define MODFLAG_METALSIEGE 1578766

//invert the mech Energy meter system to incrememt to a max instead 
//of decrementing to 0
#define MOD_HEAT_NOT_ENERGY 1

//toggle battleMETAL shield mechanics on unit.
#define MOD_HAS_SHIELD 2

//tells battleMETAL to throw a gib when a mech chunk is critically destroyed.
//if NOT using flag, then part will remain, with a darker tint, and continue to smoke.
//will also shutoff pitch.
//maps to M_* part bitflags too
#define MOD_EXPLODE_TOR_R 4
#define MOD_EXPLODE_TOR_L 8
#define MOD_EXPLODE_ARM_L 16
#define MOD_EXPLODE_ARM_R 32

//tells battleMETAL to have mech component to track player pitch.
//example: arms will rotate up-and-down to player pitch.
#define MOD_MODEL_PITCH_ARM_L 64
#define MOD_MODEL_PITCH_ARM_R 128
#define MOD_MODEL_PITCH_TOR_C 256
#define MOD_MODEL_PITCH_TOR_R 512
#define MOD_MODEL_PITCH_TOR_L 1024

#define MOD_MODEL_PITCH_WEP_CTR 2048

#define MOD_MODEL_PITCH_WEP_ALL 4096

//player mech can use ramshocks, if absent, then they can't
//  BUT up to modder to update UI / Controls / etc to tell player no ram shocks.
#define MOD_HAS_RAMSHOCKS 8192

#define MOD_CRIT_LEGS 32768

// mech component has no model (generally for weapons)
#define MOD_MODEL_NONE 65536

//ignore specific mech-piece directives, this will override any unit_data.qc file stuff.
#define MOD_HAS_ARM_L 131072
#define MOD_HAS_ARM_R 262144
#define MOD_HAS_TOR_L 524288
#define MOD_HAS_TOR_R 1048576

//some mechs the torsos are 1 solid mesh.
#define MOD_MODEL_NO_TOR_L 2097152
#define MOD_MODEL_NO_TOR_R 4194304
//simulate a hinge-joint center torso, the torsoCenter model will pivot, the 'root tor C' will be the root entity's model, replacing 'testball'
#define MOD_MODEL_ROOT_TOR_C 8388608