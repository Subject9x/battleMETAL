/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

//pathfinder node stuff
.float node_id;
.float nexnode1;
.float nexnode2;
.float nexnode3;
.float nexnode4;
.float nexnode5;
.float nexnode6;
.float nexnode7;
.float nexnode8;
.float nexnode9;
.float nexnode10;
.float nexnode11;
.float nexnode12;
.float nexnode13;
.float nexnode14;
.float nexnode15;
.float nexnode16;
.float nexnode17;
.float nexnode18;
.float nexnode19;
.float nexnode20;
.float nexnode21;
.float nexnode22;
.float nexnode23;
.float nexnode24;
.float nexnode25;
.float nexnode26;
.float nexnode27;
.float nexnode28;
.float nexnode29;
.float nexnode30;
.float nexnode31;
.float nexnode32;
//=========================

void(entity wep) ai_attack_basic;
void(entity wep) ai_attack_ene;
void(entity wep) ai_attack_bal;
void(entity wep) ai_attack_exp;

/*
  AI SPECIFIC GLOBAL CONSTANT======================
*/
//check angle constants (for readability)
float AI_TARG_FWD = 0;
float AI_TARG_BKD = 1;
float AI_TARG_LFT = 2;
float AI_TARG_RGT = 3;

//PILOT RANKS - determines base states, and some realtime decisions
float AI_RANK_ACE = 0;
float AI_RANK_VET = 1;  //veteran
float AI_RANK_REG = 2;  //regular
float AI_RANK_ROK = 3;  //rookie

//QUIRKS - combat
float AI_STYLE_SKIRM  = 0;  //this is 'default'
float AI_STYLE_SNIPER = 1;
float AI_STYLE_BRAWL  = 2;
float AI_STYLE_FLANK  = 3;
float AI_STYLE_STALK  = 4;

//QUIRKS - personality
float AI_TYPE_NORML  = 0;
float AI_TYPE_AGGRO  = 1;
float AI_TYPE_RESCU  = 2;
float AI_TYPE_COWRD  = 3;

//direction bitflag is used to filter out non-viable directions when executing pseudo-random moves
float AI_DIR_N  = 1;
float AI_DIR_NE = 2;
float AI_DIR_E  = 4;
float AI_DIR_SE = 8;
float AI_DIR_S  = 16;
float AI_DIR_SW = 32;
float AI_DIR_W  = 64;
float AI_DIR_NW = 128;

//AI order constants, refactored from func pointers
float AI_ORDER_DEBUG = -1;
float AI_ORDER_STAND = 1;
float AI_ORDER_DEFEND = 2;
float AI_ORDER_PATROL = 3;
float AI_ORDER_ATTACK = 4;
/*==========================================*/
/*
  AI SPECIFIC ENT VARS======================
*/
void() ai_control;      //global, root controller function
.void() ai_prev_state;  //stores the previous ai_state function that was executed
.void() ai_next_state;  //this is the ai_state function to execute on next think
.float ai_prev_move;    //stores previous move as a generic direction, used mostly to unstuck the bot
.float() ai_next_move;  //this is the ai_move function to execute on next think
.float ai_hasmoved;     //misc for debugging stuck bots
//the code uses enemy/goalentity together as a buffer for where the 
//  AI will move to, node and trigger_field are the 'saved state'
//  for nodes and enemies respectively.
//.entity goalentity    /builtin, used by walkmove and movetogoal
//.entity enemy         //builtin, use by walkmove and movetogoal
//.entity trigger_field //builtin but - is the holder for the actual enemy
.entity node;           //the node that the ai wants to move to
.float ai_type;
.float ai_style;
.float ai_first_order;
.vector prev_pos;
.entity oldgoal;
.float ai_dmg_l;
.float ai_dmg_m;
.float ai_dmg_s;
.float ai_rte_rng;
.float ai_rte_cnv;
//.vector ai_prev_org; use the pre-existing 'dest' vars
.float ai_leading;      //how bad does the ai suck? 0.0 is ACE, 0.2 is pretty bad
.float ai_minrange;     //minimum range of guns;
.float ai_optical;      //the 'visual' range the ai can see out before relying on sensors
.float patience;        //counter for if AI is stuck on something
.float maxpatience;     //how impatient is the AI
.void() ai_unit_update; //depends on unit type

/*==========================================*/

/*
  AI MOVE FUNCTIONS======================
*/
//move directives
void(float() move, float frames) ai_move_controller; //root controller, delegates move functions
float() ai_move_stand;
float() ai_move_walk_goal;
float() ai_move_run_goal;
float() ai_move_walkmove_strafeleft;
float() ai_move_walkmove_straferight;
float() ai_move_runmove_slideleft;
float() ai_move_runmove_slideright;
float() ai_move_forward;
float() ai_run_forward;
float() ai_move_backward;
float() ai_run_backward;
float() ai_move_walkmove_forwardleft;
float() ai_move_walkmove_forwardright;
float() ai_move_charge_left;
float() ai_move_charge_right;
float() ai_move_walkmove_backright;
float() ai_move_walkmove_backleft;
float() ai_move_runmove_backright;
float() ai_move_runmove_backleft;
void(float isRun, float duration) ai_move_walkmove_forwardRand;
void(float duration, float() move1, float() move2) ai_move_randomTwo;
void(float duration, float() move1, float() move2, float() move3) ai_move_randomThree;
void(float duration, float() move1, float() move2, float() move3, float() move4) ai_move_randomFour;
void(float duration, float() move1, float() move2, float() move3, float() move4, float() move5, float() move6) ai_move_randomSix;
/*==========================================*/

