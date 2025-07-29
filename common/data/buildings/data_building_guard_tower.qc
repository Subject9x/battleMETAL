/*
battleMETAL
Author: Peter Roohr
Date: 09/11/2019
Overview: 
  data file for the simple guard tower building

  CSQC
    self.viewAngle = cached V_RIGHT when building initialized on client
    self.viewAngle1 = cached V_UP when building initialized on client
    self.viewAngle2 = cached V_FORWARD when building initialized on client
*/


void() guard_tower_die2={
#ifdef SSQC
  TEMP_VEC1 = randompos(self.absmin, self.absmax);
  te_debris( TEMP_VEC1, normalize(TEMP_VEC1 - self.origin) * 5, '0 0 0', 3, 2 );
  building_die();
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  Sound7_Dynamic(self, CHAN_AUTO, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, (0.4 + (random() * 0.5)) * 100, SOUNDFLAG_DYNAMIC_INT);
#endif
};

void() guard_tower_die1={
#ifdef SSQC
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.solid = SOLID_NOT;
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  makevectors(self.angles);
  TEMP_VEC1 = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));
  te_debris( TEMP_VEC1, normalize(TEMP_VEC1 - self.origin) * 6, '0 0 0', 6, 3 );
  ai_alert_close(self.enemy);
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '1 0.67 0.67', 0.01 );
  Sound7_Dynamic(self, CHAN_AUTO, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, (0.4 + (random() * 0.5)) * 100, SOUNDFLAG_DYNAMIC_INT);
#endif
  self.think = guard_tower_die2;
  self.nextthink = time + 0.1;
};

#ifdef CSQC
void() guard_post_dlights={
  //apparently when menu running, these just get STACCCCCCKED and murder framerate.
  if(MENU_PROG_OFF){
    particleDraw = vlen(CLIENT_vis_org - self.origin);      
    if( particleDraw <= PARTICLE_HAZ_DISTANCE ){ 
      if( self.deadflag == DEAD_NO ){
        makevectors(self.w_adj_ang);
        adddynamiclight2( self.origin + (v_forward * 32), 128, '1 1 0.4', self.partTypeId, "", PFLAGS_FULLDYNAMIC);
      }
    }
  }
};

void() guard_post_th={
  if( self.spawnflags & 2097152){
    //shutoff lights
    self.render_dlights = SUB_Null;
    return;
  }
  if( self.deadflag == DEAD_NO ){
    self.w_adj_ang_y = anglemod(self.w_adj_ang_y + 4);
  }
  self.think = guard_post_th;
  self.nextthink = time + 0.05;
};
#endif


void() building_guard_tower={
  self.data_idx = self.nextVecChoice = UI_BUILDING_guard_tower;
  self.data_type = DATA_BLD;
  
  self.vec_name = "Guard Tower";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 1;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_STEP;
  self.takedamage = DAMAGE_AIM;
  self.model = "models/buildings/towersmall/guardtower.obj";
  precache_model("models/buildings/towersmall/guardtower.obj");
  setmodel(self, "models/buildings/towersmall/guardtower.obj");
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  self.deadflag = DEAD_NO;
  
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
  
  self.th_die = guard_tower_die1;

#ifdef CSQC
  self.th_walk = guard_post_th;
  self.render_dlights = guard_post_dlights;
  self.compOffset = self.origin + (v_up * 36);
  self.w_adj_ang =  self.angles;
#endif

#ifdef SSQC
  if( self.angle ){
    self.angles_y = self.angle;
  }
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();

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
  self.think = building_bbox_settle;
  self.nextthink = time + 0.01;
#endif
};