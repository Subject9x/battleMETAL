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

void() data_projectile_missile_activeradar_think;
void() data_projectile_missile_activeradar_delay;
void() data_projectile_missile_activeradar_touch;

void() data_projectile_ini_missile_active_radar_={
  self.classname = "prj_marh";
  self.touch = data_projectile_missile_activeradar_touch;
  self.p_velocity = 650;
  self.model = "q3mdl/proj/mdl_proj_marh.md3";
  self.p_lifetime = 8;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.traileffectnum = 0;
  self.c_ofs = '0 0 0';
  self.think = data_projectile_missile_activeradar_delay;
};

void() data_projectile_missile_activeradar_think={
	local vector	dir, vtemp, olddir;
  local float turnrate;
	if (self.enemy.health <= 0){
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
		return;
	}
  if(self.enemy == world){
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
    return;
  }
  turnrate = 0.7;
	if( (self.owner.stat_lck_stt & LOCK_TARG_HAS) ){
    makevectors(self.enemy.angles);
    vtemp = self.enemy.origin + '0 0 10' + ((crandom() * self.enemy.maxs_x) * v_right) + (v_forward * (crandom() * self.enemy.maxs_x));
    olddir = normalize(self.velocity);
		dir = normalize(vtemp - self.origin);
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
  else{
    self.p_lifetime = self.p_lifetime - 0.25;
    return;
  }
  
  if(time > self.p_lifetime){
    self.think = BecomeExplosion;
  }
  else{
    self.think = data_projectile_missile_activeradar_think;
  }
  self.nextthink = time + 0.3;
};

//oh what I do for cosmetics
void() data_projectile_missile_activeradar_delay={
  if( !self.traileffectnum ){
    self.traileffectnum = particleeffectnum("TE_ARH_TRAIL");
  }
  self.velocity = self.velocity * self.p_velocity;
  self.angles = vectoangles(self.velocity);
  
  self.think = data_projectile_missile_activeradar_think; 
  self.nextthink = time + 0.3;
};

void() data_projectile_missile_activeradar_touch={
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
  te_missile_explode(  self.origin + (v_up * -5), 1, '0.969 0.996 0.18', self.damageValue / 5, 1);
  remove(self);
};
