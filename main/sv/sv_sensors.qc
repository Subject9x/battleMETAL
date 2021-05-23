/*
battleMETAL
Author: Peter Roohr
Date: 1/26/2017
mod: 9/3/2019
mod: 1/14/2021
Overview: 
  necessary targeting and radar functions
  scope - self = unit making the target call
*/


/*
  This function is called when a Player goes to acquire a target.
  usually via impulse keybind. 
*/
void() sv_getTarget={
  local entity src;
  local string targName;
  local vector viewOfs;
  
  makevectors(self.v_angle);
  src = self;

  if( self.chaseActive ){
    viewOfs = src.origin + (v_up * 22) + (v_forward * -96);
    traceline(src.origin, viewOfs, FALSE, self);
    viewOfs = trace_endpos;
  }
  else{
    viewOfs = self.cockpit.origin;
  }
  traceline(viewOfs, viewOfs + (v_forward * self.stat_rdr_rng), MOVE_NORMAL, self);
  
  if( ai_valid_target(trace_ent) ){
    if( trace_ent == self.enemy ){
      //already have this target.
      return;
    }
    self.enemy = trace_ent;
    if( (self.enemy.flags & FL_CLIENT) ){
      targName = self.enemy.netname;
      self.targetEntId = num_for_edict(self.enemy.clientData);
    }
    else{
      targName = self.enemy.vec_name;
      self.targetEntId = num_for_edict(self.enemy);
    }
    
    //2.0.0: lock-on not timer-based anymore
    /*self.lock_timer = 0;  //make sure to reset the timer
    self.targLockState = 0;
    if(self.stat_rdr_mode){
      self.lock_timer = time + self.w_firetime;
    }
    else{
      self.lock_timer = time + (self.w_firetime * 1.75);
    }
    if( self.enemy.trigOnTarget ){
      trigger_event( self.enemy, self.trigOnTarget );
    }
    else{
      trigger_event( self, self.trigOnTarget );
    }*/
    self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_TARGET;
  }
};

/*
  Run every PlayerThink() for every single player.
  This controls the target state of a player, checking radar rules,
   and updating client's target info.
*/
void() sv_updateTargetInfo={
  local float prevDeadFlags;
  local float prevDist;
  local float prevValid;
  local float lostTarget;
  local float canLock;
  local float dst;
  
  //completely lost target
  if( self.enemy == world ){
    self.targetEntId = 0;
    if( self.targetEntIdPrev != 0){
      self.targetEntIdPrev = 0;
      self.stat_trg_dataidx = 0;
      self.stat_trg_dist = 0;
      self.stat_trg_faction = 0;
      self.targLockState = 0;
      self.stat_target_name = "";
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_TARGET;
      //self.targLockState = self.targLockState - (self.targLockState & (LOCK_TARG_START | LOCK_TARG_HAS)); //2.0.0: lock-on not timer-based anymore
    }
    return;
  }
  
  if( (self.enemy.flags & FL_CLIENT) ){
    self.targetEntId = num_for_edict(self.enemy.clientData);
  }
  else{
    self.targetEntId = num_for_edict(self.enemy);
  }
  
  prevDeadFlags = self.stat_trg_ddflg;
  prevDist = self.stat_trg_dist;
  prevValid = self.targetValid;
  
  self.stat_trg_ddflg = self.enemy.deadflag;
  
  lostTarget = FALSE;
  if( self.enemy == world ){
    //early-exit if enemy is not valid
    lostTarget = TRUE;
  }
  else if( prevDeadFlags == DEAD_NO && self.enemy.deadflag > DEAD_NO ){
    //target killed
    lostTarget = TRUE;
  }
  else{
    //Target falls out of radar range or is no longer valid for any reason
    dst = vlen( self.enemy.origin - self.origin );
    self.targetValid = ai_valid_target(self.enemy);
    if( (prevValid && !self.targetValid) || (dst > self.stat_rdr_rng && prevDist <= self.stat_rdr_rng) ){
      lostTarget = TRUE;
    }
  }
  
  if( lostTarget ){
    self.enemy = world;
    self.targetEntId = 0;
    self.targetEntIdPrev = 0;
    self.stat_trg_dataidx = 0;
    self.stat_trg_dist = 0;
    self.stat_trg_faction = 0;
    self.stat_target_name = "";
    self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_TARGET;
    //self.targLockState = self.targLockState - (self.targLockState & (LOCK_TARG_START | LOCK_TARG_HAS)); //2.0.0: lock-on not timer-based anymore
    return;
  }
  
  self.stat_trg_dataidx = self.enemy.data_idx;
  self.stat_trg_dataType = self.enemy.data_type;
  self.stat_trg_faction = self.enemy.faction;
  self.stat_trg_ddflg = self.enemy.deadflag;
  self.stat_trg_dist = dst;
  
  canLock = TRUE;
  //regardless of lock-status, if the intended target is outside the choke, drop the lock
  if( !util_lockOnChoke(self.enemy.origin) ){
    canLock = FALSE;
  }
  else if( self.faction == self.enemy.faction ){
    //can only lock-on to enemy units
    if( self.faction != FACTION_ALL && self.enemy.faction != FACTION_ALL ){
      canLock = FALSE;
    }
  }
  else if( self.targetEntIdPrev != self.targetEntId ){
    //prevents being able to 'transition' the player's Lock State from one target to another.
    canLock = FALSE;
  }
  else{
    traceline(self.origin, self.enemy.origin, FALSE, self);
    if( (self.enemy.flags & FL_CLIENT) ){
      if( self.enemy.stat_rdr_mode != TRUE || trace_fraction != 1.0 ){
        canLock = FALSE;
      }
    }
  }
  self.targetEntIdPrev = self.targetEntId;
  
  //2.0.0: lock-on not timer-based anymore
  /*if(canLock){
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
        self.targLockState = self.targLockState - (self.targLockState & LOCK_TARG_START);
        self.targLockState = self.targLockState | LOCK_TARG_HAS;
      }
    }
    return;
  }
  
  self.targLockState = self.targLockState - (self.targLockState & (LOCK_TARG_START | LOCK_TARG_HAS));
  if( (self.enemy.targLockState & LOCK_PLAYER) ){
    self.enemy.targLockState = self.enemy.targLockState - (self.enemy.targLockState & LOCK_PLAYER);
  }*/
};

