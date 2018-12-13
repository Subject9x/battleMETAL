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

  if(other == self.owner){
    return;
  }
  
  if(other.takedamage){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if( other.sh_cur > 0 ){
      remove(self);
      return;
    }
  }
  te_mis_expl( self.origin );
  BecomeExplosion();
};

void() data_prj_mis_th={
  local vector smk1;
  
  makevectors( self.angles );
  
  smk1 = self.origin + (v_forward * -2.5);
  
  //te_mis_trail(self.origin, self.c_ofs, 1);
  te_mis_flame( smk1, 1) ;
  
  self.think = data_prj_mis_th;
  self.nextthink = time + 0.05;
  if( time > self.power_timer ){
    self.think = BecomeExplosion;
    self.nextthink = time + 0.05;
  }
};

void() data_prj_mis_ini={
  self.classname = "prj_rck";
  self.touch = data_prj_mis_touch;
  self.data_idx = ID_PRJ_MIS;
  self.p_velocity = DAT_PRJ_MIS_VELOCITY;
  self.c_model = DAT_PRJ_MIS_MODEL;
  self.p_lifetime = DAT_PRJ_MIS_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | EF_NOSHADOW;
  self.modelflags = 0;//DAT_PRJ_MIS_MODELFLAGS;
  self.alpha = DAT_PRJ_MIS_ALPHA;
  self.colormod = DAT_PRJ_MIS_COLORMOD;
  self.glow_color = DAT_PRJ_MIS_GLOWCOLOR;
  self.glow_size = DAT_PRJ_MIS_GLOWSIZE;
  self.glow_trail = DAT_PRJ_MIS_GLOWTRAIL;
  self.traileffectnum = particleeffectnum("TE_MIS_TRAIL");  //DEBUG
  
  //self.think = data_prj_mis_th;
  //self.nextthink = time + (random() * 0.01);
};

