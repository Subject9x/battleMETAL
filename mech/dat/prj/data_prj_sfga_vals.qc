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
  self.classname = "prj_sfga";
  self.touch = data_prj_sfga_touch;
  self.data_idx = ID_PRJ_SFGA;
  self.p_velocity = DAT_PRJ_SFGA_VELOCITY;
  self.c_model = DAT_PRJ_SFGA_MODEL;
  self.p_lifetime = DAT_PRJ_SFGA_LIFETIME;
  self.w_range = DAT_PRJ_SFGA_RAD;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_SFGA_EFFECTS;
  self.traileffectnum = particleeffectnum("TE_SFGA_TRAIL");
};

void() data_prj_sfga_touch={
  
  if( pointcontents(self.origin) == CONTENT_SKY ){
    remove(self);
    return;
  }
  
  makevectors(self.angles);
  if( other.takedamage ){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if( other.shield > 0){
      pointparticles( particleeffectnum("TE_SFGA_IMPACT_SHIELD"), self.origin, self.velocity, 1);
    }else{
      te_missile_explode(  self.origin + (v_up * -5), 1, '0.99 0.6 0.18', self.p_damage / 7, 1);
    }
    remove(self);
    return;
  }
  te_missile_explode(  self.origin + (v_up * -5), 1, '0.99 0.8 0.5', self.p_damage / 7, ceil( random() * 3) );
  data_prj_sfga_raddmg();
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  remove(self);
  return;
};

void() data_prj_sfga_raddmg={
  local entity radiusTarg;
  local float d, dmg_act;
        
  radiusTarg = findradius(self.origin, self.w_range);
  while(radiusTarg){
    if( (radiusTarg.flags & FL_UNIT) ){
      if( CanDamage( radiusTarg, self )){
        d = vlen(radiusTarg.origin - self.origin);
        d = d / self.w_range;
        dmg_act = self.p_damage - (self.p_damage * d);
        t_damage(radiusTarg, self, self.owner, dmg_act, self.p_dmgtype, trace_endpos, '0 0 0');
      } 
    }
    radiusTarg = radiusTarg.chain;
  }
};