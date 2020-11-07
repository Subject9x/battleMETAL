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
      if( ai_attack_blockcheck(wep_chain) ){
        continue;
      }
      if( !ai_check_face(this.enemy, 0.85, (self.flags&FL_TURRET)) ){
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
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
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

void(float dst, float grp, float bracket) ai_wep_group_track={
  if( dst <= bracket ){
    self.currentWeaponGroup = self.currentWeaponGroup | grp;
  }
  else{
    self.currentWeaponGroup = self.currentWeaponGroup - self.currentWeaponGroup & grp;
  }
};


/*
  ST_COMBAT
  STATE : COMBAT START
    used to filter out what the AI should do before entering combat sub-system
*/
void() ai_combat_start={
  local float pathFind;
  local float nearNode;
  local float pathExec;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      if( self.tether == TETHER_NODE ){
        self.ai_state_next = ST_THR;
        return;
      }
      if( self.tether == TETHER_PATROL ){
        self.ai_state_next = ST_PTR;
        return;
      }
      if( self.tether == TETHER_SELF ){
        //todo 
      }
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      return;
    }
    
    //todo - disarmed?
    if( (self.flags & FL_DISARMED) ){
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      return;
    }
    
    /*
      TODO
      Fight script determines the MOVE_ to make
        MOVE_STAND
        
        MOVE_TRACK_TARGET
        
        MOVE_STRAFE_LEFT
        
        MOVE_STRAFE_RIGHT
        
        MOVE_FLANK_LEFT
        
        MOVE_FLANK_RIGHT
        
        MOVE_FLANK_REAR
        
        MOVE_RETREAT
    */
    //you better hope its loaded...
    if( NODEGRAPH_LOADED ){
      pathFind = -1;
      if( self.ai_fight_script ){
        self.ai_move_next = self.ai_fight_script();
        dprint(sprintf("fight script %f\n", self.ai_move_next));  //debug
      }
      else{
        pathFind = ai_nodegraph_attack_node_close( self.enemy.origin, 1024, 90, FALSE ); //debug - this will be the 'scriptable' part of the combat funcs
        dprint(sprintf("ai_combat_start().pathFind %f \n", pathFind));  //debug
        //pathFind == found node id from data set
        if( !pathFind || pathFind == -1 ){
          self.ai_state_next = ST_COM_MOVE_BLOCK;
          return;
        }
        nearNode = ai_nodegraph_to_org(self.origin);
        if( nearNode == -1 ){
          self.ai_state_next = ST_COM_MOVE_BLOCK;
          return;
        }
        pathExec = ai_nodegraph_trace_route( nearNode, pathFind );
        dprint(sprintf("ai_combat_start().pathExec %u \n", pathExec));  //debug
        if( pathExec == FALSE ){
          self.ai_state_next = ST_COM_MOVE_BLOCK;
          return;
        }
      }
      self.ai_state_next = ST_COM_MOVE_START;
    }
    return;
  //---------------------------------------------------------------------------
  }
  //can't find WHY its sometimes ending up here, but it is.
  self.ai_state_last = 0;
  self.ai_state_next = ST_COMBAT;
};

/*
  STATE : COMBAT FIGHTING
  ST_COM_MOVE_START
*/
void() ai_com_moveStart={
  local vector nqOrg;
  local float nodeYaw;
  local float nodeExec;
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_move = self.ai_move_next;
    
    //CHECK - HUNTING
    if( self.ai_move == MOVE_NEXT_HUNT ){
      self.ai_state_next = ST_HUNT;
      return;
    }
    
    ai_attack();
  
    //CHECK - NON NODE MOVES
    if( self.ai_move == MOVE_NEXT_STAND ){
      self.ai_movewait = time + 5;
    }
    else if( self.ai_move == MOVE_NEXT_TRACK ){
      self.ai_movewait = time + 10;
    }
    else{
      switch(self.ai_move){
        case MOVE_NEXT_STRAFE_LEFT:
          nodeExec = ai_nodegraph_attack_strafe_left( self.enemy.origin, 768 );
          if( !nodeExec ){
            nodeExec = ai_nodegraph_attack_flank_right( self.enemy.origin, 1024 );
          }
          break;
        case MOVE_NEXT_STRAFE_RIGHT:
          nodeExec = ai_nodegraph_attack_strafe_right( self.enemy.origin, 768);
          if( !nodeExec ){
            nodeExec = ai_nodegraph_attack_flank_left( self.enemy.origin, 1024 );
          }
          break;
        case MOVE_NEXT_FLANK_REAR:
          nodeExec = ai_nodegraph_attack_flank_rear( self.enemy.origin, 2048 );
          break;
        case MOVE_NEXT_FLANK_LEFT:
          nodeExec = ai_nodegraph_attack_flank_left(self.enemy.origin, 1024 );
          break;
        case MOVE_NEXT_FLANK_RIGHT:
          nodeExec = ai_nodegraph_attack_flank_right( self.enemy.origin, 1024 );
          break;
        case MOVE_NEXT_RETREAT:
          nodeExec = ai_nodegraph_retreat( self.enemy.origin, 1024 );
          break;
        case MOVE_NEXT_FORWARD:
          nodeExec = ai_nodegraph_attack_charge( self.enemy.origin, 2048 );
          break;
        case MOVE_NEXT_FOR_LEFT:
          nodeExec = ai_nodegraph_free_move( -67, 1024, 768 );
          break;
        case MOVE_NEXT_FOR_RIGHT:
          nodeExec = ai_nodegraph_free_move( 67, 1024, 768 );
          break;
      }
      if( !nodeExec ){
        self.ai_move = MOVE_NEXT_TRACK;
      }
    }
    self.ai_state_next = ST_COM_MOVE_EXEC;
    return;
  }
  //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER
  ST_COM_MOVE_EXEC
