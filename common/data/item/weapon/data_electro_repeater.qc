/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Electro-Static Repeater
      Range - Short
      Consumes Energy
      hit scan
      Inaccurate
      spin up and cooldown
*/
#ifndef CSQC
// last fire time == self.count1
// cooldown check == self.count2;
// last fire rate = self.count3
// next cool check == self.count4
// reload counter = self.count
// overheat counter = self.count5
float DATA_ESR_BEAM_COUNT = 3;
float DATA_ESR_COOLDOWN_MAX = 2;

float ESR_HEAT_UP = 0.05;    //count5
float ESR_MAX_RATE = 0.09;  //count3
float ESR_RATE_UP = 0.0065;   //count3
float ESR_RATE_DN = 0.01;   //count3
float ESR_SPREAD_UP = 1.15;
float ESR_SPREAD_DN = 0.95;

void() weapon_esr_think={
  local float lim;
  local float prevState;
  
  prevState = self.wepReloadState;

  //Reloading - overheated, full cooldown
  if( self.wepReloadState == RELOADING ){
    if( time > self.w_firetime ){
      if( self.w_currentammo < self.reloadMax ){
        self.w_currentammo = self.w_currentammo + ESR_HEAT_UP;
        self.w_firetime = time + 0.33;
      }
      else{
        self.reloadValue = 100;
        self.wepReloadState = READY;
      }
    }
  }
  else{
    //Recoil - Just fired
    if( prevState == RECOIL ){
      if( time > self.w_firetime ){
        self.wepReloadState = READY;
        self.reloadValue = 100;
      }
    }
    //Waiting - has not been fired recently, cooling down
    if( prevState == WAITING || time > self.count2 ){
      if( self.wepReloadState == WAITING ){
        //proper cool down
        if( time > self.count4 ){
          //spin down the fire rate
          self.count3 = self.count3 + ESR_RATE_DN;
          if( self.count3 > self.reloadRate ){
            self.count3 = self.reloadRate;
          }
          //unfocus the spread lens
          self.spreadDefault = self.spreadDefault * ESR_SPREAD_UP;
          if( self.spreadDefault_x > self.spreadCache_x * 4 ){
            self.spreadDefault = self.spreadCache * 4;
          }
          //take off some heat
          if( self.w_currentammo < self.reloadMax ){
            self.w_currentammo = self.w_currentammo + ESR_HEAT_UP / 3;
          }
        }
      }
      else{
        self.wepReloadState = WAITING;
        self.count4 = time + 0.1;
      }
    }
  }

  lim = self.reloadMax;
  self.reloadValue = (self.w_currentammo / lim) * 100;
  self.think = weapon_esr_think;
};

void() data_ini_attack_electro_repeater_;
#endif 

#ifdef CSQC
void() te_muzzle_esr={
  local vector startOrg;
  local vector endOrg;
  local vector norm;
  local float impactStyle;
  
  startOrg = self.origin + v_forward * self.wepFireOffset_z + v_up * 0.1;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  norm = normalize(endOrg - startOrg);
  
  pointsound( startOrg, "sound/weapons/esr_fire.ogg", 0.5 + (random() * 0.5), ATTN_NORM);
  pointparticles( particleeffectnum("TE_ESR_MUZZLE"), startOrg,  norm* 1, 1);
  
  impactStyle = te_impact_type(endOrg, trace_ent);
    
  trailparticles( world, particleeffectnum("TE_ESR_RAIL"), startOrg, endOrg );
  switch(impactStyle){
    case IMPACT_SHIELD:
      pointparticles( particleeffectnum("TE_ESR_IMPACT_SHIELD"), endOrg, norm * -2, 1);
      pointsound( endOrg, "sound/fx_shieldhit.ogg", 0.67 + (random() * 0.33), ATTN_NORM );
      break;
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_ESR_IMPACT_ARMOR"), endOrg, norm * -6, 1);
      break;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_ESR_IMPACT_DIRT"), endOrg, norm * -4, 1);
      break;
    default:
      return;
  }
};
#endif
void() data_ini_electro_repeater_={
  
  self.data_idx = 8;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.2;
  self.reloadMax = 4;
  self.energyRate = 5;
  
  self.w_range = 1000;
  self.damageValue = 10;
  self.damageType = DMG_ENE;

  self.techLevel = 2;
  self.equipSize = ENE2;

  self.spreadDefault = '0.015 0.015 0';
  self.wepFireOffset = '0 0 6'; 
  self.burstRate = 0;
  
#ifdef CSQC  
  self.w_name = "Electro-Static Repeater";
  self.fire_sound = "sound/weapons/esr_fire.ogg";
  self.model = "q3mdl/weapons/w_esr.md3";
  self.abbrev = "ESR";
  self.description = "+ Instant-impact weapon. + Rate of Fire spin up/cool down. + Damage split when target is <shielded>";
  self.icon = "gfx/ui/wep_icons/wi_esr.png";
  self.itemMuzzleFlash = te_muzzle_esr;
#endif

#ifndef CSQC
  self.w_isburst = FALSE;
  if( (self.owner.flags & FL_MONSTER) ){
    self.reloadMax = 1;
    self.energyRate = self.energyRate / 2;
    self.think = default_weapon_think;
  }
  else{
    self.think = weapon_esr_think;
  }
  
  self.w_attack = data_ini_attack_electro_repeater_;
  self.spreadCache = self.spreadDefault;
  self.damageCache = self.damageValue;
  self.count3 = self.reloadRate;
#endif
};

#ifndef CSQC
void() data_ini_attack_electro_repeater_={
  local float damage;
  
  if( self.owner.energy <= self.energyRate ){
    self.wepReloadState = RELOADING;
    self.w_currentammo = self.reloadMax / 1.125;
    return;
  }
  
  self.wepReloadState = RECOIL;
  self.count1 = time;
  self.count2 = time + self.reloadRate * 2;
  
  self.count3 = self.count3 - ESR_RATE_UP;
  if( self.count3 < ESR_MAX_RATE ){
    self.count3 = ESR_MAX_RATE;
  }
  
  self.w_firetime = time + self.count3;

  self.spreadDefault = self.spreadDefault * ESR_SPREAD_DN;
  if( self.spreadDefault_x < self.spreadCache_x ){
    self.spreadDefault = self.spreadCache;
  }
  
  self.owner.energy = self.owner.energy - self.energyRate;
  
  self.w_currentammo = self.w_currentammo - ESR_HEAT_UP;
  if( self.w_currentammo < 0 ){
    self.wepReloadState = RELOADING;
    self.count2 = time;
    self.count3 = self.reloadRate;
    self.spreadDefault = self.spreadCache * 4;
  }
  ctrl_weapon_fireOffset();
  
  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  if( trace_ent.takedamage ){
    damage = self.damageValue; 
    if( trace_ent.shield > 0 ){
      damage = damage * 0.67;
      t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, FALSE);
    }
    else{
      t_damage(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, '0 0 0');
    }
  }
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif