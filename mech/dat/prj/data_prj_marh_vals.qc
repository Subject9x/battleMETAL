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
  self.classname = "missile";
  self.touch = data_prj_marh_touch;
  self.data_idx = DAT_PRJ_MARH_IDX;
  self.p_velocity = DAT_PRJ_MARH_VELOCITY;
  self.c_model = DAT_PRJ_MARH_MODEL;
  self.p_lifetime = DAT_PRJ_MARH_LIFETIME;
  self.p_damage = DAT_PRJ_MARH_DAMAGE;
  self.p_dmgtype = DMG_EXP;
  //cosmetics
  self.effects = EF_ADDITIVE + EF_NOSHADOW;
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
		return;
	}
  if(self.enemy == world){
    return;
  }
  //turnrate = 0.1;	//Change as you wish  
	if((self.owner.stat_lck_stt & LOCK_TARG)){
    if(time > self.lock_timer){
      makevectors(self.enemy.angles);
      vtemp = self.enemy.origin + '0 0 10' + ((crandom() * 35) * v_right) + (v_forward * (crandom() * 35));
    }
    else{
      local vector mns, mxs;
      mns = self.c_ofs - '25 25 25';
      mxs = self.c_ofs + '25 25 25';
      local float yiss;
      yiss = util_checkInBounds(self.origin, mns, mxs);
      
      if(yiss){
        makevectors(self.enemy.angles);
        vtemp = self.enemy.origin + '0 0 10' + ((crandom() * 35) * v_right) + (v_forward * (crandom() * 35));
      }
      else{
        vtemp = self.c_ofs;
      }
    }
    olddir = normalize(vtemp - self.origin);
    dir = olddir + olddir + olddir;
    dir = dir * (1/3);
    dir = normalize(olddir + dir);
    self.velocity = self.p_velocity * dir;
    self.angles = vectoangles(self.velocity);
	}
  else{
    return;
  }
  
  if(time > self.p_lifetime){
    self.nextthink = time + 0.001;
    self.think = BecomeExplosion;
  }
  else{
    self.nextthink = time + 0.01;
    self.think = data_prj_marh_th;
  }
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
  
  if(other.owner == self.owner){
    return;
  }
  
  if(other.classname == "missile"){
    return;
  }

  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  BecomeExplosion();
};