/*
battleMETAL 
Author: Peter Roohr
Date: 06/30/2020
Overview: 
  just spinning about combat-specific funcs to a separate file.
  2 big pieces
    Combat Functions
    Combat State
      - standardized the combat sub-states into a single 
*/

/*
  Main AI attack function, called when AI's self.button0 = 1.
  Runs through AI's weapon list, and finds which are able to be fired, then calls that function.
*/
void() ai_ranged_attack={
  local entity wep_chain, this;
  local float fired;
  local vector diff;
  local float blockShot;
  
  self.ai_weaponEnergy = 0;
  this = self;
  self.v_angle = self.angles;
  if( (self.flags & FL_TURRET) ){
    //if the AI has a turret, use the turret's angles for Line of Sight offset origins.
    self.v_angle = self.torsoCenter.angles;
    diff = vectoangles( self.enemy.origin - self.cockpit.origin);
    self.v_angle_x = diff_x;
  }
  
  for( wep_chain = self.w_slot; wep_chain.owner == self; wep_chain = wep_chain.w_slot){
    if(self.button0){
      if(wep_chain.deadflag > DEAD_NO){
        continue;
      }
      if(wep_chain.wepReloadState != READY){
        continue;
      }
      if( !(self.currentWeaponGroup & wep_chain.w_group) ){
        continue;
      }
      if( !ai_check_face(this.enemy, 0.9, (self.flags&FL_TURRET)) ){
        continue;
      }
      if( ai_attack_blockcheck(wep_chain) ){
        blockShot = blockShot + 1;
        continue;
      }
      self = wep_chain;
        self.w_attack();
        fired = fired + 1;
      self = this;
    }
    else{
      if(wep_chain.deadflag > DEAD_NO){
        continue;
      }
      //Weapon has a bust-fire mode, and has been fired at least once, run through the burst.
      if(wep_chain.w_isburst != TRUE){
        continue;
      }
      if(wep_chain.wepReloadState != READY){
        continue;
      }
      self = wep_chain;
        self.w_attack();
      self = this;
    }
  }
  if( fired > 0 ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( self.trigOnAttack ){
        trigger_event( self.enemy, self.trigOnAttack );
        self.target = "";
      }
    }
  }
  if( blockShot >= fired ){
    self.combatFlags = TRUE;
  }
  else{
    self.combatFlags = FALSE;
  }
  self.currentWeaponGroup = 0;
};

/*
  Don't fire if the weapon's barrel is blocked by things like:
  non-target entity,
  friendlies
*/  
float(entity wep) ai_attack_blockcheck={
  local vector viewpont, vang;

  //ai v_angle already set by ai_ranged_attack
  vang = self.v_angle;
  
  if( self.enemy.data_type == DATA_BLD ){
    viewpont = normalize(self.enemy.hitOffset - wep.origin);
  }
  else{
    viewpont = normalize((self.enemy.origin + '0 0 5') - wep.origin);
  }
  
  makevectors( vang );
  tracebox (wep.origin + v_forward * 1, '-4 -4 -4', '4 4 4',wep.origin + viewpont*wep.w_range, (wep.damageType & EFF_ARC), self);

  if(trace_ent == world){
    return TRUE;
  }
  if(!trace_ent.takedamage){
    return TRUE;
  }
  if( trace_ent.faction == self.faction ){
    return TRUE;
  }
  
  //not sure what this does anymore
  /*if( (viewpont * v_forward) <= 0.99 ){
    return TRUE;
  }*/
  return FALSE;
};

/*
  Adjust AI's .accuracy setting based on movement
  TRUE = unit is moving, adjust self.accuracy up to spreadDefault_y (max)
  FALSE = unit is standing still, self.accuracy down to spreadDefault_x (min)
*/
void( float move ) ai_update_accuracy={
  local float rate;
  rate = self.spreadDefault_z;
  if( move ){      
    //unit is moving, increase spread factor
    rate = rate - self.accuracyMod;
    self.accuracy = self.accuracy + rate;
    if( self.accuracy > self.spreadDefault_y ){
      self.accuracy = self.spreadDefault_y;
    }
  }
  else{
    //standing still, lessen the spread
    rate = rate + self.accuracyMod;
    self.accuracy = self.accuracy - (rate * 2);
    if( self.accuracy < self.spreadDefault_x ){
      self.accuracy = self.spreadDefault_x;
    }
  }
};

