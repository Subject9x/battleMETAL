/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/

//TE_SMOKE_TEST
void(vector org, vector vel, float total) te_smoke_test={
  pointparticles(particleeffectnum("SMOKE_TEST"), org , vel, total);
};

/*
  Creates a small flying smoking debris field
  mostly used for mech piece explosions
*/
void( vector org, vector angl, float vel, float total, float particleNum) te_debris_smoke_small={
  local float totals;
  
  totals = total;
  while( totals > 0 ){
    newmis = spawn();
    newmis.movetype = MOVETYPE_BOUNCE;
    newmis.solid = SOLID_NOT;
    newmis.classname = "missile";
    newmis.velocity = normalize(angl);
    newmis.velocity = newmis.velocity * vel;
    newmis.angles = vectoangles(newmis.velocity);
    newmis.think = SUB_Remove;
    newmis.nextthink = time + newmis.p_lifetime;
    setmodel(newmis, "q3mdl/testball.md3"); //DEBUG - TODO
    setsize(newmis, '0 0 0', '0 0 0');        
    setorigin(newmis, org);
    newmis.traileffectnum = particleNum;  //TODO - finish
    totals = totals - 1;
  }
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









