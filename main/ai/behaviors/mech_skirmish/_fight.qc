/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish mechs are the basic mech behavior type in the game.
  the _fight file contains the code for combat-state movement.
  
  external globals
    float enemy_infront;  //boolean, on-this-frame check if target is in AI's forward arc.
    float enemy_range;    //distance to AI relative to patrolNode.ai_view (radius)
    float enemy_vis;      //enum, Line of Sight to target
    float enemy_dist;     //target's distance to patrolNode
    float combat_dist;    //AI's distance to its patrolNode
    float combat_roll;    //per-state-frame dice roll for random movement selection.
*/

float() mech_sk_fight_script_easy={
  if( (self.combatFlags & COMBAT_CLOSE) ){
  //COMBAT RANGE <= 300 --------------------------------------------------------
    if( (self.combatFlags & COMBAT_VIS) ){
      if( (self.combatFlags & COMBAT_FRONT) ){
        if( combat_roll < 0.4 ){
          return MOVE_NEXT_STRAFE_LEFT;
        }
        else if( combat_roll < 0.7 ){
          return MOVE_NEXT_STRAFE_RIGHT;
        }
        return MOVE_NEXT_RETREAT;
      }
    }
    return MOVE_NEXT_HUNT;
  //=============================================================================
  }
  else if( (self.combatFlags & COMBAT_MID) ){
  //COMBAT RANGE > 300   --------------------------------------------------------
    if( (self.combatFlags & COMBAT_VIS) ){
      if( (self.combatFlags & COMBAT_FRONT) ){
        if( combat_roll < 0.3 ){
          return MOVE_NEXT_STRAFE_LEFT;
        }
        else if( combat_roll < 0.6 ){
          return MOVE_NEXT_STRAFE_RIGHT;
        }
        else if( combat_roll < 0.8 ){
          return MOVE_NEXT_FLANK_LEFT;
        }
        return MOVE_NEXT_FLANK_RIGHT;
      }
    }
    return MOVE_NEXT_HUNT;
  //=============================================================================
  }
  else if( (self.combatFlags & COMBAT_LONG) ){
  //COMBAT RANGE > AI_MINRANGE----------------------------------------------------
    if( (self.combatFlags & COMBAT_VIS) ){
      if( (self.combatFlags & COMBAT_FRONT) ){
        if( combat_roll < 0.5 ){
        
        }
        return MOVE_NEXT_FORWARD;
      }
    }
    return MOVE_NEXT_HUNT;
  //=============================================================================
  }
  return MOVE_NEXT_STAND;
};


float() mech_sk_fight_script_med={

};

float() mech_sk_fight_script_hard={

};

//AI is on edge of bounds but inside radius
void() mech_sk_fight_target_fire={
  self.ai_movedist = 4;
  if(combat_dist <= 0.33){
    if(combat_roll > 0.5){
      self.ai_move_next = MOVE_STRAFE_LEFT;
    }
    else{
      self.ai_move_next = MOVE_STRAFE_RIGHT;
    }
    return;
  }
  if(combat_dist <= 0.67){
    self.ai_movedist = 4;
    if(enemy_infront){
      if(combat_roll > 0.6){
        self.ai_move_next = MOVE_BACK_LEFT;
      }
      else{
        self.ai_move_next = MOVE_BACK_RIGHT;
      }
      return;
    }
    self.ai_move_next = MOVE_BACK;
    return;
  }
  if(combat_roll > 0.5){
    self.ai_move_next = MOVE_CHARGE_LEFT;
  }
  else{
    self.ai_move_next = MOVE_CHARGE_RIGHT;
  }
};

void() mech_sk_fight_out_radius={
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
  return;
};

