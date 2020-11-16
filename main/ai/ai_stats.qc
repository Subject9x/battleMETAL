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
  self.targLockState = LOCK_NONE;
  self.power_timer = 0;
  self.ideal_yaw = self.angles * '0 1 0';
  self.ai_viewcheck = 0;
  self.ai_view = 0;
  self.ai_action_mod = 0;
  self.ai_viewtime = 0;
  self.ai_minrange = 0;
  self.lefty = 1;
  if( random() > 0.5 ){
    self.lefty = -1;
  }
  self.pausetime = time;
};

/*
  Scope : Self = AI 
  initialize all ai pilot stats, cleans up the ini for any ai unit
*/
void(float rank) ai_pilot_ini_stats={

  if( self.data_type == DATA_MECH ){
    if( (self.legs) ){
      self.legs.max_health = self.legs.health = self.legs.health * AI_ARMOR_MECH;
    }
    if( (self.torsoLeft) ){
      self.torsoLeft.max_health = self.torsoLeft.health = self.torsoLeft.health * AI_ARMOR_MECH;
    }
    if( (self.torsoRight) ){
      self.torsoRight.max_health = self.torsoRight.health = self.torsoRight.health * AI_ARMOR_MECH;
    } 
    if( (self.armRight) ){
      self.armRight.max_health = self.armRight.health = self.armRight.health * AI_ARMOR_MECH;
    } 
    if( (self.armLeft) ){
      self.armLeft.max_health = self.armLeft.health = self.armLeft.health * AI_ARMOR_MECH;
    }
  
  }
  
  self.energyRate = self.energyRate * AI_ADJUST_ENERGY;
  self.shieldRate = self.shieldRate * AI_ADJUST_SHIELD;
  
  if( self.data_type == DATA_MECH ){
    self.shieldMax = self.shield = self.shield * AI_SHIELD_MECH;
  }
 
  self.spreadDefault = ai_pilot_accuracy( rank, self.spreadDefault );
  self.accuracy = self.spreadDefault_y;
  
  self.stat_rdr_mode = FALSE;
  if( (self.spawnflags & HAS_RADAR) || self.ai_rank > AI_RANK_REG )
    self.stat_rdr_mode = TRUE;
  
  self.data_speed_forward = self.data_speed_forward * AI_WALK_SPD;
  self.data_speed_strafe = self.data_speed_strafe * AI_WALK_SPD;
  self.data_speed_backward = self.data_speed_backward * AI_WALK_SPD;
  
  switch(self.ai_rank){
    case 0:
      ai_pilot_ini_rok();
      break;
    default:
      ai_pilot_ini_reg();
      break;
    case 2:
      ai_pilot_ini_vet();
      break;
    case 3:
      ai_pilot_ini_ace();
      break;
  }
  
  world_get_fog();
};

