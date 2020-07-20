/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish mechs are the basic mech behavior type in the game.
  the _fight file contains the code for combat-state movement.
*/

//AI is on edge of bounds but inside radius
void() mech_sk_fight_target_fire={
  if(combat_dist <= 0.33){
    self.ai_movedist = 5;
    if(combat_roll > 0.5){
      self.ai_move_next = MOVE_STRAFE_LEFT;
    }
    else{
      self.ai_move_next = MOVE_STRAFE_RIGHT;
    }
    return;
  }
  if(combat_dist >= 0.75){
    if(enemy_infront){
      self.ai_movedist = 2;
      if(combat_roll > 0.6){
        self.ai_move_next = MOVE_BACK_LEFT;
      }
      else{
        self.ai_move_next = MOVE_BACK_RIGHT;
      }
      return;
    }
    self.ai_movedist = self.ai_rank * 1.25;
    self.ai_move_next = MOVE_STAND_FACE;
    return;
  }
  self.ai_movedist = self.ai_rank * 2;
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
    if(self.tetherStatus == TETHER_PATROL){
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
  if( enemy_range < 0.25 ){
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
  self.ai_move_next = MOVE_SNAPSHOT;
  self.ai_movedist = 5;
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
  self.ai_movedist = 10;
  self.ai_move_next = MOVE_STAND_FACE;
};

void() mech_sk_fight_full={
  //CLOSE COMBAT
  if(combat_dist <= 0.4 ){
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
      self.ai_movedist = 5;
      if(combat_roll > 0.5){
        self.ai_move_next = MOVE_BACK_LEFT;
      }
      else{
        self.ai_move_next = MOVE_BACK_RIGHT;
      }
      return;
    }
    self.ai_movedist = random() * (self.ai_rank * 1.5);
    self.ai_move_next = MOVE_SNAPSHOT;
    return;
  }
  //---------------------------------
  //MID RANGE COMBAT
  if(combat_dist <= 0.7 ){
    if(enemy_infront){
      if( enemy_range <= 0.5 ){
        if( self.ai_rank == AI_RANK_ROK ){
          self.ai_movedist = 8;
          self.ai_move_next = MOVE_STAND_FACE;
          return;
        }
        if( self.ai_rank == AI_RANK_REG ){
          self.ai_movedist = 8;
          if( combat_roll < 0.6 ){
            self.ai_move_next = MOVE_BACK_LEFT;
          }
          else{
            self.ai_move_next = MOVE_BACK_RIGHT;
          }
          return;
        }
        if( combat_roll <=0.25 ){
          self.ai_movedist = 6;
          self.ai_move_next = MOVE_CIRCLE_RIGHT;
          return;
        }
        if( combat_roll <=0.5 ){
          self.ai_movedist = 6;
          self.ai_move_next = MOVE_STRAFE_LEFT;
          return;
        }
        if( combat_roll <=0.75 ){
          self.ai_movedist = 6;
          self.ai_move_next = MOVE_STRAFE_RIGHT;
          return;
        }
        self.ai_movedist = 6;
        self.ai_move_next = MOVE_CIRCLE_LEFT;
        return;
      }
      if( self.ai_rank == AI_RANK_ROK ){
        if( combat_roll > 0.33 ){
          self.ai_movedist = 3;
          self.ai_move_next = MOVE_STAND_FACE;
          return;
        }
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CHARGE;
        return;
      }
      if( combat_roll <= 0.25 ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CIRCLE_LEFT;
        return;
      }
      if( combat_roll <= 0.5 ){
        self.ai_movedist = 3;
        self.ai_move_next = MOVE_STRAFE_RIGHT;
        return;
      }
      if( combat_roll <= 0.75 ){
        self.ai_movedist = 3;
        self.ai_move_next = MOVE_STRAFE_LEFT;
        return;
      }
      self.ai_movedist = 5;
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
      return;
    }
    //enemy not in front;
    if(self.ai_rank==AI_RANK_ROK){
      if(combat_roll < 0.4 ){
        self.ai_movedist = 4;
        self.ai_move_next = MOVE_SNAPSHOT;
        return;
      }
      self.ai_movedist = 6;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    if(self.ai_rank < AI_RANK_ACE ){
      self.ai_movedist = 6;
      if( combat_roll <= 0.5 ){
        self.ai_move_next = MOVE_STRAFE_LEFT;
        return;
      }
      self.ai_move_next = MOVE_STRAFE_RIGHT;
      return;
    }
    self.ai_movedist = 4;
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
    if(enemy_range <= 0.33){
      if( combat_roll > 0.5 ){
        self.ai_movedist = 3;
        self.ai_move_next = MOVE_BACK_LEFT;
        return;
      }
      self.ai_movedist = 3;
      self.ai_move_next = MOVE_BACK_RIGHT;
      return;
    }
    if(enemy_range <= 0.6){
      if( combat_roll <= 0.25 ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CIRCLE_LEFT;
        return;
      }
      if( combat_roll <= 0.5 ){
        self.ai_movedist = 3;
        self.ai_move_next = MOVE_STRAFE_RIGHT;
        return;
      }
      if( combat_roll <= 0.75 ){
        self.ai_movedist = 3;
        self.ai_move_next = MOVE_STRAFE_LEFT;
        return;
      }
      self.ai_movedist = 5;
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
      return;
    }
    self.ai_movedist = 2 + (random()*self.ai_rank);
    self.ai_move_next = MOVE_STAND_FACE;
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
  self.ai_movedist = 10;
  self.ai_move_next = MOVE_STAND_FACE;
  return;
};