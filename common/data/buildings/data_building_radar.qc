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


void() building_radar_die2={
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3 + rint(random() * 5), 1 );
  building_die();
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};

void() building_radar_die1={
#ifdef SSQC
  local vector shoot;
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3 + rint(random() * 5), 1 );
  ai_alert_close(self.enemy);
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
  
  self.think = building_radar_die2;
  self.nextthink = time + 0.1;
};


#ifdef SSQC
/*
  macro rebuild
*/
void() building_radar_detect1;  //th_stand
void() building_radar_patrol1;  //th_walk
float() building_radar_alert1;   //th_missile
void() building_radar_alert2;   //th_missile
void() building_radar_cool1;    //th_melee
void() building_radar_touch;    //touch

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
#endif


#ifdef CSQC
void() radar_post_dlights={
  if( self.deadflag == DEAD_NO ){
    //apparently when menu running, these just get STACCCCCCKED and murder framerate.
    if(MENU_PROG_OFF == FALSE){
      particleDraw = vlen(CLIENT_vis_org - self.origin);      
      if( particleDraw <= PARTICLE_HAZ_DISTANCE ){  
        adddynamiclight( self.compOffset, 128, self.compAltOffsetCache); 
      }
    }
  }
};
void() radar_post_th={
  if( self.deadflag == DEAD_NO ){
    if( self.faction == CLIENT_faction ){
      if(  self.w_firetime == 1 ){
        //ST_STAND -> sv/main/ai/ai_api.qh 
        //post detecting, countdown to alarm
        self.compAltOffsetCache = '1 1 0.4';
        self.partTypeId = 2;
      }
      else if(  self.w_firetime == 2 ){
        //ST_WALK -> sv/main/ai/ai_api.qh 
        //idling normally
        self.compAltOffsetCache = '0 0.8 0.6';
        self.partTypeId = 11;
      }
      else if( self.w_firetime == 4 ){
        //ST_RUN -> sv/main/ai/ai_api.qh 
        //post is raising alarm
        self.compAltOffsetCache = '1 0.6 0';
        self.partTypeId = 4;
      }
    }
    else{     
      if( self.w_firetime == 1 ){
        //ST_STAND-> sv/main/ai/ai_api.qh 
        //post detecting, countdown to alarm
        self.compAltOffsetCache = '1 0.8 0.4';
        self.partTypeId = 3;
      }
      else if(  self.w_firetime == 2 ){
        //ST_WALK -> sv/main/ai/ai_api.qh 
        //idling normally
        self.compAltOffsetCache = '0 0.4 1';
        self.partTypeId = 9;
      }
      else if( self.w_firetime == 4 ){
        //ST_RUN -> sv/main/ai/ai_api.qh 
        //post is raising alarm
        self.compAltOffsetCache = '1 0 0';
        self.partTypeId = 1;
      }
    }
    self.think = radar_post_th;
    self.nextthink = time + 0.1;
  }
};
#endif

/*QUAKED building_radar (0 0 1) (-20 -20 0) (20 20 26) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY IS_VIP
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
void() building_radar={
  self.data_idx = self.nextVecChoice = UI_BUILDING_radar;
  self.data_type = DATA_BLD;

  self.deadflag = DEAD_NO;  
  self.vec_name = "Listening Post";
  self.flags = self.flags | FL_MONSTER ;
  self.vec_size = 1;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_STEP;
  self.takedamage = DAMAGE_AIM;
  self.skin = self.faction - 1;
  self.model = "models/buildings/radar/listpost.md3";
  precache_model("models/buildings/radar/listpost.md3");
  setmodel(self, "models/buildings/radar/listpost.md3");
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);

  if( !self.health) {
    self.health = 250;
  }
  self.max_health = self.health;
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
  
  makevectors(self.angles);
  self.th_die = building_radar_die1;
#ifdef CSQC
  self.th_walk = radar_post_th;
  self.render_dlights = radar_post_dlights;
  self.compOffset = self.origin + (v_up * 38) + (v_forward * -15) + (v_right * 18); //dlight origin
  self.partTypeId = 0;  //dlight style
  self.compAltOffsetCache = '0 0 0';  //dlight color
#endif
  
#ifdef SSQC
  if( self.angle ){
    self.angles_y = self.angle;
  }
  
  self.effects = self.effects | EF_LOWPRECISION;
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();

  self.ai_rank = skill;
  self.w_firetime = AI_POST_SPOT_TIME;

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
  
  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 4) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  setorigin(self, self.origin);
  
  self.th_walk = building_radar_patrol1;
  self.th_stand = building_radar_detect1;
  self.th_missile = building_radar_alert1;
  self.th_melee = building_radar_cool1;
  self.th_die = building_radar_die1;
  self.use = multi_trigger;
  self.touch = building_radar_touch;
  self.wait = time;
  
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
  
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }  
  if( self.canTarget || (self.spawnflags & IS_MAPKEY) ){
    self.SendEntity = ctrl_send_building;
    self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
  }
  self.building_delay_think = building_radar_patrol1;
  self.think = building_bbox_settle;
  self.nextthink = time + 0.1;
#endif
};