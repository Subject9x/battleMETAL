/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Missile - Active Radar
    Explodes on touch
    needs player lock-on to follow target.
*/

#ifdef SSQC
float PROJ_MARH_TURN_FADE = 0.02; //turn speed decay rate.
void() data_projectile_missile_activeradar_think;
void() data_projectile_missile_activeradar_delay;
void() data_projectile_missile_activeradar_touch;
#endif

#ifdef CSQC
void() projectile_marh_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  local entity cluster;
  local entity rem;
  
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    hitColor = '0 0.2 0.67';
    hitBloom = -0.01;
    hitScale = 0.33;
  }
  else{
    hitColor = '0.969 0.996 0.18';
    hitBloom = 0.01;
    hitScale = 0.66;
    pointsound(self.origin, "sound/fx_boom.ogg",  0.8, ATTN_NORM);
  }
  if(self.impactType == IMPACT_DIRT){
    self.angles = vectoangles(self.velocity);
    makevectors(self.angles);
    traceline(self.origin - (v_forward * 2), self.origin, MOVE_WORLDONLY, self);
    pointparticles(PTC_HIT_DIRT_EXP_SML, trace_endpos, trace_plane_normal * -1, 1);
  }
  te_missile_explode( self.origin, hitScale, hitColor, hitBloom ); 
  
  cluster = self.w_slot;
  while( cluster.owner == self ){
    cluster.traileffectnum = 0;
    te_missile_explode( cluster.origin, hitScale, hitColor, hitBloom );
    rem = cluster;
    remove(rem);
    cluster = rem.w_slot;
  }
};

/*
  clusters of missiles are actually CSQC ents, and the SSQC handles shotgun-style damage pattern.
*/
void() projectile_marh_multi={
  local entity newMis;
  local entity chainPtr;
  local float misTotal;
  
  misTotal = 5;
  chainPtr = self;
  while( misTotal > 0 ){
    newMis = spawn();
    newMis.model = self.model;
    setmodel(newMis, newMis.model);
    newMis.compOffset = '0 0 0';
    newMis.compOffset_x = crandom() * 10;
    newMis.compOffset_y = crandom() * 10;
    newMis.compOffset_z = crandom() * 5;
    newMis.angles = self.angles;
    newMis.traileffectnum = self.traileffectnum;
    chainPtr.w_slot = newMis;
    newMis.owner = self;
    chainPtr = newMis;
    misTotal = misTotal - 1;
  }
};
#endif

