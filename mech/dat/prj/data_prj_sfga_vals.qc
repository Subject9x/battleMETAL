/*
mech Mod
Author: Subject9x
Date: 05/17/2017
Overview: data def file for a weapon projectile
*/

//LIGHT AUTOCANNON SHOT==================
float DAT_PRJ_SFGA_IDX = ID_PRJ_SFGA;
float DAT_PRJ_SFGA_VELOCITY = 1500;
string DAT_PRJ_SFGA_MODEL = "progs/casing.mdl";
float DAT_PRJ_SFGA_LIFETIME = 8;
float DAT_PRJ_SFGA_DAMAGE = 300;
float DAT_PRJ_SFGA_DMGTYPE = DMG_EXP;
float DAT_PRJ_SFGA_RAD = 150;

float DAT_PRJ_SFGA_EFFECTS = EF_NOSHADOW;
float DAT_PRJ_SFGA_MODELFLAGS = MF_GRENADE;
float DAT_PRJ_SFGA_ALPHA = 1;
vector DAT_PRJ_SFGA_COLORMOD = '0.85 0.45 0.45';
float DAT_PRJ_SFGA_GLOWCOLOR = 240;
float DAT_PRJ_SFGA_GLOWSIZE = 0.005;
float DAT_PRJ_SFGA_GLOWTRAIL= FALSE;

void() data_prj_sfga;
void() data_prj_sfga_ini;
void() data_prj_sfga_touch;
void() data_prj_sfga_raddmg;
void() data_prj_sfga={
  local entity oself, data;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "data";
    self.data_type = DATA_PROJ;
    self.data_idx = DAT_PRJ_SFGA_IDX;
    self.unit_ini = data_prj_sfga_ini;
    self.p_damage = DAT_PRJ_SFGA_DAMAGE;
  self = oself;
};

void() data_prj_sfga_ini={
  self.classname = "spike";
  self.touch = data_prj_sfga_touch;
  self.data_idx = DAT_PRJ_SFGA_IDX;
  self.p_velocity = DAT_PRJ_SFGA_VELOCITY;
  self.c_model = DAT_PRJ_SFGA_MODEL;
  self.p_lifetime = DAT_PRJ_SFGA_LIFETIME;
  self.p_damage = DAT_PRJ_SFGA_DAMAGE;
  self.p_dmgtype = DMG_BAL;
  self.w_range = DAT_PRJ_SFGA_RAD;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_SFGA_EFFECTS;
  self.modelflags = DAT_PRJ_SFGA_MODELFLAGS;
  self.alpha = DAT_PRJ_SFGA_ALPHA;
  self.colormod = DAT_PRJ_SFGA_COLORMOD;
  self.glow_color = DAT_PRJ_SFGA_GLOWCOLOR;
  self.glow_size = DAT_PRJ_SFGA_GLOWSIZE;
  self.glow_trail = DAT_PRJ_SFGA_GLOWTRAIL;
};

void() data_prj_sfga_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    data_prj_sfga_raddmg();
    BecomeExplosion();
    return;
  }

  if(other == self.owner){
    return;
  }
  
  if(other.owner == self.owner){
    return;
  }
  
  if(other.classname == "spike"){
    return;
  }
  t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
  data_prj_sfga_raddmg();
  BecomeExplosion();
};

void() data_prj_sfga_raddmg={
  local entity f;
  f = findradius(self.origin, self.w_range);
  while(f){
    if(f != other){
      if(f.classname != MECH_PIECE){
        local float d, dmg_act;
        d = vlen(f.origin - self.origin);
        if(d < (DAT_PRJ_SFGA_RAD/4)){
          dmg_act = self.p_damage;
        }
        else if(d > (DAT_PRJ_SFGA_RAD/4) && d < (DAT_PRJ_SFGA_RAD/2)){
          dmg_act = self.p_damage/2;
        }
        else{
          dmg_act = self.p_damage/4;
        }
        traceline(self.origin, f.origin, FALSE, self.owner);
        t_damage(f, self, self.owner, dmg_act, self.p_dmgtype, trace_endpos, '0 0 0');
      }
    }
    f = f.chain;
  }
};