float( float scan_mode) ai_check_scan={
  local float scanned;
  
  if( (self.spawnflags & UNARMED) ){
    return FALSE;
  }
  
  scanned = FALSE;
  if( time > self.ai_viewtime ){
    self.ai_viewtime = time + self.ai_viewcheck;
    if( scan_mode ){
      scanned = ai_find_target_radar();
    }
    else{
      scanned = ai_find_target_visual();
    }
  }
  return scanned;
};

void() ai_lock_on={
  //can only lock-on to enemy units
  if( self.enemy.faction != self.faction ){
    if( util_lockOnChoke(self.enemy.origin) ){
      if( !(self.targLockState & LOCK_TARG_START) && !(self.targLockState & LOCK_TARG_HAS) ){
        self.targLockState = self.targLockState | LOCK_TARG_START;
        self.power_timer_segment = time;
        if(self.stat_rdr_mode){
          self.lock_timer = time + self.w_firetime;
        }
        else{
          self.lock_timer = time + (self.w_firetime * 2);
        }
      }
      if( time > self.lock_timer ){
        if( !(self.targLockState & LOCK_TARG_HAS) ){
          self.targLockState = self.targLockState - LOCK_TARG_START;
          self.targLockState = self.targLockState | LOCK_TARG_HAS;
        }
      }
    }
    else{
      if( (self.targLockState & LOCK_TARG_START) ){
        self.targLockState = self.targLockState - LOCK_TARG_START;
      }
      if( (self.targLockState & LOCK_TARG_HAS) ){
        self.targLockState = self.targLockState - LOCK_TARG_HAS;
      }
      if( (self.enemy.targLockState & LOCK_PLAYER) ){
        self.enemy.targLockState = self.enemy.targLockState - LOCK_PLAYER;
      }
    }
  }
};

/*
  AI attempts to hold-off on making an attack until their accuracy is as best as
  it can be
*/
float( float bestAccuracy ) ai_wait_for_shot={
  if( self.accuracy <= bestAccuracy ){
    return TRUE;
  }
  return FALSE;
};

/*
  AI checks to see if it has enough energy to fire this weapon in relation
  to the total energy cost of ALL its energy weapons.
*/  
float(entity wep) ai_attack_checkEne={
  if( self.energy >= self.ai_weaponEnergy ){
    return TRUE;
  }
  return FALSE;
};

/*
  A more stateless implementation of the nodegraph state from earlier;
    if the AI arrives here, it merely checks if a path exists -
      if there's a path, run it,
      if no path, make a new one
*/

//generic
// targetDest, nextTargetDest, turnSpeed, walkSpeed, 

void() ai_nodegraph_combat_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float moveYaw;
  local float moveSpeed;
  
  if( self.nqLast != -1 ){
    ai_nodegraph_check_lastnode();
  }
  
  if( self.nq1 == -1 ){
    //fresh path
    ai_nodegraph_clear_locks();
    ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
  }
  else{
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nodeDist = ai_check_dist_node(self.origin, nqOrg);
    if( nodeDist <= 8 ){
      //arrived at node
      //check for pause first
      if( ai_check_pause() ){
        self.ai_fight_pause = TRUE;
      }
      else{
        pathFind = ai_nodegraph_next();
        if( !pathFind ){
          ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
        }
      }
    }
    else{ 
      if( !self.ai_last_pathWait ){
        self.moveState = MOVE_NORM;
        if( self.legs ){
          self.legs.attack_state = TR_NORM;
        }
        self.yawCache = self.yaw_speed;
        moveSpeed = self.data_speed_forward;
        //still traveling to node
        self.ideal_yaw = vectoyaw(nqOrg - self.origin);
        
        //check yaw-to-node
        if( self.angles_y != self.ideal_yaw ){
          moveSpeed = self.data_speed_strafe;
          
          //yaw is too wide, stop moving and just pivot to node
          moveYaw = anglemod(self.angles_y - self.ideal_yaw);
          if( moveYaw > 15 && moveYaw < 345 ){
            self.moveState = MOVE_STAND;
            moveSpeed = 0;
            if( self.legs ){
              self.legs.attack_state = TR_NORM;
            }
            self.yaw_speed = self.yaw_speed * 2;
          }
          else{
            if( moveYaw > 10 && moveYaw < 350){
              moveSpeed = moveSpeed * 0.5;  //0.2
            }
            else if( moveYaw > 5 && moveYaw < 355 ){
              moveSpeed = moveSpeed * 0.75;  //0.5
            }
            self.yaw_speed = self.yaw_speed * 1.5;
          }
          ChangeYaw();
          self.yaw_speed = self.yawCache;
        }
      }
      if( self.ai_last_pathWait ){
        if( time > self.ai_timer_pathWait ){
          self.ai_last_pathWait = FALSE;
          self.ai_timer_pathWait = time + 1;
          pathFind = ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
          if( pathFind ){
            self.moveState = MOVE_NORM;
          }
        }
        else{
          self.moveState = MOVE_STAND;
        }
      }
      else{
        moveSpeed = ai_check_slope(self.angles_y, moveSpeed);
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          if( ai_valid_target(self.enemy) ){
            if( time > self.ai_timer_pathWait ){
              if( ai_check_vis(self.enemy) != VIS_FAIL ){
                self.ai_last_pathWait = TRUE;
                self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
              }
            }
          }
          else{
            pathFind = ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
          }
        }
      }
    }
  }
};

