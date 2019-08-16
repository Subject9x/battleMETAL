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
  self.data_velocity = 650;
  self.model = "q3mdl/proj/mdl_proj_marh.md3";
  self.data_lifetime = 8;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.traileffectnum = particleeffectnum("TE_ARH_TRAIL");
  self.c_ofs = '0 0 0';
  self.think = data_projectile_missile_activeradar_delay;
};

void() data_projectile_missile_activeradar_think={
	local vector	dir, vtemp;
  
	if (self.enemy.health < 1){
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
		return;
	}
  if(self.enemy == world){
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
  self.nextthink = time + 0.3;
};

void() data_projectile_missile_activeradar_delay={
  self.velocity = normalize( self.origin - self.c_ofs);
  self.velocity = self.velocity * (self.data_velocity * 0.33);
  self.angles = vectoangles(self.velocity);
   
  self.think = data_projectile_missile_activeradar_think; 
  self.nextthink = time + 1;
};

void() data_projectile_missile_activeradar_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		//remove(self);
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
		return;
	}

  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      //remove(self);
      self.think = SUB_Remove;
      self.nextthink = time + 0.01;
      return;
    }
  }

  makevectors(self.angles);
  te_missile_explode(  self.origin + (v_up * -5), 1, '0.969 0.996 0.18', self.damageValue / 5, 1);
  //remove(self);
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};
