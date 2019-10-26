/*
battleMETAL
Author: Peter Roohr
Date: 09/03/2019
Overview:
  a smaller, vehicle hangar.
*/


void() building_human_hangar_vec_th={
  
  building_burn();
  self.think = building_human_hangar_vec_th;
  self.nextthink = time + 0.1;
};

/*QUAKED building_human_hangar_vehicle (0 0 1) (-72 -72 0) (72 72 80) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - - - IS_MAPKEY -
{ model("models/buildings/hangar_vec/hangar_vehicle.md3"); }
Mostly just a decorating building, BUT
you can target an ai_spawner and when the hangar is attacked, it'll trigger the spawner
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() building_human_hangar_vehicle={

  self.data_idx = UI_BUILDING_hangar_med;
  self.data_type = DATA_BLD;
  self.vec_name = "Vehicle Hangar";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 2;
  
  self.takedamage = DAMAGE_AIM;
  
  self.shield = 0;
  self.shieldMax = 500;
  self.shieldRate = 1;
  self.deadflag = DEAD_NO;
  
  self.th_die = building_die;
  self.use = multi_trigger;
  self.solid = SOLID_BSP;
  util_setHealthArmor(500, 500, 1, 100) ;
  util_setModel( "q3mdl/buildings/hangar_vehicle/hangar_vehicle.md3", self.skin, 0) ;
  setsize(self, self.mins, self.maxs);
  self.movetype = MOVETYPE_NONE;
  
  if( util_cornerSlopeCheck(self, 0.95) ){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  
  self.think = building_human_hangar_vec_th;
  self.nextthink = time + (random() * 0.1);
};