/*
battleMETAL
Author: Peter Roohr
Date: 01/21/2017
mod : 09/19/2018
mod : 02/18/2019 - refactor
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*
  macro rebuild
*/
void() building_radar_detect1;  //th_stand
void() building_radar_patrol1;  //th_walk
float() building_radar_alert1;   //th_missile
void() building_radar_alert2;   //th_missile
void() building_radar_cool1;    //th_melee
void() building_radar_touch;    //touch

void() building_radar_die2={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3 + rint(random() * 5), 1 );
  self.think = SUB_Null;
  self.nextthink = time + 0.1;
};

void() building_radar_die1={
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_NOT;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;

  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  ai_alert_close(self.enemy);
  
  self.think = building_radar_die2;
  self.nextthink = time + 0.1;
};

/*
  th_stand
  Post has detected a target, begin countdown to alarm
*/
void() building_radar_detect1=[0, building_radar_detect1]{
  local float dist, rng;
  dist = vlen( self.origin - self.enemy.origin );
  
  //target player is running PASSIVE radar
  rng = self.radar_range;
  if( self.enemy.stat_rdr_mode == 0 ){
    makevectors( self.angles );
    traceline( self.origin + (v_up * 32), self.enemy.origin, TRUE, self);
    if( trace_fraction < 1 ){
      ai_sfx_huntStart();
      self.pausetime = time + self.w_firetime;
      self.th_melee();
      return;
    }
    rng = self.radar_range / 2;
  }
  
  //target player is outside radar range
  if( dist > rng ){
    ai_sfx_huntStart();
    self.pausetime = time + self.w_firetime;
    self.th_melee();
    return;
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
  self.attack_state = ST_STAND;
  
  if( time > self.pausetime ){
    ai_sfx_spotted();
    self.th_missile();
    if( self.trigOnTarget ){
      if( time > self.wait ){
        trigger_event( self.enemy, self.trigOnTarget );
        self.wait = time + self.delay;
      }
    }
    return;
  }
};

/*
  th_walk
*/
void() building_radar_patrol1=[0, building_radar_patrol1]{
  local entity blip, found;
  local float rng, sweep, low, high, yaw;
  
  self.radar_time = anglemod( self.radar_time + AI_POST_SWEEP_SIZE );

  sweep = self.radar_time;
  low = anglemod( sweep - AI_POST_SWEEP_SIZE / 2 );
  high = anglemod( sweep + AI_POST_SWEEP_SIZE / 2 );
  
  for( blip = findradius( self.origin, self.radar_range ); blip != world; blip = blip.chain ){
    if( blip.deadflag > DEAD_NO ){
      continue;
    }
    if( !(blip.flags & FL_CLIENT) ){
      continue;
    }    
    if( blip.data_type != DATA_MECH ){
      continue;
    }
    if( blip.faction == self.faction ){
      continue;
    }
    rng = self.radar_range;
    //target player is running PASSIVE radar
    if( blip.stat_rdr_mode == FALSE){
      rng = self.radar_range / 2;
    }
    yaw = vectoyaw( self.origin - blip.origin);
    if( (yaw < low) || (yaw > high) ){
      continue;
    }
    if( vlen( blip.origin - self.origin ) > rng ){
      continue;
    }
    found = blip;
  }
  building_burn();
  self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
  self.attack_state = ST_WALK;
  
  if( found != world){
    self.enemy = found;
    self.pausetime = time + self.w_firetime;
    ai_sfx_warning();
    self.th_stand();
    return;
  }
};

/*
  th_missile
  Sound the alarm!
  
*/
float() building_radar_alert1={
  local entity ally, this;
  this = self;
  ai_sfx_help();
  
  if(alarm_ent == world){
    alarm_ent = self;
  } 
  for( ally = findchainfloat(faction, self.faction); ally != world; ally = ally.chain){
    if( vlen( ally.origin - self.origin ) > (self.radar_range / 2) ){
      continue;
    }
    if( !ai_valid_target(ally) ){
      continue;
    }
    if( ally == self ){        
      continue;
    }
    if( !(ally.flags & FL_UNIT) || (ally.flags & FL_DISARMED)){
      continue;
    }
    ai_give_target( ally, self.enemy, (self.ai_rank > AI_RANK_REG));
  }
  if(alarm_ent == this ){
    alarm_ent = world;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
  self.attack_state = ST_RUN;
  
  self.ai_action_time = time + 5;
  self.think = building_radar_alert2;
  self.nextthink = time + 0.1;
  return 0;
};

//simply strobe at 'alarm' for a spell;
void() building_radar_alert2={
  if( time > self.ai_action_time ){
    self.enemy = world;
    self.th_walk();
    return;
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
  self.attack_state = ST_RUN;
  self.think = building_radar_alert2;
  self.nextthink = time + 0.1;
};
/*
  th_melee
*/
void() building_radar_cool1=[0, building_radar_cool1]{
  if( time > self.pausetime ){
    self.enemy = world;
    ai_sfx_huntEnd();
    self.th_walk();
    return;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
  self.attack_state = ST_STAND;
};

/*
  Touch Function
*/
void() building_radar_touch={
  if( (other.flags & FL_UNIT) ){
    if( other.faction != self.faction ){
      if( !self.enemy ){
        self.enemy = other;
        self.th_missile();
        return;
      }
    }
  }
};

/*QUAKED building_human_radar (0 0 1) (-20 -20 0) (20 20 26) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/radar/radar.md3"); }

Radar Post, has the ability to detect the player and alert friendly bot to these players.
  
Does not require power.

Max Health = 100. (default)

Shield Max = 250. (default)

Radar Range = 2000. (default) 

-------- KEYS -------- 
.faction : <float> = 1, 2, 3 [REQUIRED]
.radar_range : <float> = range of radar in game units.
.targetname : string, used for trigger calls from other ents
.target : string name of ent to go to, usually a patrol node
.trigOnSpawn:string target, fire this ENTITY when activated
.trigOnDeath: string target, fire this ENTITY when killed
.trigOnTarget: string target, fire this ENTITY when spotting a target
.delay : float, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_human_radar={
  self.data_idx = self.nextVecChoice = UI_BUILDING_radar;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  self.ai_rank = skill;
  self.w_firetime = AI_POST_SPOT_TIME;
  self.vec_name = "Listening Post";
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.vec_size = 1;
  macro_set_model("q3mdl/testball.md3", self.skin, EF_LOWPRECISION)
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE)
  setsize(self, '-20 -20 0', '20 20 26');
  self.stat_rdr_mode = TRUE;
  
  self.ai_view = self.radar_range * AI_VIEW_RANGE_REG;
  switch( self.ai_rank ){
    case AI_RANK_ROK:
      self.ai_view = self.radar_range * AI_VIEW_RANGE_ROK;
      self.w_firetime = self.w_firetime * AI_POST_LOCK_ROK;
      break;
    case AI_RANK_VET:
      self.ai_view = self.radar_range * AI_VIEW_RANGE_VET;
      self.w_firetime = self.w_firetime * AI_POST_LOCK_VET;
      break;
    case AI_RANK_ACE:
      self.ai_view = self.radar_range * AI_VIEW_RANGE_ACE;
      self.w_firetime = self.w_firetime * AI_POST_LOCK_ACE;
      break;
  }
  
  if( !self.health) {
    self.health = self.max_health = 250;
  }
  if( !self.shieldMax ){
    self.shieldMax = 200;
  }
  if( !self.shieldRate ){
    self.shieldRate = 0;
  }
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 100;
  }
  if( !self.radar_range ){
    self.radar_range = 2000; 
  }
  
  self.deadflag = DEAD_NO;  
  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 4) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  
  self.th_walk = building_radar_patrol1;
  self.th_stand = building_radar_detect1;
  self.th_missile = building_radar_alert1;
  self.th_melee = building_radar_cool1;
  self.th_die = building_radar_die1;
  self.use = multi_trigger;
  self.touch = building_radar_touch;
  self.wait = time;
  
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  
  //allows RADAR to call a specific trigger when it spots something
  if( self.trigOnTarget ){
    if( self.delay == -1 ){
      self.delay = 99999999;
    }
    else{
      if( !self.delay ){
        self.delay = self.w_firetime * 1.67;
      }
    }
  }
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }
  self.think = building_radar_patrol1;
  self.nextthink = time + 1;
};