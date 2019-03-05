/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/

//ported over from classice Quake C
void(string gibname, float dm) ThrowGib =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
};

//TE_SMOKE_TEST
void(vector org, vector vel, float total) te_smoke_test={
  
  pointparticles(particleeffectnum("SMOKE_TEST"), org , vel, total);
};

/*
  Creates a small flying smoking debris field
  mostly used for mech piece explosions
*/
void( vector org, vector angl, vector vel, float total, float debrType) te_debris={
  local float totals;
  local string debrisMdl;
  local float trailNum;
  
  switch( debrType ){
    case 2:
      debrisMdl = "q3mdl/fx/debris2/mdl_debris_2.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_MED");
      break;
    case 3:
      debrisMdl = "q3mdl/fx/debris3/mdl_debris_3.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_BIG");
      break;
    default:
      debrisMdl = "q3mdl/fx/debris1/mdl_debris_1.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_SMALL");
      break;
  }
  
  totals = total;
  while( totals > 0 ){
  	newmis = spawn();
    newmis.origin = self.origin;
    setmodel (newmis, debrisMdl);
    setsize (newmis, '0 0 0', '0 0 0');
    newmis.velocity_x = 100 * crandom();
    newmis.velocity_y = 100 * crandom();
    newmis.velocity_z = 50 + 100 * random();
    newmis.effects = newmis.effects | EF_NOSHADOW;
    newmis.movetype = MOVETYPE_BOUNCE;
    newmis.solid = SOLID_NOT;
    newmis.avelocity_x = random()*450;
    newmis.avelocity_y = random()*450;
    newmis.avelocity_z = random()*450;
    newmis.think = SUB_Remove;
    newmis.ltime = time;
    newmis.nextthink = time + random() * 5;
    newmis.frame = 0;
    newmis.flags = 0;
    newmis.gravity = 0.15;
    newmis.traileffectnum = trailNum;
    totals = totals - 1;
  }
};

void( vector org, vector angl, vector vel, float total) te_unit_dust={
  local vector dir;
  local vector torg;
  local float partcle;
  
  makevectors(self.angles);
  torg = org + (v_up * (self.mins_z / 1.5) ) + (v_forward * (self.mins_x / 4));
  dir = (WINDDIR + angl) * WINDSPEED;
  dir = normalize( dir - vel );
  
  switch( world.worldtype ){
    case 0:
      partcle = particleeffectnum("TE_DUST_DESERT");
      break;
    case 1:
      partcle = particleeffectnum("SMOKE_TEST");
      break;
    case 2: 
      partcle = particleeffectnum("SMOKE_TEST");
      break;
    case 3:
      partcle = particleeffectnum("SMOKE_TEST");
      break;
    case 4:
      partcle = particleeffectnum("SMOKE_TEST");
      break;
  }
  
  pointparticles( partcle, torg , dir * 2, total);
};

void() te_flame_th={
  
  makevectors( self.angles );
  self.c_alt_ofs = self.origin + (v_up * self.c_ofs_y) + (v_forward * self.c_ofs_z) + (v_right * self.c_ofs_x);
  pointparticles( particleeffectnum(self.vec_name), self.origin, normalize(self.c_alt_ofs - self.origin) * 1, self.count);

  self.think = te_flame_th;
  if( self.p_lifetime > 0 ){
    if( time > self.p_lifetime ){
      self.think = SUB_Remove;
    }
  }
  self.nextthink = time + self.count2;
};

void( vector org, vector angl, vector vel, float total, float lifetime, float ticrate) te_small_flame_start={
  local entity fire;
  
  fire = spawn();
  fire.w_firetime = ticrate;
  fire.movetype = MOVETYPE_NONE;
  fire.solid = SOLID_NOT;
  fire.angles = angl;
  fire.think = te_flame_th;
  fire.nextthink = time + fire.w_firetime;
  fire.c_ofs = vel; //holds velocity;
  fire.count = total;
  fire.vec_name = "TE_FIRE_1";
  if( lifetime > 0 ){
    fire.p_lifetime = time + lifetime;
  }
  setorigin( fire, org );
};

void( vector org, vector angl, vector vel, float total, float lifetime, float ticrate) te_med_flame_start={
  local entity fire;
  
  fire = spawn();
  fire.w_firetime = ticrate;
  fire.movetype = MOVETYPE_NONE;
  fire.solid = SOLID_NOT;
  fire.angles = angl;
  fire.think = te_flame_th;
  fire.nextthink = time + fire.w_firetime;
  fire.c_ofs = vel; //holds velocity;
  fire.count = total;
  fire.vec_name = "TE_FIRE_2";
  if( lifetime > 0 ){
    fire.p_lifetime = time + lifetime;
  }
  setorigin( fire, org );
};

