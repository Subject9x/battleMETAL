/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for turret buildings, a unique form of building
  
  handles
    sv/main/controllers/ctrl_building.ctrl_send_turret()
*/

void() sendevent_turret_die={
  local entity weps;
  local entity rem;
  
  makevectors(self.angles);
  setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
  self.colormod = '0.85 0.85 0.85';
  
  self.origin = self.origin + (v_up * (self.maxs_z * -0.5));
  setorigin(self, self.origin);
  if( self.torsoCenter.owner == self ){
    sendent_handle_remove(self.torsoCenter);
  }
  weps = self.w_slot;
  while( weps ){
    rem = weps;
    weps = rem.w_slot;
    if( rem.owner == self ){
      sendent_handle_remove(rem);
    }
  }
  te_missile_explode( self.origin + (v_up * self.maxs_z), self.vec_size + 1, '0.9 0.67 0.33', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  if( self.effect1.owner == self && self.effect1 != world ){
    sendent_handle_remove(self.effect1);
  }
  if( self.effect2.owner == self && self.effect2 != world ){
    sendent_handle_remove(self.effect2);
  }
  if( self.effect3.owner == self && self.effect3 != world ){
    sendent_handle_remove(self.effect3);
  }
};

/*
  SendEntity - Turret =======================================
*/
void( float isNew, float changeFlags) sendent_handle_turret={
  local vector turretAng;
  local entity this;
  local float prevShield;
  
    //EVENT - New to player
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
    
    self.entId = ReadLong();
    self.data_idx = ReadByte();
    self.spawnflags = ReadLong();
    
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    setorigin( self, self.origin );
    if( isNew ){
      self.flags = self.flags | FL_MONSTER ;
      self.data_type = DATA_BLD;
      self.colormod = '1 1 1';
      data_sync_new_turret(self.data_idx);
      sendent_setup_weapons();
    }
    sendent_ini_interpolate();
    self.interpolate_entity = interpolate_turret;
    self.drawmask = MASK_ENGINE;
    self.predraw = predraw_turret;
  }
  
  //EVENT - MOVE - for turrets, this means a general update tic.
  prevShield = self.shield;
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.shield = ReadShort();
  }
  
  //EVENT - faction changed
  if( (changeFlags & SENDFLAG_VELOCITY) ){     
    self.faction = ReadByte();
  }
  
  //EVENT - turret rotated
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng = te_read_vector();
  }
  
  //EVENT - death
  if( (changeFlags & SENDFLAG_DEAD) ){ 
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      sendevent_turret_die() ;
    }
  }
  
  //EVENT - health dropped below threshold
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadLong();
    if( self.burnBits > 0 ){
      if( (self.burnBits & WEAPON1) && !self.effect1.count ){
        self.effect1 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.85;
      }
      if( (self.burnBits & WEAPON2) && !self.effect2.count ){
        self.effect2 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.75;
      }
      if( (self.burnBits & WEAPON3) && !self.effect3.count ){
        self.effect3 = te_building_fire_start( self );
        self.colormod = self.colormod * 0.67;
      }
    }
  }
  
  //HANDLE EVENT - Shield explode
  sendevent_shield_explode( prevShield );
  
  //HANDLE EVENT - turret rotate
  sendevent_turret_update( turretAng );
  
  if( isNew ){      
    if( self.torsoCenter ){
      this = self;
      self = this.torsoCenter;
        sendent_ini_interpolate();
      self = this;
    }
  }
};

void() interpolate_turret={
  local entity parent;
  local entity wepn;
  local vector saved;
  
  interpolate_origin();
  interpolate_angle();
  interpolate_ground();
  
  parent = self;
  makevectors(parent.angles);
  if( self.torsoCenter ){
    self = self.torsoCenter;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      interpolate_origin();
      interpolate_angle();
      interpolate_ground();
      self.think = SUB_Null;
      self.nextthink = time + 0.01;
      addentity(self);
    self = parent;
  }
  
  wepn = self.w_slot;
  while( (wepn != world) ){
    self = wepn;
      if( self.partParentId == M_LEGS ){
        makevectors(parent.angles);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        self.origin = parent.origin + saved ;
        self.angles = parent.angles;
      }
      else{
        makevectors(parent.torsoCenter.angles);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        self.origin = parent.origin + saved ;
        self.angles = parent.torsoCenter.angles;
      }
      interpolate_origin();
      interpolate_angle();
      interpolate_ground();
      self.think = SUB_Null;
      self.nextthink = time + 0.01;
      addentity(self);
    self = parent;
    wepn = wepn.w_slot;
  }
  self.think = SUB_Null;
  self.nextthink = time + 0.01;
};

float() predraw_turret={
  if(self.deadflag == DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
  return FALSE;
};