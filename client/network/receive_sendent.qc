/*
battleMETAL
Author: Peter Roohr
Date: 3/10/2020
Overview: 
  impl file for SendEntity functionality....sigh.
  I don't even know if it's worth it to try this.
*/

/*
  Entry point for handler api
*/
void( float isNew ) sendent_handle_update={
  local float entType;
  local float entFlags;
  
  entType = ReadByte();
  entFlags = ReadByte();
  
  switch(entType){
    case SENDTYPE_TANK:
      sendent_handle_tank( isNew, entFlags );
      break;
    case SENDTYPE_SPG:
      sendent_handle_spg( isNew, entFlags );
      break;
    case SENDTYPE_GEV:
      sendent_handle_gev( isNew, entFlags );
      break;
    case SENDTYPE_TURRET:
      sendent_handle_turret( isNew, entFlags );
      break;
    case SENDTYPE_BUILD:
      sendent_handle_building( isNew, entFlags );
      break;
    case SENDTYPE_MECH_AI:
      sendent_handle_mech_ai( isNew, entFlags );
      break;
    case SENDTYPE_PROJ:
      sendent_handle_missile( isNew, entFlags );
      break;
    case SENDTYPE_MAP:
      sendent_handle_map( isNew, entFlags );
      break;
  }
};
/*
  SendEntity - Tank =======================================
*/
void( float isNew, float changeFlags ) sendent_handle_tank={
  local float prevShield;
  local vector turretAng;
  local entity this;
  local entity weps;
    
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();

  self.shield = ReadByte();
  
  //EVENT - SHIELD EXPLODE
  if( self.shield <= 0 && prevShield > 0 ){
    if( time > self.shieldExplodeCool ){
      te_shield_explode( self.origin, self.vec_size);
      self.shieldExplodeCool = time + self.vec_size;
    }
  }
  //EVENT - UNIT MOVE
  if( changeFlags & SENDFLAG_MOVE ){
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      if( weps.partParentId == M_UNIT || weps.partParentId == M_LEGS ){
        weps.angles = self.angles;
      }
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
  //EVENT - TURRET ROTATES
  if( changeFlags & SENDFLAG_TURRET ){
    turretAng = te_read_vector();
    if( self.torsoCenter != world ){
      self.torsoCenter.angles_x = turretAng_x;
      self.torsoCenter.angles_y = turretAng_y;
      self.torsoCenter.angles_z = turretAng_z;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        if( weps.partParentId == M_TOR_CENTER ){
          weps.angles = self.torsoCenter.angles;
        }
        else{
          weps.angles = self.angles;
        }
      }
    }
  }
  //EVENT - DEATH
  if( changeFlags & SENDFLAG_DEAD ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      makevectors(self.angles);
      self.origin = self.origin + (v_up * -2);
      self.colormod = '0.33 0.33 0.33';
      if( self.torsoCenter != world ){
        remove(self.torsoCenter);
      }     
      weps = self.w_slot;
      while( weps ){
        this = weps.w_slot;
        remove(weps);
        weps = this;
      }
      self.deadflag = DEAD_DEAD;
      if(self.vec_size == 1){
        self.pcl_effectnum = particleeffectnum("TE_FIRE_1");
      }
      else if( self.vec_size == 2){
        self.pcl_effectnum = particleeffectnum("TE_FIRE_2");
      }
      else{
        self.pcl_effectnum = particleeffectnum("TE_FIRE_3");
      }
      te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
    }
  }
  //EVENT - CRITICAL HIT
  if( changeFlags & SENDFLAG_CRIT ){
    self.pcl_effectnum = ReadByte();
  }
  //EVENT - DEAD AND BURNING
  if( changeFlags & SENDFLAG_BURN ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      makevectors(self.angles);
      pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
    }
  }
  //EVENT - NEW ENTITY
  if( changeFlags & SENDFLAG_NEWENT ){
    self.faction = ReadByte();
    self.data_idx = ReadByte();

    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    
    if( isNew ){    
      self.skin =  self.faction - 1;
      data_sync_new_vehicle( self.data_idx );
      self.flags = self.flags | (FL_MONSTER | FL_UNIT);
      self.drawmask = MASK_ENGINE;
      self.data_type = DATA_VEHC;
      this = self;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        self = weps;
          sendent_set_weapon();
          initialize_data_item_(self.data_idx);
          self.angles = this.angles;
          self.owner = this;
        self = this;
      }
      self.movetype = MOVETYPE_STEP;
      self.solid = SOLID_SLIDEBOX;
      setmodel(self, self.model);
      setsize(self, self.mins, self.maxs);
      self.predraw = predraw_tank;
      self.frame2time = time + 0.05;
      self.frame1time = time + 0.05;
      self.origin2 = self.origin1;
      self.origin1 = self.origin;
      self.nextthink = time + 0.1;
    }
  }
};

/*
  SendEntity - SPG =======================================
*/
void( float isNew, float changeFlags) sendent_handle_spg={
  local float prevShield;
  local entity weps;
  local entity this;
  
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();
  
  self.shield = ReadByte();
  
  //Shield Explode event
  if( self.shield <= 0 && prevShield > 0 ){
    if( time > self.shieldExplodeCool ){
      te_shield_explode( self.origin, self.vec_size);
      self.shieldExplodeCool = time + self.vec_size;
    }
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      weps.angles = self.angles;
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      makevectors(self.angles);
      self.origin = self.origin + (v_up * -2);
      self.colormod = '0.33 0.33 0.33';  
      weps = self.w_slot;
      while( weps ){
        this = weps.w_slot;
        remove(weps);
        weps = this;
      }
      self.deadflag = DEAD_DEAD;
      if(self.vec_size == 1){
        self.pcl_effectnum = particleeffectnum("TE_FIRE_1");
      }
      else if( self.vec_size == 2){
        self.pcl_effectnum = particleeffectnum("TE_FIRE_2");
      }
      else{
        self.pcl_effectnum = particleeffectnum("TE_FIRE_3");
      }
      te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
    }
  }
  
  if( changeFlags & SENDFLAG_CRIT ){
    self.pcl_effectnum = ReadByte();
  }
  
  if( changeFlags & SENDFLAG_BURN ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      makevectors(self.angles);
      pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
    }
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();

    if( isNew ){
      self.drawmask = MASK_ENGINE;
      self.skin =  self.faction - 1;
      data_sync_new_vehicle(self.data_idx);
      self.data_type = DATA_VEHC;
      self.flags = self.flags | (FL_MONSTER | FL_UNIT);
      this = self;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        self = weps;
          sendent_set_weapon();
          initialize_data_item_(self.data_idx);
          self.angles = this.angles;
          self.owner = this;
        self = this;
      }
      self.movetype = MOVETYPE_STEP;
      self.solid = SOLID_SLIDEBOX;
      setmodel(self, self.model);
      setsize(self, self.mins, self.maxs);
      self.predraw = predraw_spg;
      self.frame2time = time + 0.05;
      self.frame1time = time + 0.05;
      self.origin2 = self.origin1;
      self.origin1 = self.origin;
      self.nextthink = time + 0.1;
    }
  }
};

