/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Projectile
    Snub Artillery Shell
      AoE radius.
      
*/
float DAT_PRJ_SFGA_RAD        = 300;
void() data_projectile_snub_artillery_radiusDamage;
void() data_projectile_snub_artillery_touch_;

void() data_projectile_ini_snub_artillery_={
  self.classname = "missile";
  self.p_velocity = 1000;
  self.model = "q3mdl/proj/mdl_proj_sfga.md3";
  self.p_lifetime = 8;
  
  //cosmetics
  self.effects = (EF_NOSHADOW);
  self.modelflags = 0;
  self.alpha = 1;
  self.color =  '0.85 0.45 0.45';
  self.traileffectnum = particleeffectnum("TE_SFGA_TRAIL");
  self.think = SUB_Null;
  self.touch = data_projectile_snub_artillery_touch_;
};

void() data_projectile_snub_artillery_touch_={
  
  if( pointcontents(self.origin) == CONTENT_SKY ){
    remove(self);
    return;
  }
  
  makevectors(self.angles);
  if( other.takedamage ){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if( other.sh_cur > 0){
      pointparticles( particleeffectnum("TE_SFGA_IMPACT_SHIELD"), self.origin, self.velocity, 1);
    }else{
      te_missile_explode(  self.origin + (v_up * -5), 1, '0.99 0.6 0.18', self.p_damage / 7, 1);
    }
    remove(self);
    return;
  }
  te_missile_explode(  self.origin + (v_up * -5), 1, '0.99 0.8 0.5', self.p_damage / 7, ceil( random() * 3) );
  data_projectile_snub_artillery_radiusDamage();
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  remove(self);
  return;
};

void() data_projectile_snub_artillery_radiusDamage={
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