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
void() building_radar_alert1;   //th_missile
void() building_radar_cool1;    //th_melee
void() building_radar_touch;    //touch

/*
  th_stand
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
  
  if( time > self.pausetime ){
    ai_sfx_spotted();
    self.th_missile();
    if( self.trigOnTarget ){
      if( time > self.wait ){
        trigger_event( self, self.trigOnTarget );
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
  
  building_burn();
  self.radar_time = anglemod( self.radar_time + AI_POST_SWEEP_SIZE );

  sweep = self.radar_time;
  low = anglemod( sweep - AI_POST_SWEEP_SIZE / 2 );
  high = anglemod( sweep + AI_POST_SWEEP_SIZE / 2 );
  
  blip = findradius( self.origin, self.radar_range );
  while( blip ){
    if( blip.deadflag <= DEAD_NO ){
      if( (blip.flags & FL_CLIENT) ){
        if( blip.data_type == DATA_MECH ){
          if( blip.faction != self.faction ){
            rng = self.radar_range;
            //target player is running PASSIVE radar
            if( blip.stat_rdr_mode == FALSE){
              rng = self.radar_range / 2;
            }
            yaw = vectoyaw( self.origin - blip.origin);
            if( (yaw >= low) && (yaw <= high) ){
              if( vlen( blip.origin - self.origin ) <= rng ){
                found = blip;
              }
            }
          }
        }
      }
    }
    blip = blip.chain;
  }
  
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
*/
void() building_radar_alert1=[0, building_radar_alert1]{
  local entity ally, this;
  this = self;
  ally = findchainfloat( faction, self.faction );
  ai_sfx_help();
  while( ally ){
    if( vlen( ally.origin - self.origin ) <= (self.radar_range / 2) ){
      if( ai_valid_target(ally) ){
        if( ally != self ){        
          if( (ally.flags & FL_UNIT) && !(ally.flags & FL_DISARMED)){
            ai_give_target( ally, self.enemy, ( self.ai_rank > AI_RANK_REG ));
          }
        }
      }
    }
    ally = ally.chain;
  }
  self.enemy = world;
  self.th_walk();
  return;
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

/*QUAKED building_human_radar (0 0 1) (-20 -20 0) (20 20 26) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - - - IS_MAPKEY -
{ model("models/buildings/radar/radar.md3"); }
Listening Post, has the ability to detect the player and alert friendly bots.
-------- KEYS -------- 
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
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() building_human_radar={
  self.data_idx = UI_BUILDING_radar;
  self.data_type = DATA_BLD;
  self.ai_rank = skill;
  self.w_firetime = AI_POST_SPOT_TIME;
  self.vec_name = "Listening Post";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 1;
  util_setModel("q3mdl/buildings/radar/mdl_bld_h_radar.md3", self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(100, 100, 1, 100) ;
  setsize(self, '-20 -20 0', '20 20 26');
  self.shield = 0;
  self.shieldMax = 150;
  self.shieldRate = 1;
  self.stat_rdr_mode = TRUE;
  self.radar_range = 2000;
  
  ai_pilot_view_range();
  switch( self.ai_rank ){
    case AI_RANK_ROK:
      self.w_firetime = self.w_firetime * AI_POST_LOCK_ROK;
      break;
    case AI_RANK_VET:
      self.w_firetime = self.w_firetime * AI_POST_LOCK_VET;
      break;
    case AI_RANK_ACE:
      self.w_firetime = self.w_firetime * AI_POST_LOCK_ACE;
      break;
  }
  
  self.deadflag = DEAD_NO;  
  if( util_cornerSlopeCheck(self, 0.95) ){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  self.th_walk = building_radar_patrol1;
  self.th_stand = building_radar_detect1;
  self.th_missile = building_radar_alert1;
  self.th_melee = building_radar_cool1;
  self.th_die = building_die;
  self.think = building_radar_patrol1;
  self.use = multi_trigger;
  self.touch = building_radar_touch;
  self.nextthink = time + 1;
  self.wait = time;
  
  makevectors(self.angles);
  world_make_dlight( (self.origin + (v_up * 38) + (v_forward * -15) + (v_right * 18)), self, 1, '1 0 0', 2, PFLAGS_FULLDYNAMIC, '-90 0 0', 0, 100);
  
  ai_voice_ini( TRUE );
  
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
};