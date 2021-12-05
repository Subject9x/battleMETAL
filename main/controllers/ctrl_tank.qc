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
  local float hp;
  local float myShield;
  
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
  
  if( time > self.energyRegenTimer ){
    self.energyRegenTimer = time + 0.1;
    if( (self.unitModFlags & MOD_HEAT_NOT_ENERGY) ){
      self.energy = self.energy - self.energyRate;
    }
    else{
      self.energy = self.energy + self.energyRate;
    }
    self.energy = bound(0, self.energy, self.energyMax);
  }
  
  if( (self.unitModFlags & MOD_HAS_SHIELD) ){
    if( time <= self.shieldHitRegen ) {
      myShield = self.shieldHitRegen - self.shieldHitRegenStart;
      myShield = (time - self.shieldHitRegenStart) / myShield;
      self.stat_client_shield =  (100 - (myShield * 100) ) + 100;
    }
    else{
      if(self.shield < self.shieldMax){
        if( (time > self.shieldHitDelay) && (time > self.shieldHitRegen) ){
          if(self.energy > 0){
            self.shield = self.shield + (self.shieldRate * 0.5);
            self.energy = self.energy - (self.shieldRate * 2);
            if(self.shield > self.shieldMax){
              self.shield = self.shieldMax;
            }
          }
        }
      }
      self.stat_client_shield = (self.shield / self.shieldMax) * 100;
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
      
      self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE_HOT");
      if( self.data_type == DATA_BLD ){
        if( !(self.burnBits & WEAPON3) ){
          self.burnBits = self.burnBits | WEAPON3;
        }
      }
    }
    else if( hp <= 0.5 ){
      
      self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE_HOT");
      if( self.data_type == DATA_BLD ){
        if( !(self.burnBits & WEAPON2) ){
          self.burnBits = self.burnBits | WEAPON2;
        }
      }
    }
    else if( hp <= 0.75 ){
     
      self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE");
      if( self.data_type == DATA_BLD ){
        if( !(self.burnBits & WEAPON1) ){
          self.burnBits = self.burnBits | WEAPON1;
        }
      }
    }
  }
};

float( float isNew, float changedflags ) ctrl_send_tank={
  WriteByte( MSG_ENTITY, SENDTYPE_TANK );
  WriteCoord( MSG_ENTITY, changedflags );
  
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  
  if( (changedflags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
  }
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteCoord( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteString( MSG_ENTITY, self.netname );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
  }
  
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_y );
  }
  
  if( (changedflags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  } 
  
  //if( (changedflags & SENDFLAG_BURN) ){
  //  <no-writes>
  //}
  
  if( (changedflags & SENDFLAG_TARGET) ){
    WriteCoord( MSG_ENTITY, num_for_edict(self.enemy));
  }
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteCoord( MSG_ENTITY, self.attackFlag );
  }
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  self.shieldHitFlag = 0;
  return TRUE;
};

float( float isNew, float changedflags ) ctrl_send_spg={
  WriteByte( MSG_ENTITY, SENDTYPE_SPG );
  WriteCoord( MSG_ENTITY, changedflags );
  
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  
  if( (changedflags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
  }
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteCoord( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteString( MSG_ENTITY, self.netname );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
  }
  
  if( (changedflags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  }
  
  //if( (changedflags & SENDFLAG_BURN) ){
  //  <no-writes>
  //}
  
  if( (changedflags & SENDFLAG_TARGET) ){
    WriteCoord( MSG_ENTITY, num_for_edict(self.enemy));
  }
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteCoord( MSG_ENTITY, self.attackFlag );
  }
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  self.shieldHitFlag = 0;
  return TRUE;
};

float( float isNew, float changedflags ) ctrl_send_gev={
  WriteByte( MSG_ENTITY, SENDTYPE_GEV );
  WriteCoord( MSG_ENTITY, changedflags );
  
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  
  if( (changedflags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
  }
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteCoord( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteString( MSG_ENTITY, self.netname );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
  }
  
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_y );
  }
  if( (changedflags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  }
    
  //if( (changedflags & SENDFLAG_BURN) ){
  //  <no-writes>
  //}
  
  if( (changedflags & SENDFLAG_TARGET) ){
    WriteCoord( MSG_ENTITY, num_for_edict(self.enemy));
  }
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteCoord( MSG_ENTITY, self.attackFlag );
  }
  
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  
  self.shieldHitFlag = 0;
  return TRUE;
};
