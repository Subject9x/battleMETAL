/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Missile - Active Radar
    Explodes on touch
    needs player lock-on to follow target.
*/

#ifndef CSQC
void() data_projectile_missile_activeradar_think;
void() data_projectile_missile_activeradar_delay;
void() data_projectile_missile_activeradar_touch;
#endif CSQC

#ifdef CSQC
void() projectile_marh_expl={
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
    hitColor = '0.969 0.996 0.18';
    hitBloom = 0.01;
    hitScale = 1;
    pointsound(self.origin, "sound/fx_boom.ogg",  0.8, ATTN_NORM);
  }
  te_missile_explode( self.origin, hitScale, hitColor, hitBloom ); 
};
#endif

void() data_projectile_ini_missile_active_radar_={
  self.classname = "missile";
  self.data_velocity = 650;
  self.data_lifetime = 8;
  self.compOffset = '0 0 0';   
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_marh.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_ARH_TRAIL");
    self.pcl_explode = projectile_marh_expl;
  #endif
  
  #ifndef CSQC
    self.think = data_projectile_missile_activeradar_delay;  
  #endif
};
#ifndef CSQC
void() data_projectile_missile_activeradar_think={
	local vector	dir, vtemp;
  
  if( !self.touch ){
    self.touch = data_projectile_missile_activeradar_touch;
  }
  
	if (self.enemy.health < 1){
    self.solid = SOLID_NOT;
    self.touch = SUB_Null;
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
		return;
	}
  if(self.enemy == world){
    self.solid = SOLID_NOT;
    self.touch = SUB_Null;
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
    return;
  }
	if( (self.owner.stat_lck_stt & LOCK_TARG_HAS) ){
    makevectors(self.enemy.angles);
    vtemp = self.enemy.origin + '0 0 10' + ((crandom() * self.enemy.maxs_x) * v_right) + (v_forward * (crandom() * self.enemy.maxs_x));
    dir = normalize(vtemp - self.origin);
    if( time > NEWSHOT.w_isburst ){
      self.velocity = dir * self.data_velocity;
    }
    else{
      self.velocity_x = dir_x * self.data_velocity;
      self.velocity_y = dir_y * self.data_velocity;
      self.velocity_z = dir_z * self.data_velocity / 4;
    }
    self.angles = vectoangles( self.velocity );
	}
  else{
    self.velocity = self.angles * self.data_velocity;
  }
  
  if(time > self.data_lifetime){
    self.think = BecomeExplosion;
  }
  else{
    self.think = data_projectile_missile_activeradar_think;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.nextthink = time + 0.3;
};

void() data_projectile_missile_activeradar_delay={
  self.velocity = normalize( self.origin - self.compOffset);
  self.velocity = self.velocity * (self.data_velocity * 0.33);
  self.angles = vectoangles(self.velocity);
   
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.think = data_projectile_missile_activeradar_think; 
  self.nextthink = time + 1;
};

void() data_projectile_missile_activeradar_touch={
  local float debris;
  if( other == self.owner ){
    return;
  }
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  debris = 0;
	if (pointcontents(self.origin) == CONTENT_SKY){
    self.impactType = IMPACT_SKY;
    debris = 0;
	}
 
  if(other.takedamage){
    self.impactType = IMPACT_ARMOR;
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      self.impactType = IMPACT_SHIELD;
    }
    else{
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, 6, 1 );
    }
    debris = 0;
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, rint(random() * 3), 1 );
  }

  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};
#endif CSQC