void() mech_sk_fight_vis_friend={
  if( enemy_range <= 0.25 ){
    if( enemy_infront ){
      self.ai_movedist = self.ai_rank * 1.2;
      if( combat_roll < 0.4 ){
        self.ai_move_next = MOVE_BACK;
        return;
      }
      if( combat_roll < 0.7 ){
        self.ai_move_next = MOVE_BACK_LEFT;
        return;
      }
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    //enemy not in front
    self.ai_movedist = 4;
    if(combat_roll<0.6){
      self.ai_move_next = MOVE_STRAFE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_STRAFE_LEFT;
    return;
  }
  //range > 0.25
  if(enemy_infront){
    self.ai_movedist = 8;
    if(combat_roll<0.6){
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE_LEFT;
    return;
  }
  self.ai_movedist = 10;
  if(combat_roll<0.6){
    self.ai_move_next = MOVE_CHARGE_LEFT;
    return;
  }
  self.ai_move_next = MOVE_CIRCLE_RIGHT;
  return;
};

void() mech_sk_fight_building={
  if(combat_dist <= 0.5){
    if(enemy_infront){
      if(enemy_dist > 0.5){
        self.ai_movedist = 5;
        if(combat_roll < 0.4){
          self.ai_move_next = MOVE_CHARGE;
          return;
        }
        if(combat_roll < 0.7){
          self.ai_move_next = MOVE_CHARGE_LEFT;
          return;
        }
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      self.ai_movedist = 10;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
     //not in front
    if(enemy_dist > 0.5){
      self.ai_movedist = 4;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    self.ai_movedist = 5;
    if(combat_roll < 0.6){
      self.ai_move_next = MOVE_STRAFE_LEFT;
      return;
    }
    self.ai_move_next = MOVE_STRAFE_RIGHT;
    return;
  }
  self.ai_movedist = 4;
  self.ai_move_next = MOVE_BACK;
};

void() mech_sk_fight_full={
  //CLOSE COMBAT
  if(combat_dist < 0.4 ){
    if(enemy_infront){
      if( enemy_range > 0.25 ){
        self.ai_movedist = 5;
        if( combat_roll > 0.5 ){
          self.ai_move_next = MOVE_CHARGE_LEFT;
          return;
        }
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      self.ai_movedist = 7;
      self.ai_move_next =  MOVE_BACK;
      return;
    }
    if(self.ai_rank > AI_RANK_REG){
      self.ai_movedist = 3;
      if(combat_roll > 0.5){
        self.ai_move_next = MOVE_BACK_LEFT;
      }
      else{
        self.ai_move_next = MOVE_BACK_RIGHT;
      }
      return;
    }
    self.ai_movedist = 3;
    self.ai_move_next = MOVE_CHARGE;
    return;
  }
  //---------------------------------
  //MID RANGE COMBAT
  if(combat_dist < 0.7 ){
    if(enemy_infront){
      if( enemy_range <= 0.5 ){
        self.ai_movedist = self.ai_rank * 1.25;
        if( combat_roll <= 0.25 ){
          self.ai_move_next = MOVE_CIRCLE_RIGHT;
          return;
        }
        if( combat_roll <= 0.5 ){
          self.ai_move_next = MOVE_STRAFE_LEFT;
          return;
        }
        if( combat_roll <= 0.75 ){
          self.ai_move_next = MOVE_STRAFE_RIGHT;
          return;
        }
        self.ai_move_next = MOVE_CIRCLE_LEFT;
        return;
      }
      self.ai_movedist = self.ai_rank * 1.5;
      if( self.ai_rank == AI_RANK_ROK ){
        self.ai_move_next = MOVE_CHARGE;
        return;
      }
      if( combat_roll <= 0.25 ){
        self.ai_move_next = MOVE_CIRCLE_LEFT;
        return;
      }
      if( combat_roll <= 0.5 ){
        self.ai_move_next = MOVE_STRAFE_RIGHT;
        return;
      }
      if( combat_roll <= 0.75 ){
        self.ai_move_next = MOVE_STRAFE_LEFT;
        return;
      }
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
      return;
    }
    //enemy not in front;
    self.ai_movedist = self.ai_rank * 2;
    if( combat_roll < 0.4 ){
      self.ai_move_next = MOVE_CHARGE_RIGHT;
      return;
    }
    if( combat_roll < 0.7 ){
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE;
    return;
  }
  //---------------------------------
  //FAR COMBAT
  if(enemy_infront){
    if(enemy_range < 0.4){
      self.ai_movedist = 3;
      if( combat_roll > 0.5 ){
        self.ai_move_next = MOVE_BACK_LEFT;
        return;
      }
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    if(enemy_range < 0.7){
      self.ai_movedist = self.ai_rank * 2;
      if( combat_roll <= 0.25 ){
        self.ai_move_next = MOVE_CIRCLE_LEFT;
        return;
      }
      if( combat_roll <= 0.5 ){
        self.ai_move_next = MOVE_STRAFE_RIGHT;
        return;
      }
      if( combat_roll <= 0.75 ){
        self.ai_move_next = MOVE_STRAFE_LEFT;
        return;
      }
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
      return;
    }
    self.ai_movedist = self.ai_rank * 2;
    self.ai_move_next = MOVE_BACK;
    return;
  }
  //enemy's not in front
  if(enemy_range < 0.4){
    self.ai_movedist = 4;
    if( combat_roll > 0.5 ){
      self.ai_move_next = MOVE_CIRCLE_LEFT;
      return;
    }
    self.ai_move_next = MOVE_CIRCLE_RIGHT;
    return;
  }
  if(enemy_range < 0.7){
    self.ai_movedist = 3;
    if( combat_roll <= 0.25 ){
      self.ai_move_next = MOVE_BACK_LEFT;
      return;
    }
    if( combat_roll <= 0.5 ){
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    self.ai_movedist = 6;
    if( combat_roll <= 0.75 ){
      self.ai_move_next = MOVE_CHARGE_LEFT;
      return;
    }
    self.ai_move_next = MOVE_CHARGE_RIGHT;
    return;
  }
  self.ai_movedist = 5;
  self.ai_move_next = MOVE_CHARGE;
};