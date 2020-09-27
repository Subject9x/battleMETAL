/*
battleMETAL
Author: Peter Roohr
Date: 1/26/2017
mod: 9/3/2019
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
    viewOfs = src.origin + (v_up * 20) + (v_forward * -96);
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
    if( (trace_ent.flags & FL_CLIENT) ){
      targName = trace_ent.netname;
    }
    else{
      targName = trace_ent.vec_name;
    }
    self.enemy = trace_ent;
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
    }
    self.lock_timer = 0;  //make sure to reset the timer
    self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_VELOCITY;
    self.stat_trg_ent_id = num_for_edict(self.enemy);
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
  
  self.stat_trg_ent_id = num_for_edict(self.enemy);
  
  prevDeadFlags = self.stat_trg_ddflg;
  prevDist = self.stat_trg_dist;
  prevValid = self.targetValid;
  
  self.stat_trg_ddflg = self.enemy.deadflag;
  
  //target killed
  if( self.enemy != world ){
    if( prevDeadFlags == DEAD_NO && self.enemy.deadflag > DEAD_NO ){
      self.stat_trg_ent_id = 0;
      self.enemy = world;
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_VELOCITY;
      self.stat_trg_ent_id = 0;
      return;
    }
    local float dst;
    dst = vlen( self.enemy.origin - self.origin );

    self.targetValid = ai_valid_target(self.enemy);
    if( (prevValid && !self.targetValid) || (dst > self.stat_rdr_rng && prevDist <= self.stat_rdr_rng) ){
      self.enemy = world;
      self.stat_trg_ent_id = 0;
      self.stat_trg_dataidx = 0;
      self.stat_trg_dist = 0;
      self.stat_trg_face = -1;
      self.stat_trg_faction = 0;
      if( (self.targLockState & LOCK_TARG_START)){
        self.targLockState = self.targLockState - (self.targLockState & LOCK_TARG_START);
      }
      if( (self.targLockState & LOCK_TARG_HAS)){
        self.targLockState = self.targLockState - (self.targLockState & LOCK_TARG_HAS);
      }
      self.stat_target_name = "";
      self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_VELOCITY;
      self.stat_trg_ent_id = 0;
      return;
    }
    self.stat_trg_dataidx = self.enemy.data_idx;
    self.stat_trg_dataType = self.enemy.data_type;
    self.stat_trg_faction = self.enemy.faction;
    self.stat_trg_ddflg = self.enemy.deadflag;
    self.stat_trg_dist = dst;
    self.stat_trg_face = util_checkPointAngle(self.enemy);
    
    //can only lock-on to enemy units
    if( self.enemy.faction != self.faction ){
      local float canLock;
      canLock = FALSE;
      if( util_lockOnChoke(self.enemy.origin) ){
        traceline(self.origin, self.enemy.origin, FALSE, self);
        if( (self.enemy.flags & FL_CLIENT) ){
          if( self.enemy.stat_rdr_mode == TRUE || trace_fraction == 1.0 ){
            canLock = TRUE;
          }
        }
        else{
          canLock = TRUE;
        }
        if(canLock){
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
      }
      if( (self.targLockState & LOCK_TARG_START) ){
        self.targLockState = self.targLockState - (self.targLockState & LOCK_TARG_START);
      }
      if( (self.targLockState & LOCK_TARG_HAS) ){
        self.targLockState = self.targLockState - (self.targLockState & LOCK_TARG_HAS);
      } 
      if( (self.enemy.targLockState & LOCK_PLAYER) ){
        self.enemy.targLockState = self.enemy.targLockState - (self.enemy.targLockState & LOCK_PLAYER);
      }
    }
  }
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