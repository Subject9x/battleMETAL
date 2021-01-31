/*
battleMETAL
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: Shield Generator
  faction: humans
  func: provides shields to all friendly units in its radius, but requires a nearby power plant.
*/
void() hshield_die = [0, hshield_die1]{
  if( self.deadflag > DEAD_NO){
    return;
  }
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  ai_alert_close(self.enemy);

};
void() hshield_die1 = [1, hshield_die2]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die2 = [2, hshield_die3]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die3 = [3, hshield_die4]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die4 = [4, hshield_die5]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die5 = [5, hshield_die6]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die6 = [6, hshield_die7]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die7 = [7, hshield_die8]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die8 = [8, hshield_die9]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
};
void() hshield_die9 = [9, hshield_die10]{
  local entity head;
  
  if( self.energy > 0 ){
    for(head = nextent(world); head != world; head = nextent(head) ){
      if( head == self ){
        continue;
      }
      if( vlen(head.origin - self.origin) > (self.ai_minrange / 2) ){
        continue;
      }
      if( !(head.flags & (FL_UNIT | FL_MONSTER)) ){
        continue;
      }
      if( head.shield <= 0 ){
        continue;
      }
      if( self.energy < 0 ){
        continue;
      }
      head.shield = head.shield - ((self.energy / self.energyMax) / 2);
      if( head.shield < 0 ){
        head.shield = 0;
      }
      if( !head.stat_client_shield ){
        head.stat_client_shield = (head.shield / head.shieldMax) * 100;
      }
      if( head.data_type == DATA_BLD ){
        head.SendFlags = head.SendFlags | SENDFLAG_IMPACT;
      }
      
    
      head.shieldHitDelay = time + ((self.energy / self.energyMax) / 2);
      self.energy  = self.energy - ((self.energy / self.energyMax) / 5);
    }
  }
};
void() hshield_die10 = [10, hshield_die11]{};
void() hshield_die11 = [11, hshield_die12]{};
void() hshield_die12 = [12, hshield_die13]{};
void() hshield_die13 = [13, hshield_die14]{};
void() hshield_die14 = [14, hshield_die15]{};
void() hshield_die15 = [15, SUB_Null]{};


void() hshield_th ={
  local entity t;
  local float mod;
  local float cost;
 
  cost = 0;
  if( self.energy > 0 ){
    for( t = nextent(world); t != world; t = nextent(t) ){   
      if( t == self ){
        continue;
      }
      if( !(t.flags & (FL_UNIT|FL_MONSTER)) ){
        continue;
      }
      if( vlen(t.origin - self.origin) > self.ai_minrange ){
        continue;
      }
      if( t.faction != self.faction ){
        continue;
      }
      if( time > t.shieldHitDelay ){
        mod = t.shieldRate + (self.shieldRate * 0.33);
        t.shield = t.shield + mod;
        if( t.shield > t.shieldMax ){
          t.shield = t.shieldMax;
        }
        cost = cost + (self.shieldRate * 0.05);
        if( !t.stat_client_shield ){
          t.stat_client_shield = (t.shield / t.shieldMax) * 100;
        }
      }
    }
  }
  
  self.energy = self.energy - cost;
  self.energy = self.energy + self.energyRate;
  if(self.energy > self.energyMax){
    self.energy = self.energyMax;
  }
  
  if( time > self.shieldHitDelay ){
    self.shield = self.shield + self.shieldRate * 2;  //generators get their own shields for free
    if(self.shield > self.shieldMax){
      self.shield = self.shieldMax;
    }  
  }
  self.stat_client_shield = (self.shield / self.shieldMax) * 100;
  building_burn();
  
  if( self.last_shield != self.stat_client_shield ){
    self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
    self.last_shield = self.stat_client_shield;
  }
  self.think = hshield_th;
  self.nextthink = time + 0.1;
}

/*QUAKED building_human_shield (0.2 0.8 0.2) (-56 -56 0) (56 56 28) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/shield/shield.md3"); }
Shield Generator Building.
Gives SHIELD to EVERY FRIENDLY unit in radius, regardless if those units normally have shields!
MUST HAVE: Power Plant that can power it (check power plant radius).
Generator does have to pay for its shield generating, these can be taxed by too many nearby units.

Health = 500. (default)

Energy Max = 2000 units. (default)
Energy Rate = 0. (default)

Shield Max = 300. (default)
Shield Rate = 0.33 / tic (default)

Radius: 1000 units.(default)

behavior: death() will DAMAGE shields of all units at ai_minrange/2

-------- KEYS -------- 
faction : <float> [Required], faction id - 1 | 2 | 3
targetname : <string>, used for trigger calls from other ents.
target : <string> name of ent to go to, usually a patrol node.
trigOnSpawn: <string> ent, fire this ENTITY when activated.
trigOnDeath: <string target, fire this ENTITY when killed.
shieldRate: <float> [Optional], default is 4 / tic. set this to override default.
shieldMax: <float> [Optional], default is 4000. set this to override default.
ai_minrange: <float> [Optional], default is 100. set ths to override default;
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_human_shield={
  self.data_idx = self.nextVecChoice = UI_BUILDING_shield_generator;
  self.data_type = DATA_BLD;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  self.vec_name = "Shield Generator";
  self.vec_size = 2;
  self.flags = self.flags | FL_MONSTER ;  
  self.scale = 1;
  self.deadflag = DEAD_NO;
  
  macro_set_model("q3mdl/testball.md3", self.skin, EF_LOWPRECISION)
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE)
  setsize(self, '-48 -48 0', '48 48 32');
    
  if( !self.ai_minrange ){
    self.ai_minrange = 1000;
  }
    
  if( !self.health) {
    self.health = self.max_health = 500;
  }
  
  if( !self.shieldMax ){
    self.shieldMax = 4000;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0.33;
  }
  
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 2000;
  }
  
  //fine, you don't want power plants in YOUR map <chuckle>
  if( !self.energy ){
    self.energy = 0;
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
  self.th_die = hshield_die;
  self.use = multi_trigger;
  hshield_th();
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }
};