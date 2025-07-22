/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Particle Cannon
      Range - Long
      Consumes Energy
      High Damage
      Single shot
      hit scan
*/
#ifdef SSQC
void() data_ini_attack_particle_cannon_;
#endif

#ifdef CSQC
void() te_pac_beam={
  
  self.beamWidth = self.beamWidth + (3 * frametime);
  self.beamAlpha = self.beamAlpha - (0.1 * frametime);
  Draw_CylindricLine(self.wepFireOffset, self.beamEnd, self.beamWidth, "particles/pac_beam", 1.0, time * -3.0, '0.98 0.68 0.23', self.beamAlpha, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);

};
void() te_muzzle_pac={
  local vector norm;

  norm = normalize(self.beamEnd - self.wepFireOffset);
  
  if( vlen(self.beamEnd - self.wepFireOffset) >= 1500 ){
    sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.33 + (random() * 0.67)) * 185, 0 );
  }
  else{
    sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.2 + (random() * 0.8)) * 100, 0 );
  }
  
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_PAC_MUZZLE"), self.wepFireOffset, norm * 2, 1);
    
    if(self.pcl_count == IMPACT_ARMOR){
      pointparticles( particleeffectnum("TE_PAC_IMPACT_ARMOR"), self.beamEnd, norm * -6, 1);
    }
    else if(self.pcl_count == IMPACT_DIRT){
      pointparticles( particleeffectnum("TE_PAC_IMPACT_GROUND"), self.beamEnd, norm * -4, 1);
      pointparticles(PTC_HIT_DIRT_ENE_LRG, self.beamEnd, trace_plane_normal * -1, 1);
    }
  }

  self.beamActive = TRUE;
  self.beamWidth = 3.0;
  self.beamTime = time + 1.0;
  self.beamAlpha = 0.8;
};
#endif
void() data_ini_particle_cannon_={
  
  self.data_idx = UID_ITEM_particle_cannon;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.1;
  self.reloadMax = 7.5;
  self.energyRate = 300;

  self.w_range = 3000;
  self.damageValue = 300; //pre-5.0.0 250
  self.damageType = DMG_ENE;
 
  self.techLevel = 3;
  self.equipSize = ENE3;
  
  self.spreadDefault = '0.0025 0.0025 0';
  self.wepFireOffset = '0 0 6.75'; 
  self.burstRate = 0;
  self.beamFlag = TRUE;
  
#ifdef CSQC
  precache_sound("sound/weapons/pac_fire.ogg");
  precache_sound("sound/weapons/pac_reload.ogg");
  precache_model("models/weapons/w_pac.md3");
  precache_file( "gfx/ui/wep_icons/wi_pac.png");
  self.w_name = "PAC";
  self.fire_sound = "sound/weapons/pac_fire.ogg";
  self.reload_sound = "sound/weapons/pac_reload.ogg";
  self.model = "models/weapons/w_pac.md3";
  self.abbrev = "PAC";
  self.description = "+ Instant-impact weapon. + Bypasses a % of target shields. + Lower shields on target yields higher armor damage.";
  self.icon = "gfx/ui/wep_icons/wi_pac.png";
  self.itemMuzzleFlash = te_muzzle_pac;
  self.effect_beam = te_pac_beam;
  self.beamActive = FALSE;
#endif 

#ifdef SSQC
  self.w_isburst = FALSE;
  self.think = default_weapon_think;
  self.w_attack = data_ini_attack_particle_cannon_;
#endif
};

#ifdef SSQC
void() data_ini_attack_particle_cannon_={
  local vector strikePoint;
  local float oldShields;
  local float dmgArmor, dmgShield;
  local float impactStyle;
  
  if( !ctrl_weapon_checkEnergy() ){
    return;
  }

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );

  impactStyle = IMPACT_SKY;
  if( !(trace_dphitcontents & DPCONTENTS_SKY) && !(trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) ){
    impactStyle = IMPACT_DIRT;
    
    strikePoint = FIRE_ENDPOINT + (v_forward * -5);
  
    dmgArmor = self.damageValue;
    dmgShield = 0;
    if( trace_ent.takedamage ){
      impactStyle = IMPACT_ARMOR;
      
      //strike a unit, not a building
      if( trace_ent.shield > 0 ){
        impactStyle = IMPACT_SHIELD;
        if( trace_ent.shield <= (trace_ent.shieldMax * 0.33) ){
          dmgShield = dmgArmor * 0.15;
        }
        else{
          dmgShield = dmgArmor * 0.25;
        }
        dmgArmor = dmgArmor - dmgShield;
      }
      if( (trace_ent.flags & FL_UNIT) ){
        if( trace_ent.vec_size <= 1 ){
          dmgArmor = dmgArmor * 0.7;
        }
        else if( trace_ent.vec_size == 2){
          dmgArmor = dmgArmor * 0.85;
        }
      }
      
      if( dmgShield ){
        impactStyle = IMPACT_SHIELD;
        t_damage_shield(trace_ent, self, FIRE_ENT, dmgShield, FIRE_ENDPOINT + (v_forward*3), FALSE);
      }
      
      HIT_LOCATION = t_damage(trace_ent, self, FIRE_ENT, dmgArmor, FIRE_ENDPOINT + (v_forward*3), '0 0 0');
  
      if( HIT_LOCATION && (trace_ent.shield < 101 && trace_ent.shield > 0) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION;
      }
    }
  }
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  client_send_particle_rail( BEAM_PAC, num_for_edict(self), FIRE_ORIGIN, FIRE_ENDPOINT, 4,  impactStyle);
};
#endif