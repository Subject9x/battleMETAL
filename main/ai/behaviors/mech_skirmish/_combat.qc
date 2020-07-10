/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish mechs are the basic mech behavior type in the game.
  the _combat file contains the state code for ST_COMBAT states.
*/

/*
float ST_COM_REACT            = 12;
*/

/*
  STATE : COMBAT START
    used to filter out what the AI should do before entering combat sub-system
*/
void() mech_sk_combat={
  local float roll;
  local entity prox;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
     cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      if( self.patrolNode ){
        self.goalentity = self.patrolNode;
        self.tetherStatus = TETHER_NODE;
        self.ai_state_next = ST_PTR;
        return;
      }
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      return;
    }
    
    
    if( (self.flags & FL_DISARMED) ){
      //TODO pain / flee
      return;
    }
    self.ai_state_next = ST_COM_MOVE_START;
    enemy_hunt = FALSE;
    /*
      Combat Frame State Checks
    */
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = self.stat_trg_dist;
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    
    local float targDist;
    local float myDist;
    local float distToTarg;
    
    targDist = ai_check_node_radius(self.enemy);
    myDist = ai_check_node_radius(self);
    distToTarg = ai_check_node_radius_targdist();
    
    cons_logAFloat("Line 61 -mech_sk_combat:targDist", targDist); //debug
    cons_logAFloat("Line 62 -mech_sk_combat:myDist", myDist); //debug
    cons_logAFloat("Line 63 -mech_sk_combat:distToTarg", distToTarg); //debug
    
    //out of bounds, do move override
    if(myDist > 1.0){
      //run
      self.ai_move_next = MOVE_NODE_RADIUS;
      cons_logAString("Line 72 -mech_sk_combat:NEXT MOVE","MOVE_NODE_RADIUS"); //debug
      return;
    }
    
    //AI is in bounds, but target is out of bounds
    if( targDist > 1 && myDist <= 1 ){
      //AI is on edge of bounds but inside radius
      if(myDist >= 0.75){
        cons_logAString("Line 81 -myDist >= 0.75","1"); //debug
        if(enemy_infront){
          if(roll > 0.6){
            self.ai_move_next = MOVE_BACK_LEFT;
            cons_logAString("L83 self.ai_move_next","MOVE_BACK_LEFT"); //debug
          }
          else{
            self.ai_move_next = MOVE_BACK_RIGHT;
            cons_logAString("L87 self.ai_move_next","MOVE_BACK_RIGHT"); //debug
          }
          return;
        }
        else{
          self.ai_movewait = self.ai_rank;
          self.ai_move_next = MOVE_STAND_FACE;
          return;
        }
      }
      else{
        if(myDist <= 0.67){
          if(roll > 0.5){
            self.ai_move_next = MOVE_STRAFE_LEFT;
            cons_logAString("L99 self.ai_move_next","MOVE_STRAFE_LEFT"); //debug
          }
          else{
            self.ai_move_next = MOVE_STRAFE_RIGHT;
            cons_logAString("L102 self.ai_move_next","MOVE_STRAFE_RIGHT"); //debug
          }
          return;
        }
        cons_logAString("Line 106 -self.ai_move_next","MOVE_STAND_FACE"); //debug
        self.ai_movewait = self.ai_rank;
        self.ai_move_next = MOVE_STAND_FACE;
        return;
      }
    }
    
    if( targDist > 1.0 && myDist > 1.0 ){
      if( enemy_vis == VIS_FAIL ){
        self.enemy = world;
        self.ai_state_next = ST_PTR;
        return;
      }
      //both target and AI are out of bounds
      cons_logAString("Line 120 -mech_sk_combat:"," targDist > 1.0 && myDist > 1.0"); //debug
      self.ai_move_next = MOVE_NODE_RADIUS;
      return;
    }
    
    //target < 1.0
    //myDist < 1.0
    //get fighting
    roll = random() * 1;
    self.ai_movedist = AI_RANGE_M * myDist;
    
    cons_logAString("Line 129 -mech_sk_combat:"," get fightin"); //debug
    if(myDist < 0.33 ){
      if(enemy_infront){
        if( roll > 0.5 ){
          self.ai_move_next = MOVE_CHARGE_LEFT;
          cons_logAString("133 self.ai_move_next","MOVE_CHARGE_LEFT"); //debug
          return;
        }
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        cons_logAString("137 self.ai_move_next","MOVE_CHARGE_RIGHT"); //debug
        return;
      }
      if(self.ai_rank > AI_RANK_REG){
        if(roll > 0.5){
          self.ai_move_next = MOVE_BACK_LEFT;
          cons_logAString("141 self.ai_move_next","MOVE_BACK_LEFT"); //debug
        }
        else{
          self.ai_move_next = MOVE_BACK_RIGHT;
          cons_logAString("145 self.ai_move_next","MOVE_BACK_RIGHT"); //debug
        }
        return;
      }
      self.ai_movewait = random() * self.ai_rank * 1.25;
      self.ai_move_next = MOVE_STAND_FACE;
      cons_logAString("154 self.ai_move_next","MOVE_STAND_FACE"); //debug
      return;
    }
    if(myDist < 0.66 ){
    
    }
    if(myDist < 1.0 ){
    
    }
    

    //self.ai_movedist = max((4 - self.ai_rank),1) * 2; //default move here, but can be overridden down the line.
    return;
  //---------------------------------------------------------------------------
  }
};

/*
  STATE : COMBAT FIGHTING
*/
void() mech_sk_com_moveStart={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    cons_logAFloat("ENTER[ST_COM_MOVE_START]",  self.ai_state_next); //debug
    cons_logAFloat("self.ai_move_next", self.ai_move_next); //debug

    self.ai_state_next = ST_COM_MOVE_EXEC;
    return;
  }
  //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER
*/
void() mech_sk_com_moveExec={
  local float nodeMove;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    cons_logAFloat("ENTER[ST_COM_MOVE_EXEC]",  self.ai_state_next); //debug
    cons_logAFloat("-----------------------MOVE NEXT",  self.ai_move_next); //debug
    return;
  }
  //------------------------------------------------------------------
  cons_logAFloat("-----------------------MOVE",  self.ai_move); //debug
  nodeMove = ai_check_node_radius(self);
  if(nodeMove > 0.95){
    self.ai_move_next = MOVE_NODE_RADIUS;
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
  if( self.ai_move != MOVE_PATROLNODE ){
    if( vlen(self.goalentity.origin - self.origin) > AI_RANGE_M ){
      self.ai_state_next = ST_COM_MOVE_START;
      self.ai_move_next = MOVE_NODE_RADIUS;
      return;
    }
    if( time > self.ai_movewait ){
      self.ai_state_next = ST_COM_MOVE_END;
      return;
    }
  }

};

/*
  STATE : COMBAT MANEUVER COMPLETED
*/
void() mech_sk_com_moveEnd={
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    cons_logAFloat("ENTER[ST_COM_MOVE_END]",  self.ai_state_next); //debug

    if( ai_valid_target(self.enemy) && ai_check_vis(self.enemy) != VIS_FAIL ){
      self.ai_state_next = ST_COMBAT;
      cons_logAFloat("continue the combat->ST_COMBAT",  self.ai_state_next); //debug
      return;
    }
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() mech_sk_com_blocked={
  local entity blockNode;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    cons_logAFloat("ENTER[ST_COM_MOVE_BLOCK]",  self.ai_state_next); //debug

    return;
  }
 //------------------------------------------------------------------
};
