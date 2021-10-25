/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rocket Launcher projectile 
    Explodes on touch
*/

#ifdef SSQC
float DAT_ROCKET_PROXY_RAD = 25;
void() data_prj_mis_touch;
void() data_projectile_rocket_think_;
#endif

#ifdef CSQC
void() projectile_rocket_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    hitColor = '0 1.25 0.67';
    hitBloom = -0.01;
    hitScale = 0.5;
  }
  else{
    hitColor = '0.99 0.6 0.18';
    hitBloom = 0.01;
    hitScale = 1;
    pointsound(self.origin, "sound/fx_boom.ogg",  0.8, ATTN_NORM);
  }
  if(self.impactType == IMPACT_DIRT){
    self.angles = vectoangles(self.velocity);
    makevectors(self.angles);
    traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
    pointparticles(PTC_HIT_DIRT_EXP_MED, trace_endpos, trace_plane_normal * -1, 1);
  }
  te_missile_explode( self.origin, hitScale, hitColor, hitBloom ); 
};
#endif

void() data_projectile_ini_rocket_={
  self.classname = "missile";
  self.data_velocity = 1973;  //1500
  self.data_lifetime = 0.38;  //0.5
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_mis.md3";
    self.effects = EF_NOSHADOW;
    self.traileffectnum = particleeffectnum("TE_MIS_TRAIL");
    self.pcl_explode = projectile_rocket_expl;
  #endif
  
  #ifdef SSQC
    self.touch = data_prj_mis_touch;
    self.think = data_projectile_rocket_think_;  
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};

#ifdef SSQC
void(entity theOther ) data_prj_mis_hit={  
  local float debris, debrisType;
  local float damage; 
  local entity hitLocation;
  
  self.touch = SUB_Null;
  self.impactType = IMPACT_SKY;
  self.velocity = '0 0 0';
  
  if(theOther.takedamage){
    damage = self.damageValue;
    if( theOther.shield > 0 ){
      if( theOther.shield > (theOther.shieldMax * 0.5) ){
        damage = damage * 0.33;
      }
      else{
        damage = damage * 0.67;
      }
      t_damage_shield(trace_ent, self, FIRE_ENT, damage, FIRE_ENDPOINT, FALSE );
      self.impactType = IMPACT_SHIELD;
    }
    else{
      damage = damage + (damage * 0.25);
      hitLocation = t_damage(theOther, self, self.owner, damage, self.origin, '0 0 0');
      if( hitLocation.partTypeId && !(self.owner.statTargetHitParts & hitLocation.partTypeId) ){
        self.owner.statTargetHitParts = self.owner.statTargetHitParts | hitLocation.partTypeId;
      }
      self.impactType = IMPACT_ARMOR;
      debris = rint(1 + random() * 3);
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, debris, 1 );
    }
    self.targetEntId = num_for_edict(other);
    debris = 0;
  }
  else{
    makevectors(self.angles);
    traceline(self.origin + (v_forward * -4), self.origin + (v_forward * 4), MOVE_WORLDONLY, self);
    if( (trace_dpstartcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_SOLID) ){
      self.impactType = IMPACT_DIRT;
      debris = rint(1 + random() * 3);
    }
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, debris, debrisType );
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.01;
};

void() data_prj_mis_touch={
  data_prj_mis_hit( other );
};

void() data_projectile_rocket_think_={
  local entity close;
  local float hit;
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  
  self.think = data_projectile_rocket_think_;
  self.nextthink = time + 0.025;
  self.angles = vectoangles(self.velocity);
  if( time > self.data_lifetime ){
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.01;
    return;
  }
  if( (self.owner.flags & FL_CLIENT) ){
    hit = FALSE;
    for( close = findradius(self.origin, DAT_ROCKET_PROXY_RAD); close != world; close = close.chain ){
      if( hit ){
        continue;
      }
      if( close.deadflag != DEAD_NO ){
        continue;
      }
      if( !(close.flags & FL_UNIT) || !(close.flags&FL_MONSTER) ){
        continue;
      }
      if( close.faction == self.owner.faction ){
        continue;
      }
      traceline(self.origin, close.origin, FALSE, self.owner );
      if( trace_fraction == 1 ){
        hit = TRUE;
        self.origin = trace_endpos;
        self.velocity = '0 0 0';
      }
    }
    if( hit == TRUE ){
      self.movetype = MOVETYPE_NONE;
      self.touch = SUB_Null;
      data_prj_mis_hit( close );
    }
  }
};
#endif