/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Missile - Swarm
      Range: short
      3rnd burst
      Arcing
      3mis per up-to 3 targets
*/
#ifndef CSQC
void() data_ini_attack_missile_swarm_;

float DATA_SWARM_MAX_TARGETS = 3;
#endif

void() data_ini_missile_swarm_={

  self.data_idx = 14;  
  self.w_name = "Missile - Swarm";
  
  self.w_clipsize = 3;
  self.reloadRate = 0.3;
  self.reloadMax = 10;
  self.energyRate = 0;
  
  self.w_range = 1000;
  self.damageValue = 20;
  self.damageType = DMG_EXP | EFF_ARC | EFF_PTR;
 
  self.techLevel = 3;
  self.equipSize = 2;

  #ifdef CSQC
  self.abbrev = "SWRM";
  self.description = "+ Requires <Active Radar> to fire. + Fires 3 missiles at up to 3 targets each.";
  self.icon = "gfx/ui/wep_icons/wi_swrm.png";  
  #endif 
  
  #ifndef CSQC
  self.spreadDefault = '0.07 0.07 0';
  self.w_isburst = FALSE;
  self.burstRate = 1;
  self.wepFireOffset = '0 0 2';
  self.fire_sound = "sound/weapons/mis_fire.ogg";
  self.model = "q3mdl/weapons/w_swrm.md3";
  self.w_attack = data_ini_attack_missile_swarm_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_missile_swarm_;
  #endif
};

#ifndef CSQC
void() data_ini_attack_missile_swarm_={
  local float maxtarg;
  local vector arc, start;
  
  if( self.owner.stat_rdr_mode == TRUE ){
    //check for 'Active' Radar
      ctrl_weapon_updateAmmo( TRUE );
    
      ctrl_weapon_fireOffset();
      
      local entity targs;
      maxtarg = DATA_SWARM_MAX_TARGETS;
      for(targs = findradius(self.origin, self.w_range); targs != world; targs = targs.chain){
        if( maxtarg <= 0 ){
          continue;
        }
        if( targs.deadflag > DEAD_NO ){
          continue;
        }
        if( !ai_check_face(targs, 0.7) || (targs == self.owner) ){
          continue;
        }
        if( !(targs.flags & FL_MONSTER) || !(targs.flags & FL_CLIENT) ){
          continue;
        }
        if( targs.faction == self.owner.faction){
          continue;
        }
        maxtarg = maxtarg - 1;
        ctrl_weapon_make_projectile( 0.2 );
        
        arc = FIRE_ORIGIN + (v_forward * (200 + (crandom() * 20)));
        arc = arc + (v_up * (133 + (crandom() * 67))) + (v_right * (crandom() * 67));
        start = FIRE_ORIGIN + (v_forward * 0.75) + ((crandom() * 1.25) * v_right) + (v_up * (crandom() * 1.5));
        NEWSHOT.enemy = targs;
        NEWSHOT.compOffset = start;
        NEWSHOT.velocity = '0 0 0';
        NEWSHOT.velocity = normalize( arc - start );
        NEWSHOT.velocity = NEWSHOT.velocity * 50;
        NEWSHOT.angles = vectoangles( NEWSHOT.velocity );
        NEWSHOT.w_isburst = time + 2; //use to track curving behavior
        setorigin(NEWSHOT, start);
        sound (NEWSHOT, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM);
        pointparticles( particleeffectnum("TE_SWRM_MUZZLE"), self.origin, normalize( targs.origin - FIRE_ORIGIN ) * 3, 1);
        NEWSHOT = world;
      }
  }
};
#endif