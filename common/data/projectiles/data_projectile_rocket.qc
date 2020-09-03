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
float DAT_ROCKET_PROXY_RAD = 25;
void() data_prj_mis_touch;
void() data_projectile_rocket_think_;
#endif CSQC

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
  
  #ifndef CSQC
    self.touch = data_prj_mis_touch;
    self.think = data_projectile_rocket_think_;  
    self.effects = self.effects | EF_LOWPRECISION;
  #endif
};

#ifndef CSQC
void(entity theOther ) data_prj_mis_hit={  
  local float debris, debrisType;
  local float damage; 
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.velocity = '0 0 0';
  
  self.impactType = IMPACT_DIRT;
  //debris = rint(3 + random() * 5);
	if ( pointcontents(self.origin) == CONTENT_SKY){
    self.impactType = IMPACT_SKY;
	}
 
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
      t_damage(theOther, self, self.owner, damage, self.origin, '0 0 0');
      self.impactType = IMPACT_ARMOR;
      //debris = rint(4 + random() * 6);
      //te_debris_armor( self.origin, vectoangles(self.velocity), self.velocity, debris, 1 );
    }
    debris = 0;
  }
  if( debris > 0 ){
   // te_debris( self.origin, vectoangles(self.velocity), self.velocity, debris, debrisType );
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT;
  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};

void() data_prj_mis_touch={
  data_prj_mis_hit( other );
};

void() data_projectile_rocket_think_={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.think = data_projectile_rocket_think_;
  self.nextthink = time + 0.025;
  self.angles = vectoangles(self.velocity);
  if( time > self.data_lifetime ){
    self.think = ctrl_missile_dud;
    self.nextthink = time + 0.01;
    return;
  }
  if( (self.owner.flags & FL_CLIENT) ){
    local entity close;
    local float hit;
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
#endif CSQC