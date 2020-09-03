/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Item - Weapon
    Light Laser
      Range - Long
      Consumes Energy
      Mild Dmg buff against shields

*/
#ifndef CSQC
void() data_ini_attack_laser_;
#endif
 
#ifdef CSQC
void() te_muzzle_las={
  local vector startOrg;
  local vector endOrg;
  local float impactStyle;
  local vector norm;
  
  startOrg = self.origin + v_forward * self.wepFireOffset_z;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  pointsound( startOrg, "sound/weapons/laser_fire.ogg", 1, ATTN_NORM);
  if( vlen(endOrg - startOrg) >= 1500 ){
    pointsound( endOrg, "sound/weapons/laser_fire.ogg", 0.5, ATTN_NORM);
  }
  pointparticles( particleeffectnum("TE_LAS_MUZZLE"), startOrg, normalize(startOrg - endOrg) * 2, 1);
  
  impactStyle = te_impact_type(endOrg, trace_ent);
  
  trailparticles( world, particleeffectnum("TE_LAS_RAIL"), startOrg, endOrg );
  
  norm = normalize(endOrg - startOrg);
  
  impactStyle = te_impact_type(endOrg, trace_ent);
  
  switch(impactStyle){
    case IMPACT_ARMOR:
      pointparticles(particleeffectnum("TE_LAS_HIT"), endOrg, norm, 1);
      break;
    case IMPACT_DIRT:
      pointparticles(particleeffectnum("TE_LAS_DIRT"), endOrg , '0 0 0', 1);
      break;
    default:
      return;
  }
};
#endif
void() data_ini_light_laser_={
  
  self.data_idx = 3;
  
  self.w_clipsize = 1;
  self.reloadRate = 1.5;
  self.reloadMax = 1.5;
  self.energyRate = 18;

  self.w_range = 3000;
  self.damageValue = 25;
  self.damageType = (DMG_ENE | EFF_SHD);

  self.techLevel = 1;
  self.equipSize = ENE1;

  self.spreadDefault = '0.0075 0.0075 0';
  self.wepFireOffset = '0 0 3.5';
  self.burstRate = 0;
  
#ifdef CSQC
  self.w_name = "Laser";
  self.fire_sound = "sound/weapons/laser_fire.ogg";
  self.model = "q3mdl/weapons/w_laser.md3";
  self.abbrev = "LAS";
  self.description = "+ Instant-impact weapon. + bonus damage  against <shields>.";
  self.icon = "gfx/ui/wep_icons/wi_las.png";
  self.itemMuzzleFlash = te_muzzle_las;
#endif

#ifndef CSQC
  self.w_isburst = FALSE;
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_laser_;
#endif
};

#ifndef CSQC
void() data_ini_attack_laser_={
  local float damage;
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  if( pointcontents(FIRE_ENDPOINT) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    if( trace_ent.shield > 0 ){
      t_damage_shield(trace_ent, self,self.owner, self.damageValue * 1.85, trace_endpos, FALSE); 
    }
    else{
      t_damage(trace_ent, self, FIRE_ENT, self.damageValue, FIRE_ENDPOINT, '0 0 0');  
    }
  }
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif