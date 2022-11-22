/*
battleMETAL
Author: Peter Roohr
Date: 05/08/2020
Overview: data file for building
  
  type: Barracks
  faction: any
  func: 
    Decoration, mostly an aesthetics building used to fill-out base areas.
*/

void() barracks_die2;
void() barracks_die3;
void() barracks_die4;
void() barracks_die5;
void() barracks_die6;
void() barracks_die7;
void() barracks_die8;
void() barracks_die9;
void() barracks_die10;
void() barracks_die11;
void() barracks_die12;
void() barracks_die13;
void() barracks_die14;
void() barracks_die15;

void() barracks_die1=[0, barracks_die2]{

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
  
  if( self.canTarget ){
    self.deadflag = DEAD_DYING;
    self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  }
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() barracks_die2=[0, barracks_die3]{

};
void() barracks_die3=[0, barracks_die4]{
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
void() barracks_die4=[0, barracks_die5]{

};
void() barracks_die5=[0, barracks_die6]{
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
void() barracks_die6=[0, barracks_die7]{

};
void() barracks_die7=[0, barracks_die8]{
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
void() barracks_die8=[0, barracks_die9]{
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
void() barracks_die9=[0, barracks_die10]{
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
void() barracks_die10=[0, barracks_die11]{
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
void() barracks_die11=[0, barracks_die12]{
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
void() barracks_die12=[0, barracks_die13]{

};
void() barracks_die13=[0, barracks_die14]{
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
void() barracks_die14=[0, barracks_die15]{

};
void() barracks_die15=[0, SUB_Null]{
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

void() building_barracks={

  self.data_idx = self.nextVecChoice = UI_BUILDING_barracks;
  self.data_type = DATA_BLD;

  self.vec_name = "Barracks";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 2;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_STEP;
  self.takedamage = DAMAGE_AIM;
  self.skin = self.faction - 1;
  self.model = "models/buildings/barracks/barracks.md3";
  precache_model("models/buildings/barracks/barracks.md3");
  setmodel(self, "models/buildings/barracks/barracks.md3");
  setsize(self, self.mins, self.maxs);
  
  if( !self.health) {
    self.health = 275;
  }
  self.max_health = self.health;
  
  if( !self.shieldMax ){
    self.shieldMax = 300;
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
  
  self.th_die = barracks_die1;

#ifdef SSQC
  if( self.angle ){
    self.angles_y = self.angle;
  }

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();

  self.use = multi_trigger;
  self.effects = self.effects | EF_LOWPRECISION;
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