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
    case SENDTYPE_CHUNK:
      sendent_handle_chunk( isNew, entFlags );
      break;
    case SENDTYPE_PROJ:
      sendent_handle_missile( isNew, entFlags );
      break;
    case SENDTYPE_MAP:
      sendent_handle_map( isNew, entFlags );
      break;
  }
};

void( float isNew, float changeFlags ) sendent_handle_tank={
  local vector turretAng;
  local entity this;
  local entity weps;
    
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();
  
  self.flags = ReadByte();
  
  if( changeFlags & SENDFLAG_MOVE ){
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      if( weps.partParentId == M_UNIT || weps.partParentId == M_LEGS ){
        weps.angles = self.angles;
      }
      weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
    }
  }
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
  if( changeFlags & SENDFLAG_NEWENT ){
    self.faction = ReadByte();
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    self.skin =  self.faction - 1;
    
    self.drawmask = MASK_ENGINE;
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
      data_sync_new_vehicle( self.data_idx );
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

void( float isNew, float changeFlags) sendent_handle_spg={
  local entity weps;
  local entity this;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();
  
  self.flags = ReadByte();
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    setorigin(self, self.origin);
    makevectors(self.angles);
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
    self.data_type = ReadByte();
    
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

void( float isNew, float changeFlags) sendent_handle_gev={
  local vector turretAng;
  local entity weps;
  local entity this;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  self.angles_x = ReadCoord();
  self.angles_y = ReadCoord();
  self.angles_z = ReadCoord();
  self.flags = ReadByte();
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    setorigin(self, self.origin);
    makevectors(self.angles);
    if( self.torsoCenter ){
      self.torsoCenter.origin = self.origin + (v_right * self.torsoCenter.compOffset_x) + (v_forward * self.torsoCenter.compOffset_z) + (v_up * self.torsoCenter.compOffset_y);
    }
    makevectors(self.angles);
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
    self.data_type = ReadByte();
   
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
      self.drawmask = MASK_ENGINE;
      data_sync_new_vehicle(self.data_idx);
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

void( float isNew, float changeFlags) sendent_handle_turret={
  local vector turretAng;
  local entity weps;
  local entity this;
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
    setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
    self.angles = self.angles;
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.colormod = '0.85 0.85 0.85';
    if( self.torsoCenter ){
      remove(self.torsoCenter);
    }
    weps = self.w_slot;
    while( weps ){
      this = weps.w_slot;
      remove(weps);
      weps = this;
    }
    te_missile_explode( self.origin, self.vec_size, '0.9 0.67 0.33',  rint(2 + random() * self.vec_size), 1, 0.01 ) ;
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
    self.data_type = ReadByte();

    data_sync_new_turret(self.data_idx);
    
    self.drawmask = MASK_ENGINE;
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    this = self;
    for(weps = self.w_slot; weps != world; weps = weps.w_slot){
      self = weps;
        sendent_set_weapon();
        initialize_data_item_(self.data_idx);
        self.angles = this.angles;
        self.owner = this;
      self = this;
    }
    setmodel(self, self.model);
    setorigin(self, self.origin);
  }
};

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
    self.data_type = ReadByte();
    
    data_sync_new_building(self.data_idx);
    self.colormod = '1 1 1';
    setmodel(self, self.model);
    setorigin(self, self.origin);
    self.drawmask = MASK_ENGINE;
  }
};

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
