/*
battleMETAL 
Author: Peter Roohr
Date: 06/30/2020
Overview: 
  just spinning about combat-specific funcs to a separate file.
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

