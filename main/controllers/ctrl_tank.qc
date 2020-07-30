/*
battleMETAL
Author: Peter Roohr
Date: 1/15/2019
Overview: 
  per-frame game logic update functions
  
*/

void() ctrl_updateTank={
  local entity cam;
  local entity wep;
  local vector v1;
  local vector spark;
  local float hp;
  
  cam = self.cockpit;
  
  if( !(self.flags & FL_TURRET) ){
    //Unit lacks a turret.
    self.v_angle = self.angles;
  }
  
  makevectors(self.v_angle);
  v1 = self.origin + (v_right * cam.compOffset_x) + (v_up*cam.compOffset_y) + (v_forward*cam.compOffset_z);
  traceline(v1, v1 + v_forward * 10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  self.laser_sight_timer = time + 0.05;

  if( time > self.count4 ){
    self.count4 = time + 0.1;
    if(self.energy >= 0){
      self.energy = self.energy + self.energyRate;
      if(self.energy > self.energyMax){
        self.energy = self.energyMax;
      }
    }  
    if(self.energy < 0){
      self.energy = 0;
    }
    else if(self.energy > self.energyMax){
      self.energy = self.energyMax;
    }
  }
  
  self.ai_attackPreviousEnergy = self.ai_weaponEnergy;
  self.ai_weaponEnergy = 0;
  self.currentWeaponGroup = 0;
  
  wep = self.w_slot;
  while(wep){
    ctrl_weapon_think_ai(wep);
    wep = wep.w_slot;
  }
  
  //damage-based cosmetics for unit component pieces
  if( self.deadflag <= DEAD_NO ){
    hp = self.health / self.max_health;
    if( hp <= 0.25 ){
      self.SendFlags = self.SendFlags | (SENDFLAG_BURN | SENDFLAG_CRIT);
      self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE_HOT");
      if( self.data_type == DATA_BLD ){
        if( !(self.burnBits & WEAPON3) ){
          self.burnBits = self.burnBits | WEAPON3;
        }
      }
    }
    else if( hp <= 0.5 ){
      self.SendFlags = self.SendFlags | (SENDFLAG_BURN | SENDFLAG_CRIT);
      self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE_HOT");
      if( self.data_type == DATA_BLD ){
        if( !(self.burnBits & WEAPON2) ){
          self.burnBits = self.burnBits | WEAPON2;
        }
      }
    }
    else if( hp <= 0.75 ){
      self.SendFlags = self.SendFlags | (SENDFLAG_BURN | SENDFLAG_CRIT);
      self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE");
      if( self.data_type == DATA_BLD ){
        if( !(self.burnBits & WEAPON1) ){
          self.burnBits = self.burnBits | WEAPON1;
        }
      }
    }
  }
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_TURRET);
};

float( entity dest, float changedflags ) ctrl_send_tank={
  local vector vex;
  WriteByte( MSG_ENTITY, SENDTYPE_TANK );
  WriteByte( MSG_ENTITY, changedflags );
  
  WriteCoord( MSG_ENTITY, self.origin_x );
  WriteCoord( MSG_ENTITY, self.origin_y );
  WriteCoord( MSG_ENTITY, self.origin_z );
  
  WriteAngle( MSG_ENTITY, self.angles_x );
  WriteAngle( MSG_ENTITY, self.angles_y );
  WriteAngle( MSG_ENTITY, self.angles_z );
  
  if( changedflags & SENDFLAG_NEWENT ){
    WriteLong( MSG_ENTITY, num_for_edict(self));
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
    
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteString( MSG_ENTITY, self.netname );
  }
  
  WriteShort( MSG_ENTITY, self.shield );
    
  if( changedflags & SENDFLAG_TURRET ){
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_x );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_y );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_z );
  }
  if( changedflags & SENDFLAG_DEAD ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  if( changedflags & SENDFLAG_CRIT ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  }
  return TRUE;
};

float( entity dest, float changedflags ) ctrl_send_spg={
  WriteByte( MSG_ENTITY, SENDTYPE_SPG );
  WriteByte( MSG_ENTITY, changedflags );
  
  WriteCoord( MSG_ENTITY, self.origin_x );
  WriteCoord( MSG_ENTITY, self.origin_y );
  WriteCoord( MSG_ENTITY, self.origin_z );
  
  WriteAngle( MSG_ENTITY, self.angles_x );
  WriteAngle( MSG_ENTITY, self.angles_y );
  WriteAngle( MSG_ENTITY, self.angles_z );
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteLong( MSG_ENTITY, num_for_edict(self));
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
    
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteString( MSG_ENTITY, self.netname );
  }
  
  WriteShort( MSG_ENTITY, self.shield );

  if( changedflags & SENDFLAG_DEAD ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  if( changedflags & SENDFLAG_CRIT ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  }
  return TRUE;
};

float( entity dest, float changedflags ) ctrl_send_gev={
  WriteByte( MSG_ENTITY, SENDTYPE_GEV );
  WriteByte( MSG_ENTITY, changedflags );
  
  WriteCoord( MSG_ENTITY, self.origin_x );
  WriteCoord( MSG_ENTITY, self.origin_y );
  WriteCoord( MSG_ENTITY, self.origin_z );
  
  WriteAngle( MSG_ENTITY, self.angles_x );
  WriteAngle( MSG_ENTITY, self.angles_y );
  WriteAngle( MSG_ENTITY, self.angles_z );
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteLong( MSG_ENTITY, num_for_edict(self));
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteString( MSG_ENTITY, self.netname );
  }
  
  WriteShort( MSG_ENTITY, self.shield );
  
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_x );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_y );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_z );
  }
  if( changedflags & SENDFLAG_DEAD ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  if( changedflags & SENDFLAG_CRIT ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  }

  return TRUE;
};
