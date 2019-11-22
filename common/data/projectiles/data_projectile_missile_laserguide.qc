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

void() data_projectile_missile_laserguide_touch;
void() data_projectile_missile_laserguide_think;

void() data_projectile_ini_missile_laserguide_={
  self.classname = "missile";
  self.touch = data_projectile_missile_laserguide_touch;
  self.data_velocity = 800;
  self.model = "q3mdl/proj/mdl_proj_lgm.md3";
  self.data_lifetime = 2;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.traileffectnum = particleeffectnum("TE_LGM_TRAIL");
  self.think = data_projectile_missile_laserguide_think;
};

void() data_projectile_missile_laserguide_touch={
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}

  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      self.think = SUB_Remove;
      self.nextthink = time + 0.01; 
      return;
    }
  }
  makevectors(self.angles);
  te_missile_explode(  self.origin + (v_up * -5),  1, '0.663 0.886 0.953', self.damageValue / 5, 1);

  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};

void() data_projectile_missile_laserguide_think={
  local vector lorg, dir, olddir;
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
    self.velocity = dir * self.data_velocity;
		self.angles = vectoangles(self.velocity);
	}
  if(time > self.data_lifetime){
    self.nextthink = time + 0.1;
    self.think = BecomeExplosion;
  }
  else{
    self.nextthink = time + 0.2; //0.05
    self.think = data_projectile_missile_laserguide_think;
  }
};

