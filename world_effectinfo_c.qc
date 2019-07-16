/*
battleMETAL
Date: 11/29/2017
mod: 07/02/2019
Author: Peter Roohr
Overview: 
  custom TE_'s using the effectinfo.txt system
*/


vector( vector startOrg ) te_apply_wind={
  local vector windVel;
  
  makevectors(world.wind);
  windVel = startOrg + (v_up * WINDDIR_z) + (v_forward * (-1 * (WINDDIR_z/2)) );
  return windVel;
};


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

entity( entity targetBuilding ) te_building_fire_start={
  local entity fire;
  fire = spawn();
  fire.origin = util_pointNearBoxEdge( targetBuilding.origin, targetBuilding.angles, targetBuilding.mins, targetBuilding.maxs );
  fire.damageValue = particleeffectnum(strcat("TE_FIRE_", ftos(targetBuilding.vec_size)));
  fire.think = building_burn_th;
  fire.nextthink = time + 0.1;
  fire.angles = targetBuilding.angles;
  fire.count = targetBuilding.vec_size + (1 / 3);
  te_debris(fire.origin, targetBuilding.angles, '1 1 8', random() * (targetBuilding.vec_size * 6), targetBuilding.vec_size);
  targetBuilding.color = targetBuilding.color - '0.1 0.1 0.1';
  return fire;
};

//TE_SMOKE_TEST
void(vector org, float total) te_smoke_test={
  local vector smoke;
  smoke = te_apply_wind( org );
  pointparticles(particleeffectnum("SMOKE_TEST"), org , normalize(smoke - org) * WINDDIR_z, total);
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
    setmodel (newmis, debrisMdl);
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin(newmis, org);
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
  dir = te_apply_wind( torg );
  dir = normalize( dir - vel ) * WINDDIR_z;
  
  switch( world.worldtype ){
    default:
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
  
  self.c_alt_ofs = te_apply_wind( self.origin );
  pointparticles( particleeffectnum(self.vec_name), self.origin, normalize(self.c_alt_ofs - self.origin) * WINDDIR_z, self.count);

  self.think = te_flame_th;
  if( self.data_lifetime > 0 ){
    if( time > self.data_lifetime ){
      self.think = SUB_Remove;
    }
  }
  self.nextthink = time + self.count2;
};

void( vector org, vector angl, float total, float lifetime, float ticrate) te_small_flame_start={
  local entity fire;
  
  fire = spawn();
  fire.w_firetime = ticrate;
  fire.movetype = MOVETYPE_NONE;
  fire.solid = SOLID_NOT;
  fire.angles = angl;
  fire.think = te_flame_th;
  fire.nextthink = time + fire.w_firetime;
  fire.count = total;
  fire.vec_name = "TE_FIRE_1";
  if( lifetime > 0 ){
    fire.data_lifetime = time + lifetime;
  }
  setorigin( fire, org );
};

void( vector org, vector angl, float total, float lifetime, float ticrate) te_med_flame_start={
  local entity fire;
  
  fire = spawn();
  fire.w_firetime = ticrate;
  fire.movetype = MOVETYPE_NONE;
  fire.solid = SOLID_NOT;
  fire.angles = angl;
  fire.think = te_flame_th;
  fire.nextthink = time + fire.w_firetime;
  fire.count = total;
  fire.vec_name = "TE_FIRE_2";
  if( lifetime > 0 ){
    fire.data_lifetime = time + lifetime;
  }
  setorigin( fire, org );
};

void( vector org, vector angl, float total, float lifetime, float ticrate) te_big_flame_start={
  local entity fire;
  
  fire = spawn();
  fire.w_firetime = ticrate;
  fire.movetype = MOVETYPE_NONE;
  fire.solid = SOLID_NOT;
  fire.angles = angl;
  fire.think = te_flame_th;
  fire.nextthink = time + fire.w_firetime;
  fire.count = total;
  fire.vec_name = "TE_FIRE_3";
  if( lifetime > 0 ){
    fire.data_lifetime = time + lifetime;
  }
  setorigin( fire, org );
};


void( vector org, vector angl, float hitDmg, float total) te_shield_hit_high={
  local vector vel;
  local float demg;
  
  demg = hitDmg / 10;
  vel = angl * demg;
  
  pointparticles( particleeffectnum("TE_SHIELD_HIT_HIGH"), org, vel, demg + total);
  pointsound( org, "sound/fx_shieldhit.ogg", 1, ATTN_NORM );
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
  explode.data_lifetime = 10;
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
  explode.data_lifetime = 10;
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

void( entity source, vector org, vector angl, vector vel, string modl, float skinNum ) te_mech_piece_explode={
  local entity notChunk;
  local vector localVel;
  notChunk = self;
  
  localVel = vel;
  newmis = spawn();
  self = newmis;
    self.vec_size = notChunk.owner.vec_size;
    self.angles = angl;
    if(localVel_x > 0 || localVel_y > 0 ||localVel_z > 0){
      self.velocity = vel + VelocityForDamage (100);
      self.avelocity_x = random()*150;
      self.avelocity_y = random()*150;
      self.avelocity_z = random()*100;
    }
    else{
      self.velocity = VelocityForDamage (100);
      self.avelocity_x = random()*150;
      self.avelocity_y = random()*150;
      self.avelocity_z = random()*100;
    }
    self.th_die = SUB_Remove;
    self.owner = notChunk.owner;
    util_setCollider(DAMAGE_AIM, SOLID_CORPSE, MOVETYPE_BOUNCE);
    util_setModel(modl, skinNum, 0);
    setsize(self, '-4 -4 -4', '4 4 4');
    setorigin(self, notChunk.origin);
    self.touch = touch_mechPiece;
    self.think = ctrl_component_burn;
    self.nextthink = time + (random() * 1);
    self.ai_action_time = time + (random() * (self.owner.vec_size * 4824));
    self.colormod = notChunk.colormod;
    localVel = normalize(self.origin - self.owner.origin) * 10;
    localVel_z = localVel_z + 50;
    te_debris( self.origin, self.angles, normalize(self.origin - self.owner.origin) * 5, self.owner.vec_size * 2, self.owner.vec_size);
  self = notChunk;
};

void( vector org, vector setVelocity, float total ) te_field_rad={
  pointparticles( particleeffectnum("TE_FIELD_RAD"), org, setVelocity,  total);
};

void( vector org, float total ) te_field_rad_light={
  pointparticles( particleeffectnum("TE_FIELD_RAD_LIGHT"), org, '0 0 0',  total);
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
    traceline(self.owner.origin, self.owner.origin + (v_up * (unitMins_z - 16)), MOVE_HITMODEL, self.owner);
    if( !trace_ent.model ){
      return;
    }
    sound (self, CHAN_FOOT, "sound/mech_stomp.ogg", 1, ATTN_NORM);
    pointparticles( TE_STOMP_TYPE, fx, normalize(vel - fx) * 10,  vecSize * 3);
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
