/*
mech Mod
Author: Peter Roohr
Date: 05/17/2017
Overview: data def file for a weapon projectile
*/

//SNUB FIELD GUN ARTILLERY ROUND==================


void() data_prj_sfga_touch;
void() data_prj_sfga_raddmg;

void() data_prj_sfga_ini={
  self.classname = "missile";
  self.touch = data_prj_sfga_touch;
  self.data_idx = ID_PRJ_SFGA;
  self.p_velocity = DAT_PRJ_SFGA_VELOCITY;
  self.c_model = DAT_PRJ_SFGA_MODEL;
  self.p_lifetime = DAT_PRJ_SFGA_LIFETIME;
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
  
  if(other.classname == "missile"){
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