/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Missile - Laser Guided
    Explodes on touch
    follows player reticle
*/

#ifndef CSQC
void() data_projectile_missile_laserguide_touch;
void() data_projectile_missile_laserguide_think;
#endif CSQC

#ifdef CSQC
void() projectile_mlg_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  
  if( self.impactType == IMPACT_SHIELD ){
    hitColor = '0 0.2 0.67';
    hitBloom = -0.01;
    hitScale = 0.5;
    pointsound( self.origin, "sound/fx_shieldhit.ogg", 0.6, ATTN_NORM );
  }
  else{
    hitColor = '0.663 0.886 0.953';
    hitBloom = 0.01;
    hitScale = 1;
    pointsound(self.origin, "sound/fx_boom.ogg",  0.8, ATTN_NORM);
  }
  te_missile_explode( self.origin, hitScale, hitColor, hitBloom ); 
};
#endif

void() data_projectile_ini_missile_laserguide_={
  self.classname = "missile";
  self.data_velocity = 2200;
  self.data_lifetime = 1.1;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_lgm.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_LGM_TRAIL");
    self.pcl_explode = projectile_mlg_expl;
    self.scale = 2;
  #endif 
  
  #ifndef CSQC
    self.touch = data_projectile_missile_laserguide_touch;
    self.think = data_projectile_missile_laserguide_think;  
  #endif
};
#ifndef CSQC
void() data_projectile_missile_laserguide_touch={
  local float debris;
  local float damage; 
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  
	if (pointcontents(self.origin) == CONTENT_SKY){
    self.impactType = IMPACT_SKY;
  }
  else{
    self.impactType = IMPACT_DIRT;
    debris = 4;
    if(other.takedamage){
      damage = self.damageValue;
      if( other.shield > 0 ){
        damage = damage * 0.33;
        t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, FALSE);
        self.impactType = IMPACT_SHIELD;
      }
      else{
        t_damage(other, self, self.owner, self.damageValue, self.origin, '0 0 0');
        te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, 3, 2 );
        self.impactType = IMPACT_ARMOR;
      }
      debris = 0;
    }
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, debris, 2 );
  }

  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};

void() data_projectile_missile_laserguide_think={
  local vector vtemp;
  
  vtemp = normalize(self.owner.laser_sight_org - self.origin);
  self.velocity = vtemp * 0.5;
  self.velocity = self.velocity * self.data_velocity;
  self.angles = vectoangles(self.velocity);
  self.SendFlags = self.SendFlags | SENDFLAG_VELOCITY;
  
  if(time > self.data_lifetime){
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.1;
  }
  else{
    self.nextthink = time + 0.025;
    self.think = data_projectile_missile_laserguide_think;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
};
#endif CSQC

