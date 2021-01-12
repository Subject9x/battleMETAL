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
  local vector v1;
  
  makevectors(self.v_angle);
  v1 = self.origin + (v_up * self.cockpit.compOffset_y);
  traceline(v1, v1 + v_forward*10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  
  self.think = mech_ai_think;
  self.nextthink = time + 0.001;
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
void() mech_corpse_remove={

  if( self.legs != world ){
    remove(self.legs);
  }
  if( self.torsoLeft != world ){
    remove(self.torsoLeft);
  }
  if( self.torsoRight != world ){
    remove(self.torsoRight);
  }
  if( self.armLeft != world ){
    remove(self.armLeft);
  }
  if( self.armRight != world ){
    remove(self.armRight);
  }
  if(self.effect1 != world ){
    remove(self.effect1);
  }
  self.drawmask = 0;
  remove(self);
};


void() mech_corpse_th={
  self.think = mech_corpse_th;
  if( time > self.data_lifetime ){
    self.think = mech_corpse_remove;
  }
  self.nextthink = time + 0.1;
};
//watch this
float() predraw_mech_corpse={
  local entity parent;
  local entity piece;
  
  local vector orgOfs;
  local vector modAngle;
  
  parent = self;

  if( self.legs != world ){
    addentity(self.legs );
  }
  if( !(self.criticalHits & M_TOR_LEFT) && self.torsoLeft != world){
    addentity(self.torsoLeft);
  }
  if( !(self.criticalHits & M_TOR_RIGHT) && self.torsoRight != world ){
    addentity(self.torsoRight);
  }
  if( !(self.criticalHits & M_ARM_RIGHT) && self.armRight != world ){
    addentity(self.armRight);
  }
  if( !(self.criticalHits & M_ARM_LEFT) && self.armLeft != world ){
    addentity(self.armLeft);
  }
  
  return FALSE;
};
void() sendevent_mech_ai_die_standing={
  local entity mechRoot;
  local entity mechTorLeft;
  local entity mechTorRight;
  local entity mechArmLeft;
  local entity mechArmRight;
  local entity mechLegs;
  local entity pass;
  
  pass = self;
  
  mechRoot = spawn();
  mechRoot.solid = SOLID_NOT;
  mechRoot.movetype = MOVETYPE_NONE;
  mechRoot.origin = self.torsoCenter.origin;
  
  mechRoot.compOffset = self.origin;
  mechRoot.angles = self.torsoCenter.angles;
  mechRoot.angles_x = anglemod(mechRoot.angles_x + (crandom() * 20));
  mechRoot.angles_y = anglemod(mechRoot.angles_y + (crandom() * 10));
  mechRoot.compAltOffset = self.angles;
  mechRoot.model = modelnameforindex(self.torsoCenter.modelindex);
  setmodel(mechRoot, self.torsoCenter.model);
  setsize(mechRoot, '-1 -1 -1', '1 1 1');
  setorigin(mechRoot, mechRoot.origin);
  mechRoot.skin = self.skin;
  mechRoot.colormod = '0.45 0.45 0.45';
  mechRoot.predraw = predraw_mech_corpse;
  mechRoot.criticalHits = self.criticalHits;
  mechRoot.drawmask = MASK_ENGINE;
  
  mechLegs = te_mech_chunk_stand(pass, pass.legs, pass.angles);
  mechLegs.frame = self.legs.frame;
  mechRoot.legs = mechLegs;
  mechRoot.legs.angles = self.legs.angles;
  mechRoot.legs.angles_y = self.legDir;
  
  if( !(mechRoot.criticalHits & M_TOR_LEFT) ){
    mechTorLeft = te_mech_chunk_stand(pass, pass.torsoLeft, mechRoot.angles);
    mechRoot.torsoLeft = mechTorLeft;
    if( !(mechRoot.criticalHits & M_ARM_LEFT) ){
      mechArmLeft = te_mech_chunk_stand(pass, pass.armLeft, mechRoot.angles);
      mechRoot.armLeft = mechArmLeft;
    }
  }
  
  if( !(mechRoot.criticalHits & M_TOR_RIGHT) ){
    mechTorRight = te_mech_chunk_stand(pass, pass.torsoRight, mechRoot.angles);
    mechRoot.torsoRight = mechTorRight;
    if( !(mechRoot.criticalHits & M_ARM_RIGHT) ){
      mechArmRight = te_mech_chunk_stand(pass, pass.armRight, mechRoot.angles);
      mechRoot.armRight = mechArmRight;
    }
  }
  
  mechRoot.vec_size = self.vec_size;
  mechRoot.effect1 = te_building_fire_start( mechRoot );
  mechRoot.effect1.origin = mechRoot.origin;
  mechRoot.effect1.origin_z = mechRoot.effect1.origin_z + self.maxs_z;
  
  mechRoot.data_lifetime = time + 360 + (random() * 180);
  mechRoot.think = mech_corpse_th;
  mechRoot.nextthink = time + 0.1;
  
};

void() sendevent_mech_ai_die={
  local entity weps;
  local entity rem;
  local float wId;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  weps = self.w_slot;
  for(wId = 0; wId < self.hardpoint_cnt; wId = wId + 1){
    rem = weps;
    weps = rem.w_slot;
    sendent_handle_remove(rem);
  }
  makevectors(self.angles);
  te_missile_explode( self.origin + (v_up * self.maxs_z * 0.67), self.vec_size * 2, '0.9 0.75 0.45', 0.01 );
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  
  if( self.moveState == FALSE ){
    sendevent_mech_ai_die_standing();
  }
  else{
    self.alpha = 0.01;
    self.scale = 0.01;
    sendent_handle_remove(self.torsoCenter);
    sendent_handle_remove(self.torsoLeft);
    sendent_handle_remove(self.torsoRight);
    sendent_handle_remove(self.armLeft);
    sendent_handle_remove(self.armRight);
    sendent_handle_remove(self.legs);
    te_mech_dead_legs( self.legs );
  }
};

/*
  EVENT - CRITICAL =====================================
*/
void( float critical ) sendevent_mech_ai_crit={  
  
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
    if( !(self.critBits & M_TOR_LEFT) ){
      offset = self.armLeft.origin;
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (criticalHits & M_ARM_RIGHT) ){
    if( !(self.critBits & M_TOR_RIGHT) ){
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
  local vector turretAng;
  local float critical;
  local string newName;
  local float prevShield;
  local float prevAttackFlag;
  local float prevDeadFlag;
  
  prevShield = self.shield;
  prevDeadFlag = self.deadflag;
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    self.moveState = ReadByte();
    
    sendevent_mech_ai_move();
    if(self.moveState > 0 ){
      self.ai_dir = 1;
    }
    else{
      self.ai_dir = 0;
    }
  }
  
  if( (changeFlags & SENDFLAG_ANGLE) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = 0;
    self.legDir = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    self.critBits = ReadCoord();
    if( self.critBits != 0 ){
      sendevent_mech_ai_crit( self.critBits );
      self.criticalHits = self.criticalHits | self.critBits;
    }
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.flags = ReadCoord();
    self.faction = ReadByte();
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
  }
  
  if( isNew ){
    setorigin(self, self.origin);
    self.think = mech_ai_think;
    self.nextthink = time + 0.01;
    cacheGlobalString(self.netname, newName )
    self.data_type = DATA_MECH;
    self.skin =  self.faction - 1;
    self.movetype = MOVETYPE_STEP;
    data_sync_new_mech_ai( self.data_idx );
    self.interpolate_entity = interpolate_mech_ai;
    self.drawmask = MASK_ENGINE;
    self.predraw = predraw_mech_ai;
    self.canTarget = TRUE;
  }
  
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = ReadCoord();
    sendevent_handle_weaponfire();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng_x = anglemod(ReadAngle());
    turretAng_y = anglemod(ReadAngle());
    turretAng_z = anglemod(ReadAngle());
    self.v_angle = turretAng;
    self.v_angle_x = self.v_angle_x * -1;
    turretAng_x = 0;
    sendevent_turret_update( turretAng );
  }

  //EVENT - CRITICAL HIT
  if( (changeFlags & SENDFLAG_CRIT) ){
    self.critBits = ReadCoord();
    if( self.critBits != 0 ){
      sendevent_mech_ai_crit( self.critBits );
      self.criticalHits = self.criticalHits | self.critBits;
    }
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadCoord();
    if( self.burnBits > 0 ){
      sendevent_mech_burn( self.burnBits );
    }
  }
  
  //Shield strike event
  if( self.shieldHitFlag == SHIELD_HIT_UP && (self.shield > 0 && self.shield < 100.01)){
    if( time > self.shieldEffectTime ){
      self.shieldEffectTime = time + 0.5;
      te_shield_hit();
    }
  }
  
  //Shield Explode event
  if( !isNew ){
    sendevent_shield_explode( prevShield );
  }
  
  if( self.deadflag > DEAD_NO && prevDeadFlag == DEAD_NO ){
    sendevent_mech_ai_die();
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
    addentity(self.torsoCenter);
  }
  if( self.legs != world ){
    self = self.legs;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.angles;
      self.angles_y = parent.legDir;
    self = parent;
    predraw_legs();
    addentity(self.legs);
  }
  
  makevectors(parent.torsoCenter.angles);
  if( !(self.critBits & M_TOR_LEFT) && self.torsoLeft != world){
    self = self.torsoLeft;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
    addentity(self.torsoLeft);
  }
  if( !(self.criticalHits & M_TOR_RIGHT) && self.torsoRight != world ){
    self = self.torsoRight;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
    addentity(self.torsoRight);
  }
  if( !(self.criticalHits & M_ARM_RIGHT) && self.armRight != world ){
    self = self.armRight;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
    addentity(self.armRight);
  }
  if( !(self.criticalHits & M_ARM_LEFT) && self.armLeft != world ){
    self = self.armLeft;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
      self.angles = parent.torsoCenter.angles;
    self = parent;
    addentity(self.armLeft);
  }
  
  wepn = self.w_slot;
  while( (wepn != world) ){
    self = wepn;
      if( !(parent.criticalHits & wepn.partParentId) ){
        addentity(wepn);
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
    setorigin(self, self.origin);
  }
  return FALSE;
};