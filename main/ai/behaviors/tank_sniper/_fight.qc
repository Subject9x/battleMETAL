/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 
  sniper tanks are a special behavior of tanks in the game,
    they usually lack turrets, but carry powerful weapons.
    they will try to fight at long-range mostly
  _fight.qc contains functions that break up the fight-move filtering
  seein in _combat.qc into manageable chunks of code.
  
  external globals
  float enemy_infront;  //boolean, on-this-frame check if target is in AI's forward arc.
  float enemy_range;    //distance to AI relative to patrolNode.ai_view (radius)
  float enemy_vis;      //enum, Line of Sight to target
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
void() spg_fight_target_fire={
  if( enemy_infront ){
    if( combat_dist <= 0.5 ){
      if(self.ai_move_last == MOVE_STAND_FACE){
        self.ai_movedist = 10;
        self.ai_move_next = MOVE_CHARGE;
        return;
      }
      self.ai_move_next = MOVE_STAND_FACE;
      self.ai_movedist = 1 + (random() * (self.ai_rank * 1.25));
      return;
    }
    self.ai_movedist = 10;
    self.ai_move_next = MOVE_CHARGE;
    return;
  }
  self.enemy = world;
  self.ai_state_next = ST_STAND;
};

/*
  CASE:
  Target - out of node bounds
  AI - out of node bounds
    if( enemy_dist > 1.0 && combat_dist > 1.0 ){
*/
void() spg_fight_out_radius={
  if( enemy_vis == VIS_FAIL ){
    self.enemy = world;
    if(self.tether == TETHER_PATROL){
      self.ai_state_next = ST_PTR;
    }
    else{
      self.ai_state_next = ST_THR;
    }
    return;
  }
  if(self.ai_move_last == MOVE_STAND_FACE){
    self.ai_movedist = 10;
    self.ai_move_next = MOVE_NODE_RADIUS;
    return;
  }
  self.ai_move_next = MOVE_STAND_FACE;
  self.ai_movedist = 1 + (random() * (self.ai_rank * 1.25));
  return;
};
/*
  CASE:
  target obscured by friendly
    if( enemy_vis == VIS_FRN ){
*/
void() spg_fight_vis_friend={
  if( enemy_infront ){
    self.ai_movedist = 10;
    if( combat_dist < 0.4 ){
      self.ai_move_next = MOVE_BACK_LEFT;
      return;
    }
    if( combat_dist < 0.7 ){
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    if(self.ai_move_last == MOVE_STAND_FACE){
      if(combat_roll < 0.6){
        self.ai_move_next = MOVE_STRAFE_LEFT;
        return;
      }
      self.ai_move_next = MOVE_STRAFE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_STAND_FACE;
    self.ai_movedist = 3 + (random() * (self.ai_rank * 1.25));
    return;
  }
  if(combat_dist < 0.4){
    self.ai_movedist = 6;
    if(combat_roll < 0.6){
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE_RIGHT;
    return;
  }
  self.ai_move_next = MOVE_STAND_FACE;
  self.ai_movedist = 8;
};

/*
  CASE:
    target is a building...
*/
void() spg_fight_building={
  self.ai_move_next = MOVE_SNAPSHOT;
  self.ai_movedist = 2;
};

/*
  CASE:
    my node dist is in the green
*/
void() spg_fight_full={
  if(combat_dist < 0.6 ){
    if(enemy_range < 0.6){
      if(enemy_infront){
        self.ai_movedist = 3;
        if(combat_roll<0.6){
          self.ai_move_next = MOVE_BACK_RIGHT;
          return;
        }
        self.ai_move_next = MOVE_BACK_LEFT;
        return;
      }
      self.ai_movedist = 6;
      if(combat_roll<0.6){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    if(enemy_infront){
      self.ai_movedist = 4;
      self.ai_move_next = MOVE_SNAPSHOT;
      return;
    }
    self.ai_movedist = 10;
    if(combat_roll< 0.6){
      self.ai_move_next = MOVE_CHARGE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE_LEFT;
    return;
  }
  //
  if(enemy_range < 0.6){
    if(enemy_infront){
      self.ai_movedist = 3;
      if(combat_roll<0.6){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    self.ai_movedist = 4;
    self.ai_move_next = MOVE_SNAPSHOT;
    return;
  }
  self.ai_movedist = 8;
  self.ai_move_next = MOVE_SNAPSHOT;
};