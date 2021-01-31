/*
battleMETAL
Author: Peter Roohr
Date: 09/03/2019
Overview:
  a smaller, vehicle hangar.
*/

void() hangar_vehicle_die2;
void() hangar_vehicle_die3;
void() hangar_vehicle_die4;
void() hangar_vehicle_die5;
void() hangar_vehicle_die6;
void() hangar_vehicle_die7;
void() hangar_vehicle_die8;
void() hangar_vehicle_die9;
void() hangar_vehicle_die10;
void() hangar_vehicle_die11;
void() hangar_vehicle_die12;
void() hangar_vehicle_die13;
void() hangar_vehicle_die14;
void() hangar_vehicle_die15;

void() hangar_vehicle_die1=[0, hangar_vehicle_die2]{
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD; 
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
  
  ai_alert_close(self.enemy);
  
};
void() hangar_vehicle_die2=[0, hangar_vehicle_die3]{

};
void() hangar_vehicle_die3=[0, hangar_vehicle_die4]{
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.mins_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
};
void() hangar_vehicle_die4=[0, hangar_vehicle_die5]{

};
void() hangar_vehicle_die5=[0, hangar_vehicle_die6]{
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * self.maxs_z) + (v_forward * (self.mins_y * 0.18)) + (v_right * (self.mins_x * 0.15));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
};
void() hangar_vehicle_die6=[0, hangar_vehicle_die7]{

};
void() hangar_vehicle_die7=[0, hangar_vehicle_die8]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
};
void() hangar_vehicle_die8=[0, hangar_vehicle_die9]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 2 );
};
void() hangar_vehicle_die9=[0, hangar_vehicle_die10]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
};
void() hangar_vehicle_die10=[0, hangar_vehicle_die11]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 2, 2 );
};
void() hangar_vehicle_die11=[0, hangar_vehicle_die12]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 1 );
};
void() hangar_vehicle_die12=[0, hangar_vehicle_die13]{

};
void() hangar_vehicle_die13=[0, hangar_vehicle_die14]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 1 );
};
void() hangar_vehicle_die14=[0, hangar_vehicle_die15]{

};
void() hangar_vehicle_die15=[0, SUB_Null]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 5,1 );
};

/*QUAKED building_human_hangar_vehicle (0 0 1) (-78 -78 0) (78 78 48) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/hangar_vec/hangar_vehicle.md3"); }

Base Decoration building.
 + you can target an ai_spawner and when the hangar is attacked, it'll trigger the spawner
 
Does Not require power.

Max Health = 500.(default)

ShieldMax = 400. (default)
ShieldRate = 0. (default)

-------- KEYS -------- 
.faction : <float> 1, 2, 3 - [REQURIED]
targetname : <string>, used for trigger calls from other ents
target : <string> name of ent to go to, usually a patrol node
trigOnSpawn: <string> ent, fire this ENTITY when activated
trigOnDeath: <string> target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_human_hangar_vehicle={

  self.data_idx = self.nextVecChoice = UI_BUILDING_hangar_med;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  self.vec_name = "Vehicle Hangar";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 2;
  macro_set_model("q3mdl/testball.md3", self.skin, 0)
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE)
  setsize(self, '-78 -78 0', '78 78 48');
  
  self.th_die = hangar_vehicle_die1;
  self.use = multi_trigger;
  
  if( !self.health) {
    self.health = self.max_health = 500;
  }
  
  if( !self.shieldMax ){
    self.shieldMax = 400;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0;
  }
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 1000;
  }

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
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }
  self.think = building_burn_th;
  self.nextthink = time + random() * 3;
};