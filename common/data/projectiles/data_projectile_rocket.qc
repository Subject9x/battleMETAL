/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rocket Launcher projectile 
    Explodes on touch
*/

#ifndef CSQC
void() data_prj_mis_touch;
void() data_projectile_rocket_think_;

#endif CSQC
void() data_projectile_ini_rocket_={
  self.classname = "missile";
  self.data_velocity = 1300;
  self.data_lifetime = 0.56;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_mis.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_MIS_TRAIL");    
  #endif
  
  #ifndef CSQC
    self.touch = data_prj_mis_touch;
    self.think = data_projectile_rocket_think_;  
  #endif
};
#ifndef CSQC
void() data_prj_mis_touch={
  local float shieldHit;
  
	if ( pointcontents(self.origin) == CONTENT_SKY){
    remove(self);
		return;
	}

  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    if( other.shield > 0 ){
      shieldHit = TRUE;
    }
    else{
      shieldHit = FALSE;
    }
  }
  client_send_missile_explode( self.origin, 1, '0.99 0.6 0.18', min(self.damageValue / 7, 3), 2, shieldHit);
  remove(self);
};

void() data_projectile_rocket_think_={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.think = data_projectile_rocket_think_;
  self.nextthink = time + 0.05;
  if( time > self.data_lifetime ){
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.01;
  }
};
#endif CSQC