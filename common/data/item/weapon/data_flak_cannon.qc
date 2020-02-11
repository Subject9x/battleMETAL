/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Item - Weapon
    Flak Cannon
      Range: Long
      Rapid fire
      low accuracy
      small AoE when shields are gone
*/
float DAT_FLAK_SHRAP_TOTAL    = 14;
#ifndef CSQC
vector DAT_FLAK_SHRAP_SPREAD  = '0.3 0.3 64';
float DAT_PRJ_FLAK_PROXYRAD   = 45;
float DAT_PRJ_FLAK_EXPRAD     = 50;

void() data_ini_attack_flak_;
#endif

void() data_ini_flak_cannon_={

  self.data_idx = 12;  
  self.w_name = "Flak Cannon";
  
  self.w_clipsize = 1;    //1 - 10/07/2019
  self.reloadRate = 0.67; //0.3 - 10/07/2019
  self.reloadMax = 0.67;  //0.3 - 10/07/2019
  self.energyRate = 0;
  
  self.w_range = 2000;
  self.damageValue = 0.5;
  self.damageType = DMG_BAL;
  
  self.techLevel = 1;
  self.equipSize = 1;
  
  #ifdef CSQC
  self.damageValue = self.damageValue * DAT_FLAK_SHRAP_TOTAL;
  self.abbrev = "FLAK";
  self.description = "+ Instant-impact weapon. + Shotgun Damage pattern when Target has no <shields>. + 14 sub-munitions.";
  self.icon = "gfx/ui/wep_icons/wi_flak.png";
  #endif
  
  #ifndef CSQC
  self.spreadDefault = '0.017 0.015 0';
  self.burstRate = 2;
  self.w_isburst = FALSE;
  self.wepFireOffset = '0 0 5';
  self.fire_sound = "sound/weapons/flak_fire.ogg";
  self.model = "q3mdl/weapons/w_flk.md3";
  self.w_attack = data_ini_attack_flak_;
  self.think = default_weapon_think;
  #endif
};

#ifndef CSQC
void() data_ini_attack_flak_={
  local float totes;
  local float shieldDamage;
  
  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_FLK_MUZZLE"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 4, 1);
  
  if( vlen(trace_endpos - FIRE_ORIGIN) > 100 ){
    pointparticles( particleeffectnum("TE_FLK_TRACER"), FIRE_ORIGIN, normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 1600, 1);
  }
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }  
  
  if( !trace_ent.takedamage ){
    if( (trace_dphitcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_OPAQUE) ){
      pointparticles( particleeffectnum("TE_FLK_DIRT"), FIRE_ENDPOINT + (v_up * 3) + (v_forward * -7), normalize( FIRE_ENDPOINT - FIRE_ORIGIN ) * 20, 1);
    }
    return;
  }
  if(trace_ent && trace_ent != world){
    totes = DAT_FLAK_SHRAP_TOTAL;
    shieldDamage = (self.damageValue * totes) / 2;
    if(trace_ent.shield > 0){
      t_damage(trace_ent, self, self.owner, shieldDamage, self.damageType, trace_endpos, '0 0 0');
    }
    else{
      local vector shotpoint;
      local vector shrapPoint;
      local vector shotDir;
      local vector shrapDir;
      
      shotpoint = trace_endpos + (v_forward * -32);
      shotDir = normalize(trace_endpos - shotpoint);
      pointparticles( particleeffectnum("TE_FLK_IMPACT"), shotpoint, shotDir * 4, 1);
      while(totes > 0){
        shrapDir = shotDir + (crandom()*DAT_FLAK_SHRAP_SPREAD_x*v_right) + (crandom()*DAT_FLAK_SHRAP_SPREAD_y*v_up);
        shrapPoint = shotpoint + shrapDir*DAT_FLAK_SHRAP_SPREAD_z;
        traceline( shotpoint, shrapPoint, FALSE, self.owner);
        t_damage(trace_ent, self, self.owner, self.damageValue, self.damageType, trace_endpos, '0 0 0');
        totes = totes - 1;
      }
    }
  }
};
#endif