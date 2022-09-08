/*
battleMETAL
Author: Peter Roohr
Date: 05/08/2020
Overview: data file for building
  
  type: Supply Depot
  faction: any
  func: 
    Decoration, mostly an aesthetics building used to fill-out base areas.
*/
void() supply_depot_die2;
void() supply_depot_die3;
void() supply_depot_die4;
void() supply_depot_die5;
void() supply_depot_die6;
void() supply_depot_die7;
void() supply_depot_die8;
void() supply_depot_die9;
void() supply_depot_die10;
void() supply_depot_die11;
void() supply_depot_die12;
void() supply_depot_die13;
void() supply_depot_die14;
void() supply_depot_die15;

void() supply_depot_die1=[0, supply_depot_die2]{
  
#ifdef SSQC
  local vector vfx;
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
  ai_alert_close(self.enemy);
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die2=[0, supply_depot_die3]{

};
void() supply_depot_die3=[0, supply_depot_die4]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.mins_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die4=[0, supply_depot_die5]{

};
void() supply_depot_die5=[0, supply_depot_die6]{
#ifdef SSQC
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * self.maxs_z) + (v_forward * (self.mins_y * 0.18)) + (v_right * (self.mins_x * 0.15));
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die6=[0, supply_depot_die7]{

};
void() supply_depot_die7=[0, supply_depot_die8]{
#ifdef SSQC
  local vector vfx;
  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die8=[0, supply_depot_die9]{
#ifdef SSQC
  local vector vfx;
  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die9=[0, supply_depot_die10]{
#ifdef SSQC
  local vector vfx;
  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die10=[0, supply_depot_die11]{
#ifdef SSQC
  local vector vfx;
  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 2, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die11=[0, supply_depot_die12]{
#ifdef SSQC
  local vector vfx;
  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die12=[0, supply_depot_die13]{

};
void() supply_depot_die13=[0, supply_depot_die14]{
#ifdef SSQC
  local vector vfx;
  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() supply_depot_die14=[0, supply_depot_die15]{

};
void() supply_depot_die15=[0, SUB_Null]{

#ifdef SSQC
  local vector vfx;
  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 5,1 );
  building_die();
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
  
};
void() building_supply_depot={

  self.data_idx = self.nextVecChoice = UI_BUILDING_supply_depot;
  self.data_type = DATA_BLD;

  if( !self.health) {
    self.health = 350;
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
    self.energyMax = 100;
  }

  self.vec_name = "Supply Depot";
  self.flags = self.flags | FL_MONSTER ;
  self.vec_size = 2;
  
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.takedamage = DAMAGE_AIM;
  
  self.skin = self.faction - 1;
  self.model = "models/buildings/depot/supply_depot.md3";
  precache_model("models/buildings/depot/supply_depot.md3");
  setmodel(self, "models/buildings/depot/supply_depot.md3");
  setsize(self, self.mins, self.maxs);
  
  self.th_die = supply_depot_die1;
  
  #ifdef SSQC
    self.angles_y = self.angle;
    self.effects = self.effects | EF_LOWPRECISION;
    if( ai_can_spawn() == FALSE ){
      remove(self);
      return;
    }
    trigger_ext_check();
    
    self.use = multi_trigger;
    
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
    
    if( (self.spawnflags & IS_MAPKEY) ){
      self.effects = self.effects | EF_NODEPTHTEST;
    }
    self.canTarget = TRUE;
    if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
      self.canTarget = FALSE;
    }
    self.SendEntity = ctrl_send_building;
    self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
    
    self.think = building_bbox_settle;
    self.nextthink = time + 0.01;
  #endif
};