/*
  Special brawler frame - priotizes enemy.position1 so as to give a feeling that the bot is flanking the target.
  
*/
void() ai_nodegraph_combat_brawler_frame={
  local float pathFind;
  local float nodeDist;
  local vector nqOrg;
  local float moveYaw;
  local float moveSpeed;
  
  if( self.nqLast != -1 ){
    ai_nodegraph_check_lastnode();
  }
  
  if( self.nq1 == -1 ){
    ai_nodegraph_clear_locks();
    //fresh path
    ai_nodegraph_trace_vec( self.origin, self.enemy.position1 );
  }
  else{
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
      self.moveState = MOVE_NORM;
    }
    nqOrg = nodegraph_get_node_origin( self.nq1 );
    nodeDist = ai_check_dist_node(self.origin, nqOrg);
    
    if( self.ai_path_tries > 3 ){
      
    }
    
    if( nodeDist <= 8 ){
      //arrived at node
      //check for pause first
      if( ai_check_pause() ){
        self.ai_fight_pause = TRUE;
      }
      else{
        pathFind = ai_nodegraph_next();
        if( !pathFind ){
          ai_nodegraph_trace_vec( self.origin, self.enemy.position1 );
        }
      }
    }
    else{
      if( !self.ai_last_pathWait ){
        self.moveState = MOVE_NORM;
        if( self.legs ){
          self.legs.attack_state = TR_NORM;
        }
        moveSpeed = self.data_speed_forward;
        
        //still traveling to node
        self.ideal_yaw = vectoyaw(nqOrg - self.origin);
        
        //check yaw-to-node
        if( self.angles_y != self.ideal_yaw){
          self.yawCache = self.yaw_speed;
          moveSpeed = self.data_speed_strafe;
          //yaw is too wide, stop moving and just pivot to node
          moveYaw = anglemod(self.angles_y - self.ideal_yaw);
          if( moveYaw > 15 && moveYaw < 345 ){
            self.moveState = MOVE_STAND;
            moveSpeed = 0;
            if( self.legs ){
              self.legs.attack_state = TR_NORM;
            }
            self.yaw_speed = self.yaw_speed * 3;
          }
          else{
            if( moveYaw > 10 && moveYaw < 350){
              moveSpeed = moveSpeed * 0.55; //0.33
            }
            else if( moveYaw > 5 && moveYaw < 355 ){
              moveSpeed = moveSpeed * 0.8; //0.67
            }
            self.yaw_speed = self.yaw_speed * 2;
          }
          ChangeYaw();
          self.yaw_speed = self.yawCache;
        }
      }
      
      if( self.ai_last_pathWait ){
        if( time > self.ai_timer_pathWait ){
          self.ai_last_pathWait = FALSE;
          self.ai_timer_pathWait = time + 1;
          pathFind = ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
          if( pathFind ){
            self.ai_path_tries = 0;
            self.moveState = MOVE_NORM;
          }
          else{
            self.ai_path_tries = self.ai_path_tries + 1;
          }
        }
        else{
          self.moveState = MOVE_STAND;
        }
      }
      else{
        moveSpeed = ai_check_slope(self.angles_y, moveSpeed);
        if( walkmove(self.angles_y, moveSpeed) == FALSE ){
          if( ai_valid_target(self.enemy) ){
            if( time > self.ai_timer_pathWait ){
              if( ai_check_vis(self.enemy) != VIS_FAIL ){
                self.ai_last_pathWait = TRUE;
                self.ai_timer_pathWait = time + (0.5 + random() * 1.0);
              }
            }
          }
          else{
            pathFind = ai_nodegraph_trace_vec( self.origin, self.enemy.origin );
          }
        }
      }
    }
  }
};