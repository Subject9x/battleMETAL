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
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_node_radius_targdist();
    enemy_dist = ai_check_node_radius(self.enemy);
    combat_dist = ai_check_node_radius(self);

    cons_logAFloat("Line 61 -mech_sk_combat:enemy_dist", enemy_dist); //debug
    cons_logAFloat("Line 62 -mech_sk_combat:combat_dist", combat_dist); //debug
    cons_logAFloat("Line 63 -mech_sk_combat:enemy_range", enemy_range); //debug
    
    //out of bounds, do move override
    if(combat_dist > 1.0){
      //run
      self.ai_move_next = MOVE_NODE_RADIUS;
      cons_logAString("Line 72 -mech_sk_combat:NEXT MOVE","MOVE_NODE_RADIUS"); //debug
      return;
    }
    
    roll = random() * 1;
    //AI is in bounds, but target is out of bounds
    if( enemy_dist > 1.0 && combat_dist <= 1.0){
      //AI is on edge of bounds but inside radius
      if(combat_dist >= 0.75){
        cons_logAString("Line 81 -combat_dist >= 0.75","1"); //debug
        if(enemy_infront){
          self.ai_movedist = 2;
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
        self.ai_movewait = self.ai_rank * 1.25;
        self.ai_move_next = MOVE_STAND_FACE;
        return;
      }
      if(combat_dist <= 0.33){
        self.ai_movedist = 5;
        if(roll > 0.5){
          self.ai_move_next = MOVE_STRAFE_LEFT;
          cons_logAString("95 self.ai_move_next","MOVE_STRAFE_LEFT"); //debug
        }
        else{
          self.ai_move_next = MOVE_STRAFE_RIGHT;
          cons_logAString("99 self.ai_move_next","MOVE_STRAFE_RIGHT"); //debug
        }
        return;
      }
      cons_logAString("Line 104 -self.ai_move_next","MOVE_STAND_FACE"); //debug
      self.ai_movedist = combat_dist * (8 * self.data_speed_forward);
      if(roll > 0.5){
        self.ai_move_next = MOVE_CHARGE_LEFT;
        cons_logAString("107 self.ai_move_next","MOVE_CHARGE_LEFT"); //debug
      }
      else{
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        cons_logAString("111 self.ai_move_next","MOVE_CHARGE_RIGHT"); //debug
      }
      return;
    }
    
    if( enemy_dist > 1.0 && combat_dist > 1.0 ){
      if( enemy_vis == VIS_FAIL ){
        self.enemy = world;
        self.ai_state_next = ST_PTR;
        return;
      }
      //both target and AI are out of bounds
      cons_logAString("Line 120 -mech_sk_combat:"," enemy_dist > 1.0 && combat_dist > 1.0"); //debug
      self.ai_move_next = MOVE_NODE_RADIUS;
      return;
    }
    
    if( enemy_vis == VIS_FRN ){
      if( enemy_range < 0.25 ){
        if( enemy_infront ){
          if( roll < 0.3 ){
            self.ai_move_next = MOVE_BACK;
            return;
          }
          if( roll < 0.7 ){
            self.ai_move_next = MOVE_BACK_LEFT;
            return;
          }
          self.ai_move_next = MOVE_BACK_RIGHT;
          return;
        }
      }
    }
    
    //target == building - those things don't really move or fight back...
    if(self.enemy.data_type == DATA_BLD){
      if(combat_dist < 0.5){
        if(enemy_infront){
          if(enemy_dist > 0.5){
            self.ai_movedist = 5;
            if(roll < 0.4){
              self.ai_move_next = MOVE_CHARGE;
              return;
            }
            if(roll < 0.7){
              self.ai_move_next = MOVE_CHARGE_LEFT;
              return;
            }
            self.ai_move_next = MOVE_CHARGE_RIGHT;
            return;
          }
          self.ai_movewait = 10;
          self.ai_move_next = MOVE_STAND_FACE;
          return;
        }
        else{
          //not in front
          if(enemy_dist > 0.5){
            self.ai_movewait = 4;
            self.ai_move_next = MOVE_STAND_FACE;
            return;
          }
          self.ai_movedist = 5;
          if(roll < 0.6){
            self.ai_move_next = MOVE_STRAFE_LEFT;
            return;
          }
          self.ai_move_next = MOVE_STRAFE_RIGHT;
          return;
        }
      }
      self.ai_movewait = 10;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    //target < 1.0
    //combat_dist < 1.0
    //get fighting
    cons_logAString("Line 129 -mech_sk_combat:"," get fightin"); //debug
    if(combat_dist < 0.33 ){
      if(enemy_infront){
        if( enemy_range > 0.25 ){
          self.ai_movedist = 14;
          if( roll > 0.5 ){
            self.ai_move_next = MOVE_CHARGE_LEFT;
            cons_logAString("133 self.ai_move_next","MOVE_CHARGE_LEFT"); //debug
            return;
          }
          self.ai_move_next = MOVE_CHARGE_RIGHT;
          cons_logAString("137 self.ai_move_next","MOVE_CHARGE_RIGHT"); //debug
          return;
        }
        self.ai_movedist = 7;
        self.ai_move_next =  MOVE_BACK;
        return;
      }
      if(self.ai_rank > AI_RANK_REG){
        self.ai_movedist = 5;
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
      self.ai_movewait = random() * (self.ai_rank * 1.5);
      self.ai_move_next = MOVE_STAND_FACE;
      cons_logAString("154 self.ai_move_next","MOVE_STAND_FACE"); //debug
      return;
    }
    if(combat_dist < 0.66 ){
      if(enemy_infront){
        if( enemy_range < 0.5 ){
          if( self.ai_rank == AI_RANK_ROK ){
            self.ai_movewait = 3;
            self.ai_move_next = MOVE_STAND_FACE;
            return;
          }
          if( self.ai_rank == AI_RANK_REG ){
            self.ai_movedist = 4;
            if( roll < 0.6 ){
              self.ai_move_next = MOVE_BACK_LEFT;
            }
            else{
              self.ai_move_next = MOVE_BACK_RIGHT;
            }
            return;
          }
        }
        if( self.ai_rank == AI_RANK_ROK ){
          if( roll > 0.33 ){
            self.ai_movewait = 5;
            self.ai_move_next = MOVE_STAND_FACE;
            return;
          }
          self.ai_movedist = 5;
          self.ai_move_next = MOVE_CHARGE;
          return;
        }
        if( roll < 0.25 ){
          self.ai_movedist = 8;
          self.ai_move_next = MOVE_CIRCLE_LEFT;
          return;
        }
        if( roll < 0.5 ){
          self.ai_movedist = 10;
          self.ai_move_next = MOVE_STRAFE_RIGHT;
          return;
        }
        if( roll < 0.75 ){
          self.ai_movedist = 10;
          self.ai_move_next = MOVE_STRAFE_LEFT;
          return;
        }
        self.ai_movedist = 8;
        self.ai_move_next = MOVE_CIRCLE_RIGHT;
        return;
      }
    }
    if(combat_dist < 1.0 ){
      if(enemy_infront){
        if(enemy_range > 0.33){
          if( roll > 0.5 ){
            self.ai_movedist = 3;
            self.ai_move_next = MOVE_BACK_LEFT;
            return;
          }
          self.ai_movedist = 3;
          self.ai_move_next = MOVE_BACK_RIGHT;
          return;
        }
        if(enemy_range > 0.6){
          if( roll < 0.25 ){
            self.ai_movedist = 8;
            self.ai_move_next = MOVE_CIRCLE_LEFT;
            return;
          }
          if( roll < 0.5 ){
            self.ai_movedist = 10;
            self.ai_move_next = MOVE_STRAFE_RIGHT;
            return;
          }
          if( roll < 0.75 ){
            self.ai_movedist = 10;
            self.ai_move_next = MOVE_STRAFE_LEFT;
            return;
          }
          self.ai_movedist = 8;
          self.ai_move_next = MOVE_CIRCLE_RIGHT;
          return;
        }
        if(enemy_range > 1.0){
          self.ai_movewait = 2 + (random()*self.ai_rank);
          self.ai_move_next = MOVE_STAND_FACE;
          return;
        }
      }
      //enemy's not in front
      if(enemy_range > 0.33){
        self.ai_movedist = 4;
        if( roll > 0.5 ){
          self.ai_move_next = MOVE_CIRCLE_LEFT;
          return;
        }
          self.ai_move_next = MOVE_CIRCLE_RIGHT;
          return;
      }
      if(enemy_range > 0.6){
        self.ai_movewait = 4;
        if( roll < 0.25 ){
          self.ai_move_next = MOVE_BACK_LEFT;
          return;
        }
        if( roll < 0.5 ){
          self.ai_move_next = MOVE_BACK_RIGHT;
          return;
        }
        self.ai_movewait = 8;
        if( roll < 0.75 ){
          self.ai_move_next = MOVE_CHARGE_LEFT;
          return;
        }
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
      if(enemy_range > 1.0){
        self.ai_movewait = 15;
        self.ai_move_next = MOVE_STAND_FACE;
        return;
      }
    }
    self.ai_move_next = MOVE_NODE_RADIUS;
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
  if( self.ai_move != MOVE_PATROLNODE && self.ai_move != MOVE_NODE_RADIUS ){
    nodeMove = ai_check_node_radius(self);
    if(nodeMove > 0.95){
      self.ai_move_next = MOVE_NODE_RADIUS;
      self.ai_state_next = ST_COM_MOVE_START;
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
    
    self.ai_state_next = ST_COMBAT;
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
    self.goalentity = self.patrolNode;
    self.ai_move_next = MOVE_NODE_RADIUS;
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
 //------------------------------------------------------------------
};
