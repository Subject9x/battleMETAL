/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//Rocket Launcher rocket=======================
void() data_prj_mis_touch={
	if ( pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}

  if(other.takedamage){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if( other.sh_cur > 0 ){
      remove(self);
      return;
    }
  }
  makevectors(self.angles);
  te_missile_explode(  self.origin + (v_up * -5), 1, '0.99 0.6 0.18', self.p_damage / 5, 1);
  remove(self);
};

void() data_prj_mis_th={
  self.think = data_prj_mis_th;
  self.nextthink = time + 0.05;
  if( time > self.p_lifetime ){
    self.think = BecomeExplosion;
    self.nextthink = time + 0.05;
  }
};

void() data_prj_mis_ini={
  self.classname = "missile";
  self.touch = data_prj_mis_touch;
  self.data_idx = ID_PRJ_MIS;
  self.p_velocity = DAT_PRJ_MIS_VELOCITY;
  self.c_model = DAT_PRJ_MIS_MODEL;
  self.p_lifetime = DAT_PRJ_MIS_LIFETIME;
  
  //cosmetics
  self.effects = EF_NOSHADOW;
  self.modelflags = DAT_PRJ_MIS_MODELFLAGS;
  self.traileffectnum = particleeffectnum("TE_MIS_TRAIL");
};

