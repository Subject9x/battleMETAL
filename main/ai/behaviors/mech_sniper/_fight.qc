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
  if(combat_dist <= 0.33){
    if(enemy_infront){
      self.ai_movedist = 7;
      if(combat_roll > 0.5){
        self.ai_move_next = MOVE_BACK_RIGHT;
      }
      else{
        self.ai_move_next = MOVE_BACK_LEFT;
      }
      return;
    }
      self.ai_movedist = 5;
      if(combat_roll > 0.5){
        self.ai_move_next = MOVE_STRAFE_LEFT;
      }
      else{
        self.ai_move_next = MOVE_STRAFE_RIGHT;
      }
      return;
  }
  if(combat_dist <= 0.67){
    self.ai_movedist = self.ai_rank * 1.5;
    if(enemy_infront){
      if(combat_roll > 0.5){
        self.ai_move_next = MOVE_BACK_RIGHT;
      }
      else{
        self.ai_move_next = MOVE_BACK_LEFT;
      }
      return;
    }
    if(combat_roll > 0.5){
      self.ai_move_next = MOVE_CHARGE_LEFT;
    }
    else{
      self.ai_move_next = MOVE_CHARGE_RIGHT;
    }
    return;
  }
  self.ai_movedist = 3;
  if(enemy_infront){
    if(combat_roll > 0.6){
      self.ai_move_next = MOVE_BACK_LEFT;
    }
    else{
      self.ai_move_next = MOVE_BACK_RIGHT;
    }
    return;
  }  
  if(combat_roll > 0.5){
    self.ai_move_next = MOVE_CIRCLE_LEFT;
  }
  else{
    self.ai_move_next = MOVE_CIRCLE_LEFT;
  }
  return;
};

/*
  CASE:
  Target - out of node bounds
  AI - out of node bounds
    if( enemy_dist > 1.0 && combat_dist > 1.0 ){
*/
void() mech_sniper_fight_out_radius={
  if( enemy_vis == VIS_FAIL ){
    self.enemy = world;
    if(self.tetherStatus == TETHER_PATROL){
      self.ai_state_next = ST_PTR;
    }
    else{
      self.ai_state_next = ST_THR;
    }
    return;
  }
  if(self.ai_move_last == MOVE_STAND_FACE){
    self.ai_movedist = 5;
    self.ai_move_next = MOVE_NODE_RADIUS;
    return;
  }
  self.ai_move_next = MOVE_STAND_FACE;
  self.ai_movedist = random() * (self.ai_rank * 1.25);
  return;
};

/*
  CASE:
  target obscured by friendly
    if( enemy_vis == VIS_FRN ){
*/
void() mech_sniper_fight_vis_friend={
  if( enemy_infront ){
    self.ai_movedist = 4;
    if( enemy_range < 0.4 ){
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    if( enemy_range < 0.7 ){
      self.ai_move_next = MOVE_BACK_LEFT;
      return;
    }
    if(combat_roll < 0.6){
      self.ai_move_next = MOVE_STRAFE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_STRAFE_LEFT;
    return;
  }
  self.ai_movedist = 6;
  if(enemy_range <= 0.4){
    if(combat_roll < 0.6){
      self.ai_move_next = MOVE_CHARGE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE_LEFT;
    return;
  }
  if(combat_roll < 0.6){
    self.ai_move_next = MOVE_STRAFE_RIGHT;
    return;
  }
  self.ai_move_next = MOVE_STRAFE_LEFT;
  return;

};

/*
  CASE:
    target is a building...
*/
void() mech_sniper_fight_building={
  if(combat_dist<0.6){
    if(enemy_range<0.6){
      if(enemy_infront){
        self.ai_movedist = 10;
        if(combat_roll<0.6){
          self.ai_move_next = MOVE_BACK_RIGHT;
          return;
        }
        self.ai_move_next = MOVE_BACK_LEFT;
        return;
      }
      self.ai_movedist = 10;
      self.ai_move_next = MOVE_SNAPSHOT;
      return;
    }
    if(enemy_infront){
      self.ai_movedist = 4;
      self.ai_move_next = MOVE_SNAPSHOT;
      return;
    }
    self.ai_movedist = 10;
    if(combat_roll<0.6){
      self.ai_move_next = MOVE_STRAFE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_STRAFE_LEFT;
    return;
  }
  if(enemy_range<0.6){
    if(enemy_infront){
      self.ai_movedist = 15;
      self.ai_move_next = MOVE_BACK;
      return;
    }
  }
  self.ai_movedist = 4;
  self.ai_move_next = MOVE_SNAPSHOT;
};

/*
  CASE:
    my node dist is in the green
*/
void() mech_sniper_fight_full={
  if(combat_dist < 0.6){
    if(enemy_range < 0.6){
      if( enemy_infront ){
        self.ai_movedist = 7;
        if(combat_roll < 0.6){
          self.ai_move_next = MOVE_STRAFE_RIGHT;
          return;
        }
        self.ai_move_next = MOVE_STRAFE_LEFT;
        return;
      }
      self.ai_movedist = 5;
      if(combat_roll < 0.6){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE;
    if(enemy_infront){
      self.ai_movedist = 5;
      return;
    }
    self.ai_movedist = 6;
    return;
  }
  if(enemy_range < 0.6){
    if(enemy_infront){
      self.ai_movedist = 5;
      if(combat_roll < 0.6){
        self.ai_move_next = MOVE_BACK_RIGHT;
        return;
      }
      self.ai_move_next = MOVE_BACK_LEFT;
      return;
    }
    self.ai_movedist = 5;
    if(combat_roll<0.6){
      self.ai_move_next = MOVE_STRAFE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_STRAFE_LEFT;
    return;
  }
  if(enemy_infront){
    if(combat_roll < 0.25){
      self.ai_movedist = 5;
      if(combat_roll < 0.1){
        self.ai_move_next = MOVE_STRAFE_RIGHT;
        return;
      }
      self.ai_move_next = MOVE_STRAFE_LEFT;
      return;
    }
    self.ai_movedist = 5;
    self.ai_move_next = MOVE_CHARGE;
    return;
  }
  if(enemy_infront){
    self.ai_movedist = 6;
    self.ai_move_next = MOVE_BACK;
    return;
  }
};