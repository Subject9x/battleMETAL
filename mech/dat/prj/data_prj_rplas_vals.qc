/*
battleMETAL
Author: Peter Roohr
Date: 12/11/2018
Overview: 
  Projectile: Rotary Plasma Shot
  Hits target
  if target has no shields, it 'burns over time' on target
*/

//ROTARY PLASMA SHOT==================
void() data_prj_rplas_burn_th={
  local entity e;
  
  if( (self.enemy.deadflag > DEAD_NO) || (self.e_cam.deadflag > DEAD_NO) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
    return;
  }
  t_damage(self.e_cam, self, self.owner, DAT_RPLAS_DMG_BURN, self.p_dmgtype, self.e_cam.origin, '0 0 0');

  pointparticles( particleeffectnum("TE_RPC_BURN"), self.origin, '0 0 0', 1);
  
  if(time > self.p_lifetime){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    return;
  }
  else{
    self.think = data_prj_rplas_burn_th;
    self.nextthink = time + 0.1;
  }
};

/*
  pieced this out its own ini
*/
void() data_prj_rplas_burn_ini={
  self.movetype = MOVETYPE_FOLLOW;
  self.solid = SOLID_NOT;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  self.aiment = self.e_cam;
  self.punchangle = self.e_cam.angles;
  self.view_ofs = self.origin - self.e_cam.origin;
  self.angles = self.e_cam.angles;
  self.v_angle = self.angles - self.e_cam.angles;
  self.think = data_prj_rplas_burn_th;
  self.nextthink = time + 0.01;
  self.p_lifetime = time + self.p_lifetime;
  self.alpha = 0;
};

void() data_prj_rplas_touch={
  local entity hit;
  local entity this;
  
  this = self;
  
  if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}

  pointparticles( particleeffectnum("TE_RPC_HIT"), this.origin, '0 0 0', 1);
  if(other.takedamage){
    hit = t_damage(other, this, this.owner, this.p_damage, this.p_dmgtype, this.origin, '0 0 0');
    if(other.sh_cur <= 0){
      newmis = spawn();
      newmis.enemy = other;
      newmis.e_cam = hit;
      newmis.p_lifetime = self.p_lifetime;
      newmis.p_damage = self.p_damage;
      newmis.p_dmgtype = self.p_dmgtype;
      newmis.owner = self.owner;
      setmodel(newmis, "q3mdl/testball.md3");
      setsize(newmis, '-1 -1 -1', '1 1 1');
      if( (other.data_type == DATA_MECH) ){
        setorigin(newmis, newmis.e_cam.origin);
      }
      else{
        setorigin(newmis, self.origin);
      }
      newmis.effects = EF_NODRAW;
      newmis.think = data_prj_rplas_burn_ini;
      newmis.nextthink = time + 0.01; 
    }
	}
  remove(self);
};

void() data_prj_rplas_ini={
  self.touch = data_prj_rplas_touch;
  self.data_idx = ID_PRJ_RPLAS;
  self.p_velocity = DAT_PRJ_RPLAS_VELOCITY;
  self.c_model = DAT_PRJ_RPLAS_MODEL;
  self.p_lifetime = DAT_PRJ_RPLAS_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_RPLAS_EFFECTS;
  //self.modelflags = self.modelflags | DAT_PRJ_RPLAS_MODELFLAGS;
  self.modelflags = 0;
  self.alpha = DAT_PRJ_RPLAS_ALPHA;
  self.colormod = DAT_PRJ_RPLAS_COLORMOD;
  self.glow_color = DAT_PRJ_RPLAS_GLOWCOLOR;
  self.glow_size = DAT_PRJ_RPLAS_GLOWSIZE;
  self.glow_trail = DAT_PRJ_RPLAS_GLOWTRAIL;
  self.traileffectnum = particleeffectnum("TE_RPC_TRAIL");  //DEBUG
};
