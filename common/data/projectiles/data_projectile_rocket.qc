/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rocket Launcher projectile 
    Explodes on touch
*/

void() data_prj_mis_touch;
void() data_projectile_rocket_think_;
void() data_projectile_rocket_dud;
void() data_projectile_rocket_dud_touch;

void() data_projectile_ini_rocket_={
  self.classname = "missile";
  self.touch = data_prj_mis_touch;
  self.data_velocity = 1300;
  self.model = "q3mdl/proj/mdl_proj_mis.md3";
  self.data_lifetime = 0.56;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = 0;
  self.traileffectnum = particleeffectnum("TE_MIS_TRAIL");
  self.think = data_projectile_rocket_think_;
};

void() data_prj_mis_touch={
	if ( pointcontents(self.origin) == CONTENT_SKY){
    self.touch = SUB_Null;
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
		return;
	}

  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      self.touch = SUB_Null;
      remove(self);
      return;
    }
  }
  makevectors(self.angles);
  te_missile_explode(  self.origin + (v_up * -5), 1, '0.99 0.6 0.18', self.damageValue / 5, 1);
  
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};

void() data_projectile_rocket_think_={
  self.think = data_projectile_rocket_think_;
  self.nextthink = time + 0.05;
  if( time > self.data_lifetime ){
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.01;
  }
};
