/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI mechs
  
  handles
    sv/main/controllers/ctrl_mech.ctrl_send_mech_ai()
*/

/*
  EVENT - MOVE =====================================
*/
void() sendevent_mech_ai_move={
  local entity weps;
  for(weps = self.w_slot; weps != world; weps = weps.w_slot){
    if( weps.partParentId == M_UNIT || weps.partParentId == M_LEGS ){
      weps.angles = self.angles;
    }
    else{
      weps.angles = self.torsoCenter.angles;
    }
  }
};
/*
  EVENT - DEATH =====================================
*/
void() sendevent_mech_ai_die={
  local entity weps;
  local entity rem;
  te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size * 2, '0.9 0.75 0.45', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  if( self.torsoCenter.partTypeId && self.torsoCenter != world ){
    rem = self.torsoCenter;
    self.torsoCenter = world;
    remove(rem);
  }
  if( self.torsoLeft.partTypeId && self.torsoLeft != world ){
    rem = self.torsoLeft;
    self.torsoLeft = world;
    remove(rem);
  }
  if( self.torsoRight.partTypeId && self.torsoRight != world ){
    rem = self.torsoRight;
    self.torsoRight = world;
    remove(rem);
  }
  if( self.armLeft.partTypeId && self.armLeft != world ){
    rem = self.armLeft;
    self.armLeft = world;
    remove(rem);
  }
  if( self.armRight.partTypeId && self.armRight != world ){
    rem = self.armRight;
    self.armRight = world;
    remove(rem);
  }
  if( self.legs.partTypeId && self.legs != world ){
    rem = self.legs;
    self.legs = world;
    remove(rem);
  }
  weps = self.w_slot;
  while( weps != world ){
    rem = weps;
    weps = rem.w_slot;
    if( rem.data_idx && rem.owner == self ){
      remove(rem);
    }
  }
};

/*
  EVENT - CRITICAL =====================================
*/
void( float critical ) sendevent_mech_ai_crit={
  local entity weps;
  local entity rem;
  local entity prev;
  
  if( (critical & M_TOR_LEFT) ){
    if( self.torsoLeft != world ){
      te_missile_explode( self.torsoLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      rem = self.torsoLeft;
      self.torsoLeft = world;
      remove(rem);
    }
  }
  if( (critical & M_TOR_RIGHT) ){
    if( self.torsoRight != world ){
      te_missile_explode( self.torsoRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      rem = self.torsoRight;
      self.torsoRight = world;
      remove(rem);
    }
  }
  if( (critical & M_ARM_LEFT) ){
    if( self.armLeft != world ){
      te_missile_explode( self.armLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      rem = self.armLeft;
      self.armLeft = world;
      remove(rem);
    }
  }
  if( (critical & M_ARM_RIGHT) ){
    if( self.armRight != world ){
      te_missile_explode( self.armRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      rem = self.armRight;
      self.armRight = world;
      remove(rem);
    }
  }
  if( (critical & M_LEGS) ){
    te_missile_explode( self.legs.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  weps = self.w_slot;
  prev = self;
  while(weps != world ){
    if( (weps.partParentId & critical) ){
      rem = weps;
      weps = weps.w_slot;
      prev.w_slot = weps;
      remove(rem);
    }
    else{
      prev = weps;
      weps = weps.w_slot;
    }
  }
  pointsound( self.origin, "sound/fx_boom.ogg", 0.7 + (random() * 0.3) , ATTN_NORM );
};

void(float critBits) sendevent_mech_burn={  local vector offset;
  local vector offset;
  
  if( (critBits & M_TOR_LEFT) ){
    offset = self.torsoLeft.origin;
    te_mech_crit( offset, '0 0 10');
  }
  if( (critBits & M_TOR_RIGHT) ){
    offset = self.torsoRight.origin;
    te_mech_crit( offset, '0 0 10');
  }
  if( (critBits & M_ARM_LEFT) ){
    if( !(self.damageValue & M_TOR_LEFT) ){
    offset = self.armLeft.origin;
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (critBits & M_ARM_RIGHT) ){
    if( !(self.damageValue & M_TOR_RIGHT) ){
    offset = self.armRight.origin;
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (critBits & M_LEGS) ){
    offset = self.legs.origin + '0 0 -10';
    te_mech_crit( offset, '0 0 10');
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
  
  self.angles_x = anglemod(ReadAngle());
  self.angles_y = anglemod(ReadAngle());
  self.angles_z = anglemod(ReadAngle());
  
  //self.flags = ReadLong(); // DEBUG - disabled for now.
  self.shield = ReadShort();
  
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
    
    if( isNew ){    
      self.flags = self.flags | (FL_MONSTER | FL_UNIT);
      self.skin =  self.faction - 1;
      self.data_type = DATA_MECH;
      data_sync_new_mech_ai( self.data_idx );
      self.drawmask = MASK_ENGINE;
      
      sendent_setup_weapons();
      
      self.alpha = 0.001;
      self.scale = 0.001;
      setmodel(self, "q3mdl/testball.md3");
      setsize(self, self.mins, self.maxs);
      setorigin(self, self.origin);
      self.predraw = predraw_mech_ai;
      sendent_ini_interpolate(); 
    }
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      sendevent_mech_ai_die();
    }
  }
  
  //EVENT - MOVE
  if( (changeFlags & SENDFLAG_MOVE) ){
    sendevent_mech_ai_move();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng_x = anglemod(ReadAngle());
    turretAng_y = anglemod(ReadAngle());
    turretAng_z = anglemod(ReadAngle());
    sendevent_turret_update( turretAng );
  }

  //EVENT - CRITICAL HIT
  if( (changeFlags & SENDFLAG_CRIT) ){
    critical = ReadByte();
    if( critical > 0 ){
      sendevent_mech_ai_crit( critical );
    }
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadLong();
    if( self.burnBits > 0 ){
      sendevent_mech_burn( self.burnBits );
    }
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
};

float() predraw_mech_ai={
  local entity weps;
  local vector saved;
  local entity partOfs;
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
    for( weps = self.w_slot; weps != world; weps = weps.w_slot ){
      if( weps.partParentId == M_LEGS ){
        makevectors(self.angles);
        saved = (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
        weps.origin = self.origin + saved ;
      }
      else{
        makevectors(self.torsoCenter.angles);
        saved = (v_right * weps.compOffset_x) + (v_forward * weps.compOffset_z) + (v_up * weps.compOffset_y);
        weps.origin = self.origin + saved;
      }
    }
  }
  
  return TRUE;
};