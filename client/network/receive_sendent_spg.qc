/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI tank destroyers ( Self-propelled gun )
    SPGs dont have turrets
  
  handles
    sv/main/controllers/ctrl_tank.ctrl_send_spg()
*/

/*
  EVENT - MOVE
*/
void() sendevent_spg_move={
  local entity weps;
  makevectors(self.angles);
  for(weps = self.w_slot; weps != world; weps = weps.w_slot){
    weps.angles = self.angles;
    weps.origin = self.origin + (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
  }
};

/*
  EVENT - DEATH
*/
void() sendevent_spg_die={
  local entity weps;
  local entity this;
  local entity rem;

  weps = self.w_slot;
  while( weps ){
    rem = weps;
    weps = rem.w_slot;
    if( rem.data_idx && rem.owner == self ){
      remove(rem);
    }
  }
  
  data_vehicle_wreck();
  
  te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
};

/*
  SendEntity - SPG =======================================
*/
void( float isNew, float changeFlags) sendent_handle_spg={
  local float prevShield;
  local float pclEffect;
  
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
    self.predraw = predraw_spg;
    sendent_ini_interpolate();
  }
  
  self.shield = ReadShort();
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    sendevent_spg_move();
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      sendevent_spg_die();
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

/*
  PREDRAW - SPG
*/
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