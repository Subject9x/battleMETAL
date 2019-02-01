/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
mod : 09/19/2018
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

void() building_radar_cooldown={
  if( time > self.ai_action_time ){
    self.enemy = world;
    ai_next_state( ST_STAND );
    ai_sfx_huntEnd();
    return;
  }
};

void() building_radar_has_enemy={
  local float dist, rng;
  dist = vlen( self.origin - self.enemy.origin );
  
  //target player is running PASSIVE radar
  rng = self.radar_range;
  if( self.enemy.stat_rdr_mode == 0 ){
    rng = self.radar_range / 2;
  }
  
  //target player is outside radar range
  if( dist > rng ){
    ai_next_state( ST_HUNT );
    self.ai_action_time = self.ai_action_time + self.w_firetime;
    ai_sfx_huntStart();
    return;
  }
  
  if( time > self.ai_action_time ){
    ai_sfx_spotted();
    ai_next_state( ST_MISSILE );
    return;
  }
};

void() building_radar_send_target={
  local entity ally, this;
  this = self;
  ally = findchainfloat( i_faction, self.i_faction );
  while( ally ){
    if( vlen( ally.origin - self.origin ) <= (self.radar_range / 2) ){
      if( ai_valid_target(ally) ){
        //heh, sloppy check for combat units
        if( ally.w_slot != world ){
          ai_give_target( ally, self.enemy, FALSE );
        }
      }
    }
    ally = ally.chain;
  }
  
  self.enemy = world;
  ai_next_state( ST_STAND );
  return;
};

void() building_radar_sweep={
  local entity blip, found;
  local float rng, sweep, low, high, yaw;
  //TODO - Magic numbers
  self.radar_time = anglemod( self.radar_time + 6 );

  sweep = self.radar_time;
  low = anglemod( sweep - 5 );
  high = anglemod( sweep + 1 );
  
  blip = findradius( self.origin, self.radar_range );
  while( blip ){
    if( blip.deadflag <= DEAD_NO ){
      if( (blip.flags & FL_CLIENT) ){
        if( blip.i_faction != self.i_faction ){
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
    blip = blip.chain;
  }
  
  if( found != world){
    self.enemy = found;
    ai_sfx_warning();
    ai_next_state( ST_RUN );
    self.ai_action_time = self.ai_action_time + self.w_firetime;
    return;
  }
};

void() building_radar_think={
  
  ai_state_control( self.attack_state );
  
  building_burn();
  
  self.think = building_radar_think;
  self.nextthink = time + 0.1;
};

/*QUAKED building_human_radar (.1 .1 .1) (-20 -20 0) (20 20 13)
*/
void() building_human_radar={
  self.data_idx = ID_BLD_H_RADAR;
  self.data_type = DATA_BLD;
  self.ai_rank = skill;
  self.w_firetime = DAT_BLD_H_SM_RADAR_LOCK_ON;
  self.vec_name = "Listening Post";
  self.flags = (FL_MONSTER | FL_UNIT);
  self.vec_size = 1;
  util_setModel(DAT_BLD_H_SM_RADAR_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_SM_RADAR_HP, DAT_BLD_H_SM_RADAR_HP, 1, 100) ;
  setsize(self, '-20 -20 0', '20 20 26');
  self.sh_cur = 0;
  self.sh_max = DAT_BLD_H_SM_RADAR_SH_MAX;
  self.sh_rate = DAT_BLD_H_SM_RADAR_SH_RATE;
  self.stat_rdr_mode = TRUE;
  self.radar_range = DAT_BLD_H_SM_RADAR_RADAR_RANGE;
  
  switch( self.ai_rank ){
    case 1:
      self.radar_range = self.radar_range * 0.7;
      self.w_firetime = self.w_firetime * 0.85;
      break;
    case 2:
      self.radar_range = self.radar_range * 0.85;
      self.w_firetime = self.w_firetime * 0.70;
      break;
    case 3:
      self.w_firetime = self.w_firetime * 0.55;
      break;
    default:
      self.radar_range = self.radar_range * 0.55;
      break;
  }
  
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();  
  
  self.th_stand = building_radar_sweep;
  self.th_run = building_radar_has_enemy;
  self.th_missile = building_radar_send_target;
  self.th_hunt = building_radar_cooldown;
  
  self.ai_action_mod = 0.15;
  
  ai_initialize_system( ST_STAND );
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  self.th_die = building_die;
  self.think = building_radar_think;
  self.use = multi_trigger;
  self.nextthink = time + 1;
};