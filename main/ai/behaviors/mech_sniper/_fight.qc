/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  sniper mechs are a special behavior of mechs in the game,
    they will try to fight at long-range mostly
  _fight.qc contains functions that break up the fight-move filtering
  seein in _combat.qc into manageable chunks of code.
  
  external globals
  float enemy_infront;  //boolean, on-this-frame check if target is in AI's forward arc.
  float enemy_range;    //distance to AI relative to patrolNode.ai_view (radius)
  float enemy_vis;      //enum, Line of Sight to target
    float enemy_hunt;     //potentially deprecated.
    float enemy_dist;     //target's distance to patrolNode
    float combat_dist;    //AI's distance to its patrolNode
    float combat_roll;    //per-state-frame dice roll for random movement selection.
*/

/*
  CASE:
  Target - out of node bounds
  AI - inside bounds
    if( enemy_dist > 1 && combat_dist <= 1 ){
*/
void() mech_sniper_fight_target_fire={

};

/*
  CASE:
  Target - out of node bounds
  AI - out of node bounds
    if( enemy_dist > 1.0 && combat_dist > 1.0 ){
*/
void() mech_sniper_fight_out_radius={

};

/*
  CASE:
  target obscured by friendly
    if( enemy_vis == VIS_FRN ){
*/
void() mech_sniper_fight_vis_friend={

};

/*
  CASE:
    target is a building...
*/
void() mech_sniper_fight_building={

};

/*
  CASE:
    my node dist is in the green
*/
void() mech_sniper_fight_full={

};