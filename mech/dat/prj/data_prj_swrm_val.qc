/*
mech Mod
Author: Peter Roohr
Date: 01/21/2018
Overview: data def file for Swarm Missile Launcher missile
*/

//Swarm Missile missile=======================
void() data_prj_swrm_think;
void() data_prj_swrm_touch;

void() data_prj_swrm_ini={
  self.classname = "missile";
  self.touch = data_prj_swrm_touch;
  self.data_idx = ID_PRJ_SWRM;
  self.p_velocity = DAT_PRJ_SWRM_VELOCITY;
  self.c_model = DAT_PRJ_SWRM_MODEL;
  self.p_lifetime = DAT_PRJ_SWRM_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | EF_ADDITIVE | EF_NOSHADOW;
  self.modelflags = DAT_PRJ_SWRM_MODELFLAGS;
  self.traileffectnum = particleeffectnum("TE_SWRM_TRAIL");
};

//thanks, inside3d for the homing missile tut.
void() data_prj_swrm_think={

	local vector vele, vels;					//velocity enemy, velocity self
	local vector ph;						//Place holder
	
  if(time >= self.p_lifetime){
    BecomeExplosion();
    return;
  }
  
  if(self.movetype != MOVETYPE_BOUNCE){
    self.movetype = MOVETYPE_BOUNCE;
  }
  
	//The tack to opponent
	vele = (self.enemy.origin + '0 0 16') - self.origin;		//Finds the unit vector towards the enemy
	vele = normalize(vele);
	
	//Current tack
	vels = normalize(self.velocity);				//defines current vector
	
	//Check tack to enemy
	traceline(self.origin, self.origin + vele * 10000, FALSE, self);	//Traceline to enemy
	
	if((trace_fraction != 0) && (self.enemy != world))
	{
		//Placeholder
		ph = vele + vels + vels + vels + vels;			//Enemy velocity plus 4 times self velocity
		
		//Placeholder over three
		ph = ph * (1/5);					//Averaging
		
		//Setvelocity and here we go!	
		self.velocity = normalize(vels + ph);			//Set the velocity
		self.velocity = self.velocity * self.p_velocity;			//And you are on your way
	}

	//Set the angles	
	self.angles = vectoangles(self.velocity);			//Set angle
	self.aflag = self.aflag + 1;					//Add to "idle hands" counter
	
	if(self.aflag >= 500){						//5.25 seconds is up....
		self.owner = world;
	}
	
  self.think = data_prj_swrm_think;
  self.nextthink = time + 0.05;
};

void() data_prj_swrm_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.takedamage){
    t_damage(other, self, self.owner, self.p_damage, self.p_dmgtype, self.origin, '0 0 0');
    if( other.sh_cur > 0 ){
      remove(self);
      return;
    }
  }
  BecomeExplosion();
};