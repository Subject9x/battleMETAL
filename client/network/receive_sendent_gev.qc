/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI hovercraft
  
  handles
    sv/main/controllers/ctrl_tank.ctrl_send_gev()
*/

/*
  EVENT - MOVE
*/
void() sendevent_gev_move={
  local entity weps;
  
  for(weps = self.w_slot; weps != world; weps = weps.w_slot){
    if( weps.partParentId == M_UNIT || weps.partParentId == M_LEGS ){
      weps.angles = self.angles;
    }
    else{
      weps.angles = self.torsoCenter.angles;
    }
  }
  if( self.trail_effectnum > 0 ){
    if( self.deadflag == DEAD_NO ){
      te_unit_dust( self.origin, rint(random() * 3) );
    }
  }
};

/*
  EVENT - DEATH
*/
void() sendevent_gev_die={
  local entity weps;
  local entity this;
  
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
};

/*
  SendEntity - GEV =======================================
*/
void( float isNew, float changeFlags) sendent_handle_gev={
  local float prevShield;
  local float pclEffect;
  local vector turretAng;
  local entity weps;
  local entity this;
  
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
 
  self.angles_x = anglemod(ReadAngle());
  self.angles_y = anglemod(ReadAngle());
  self.angles_z = anglemod(ReadAngle());
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.entId = ReadLong();
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
  }
  if( isNew ){
    self.skin =  self.faction - 1;
    self.data_type = DATA_VEHC;
    self.flags = self.flags | (FL_MONSTER | FL_UNIT);
    data_sync_new_vehicle(self.data_idx);
    self.drawmask = MASK_ENGINE;
    
    sendent_setup_weapons();
    
    setmodel(self, self.model);
    setsize(self, self.mins, self.maxs);

    sendent_ini_interpolate();
    te_unit_dust_set();
    
    self.predraw = predraw_tank;
  }
  
  self.shield = ReadShort();
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    sendevent_gev_move();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng_x = anglemod(ReadAngle());
    turretAng_y = anglemod(ReadAngle());
    turretAng_z = anglemod(ReadAngle());
    sendevent_turret_update( turretAng );
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      sendevent_gev_die();
    }
  }
  
  if( changeFlags & SENDFLAG_CRIT ){
    pclEffect = ReadByte();
    if( pclEffect > 0 ){
      self.pcl_effectnum = pclEffect;
    }
  }
  
  if( changeFlags & SENDFLAG_BURN ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      makevectors(self.angles);
      pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
    }
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
};