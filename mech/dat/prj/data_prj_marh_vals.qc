/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: long-range, low damage, homing missile
*/
//=======MISSILE: ACTIVE-RADAR========
float DAT_PRJ_MARH_IDX = ID_PRJ_MARH;
float DAT_PRJ_MARH_DAMAGE = 2;
float DAT_PRJ_MARH_DMGTYPE = DMG_EXP;

void() data_prj_marh_th;
void() data_prj_marh_touch;

void() data_prj_marh_ini={
  self.classname = "prj_marh";
  self.touch = data_prj_marh_touch;
  self.data_idx = DAT_PRJ_MARH_IDX;
  self.p_velocity = DAT_PRJ_MARH_VELOCITY;
  self.c_model = DAT_PRJ_MARH_MODEL;
  self.p_lifetime = DAT_PRJ_MARH_LIFETIME;
  self.p_damage = DAT_PRJ_MARH_DAMAGE;
  self.p_dmgtype = DMG_EXP;
  //cosmetics
  self.effects = self.effects - (self.effects & EF_NOMODELFLAGS);
  self.effects = self.effects | EF_NOSHADOW;
  self.modelflags = DAT_PRJ_MARH_MODELFLAGS;
  self.alpha = DAT_PRJ_MARH_ALPHA;
  self.colormod = DAT_PRJ_MARH_COLORMOD;
  self.glow_color = DAT_PRJ_MARH_GLOWCOLOR;
  self.glow_size = DAT_PRJ_MARH_GLOWSIZE;
  self.glow_trail = DAT_PRJ_MARH_GLOWTRAIL;
  self.c_ofs = '0 0 0';
};

void() data_prj_marh_th={
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
    vtemp = self.enemy.origin + '0 0 10' + ((crandom() * self.enemy.c_bbx_x_x) * v_right) + (v_forward * (crandom() * self.enemy.c_bbx_x_x));
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
    self.think = data_prj_marh_th;
  }
    self.nextthink = time + 0.3;
};

void() data_prj_marh_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    BecomeExplosion();
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