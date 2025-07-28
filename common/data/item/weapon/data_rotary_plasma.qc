/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Rotary Plasma Chamber
      Range: Medium
      2rnd Burst.
      medium accuracy.
      projectiles burn unshielded targets.
*/
#ifdef SSQC
void() data_ini_attack_plasma_;
#endif
#ifdef CSQC
void() te_muzzle_rpc={

  traceline(self.wepFireOffset, self.owner.laser_sight_org, FALSE, self.owner);
  
  Sound7_Dynamic(self, CHAN_AUTO, self.fire_sound, 1.0, ATTN_NORM, (0.65 + (random() * 0.35)) * 125, SOUNDFLAG_DYNAMIC_INT);

  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){  
    pointparticles( particleeffectnum("TE_RPC_MUZZLE"), self.wepFireOffset, normalize(trace_endpos - self.wepFireOffset) * 2, 1);
  }
}
#endif
void() data_ini_plasma_={

  self.data_idx = UID_ITEM_rotary_plasma;
  
  if( (self.owner.flags & FL_CLIENT) ){
    self.w_clipsize = 2;
    self.reloadRate = 0.4;
    self.reloadMax = 1.0;
    self.count = 0.4; //burn-chance
  }
  else{
    self.w_clipsize = 1;
    self.reloadRate = 1.25;
    self.reloadMax = 1.25;
    self.count = 0; //burn-chance
  }

  self.damageValue = 16.0; //7.0
  self.count1 = 1.0; // rotate shot pattern;
  self.w_range = 1800;
  self.damageType = DMG_BAL;
  
  self.techLevel = 3;
  self.equipSize = BAL2;
  
  self.wepFireOffset = '0 0 6';
  self.spreadDefault = '2.0 6.0 0';
  self.burstRate = 1;
  
#ifdef CSQC  
  precache_sound("sound/weapons/rpls_fire.ogg");
  precache_sound("sound/weapons/rpls_fire_int.ogg");
  precache_model("models/weapons/w_rpc.md3");
  precache_file( "gfx/ui/wep_icons/wi_rpc.png");
  self.w_name = "Rotary Plasma Chamber";
  self.fire_sound = "sound/weapons/rpls_fire%s.ogg";
  self.model = "models/weapons/w_rpc.md3";
  self.abbrev = "RPC";
  self.description = "+ semi-auto. + 30% chance burn over time on unshielded hit. + inhibits target shield regen when burning.";
  self.icon = "gfx/ui/wep_icons/wi_rpc.png";
  self.itemMuzzleFlash = te_muzzle_rpc;
  self.w_clipsize = 2;
  self.reloadRate = 0.4;
  self.reloadMax = 1.0;
  self.damageValue = 7.0;
#endif 

#ifdef SSQC
  precache_sound("sound/weapons/rpls_burn.ogg");
  self.w_isburst = TRUE;
  self.w_attack = data_ini_attack_plasma_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_plasma_;
  self.spreadCache = self.spreadDefault;
#endif
};

#ifdef SSQC
void() data_ini_attack_plasma_={
  local entity theWeapon;
  local vector dir;

  ctrl_weapon_fireOffset();

  ctrl_weapon_updateAmmo( FALSE );
  
  //ctrl_weapon_make_projectile( -1 );
  //overriding for enforced spread.
  if( self.data_ini_projectile ){
    theWeapon = self;
    NEWSHOT = spawn();
    self = NEWSHOT;
      dir = FIRE_ENDPOINT + randomvec2() * 10;
      self.owner = FIRE_ENT;
      theWeapon.data_ini_projectile();
      self.damageType = theWeapon.damageType;
      self.damageValue = theWeapon.damageValue;
      self.data_idx = theWeapon.data_idx; //use weapon idx to sync to CSQC
      self.data_lifetime = time + self.data_lifetime;
      self.w_firetime = time + 0.5;
      self.velocity = normalize(dir - FIRE_ORIGIN);
      self.velocity = self.velocity * self.data_velocity;
      self.angles = vectoangles(self.velocity);
      if( cvar("gamemode") == GAMEMODE_CAMPAIGN ){
        self.nextthink = time + 0.01;
      }
      else{
        self.nextthink = time + 0.033;  //network compromise
      }
      self.movetype = MOVETYPE_FLYMISSILE;
      self.solid = SOLID_BBOX;
      self.takedamage = DAMAGE_NO;
      setmodel(self, "models/testball.md3");
      setsize(self, '0 0 0', '0 0 0');
      setorigin(self, FIRE_ORIGIN);
      self.SendEntity = te_send_missile;
      self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_VELOCITY);
      if(random() * 1.0 <= theWeapon.count){
        //burn chance
        self.count = TRUE;
      }
    self = theWeapon;
  }
  else{
    if( cvar("developer") ){
      cons_logAString("[Error]", "data_ini_projectile() not defined");  //DEBUG
    }
  }
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
};
#endif