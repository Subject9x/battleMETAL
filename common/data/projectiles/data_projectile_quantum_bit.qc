/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rocket Launcher projetile 
    Explodes on touch
*/

#ifdef SSQC
void() data_projectile_ini_quantum_bit_touch_;
void() data_projectile_quantum_bit_th;
#endif

#ifdef CSQC
void() projectile_qbit_expl={
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    pointparticles( particleeffectnum("TE_QRFL_IMPACT_SHIELD"), self.origin, normalize(self.origin - self.origin1) * 2, 1);
  }
  else if( self.impactType == IMPACT_ARMOR ){
    pointparticles( particleeffectnum("TE_QRFL_QBIT_IMPACT"), self.origin, normalize(self.origin - self.origin1) * 2, 1);
  }
  else{
    //dirt
    pointparticles( particleeffectnum("TE_QRFL_QBIT_IMPACT"), self.origin, '0 0 0', 1);
    self.angles = vectoangles(self.velocity);
    makevectors(self.angles);
    traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
    pointparticles(PTC_HIT_DIRT_ENE_LRG, trace_endpos, trace_plane_normal * -1, 1);
  }
};
#endif

void() data_projectile_ini_quantum_bit_={
  self.classname = "missile";
  self.data_velocity = 1800;
  self.data_lifetime = 1.5;
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_qrfl.md3";
    self.effects = self.effects | (EF_NOSHADOW | EF_DOUBLESIDED);
    self.traileffectnum = particleeffectnum("TE_QRFL_QBIT_TRAIL");
    self.damageType = self.damageType | EFF_SHD;
    self.pcl_explode = projectile_qbit_expl;
    self.scale = 1.15;
    self.predraw_projectile = predraw_quantum;
  #endif
  
  #ifdef SSQC
    self.touch = data_projectile_ini_quantum_bit_touch_;
    self.think = data_projectile_quantum_bit_th;
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};

#ifdef SSQC
void() data_projectile_quantum_bit_th={
  self.SendFlags = self.SendFlags | SENDFLAG_VELOCITY;
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  
  self.think = data_projectile_quantum_bit_th;
  self.nextthink = time + 0.025;
  
  if( time > self.data_lifetime ){
    self.velocity = '0 0 0';
    remove(self);
    return;
  }
}


/*
  Projectile will chain onto nearby targets with successful hits.
*/
void() data_projectile_quantum_shatter={
  local entity thing;
  local float itr;
  local entity hitLocation;
  
  self.damageValue = self.damageValue * 0.4;
  itr = 4;
  if( self.aState ){
    itr = rint( itr * 1.85);
  } 
  itr = 2 + rint(random() * itr);
  for(thing = findradius(self.enemy.origin, 250); thing != world; thing = thing.chain){
    if(itr == 0){
      continue;
    }
    if( thing == self.owner ){
      continue; //splash is dumb
    }
    if(thing == self.enemy){
      continue;
    }
    if( !thing.takedamage ){
      continue;
    }
    if( !(thing.flags & (FL_MONSTER)) && !(thing.flags & (FL_CLIENT)) ){
      continue;
    }
    itr = itr - 1;
    trailparticles(self.enemy, particleeffectnum("TE_QRFL_QBIT_TRAIL"), self.enemy.origin, thing.origin);
    if(thing.shield > 0){
      t_damage_shield(thing, self, self.owner, self.damageValue * 0.67, self.origin, FALSE);
    }
    else{
      hitLocation = t_damage(thing, self, self.owner, self.damageValue, self.origin, '0 0 0');
      if( hitLocation.partTypeId && !(self.owner.statTargetHitParts & hitLocation.partTypeId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | hitLocation.partTypeId;
      }  
    }
  }

  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};

void() data_projectile_ini_quantum_bit_touch_={
  local entity hitLocation;
  
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_IMPACT);
  self.impactType = IMPACT_DIRT;
	if (pointcontents(self.origin) == CONTENT_SKY || pointcontents(self.origin) == CONTENT_SOLID){
    self.impactType = IMPACT_SKY;
	}
  
  if(other.takedamage){
    if(other.shield > 0){
      t_damage_shield(other, self, self.owner, self.damageValue * 0.15 , self.origin, TRUE);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      self.aState = TRUE;
      hitLocation = t_damage(other, self, self.owner, self.damageValue, self.origin, '0 0 0');
      if( hitLocation.partTypeId && !(self.owner.statTargetHitParts & hitLocation.partTypeId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | hitLocation.partTypeId;
      }
      self.impactType = IMPACT_ARMOR;
    }
    self.targetEntId = num_for_edict(other);
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.movetype = MOVETYPE_NONE;
  
  if(self.aState == TRUE){
    self.enemy = other;
    self.think = data_projectile_quantum_shatter;
    self.nextthink = time + 0.01;
  }
  else{
    self.think = ctrl_missile_lastframe;
    self.nextthink = time + 0.01;
  }
};
#endif