void() data_projectile_ini_missile_active_radar_={
  self.classname = "missile";
  self.data_velocity = 1800;
  self.data_lifetime = 1.75;
  self.compOffset = '0 0 0';
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_marh.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_ARH_TRAIL");
    self.pcl_explode = projectile_marh_expl;
    self.scale = 1.25;
    self.predraw_projectile = predraw_marh;
    self.effects = self.effects | EF_FULLBRIGHT;
    projectile_marh_multi();
  #endif
  
  #ifdef SSQC
    self.think = data_projectile_missile_activeradar_delay;
    self.effects = self.effects | EF_FULLBRIGHT;
    self.ai_dir = 1.0;
  #endif
};
#ifdef SSQC
void() data_projectile_missile_activeradar_think={
	local vector	dir, vtemp;
  local float lock;
  
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  
  if( !self.touch ){
    self.touch = data_projectile_missile_activeradar_touch;
  }
  
	if (self.enemy.health < 1){
    self.solid = SOLID_NOT;
    self.touch = SUB_Null;
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
    return;
  }
  if(self.enemy == world){
    self.solid = SOLID_NOT;
    self.touch = SUB_Null;
    self.think = BecomeExplosion;
    self.nextthink = time + 1 + random();
    return;
  }
  
  self.isActive =  self.owner.enemy.stat_rdr_mode;
  if( (self.enemy.flags & FL_CLIENT) ){
    if( self.stat_rdr_mode == TRUE && self.owner.enemy.stat_rdr_mode == FALSE ){
      //target has switched to passive radar
      lock = 1;
    }
    else if(self.stat_rdr_mode == TRUE && self.owner.enemy.stat_rdr_mode == TRUE) {
      lock = 2;
    }
  }else{
    lock = 2;
  }
  self.stat_rdr_mode = self.owner.enemy.stat_rdr_mode;
  if( lock == 2 ){
    vtemp = self.enemy.origin + '0 0 10';
    vtemp = randompos( vtemp + self.enemy.mins, vtemp + self.enemy.maxs );
    self.last_origin = self.enemy.origin;
  }
  else{
    vtemp = self.last_origin;
  }
  
  dir = normalize(vtemp - self.origin);
  
  if( time > self.data_lifetime * 0.67){
    if(self.ai_dir > 0.1){
      self.ai_dir = self.ai_dir - PROJ_MARH_TURN_FADE;
    }
    else{
      self.ai_dir = 0.1;
    }
  }
  dir = dir * self.ai_dir;
  self.velocity = dir * self.data_velocity;

  self.think = data_projectile_missile_activeradar_think;
  if(time > self.data_lifetime){
    self.think = BecomeExplosion;
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_VELOCITY;
  self.nextthink = time + 0.1;
};

void() data_projectile_missile_activeradar_delay={
  if( self.last_origin != self.origin ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
    self.last_origin = self.origin;
  }
  if( time > self.w_isburst ){
    self.data_velocity = 1500;
    self.data_lifetime = time + 1.56;
    self.think = data_projectile_missile_activeradar_think;
    self.nextthink = time + 0.01;
    return;
  }
  self.think = data_projectile_missile_activeradar_delay;
  self.nextthink = time + 0.025;
};

float DAT_MARH_SHRAP_TOTAL = 5;

void() data_projectile_missile_activeradar_touch={
  local float debris;
  local float damage;
  
  local float totes;
  local float startOfs;
  local float rollDice;
  local float part;
  local entity hit;
  
  if( other == self.owner ){
    return;
  }
  
  self.touch = SUB_Null;
  self.impactType = IMPACT_SKY;
 
  if(other.takedamage){
    damage = self.damageValue;
    if(other.vec_size > 2){
      damage = damage * 0.5;
    }
    if( other.shield > 0 ){
      if( other.shield >= (other.shieldMax * 0.67) ){
        damage = damage * 0.67;
      }
      else{
        damage = damage * 0.25;
      }
      t_damage_shield(other, self, FIRE_ENT, damage, FIRE_ENDPOINT, FALSE);
      self.impactType = IMPACT_SHIELD;
    }
    else{
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, 6, 1 );
      self.impactType = IMPACT_ARMOR;
      if( other.data_type == DATA_MECH ){
        totes = DAT_MARH_SHRAP_TOTAL;
        startOfs = 2;
        while(totes > 0){
          rollDice = floor(startOfs + (random() * 5));
          if(rollDice > 5){
            rollDice = 5;
          }
          part = bitshift(2, rollDice);
          hit = util_getPartFromName(part, other);
          hit = t_damage(trace_ent, self, self.owner, self.damageValue / DAT_MARH_SHRAP_TOTAL, hit.origin, '0 0 0');
          if( hit.partTypeId && !(self.owner.statTargetHitParts & hit.partTypeId) ){
            self.owner.statTargetHitParts = self.owner.statTargetHitParts | hit.partTypeId;
          }
          totes = totes - 1;
        }
      }
      else{
        t_damage(other, self, self.owner, self.damageValue, self.origin, '0 0 0');
      }
    }
    self.targetEntId = num_for_edict(other);
    debris = 0;
  }
  else{
    makevectors(self.angles);
    traceline(self.origin + (v_forward * -4), self.origin + (v_forward * 4), MOVE_WORLDONLY, self);
    if( (trace_dpstartcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_SOLID) ){
      self.impactType = IMPACT_DIRT;
      debris = ceil( 1 + random() * 3);
    }
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, rint(random() * 3), 1 );
  }
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.think = ctrl_missile_lastframe;
  self.nextthink = time + 0.01;
};
#endif
