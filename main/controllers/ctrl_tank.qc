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
    if( hp <= 0.75){
      makevectors( self.angles );
      spark = self.origin + (v_up * (self.maxs_z * 0.75));
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - self.origin) * 5, 1);
    }
    else if( hp <= 0.5){
      makevectors( self.angles );
      spark = self.origin + (v_up * (self.maxs_z * 0.75));
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - self.origin) * 5, 1);
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - self.origin) * 5, 1);
    }
    else if( hp <= 0.25){
      makevectors( self.angles );
      spark = self.origin + (v_up * (self.maxs_z * 0.75));
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - self.origin) * 5, 1);
      pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - self.origin) * 5, 1);
    }
  }

};
