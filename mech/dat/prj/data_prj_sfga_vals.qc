/*
mech Mod
Author: Peter Roohr
Date: 05/17/2017
Overview: data def file for a weapon projectile
*/

//SNUB FIELD GUN ARTILLERY ROUND==================


void() data_prj_sfga_touch;
void() data_prj_sfga_raddmg;

void() data_prj_sfga_th;

void() data_prj_sfga_ini={
  self.classname = "prj_sfga";
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
  //self.colormod = DAT_PRJ_SFGA_COLORMOD;
  self.traileffectnum = particleeffectnum("TE_SFGA_TRAIL");
};

void() data_prj_sfga_touch={
  
  if( pointcontents(self.origin) == CONTENT_SKY ){
    remove(self);
    return;
  }
  
  if( other.takedamage ){
    if( other.sh_cur > 0){
      pointparticles( particleeffectnum("TE_SFGA_IMPACT_SHIELD"), self.origin, self.velocity, 1);
      remove(self);
      return;
    }
  }
  
  data_prj_sfga_raddmg();
  self.think = BecomeExplosion;
  self.nextthink = time + 0.01;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  return;
};

//kinda dumb but for cosmetics
void() data_prj_sfga_th={
  local vector dir;
  
  dir = normalize( self.origin - self.c_ofs ) * self.p_velocity;
  self.angles = vectoangles(dir);
  
  self.think = data_prj_sfga_th;

  self.nextthink = time + 0.01;
  self.c_ofs = self.origin;
};

void() data_prj_sfga_raddmg={
  local entity f;
  f = findradius(self.origin, self.w_range);
  while(f){
    if(f != other){
      if(f.comp_id > 0){
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