/*
  AI STATE FUNCTIONS========================
*/
//use this to change an AI's state, it'll be executed on the next .think cycle
void(void() next_state) ai_state_control={
  if(next_state != self.ai_next_state){
     self.ai_prev_state = self.ai_next_state;
     self.ai_next_state = next_state;     
  }
};
//PATROL STATES
void() ai_patrol_startWithNode; 
void() ai_patrol_findNode;
void() ai_patrol_gotoNode;
void() ai_patrol_atNode;
//DEFEND STATES
void() ai_defend_startWithNode;
void() ai_defend_findNode;
void() ai_defend_gotoNode;
void() ai_defend_atNode;
//ASSAULT STATES
void() ai_assault_startWithNode;
void() ai_assault_findNode;
void() ai_assault_gotoNode;
void() ai_assault_atNode;
//MISC STATES
void() ai_misc_unstuck;
void() ai_misc_stand;  
void() ai_misc_stand_debug;
//WANDER STATES
void() ai_wander_findNode;
void() ai_wander_gotoNode;
void() ai_wander_atNode;
//COMBAT STATES
void() ai_combat_findTarget;
void() ai_combat_huntTarget;
void() ai_combat_adjustPosition;
void() ai_combat_endFight;
  //COMBAT SUB STATES 
  void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustSniper;
  void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustBrawler;
  void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustSkirmish;
  void(float targDist, float distClose, float distFar, float tMovedir, float selfLowHealth, entity eBlocker) ai_combat_adjustFlanker;
/*==========================================*/

/*AI CORE FUNCTIONS=========================*/
//NODE NOODLES
float(entity aggro, string groupId) ai_node_defenseGroup_nodeToTarget;
entity(entity aggro, string groupId) ai_node_defenseGroup_setCourse;
entity(string grpId) ai_node_searchGroup_ignoreActive;
entity(string grpId) ai_node_searchGroup_checkActive;
entity(entity pNode) ai_findNode_searchGroup;
entity(entity aNode) ai_node_closestTargNearNode;
//COMBAT
float(entity targ, float faction) ai_combat_locksOnTarget;
float(entity targ) ai_target_canSee;
float(entity targ) ai_target_inForwardArc;
float(entity t) ai_target_visualPing;
float(entity t) ai_target_radarPing;
float(entity t) ai_target_isValid;
float(entity t) ai_target_validType;
entity() ai_target_visualTarget;
entity() ai_target_radarTarget; 
entity(entity filter) ai_target_radarTarget_other;
void() ai_target_clearBuffers;
entity(entity targ) ai_target_checkBlock;
float() ai_target_facingideal;
float(entity targ) ai_target_isInFront;
float(entity targ) ai_target_isFacingThis;
float(entity t) ai_target_isValid_useDataType;
//UPDATE
void(entity t, string grpId) ai_update_entityGroup;
void(float new_type) ai_update_combatType;
void(float new_style) ai_update_combatStyle;
void(entity t, string newTarg) ai_update_entityTarget;
void(entity newTarget) ai_update_switchToTarget;
void(entity newNode) ai_update_switchToNode;
void() ai_update_dmgTime;
//UTIL
void(float state) ai_util_firstOrder_nonStatic;
void(entity aggro) ai_util_defense_callForHelp;
float(entity targ, entity this) ai_util_calcTargetMoveDir;
float(float checkYaw) ai_util_compareYawIdeal;
float() ai_util_checkSelfHealth;
float(vector torg, float tickRate) ai_util_calcMoveDist;
float(float len, float tickRate) ai_util_calcMoveLen;
/*==========================================*/

//WEAPON HANDLING
void() ai_attack;

//utility functions
float() ai_core_noguns;
entity(entity node, float id) ai_query_graphnode;
entity(vector org, float start_dist) ai_core_findgraphnode;
void() ai_core_calcranges;
entity() ai_core_findfriendly;

//AI STATISTICS
float() ai_pilot_rating_converg;
float() ai_pilot_rating_range;
float() ai_pilot_rating_leading;
float() ai_pilot_yaw_mod;
float() ai_pilot_armor_mod;
float() ai_pilot_shield_mod;
float() ai_pilot_rating_patience;
float() ai_core_hitTimeCalc;
float() ai_core_attackInterval;

//TODO - separate header?
void() ai_mech_update;
void() ai_mech_attack;
void() ai_mech_die;
void() ai_mech_cleanup;
void() ai_mech_touch;
void() ai_turret_control;
void() ai_turret_update;
void() ai_turret_touch;
void() ai_turret_die;