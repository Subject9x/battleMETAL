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
#define LIGHT_LAS_SHIELD_BONUS 2.0
void() data_ini_attack_laser_;
#endif
 
#ifdef CSQC
void() te_beam_las={
  Draw_CylindricLine(self.wepFireOffset, self.beamEnd, self.beamWidth, "particles/laserbeam", 0.5, time * (random() * -6), '1.0 0.33 0.67', 0.75, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
};
void() te_muzzle_las={
  local vector startOrg;
  local vector endOrg;
  local float impactStyle;
  local vector norm;
  
  startOrg = self.wepFireOffset;
  endOrg = self.beamEnd;

  norm = normalize(endOrg - startOrg);
  
  if( vlen(endOrg - startOrg) >= 1500 ){
    sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.33 + (random() * 0.67)) * 115, 0 );
  }
  else{
    sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.45 + (random() * 0.55)) * 175, 0 );
  }

  self.beamTime = time + 0.2;
  self.beamOrg = startOrg;
  self.beamWidth = 2.0;
  self.beamActive = TRUE;

  //trailparticles( world, particleeffectnum("TE_LAS_RAIL"), startOrg, endOrg );
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_LAS_MUZZLE"), startOrg, norm * -2, 1);
    if(self.pcl_count == IMPACT_ARMOR){
        pointparticles(particleeffectnum("TE_LAS_HIT"), endOrg + (norm * -2), norm, 1);
    }
    else if(self.pcl_count == IMPACT_DIRT){
      pointparticles(particleeffectnum("TE_LAS_DIRT"), endOrg + (norm * -2), norm, 1);
      pointparticles(PTC_HIT_DIRT_ENE_SML, endOrg, trace_plane_normal * -1, 1);
    }
  }
};
#endif
void() data_ini_light_laser_={
  
  self.data_idx = UID_ITEM_light_laser;
  
  self.w_clipsize = 1;
  self.reloadRate = 1.5;
  self.reloadMax = 1.5;
  self.energyRate = 20;   //v3.7.4 - 18

  self.w_range = 3000;
  self.damageValue = 30;  //v3.7.4 - 25
  self.damageType = (DMG_ENE | EFF_SHD);

  self.techLevel = 1;
  self.equipSize = ENE1;

  self.spreadDefault = '0.0075 0.0075 0';
  self.wepFireOffset = '0 0 3.5';
  self.burstRate = 0;
  self.beamFlag = TRUE;
  
#ifdef CSQC
  precache_sound("sound/weapons/laser_fire.ogg");
  precache_model("models/weapons/w_laser.md3");
  precache_file( "gfx/ui/wep_icons/wi_las.png");
  self.w_name = "Laser";
  self.fire_sound = "sound/weapons/laser_fire.ogg";
  self.model = "models/weapons/w_laser.md3";
  self.abbrev = "LAS";
  self.description = "+ Instant-impact weapon. + bonus damage against <shields>.";
  self.icon = "gfx/ui/wep_icons/wi_las.png";
  self.itemMuzzleFlash = te_muzzle_las;
  self.effect_beam = te_beam_las;
#endif

#ifdef SSQC
  self.w_isburst = FALSE;
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_laser_;
#endif
};

#ifdef SSQC
void() data_ini_attack_laser_={
  local float impactStyle;

  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  impactStyle = IMPACT_SKY;
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;

  if( !(trace_dphitcontents & DPCONTENTS_SKY) && !(trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) ){
    impactStyle = IMPACT_DIRT;

    if( trace_ent.takedamage ){
      impactStyle = IMPACT_ARMOR;

      if( trace_ent.shield > 0 ){
        t_damage_shield(trace_ent, self,self.owner, self.damageValue * LIGHT_LAS_SHIELD_BONUS, trace_endpos, FALSE); 
        impactStyle = IMPACT_SHIELD;
      }
      else{
        HIT_LOCATION = t_damage(trace_ent, self, FIRE_ENT, self.damageValue, FIRE_ENDPOINT, '0 0 0');
        if( HIT_LOCATION && !(self.owner.statTargetHitParts & HIT_LOCATION) ){
          self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION;
        }
      }
    }
  }
  client_send_particle_rail( BEAM_LAS, num_for_edict(self), FIRE_ORIGIN, FIRE_ENDPOINT, 4,  impactStyle);
};
#endif