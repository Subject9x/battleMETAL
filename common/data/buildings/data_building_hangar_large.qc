/*
battleMETAL
Author: Peter Roohr
Date: 5/10/2017
Overview: data file for building
*/

void() building_human_hangar_th={
  building_burn();
  self.think = building_human_hangar_th;
  self.nextthink = time + 0.1;
};

/*QUAKED building_human_hangar (0 0 1) (-72 -72 0) (72 72 80) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY -
{ model("models/buildings/hangar/hangar.md3"); }
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() building_human_hangar={

  self.data_idx = self.nextVecChoice = UI_BUILDING_hangar_large;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  self.vec_name = "Large Hangar";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 3;
  
  self.takedamage = DAMAGE_AIM;
  
  self.shield = 0;
  self.shieldMax = 300;
  self.shieldRate = 0.2;
  self.deadflag = DEAD_NO;
  
  self.th_die = building_die;
  self.use = multi_trigger;
  self.solid = SOLID_SLIDEBOX;
  util_setHealthArmor(800, 800, 1, 100) ;
  util_setModel( "q3mdl/buildings/hangar/mdl_bld_h_hangar_l.md3", self.skin, EF_LOWPRECISION) ;
  setsize(self, '-68 -84 0', '68 84 88');
  self.movetype = MOVETYPE_NONE;
  
  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 0.95) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  
  self.think = building_human_hangar_th;
  self.nextthink = time + (random() * 0.1);
};