/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: 
  AI State equations
*/

/*
  Scope : Self
  initialize all the entity vars needed for the unit
*/
void() ai_unit_ini_var={

  //ini all the unit stats
  self.data_idx = 0;
  self.energy = 0;
  self.energyMax = 0;
  self.energyRate = 0;
  self.shield = 0;
  self.shieldMax = 0;
  self.shieldRate = 0;
  
  self.radar_range = 0; 
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = FALSE;
  
  self.accuracy = 0;
  self.accuracyMod = 0;
  self.stat_lck_stt = LOCK_NONE;
  self.power_timer = 0;
  self.ideal_yaw = self.angles * '0 1 0';
  self.ai_viewcheck = 0;
  self.ai_view = 0;
  self.ai_action_mod = 0;
  self.ai_viewtime = 0;
  self.ai_minrange = 0;
  self.ai_hunt_total = -1;
  self.lefty = 1;
  if( random() > 0.5 )
    self.lefty = -1;

  self.pausetime = time;
};

/*
  Scope : Self = AI 
  initialize all ai pilot stats, cleans up the ini for any ai unit
*/
void(float rank) ai_pilot_ini_stats={
  local float mod_am;
  local float mod_sh;
    
  self.ai_fov = ai_pilot_field_of_view(rank);
  self.ai_view = ai_pilot_view_range();
  self.ai_viewcheck = ai_pilot_view_interval();

  mod_am = ai_pilot_armor_mod();
  self.max_health = self.health = self.health * mod_am; 
  self.legs.max_health = self.legs.health = self.legs.health * mod_am; 
  self.torsoLeft.max_health = self.torsoLeft.health = self.torsoLeft.health * mod_am; 
  self.torsoRight.max_health = self.torsoRight.health = self.torsoRight.health * mod_am; 
  self.armRight.max_health = self.armRight.health = self.armRight.health * mod_am; 
  self.armLeft.max_health = self.armLeft.health = self.armLeft.health * mod_am;
  
  mod_sh = ai_pilot_shield_mod();
  self.shieldMax = self.shield = self.shield * mod_sh;
  
  if(self.yaw_speed)
    self.yaw_speed = ai_pilot_yaw_mod();

  if(self.turret_yaw_speed)
    self.turret_yaw_speed = ai_turret_yaw_mod();

  self.ai_leading = ai_pilot_rating_leading();
  self.spreadDefault = ai_pilot_accuracy( rank, self.spreadDefault );
  self.accuracy = self.spreadDefault_y;
  self.w_firetime = ai_pilot_lock_time( rank, self.w_firetime );
  
  self.stat_rdr_mode = FALSE;
  if( (self.spawnflags & AI_SPAWNFLAG_HASRADAR) || self.ai_rank > AI_RANK_REG )
    self.stat_rdr_mode = TRUE;
  
  self.ai_action_mod = self.ai_action_time = ai_pilot_action_mod( rank );
  self.ai_attack_chance = ai_pilot_attack_interval( rank );
  
  self.data_speed_forward = self.data_speed_forward * AI_WALK_SPD;
  self.data_speed_strafe = self.data_speed_strafe * AI_WALK_SPD;
  self.data_speed_backward = self.data_speed_backward * AI_WALK_SPD;
  
  ai_pilot_react_cool();
  
  world_get_fog();
};

void() ai_pilot_react_cool={
  switch(self.ai_rank){
    case AI_RANK_ACE:
      self.ai_react_time = AI_REACT_ACE;
      break;
    case AI_RANK_VET:
      self.ai_react_time = AI_REACT_VET;
      break;
    case AI_RANK_REG:
      self.ai_react_time = AI_REACT_REG;
      break;
    case AI_RANK_ROK : 
      self.ai_react_time = AI_REACT_ROK;
      break;
  }
};

float(float rank) ai_pilot_field_of_view={
  local float diff;
  diff = AI_FOV;
  
  switch(rank){
    case AI_RANK_ACE:
      diff = diff * AI_FOV_ACE;
      break;
    case AI_RANK_VET:
      diff = diff * AI_FOV_VET;
      break;
    case AI_RANK_REG:
      diff = diff * AI_FOV_REG;
      break;
    case AI_RANK_ROK : 
      diff = diff * AI_FOV_ROK;
      break;
  }
  return diff;
};

