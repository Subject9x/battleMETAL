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

void() data_projectile_missile_swarm_touch;
void() data_projectile_missile_swarm_think;

void() data_projectile_ini_missile_swarm_={
  self.classname = "missile";
  self.touch = data_projectile_missile_swarm_touch;
  self.p_velocity = 1600;
  self.model = "q3mdl/proj/mdl_proj_lgm.md3";
  self.p_lifetime = 1.2;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.traileffectnum = particleeffectnum("TE_SWRM_TRAIL");
  self.think = data_projectile_missile_swarm_think;
};

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
  local vector lorg, dir, olddir, nuv;
  local float turnrate;

  turnrate = 0.9;//0.15 turn rate increased to make up for longer intervals
  lorg = self.owner.laser_sight_org;
  
  if (lorg != '0 0 0'){
    olddir = normalize(self.velocity);
		dir = normalize(lorg - self.origin);
    if (olddir_x - dir_x > turnrate)
      dir_x = olddir_x - turnrate;
    if (olddir_x - dir_x < -1 * turnrate)
      dir_x = olddir_x + turnrate;
    if (olddir_y - dir_y > turnrate)
      dir_y = olddir_y - turnrate;
    if (olddir_y - dir_y < -1 * turnrate)
      dir_y = olddir_y + turnrate;
    if (olddir_z - dir_z > turnrate)
      dir_z = olddir_z - turnrate;
    if (olddir_z - dir_z < -1 * turnrate)
      dir_z = olddir_z + turnrate;
    self.velocity = dir * self.p_velocity;
		self.angles = vectoangles(self.velocity);
	}
  if(time > self.p_lifetime){
    self.nextthink = time + 0.1;
    self.think = BecomeExplosion;
  }
  else{
    self.nextthink = time + 0.2; //0.05
    self.think = data_projectile_missile_swarm_think;
  }
};