*/
void() ai_com_moveExec={
  local float checkVis;
  
  local float nodeMove;
  local entity nodeCheck;
  local float nodeYaw;
  
  local float dist;
  local float walkSpeed;
  local vector nqOrg;
  local float turnSpeed;
  local float pathFind;
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    if( (self.flags & FL_TURRET) ){
      //TODO - face target
      //self.torsoCenter.attack_state = TR_NORM;
    }
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
    }
  }
  //-----------------------------------------------------------------
  
  checkVis = ai_check_vis(self.enemy);
  if( checkVis != VIS_FRAC || checkVis != VIS_FRN ){
    self.ai_state_next = ST_HUNT;
    return;
  }
  ai_attack();
  
  if( self.ai_move == MOVE_NEXT_STAND ){
    ai_update_accuracy( FALSE );
    self.moveState = 0;
    //todo dead enemy check
    if( time > self.ai_movewait ){
      self.ai_state_next = ST_COM_MOVE_END;
    }
    return;
  }
  else if( self.ai_move == MOVE_NEXT_TRACK ){
    ai_update_accuracy( FALSE );
    self.moveState = 0;
    ai_face_targ();
    //todo dead enemy check
    if( time > self.ai_movewait ){
      self.ai_state_next = ST_COM_MOVE_END;
    }
    return;
  }
  
  self.moveState = MOVE_NORM;
  
  ai_update_accuracy( TRUE );
  
  if( self.nq1 == -1){
    dprint("ai_state_nodegraph_travel() nq1 == -1!\n");  //debug
    self.ai_state_next = ST_COMBAT;
    return;
  }
  
  nqOrg = nodegraph_get_node_origin( self.nq1 );
  //dprint(sprintf("curret node: %f\n", self.nq1));
  //dprint(sprintf("curret origin: %f %f %f\n", nqOrg_x, nqOrg_y, nqOrg_z));
  nodeYaw = vectoyaw(nqOrg - self.origin);
  if( nodeYaw != self.angles_y ){
    self.ideal_yaw = vectoyaw(nqOrg - self.origin) ;
    yawCache = self.yaw_speed;
    self.yaw_speed = self.yaw_speed * 2;
    ChangeYaw();  //double 
    self.yaw_speed = yawCache;
    turnSpeed = TRUE;
  }

  //not at node yet, keep moving.
  if( turnSpeed || self.reverseFlag ){
    walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 3;
  }
  else{
    walkSpeed = self.data_speed_forward * 0.85;
  }
  
  if( walkmove(self.angles_y, walkSpeed) == FALSE ){
    dprint(sprintf("class %s\n", self.classname));
    dprint("TODO blocked in ai_state_nodegraph_travel() \n");  //debug
    //-> set self.ai_blockflag = time + X
    //check for timeout in THIS state first
    self.ai_state_next = ST_COM_MOVE_BLOCK;
    return;
  }

  //ARRIVED AT NODE
  dist = vlen(nqOrg - self.origin);
  if( dist <= 32 ){
    self.ai_state_next = ST_COM_MOVE_END;
    return;
  }
};

/*
  STATE : COMBAT MANEUVER COMPLETED
  use this as a ramp to check node path too
*/
void() ai_com_moveEnd={
  local float nodeLen;
  local float pathFind;
  local float checkVis;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    self.reverseFlag = FALSE;
    //early exit if target dead
    if( !ai_valid_target(self.enemy) ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    checkVis = ai_check_vis(self.enemy);
    if( checkVis != VIS_FRAC || checkVis != VIS_FRN ){
      self.ai_state_next = ST_HUNT;
      return;
    }
    ai_attack();
    
    if( self.ai_move == MOVE_NEXT_STAND ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    else if( self.ai_move == MOVE_NEXT_TRACK ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //null node id error check.
    if(self.nq1 == -1){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //release node lock
    NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE;
    
    //at verified end of path
    if( self.pathEndId == self.nq1 ){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //end of path BUT not desired destination
    if( self.nq2 == -1 ){
      dprint("AI - failed to see patrol node, pathfinding!\n");
      pathFind = ai_nodegraph_trace_vecToNode( self.origin, self.pathEndId );
      if( pathFind ){
        self.ai_state_next = ST_COM_MOVE_START;
        dprint("travel complete->ST_COM_MOVE_START \n");  //debug
        return;
      }
      self.ai_state_next = ST_COMBAT;
      return;
    }
    
    //end of path, ready to go again
    pathFind = ai_nodegraph_next();
    if( pathFind ){
      dprint(sprintf("ai_combat() path next: %f\n", self.nq2));
      self.ai_state_next = ST_COM_MOVE_START;
      return;
    }
    self.ai_state_next = ST_COMBAT;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: COMBAT POST NODE MOVE
    move was successful
*/



/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() ai_com_blocked={
  local float pathFind;
  local float checkVis;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    
    pathFind = ai_nodegraph_trace_vecToNode( self.origin, self.pathEndId );
    if(pathFind){
      self.ai_state_next = ST_COM_MOVE_START;
      return;
    }
    self.ai_movewait = time + 5;
    return;
  }
 //------------------------------------------------------------------
  if( self.enemy != world ){
    checkVis = ai_check_vis( self.enemy );
    if( checkVis == VIS_FRAC || checkVis == VIS_FRN ){
      ai_face_targ();
      ai_attack();
    }
    else{
      ai_face_targ_fade();
      ai_attack();
    }
  }
  
  if( time > self.ai_movewait ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
};