void() ai_pilot_ini_rok={
  self.helpTimeDelay = AI_HELP_COOL_ROK;
  self.ai_react_time = AI_REACT_ROK;
  self.ai_fov = AI_FOV_ROK;
  self.ai_view = self.radar_range * AI_VIEW_RANGE_ROK;
  self.ai_viewcheck = AI_VIEW_ROK;
  self.ai_leading = AI_LEAD_ROK;
  self.ai_attack_chance = 0.05 + AI_ATTACK_ROK;
  self.w_firetime = self.w_firetime * 2;
  self.ai_pauseTime_check = AI_PAUSE_TIME_ROK;
  self.ai_pauseTime_chance = AI_PAUSE_CHANCE_ROK;
  self.ai_pauseTime_wait = AI_PAUSE_WAIT_ROK;
};
void() ai_pilot_ini_reg={
  self.helpTimeDelay = AI_HELP_COOL_REG;
  self.ai_react_time = AI_REACT_REG;
  self.ai_fov = AI_FOV_REG;
  self.ai_view = self.radar_range * AI_VIEW_RANGE_REG;
  self.ai_viewcheck = AI_VIEW_REG;
  self.ai_leading = AI_LEAD_REG;
  self.ai_attack_chance = 0.1 + AI_ATTACK_REG;
  self.w_firetime = self.w_firetime * 1;
  self.ai_pauseTime_check = AI_PAUSE_TIME_REG;
  self.ai_pauseTime_chance = AI_PAUSE_CHANCE_REG;
  self.ai_pauseTime_wait = AI_PAUSE_WAIT_REG;
};
void() ai_pilot_ini_vet={
  self.helpTimeDelay = AI_HELP_COOL_VET;
  self.ai_react_time = AI_REACT_VET;
  self.ai_fov = AI_FOV_VET;
  self.ai_view = self.radar_range * AI_VIEW_RANGE_VET;
  self.ai_viewcheck = AI_VIEW_VET;
  if(self.yaw_speed){
    self.yaw_speed = self.yaw_speed * AI_YAW_VET;
  }
  if(self.turret_yaw_speed){
    self.turret_yaw_speed = self.turret_yaw_speed * AI_YAW_VET;
  }
  self.ai_leading = AI_LEAD_VET;
  self.ai_attack_chance = 0.2 + AI_ATTACK_VET;
  self.w_firetime = self.w_firetime * 0.75;
  self.ai_pauseTime_check = AI_PAUSE_TIME_VET;
  self.ai_pauseTime_chance = AI_PAUSE_CHANCE_VET;
  self.ai_pauseTime_wait = AI_PAUSE_WAIT_VET;
};
void() ai_pilot_ini_ace={
  self.helpTimeDelay = AI_HELP_COOL_ACE;
  self.ai_react_time = AI_REACT_ACE;
  self.ai_fov = AI_FOV_ACE;
  self.ai_view = self.radar_range * AI_VIEW_RANGE_ACE;
  self.ai_viewcheck = AI_VIEW_ACE;
  if(self.yaw_speed){
    self.yaw_speed = self.yaw_speed * AI_YAW_ACE;
  }
  if(self.turret_yaw_speed){
    self.turret_yaw_speed = self.turret_yaw_speed * AI_YAW_ACE;
  }
  self.ai_leading = AI_LEAD_ACE;
  self.ai_attack_chance = 0.3 + AI_ATTACK_ACE;
  self.w_firetime = self.w_firetime * 0.6;
  self.ai_pauseTime_check = AI_PAUSE_TIME_ACE;
  self.ai_pauseTime_chance = AI_PAUSE_CHANCE_ACE;
  self.ai_pauseTime_wait = AI_PAUSE_WAIT_ACE;
};

/*
  AI does not deal full damage like players do (because there's a ton of bots)
  
*/
float( float rank, float damg) ai_pilot_mod_damage={
  local float percent;
  switch( rank ){
    case SKILL_NOV:
      percent = AI_DMG_SKILL_ROK;
      break;
    case SKILL_REG:
      percent = AI_DMG_SKILL_REG;
      break;
    case SKILL_VET:
      percent = AI_DMG_SKILL_VET;
      break;
    case SKILL_ELT:
      percent = AI_DMG_SKILL_ACE;
      break;
  }
  percent = damg * percent;
  //this prevents super-low damage weapons from being flattened
  if( percent < 0.5 ){
    percent = 0.5;
  }
  return percent;
};

/*
  reduce action_timer by this amount
*/
float(float rank) ai_pilot_action_mod={
  local float actionTime;
  local float slow;
  slow = self.data_speed_forward + self.data_speed_backward + self.data_speed_strafe;
  slow = slow - 600;
  slow = slow * -1;
  slow = slow / 100;
  actionTime = rank + slow;
  return actionTime;
};

void() ai_promote={
  self.ai_rank = skill;
  if( (self.spawnflags & PROMOTE) ){
    self.ai_rank = self.ai_rank + 1;
    if( self.ai_rank > SKILL_ELT ){
      self.ai_rank = SKILL_ELT;
    }
    self.spawnflags = self.spawnflags - PROMOTE;
  }
  if( (self.spawnflags & DEMOTE) ){
    self.ai_rank = self.ai_rank - 1;
    if( self.ai_rank < SKILL_NOV ){
      self.ai_rank = SKILL_NOV;
    }
    self.spawnflags = self.spawnflags - DEMOTE;
  }
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
  Finds acceptable minimum range of all AI's guns
*/
float() ai_pilot_minrange={
  local entity weaponEnt;
  local float minrange;
  local float total;
  
  for( weaponEnt = self.w_slot; weaponEnt != world; weaponEnt = weaponEnt.w_slot){
    if( weaponEnt.deadflag != DEAD_NO ){
      continue;
    }
    if( weaponEnt.damageType == DMG_MSC ){
      continue;
    }
    minrange = minrange + weaponEnt.w_range;
    total = total + 1;
  }
  
  minrange = ceil(minrange / total);
  return minrange;
};