/*
battleMETAL
Author: Peter Roohr
Date: 5/13/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

//Death Animation - TODO - clientside
void() hfuel_death1 = [1, hfuel_death2]{
  
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_NOT;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;

  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  ai_alert_close(self.enemy);
};
void() hfuel_death2 = [2, hfuel_death3]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 5, 1 );
};
void() hfuel_death3 = [3, hfuel_death4]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 5, 3 );
};
void() hfuel_death4 = [4, hfuel_death5]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 4, 2 );
};
void() hfuel_death5 = [5, hfuel_death6]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 1 );
};
void() hfuel_death6 = [6, hfuel_death7]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death7 = [7, hfuel_death8]{};
void() hfuel_death8 = [8, hfuel_death9]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death9 = [9, hfuel_death10]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death10 = [10, hfuel_death11]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death11 = [11, hfuel_death12]{};
void() hfuel_death12 = [12, hfuel_death12]{};


/*QUAKED building_human_fuel (0.0 0.0 1.0) (-40 -40 0) (40 40 64) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/fueltank/fueltank.md3"); }

Base Decoration building.
  
Does not require power.
Does not explode with damage.

Max Health = 100. (default)

Shield Max = 250. (default)

-------- KEYS -------- 
.faction : <float> 1, 2, 3 - [REQURIED]
targetname : <string>, used for trigger calls from other ents
target : <string name> of ent to go to, usually a patrol node
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
void() building_human_fuel={
  self.data_idx = self.nextVecChoice = UI_BUILDING_fuel_tank;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  self.vec_name = "Fuel Tank";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 2;
  macro_set_model("q3mdl/testball.md3", self.skin, 0)
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE)
  setsize(self, '-40 -40 0', '40 40 64');
  setorigin(self, self.origin);
  self.scale = 1;
  self.deadflag = DEAD_NO;

  if( !self.health) {
    self.health = self.max_health = 100;
  }
  
  if( !self.shieldMax ){
    self.shieldMax = 250;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0;
  }
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 0;
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

  self.th_die = hfuel_death1;
  self.use = multi_trigger;
  
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