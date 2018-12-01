/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: data def file for the Rotary Plasma Cannon
this guy will bounce off up to two non-targets.
*/

//ROTARY PLASMA SHOT==================
float DAT_PRJ_RPLAS_IDX = ID_PRJ_RPLAS;

void() data_prj_rplas_touch;
void() data_prj_rplas_burn;

void() data_prj_rplas_ini={
  self.classname = "prj_rplas";
  self.touch = data_prj_rplas_touch;
  self.data_idx = DAT_PRJ_RPLAS_IDX;
  self.p_velocity = DAT_PRJ_RPLAS_VELOCITY;
  self.c_model = DAT_PRJ_RPLAS_MODEL;
  self.p_lifetime = DAT_PRJ_RPLAS_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_RPLAS_EFFECTS;
  //self.modelflags = self.modelflags | DAT_PRJ_RPLAS_MODELFLAGS;
  self.modelflags = 0;
  self.alpha = DAT_PRJ_RPLAS_ALPHA;
  self.colormod = DAT_PRJ_RPLAS_COLORMOD;
  self.glow_color = DAT_PRJ_RPLAS_GLOWCOLOR;
  self.glow_size = DAT_PRJ_RPLAS_GLOWSIZE;
  self.glow_trail = DAT_PRJ_RPLAS_GLOWTRAIL;
};

void() data_prj_rplas_burn={
  local vector org;
  local entity e;
  if(self.enemy.deadflag > DEAD_NO){
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
    return;
  }
  t_damage(self.enemy, self, self.owner, DAT_RPLAS_DMG_BURN, self.p_dmgtype, self.e_cam.origin, '0 0 0');
  org = randomvec() * 5 + self.e_cam.origin;
  setorigin(self, org);
  if(time > self.p_lifetime){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    return;
  }
  else{
    self.think = data_prj_rplas_burn;
    self.nextthink = time + 0.1;
  }
};

void() data_prj_rplas_touch={

  
  if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
 
  if(other == self.owner){
    return;
  }
  
  if(other.takedamage){
    local entity hit;
    hit = t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if(other.sh_cur <= 0){
      setmodel(self, "progs/plasmashot.spr32");
      setsize(self, '0 0 0', '0 0 0');
      self.movetype = MOVETYPE_FOLLOW;
      self.solid = SOLID_NOT;
      self.velocity = '0 0 0';
      self.avelocity = '0 0 0';
      self.enemy = other;
      self.e_cam = hit; //hack!
      self.aiment = self.e_cam;
      self.punchangle = self.e_cam.angles;
      self.view_ofs = self.origin - self.e_cam.origin;
      self.angles = self.e_cam.angles;
      self.v_angle = self.angles - self.e_cam.angles;
      setorigin(self, randomvec() * 5 + self.e_cam.origin);
      self.think = data_prj_rplas_burn;
      self.nextthink = time + 0.001;
      self.p_lifetime = time + self.p_lifetime;
      return;
    }
	}
  remove(self);
};