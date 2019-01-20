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
  
  switch( debrType ){
    case 2:
      debrisMdl = "q3mdl/fx/debris2/mdl_debris_2.md3";
      break;
    case 3:
      debrisMdl = "q3mdl/fx/debris3/mdl_debris_3.md3";
      break;
    default:
      debrisMdl = "q3mdl/fx/debris1/mdl_debris_1.md3";
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
    newmis.traileffectnum = particleeffectnum("TE_MIS_TRAIL");  //TODO - finish
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

//HUD Sound Effects
//make sure to scope self to target client
void() te_nav_reach={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_NAV_REACH );
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









