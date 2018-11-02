/*
mech Mod
Author: Peter Roohr
Date: 1/26/2017
Overview: necessary targeting and radar functions
*/
/*scope - self = unit making the target call*/


void() server_make_sweep={
  local float sweep, yaw, low, high;
  local entity blip;
  
    
  //Radar 1 - 'circular sweep pattern'
  /*if( self.data_type != DATA_POBS ){
    //TODO - Magic numbers
    self.radar_time = anglemod( self.radar_time + 6 );

    sweep = self.radar_time;
    low = anglemod( sweep - 5 );
    high = anglemod( sweep + 1 );
    
    blip = findradius( self.origin, self.radar_range );
    while( blip ){
      if( (blip.flags & FL_MONSTER) || (blip.flags & FL_CLIENT) ){
        if( blip != self ){
          if( blip.deadflag <= DEAD_NO ){
            yaw = vectoyaw( self.origin - blip.origin);
            if( (yaw >= low) && (yaw <= high) ){
              if( !self.stat_rdr_mode ){
                traceline( self.origin, blip.origin, MOVE_NORMAL, self );
                if( trace_ent == blip || trace_fraction == 1 ){
                  client_push_radar_ping( blip );
                }
              }
              else{
                client_push_radar_ping( blip );
              }
            }
          }
        }
      }
      blip = blip.chain;
    }
  }*/
  
  
  //Radar 2 - ALIENS - style
  if( self.data_type != DATA_POBS ){
    //TODO - Magic numbers
    local float inv;
    if( self.radar_time > self.radar_range ){
      self.radar_time = 0;
    }
    inv = self.radar_range * 0.05;
    self.radar_time = self.radar_time + inv;
    
    blip = findradius( self.origin, self.radar_range );
    while( blip ){
      if( (blip.flags & FL_MONSTER) || (blip.flags & FL_CLIENT) ){
        if( blip != self ){
          if( blip.deadflag <= DEAD_NO ){
            local float dist;
            dist = vlen( self.origin - blip.origin);
          
            if( (dist <= self.radar_time + inv / 2 ) && (dist >= self.radar_time - inv / 2) ){
              if( !self.stat_rdr_mode ){
                traceline( self.origin, blip.origin, MOVE_NORMAL, self );
                if( trace_ent == blip || trace_fraction == 1 ){
                  client_push_radar_ping( blip );
                }
              }
              else{
                client_push_radar_ping( blip );
              }
            }
          }
        }
      }
      blip = blip.chain;
    }
  }
  
};

void() server_getTarget={
  local entity src;
  makevectors(self.v_angle);
    src = self;
  if(self.e_cam != world){
    src = self.e_cam;
  }

  traceline(src.origin, src.origin + (v_forward * self.stat_rdr_rng), MOVE_NORMAL, self);
  if( ai_valid_target(trace_ent) ){
    if( (trace_ent.flags & FL_CLIENT) || (trace_ent.flags & FL_MONSTER) ){
      self.enemy = trace_ent;
      if(self.stat_rdr_mode){
        self.lock_timer = time + self.w_firetime;
      }
      else{
        self.lock_timer = time + (self.w_firetime *1.75);
      }
      trigger_event( self, trigOnTarget );
    }
  }
  else{
    self.enemy = world;
    self.lock_timer = 0;
  }
};

/*scope - self = unit making the target call*/
void() server_updateTargetInfo={
  local float isvis;
 
  if( !(ai_valid_target(self.enemy)) || (self.enemy.health <= 0) ){
    self.stat_trg_dataidx = -1;
    self.stat_trg_ddflg = -1;
    self.stat_trg_dist = -1;
    self.stat_trg_face = -1;
    self.stat_trg_faction = -1;
    self.stat_trg_ent_id = -1;
    if( (self.stat_lck_stt & LOCK_TARG_START)){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_START);
    }
    if( (self.stat_lck_stt & LOCK_TARG_HAS)){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG_HAS);
    }
    return;
  }
  
  self.stat_trg_ent_id = num_for_edict(self.enemy);
  self.stat_trg_dataidx = self.enemy.data_idx;
  self.stat_trg_dat = self.enemy.data_type;
  self.stat_trg_faction = self.enemy.i_faction;

  local float dst;
  dst = vlen( self.enemy.origin - self.origin );
  if(dst > self.stat_rdr_rng){
    self.enemy = world;
    return;
  }
  
  self.stat_trg_ddflg = self.enemy.deadflag;
  self.stat_trg_dist = dst;
  self.stat_trg_face = util_checkPointAngle(self.enemy);
  
  //can only lock-on to enemy units
  if( self.enemy.i_faction != self.i_faction ){
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
      if( (self.enemy.stat_lck_stt & LOCK_PLYR) ){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - (self.enemy.stat_lck_stt & LOCK_PLYR);
      }
    }
    
  }
};