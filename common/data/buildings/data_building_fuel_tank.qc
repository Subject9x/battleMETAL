/*
battleMETAL
Author: Peter Roohr
Date: 5/13/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

//Death Animation
void() hfuel_death1 = [1, hfuel_death2]{
  
  if( self.deadflag > DEAD_NO ){
    return;
  }
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_NOT;
  te_object_explode( '1 0.75 0' );
  
};
void() hfuel_death2 = [2, hfuel_death3]{};
void() hfuel_death3 = [3, hfuel_death4]{};
void() hfuel_death4 = [4, hfuel_death5]{

  te_object_explode( '1 0.75 0' );
};
void() hfuel_death5 = [5, hfuel_death6]{};
void() hfuel_death6 = [6, hfuel_death7]{};
void() hfuel_death7 = [7, hfuel_death8]{

  te_object_explode( '1 0.75 0' );
};
void() hfuel_death8 = [8, hfuel_death9]{};
void() hfuel_death9 = [9, hfuel_death10]{};
void() hfuel_death10 = [10, hfuel_death11]{

  te_object_explode( '1 0.75 0' ); 
  local entity ruins;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_NOT;
};
void() hfuel_death11 = [11, hfuel_death12]{};
void() hfuel_death12 = [12, SUB_Remove]{
  makevectors( self.angles );
  te_missile_explode( self.origin + (v_up * -5),  1, '0.663 0.886 0.953', self.damageValue / 5, 1);
  
  sound(self, CHAN_VOICE, "sound/fx_boom.ogg", 1 , ATTN_NORM);
};

void() building_human_fuel_th={
  
  building_burn();
  
  self.think = building_human_fuel_th;
  self.nextthink = self.nextthink + random()*0.5;
};

/*QUAKED building_human_fuel (0.0 0.0 1.0) (-40 -40 0) (40 40 40) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY -
{ model("models/buildings/fueltank/fueltank.md3"); }
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
void() building_human_fuel={
  self.data_idx = self.nextVecChoice = UI_BUILDING_fuel_tank;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  self.vec_name = "Fuel Tank";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 2;
  macro_set_model("q3mdl/buildings/fueltank/mdl_bld_h_fuel.md3", self.skin, 0)
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE)
  util_setHealthArmor(75, 75, 1, 100) ;
  setsize(self, '-40 -40 0', '40 40 64');
  self.shield= 0;
  self.shieldMax = 150;
  self.shieldRate = 0.15;
  self.scale = 1;
  self.deadflag = DEAD_NO;

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
  
  self.think = building_human_fuel_th;
  self.nextthink = self.nextthink + random()*0.5;
};