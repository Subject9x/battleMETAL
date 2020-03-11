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
void() data_projectile_ini_missile_swarm_={
  self.classname = "missile";
  self.data_velocity = 800;
  self.data_lifetime = 3;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_lgm.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_SWRM_TRAIL");   
  #endif 
  
  #ifndef CSQC
    self.think = data_projectile_missile_swarm_delay;
    self.touch = data_projectile_missile_swarm_touch;  
  #endif
};
#ifndef CSQC
void() data_projectile_missile_swarm_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
    remove(self);
		return;
	}

  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      remove(self);
      return;
    }
  }
  makevectors(self.angles);
  te_missile_explode(  self.origin + (v_up * -5),  1, '0.663 0.886 0.953', self.damageValue / 5, 1);
  remove(self);
};

void() data_projectile_missile_swarm_think={
	local vector	dir, vtemp;
  
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
    self.nextthink = time + 0.2;
    self.think = data_projectile_missile_swarm_think;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
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

