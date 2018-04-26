/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: data def file for a weapon projectile
*/

//=======MISSILE: LASER-GUIDED========
float DAT_PRJ_MLGD_IDX = ID_PRJ_MLGD;

void() data_prj_mlgd_th;
void() data_prj_mlgd_touch;

void() data_prj_mlgd_ini={
  self.classname = "prj_mlgd";
  self.touch = data_prj_mlgd_touch;
  self.data_idx = DAT_PRJ_MLGD_IDX;
  self.p_velocity = DAT_PRJ_MLGD_VELOCITY;
  self.c_model = DAT_PRJ_MLGD_MODEL;
  self.p_lifetime = DAT_PRJ_MLGD_LIFETIME;
  
  //cosmetics
  self.effects = EF_ADDITIVE + EF_NOSHADOW;
  self.modelflags = DAT_PRJ_MLGD_MODELFLAGS;
  self.alpha = DAT_PRJ_MLGD_ALPHA;
  self.colormod = DAT_PRJ_MLGD_COLORMOD;
  self.glow_color = DAT_PRJ_MLGD_GLOWCOLOR;
  self.glow_size = DAT_PRJ_MLGD_GLOWSIZE;
  self.glow_trail = DAT_PRJ_MLGD_GLOWTRAIL;
};

void() data_prj_mlgd_th={
  local vector lorg, dir, olddir;
  local float turnrate;

  turnrate = 0.15;	//Change as you wish
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
    self.nextthink = time + 0.001;
    self.think = BecomeExplosion;
  }
  else{
    self.nextthink = time + 0.05;
    self.think = data_prj_mlgd_th;
  }
};

void() data_prj_mlgd_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}

  if(other == self.owner){
    return;
  }
  if(other.takedamage){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  }
  
  BecomeExplosion();
};