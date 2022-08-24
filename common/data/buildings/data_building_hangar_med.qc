/*
battleMETAL
Author: Peter Roohr
Date: 09/03/2019
Overview:
  a smaller, vehicle hangar.
*/

void() hangar_vehicle_die2;
void() hangar_vehicle_die3;
void() hangar_vehicle_die4;
void() hangar_vehicle_die5;
void() hangar_vehicle_die6;
void() hangar_vehicle_die7;
void() hangar_vehicle_die8;
void() hangar_vehicle_die9;
void() hangar_vehicle_die10;
void() hangar_vehicle_die11;
void() hangar_vehicle_die12;
void() hangar_vehicle_die13;
void() hangar_vehicle_die14;
void() hangar_vehicle_die15;

void() hangar_vehicle_die1=[0, hangar_vehicle_die2]{
#ifdef SSQC
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
  
  ai_alert_close(self.enemy);
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();

#endif
  
};
void() hangar_vehicle_die2=[0, hangar_vehicle_die3]{

};
void() hangar_vehicle_die3=[0, hangar_vehicle_die4]{
#ifdef SSQC
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.mins_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();

#endif
};
void() hangar_vehicle_die4=[0, hangar_vehicle_die5]{
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();

#endif
};
void() hangar_vehicle_die5=[0, hangar_vehicle_die6]{
#ifdef SSQC
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * self.maxs_z) + (v_forward * (self.mins_y * 0.18)) + (v_right * (self.mins_x * 0.15));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die6=[0, hangar_vehicle_die7]{

#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die7=[0, hangar_vehicle_die8]{
#ifdef SSQC
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die8=[0, hangar_vehicle_die9]{
#ifdef SSQC
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die9=[0, hangar_vehicle_die10]{
#ifdef SSQC
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die10=[0, hangar_vehicle_die11]{
#ifdef SSQC
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 2, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die11=[0, hangar_vehicle_die12]{
#ifdef SSQC
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die12=[0, hangar_vehicle_die13]{

#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die13=[0, hangar_vehicle_die14]{
#ifdef SSQC
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die14=[0, hangar_vehicle_die15]{

#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};
void() hangar_vehicle_die15=[0, SUB_Null]{
#ifdef SSQC
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 5,1 );
  building_die();
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();
#endif
};

void() building_hangar_vehicle={

  self.data_idx = self.nextVecChoice = UI_BUILDING_hangar_med;
  self.data_type = DATA_BLD;
  
  self.vec_name = "Vehicle Hangar";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 2;
  self.solid = SOLID_BBOX;
  self.movetype = MOVETYPE_PUSH;
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.skin = self.faction - 1;
  self.model = "q3mdl/buildings/hangar_vehicle/hangar_vehicle.md3";
  precache_model("q3mdl/buildings/hangar_vehicle/hangar_vehicle.md3");
  setmodel(self, "q3mdl/buildings/hangar_vehicle/hangar_vehicle.md3");
  setsize(self, self.mins, self.maxs);
  
  if( !self.health) {
    self.health = 500;
  }
  self.max_health = self.health;
  
  if( !self.shieldMax ){
    self.shieldMax = 400;
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
    self.th_die = hangar_vehicle_die1;

  #ifdef SSQC
    self.use = multi_trigger;
  
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