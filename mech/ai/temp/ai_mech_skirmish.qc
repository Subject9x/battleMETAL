/*
battleMETAL 
Author: Peter Roohr
Date: 7/9/2018
Overview: ai mech test, draft 9
*/
//SKIRMISHER STAND
void() ai_mech_sk_stand ={
  ai_stand(); 
};

//SKIRMISHER WALK
void() ai_mech_sk_walk = {
  ai_walk(self.m_fspeed); 
};

//SKIRMISHER RUN
void() ai_mech_sk_run ={
  ai_run(self.m_fspeed * AI_RUN_SPD);
  self.think = ai_mech_sk_run;
  self.nextthink = time + 0.05;
};
//SKIRMISHER STRAFE
void() ai_mech_sk_strafe = {
  
  self.nextthink = time + 0.05;
  
};


//SKIRMISHER ATTACK

//SKIRMISHER PAIN

//SKIRMISHER DEATH1

void() ai_mech_skirmisher={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE){
    remove(self);
  }
  ai_unit_ini_var();
    
  data_iniMech(self.nextVecChoice);
  ai_pilot_ini_stats(self.ai_rank);
  
  self.e_cam.SendEntity = send_ai_mech;
  self.e_cam.SendFlags = 31;
  
  self.pausetime = 999999;
  
  self.th_stand = ai_mech_sk_stand;
  self.th_walk = ai_mech_sk_walk;
  self.th_run = ai_mech_sk_run;
  
  droptofloor();
  self.flags = self.flags | FL_ONGROUND;
 
  ai_mech_sk_stand();
};