/*
battleMETAL
Author: Peter Roohr
Date: 1/15/2019
Overview: 
  per-frame game logic update functions
  
*/

void() ctrl_updateTank={
  local entity wep;
  local vector v1;
  local float hp;
  local float myShield;
  local vector offsetAngl;
  
  if( !(self.flags & FL_TURRET) ){
    //Unit lacks a turret.
    self.v_angle = self.angles;
  }
  
  makevectors(self.angles);
  traceline(self.origin, self.origin - (v_up * 512), TRUE, self);
  self.tankChassisOrg = trace_endpos + (v_up * self.mins_z * -1 );
  
  self.legs_org = self.tankChassisOrg + (v_right * self.legs_compOffset_x) + (v_up * self.legs_compOffset_y) + (v_forward * self.legs_compOffset_z);
  self.torC_org = self.tankChassisOrg + (v_right * self.torC_compOffset_x) + (v_up * self.torC_compOffset_y) + (v_forward * self.torC_compOffset_z);
  
  makevectors(self.v_angle);
  v1 = self.tankChassisOrg + (v_right * self.cameraOffset_x) + (v_up * self.cameraOffset_y) + (v_forward * self.cameraOffset_z);
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
    if( time < self.shieldHitRegen ) {
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
    }
    self.stat_client_shield = (self.shield / self.shieldMax) * 100;
  }
  self.ai_attackPreviousEnergy = self.ai_weaponEnergy;
  self.ai_weaponEnergy = 0;
  self.currentWeaponGroup = 0;
  
  wep = self.w_slot;
  while(wep){
    if( wep.owner != self ){
      continue;
    }
    if( (self.flags & FL_MONSTER) ){
      ctrl_weapon_think_ai(wep);
    }
    util_getPartFromName(wep.partParentId, self);

    offsetAngl = T_PART_PARENT_ANGL; 
    makevectors(offsetAngl);
    wep.origin = self.origin + (v_up * wep.compOffset_y) + (v_forward * wep.compOffset_z) + (v_right * wep.compOffset_x);
    wep.angles = T_PART_PARENT_ANGL;
    setorigin(wep, wep.origin);
    wep = wep.w_slot;
  }

  
  //damage-based cosmetics for unit component pieces
  if( self.deadflag <= DEAD_NO ){
    hp = self.health / self.max_health;
    if( hp <= 0.25 ){
      if( !(self.burnBits & WEAPON3) ){
        self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE_HOT");
        self.burnBits = self.burnBits | WEAPON2;
        self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
      }
    }
    else if( hp <= 0.5 ){
      if( !(self.burnBits & WEAPON2) ){
        self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE_HOT");
        self.burnBits = self.burnBits | WEAPON2;
        self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
      }
    }
    else if( hp <= 0.75 ){
      if( !(self.burnBits & WEAPON1) ){
        self.pcl_effectnum = particleeffectnum("TE_MECHPIECE_DAMAGE");
        self.burnBits = self.burnBits | WEAPON1;
        self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
      }
    }

    if( getsoundtime(self, CHAN_BODY) == -1 ){
      if( (self.SendFlags & SENDFLAG_MOVE)){
        sound(self, CHAN_BODY, "sound/fx_tank_move.ogg", 1.0, ATTN_NORM);
      }
      else{
        sound(self, CHAN_BODY, "sound/fx_tank_idle.ogg", 1.0, ATTN_NORM);
      }
    }

  }
  
  if(self.shield > 0){
    te_shields_active(self);
  }
};

float( entity to, float changedflags ) ctrl_send_tank={
  WriteByte( MSG_ENTITY, SENDTYPE_TANK );
  WriteLong( MSG_ENTITY, changedflags );
  
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
  
  if( (changedflags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteLong( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteChar( MSG_ENTITY, self.subType );
    WriteString( MSG_ENTITY, self.netname );
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
    WriteByte( MSG_ENTITY, (self.health / self.max_health) * 100);
  }
  
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torC_angl_y );
  }
  
  if( (changedflags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  } 
  
  //if( (changedflags & SENDFLAG_BURN) ){
  //  <no-writes>
  //}
  
  if( (changedflags & SENDFLAG_TARGET) ){
    WriteLong( MSG_ENTITY, num_for_edict(self.enemy));
  }
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteLong( MSG_ENTITY, self.attackFlag );
  }
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_UPDATE_FULL) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  if( (changedflags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.faction );
  }


  self.shieldHitFlag = 0;
  return TRUE;
};

float( entity to, float changedflags ) ctrl_send_spg={
  WriteByte( MSG_ENTITY, SENDTYPE_SPG );
  WriteLong( MSG_ENTITY, changedflags );
  
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
  
  if( (changedflags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteLong( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteChar( MSG_ENTITY, self.subType );
    WriteString( MSG_ENTITY, self.netname );
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
    WriteByte( MSG_ENTITY, (self.health / self.max_health) * 100);
  }
  
  if( (changedflags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  }
  
  //if( (changedflags & SENDFLAG_BURN) ){
  //  <no-writes>
  //}
  
  if( (changedflags & SENDFLAG_TARGET) ){
    WriteLong( MSG_ENTITY, num_for_edict(self.enemy));
  }
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteLong( MSG_ENTITY, self.attackFlag );
  }
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_UPDATE_FULL) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  if( (changedflags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  self.shieldHitFlag = 0;
  return TRUE;
};

float( entity to, float changedflags ) ctrl_send_gev={
  WriteByte( MSG_ENTITY, SENDTYPE_GEV );
  WriteLong( MSG_ENTITY, changedflags );
  
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
  
  if( (changedflags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteLong( MSG_ENTITY, self.flags );
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, (self.spawnflags & MUTE_ME) );
    WriteChar( MSG_ENTITY, self.subType );
    WriteString( MSG_ENTITY, self.netname );
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
    WriteByte( MSG_ENTITY, (self.health / self.max_health) * 100);
  }
  
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torC_angl_y );
  }
  if( (changedflags & SENDFLAG_CRIT) ){
    WriteByte( MSG_ENTITY, self.pcl_effectnum );
  }
    
  //if( (changedflags & SENDFLAG_BURN) ){
  //  <no-writes>
  //}
  
  if( (changedflags & SENDFLAG_TARGET) ){
    WriteLong( MSG_ENTITY, num_for_edict(self.enemy));
  }
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteLong( MSG_ENTITY, self.attackFlag );
  }
  
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_UPDATE_FULL) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  if( (changedflags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  self.shieldHitFlag = 0;
  return TRUE;
};
