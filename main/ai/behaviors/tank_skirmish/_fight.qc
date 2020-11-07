/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish tanks are the basic behavior of tanks in the game,
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
void() tank_sk_fight_target_fire={
  //AI is on edge of bounds but inside radius
  if(combat_dist >= 0.75){
    if(enemy_infront){
      if(combat_roll > 0.6 || self.ai_rank > AI_RANK_REG){
        self.ai_move_next = MOVE_BACK;
        self.ai_movedist = 12;
      }
      else{
        self.ai_move_next = MOVE_STAND_FACE;
        self.ai_movedist = self.ai_rank;
      }
      return;
    }
    else{
      if( self.ai_rank > AI_RANK_REG ){
        self.ai_movedist = 10;
        if( combat_roll > 0.5 ){
          self.ai_move_next = MOVE_CHARGE_LEFT;
        }
        else{
          self.ai_move_next = MOVE_CHARGE_LEFT;
        }
        return;
      }
      self.ai_move_next = MOVE_CHARGE;
      self.ai_movedist = 15;
      return;
    }
  }
  else{
    if(combat_dist <= 0.33){
      self.ai_movedist = 15;
      if( combat_roll > 0.5 ){
        self.ai_move_next = MOVE_CHARGE_LEFT;
      }
      else{
        self.ai_move_next = MOVE_CHARGE_LEFT;
      }
      return;
    }
    self.ai_movedist = 8;
    if( combat_roll > 0.5 ){
      self.ai_move_next = MOVE_BACK_LEFT;
      return;
    }
    else{
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE;
    self.ai_movedist = 15;
  }
};

/*
  CASE:
  Target - out of node bounds
  AI - out of node bounds
    if( enemy_dist > 1.0 && combat_dist > 1.0 ){
*/
void() tank_sk_fight_out_radius={
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
  //both target and AI are out of bounds
  self.ai_move_next = MOVE_NODE_RADIUS;
};


/*
  CASE:
  target obscured by friendly
    if( enemy_vis == VIS_FRN ){
*/
void() tank_sk_fight_vis_friend={
  if( enemy_range < 0.25 ){
    if( enemy_infront ){
      self.ai_movedist = self.ai_rank * 1.2;
      if( combat_roll < 0.3 ){
        self.ai_move_next = MOVE_BACK;
        return;
      }
      if( combat_roll < 0.7 ){
        self.ai_move_next = MOVE_BACK_RIGHT;
        return;
      }
      self.ai_move_next = MOVE_BACK_LEFT;
      return;
    }
    self.ai_movedist = 8;
    if(combat_roll < 0.6){
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE_RIGHT;
  }
  if(enemy_infront){
    self.ai_movedist = self.ai_rank * 1.05;
    if(combat_roll < 0.6){
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_BACK_LEFT;
    return;
  }
  self.ai_movedist = self.ai_rank * 2;
  self.ai_move_next = MOVE_SNAPSHOT;
};


/*
  CASE:
    target is a building...
*/
void() tank_sk_fight_building={
  if(combat_dist < 0.5){
    if(enemy_infront){
      if(enemy_dist > 0.33){
        self.ai_movedist = self.ai_rank/2 + (random() * self.ai_rank);
        if( combat_roll > 0.5){
          self.ai_move_next = MOVE_CHARGE_LEFT;
        }
        else{
          self.ai_move_next = MOVE_CHARGE_RIGHT;
        }
        return;
      }
      self.ai_movedist = 10;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
  }
  self.ai_movedist = 10;
  self.ai_move_next = MOVE_STAND_FACE;
  return;
};


/*
  CASE:
    my node dist
*/
void() tank_sk_fight_full={
  local float nodeYaw;
  if(combat_dist < 0.4 ){
    if(enemy_infront){
      if( enemy_range > 0.25 ){
        self.ai_movedist = 20 * enemy_range;
      }
      else{
        self.ai_movedist = 5;
      }
      if( combat_roll < 0.25 ){
        self.ai_move_next = MOVE_CHARGE_LEFT;
        return;
      }
      if( combat_roll < 0.5 ){
        self.ai_move_next = MOVE_CHARGE;
        return;
      }
      if( combat_roll < 0.75 ){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      self.ai_move_next = MOVE_BACK;
      return;
    }
    self.ai_movedist = 15;
    if( combat_roll < 0.25 ){
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    if( combat_roll < 0.5 ){
      self.ai_move_next = MOVE_BACK;
      return;
    }
    if( combat_roll < 0.75 ){
      self.ai_move_next = MOVE_CHARGE_RIGHT;
      return;
    }
    self.ai_movedist = self.ai_rank + 2;
    self.ai_move_next = MOVE_STAND_FACE;
    return;
  }
  if(combat_dist < 0.7 ){
    if(enemy_infront){
      if( enemy_range < 0.5 ){
        self.ai_movedist = 10 * combat_dist;
        if( combat_roll < 0.25 ){
          self.ai_move_next = MOVE_CHARGE_LEFT;
          return;
        }
        if( combat_roll < 0.5 ){
          self.ai_move_next = MOVE_CHARGE_RIGHT;
          return;
        }
        if( combat_roll < 0.75 ){
          self.ai_move_next = MOVE_BACK_LEFT;
          return;
        }
        self.ai_move_next = MOVE_BACK_RIGHT;
        return;
      }
      self.ai_movedist = 20 * combat_dist;
      if( combat_roll < 0.6 ){
        self.ai_move_next = MOVE_CHARGE_LEFT;
        return;
      }
      self.ai_move_next = MOVE_CHARGE_RIGHT;
      return;
    }
    self.ai_movedist = combat_dist * 10 + self.ai_rank;
    self.ai_move_next = MOVE_STAND_FACE;
    return;
  }
  if(combat_dist < 1.0 ){
    if(enemy_infront){
      if(enemy_range > 0.2){
        nodeYaw = vectoyaw(self.patrolNode.origin - self.origin);
        self.ai_movedist = 12;
        if( nodeYaw > self.angles_y ){
          self.ai_move_next = MOVE_BACK_LEFT;
          return;
        }
        self.ai_move_next = MOVE_BACK_RIGHT;
        return;
      }
      if(enemy_range > 0.5){
        self.ai_movedist = 3;
        if( combat_roll < 0.4 ){
          self.ai_move_next = MOVE_CHARGE_LEFT;
          return;
        }
        if( combat_roll < 0.7 ){
          self.ai_move_next = MOVE_CHARGE_RIGHT;
          return;
        }
        self.ai_move_next = MOVE_CHARGE;
        return;
      }
      if(enemy_range > 1.0){
        if( combat_roll < 0.4 ){
          self.ai_movedist = 10;
          self.ai_move_next = MOVE_CHARGE_LEFT;
          return;
        }
        if( combat_roll < 0.7 ){
          self.ai_movedist = 10;
          self.ai_move_next = MOVE_CHARGE_RIGHT;
          return;
        }
        self.ai_movedist = self.ai_rank * 2;
        self.ai_move_next = MOVE_STAND_FACE;
        return;
      }
      self.ai_movedist = self.ai_rank * 1.15;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    //enemy's not in front
    if(enemy_range < 0.4){
      self.ai_movedist = 4;
      if( combat_roll > 0.25 ){
        nodeYaw = vectoyaw(self.patrolNode.origin - self.origin);
        self.ai_movedist = 10;
        if( self.angles_y <= nodeYaw ){
          self.ai_move_next = MOVE_BACK_LEFT;
          return;
        }
        self.ai_move_next = MOVE_BACK_RIGHT;
        return;
      }
      self.ai_movedist = self.ai_rank * 2;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    if(enemy_range < 0.7){
      self.ai_movedist = 15;
      if( combat_roll < 0.25 ){
        self.ai_move_next = MOVE_CHARGE_LEFT;
        return;
      }
      if( combat_roll < 0.5 ){
        self.ai_move_next = MOVE_CHARGE;
        return;
      }
      if( combat_roll < 0.75 ){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      self.ai_movedist = 15;
      self.ai_move_next = MOVE_BACK;
      return;
    }
    if(enemy_range > 1.0){
      self.ai_movedist = 20;
      self.ai_move_next = MOVE_CHARGE;
      return;
    }
  }
};