/*
  -DEPRECATED-
  All player units have a basic circular sweep pattern for radar.
  this sweeps in a circle around the player, whenever a unit is near the
  sweep-line, the player is pinged on that unit.
*/
/*void() radarSweepBasic={
  local float sweep, yaw, low, high;
  local entity blip;
  
    //TODO - Magic numbers
  self.radar_time = anglemod( self.radar_time + 6 );

  sweep = self.radar_time;
  low = anglemod( sweep - 5 );
  high = anglemod( sweep + 1 );
  
  for(blip = findradius(self.origin, self.radar_range); blip != world; blip = blip.chain){
    if( !(blip.flags & (FL_UNIT|FL_MONSTER)) ){
      continue;
    }
    if( blip == self ){
      continue;
    }
    if( blip.deadflag > DEAD_NO ){ 
      continue;
    }
        
    yaw = vectoyaw( self.origin - blip.origin);
    if( (yaw >= low) && (yaw <= high) ){
      if( self.stat_rdr_mode < TRUE){
        makevectors(self.v_angle);
        traceline( self.origin + (v_up * (self.maxs_z / 2)), blip.origin, MOVE_NORMAL, self );
        if( trace_ent != blip || trace_fraction != 1 ){
          continue;
        }
      }
      //client_push_radar_ping( blip );
    }
  }
};*/

/*
  -DEPRECATED-
  Advanced radar is given if the player has mounted at least 
  1 LSA module. The advanced radar pattern is a rapidly expanding
  circle out from the player center. Every unit near the sweep line
  is pinged, the 360 direction gives the player more info than 
  the sweep pattern.
*/
/*void() radarSweepAdv={
  //TODO - Magic numbers
  local float inv;
  local entity blip;
  local float dist;
  
  if( self.radar_time > self.radar_range ){
    self.radar_time = 0;
  }
  inv = self.radar_range * 0.05;
  self.radar_time = self.radar_time + inv;
  
  for(blip = findradius( self.origin, self.radar_range ); blip != world;  blip = blip.chain){
    if( !(blip.flags & FL_MONSTER) || !(blip.flags & FL_CLIENT) ){
      continue;
    }
    if( blip == self ){
      continue;
    }
    if( blip.deadflag > DEAD_NO ){
      continue;
    }
    dist = vlen( self.origin - blip.origin);
  
    if( (dist > self.radar_time + inv / 2 ) && (dist < self.radar_time - inv / 2) ){
      continue;
    }
    if( !self.stat_rdr_mode ){
      traceline( self.origin, blip.origin, MOVE_NORMAL, self );
      if( trace_ent != blip || trace_fraction != 1 ){
        continue;
      }
    }
    //client_push_radar_ping( blip );
  }
};
*/