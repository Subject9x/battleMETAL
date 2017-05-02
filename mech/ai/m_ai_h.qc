/*
mech Mod
Date: 5/2/2017
Overview: mech mod ai header file
  this is heavily based on classic quake C cause its AI covers a good number of use-cases
*/

/*


.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.huntt_ime
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

walkmove(angle, speed) primitive is all or nothing
*/

//
// globals
//
float	current_yaw;

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity	sight_entity;
float	sight_entity_time;
float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;

float(float v) anglemod;

void() q_movetarget_f;
void() q_path_corner;
void() q_t_movetarget;
float(entity targ) q_range;
float (entity targ) q_visible;
float(entity targ) q_infront;
void() q_HuntTarget;
void() q_FoundTarget;
float() q_FindTarget ;
void(vector dest3) q_ChooseTurn;
float() q_FacingIdeal;
float() q_CheckAnyAttack;

//this is really the core of the AI (ai.qc / fight.qc)
void(float dist) q_ai_forward;
void(float dist) q_ai_back;
void(float dist) q_ai_walk;
void() q_ai_stand;
void() q_ai_turn;
void() q_ai_run_melee;
void() q_ai_run_missile;
void() q_ai_run_slide;
void(float dist) q_ai_run;
float() q_CheckAttack;
void() q_ai_face;
void(float d) q_ai_charge;
void() q_ai_charge_side;
void() q_ai_melee;
void() q_ai_melee_side;

//from monsters.qc
void() q_monster_use;
void() q_monster_death_use;
void() q_walkmonster_start_go;
void() q_walkmonster_start;
void() q_flymonster_start_go;