float() ai_pilot_view_range={
  local float view;
  switch(self.ai_rank){
    case AI_RANK_ACE:
      view = self.radar_range * AI_VIEW_RANGE_ACE;
      break;
    case AI_RANK_VET:
      view = self.radar_range * AI_VIEW_RANGE_VET;
      break;
    case AI_RANK_REG:
      view = self.radar_range * AI_VIEW_RANGE_REG;
      break;
    case AI_RANK_ROK:
      view = self.radar_range * AI_VIEW_RANGE_ROK;
      break;
  }
  return view;
};

/*
  AI does not deal full damage like players do (because there's a ton of bots)
  
*/
float( float rank, float damg) ai_pilot_mod_damage={
  local float percent;
  switch( rank ){
    case SKILL_NOV:
      percent = AI_DMG_SKILL_ROK + AI_DMG_ROK;
      break;
    case SKILL_REG:
      percent = AI_DMG_SKILL_REG + AI_DMG_REG;
      break;
    case SKILL_VET:
      percent = AI_DMG_SKILL_VET + AI_DMG_VET;
      break;
    case SKILL_ELT:
      percent = AI_DMG_SKILL_ACE + AI_DMG_ACE;
      break;
  }
  percent = damg * percent;
  //this prevents super-low damage weapons from being flattened
  if( percent < 0.5 ){
    percent = 0.5;
  }
  return percent;
};

float() ai_pilot_view_interval={
  local float mod;
  mod = AI_VIEW_INTERVAL;
  switch(self.ai_rank){
    case AI_RANK_ACE:
      mod = mod * AI_VIEW_ACE;
      break;
    case AI_RANK_VET:
       mod = mod * AI_VIEW_VET;
      break;
    case AI_RANK_REG:
       mod = mod * AI_VIEW_REG;
      break;
    case AI_RANK_ROK:
       mod = mod * AI_VIEW_ROK;
      break;
  }
  return mod;
};

/*
  reduce action_timer by this amount
*/
float(float rank) ai_pilot_action_mod={
  switch(rank){
    case AI_RANK_ACE:
      return AI_REFLEX_ACE;
    case AI_RANK_VET:
      return AI_REFLEX_VET;
    case AI_RANK_ROK:
      return AI_REFLEX_ROK;
    default:
      return AI_REFLEX_REG;
  }
};

/*
  Determines how good the AI is at turning their mech around.
  Each mech has a set yaw speed, but this determines if the AI
  is good enough to turn the mech at its set speed, rather than
  having 'slower reflexes'.
*/
float() ai_pilot_yaw_mod={
  local float yawspeed;
  yawspeed = self.yaw_speed;
 
  switch( self.ai_rank ){
    case AI_RANK_ACE:
      yawspeed = yawspeed * AI_YAW_ACE;
      break;
    case AI_RANK_VET:
      yawspeed = yawspeed * AI_YAW_VET;
      break;
    case AI_RANK_ROK:
      yawspeed = yawspeed * AI_YAW_ROK;
      break;
    default:
      yawspeed = yawspeed * AI_YAW_REG;
      break;
  }
  return yawspeed;
};

float() ai_turret_yaw_mod={
  local float yawspeed;
  yawspeed = self.turret_yaw_speed;
 
  switch( self.ai_rank ){
    case AI_RANK_ACE:
      yawspeed = yawspeed * AI_YAW_ACE;
      break;
    case AI_RANK_VET:
      yawspeed = yawspeed * AI_YAW_VET;
      break;
    case AI_RANK_ROK:
      yawspeed = yawspeed * AI_YAW_ROK;
      break;
    default:
      yawspeed = yawspeed * AI_YAW_REG;
      break;
  }
  return yawspeed;
};

/*
  Armor amounts for AI units is modified by the game's skill
  rating. Easier skill modes mean each AI has less armor.
  Mechs are a special case because health-wise they're like 5 vhicles combined
  into 1 unit...
*/
float() ai_pilot_armor_mod={

  if( self.data_type == DATA_MECH ){
    switch( self.ai_rank ){
      case SKILL_NOV:
        return AI_ARMOR_MECH_EASY;
      case SKILL_VET:
        return AI_ARMOR_MECH_HARD;
      case SKILL_ELT:
        return AI_ARMOR_MECH_NIGHT;
      default:
        return AI_ARMOR_MECH_MEDM;
    }
  }
  else{
    switch( self.ai_rank ){
      case SKILL_NOV:
    return AI_ARMOR_EASY;
      case SKILL_VET:
        return AI_ARMOR_HARD;
      case SKILL_ELT:
        return AI_ARMOR_NIGHT;
      default:
        return AI_ARMOR_MECH_MEDM;
    }
  }
}

