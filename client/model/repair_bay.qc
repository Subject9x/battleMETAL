/*
battleMETAL
Author: Peter Roohr
Date: 03/23/2020
Overview: 
  CSQC-side animations for repair bay
*/


void() repair_bay_dlights={
  local vector lightColor;
  local float lightStyle;
  
  makevectors(self.angles);
  
  if( self.deadflag == DEAD_NO ){
    if( self.faction == CLIENT_faction ){
      if( self.burstRate == 1 ){
        lightColor = '0.25 0.95 0.35';
        lightStyle = 11;
      }
      else if( self.burstRate == 2 ){
        lightColor = '1 0.6 0';
        lightStyle = 6;
      }
      else{
        lightColor = '0.25 0.25 0.25';
        lightStyle = 1;
      }
    }
    else{
      if( self.burstRate > 0 ){
        lightColor = '0 0 0';
        lightStyle = 1;
      }
      else{
        lightColor = '0.95 0.25 0.15';
        lightStyle = 4;
      }
    }
    adddynamiclight2( self.origin, 256, lightColor, lightStyle, "", PFLAGS_FULLDYNAMIC); 
  }
};

/*
  Repair Bay - Active
*/
void() repair_bay_active={
  
  if( self.reloadValue < 0 ){
    self.think = repair_bay_idle;
    self.nextthink = time + 0.1;
    return;
  }

  if(self.w_firetime > TRUE ){
    sendevent_repair_beam();
  }
  self.think = repair_bay_active;
  self.nextthink = time + 0.1;
};

/*
  Repair Bay - Idle
*/
void() repair_bay_idle={

  if( self.reloadValue > 0 ){
    self.think = repair_bay_active;
    self.nextthink = time + 0.1;
    return;
  }
  
  self.think = repair_bay_idle;
  self.nextthink = time + 0.1;
};

/*
  Repair Bay - Repair
*/
void() sendevent_repair_beam={
  local entity unit;
  local vector unitAngl;
  local vector partOfs;
  local vector beamEnd;
  
  unit = findfloat(world, entnum, self.targetEntId );
  if( unit != world ){
    switch(self.w_firetime){
      case M_ARM_LEFT:
        partOfs = unit.armLeft.compOffset;
        break;
        
      case M_ARM_RIGHT:
        partOfs = unit.armRight.compOffset;
        break;
        
      case M_TOR_LEFT:
        partOfs = unit.torsoLeft.compOffset;
        break;
        
      case M_TOR_RIGHT:
        partOfs = unit.torsoRight.compOffset;
        break;
        
      case M_LEGS:
        partOfs = unit.legs.compOffset;
        break;
        
      default:
        partOfs = unit.torsoCenter.compOffset;
        break;
    }
    unitAngl = unit.angles;
    unitAngl_x = 0;

    makevectors(unitAngl);
    beamEnd = unit.origin + (v_forward * partOfs_z);
    beamEnd = beamEnd + (v_right * partOfs_x);
    beamEnd = beamEnd + (v_up *partOfs_y);

    beamEnd_x = beamEnd_x + (crandom() * 2);
    beamEnd_y = beamEnd_y + (crandom() * 2);
    beamEnd_z = beamEnd_z + (crandom() * 2);
    self.compAltOffset = beamEnd;
  }
  
  pointparticles( particleeffectnum("TE_REPAIR_MUZZLE"), self.compOffset, normalize( self.compAltOffset - self.compOffset ) * 2, 1);
  pointparticles( particleeffectnum("TE_REPAIR_IMPACT"), self.compAltOffset, normalize( self.compOffset - self.compAltOffset ) * -2, 1);
  trailparticles( world, particleeffectnum("TE_REPAIR_RAIL"), self.compOffset, self.compAltOffset);
};

/*
  Repair Bay - DEATH
*/
void() repair_bay_die1={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 0) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 0) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die2;
  self.nextthink = time + 0.1;
};
void() repair_bay_die2={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 4) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 4) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die3;
  self.nextthink = time + 0.1;
};
void() repair_bay_die3={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 8) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 8) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die4;
  self.nextthink = time + 0.1;
};
void() repair_bay_die4={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 12) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 12) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die5;
  self.nextthink = time + 0.1;
};
void() repair_bay_die5={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 16) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 16) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die6;
  self.nextthink = time + 0.1;
};
void() repair_bay_die6={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 20) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 20) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die7;
  self.nextthink = time + 0.1;
};
void() repair_bay_die7={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 24) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 24) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die8;
  self.nextthink = time + 0.1;
};
void() repair_bay_die8={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 28) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 28) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die9;
  self.nextthink = time + 0.1;
};
void() repair_bay_die9={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 32) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 32) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die10;
  self.nextthink = time + 0.1;
};
void() repair_bay_die10={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 36) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 36) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die11;
  self.nextthink = time + 0.1;
};
void() repair_bay_die11={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 40) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 40) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die12;
  self.nextthink = time + 0.1;
};
void() repair_bay_die12={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 44) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 44) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die13;
  self.nextthink = time + 0.1;
};
void() repair_bay_die13={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 48) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 48) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die14;
  self.nextthink = time + 0.1;
};
void() repair_bay_die14={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 52) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 52) + (v_right * random() *-32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die15;
  self.nextthink = time + 0.1;
};
void() repair_bay_die15={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 56) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 56) + (v_right * random() *-32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
  self.think = repair_bay_die16;
  self.nextthink = time + 0.1;
};
void() repair_bay_die16={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 60) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 60) + (v_right * random() *-32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );

  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};
