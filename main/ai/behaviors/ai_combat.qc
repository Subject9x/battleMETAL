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
      if(wep_chain.w_state != READY){
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
      //Weapon has a bust-fire mode, and has been fired at least once, run through the burst.
      if(wep_chain.w_isburst != TRUE){
        continue;
      }
      if(wep_chain.w_state != READY){
        continue;
      }
      self = wep_chain;
        self.w_attack();
      self = this;
    }
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
      if( !(self.stat_lck_stt & LOCK_TARG_START) && !(self.stat_lck_stt & LOCK_TARG_HAS) ){
        self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG_START;
        self.power_timer_segment = time;
        if(self.stat_rdr_mode){
          self.lock_timer = time + self.w_firetime;
        }
        else{
          self.lock_timer = time + (self.w_firetime * 2);
        }
      }
      if( time > self.lock_timer ){
        if( !(self.stat_lck_stt & LOCK_TARG_HAS) ){
          self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG_START;
          self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG_HAS;
        }
      }
    }
    else{
      if( (self.stat_lck_stt & LOCK_TARG_START) ){
        self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG_START;
      }
      if( (self.stat_lck_stt & LOCK_TARG_HAS) ){
        self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG_HAS;
      }
      if( (self.enemy.stat_lck_stt & LOCK_PLAYER) ){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - LOCK_PLAYER;
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

*/

/*
  STATE : COMBAT START
    used to filter out what the AI should do before entering combat sub-system
*/
void() ai_combat_start={
  local entity prox;
  
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
    
    //check if target is blown up in between frames
    if( !ai_valid_target(self.enemy) ){
      //AI no longer has target, so execute stand behavior, don't worry about patrol state here.
      if( self.patrolNode ){
        self.goalentity = self.patrolNode;
        if( self.tetherStatus == TETHER_NODE ){
          self.ai_state_next = ST_THR;
        }
        if( self.tetherStatus == TETHER_PATROL ){
          self.ai_state_next = ST_PTR;
        }
        return;
      }
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      return;
    }
    
    if( (self.flags & FL_DISARMED) ){
      self.ai_state_next = ST_STAND;
      self.ai_dampen = 0;
      return;
    }
    self.ai_state_next = ST_COM_MOVE_START;
    /*
      Combat Frame State Checks
    */
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_node_radius_targdist();
    enemy_dist = ai_check_node_radius(self.enemy);
    combat_dist = ai_check_node_radius(self);
    
    if(enemy_vis == VIS_FAIL){
      self.enemy = world;
      self.ai_move_next = MOVE_NODE_RADIUS;
      self.ai_movedist = 15;
      return;
    }
    
    //out of bounds, do move override
    if( 1.0 < enemy_dist ){
      //run
      if(self.tetherStatus == TETHER_PATROL ){
        prox = ai_node_to_target(self.enemy);
        if(prox != self.patrolNode){
          self.patrolNode = prox;
          self.ai_move_next = MOVE_NODE_TACTICAL;
          return;
        }
      }
    }
    
    combat_roll = random() * 1.0;
    //AI is in bounds, but target is out of bounds
    if( 1.0 < enemy_dist ){
      if( combat_dist <= 1.0 ){
        //AI is on edge of bounds but inside radius
        self.ai_fight_take_fire();
        if(self.ai_move_next > MOVE_NODE_TACTICAL){
          self.ai_move_next = ai_move_director();
        }
        return;
      }
      if( combat_dist > 1.0 ){
        self.ai_fight_out_radius();
        if(self.ai_move_next > MOVE_NODE_TACTICAL){
          self.ai_move_next = ai_move_director();
        }
        return;
      }
    }
    
    if( enemy_vis == VIS_FRN ){
      self.ai_fight_vis_friend();
      if(self.ai_move_next > MOVE_NODE_TACTICAL){
        self.ai_move_next = ai_move_director();
      }
      return;
    }
    
    //target == building - those things don't really move or fight back...
    if(self.enemy.data_type == DATA_BLD){
      self.ai_fight_building();
      if(self.ai_move_next > MOVE_NODE_TACTICAL){
        self.ai_move_next = ai_move_director();
      }
      return;
    }
    //target < 1.0
    //combat_dist < 1.0
    //get fighting
    self.ai_move_next = MOVE_NODE_RADIUS;
    self.ai_movedist = 5;
    self.ai_fight_target();
    if(self.ai_move_next > MOVE_NODE_TACTICAL){
      self.ai_move_next = ai_move_director();
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
*/
void() ai_com_moveStart={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    return;
  }
  //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER
*/
void() ai_com_moveExec={
  local float nodeMove;
  local entity nodeCheck;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    self.ai_state_next = ST_COM_MOVE_EXEC;
    return;
  }
  //-----------------------------------------------------------------
  if( MOVE_NODE_TACTICAL < self.ai_move ){
    nodeMove = ai_check_node_radius(self);
    if( 1.0 < nodeMove ){
      if( self.tetherStatus == TETHER_PATROL ){
        nodeCheck = ai_node_to_target(self);
        if(nodeCheck != self.patrolNode){
          self.patrolNode = nodeCheck;
        }
      }
      self.ai_move_next = MOVE_NODE_RADIUS;
      self.ai_state_next = ST_COM_MOVE_START;
      return;
    }
    if( time > self.ai_movewait ){
      self.ai_state_next = ST_COM_MOVE_END;
      return;
    }
  }
  //node_radius
  //node_tactical
  //this have their OWN timers for ending, set on the first frame of ST_COM_MOVE_START
  if( self.ai_move < MOVE_PATROLNODE ){
    //all the _STAND move timers here
    if( time > self.ai_movewait ){
      self.ai_state_next = ST_COM_MOVE_END;
      return;
    }
  }
};

/*
  STATE : COMBAT MANEUVER COMPLETED
*/
void() ai_com_moveEnd={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    if( self.ai_blockflag ){
      self.ai_blockflag = 0;
      self.ai_state_next = ST_COM_MOVE_START;
      self.ai_move_next = MOVE_NODE_RADIUS;
      return;
    }
    self.ai_state_next = ST_COMBAT;
    self.ai_move_next = 0;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE : COMBAT MANEUVER BLOCKED
*/
void() ai_com_blocked={
  local entity blockNode;
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    ai_attack();
    if( 1.0 < ai_check_node_radius(self) ){
      self.patrolState = 0;
      self.goalentity = self.patrolNode;
      self.ai_move_next = MOVE_NODE_RADIUS;
      self.ai_state_next = ST_COM_MOVE_START;
      self.ai_movewait = time + 8;
      return;
    }
    self.ai_movedist = 3;
    self.ai_move_next = ai_move_director();
    self.ai_state_next = ST_COM_MOVE_START;
    return;
  }
 //------------------------------------------------------------------
};
