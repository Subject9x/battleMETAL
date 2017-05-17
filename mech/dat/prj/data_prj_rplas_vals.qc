/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: data def file for the Rotary Plasma Cannon
this guy will bounce off up to two non-targets.
*/

//LIGHT AUTOCANNON SHOT==================
float DAT_PRJ_RPLAS_IDX = ID_PRJ_RPLAS;
float DAT_PRJ_RPLAS_VELOCITY = 1500;//1000;
string DAT_PRJ_RPLAS_MODEL = "progs/casing.mdl";
float DAT_PRJ_RPLAS_LIFETIME = 2;
float DAT_PRJ_RPLAS_DAMAGE = 1; //was 5 - 3/27/2017
float DAT_PRJ_RPLAS_BURN = 0.25;
float DAT_PRJ_RPLAS_DMGTYPE = DMG_BAL;

float DAT_PRJ_RPLAS_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_RPLAS_MODELFLAGS = MF_TRACER2;
float DAT_PRJ_RPLAS_ALPHA = 1;
vector DAT_PRJ_RPLAS_COLORMOD = '0.35 0.85 0.45';
float DAT_PRJ_RPLAS_GLOWCOLOR = 150;// 240;
float DAT_PRJ_RPLAS_GLOWSIZE = 0.1;
float DAT_PRJ_RPLAS_GLOWTRAIL= FALSE;

void() data_prj_rplas;
void() data_prj_rplas_ini;
void() data_prj_rplas_touch;
void() data_prj_rplas_bounce;
void() data_prj_rplas_burn;

void() data_prj_rplas={
  local entity oself, data;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "data";
    self.data_type = DATA_PROJ;
    self.data_idx = DAT_PRJ_RPLAS_IDX;
    self.unit_ini = data_prj_rplas_ini;
  self = oself;
};

void() data_prj_rplas_ini={
  self.classname = "spike";
  self.touch = data_prj_rplas_touch;
  self.data_idx = DAT_PRJ_RPLAS_IDX;
  self.p_velocity = DAT_PRJ_RPLAS_VELOCITY;
  self.c_model = DAT_PRJ_RPLAS_MODEL;
  self.p_lifetime = DAT_PRJ_RPLAS_LIFETIME;
  self.p_damage = DAT_PRJ_RPLAS_DAMAGE;
  self.p_dmgtype = DMG_BAL;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_RPLAS_EFFECTS;
  self.modelflags = DAT_PRJ_RPLAS_MODELFLAGS;
  self.alpha = DAT_PRJ_RPLAS_ALPHA;
  self.colormod = DAT_PRJ_RPLAS_COLORMOD;
  self.glow_color = DAT_PRJ_RPLAS_GLOWCOLOR;
  self.glow_size = DAT_PRJ_RPLAS_GLOWSIZE;
  self.glow_trail = DAT_PRJ_RPLAS_GLOWTRAIL;
};


void() data_prj_rplas_bounce={
  local vector rando;
  rando = randomvec();
  rando_x = ( self.velocity_x + rando_x) + (5 + crandom() * 15);
  rando_y = ( self.velocity_y + rando_y) + (5 + crandom() * 15);
  rando_z = ( self.velocity_z + rando_z) + (5 + crandom() * 15);
  self.velocity = normalize(rando) * self.p_velocity;
  self.movetype = MOVETYPE_FLYMISSILE;
  self.angles = vectoangles(self.velocity);
  self.p_damage = self.p_damage - (self.p_damage/3);
  self.think = SUB_Remove;
  self.nextthink = self.ltime;
};

void() data_prj_rplas_burn={
  local vector org;
  local entity e;
  if(self.enemy.deadflag > DEAD_NO){
    self.think = SUB_Remove;
    self.nextthink = time + 0.001;
    return;
  }
  t_damage(self.enemy, self, self.owner, DAT_PRJ_RPLAS_BURN, self.p_dmgtype, self.e_cam.origin, '0 0 0');
  org = randomvec() * 5 + self.e_cam.origin;
  setorigin(self, org);
  if(time > self.p_lifetime){
    self.think = SUB_Remove;
    self.nextthink = time + 0.001;
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
  
  if(other.owner == self.owner){
    return;
  }
  
  if(other.takedamage){
    local entity hit;
    hit = t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    
    if(other.sh_cur <= 0){
      setmodel(self, "progs/plasmashot.spr32");
      self.solid = SOLID_NOT;
      self.velocity = '0 0 0';
      self.avelocity = '0 0 0';
      self.enemy = other;
      self.e_cam = hit; //hack!
      self.think = data_prj_rplas_burn;
      self.nextthink = time + 0.001;
      self.p_lifetime = time + self.p_lifetime;
    }
    else{
      
      remove(self);
    }
    return;
	}
  else{
    if(self.aflag == 2){
      remove(self);
      return;
    }
    self.aflag = self.aflag + 1;
  }
  
	self.movetype = MOVETYPE_BOUNCE;
	self.think = data_prj_rplas_bounce;
	self.ltime = self.nextthink;
	self.nextthink = time + 0.0001;
};