void( vector org, vector angl, vector vel, float total, float lifetime, float ticrate) te_big_flame_start={
  local entity fire;
  
  fire = spawn();
  fire.w_firetime = ticrate;
  fire.movetype = MOVETYPE_NONE;
  fire.solid = SOLID_NOT;
  fire.angles = angl;
  fire.think = te_flame_th;
  fire.nextthink = time + fire.w_firetime;
  fire.c_ofs = vel; //holds velocity;
  fire.count = total;
  fire.vec_name = "TE_FIRE_3";
  if( lifetime > 0 ){
    fire.p_lifetime = time + lifetime;
  }
  setorigin( fire, org );
};


void( vector org, vector angl, float hitDmg, float total) te_shield_hit_high={
  local vector vel;
  local float demg;
  
  demg = hitDmg / 10;
  vel = angl * demg;
  
  pointparticles( particleeffectnum("TE_SHIELD_HIT_HIGH"), org, vel, demg + total);

};


void() te_shield_explode_th={
  self.alpha = self.alpha - 0.015;
  self.scale = self.scale + 0.01;
  self.think = te_shield_explode_th;
  if( self.alpha < 0.01 ){
    self.think = SUB_Remove;
  }
  self.nextthink = time + 0.01;
};

void( vector org, float vecSize ) te_shield_explode={
  local entity explode;
 
  explode = spawn();
  explode.movetype = MOVETYPE_NONE;
  explode.solid = SOLID_NOT;
  explode.think = te_shield_explode_th;
  explode.nextthink = time + 0.05;
  explode.p_lifetime = 10;
  explode.scale = 0.1 + (vecSize / 3);
  explode.alpha = 0.75;
  explode.effects = explode.effects | EF_NOSHADOW;
  setmodel( explode, "q3mdl/fx/explosions/te_shield_explode.md3");
  setorigin( explode, org);
  te_customflash( org, vecSize * 50, 1, '0.003 0.87 0.22'); 
  //pointparticles?
};

void() te_missile_explode_th={
  self.alpha = self.alpha - 0.015;
  self.scale = self.scale + 0.01;
  self.think = te_shield_explode_th;
  if( self.alpha < 0.01 ){
    self.think = SUB_Remove;
  }
  self.nextthink = time + 0.01;
};

void( vector org, float explodeSize, vector explodeColor, float debrisCount, float debrType ) te_missile_explode={
  local entity explode;
 
  sound(self, CHAN_VOICE, "sound/fx_boom.ogg", 1 , ATTN_NORM);
 
  explode = spawn();
  explode.movetype = MOVETYPE_NONE;
  explode.solid = SOLID_NOT;
  explode.think = te_shield_explode_th;
  explode.nextthink = time + 0.05;
  explode.p_lifetime = 10;
  explode.scale = explodeSize;
  explode.alpha = 1;
  explode.avelocity = randomvec() * 300;
  if( explodeColor != '0 0 0' ){
    explode.color = explodeColor;
  }
  
  setmodel( explode, "q3mdl/fx/explosions/te_missile_explode.md3");
  setorigin( explode, org);
  te_debris( org, '0 0 0', '0 0 0', random() * debrisCount, 1);
  te_customflash( org, explodeSize * 50, 1, explodeColor); 
  //pointparticles?
};

/*
  item is exploding, use its bbox size for area
*/
void( vector explodeColor ) te_object_explode={
  local vector exp;
  
  exp_x = crandom() * (self.maxs_x * 2);
  exp_y = crandom() * (self.maxs_y * 2);
  exp_z = crandom() * (self.maxs_z * 2);
  makevectors(self.angles);
  exp = self.origin + (v_up * exp_z) + ( v_forward * exp_y) + (v_right * exp_x);
  
  te_missile_explode( exp, self.vec_size, explodeColor, self.vec_size * 1.5, self.vec_size );

};

void( vector org, vector angl, float vecSize, vector unitMins, float left) te_foot_stomp={
    local vector fx, vel;
    local vector leftMin;
    
    makevectors( angl );
    fx = org ;
    fx_z = fx_z + unitMins_z;
    leftMin = v_right * (unitMins_x * 0.8);
    if( left ){
       fx = fx + leftMin;
    }
    else{
       fx = fx - leftMin;
    }
    
    vel = fx + (v_up * 2);
    
    pointparticles( TE_STOMP_TYPE, fx, normalize(vel - fx) * 2,  vecSize * 1.5);
    
};

//HUD Sound Effects
//make sure to scope self to target client
void() te_nav_reach={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_NAV_REACH );
};

void() te_targ_kill={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_TARG_KILL );
};

void(float type) te_objective_complete={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_OBJECTIVE_COMPLETE );
  WriteByte( MSG_ONE, type );
};

void() te_objective_failed={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_OBJECTIVE_FAILED );
};

void() te_mission_win={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MISSION_WIN );
};

void() te_mission_lose={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MISSION_LOSE );
};

void() te_msn_boundary={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MSN_BOUND );
};









