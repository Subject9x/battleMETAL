/*
battleMETAL
Author: Peter Roohr
Date: 06/02/2019
Overview: 
  Data File - Projectile
   Missile - Laser Guided
    Explodes on touch
    follows player reticle
*/

#ifndef CSQC
void() data_projectile_missile_swarm_touch;
void() data_projectile_missile_swarm_think;
void() data_projectile_missile_swarm_delay;
#endif CSQC

#ifdef CSQC
void() projectile_swarm_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    hitColor = '0 1.25 0.67';
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

void() data_projectile_ini_missile_swarm_={
  self.classname = "missile";
  self.data_velocity = 800;
  self.data_lifetime = 3;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_lgm.md3";
    self.effects = EF_NOSHADOW;
    self.traileffectnum = particleeffectnum("TE_SWRM_TRAIL"); 
    self.pcl_explode = projectile_swarm_expl;
  #endif 
  
  #ifndef CSQC
    self.think = data_projectile_missile_swarm_delay;
    self.touch = data_projectile_missile_swarm_touch;  
  #endif
};
#ifndef CSQC
void() data_projectile_missile_swarm_touch={
  local float debris;
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  self.impactType = IMPACT_DIRT;
  debris = rint( 2 + random() * 4);
	if (pointcontents(self.origin) == CONTENT_SKY){
    self.impactType = IMPACT_SKY;
    debris = 0;
	}

  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    self.impactType = IMPACT_ARMOR;
    if( other.shield > 0 ){
      self.impactType = IMPACT_SHIELD;
    }
    else{
      self.impactType = IMPACT_ARMOR;
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, 3, 1 );
    }
    debris = 0;
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, debris, 1 );
  }
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};

void() data_projectile_missile_swarm_think={
	local vector	dir, vtemp;
  
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  
	if (self.enemy.health < 1){
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
		return;
	}

	if( self.enemy != world ){
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
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.1;
  }
  else{
    self.nextthink = time + 0.1;
    self.think = data_projectile_missile_swarm_think;
  }
};

void() data_projectile_missile_swarm_delay={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.velocity = normalize( self.origin - self.compOffset);
  self.velocity = self.velocity * (self.data_velocity * 0.50);
  self.angles = vectoangles(self.velocity);
   
  self.think = data_projectile_missile_swarm_think; 
  self.nextthink = time + 1;
};
#endif CSQC

