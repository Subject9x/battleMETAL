/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI tanks
    tanks have turrets
  
  handles
    sv/main/controllers/ctrl_tank.ctrl_send_tank()
*/

/*
  EVENT - MOVE
*/
void() sendevent_tank_move={
  local entity weps;
  
  for(weps = self.w_slot; weps != world; weps = weps.w_slot){
    if( weps.partParentId == M_LEGS ){
      weps.angles = self.angles;
    }
    else{
      weps.angles = self.torsoCenter.angles;
    }
  }
};

/*
  EVENT - DEATH
*/
void() sendevent_tank_die={
  local entity weps;
  local entity this;
  local entity rem;
  
  makevectors(self.angles);
  self.origin = self.origin + (v_up * -2);
  self.colormod = '0.33 0.33 0.33';
  if( self.torsoCenter.partTypeId && self.torsoCenter != world ){
    rem = self.torsoCenter;
    self.torsoCenter = world;
    remove(rem);
  }     
  weps = self.w_slot;
  while( weps ){
    rem = weps;
    weps = rem.w_slot;
    if( rem.data_idx && rem.owner == self ){
      remove(rem);
    }
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
  SendEntity - Tank =======================================
*/
void( float isNew, float changeFlags ) sendent_handle_tank={
  local float prevShield;
  local float pclEffect;
  local vector turretAng;
  
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = ReadAngle();
  self.angles_y = ReadAngle();
  self.angles_z = ReadAngle();
  
    //EVENT - NEW ENTITY
  if( changeFlags & SENDFLAG_NEWENT ){
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
    data_sync_new_vehicle( self.data_idx );
    self.drawmask = MASK_ENGINE;
    
    sendent_setup_weapons();

    setmodel(self, self.model);
    setsize(self, self.mins, self.maxs);
    self.predraw = predraw_tank;
    sendent_ini_interpolate();
  }
  self.shield = ReadShort();
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );

  //EVENT - TURRET ROTATES
  if( changeFlags & SENDFLAG_TURRET ){
    turretAng_x = anglemod(ReadAngle());
    turretAng_y = anglemod(ReadAngle());
    turretAng_z = anglemod(ReadAngle());
    sendevent_turret_update( turretAng );
  }
  
  //EVENT - UNIT MOVE
  if( changeFlags & SENDFLAG_MOVE ){
    sendevent_tank_move();
  }
  
  //EVENT - DEATH
  if( changeFlags & SENDFLAG_DEAD ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      sendevent_tank_die();
    }
  }
  //EVENT - CRITICAL HIT
  if( changeFlags & SENDFLAG_CRIT ){
    pclEffect = ReadByte();
    if( pclEffect > 0 ){
      self.pcl_effectnum = pclEffect;
    }
  }
  //EVENT - DEAD AND BURNING
  if( changeFlags & SENDFLAG_BURN ){
    if( self.pcl_effectnum > 0 || self.deadflag == DEAD_DEAD ){
      makevectors(self.angles);
      pointparticles( self.pcl_effectnum, self.origin + (v_up * 5), normalize( (self.origin + (v_up * 5)) - self.origin) * 5, 0.5);
    }
  }
};

/*
  PREDRAW - Tank
*/
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
  self.lerpfrac = 1-bound(0, self.lerpfrac, 10);

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
    for( weps = self.w_slot; weps != world; weps = weps.w_slot ){
      if( weps.partParentId == M_LEGS ){
        makevectors(self.angles);
        saved = (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
        weps.origin = self.origin + saved ;
      }
      else{
        makevectors(self.torsoCenter.angles);
        saved = (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
        weps.origin = self.torsoCenter.origin + saved;
      }
    }
  }
  
  return TRUE;
};