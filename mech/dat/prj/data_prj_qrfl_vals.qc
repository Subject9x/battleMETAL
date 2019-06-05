/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for the Rotary Plasma Cannon
this guy will bounce off up to two non-targets.
*/

//LIGHT AUTOCANNON SHOT==================
float DAT_PRJ_QRFL_IDX = ID_PRJ_QRFL;

void() data_prj_qrfl_touch;

void() data_prj_qrfl_ini={
  self.classname = "prj_qrfl";
  self.touch = data_prj_qrfl_touch;
  self.data_idx = DAT_PRJ_QRFL_IDX;
  self.p_velocity = DAT_PRJ_QRFL_VELOCITY;
  self.c_model = DAT_PRJ_QRFL_MODEL;
  self.p_lifetime = DAT_PRJ_QRFL_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_QRFL_EFFECTS;
  self.modelflags = DAT_PRJ_QRFL_MODELFLAGS;
  self.traileffectnum = particleeffectnum("TE_QRFL_QBIT_TRAIL");
};

void() data_prj_qrfl_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.takedamage){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if( other.shield > 0 ){
      pointparticles( particleeffectnum("TE_QRFL_IMPACT_SHIELD"), self.origin, self.velocity, 1);
    }
    remove(self);
    return;
  }  
  
  pointparticles( particleeffectnum("TE_QRFL_QBIT_IMPACT"), self.origin, self.velocity, 1);
  remove(self);
};