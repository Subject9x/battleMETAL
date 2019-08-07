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
      Needs radar lock
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
  self.reloadRate = 0.1;
  self.reloadMax = 10;
  self.energyRate = 0;
  
  self.w_range = 600;
  self.damageValue = 20;
  self.damageType = (DMG_EXP | EFF_ARC | EFF_LOK);
 
  self.techLevel = 3;
  self.i_size = 2;

  #ifdef CSQC
  self.abbrev = "SWRM";
  self.description = "+ Requires <Active Radar> to fire. + Requires <Targe Lock> on 1 target to fire. + Fires 3 missiles at up to 3 targets.";
  self.icon = "gfx/ui/wep_icons/wi_swrm.png";  
  #endif 
  
  #ifndef CSQC
  self.spreadDefault = '0.07 0.07 0';
  self.w_isburst = FALSE;
  self.burstRate = 1;
  self.w_fire_ofs = '0 0 2';
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
  
  if( self.owner.stat_rdr_mode == TRUE ){
    //check for 'Active' Radar
    //if( (self.owner.stat_lck_stt & LOCK_TARG_HAS) ){
      //check to see if owner has a target lock
      ctrl_weapon_updateAmmo( TRUE );
    
      ctrl_weapon_fireOffset();
      
      local entity targs;
      maxtarg = DATA_SWARM_MAX_TARGETS;
      targs = findradius(self.owner.origin, self.w_range);
      while(targs){
        if( maxtarg > 0 ){
          if( (ai_check_face(targs, 0.7)) && (targs != self.owner) ){
            if( (targs.flags & FL_CLIENT) || (targs.flags & FL_MONSTER) ){
              if( targs.faction != self.owner.faction){
                if(targs.deadflag == DEAD_NO){
                  maxtarg = maxtarg - 1;
                  ctrl_weapon_make_projectile( 1 );
                  NEWSHOT.enemy = targs;
                  NEWSHOT.velocity = normalize(targs.origin - FIRE_ORIGIN);
                  NEWSHOT.velocity = NEWSHOT.velocity * NEWSHOT.data_velocity;
                  NEWSHOT.velocity_z = NEWSHOT.velocity_z + 500;
                  NEWSHOT.angles = vectoangles(NEWSHOT.velocity);
                  sound (NEWSHOT, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
                  pointparticles( particleeffectnum("TE_SWRM_MUZZLE"), self.origin, normalize( targs.origin - FIRE_ORIGIN ) * 3, 1);
                }
              }
            }
          }
        }
        targs = targs.chain;
      }
    //}
  }
};
#endif
