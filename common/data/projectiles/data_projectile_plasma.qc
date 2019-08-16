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
  self.movetype = MOVETYPE_FOLLOW;
  self.solid = SOLID_NOT;
  self.velocity = '0 0 0';
  self.avelocity = '0 0 0';
  self.aiment = self.cockpit;
  self.punchangle = self.cockpit.angles;
  self.view_ofs = self.origin - self.cockpit.origin;
  self.angles = self.cockpit.angles;
  self.v_angle = self.angles - self.cockpit.angles;
  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + 0.01;
  self.data_lifetime = time + data_projectile_plasma_burn_time;
  self.alpha = 0.67;
};

void() data_projectile_plasma_burn_th={
  if( (self.enemy.deadflag > DEAD_NO) || (self.cockpit.deadflag > DEAD_NO) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
    return;
  }
  t_damage(self.cockpit, self, self.owner, 2.5, self.damageType, self.cockpit.origin, '0 0 0');

  pointparticles( particleeffectnum("TE_RPC_BURN"), self.origin, '0 0 0', 1);
  
  if(time > self.data_lifetime){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    return;
  }

  self.think = data_projectile_plasma_burn_th;
  self.nextthink = time + 0.1;
  
};

void() data_projectile_plasma_touch={
  local entity hit;
  local entity this;
  
  this = self;
  
  if (pointcontents(self.origin) == CONTENT_SKY){
    //remove(self);
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
    return;
  }

  pointparticles( particleeffectnum("TE_RPC_HIT"), this.origin, '0 0 0', 1);
  if(other.takedamage){
    hit = t_damage(other, this, this.owner, this.damageValue, this.damageType, this.origin, '0 0 0');
    if(other.shield <= 0){
      newmis = spawn();
      newmis.enemy = other;
      newmis.cockpit = hit;
      newmis.damageValue = self.damageValue;
      newmis.damageType = self.damageType | EFF_PRC;
      newmis.owner = self.owner;
      setsize(newmis, '-1 -1 -1', '1 1 1');
      if( (other.data_type == DATA_MECH) ){
        setorigin(newmis, newmis.cockpit.origin);
      }
      else{
        setorigin(newmis, self.origin);
      }
      newmis.think = data_projectile_plasma_burn_ini_;
      newmis.nextthink = time + 0.01; 
    }
	}
  //remove(self);
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};

void() data_projectile_plasma_think_={
  self.think = data_projectile_plasma_think_;
  self.nextthink = time + 0.05;
  if( time > self.data_lifetime ){
    self.think = BecomeExplosion;
    self.nextthink = time + 0.05;
  }
};

