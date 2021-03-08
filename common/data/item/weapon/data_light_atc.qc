/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Item - Weapon
    Light Autocannon
      Range: Long
      Rapid fire
      low accuracy
*/
#ifdef SSQC
void() data_ini_attack_latc_;
#endif

#ifdef CSQC
void() te_muzzle_latc={
  local vector startOrg;
  local vector endOrg;
  local vector ang;
  local vector norm;
  local float impactStyle;
  local float beamLen;
  
  startOrg = self.origin + (v_forward * self.wepFireOffset_z);
  traceline(startOrg, self.owner.laser_sight_org, FALSE, self.owner);
  endOrg = trace_endpos;
  
  norm = normalize(endOrg - startOrg);
  ang = vectoangles(endOrg - startOrg);
  pointsound( startOrg, "sound/weapons/atc_fire.ogg", 1, ATTN_NORM);
  
  beamLen = vlen(endOrg - startOrg);
  if( beamLen >= 1500 ){
    pointsound( endOrg, "sound/weapons/atc_fire.ogg", 0.5, ATTN_NORM);
  }
  
  pointparticles( particleeffectnum("TE_ATC_MUZZLE"), startOrg, norm * 4, 1);
  
  makevectors(ang);
  
  impactStyle = te_impact_type(endOrg, trace_ent);
  
  
  if( beamLen > 100 ){
    pointparticles( particleeffectnum("TE_ATC_TRACER"), startOrg, norm * 1600, 1);
  }
  
  
  switch(impactStyle){
    case IMPACT_ARMOR:
      pointparticles( particleeffectnum("TE_ATC_ARMOR"), endOrg + v_forward * -3, norm * 4, 3);
      break;
    case IMPACT_DIRT:
      pointparticles( particleeffectnum("TE_ATC_DIRT"), endOrg + (v_up *1), normalize( (endOrg + (v_up *1)) - startOrg ) * 20, 1);
      break;
    default:
      return;
  }
};
#endif
void() data_ini_light_atc_={

  self.data_idx = UID_ITEM_light_autocannon;
  
  self.w_clipsize = 3;
  self.reloadRate = 0.12;
  self.reloadMax = 1.5;
  self.energyRate = 0;
  
  self.w_range = 3200;
  self.damageValue = 10.5;
  self.damageType = DMG_BAL;

  self.techLevel = 1;
  self.equipSize = BAL1;
  
  self.spreadDefault = '0.025 0.025 0';
  self.wepFireOffset = '0 0.5 5';
  self.burstRate = 1;
  
#ifdef CSQC  
  self.w_name = "Light Autocannon";
  self.abbrev = "ATC";
  self.description = "+ Instant-impact weapon. + 3-round burst. + Better against <Armor>.";
  self.icon = "gfx/ui/wep_icons/wi_atc.png";
  self.model = "q3mdl/weapons/w_atc.md3";
  self.fire_sound = "sound/weapons/atc_fire.ogg";
  self.itemMuzzleFlash = te_muzzle_latc;
#endif

#ifdef SSQC  
  self.w_attack = data_ini_attack_latc_;
  self.think = default_weapon_think;
  self.w_isburst = FALSE;
#endif
};

#ifdef SSQC
void() data_ini_attack_latc_={
  
  ctrl_weapon_fireOffset();
  
  ctrl_weapon_updateAmmo( TRUE );
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }
  else{
    if( trace_ent.takedamage ){
      if( trace_ent.shield > 0 ){
        t_damage_shield(trace_ent, self,self.owner, self.damageValue * 0.5, trace_endpos, FALSE); 
      }
      else{
        t_damage(trace_ent, self, FIRE_ENT, self.damageValue, FIRE_ENDPOINT, '0 0 0');
      } 
    }
  }
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif