/*
battleMETAL
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: Power Plant
  faction: any
  func: provides radar scanning to all friendly units and buildings in radius.
*/


void() hpower_die = [0, hpower_die1]{
#ifdef SSQC
  if( self.deadflag > DEAD_NO){
    return;
  }
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  ai_alert_close(self.enemy);
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() hpower_die1 = [1, hpower_die2]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() hpower_die2 = [2, hpower_die3]{};
void() hpower_die3 = [3, hpower_die4]{};
void() hpower_die4 = [4, hpower_die5]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 4, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() hpower_die5 = [5, hpower_die6]{};
void() hpower_die6 = [6, hpower_die7]{};
void() hpower_die7 = [7, hpower_die8]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() hpower_die8 = [8, hpower_die9]{};
void() hpower_die9 = [9, hpower_die10]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif

};
void() hpower_die10 = [10, hpower_die11]{};
void() hpower_die11 = [11, hpower_die12]{};
void() hpower_die12 = [12, hpower_die13]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 2, 3 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() hpower_die13 = [13, hpower_die14]{};
void() hpower_die14 = [14, hpower_die15]{
#ifdef SSQC
  local vector shoot;
  local entity head;
  
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
  
  //EMP bomb
  for( head = nextent(world); head != world; head = nextent(head) ){
    if( vlen(head.origin - self.origin) > (self.ai_minrange / 2) ){
      continue;
    }
    if( !(head.flags & FL_UNIT) && !(head.flags & FL_CLIENT) ){
      continue;
    }
    head.energy = head.energy - self.energy * 0.25;
    if( head.energy < 0 ){
      head.energy = 0;
    }
  }
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() hpower_die15 = [15, SUB_Null]{
#ifdef SSQC
  building_die();
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};

#ifdef SSQC
void() hpower_th ={
  local entity t;
  local float cost;
  
  cost = 0;
  if( self.energy > 0 ){
    //power friendly local buildings
    for( t = nextent(world); t != world; t = nextent(t)){
      if(t == self){
        continue;
      }
      if( t.data_type != DATA_BLD ){
        continue;
      }
      if(vlen(t.origin - self.origin) > self.ai_minrange){
        continue;
      }
      if(t.faction != self.faction){
        continue;
      }
      t.energy = t.energy + self.energyRate;
      if( t.energy > t.energyMax ){
        t.energy = t.energyMax;
      }
      cost = cost + (self.energyRate * 0.08);
    }
  }
  self.energy = self.energy - cost;
  self.energy = self.energy + self.energyRate;
  if(self.energy > self.energyMax){
    self.energy = self.energyMax;
  }
    
  building_burn();
  
  self.SendFlags = self.SendFlags | SENDFLAG_ENERGY;
  
  if( self.last_shield != self.stat_client_shield ){
    self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
    self.last_shield = self.stat_client_shield;
  }
  
  self.think = hpower_th;
  self.nextthink = time + 0.1;
}; 
#endif
void() building_power={
  self.data_idx = self.nextVecChoice = UI_BUILDING_power_plant;
  self.data_type = DATA_BLD;
  
  self.deadflag = DEAD_NO;  
  self.vec_name = "Power Plant";
  self.flags = self.flags | FL_MONSTER ;
  self.vec_size = 3;
  self.scale = 1;
  self.solid = SOLID_BBOX;
  self.movetype = MOVETYPE_STEP;
  self.takedamage = DAMAGE_AIM;
  self.skin = self.faction - 1;
  self.model = "q3mdl/buildings/power_plant/powerplant.md3";
  precache_model("q3mdl/buildings/power_plant/powerplant.md3");
  setmodel(self, "q3mdl/buildings/power_plant/powerplant.md3");
  setsize(self, self.mins, self.maxs);
  
  if( !self.health) {
    self.health = 1200;
  }
  self.max_health = self.health;
  self.shield = 0;
  self.shieldMax = 300;
  self.shieldRate = 0;  //needs Shield Generator
  
  if( !self.energy ){
    self.energy = self.energyMax = 4000;
  }
  if( !self.energyRate ){
    self.energyRate = 4;
  }
  
  self.th_die = hpower_die;
  
  #ifdef SSQC
    if( !self.ai_minrange ){
      self.ai_minrange = 800;
    }
    if( !(self.spawnflags & NO_DROP) ){
      if( util_cornerSlopeCheck(self, 0.95) ){
        util_generateBuildingFoundation(self);
      }
      else{
        droptofloor();
      }
    }
    self.effects = self.effects | EF_LOWPRECISION;
    if( ai_can_spawn() == FALSE ){
      remove(self);
      return;
    }
    trigger_ext_check();
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
    
    self.building_delay_think = hpower_th;
    self.think = building_bbox_settle;
    self.nextthink = time + 0.01;
  #endif
};