/*
  SendEntity - GEV =======================================
*/
void( float isNew, float changeFlags) sendent_handle_gev={
  local float prevShield;
  local vector turretAng;
  local entity weps;
  local entity this;
  
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
 
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();
  
  self.shield = ReadByte();
  
  //Shield Explode event
  if( self.shield <= 0 && prevShield > 0 ){
    if( time > self.shieldExplodeCool ){
      te_shield_explode( self.origin, self.vec_size);
      self.shieldExplodeCool = time + self.vec_size;
    }
  }
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    makevectors(self.angles);
    if( self.torsoCenter ){
      self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
    }
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      if( weps.partParentId == M_UNIT || weps.partParentId == M_LEGS ){
        weps.angles = self.angles;
      }
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng = te_read_vector();
    if( self.torsoCenter != world ){
      self.torsoCenter.angles_x = turretAng_x;
      self.torsoCenter.angles_y = turretAng_y;
      self.torsoCenter.angles_z = turretAng_z;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        if( weps.partParentId == M_TOR_CENTER ){
          weps.angles = self.angles;
        }
      }
    }
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      makevectors(self.angles);
      self.colormod = '0.33 0.33 0.33';  
      te_missile_explode( self.origin, self.vec_size, '0.9 0.67 0.33', 0.02 ) ;
      weps = self.w_slot;
      while( weps ){
        this = weps.w_slot;
        remove(weps);
        weps = this;
      }
      self.deadflag = DEAD_DEAD;
      if(self.vec_size == 1){
        self.pcl_effectnum = particleeffectnum("TE_FIRE_1");
      }
      else if( self.vec_size == 2){
        self.pcl_effectnum = particleeffectnum("TE_FIRE_2");
      }
      else{
        self.pcl_effectnum = particleeffectnum("TE_FIRE_3");
      }
      te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
    }
  }
  
  if( changeFlags & SENDFLAG_CRIT ){
    self.pcl_effectnum = ReadByte();
  }
  
  if( changeFlags & SENDFLAG_BURN ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      makevectors(self.angles);
      pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
    }
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.faction = ReadByte();
    self.data_idx = ReadByte();
   
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    
    if( isNew ){
      self.skin =  self.faction - 1;
      data_sync_new_vehicle(self.data_idx);
      self.drawmask = MASK_ENGINE;
      self.data_type = DATA_VEHC;
      self.flags = self.flags | (FL_MONSTER | FL_UNIT);
      this = self;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        self = weps;
          sendent_set_weapon();
          initialize_data_item_(self.data_idx);
          self.angles = this.angles;
          self.owner = this;
        self = this;
      }
      self.movetype = MOVETYPE_STEP;
      self.solid = SOLID_SLIDEBOX;
      setmodel(self, self.model);
      setsize(self, self.mins, self.maxs);
      self.predraw = predraw_tank;
      self.frame2time = time + 0.05;
      self.frame1time = time + 0.05;
      self.origin2 = self.origin1;
      self.origin1 = self.origin;
      self.nextthink = time + 0.1;
    }
  }
};

