/*
battleMETAL
Author: Peter Roohr
Date: 09/11/2019
Overview: 
  data file for the simple guard tower building
*/

#ifdef SSQC
void() guard_tower_die2={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
};

void() guard_tower_die1={
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD; 
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  self.model = "q3mdl/map/ruins/ruin_small.obj";
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);

 
  if( self.canTarget ){
    self.deadflag = DEAD_DYING;
    self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  }
  
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 5, 1 );
  
  ai_alert_close(self.enemy);
  
  self.think = guard_tower_die2;
  self.nextthink = time + 0.1;
};
#endif

void() building_guard_tower={
  self.data_idx = self.nextVecChoice = UI_BUILDING_guard_tower;
  self.data_type = DATA_BLD;
  
  self.vec_name = "Guard Tower";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 1;
  self.solid = SOLID_BSP;
  self.movetype = MOVETYPE_NONE;
  self.takedamage = DAMAGE_AIM;
  setmodel(self, "q3mdl/buildings/towersmall/guardtower.obj");
  setsize(self, self.mins, self.maxs);
  
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  
  
  if( !self.health) {
    self.health = 200;
  }
  self.max_health = self.health;
  
  if( !self.shieldMax ){
    self.shieldMax = 150;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0;
  }
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 1000;
  }
  
  
  #ifdef SSQC
    if( ai_can_spawn() == FALSE ){
      remove(self);
      return;
    }
    trigger_ext_check();

    self.th_die = guard_tower_die1;
    self.effects = self.effects | EF_LOWPRECISION;
    if( !(self.spawnflags & NO_DROP) ){
      if( util_cornerSlopeCheck(self, 0.95) ){
        util_generateBuildingFoundation(self);
      }
      else{
        droptofloor();
      }
    }
    makevectors(self.angles);
    self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
    
    self.SendEntity = ctrl_send_building;
    self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
    if( (self.spawnflags & IS_MAPKEY) ){
      self.effects = self.effects | EF_NODEPTHTEST;
    }
    self.canTarget = TRUE;
    if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
      self.canTarget = FALSE;
    }
    self.think = building_burn_th;
    self.nextthink = time + random() * 3;
  #endif
};