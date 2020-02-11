/*
battleMETAL
Author: Peter Roohr
Date: 05/29/2019
Overview: 
  Data File - Projectile
   Rotary Plasma projectile 
    burns-over-time on unshielded targets.
*/

float data_projectile_plasma_burn_time = 0.67;

void() data_projectile_plasma_touch;
void() data_projectile_plasma_burn_ini_;
void() data_projectile_plasma_burn_th;
void() data_projectile_plasma_think_;

void() data_projectile_ini_plasma_={
  self.classname = "missile";
  self.touch = data_projectile_plasma_touch;
  self.data_velocity = 1600;
  self.model = "q3mdl/proj/mdl_proj_rpc.md3";
  self.data_lifetime = 0.649;
  self.alpha = 0.85;
  
  //cosmetics
  self.effects = (EF_NOSHADOW | EF_ADDITIVE);
  self.modelflags = 0;
  self.traileffectnum = particleeffectnum("TE_RPC_TRAIL");
  self.think = data_projectile_plasma_think_;
};

void() data_projectile_plasma_burn_ini_={
  self.aiment = self.cockpit;
  self.punchangle = self.cockpit.angles;
  self.view_ofs = self.origin - self.cockpit.origin;
  self.angles = self.cockpit.angles;
  self.v_angle = self.angles - self.cockpit.angles;
  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + 0.01;
  self.data_lifetime = time + data_projectile_plasma_burn_time;
  self.alpha = 0.75;
};

void() data_projectile_plasma_burn_th={
  if( self.enemy.deadflag > DEAD_NO || self.cockpit.deadflag > DEAD_NO ){
    remove(self);
    return;
  }
  
  if( self.enemy.shield > 0 ){
    remove(self);
    return;
  }
  
  t_damage(self.enemy, self, self.owner, self.damageValue, self.damageType, self.cockpit.origin, '0 0 0');
  pointparticles( particleeffectnum("TE_RPC_BURN"), self.origin, '0 0 0', 1);
  
  if(time > self.data_lifetime){
    remove(self);
    return;
  }

  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + 0.1;
  
};

void() data_projectile_plasma_touch={
  local entity hit;
  
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  
  if (pointcontents(self.origin) == CONTENT_SKY){  
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
    return;
  }

  pointparticles( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
  if(other.takedamage){
    if(other.shield > 0){
      t_damage(other, self, self.owner, self.damageValue, self.damageType, self.origin, '0 0 0');
    }
    else{
      hit = t_damage(other, self, self.owner, 0.01, self.damageType, self.origin, '0 0 0');
      self.enemy = other;
      self.cockpit = hit;
      self.damageType = 0 | (DMG_BAL | EFF_RAM | EFF_PRC);
      self.damageValue = self.damageValue * 0.1;
      setsize(self, '-1 -1 -1', '1 1 1');
      if( other != hit ){
        setorigin(self, self.origin);
      }
      self.movetype = MOVETYPE_FOLLOW;
      self.velocity = '0 0 0';
      self.avelocity = '0 0 0';
      self.think = data_projectile_plasma_burn_ini_;
      self.nextthink = time + 0.01;
      return;
    }
	}
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};

void() data_projectile_plasma_think_={
  if( time > self.data_lifetime ){
    pointparticles( particleeffectnum("TE_RPC_HIT"), self.origin, '0 0 0', 1);
    self.touch = SUB_Null;
    self.think = SUB_Remove;
    self.nextthink = time + 0.05;
    return;
  }
  self.think = data_projectile_plasma_think_;
  self.nextthink = time + 0.05;
};

