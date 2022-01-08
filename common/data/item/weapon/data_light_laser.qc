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
#ifdef SSQC
void() data_ini_attack_laser_;
#endif
 
#ifdef CSQC
void() te_muzzle_las={
  local vector startOrg;
  local vector endOrg;
  local float impactStyle;
  local vector norm;
  
  startOrg = self.wepFireOffset;
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  norm = normalize(endOrg - startOrg);
  
  if( vlen(endOrg - startOrg) >= 1500 ){
    sound7(self, CHAN_AUTO, "sound/weapons/laser_fire.ogg", 1, ATTN_NORM, (0.33 + (random() * 0.67)) * 115, 0 );
  }
  else{
    sound7(self, CHAN_AUTO, "sound/weapons/laser_fire.ogg", 1, ATTN_NORM, (0.45 + (random() * 0.55)) * 175, 0 );
  }
  pointparticles( particleeffectnum("TE_LAS_MUZZLE"), startOrg, norm * -2, 1);
  
  impactStyle = te_impact_type(endOrg, trace_ent, trace_dphitcontents);
  
  trailparticles( world, particleeffectnum("TE_LAS_RAIL"), startOrg, endOrg );
  
  if(impactStyle == IMPACT_ARMOR){
      pointparticles(particleeffectnum("TE_LAS_HIT"), endOrg + (v_forward * -2), norm, 1);
  }
  else if(impactStyle == IMPACT_DIRT){
    pointparticles(particleeffectnum("TE_LAS_DIRT"), endOrg + (v_forward * -2), norm, 1);
    pointparticles(PTC_HIT_DIRT_ENE_SML, endOrg, trace_plane_normal * -1, 1);
  }
};
#endif
void() data_ini_light_laser_={
  
  self.data_idx = UID_ITEM_light_laser;
  
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
  self.description = "+ Instant-impact weapon. + bonus damage against <shields>.";
  self.icon = "gfx/ui/wep_icons/wi_las.png";
  self.itemMuzzleFlash = te_muzzle_las;
#endif

#ifdef SSQC
  self.w_isburst = FALSE;
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_laser_;
#endif
};

#ifdef SSQC
void() data_ini_attack_laser_={
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  if( (trace_dphitcontents & DPCONTENTS_SKY) || (trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) ){
    return;
  }
  
  if( trace_ent.takedamage ){
    if( trace_ent.shield > 0 ){
      t_damage_shield(trace_ent, self,self.owner, self.damageValue * 1.85, trace_endpos, FALSE); 
    }
    else{
      HIT_LOCATION = t_damage(trace_ent, self, FIRE_ENT, self.damageValue, FIRE_ENDPOINT, '0 0 0');
      if( HIT_LOCATION.partTypeId && !(self.owner.statTargetHitParts & HIT_LOCATION.partTypeId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION.partTypeId;
      }
    }
  }
};
#endif