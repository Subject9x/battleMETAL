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
  
  makevectors(self.v_angle);
  src = self;

  traceline(src.origin, src.origin + (v_forward * self.stat_rdr_rng), MOVE_NORMAL, self);
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
  }
  self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_IMPACT;
};

/*
  Run every PlayerThink() for every single player.
  This controls the target state of a player, checking radar rules,
   and updating client's target info.
*/
void() sv_updateTargetInfo={
  local float prevDeadFlags;
  
  self.stat_trg_ent_id = num_for_edict(self.enemy);
  
  prevDeadFlags = self.stat_trg_ddflg;
  self.stat_trg_ddflg = self.enemy.deadflag;
  
  //target killed
  if( self.enemy != world ){
    if( prevDeadFlags == DEAD_NO && self.enemy.deadflag > DEAD_NO ){
      self.stat_trg_ent_id = -1;
      self.enemy = world;
      return;
    }
  }
  
  //lost OR killed target.
  if( !(ai_valid_target(self.enemy)) ){
    
    self.stat_trg_ent_id = -1;
    self.stat_trg_dataidx = 0;
    self.stat_trg_dist = 0;
    self.stat_trg_face = -1;
    self.stat_trg_faction = 0;
    self.addStat_targetSize_x = 0;
    self.addStat_targetSize_y = 0;
    self.addStat_targetSize_z = 0;
    self.stat_target_orgx = 0;
    self.stat_target_orgy = 0;
    self.stat_target_orgz = 0;
    self.stat_target_size = 0;
    if( (self.stat_lck_stt & LOCK_TARG_START)){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_START);
    }
    if( (self.stat_lck_stt & LOCK_TARG_HAS)){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_HAS);
    }
    self.stat_target_name = "";
    return;
  }
  
  local float dst;
  dst = vlen( self.enemy.origin - self.origin );
  if(dst > self.stat_rdr_rng){
    self.enemy = world;
    return;
  }

  self.stat_trg_dataidx = self.enemy.data_idx;
  self.stat_trg_dat = self.enemy.data_type;
  self.stat_trg_faction = self.enemy.faction;  
  self.stat_trg_ddflg = self.enemy.deadflag;
  self.stat_trg_dist = dst;
  self.stat_trg_face = util_checkPointAngle(self.enemy);
  self.addStat_targetSize_x = self.enemy.maxs_x;
  self.addStat_targetSize_y = self.enemy.maxs_y;
  self.addStat_targetSize_z = self.enemy.maxs_z;
  self.stat_target_orgx = self.enemy.origin_x;
  self.stat_target_orgy = self.enemy.origin_y;
  self.stat_target_orgz = self.enemy.origin_z;
  self.stat_target_size = self.enemy.maxs_z * 2;
  
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
          self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_START);
          self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG_HAS;
        }
      }
    }
    else{
      if( (self.stat_lck_stt & LOCK_TARG_START) ){
        self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_START);
      }
      if( (self.stat_lck_stt & LOCK_TARG_HAS) ){
        self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_HAS);
      } 
      if( (self.enemy.stat_lck_stt & LOCK_PLAYER) ){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - (self.enemy.stat_lck_stt & LOCK_PLAYER);
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
void() radarSweepBasic={
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
};

/*
  -DEPRECATED-
  Advanced radar is given if the player has mounted at least 
  1 LSA module. The advanced radar pattern is a rapidly expanding
  circle out from the player center. Every unit near the sweep line
  is pinged, the 360 direction gives the player more info than 
  the sweep pattern.
*/
void() radarSweepAdv={
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
