/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Death
    
  Setup
    
*/
void() ai_mech_sniper_die3;
void() ai_mech_sniper_die4;
void() ai_mech_sniper_die5;
void() ai_mech_sniper_die6;
/*
  TH_DIE
*/ 
void() ai_mech_sniper_die={
  
  if( self.deadflag > DEAD_NO ){
    return; //double play prevention
  }

  //fire triggers when dead
  ai_sfx_dead();
  trigger_event( self.enemy, self.trigOnDeath );
  ai_alert_close( self.enemy );
  ai_nodegraph_clear_locks();
  
  if( self.moveState != MOVE_STAND ){
    if( !(self.unitModFlags & MOD_MODEL_NO_TOR_L) && !(self.criticalHits & M_TOR_LEFT) ){
      self.critBits = self.critBits | M_TOR_LEFT;
      te_vehicle_chunk( self.torL_mdl, self.torL_org, '0 0 0', self.torL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
    }
    if( !(self.unitModFlags & MOD_MODEL_NO_TOR_R) && !(self.criticalHits & M_TOR_RIGHT) ){
      self.critBits = self.critBits | M_TOR_RIGHT;
      te_vehicle_chunk( self.torR_mdl, self.torR_org, '0 0 0', self.torR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
    }
    if( (self.unitModFlags & MOD_HAS_ARM_L) && !(self.criticalHits & M_ARM_LEFT) ){
      self.critBits = self.critBits | M_ARM_LEFT;
      te_vehicle_chunk( self.armL_mdl, self.armL_org, '0 0 0', self.armL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
    }
    if( (self.unitModFlags & MOD_HAS_ARM_R) && !(self.criticalHits & M_ARM_RIGHT) ){
      self.critBits = self.critBits | M_ARM_RIGHT;
      te_vehicle_chunk( self.armR_mdl, self.armR_org, '0 0 0', self.armR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
    }
  }
  
  self.th_pain = ai_NULL_pain;
  self.deadflag = DEAD_DEAD;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.attack_state = -1;
  self.enemy = world;
  setorigin(self, self.origin);
  droptofloor();
  
  self.SendFlags = self.SendFlags | (SENDFLAG_DEAD | SENDFLAG_MOVE | SENDFLAG_ANGLE | SENDFLAG_TURRET);
  self.think = ai_mech_sniper_die2;
  self.nextthink = time + 0.1;
};

//explode
void() ai_mech_sniper_die2={
  ctrl_weapon_remove_all();
  
  self.think = ai_mech_sniper_die3;
  self.nextthink = time + 0.1;
};

void() ai_mech_sniper_die3={
  if( !(self.unitModFlags & MOD_MODEL_NO_TOR_L) && !(self.criticalHits & M_TOR_LEFT) ){
    self.critBits = self.critBits | M_TOR_LEFT;
    te_vehicle_chunk( self.torL_mdl, self.torL_org, '0 0 0', self.torL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
  }
  self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
  self.think = ai_mech_sniper_die4;
  self.nextthink = time + 0.1;
};
void() ai_mech_sniper_die4={
  if( !(self.unitModFlags & MOD_MODEL_NO_TOR_R) && !(self.criticalHits & M_TOR_RIGHT) ){
    self.critBits = self.critBits | M_TOR_RIGHT;
    te_vehicle_chunk( self.torR_mdl, self.torR_org, '0 0 0', self.torR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
  }
  self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
  self.think = ai_mech_sniper_die5;
  self.nextthink = time + 0.1;
};
void() ai_mech_sniper_die5={
  if( (self.unitModFlags & MOD_HAS_ARM_L) && !(self.criticalHits & M_ARM_LEFT) ){
    self.critBits = self.critBits | M_ARM_LEFT;
    te_vehicle_chunk( self.armL_mdl, self.armL_org, '0 0 0', self.armL_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
  }
  self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
  self.think = ai_mech_sniper_die6;
  self.nextthink = time + 0.1;
};

void() ai_mech_sniper_die6={
  if( (self.unitModFlags & MOD_HAS_ARM_R) && !(self.criticalHits & M_ARM_RIGHT) ){
    self.critBits = self.critBits | M_ARM_RIGHT;
    te_vehicle_chunk( self.armR_mdl, self.armR_org, '0 0 0', self.armR_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
  }
  self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
  self.think = SUB_Remove;
  self.nextthink = time + 1.0;
  
  ai_wreck_mech();
  
};