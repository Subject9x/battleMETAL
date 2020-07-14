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

#ifndef CSQC
void() data_projectile_missile_activeradar_think;
void() data_projectile_missile_activeradar_delay;
void() data_projectile_missile_activeradar_touch;
#endif CSQC

#ifdef CSQC
void() projectile_marh_expl={
  local vector hitColor;
  local float hitBloom;
  local float hitScale;
  
  if( self.impactType == IMPACT_SKY ){
    return;
  }
  if( self.impactType == IMPACT_SHIELD ){
    hitColor = '0 0.2 0.67';
    hitBloom = -0.01;
    hitScale = 0.5;
    pointsound( self.origin, "sound/fx_shieldhit.ogg", 0.6, ATTN_NORM );
  }
  else{
    hitColor = '0.969 0.996 0.18';
    hitBloom = 0.01;
    hitScale = 1;
    pointsound(self.origin, "sound/fx_boom.ogg",  0.8, ATTN_NORM);
  }
  te_missile_explode( self.origin, hitScale, hitColor, hitBloom ); 
};
#endif

void() data_projectile_ini_missile_active_radar_={
  self.classname = "missile";
  self.data_velocity = 1800;  //1200
  self.data_lifetime = 1.75;   //3
  self.compOffset = '0 0 0';   
  
  #ifdef CSQC
    //cosmetics
    self.model = "q3mdl/proj/mdl_proj_marh.md3";
    self.effects = EF_NOSHADOW;
    self.modelflags = 0;
    self.traileffectnum = particleeffectnum("TE_ARH_TRAIL");
    self.pcl_explode = projectile_marh_expl;
    self.scale = 1.25;
  #endif
  
  #ifndef CSQC
    self.think = data_projectile_missile_activeradar_delay;  
  #endif
};
#ifndef CSQC
void() data_projectile_missile_activeradar_think={
	local vector	dir, vtemp;
  local float prevTargRadar;
  local float lock;
  
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
  
  lock = TRUE;
  //enemy players switching to passive radar dumps the lock-on
  if( (self.enemy.flags & FL_CLIENT) ){
    if((self.stat_rdr_mode == TRUE) && (self.enemy.stat_rdr_mode == FALSE) ){
      lock = FALSE;
    }
    self.stat_rdr_mode = self.enemy.stat_rdr_mode;  //cache previous enemy radar mode.
  }
  if( lock ){
    vtemp = self.enemy.origin + '0 0 10';
    vtemp = randompos( vtemp + self.enemy.mins, vtemp + self.enemy.maxs );
    dir = normalize(vtemp - self.origin);
    self.dest = vtemp;
  }
  else{
    dir = normalize( self.dest - self.origin);
  }
  self.velocity = dir * self.data_velocity;

  self.think = data_projectile_missile_activeradar_think;
  if(time > self.data_lifetime){
    self.think = BecomeExplosion;
  }
  
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_VELOCITY);
  self.nextthink = time + 0.05;
};

void() data_projectile_missile_activeradar_delay={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
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
  
  local vector shotpoint;
  local vector shrapPoint;
  local vector shotDir;
  local vector shrapDir;
  local float totes;
  
  if( other == self.owner ){
    return;
  }
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_IMPACT);
  debris = 0;
	if (pointcontents(self.origin) == CONTENT_SKY){
    self.impactType = IMPACT_SKY;
    debris = 0;
	}
 
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
      if( other.data_type == DATA_MECH ){
        makevectors(self.angles);
        totes = DAT_MARH_SHRAP_TOTAL;
        shotpoint = self.origin + (v_forward * -48);
        shotDir = normalize(self.origin - shotpoint);
        while(totes > 0){
          shrapDir = shotDir + (crandom()*0.4*v_right) + (crandom()*0.4*v_up);
          shrapPoint = shotpoint + (shrapDir*128);
          traceline( shotpoint, shrapPoint, FALSE, self.owner);
          t_damage(trace_ent, self, self.owner, self.damageValue /DAT_MARH_SHRAP_TOTAL, trace_endpos, '0 0 0');
          totes = totes - 1;
        }
      }
      else{
        t_damage(other, self, self.owner, self.damageValue, self.origin, '0 0 0');
      }
    
      te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, 6, 1 );
      self.impactType = IMPACT_ARMOR;
    }
    debris = 0;
  }
  if( debris > 0 ){
    te_debris( self.origin, vectoangles(self.velocity), self.velocity, rint(random() * 3), 1 );
  }
  self.velocity = '0 0 0';
  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};
#endif CSQC