/*
  Shield modifier based on difficulty.
  Either way, AI never gets player-comparable shield values
*/
float() ai_pilot_shield_mod={
  switch( self.ai_rank ){
    case AI_RANK_ROK:
      return AI_SHIELD_ROK;
    case AI_RANK_VET:
      return AI_SHIELD_VET;
    case AI_RANK_ACE:
      return AI_SHIELD_ACE;
    default:
      return AI_SHIELD_REG;
  }
}

/*
  This determines how good the AI is at 'leading' its target.
  In practice, this is how badly the AI's aim should trail BEHIND
  its target. Better AI's are better at this.
*/
float() ai_pilot_rating_leading={
  switch( self.ai_rank ){
    case AI_RANK_ACE:
      return AI_LEAD_ACE;
    case AI_RANK_VET:
      return AI_LEAD_VET;
    case AI_RANK_REG:
      return AI_LEAD_REG;
    default :
      return AI_LEAD_ROK;
  }
};

void() ai_promote={
  self.ai_rank = skill;
  if( (self.spawnflags & AI_SPAWNFLAG_PROMOTE) ){
    self.ai_rank = self.ai_rank + 1;
    if( self.ai_rank > SKILL_ELT ){
      self.ai_rank = SKILL_ELT;
    }
  }
  if( (self.spawnflags & AI_SPAWNFLAG_DEMOTE) ){
    self.ai_rank = self.ai_rank - 1;
    if( self.ai_rank < SKILL_NOV ){
      self.ai_rank = SKILL_NOV;
    }
  }
};

/*
  a design conceit, to make sure bots are not perfectly firing,
  or inhumanly relentlessly attacking, this function creates
  a random amount of time to make the next attack.
*/
float(float rank) ai_pilot_attack_interval={
  local float interval;
  switch( rank ){
    case 0:
      interval = 0.05 + AI_ATTACK_ROK;
      break;
    case 1:
      interval = 0.1 + AI_ATTACK_REG;
      break;
    case 2:
      interval = 0.2 + AI_ATTACK_VET;
      break;
    case 3:
      interval = 0.3 + AI_ATTACK_ACE;
      break;
  }
  return interval;
};

/*
  AI base accuracy rating
*/
vector( float rank, vector spread ) ai_pilot_accuracy={
  local vector acc;
  local float modMin;
  local float modMax;
  local float modRate;
  
  modMin = spread_x;
  modMax = spread_y;
  modRate = spread_z;
  
  switch( rank ){
    case SKILL_NOV:
      modMin = modMin * AI_CNV_MIN_ROK;
      modMax = modMax * AI_CNV_MAX_ROK;
      modRate = modRate * AI_CNV_RATE_ROK;
      break;
    case SKILL_REG:
      modMin = modMin * AI_CNV_MIN_REG;
      modMax = modMax * AI_CNV_MAX_REG;
      modRate = modRate * AI_CNV_RATE_REG;
      break;
    case SKILL_VET:
      modMin = modMin * AI_CNV_MIN_VET;
      modMax = modMax * AI_CNV_MAX_VET;
      modRate = modRate * AI_CNV_RATE_VET;
      break;
    case SKILL_ELT:
      modMin = modMin * AI_CNV_MIN_ACE;
      modMax = modMax * AI_CNV_MAX_ACE;
      modRate = modRate * AI_CNV_RATE_ACE;
      break;
  }
  modRate = modRate * -1;
  acc_x = modMin;
  acc_y = modMax;
  acc_z = modRate;
  return acc;
};

/*
  Adjust lock-on time by difficulty
*/
float( float rank, float lockOn ) ai_pilot_lock_time={

  switch( rank ){
    case 0:
      self.w_firetime = self.w_firetime * 2;
      break;
    case 1:
      self.w_firetime = self.w_firetime * 1;
      break;
    case 2:
      self.w_firetime = self.w_firetime * 0.75;
      break;
    case 3:
      self.w_firetime = self.w_firetime * 0.6;
      break;
  }
  return self.w_firetime;
};

/*
  Finds acceptable minimum range of all AI's guns
*/
float() ai_pilot_minrange={
  local entity weaponEnt;
  local float minrange;
  local float total;
  
  weaponEnt = self.w_slot;
  while( weaponEnt ){
    if( weaponEnt.deadflag == DEAD_NO ){
      minrange = minrange + weaponEnt.w_range;
      total = total + 1;
    }
    weaponEnt = weaponEnt.w_slot;
  }
  
  minrange = minrange / total;
  return minrange;
};