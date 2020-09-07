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
  local entity rem;
  
  if( (self.flags & FL_TURRET) ){
    if( self.torsoCenter.partTypeId && self.torsoCenter != world ){
      sendent_handle_remove(self.torsoCenter);
    }     
  }
  weps = self.w_slot;
  while( weps ){
    rem = weps;
    weps = rem.w_slot;
    if( rem.data_idx && rem.owner == self ){
      sendent_handle_remove(rem);
    }
  }
  
  data_vehicle_wreck();
  
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
  local string newName;
  local entity parent;
  local float prevAttackFlag;
  
  prevShield = self.shield;
  
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.angles_x = anglemod(ReadAngle());
  self.angles_y = anglemod(ReadAngle());
  self.angles_z = anglemod(ReadAngle());
  
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
    
    newName = ReadString();
    if( isNew ){
      if( newName != "" ){
        if( self.netname != "" ){
          local string s;
          s = self.netname;
          strunzone(s);
        }
        self.netname = strzone(newName);
      }
      data_sync_new_vehicle( self.data_idx );
      self.predraw = predraw_tank;
    }
  }
  
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shield = ReadByte();
    self.shieldHitFlag = ReadByte();
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );

  //EVENT - TURRET ROTATES
  if( changeFlags & SENDFLAG_TURRET ){
    turretAng_x = anglemod(ReadAngle());
    turretAng_y = anglemod(ReadAngle());
    turretAng_z = anglemod(ReadAngle());
    self.v_angle = turretAng;
    self.v_angle_x = self.v_angle_x * -1;
    turretAng_x = 0;
    sendevent_turret_update( turretAng );
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
  
  //EVENT - UNIT MOVE
  if( changeFlags & SENDFLAG_MOVE ){
    prevAttackFlag = self.attackFlag;
    self.attackFlag = ReadLong();
    sendevent_tank_move();
  }
  
  if( (self.attackFlag != 0) && (prevAttackFlag != self.attackFlag) ){
    sendevent_handle_weaponfire();
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );  
  
  //Shield strike event
  if( self.shieldHitFlag == TRUE && (self.shield > 0 && self.shield < 100.01)){
    if( time > self.shieldEffectTime ){
      self.shieldEffectTime = time + 0.5;
      te_shield_hit();
    }
  }
};

void() interpolate_tank={
  local entity parent;
  local entity wepn;
  local vector saved;
  
  interpolate_origin();
  interpolate_angle();
  //interpolate_ground();
  setorigin(self, self.origin);
  
  parent = self;
  makevectors(self.angles);
  
  if( self.torsoCenter ){
    self = self.torsoCenter;
      self.origin = parent.origin + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
    self = parent;
  }
  
  wepn = self.w_slot;
  while( (wepn != world) ){
    self = wepn;
      if( self.partParentId == M_LEGS ){
        makevectors(parent.angles);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        saved = parent.origin + saved;
        self.angles = parent.angles + self.w_adj_ang;
      }
      else{
        makevectors(parent.torsoCenter.angles);
        saved = (v_right * self.compOffset_x) + (v_forward * self.compOffset_z) + (v_up * self.compOffset_y);
        saved = parent.torsoCenter.origin + saved;
        self.angles = parent.torsoCenter.angles + self.w_adj_ang;
      }
      self.origin = saved;
    self = parent;
    wepn = wepn.w_slot;
  }
};

float() predraw_tank={
  if(self.deadflag==DEAD_NO){
    if(self.interpolate_entity){
      self.interpolate_entity();
    }
  }
  return FALSE;
};