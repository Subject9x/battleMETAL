/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for AI mechs
  
  handles
    sv/main/controllers/ctrl_mech.ctrl_send_mech_ai()
*/

void() mech_ai_think={
  self.think = mech_ai_think;
  self.nextthink = time + 0.1;
};

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
  if( self.torsoCenter.owner == self &&  self.torsoLeft.partTypeId == M_TOR_CENTER){
    sendent_handle_remove(self.torsoCenter);
  }
  if( self.torsoLeft.owner == self &&  self.torsoLeft.partTypeId == M_TOR_LEFT){
    sendent_handle_remove(self.torsoLeft);
  }
  if( self.torsoRight.owner == self &&  self.torsoRight.partTypeId == M_TOR_RIGHT){
    sendent_handle_remove(self.torsoRight);
  }
  if( self.armLeft.owner == self &&  self.armLeft.partTypeId == M_ARM_LEFT){
    sendent_handle_remove(self.armLeft);
  }
  if( self.armRight.owner == self &&  self.armRight.partTypeId == M_ARM_RIGHT){
    sendent_handle_remove(self.armRight);
  }
  if( self.legs.owner == self &&  self.legs.partTypeId == M_LEGS){
    sendent_handle_remove(self.legs);
  }
  weps = self.w_slot;
  while( weps != world ){
    rem = weps;
    weps = rem.w_slot;
    if( rem.data_idx && rem.owner == self ){
      sendent_handle_remove(rem);
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
      sendent_handle_remove(self.torsoLeft);
    }
  }
  if( (critical & M_TOR_RIGHT) ){
    if( self.torsoRight != world ){
      te_missile_explode( self.torsoRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      sendent_handle_remove(self.torsoRight);
    }
  }
  if( (critical & M_ARM_LEFT) ){
    if( self.armLeft != world ){
      te_missile_explode( self.armLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      sendent_handle_remove(self.armLeft);
    }
  }
  if( (critical & M_ARM_RIGHT) ){
    if( self.armRight != world ){
      te_missile_explode( self.armRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
      sendent_handle_remove(self.armRight);
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
      prev.w_slot = weps.w_slot;
      weps = weps.w_slot;
      remove(rem);
    }
    else{
      prev = weps;
      weps = weps.w_slot;
    }
  }
  pointsound( self.origin, "sound/fx_boom.ogg", 0.5 + (random() * 0.5) , ATTN_NORM );
};

void(float criticalHits) sendevent_mech_burn={  
  local vector offset;
  
  if( (criticalHits & M_TOR_LEFT) ){
    offset = self.torsoLeft.origin;
    te_mech_crit( offset, '0 0 10');
  }
  if( (criticalHits & M_TOR_RIGHT) ){
    offset = self.torsoRight.origin;
    te_mech_crit( offset, '0 0 10');
  }
  if( (criticalHits & M_ARM_LEFT) ){
    if( !(self.damageValue & M_TOR_LEFT) ){
      offset = self.armLeft.origin;
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (criticalHits & M_ARM_RIGHT) ){
    if( !(self.damageValue & M_TOR_RIGHT) ){
    offset = self.armRight.origin;
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (criticalHits & M_LEGS) ){
    offset = self.legs.origin + '0 0 -10';
    te_mech_crit( offset, '0 0 10');
  }
};

/*
  SendEntity - MECH AI =====================================
*/
void( float isNew, float changeFlags ) sendent_handle_mech_ai={
  local entity this;
  local float prevShield;
  local vector turretAng;
  local float critical;
  local string newName;
  local float prevAttackFlag;
  
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = anglemod(ReadAngle());
  self.angles_y = anglemod(ReadAngle());
  self.angles_z = anglemod(ReadAngle());
  
  self.legDir = ReadShort();
  
  //self.flags = ReadLong(); // DEBUG - disabled for now.
  self.shield = ReadShort();
  
  if( (changeFlags & SENDFLAG_NEWENT) ){   
    self.entId = ReadLong(); 
    self.flags = ReadLong();
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
    
    newName = ReadString();
    setorigin(self, self.origin);
    if( isNew ){ 
      if( newName != "" ){
        self.netname = strzone(newName);
      }   
      self.data_type = DATA_MECH;
      self.skin =  self.faction - 1;
      self.movetype = MOVETYPE_STEP;
      data_sync_new_mech_ai( self.data_idx );
      self.deadflag = DEAD_NO;
      self.critBits = 0;
      setmodel(self, "q3mdl/testball.md3");
      setsize(self, self.mins, self.maxs);
      self.think = mech_ai_think;
      self.nextthink = time + 0.1;
      sendent_ini_interpolate();
      sendent_setup_weapons();
    }
    self.alpha = 0.001;
    self.scale = 0.001;
    self.interpolate_entity = interpolate_mech_ai;
    self.drawmask = MASK_ENGINE;
    self.predraw = predraw_mech_ai;
  }
    
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      sendevent_mech_ai_die();
    }
  }
  
  //EVENT - MOVE
  if( (changeFlags & SENDFLAG_MOVE) ){
    prevAttackFlag = self.attackFlag;
    self.attackFlag = ReadLong();
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
    self.critBits = ReadByte();
    if( self.critBits > 0 ){
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
  if( isNew ){      
    
  }
  if( (self.attackFlag != 0) && (prevAttackFlag != self.attackFlag) ){
    sendevent_handle_weaponfire();
  }
};

void() interpolate_mech_ai={
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
    self = parent;
  }
  if( self.legs ){
    self = self.legs;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.angles;
    self = parent;
  }
  makevectors(parent.torsoCenter.angles);
  if( !(self.critBits & M_TOR_LEFT) && self.torsoLeft != world){
    self = self.torsoLeft;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
  }
  if( !(self.critBits & M_TOR_RIGHT) && self.torsoRight != world ){
    self = self.torsoRight;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
  }
  if( !(self.critBits & M_ARM_RIGHT) && self.armRight != world ){
    self = self.armRight;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
  }
  if( !(self.critBits & M_ARM_LEFT) && self.armLeft != world ){
    self = self.armLeft;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
  }
  
  if( self.legs != world ){
    self = self.legs;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.angles;
      self.angles_y = parent.legDir;
    self = parent;
  }
  
  wepn = self.w_slot;
  while( (wepn != world) ){
    self = wepn;
      if( !(parent.critBits & wepn.partParentId) ){
        if( self.partParentId == M_LEGS ){
          makevectors(parent.angles);
          saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
          self.origin = parent.origin + saved ;
        }
        else{
          makevectors(parent.torsoCenter.angles);
          saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
          self.origin = parent.torsoCenter.origin + saved;
        }
      }
    self = parent;
    wepn = wepn.w_slot;
  }
};

float() predraw_mech_ai={
  if(self.deadflag==DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
  return FALSE;
};