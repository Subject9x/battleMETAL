/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rotary Plasma projectile 
    burns-over-time on unshielded targets.
*/

#ifdef SSQC
float data_projectile_plasma_burn_time = 0.5;
float data_projectile_plasma_burn_dmg = 0.1;

void() data_projectile_plasma_touch;
void() data_projectile_plasma_burn_ini_;
void() data_projectile_plasma_burn_th;
void() data_projectile_plasma_think_;
#endif

#ifdef CSQC
void() projectile_plasma_expl={
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  
  if( self.impactType == IMPACT_ARMOR ){
    pointparticles( particleeffectnum("TE_RPC_BURN"), self.origin, '0 0 0', 1);
  }
  else if( self.impactType == IMPACT_SHIELD ){
    pointparticles( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
  }
  else if( self.impactType == IMPACT_DIRT ){
    self.angles = vectoangles(self.velocity);
    makevectors(self.angles);
    traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
    pointparticles( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
    pointparticles( particleeffectnum("TE_RPC_HIT_DIRT"), trace_endpos, trace_plane_normal * -1, 1);
  
  }
};
#endif

void() data_projectile_ini_plasma_={
  self.classname = "missile";
  self.data_velocity = 1600;  //vel = Range / lifetime
  self.data_lifetime = 1.12;
  
  #ifdef CSQC
    //cosmetics
    self.alpha = 0.85;
    self.model = "q3mdl/proj/mdl_proj_rpc.md3";
    self.effects = EF_NOSHADOW | EF_ADDITIVE;
    self.traileffectnum = particleeffectnum("TE_RPC_TRAIL");
    self.predraw_projectile = predraw_plasma;
    self.pcl_explode = projectile_plasma_expl;
  #endif
  
  #ifdef SSQC
    self.touch = data_projectile_plasma_touch;
    self.think = data_projectile_plasma_think_;
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};
#ifdef SSQC
void() data_projectile_plasma_burn_ini_={
  self.movetype = MOVETYPE_FOLLOW;
  self.aiment = self.cockpit;
  self.punchangle = self.cockpit.angles;
  self.view_ofs = self.origin - self.cockpit.origin;
  self.angles = self.cockpit.angles;
  self.v_angle = self.angles - self.cockpit.angles;
  self.alpha = 0.75;
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_IMPACT);
  self.impactType = IMPACT_ARMOR;
  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + 0.01;
};

void() data_projectile_plasma_burn_th={
  
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  
  if( self.enemy.deadflag > DEAD_NO || self.cockpit.deadflag > DEAD_NO ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    return;
  }

  t_damage_shield(self.enemy, self, self.owner, self.damageValue, self.cockpit.origin, TRUE);
  
  if(time > self.data_lifetime){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    return;
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  self.targetEntId = 0;
  self.impactType = IMPACT_ARMOR;

  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + (random() * 0.1);
};

void() data_projectile_plasma_touch={
  local entity hit;
  local float damage;
  local float proc;
  
  self.touch = SUB_Null;
  self.impactType = IMPACT_SKY;
  self.solid = SOLID_NOT;
  
  if(other.takedamage){
    damage = self.damageValue;
    self.targetEntId = num_for_edict(other);
    if(other.shield > 0){
      proc = FALSE;
      if( other.shield <= (other.shieldMax * 0.1) ){
        proc = TRUE;
        damage = damage * 0.65;
      }
      else{
        damage = damage * 0.45;
      }
      t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, proc);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      hit = t_damage(other, self, self.owner, damage, self.origin, '0 0 0');
      self.enemy = other;
      self.cockpit = hit;
      self.damageValue = data_projectile_plasma_burn_dmg;
      self.data_lifetime = time + data_projectile_plasma_burn_time;
      setsize(self, '-1 -1 -1', '1 1 1');
      if( other != hit ){
        setorigin(self, self.origin);
      }
      self.velocity = '0 0 0';
      self.avelocity = '0 0 0';
      self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
      self.think = data_projectile_plasma_burn_ini_;
      self.nextthink = time + 0.05;
      self.impactType = IMPACT_ARMOR;
      if( hit.partTypeId && !(self.owner.statTargetHitParts & hit.partTypeId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | hit.partTypeId;
      } 
      return;
    }
	}
  else{
    makevectors(self.angles);
    traceline(self.origin + (v_forward * -4), self.origin + (v_forward * 4), MOVE_WORLDONLY, self);
    if( (trace_dpstartcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_SOLID) ){
      self.impactType = IMPACT_DIRT;
    }
  }
  
  self.movetype = MOVETYPE_NONE;
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
 
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.1;
};

void() data_projectile_plasma_think_={
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  if( time > self.data_lifetime ){
    client_send_particle( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
    self.touch = SUB_Null;
    self.think = ctrl_missile_lastframe;
    self.nextthink = time + 0.05;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
    return;
  }
  self.think = data_projectile_plasma_think_;
  self.nextthink = time + 0.01;
};
#endif