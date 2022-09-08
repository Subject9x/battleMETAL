/*
battleMETAL
Author: Peter Roohr
Date: 5/13/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

//Death Animation
void() fuel_tank_die1 = [1, fuel_tank_die2]{

#ifdef SSQC
  if( self.deadflag > DEAD_NO ){
    return;
  } 
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( pos, 1, '1 0.67 0.67', 0.01 );
  
  building_sound_explode();
#endif
};
void() fuel_tank_die2 = [2, fuel_tank_die3]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  building_sound_explode();
#endif
};
void() fuel_tank_die3 = [3, fuel_tank_die4]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 5, 3 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  
  te_missile_explode( pos, 5, '1 0.67 0.67', 0.0015 );
  building_sound_explode();
#endif
};
void() fuel_tank_die4 = [4, fuel_tank_die5]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 4, 2 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 3, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
#endif
};
void() fuel_tank_die5 = [5, fuel_tank_die6]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 1 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 3, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
#endif
};
void() fuel_tank_die6 = [6, fuel_tank_die7]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 3, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
#endif
};
void() fuel_tank_die7 = [7, fuel_tank_die8]{
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
#endif
};
void() fuel_tank_die8 = [8, fuel_tank_die9]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
#endif
};
void() fuel_tank_die9 = [9, fuel_tank_die10]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
#endif
};
void() fuel_tank_die10 = [10, fuel_tank_die11]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
#endif
};
void() fuel_tank_die11 = [11, fuel_tank_die12]{
#ifdef CSQC
  local vector pos;
  makevectors(self.angles);
  pos = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
#endif
};
void() fuel_tank_die12 = [12, fuel_tank_die12]{
#ifdef SSQC
  building_die();
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};

void() building_fuel_tank={
  self.data_idx = self.nextVecChoice = UI_BUILDING_fuel_tank;
  self.data_type = DATA_BLD;
  
  self.vec_name = "Fuel Tank";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 2;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.takedamage = DAMAGE_AIM;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  self.model = "models/buildings/fueltank/fueltank.md3";
  precache_model("models/buildings/fueltank/fueltank.md3");
  setmodel(self, "models/buildings/fueltank/fueltank.md3");
  setsize(self, self.mins, self.maxs);

  if( !self.health) {
    self.health = 100;
  }
  self.max_health = self.health;
  
  if( !self.shieldMax ){
    self.shieldMax = 250;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0;
  }
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 0;
  }
  self.th_die = fuel_tank_die1;
  
  #ifdef SSQC
    self.angles_y = self.angle;
    self.effects = self.effects | EF_LOWPRECISION;
    if( ai_can_spawn() == FALSE ){
      remove(self);
      return;
    }
    trigger_ext_check();

    if( !(self.spawnflags & NO_DROP) ){
      if( util_cornerSlopeCheck(self, 0.95) ){
        util_generateBuildingFoundation(self);
      }
      else{
        droptofloor();
      }
    }
    setorigin(self, self.origin);
    
    makevectors(self.angles);
    self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);

    self.use = multi_trigger;
    
    self.SendEntity = ctrl_send_building;
    self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
    if( (self.spawnflags & IS_MAPKEY) ){
      self.effects = self.effects | EF_NODEPTHTEST;
    }
    self.canTarget = TRUE;
    if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
      self.canTarget = FALSE;
    }
    
    self.think = building_bbox_settle;
    self.nextthink = time + 0.01;
  #endif
};