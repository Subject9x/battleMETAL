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

void() te_debris_touch={
  remove(self);
};

void() te_debris_th2={
  self.alpha = self.alpha - 0.1;
  self.think = te_debris_th2;
  if( self.alpha >= 0 ){
    self.think = SUB_Remove;
  } 
  self.nextthink = time + 0.5;
}

void() te_debris_th1={
  self.solid = SOLID_BBOX;
  self.touch = te_debris_touch;
  self.think = te_debris_th2;
  self.nextthink = time + 0.1;
};

/*
  Creates a small flying smoking debris field
  mostly used for mech piece explosions
*/
void( vector org, vector angl, vector vel, float total) te_debris_small={
  local float totals;
  
  totals = total;
  while( totals > 0 ){
    newmis = spawn();
    newmis.movetype = MOVETYPE_BOUNCE;
    newmis.solid = SOLID_NOT;
    newmis.classname = "missile";
    newmis.velocity = vel;
    newmis.velocity_z = newmis.velocity_z + 50;
    newmis.avelocity_x = random()*150;
    newmis.avelocity_y = random()*150;
    newmis.avelocity_z = random()*100;
    newmis.think = te_debris_th1;
    newmis.nextthink = time + 1;
    setmodel(newmis, "q3mdl/fx/debris1/mdl_debris_1.md3"); //DEBUG - TODO
    setsize(newmis, '0 0 0', '0 0 0');        
    setorigin(newmis, org);
    newmis.gravity = 0.15;
    newmis.traileffectnum = particleeffectnum("TE_MIS_TRAIL");  //TODO - finish
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