/*
  SendEntity - MECH AI =====================================
*/
void( float isNew, float changeFlags ) sendent_handle_mech_ai={
  local entity this;
  local entity weps;
  local float prevShield;
  local vector turretAng;
  local float critical;
  
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();
  
  self.shield = ReadByte();
  //EVENT - SHIELD EXPLODE
  if( self.shield <= 0 && prevShield > 0 ){
    if( time > self.shieldExplodeCool ){
      te_shield_explode( self.origin, self.vec_size);
      self.shieldExplodeCool = time + self.vec_size;
    }
  }
  
  //EVENT - MOVE
  if( (changeFlags & SENDFLAG_MOVE) ){
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      if( weps.partParentId == M_UNIT ){
        weps.angles = self.angles;
      }
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng = te_read_vector();
    if( self.torsoCenter ){  
      self.torsoCenter.angles_x = turretAng_x;
      self.torsoCenter.angles_y = turretAng_y;
      self.torsoCenter.angles_z = turretAng_z;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        if( weps.partParentId != M_UNIT ){
          weps.angles = self.torsoCenter.angles;
        }
        else{
          weps.angles = self.angles;
        }
      }
    }
  }

  //EVENT - CRITICAL HIT
  if( (changeFlags & SENDFLAG_CRIT) ){
    critical = ReadByte();
    if( critical > 0 ){
      cons_logAFloat("CS()->critical", critical); //DEBUG
      if( (critical & M_TOR_LEFT) ){
        te_missile_explode( self.torsoLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
        self.torsoLeft.think = SUB_Remove;
        self.torsoLeft.nextthink = time + 0.1;
      }
      if( (critical & M_TOR_RIGHT) ){
        te_missile_explode( self.torsoRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
        self.torsoRight.think = SUB_Remove;
        self.torsoRight.nextthink = time + 0.1;
      }
      if( (critical & M_ARM_LEFT) ){
        te_missile_explode( self.armLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
        self.armLeft.think = SUB_Remove;
        self.armLeft.nextthink = time + 0.1;
      }
      if( (critical & M_ARM_RIGHT) ){
        te_missile_explode( self.armRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
        self.armRight.think = SUB_Remove;
        self.armRight.nextthink = time + 0.1;
      }
      if( (critical & M_LEGS) ){
        te_missile_explode( self.legs.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
        self.legs.think = SUB_Remove;
        self.legs.nextthink = time + 0.1;
      }
      pointsound( self.origin, "sound/fx_boom.ogg", 0.7 + (random() * 0.3) , ATTN_NORM );
    }
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
  
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
      self.alpha = 0.001;
      self.scale = 0.001;
      if( self.torsoCenter ){
        self.torsoCenter.think = SUB_Remove;
        self.torsoCenter.nextthink = time + 0.1;
      }
      if( self.torsoLeft ){
        self.torsoLeft.think = SUB_Remove;
        self.torsoLeft.nextthink = time + 0.1;
      }
      if( self.torsoRight ){
        self.torsoRight.think = SUB_Remove;
        self.torsoRight.nextthink = time + 0.1;
      }
      if( self.armLeft ){
        self.armLeft.think = SUB_Remove;
        self.armLeft.nextthink = time + 0.1;
      }
      if( self.armRight ){
        self.armRight.think = SUB_Remove;
        self.armRight.nextthink = time + 0.1;
      }
      if( self.legs ){
        self.legs.think = SUB_Remove;
        self.legs.nextthink = time + 0.1;
      }
    }
  }

  if( (changeFlags & SENDFLAG_NEWENT) ){    
    self.faction = ReadByte();
    self.data_idx = ReadByte();
   
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    
    if( isNew ){    
      self.skin =  self.faction - 1;
      data_sync_new_mech_ai( self.data_idx );
      self.flags = self.flags | (FL_MONSTER | FL_UNIT);
      self.drawmask = MASK_ENGINE;
      self.data_type = DATA_MECH;
      this = self;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        self = weps;
          sendent_set_weapon();
          initialize_data_item_(self.data_idx);
          self.angles = this.angles;
          self.owner = this;
        self = this;
      }
      self.movetype = MOVETYPE_STEP;
      self.solid = SOLID_SLIDEBOX;
      setmodel(self, "q3mdl/testball.md3");
      setsize(self, self.mins, self.maxs);
      self.predraw = predraw_mech_ai;
      self.frame2time = time + 0.05;
      self.frame1time = time + 0.05;
      self.origin2 = self.origin1;
      self.origin1 = self.origin;
      self.nextthink = time + 0.1;
    }
  }
};



/*
  SendEntity - Turret =======================================
*/
void( float isNew, float changeFlags) sendent_handle_turret={
  local vector turretAng;
  local entity weps;
  local entity this;
  local float prevShield;
  
  //EVENT - MOVE - for turrets, this means a general update tic.
  prevShield = self.shield;
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.shield = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng = te_read_vector();
    if( self.torsoCenter != world ){
      self.torsoCenter.angles_x = turretAng_x;
      self.torsoCenter.angles_y = turretAng_y;
      self.torsoCenter.angles_z = turretAng_z;
    }
    makevectors(turretAng);
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      weps.angles = turretAng;
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
  if( (changeFlags & SENDFLAG_DEAD) ){ 
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      makevectors(self.angles);
      setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
      self.colormod = '0.85 0.85 0.85';
      traceline(self.origin, self.origin + (v_up * (self.maxs_z * -0.5)), FALSE, self);
      setorigin(self, trace_endpos);
      if( self.torsoCenter ){
        remove(self.torsoCenter);
      }
      weps = self.w_slot;
      while( weps ){
        this = weps.w_slot;
        remove(weps);
        weps = this;
      }
      te_missile_explode( self.origin + (v_up * self.maxs_z), self.vec_size + 1, '0.9 0.67 0.33', 0.01 ) ;
      pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
    }
  }
  if( (changeFlags & SENDFLAG_CRIT) ){
    if( self.effect1 ){
      if( self.effect2 ){
        if( !self.effect3 ){
          self.effect3 = te_building_fire_start( self );
        }
      }
      else{
        self.effect2 = te_building_fire_start( self );
      }
    }
    else{
      self.effect1 = te_building_fire_start( self );
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = ReadCoord();
    self.angles_y = ReadCoord();
    self.angles_z = ReadCoord();
    
    self.faction = ReadByte();
    self.data_idx = ReadByte();

    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    if( isNew ){
      data_sync_new_turret(self.data_idx);
      self.flags = self.flags | (FL_MONSTER | FL_UNIT);
      self.data_type = DATA_BLD;
      self.colormod = '1 1 1';
      self.drawmask = MASK_ENGINE;
      this = self;
      for(weps = self.w_slot; weps != world; weps = weps.w_slot){
        self = weps;
          sendent_set_weapon();
          initialize_data_item_(self.data_idx);
          self.angles = this.angles;
          self.owner = this;
        self = this;
      }
      setorigin( self, self.origin );
    }
  }
};

/*
  SendEntity - Building =======================================
*/
void( float isNew, float changeFlags) sendent_handle_building={
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      
      makevectors(self.angles);
      switch( self.vec_size ){
        case 2:
          setmodel(self, "q3mdl/map/ruins/ruin_medium.obj");
          break;
        case 3:
          setmodel(self, "q3mdl/map/ruins/ruin_large.obj");
          break;
        default:
          setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
          break;
      }
      setorigin(self, self.origin + (v_up * -10));
    }
  }

  if( (changeFlags & SENDFLAG_CRIT) ){
    if( self.effect1 ){
      if( self.effect2 ){
        if( !self.effect3 ){
          self.effect3 = te_building_fire_start( self );
        }
      }
      else{
        self.effect2 = te_building_fire_start( self );
      }
    }
    else{
      self.effect1 = te_building_fire_start( self );
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = ReadCoord();
    self.angles_y = ReadCoord();
    self.angles_z = ReadCoord();
    
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    
    if( isNew ){
      self.solid = SOLID_SLIDEBOX;
      self.movetype = MOVETYPE_NONE;
      data_sync_new_building(self.data_idx);
      self.data_type = DATA_BLD;
      self.flags = self.flags | (FL_MONSTER | FL_UNIT); 
      self.colormod = '1 1 1';
      setorigin(self, self.origin);
      self.drawmask = MASK_ENGINE;
    }
  }
};

/*
  SendEntity - Projectile ====================================
*/
void( float isNew, float changeFlags) sendent_handle_missile={
  local float impactEvent;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();

  self.velocity_x = ReadCoord();
  self.velocity_y = ReadCoord();
  self.velocity_z = ReadCoord();

  if( changeFlags & SENDFLAG_IMPACT ){
    self.impactType = ReadByte();
    self.damageValue = ReadByte();
    if( self.pcl_explode ){
      self.pcl_explode();
    }
  }
  if( changeFlags & 128 ){
    self.data_idx = ReadByte();
    self.damageValue = ReadByte();
    self.movetype = ReadByte();
    
    if( isNew ){
      self.solid = SOLID_NOT;
      data_sync_new_projectile(self.data_idx);
      setmodel(self, self.model);
      setsize(self, '0 0 0', '0 0 0');
      self.origin2 = self.origin;
      self.origin1 = self.origin;
      setorigin(self, self.origin);
      self.drawmask = MASK_NORMAL;
      self.predraw = predraw_missile;
      self.alpha = 1;
      self.scale = 1;
      self.nextthink = time + 0.1;
    }
  }
};

float() predraw_tank={
  local entity weps;
  local vector saved;
  if( self.nextthink != self.frame1time ){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    self.origin2 = self.origin1;
		self.origin1 = self.origin;
  }
  self.lerpfrac = (time - self.frame2time) / (self.frame1time-self.frame2time);
  self.lerpfrac = 1-bound(0, self.lerpfrac, 1);

  if( (self.flags & (FL_ONGROUND|FL_PARTIALGROUND)) ){
    saved = self.origin;
    self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
    self.origin_z = saved_z;
  }
  else{
    self.origin2 = self.origin1 = self.origin;
  }

  if( self.deadflag == DEAD_NO ){
    makevectors(self.angles);
    if( self.torsoCenter != world ){
      self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
    }
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      if( weps.partParentId == M_TOR_CENTER ){
        weps.angles = self.torsoCenter.angles;
        makevectors(self.torsoCenter.angles);
      }
      else{
        makevectors(self.angles);
      }
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
  
  return TRUE;
};
float() predraw_spg={
  local entity weps;
  local vector saved;

  if( self.nextthink != self.frame1time ){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    self.origin2 = self.origin1;
		self.origin1 = self.origin;
  }
  self.lerpfrac = (time - self.frame2time) / (self.frame1time-self.frame2time);
  self.lerpfrac = 1-bound(0, self.lerpfrac, 1);

  if( (self.flags & (FL_ONGROUND|FL_PARTIALGROUND)) ){
    saved = self.origin;
    self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
    self.origin_z = saved_z;
  }
  else{
    self.origin2 = self.origin1 = self.origin;
  }
  
  if( self.deadflag == DEAD_NO ){
    makevectors(self.angles);
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
  return TRUE;
};


float() predraw_turret={
  
  

  return TRUE;
};

float() predraw_mech_ai={
  local entity weps;
  local vector saved;
  if( self.nextthink != self.frame1time ){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    self.origin2 = self.origin1;
		self.origin1 = self.origin;
  }
  self.lerpfrac = (time - self.frame2time) / (self.frame1time-self.frame2time);
  self.lerpfrac = 1-bound(0, self.lerpfrac, 1);

  if( (self.flags & (FL_ONGROUND|FL_PARTIALGROUND)) ){
    saved = self.origin;
    self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
    self.origin_z = saved_z;
  }
  else{
    self.origin2 = self.origin1 = self.origin;
  }

  if( self.deadflag == DEAD_NO ){
    makevectors(self.angles);
    if( self.torsoCenter != world ){
      self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
    }
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      if( weps.partParentId == M_TOR_CENTER ){
        weps.angles = self.torsoCenter.angles;
        makevectors(self.torsoCenter.angles);
      }
      else{
        makevectors(self.angles);
      }
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
    makevectors(self.torsoCenter.angles);
    if( self.torsoLeft ){
      self.torsoLeft.angles = self.torsoCenter.angles;
      self.torsoLeft.origin = self.origin + (v_right * self.torsoLeft.compOffset_x) + (v_forward * self.torsoLeft.compOffset_z) + (v_up * self.torsoLeft.compOffset_y);self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
    }
    if( self.torsoRight ){
      self.torsoRight.angles = self.torsoCenter.angles;
      self.torsoRight.origin = self.origin + (v_right * self.torsoRight.compOffset_x) + (v_forward * self.torsoRight.compOffset_z) + (v_up * self.torsoRight.compOffset_y);
    }
    if( self.armLeft ){
      self.armLeft.angles = self.torsoCenter.angles;
      self.armLeft.origin = self.origin + (v_right * self.armLeft.compOffset_x) + (v_forward * self.armLeft.compOffset_z) + (v_up * self.armLeft.compOffset_y);
    }
    if( self.armRight ){
      self.armRight.angles = self.torsoCenter.angles;
      self.armRight.origin = self.origin + (v_right * self.armRight.compOffset_x) + (v_forward * self.armRight.compOffset_z) + (v_up * self.armRight.compOffset_y);
    }
  }
  
  

  return TRUE;
};


void() sendent_set_weapon={
  switch(self.w_group){
     case WEAPON1:
      self.data_idx = self.owner.next_wepn1;
      return;
     case WEAPON2:
      self.data_idx = self.owner.next_wepn2;
      return;
     case WEAPON3:
      self.data_idx = self.owner.next_wepn3;
      return;
     case WEAPON4:
      self.data_idx = self.owner.next_wepn4;
      return;
     case WEAPON5:
      self.data_idx = self.owner.next_wepn5;
      return;
     case WEAPON6:
      self.data_idx = self.owner.next_wepn6;
      return;
     case WEAPON7:
      self.data_idx = self.owner.next_wepn7;
      return;
     case WEAPON8:
      self.data_idx = self.owner.next_wepn8;
      return;
     case WEAPON9:
      self.data_idx = self.owner.next_wepn9;
      return;
  }
};
