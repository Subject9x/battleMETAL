/*
battleMETAL
Author: Peter Roohr
Date: 3/21/2018
Overview: 
  data file for the human repair bay
*/

void() building_repair_touch;
void() building_repair_node_think;  //cool down to prevent spam of notifications.

void() hrepair_th = [0, hrepair_th]{
  if( self.trigger_field.takedamage >= DAMAGE_YES){
    self.th_walk();
    return;
  }
  else{
    if(self.reloadValue < self.reloadMax){
      self.reloadValue = self.reloadValue + self.reloadRate;
      if(self.reloadValue > self.reloadMax){
        self.reloadValue = self.reloadMax;
      }
    }
  }
  building_burn();
};

void() hrepair_rep = [0, hrepair_rep]{
  local float end_repair;
  local entity repairMe,fix;  
  local entity part;
  local float lowHP;
  local float hp;
  local vector fx;
  fix = world;
  
  end_repair = TRUE;
  
  if( self.cockpit.attack_state == ST_WALK ){
    if( vlen(self.trigger_field.origin - self.cockpit.origin) <= 32){
      repairMe = self.trigger_field;
      if(csqc_updateCompStat(repairMe) < 100){
        fix = repairMe;
      }
      else{
        part = repairMe.partNext;
        lowHP = 99.99;
        while(part){
          if( part.deadflag <= DEAD_NO && (part.partTypeId != M_ITEM || part.partTypeId != M_CAMERA) ){
            
            hp = csqc_updateCompStat(part);
            if( hp < lowHP){
              lowHP = hp;
              fix = part;
            }
          }
          part = part.partNext;
        }
      }
      if( fix != world){
        end_repair = FALSE;
        makevectors(self.angles);
        fx = self.origin + (v_up * 75) + (v_forward * -24);
        pointparticles( particleeffectnum("TE_REPAIR_MUZZLE"), fx, normalize( fix.origin - fx ) * 3, 1);
        pointparticles( particleeffectnum("TE_REPAIR_IMPACT"), fix.origin, normalize( fix.origin - fx ) * -3, 1);
        trailparticles( world, particleeffectnum("TE_REPAIR_RAIL"), fx, fix.origin);

        fix.health = fix.health + (self.reloadRate * 2);
        self.reloadValue = self.reloadValue - (self.reloadRate * (self.trigger_field.vec_size * 1.25));
        if(fix.health >= fix.max_health){
          fix.health = fix.max_health;
          if( fix.partTypeId == M_LEGS ){
            if( (fix.flags & FL_DISARMED) ) {
              fix.flags = fix.flags - (fix.flags & FL_DISARMED);
              fix.owner.data_speed_forward = fix.data_speed_forward;
              fix.owner.data_speed_backward = fix.data_speed_backward;
              fix.owner.data_speed_strafe = fix.data_speed_strafe;
              fix.owner.data_speed_accel = fix.data_speed_accel;
            }
          }
        }
        self.trigger_field.stat_plr_rep = (self.reloadValue / self.reloadMax);
      }
    }
  }

  if(end_repair && self.cockpit.attack_state == ST_WALK ){
    self.trigger_field.flags = self.trigger_field.flags - (self.trigger_field.flags & FL_NOSHOOT);
    if( (self.trigger_field.flags & FL_CLIENT) ){
      client_send_event_weapons( self.trigger_field, TRUE );
      client_send_event_repairs( self.trigger_field, FALSE ) ;
    }
    self.trigger_field.stat_plr_rep = -1;
    self.trigger_field = world;
    self.th_stand();
    self.cockpit.think = building_repair_node_think;
    self.cockpit.nextthink = time + 3;
    self.cockpit.attack_state = ST_MELEE;
    
    world_update_dlight( self, -1, '0.25 0.9 0.15', 50, 2, '-1 -1 -1');
    
    return;
  }
};

void() hrepair_die = [0, hrepair_die1]{
  world_remove_dlight( self );
  
  //fire triggers when dead
  trigger_event( self, self.trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_NOT;
  building_die_removeFire();
  
};
void() hrepair_die1 = [1, hrepair_die2]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die2 = [2, hrepair_die3]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die3 = [3, hrepair_die4]{};
void() hrepair_die4 = [4, hrepair_die5]{};
void() hrepair_die5 = [5, hrepair_die6]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die6 = [6, hrepair_die7]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die7 = [7, hrepair_die8]{};
void() hrepair_die8 = [8, hrepair_die9]{};
void() hrepair_die9 = [9, hrepair_die10]{
  te_object_explode( '0.75 0.75 0.6' );
  
  self.deadflag = DEAD_DEAD;
  local entity ruins;
  ruins = spawn();
  ruins.solid = SOLID_NOT;
  ruins.movetype = MOVETYPE_NONE;

  setmodel(ruins, precache_model("q3mdl/map/ruins/ruin_large.obj"));
  ruins.vec_size = self.vec_size;
  ruins.angles = self.angles;
  ruins.angles_y = anglemod( 45 + crandom() * 125);
  setsize(ruins, ruins.mins, ruins.maxs * 0.75);
  setorigin(ruins, self.origin);
  ruins.armLeft = te_building_fire_start( ruins );
  if( ruins.vec_size > 1 ){
    ruins.armRight = te_building_fire_start( ruins );
    ruins.torsoLeft = te_building_fire_start( ruins );
  }  
};
void() hrepair_die10 = [10, hrepair_die11]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die11 = [11, BecomeExplosion]{
  te_object_explode( '0.75 0.75 0.6' );
};

/*QUAKED building_human_repair (0 0 1) (-53 -53 0) (53 53 40) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - - - IS_MAPKEY -
{ model("models/buildings/repair/repair.md3"); }
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
void() building_human_repair={
  self.data_idx = UI_BUILDING_repair_bay;
  self.data_type = DATA_BLD;
  self.vec_name = "Repair Bay";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 3;
  util_setModel("q3mdl/buildings/repair_bay/mdl_repair_bay.md3", self.skin, 0) ;
  util_setCollider(DAMAGE_YES, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(600, 600, 1, 100) ;
  setsize(self, '-53 -53 0', '53 53 40');
  self.shield = 0;
  self.shieldMax= 750;
  self.shieldRate= 1;
  
  if( skill > SKILL_REG ){
    self.reloadValue = 750;
    self.reloadMax = 750;
    self.reloadRate = 0.5;
  }
  else{
    self.reloadValue = 2000;
    self.reloadMax = 2000;
    self.reloadRate = 1;
  }
  
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  self.nextthink = time + 0.1;
  self.use = multi_trigger;
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  
  makevectors(self.angles);
  self.c_ofs = self.origin + (v_forward * -20) + (v_up * 30) + (v_right * 4);
  local entity repairNode, this;
  this  = self;
  repairNode = spawn();
  repairNode.effects = repairNode.effects | EF_NODRAW;
  repairNode.touch = building_repair_touch;
  repairNode.deadflag = DEAD_NO;
  repairNode.trigger_field = world;
  repairNode.owner = this;
  this.cockpit = repairNode;
  self = repairNode;
    util_setModel("q3mdl/testball.md3", repairNode.skin, 0) ;
    util_setCollider(FALSE, SOLID_TRIGGER, MOVETYPE_NONE) ;
    util_setHealthArmor(0, 0, 0, 0) ;
  self = this;
  setsize(repairNode, '-8 -8 -24', '8 8 32');
  setorigin(repairNode, this.c_ofs);
  
  self.th_die = hrepair_die;
  self.th_stand = hrepair_th;
  self.th_walk = hrepair_rep;
  
  local vector lightColor;
  if( self.faction == FACTION_PSC ){
    lightColor = '0.25 0.85 0.35';
  }
  else{
    lightColor = '0.95 0.25 0.15';
  }
  
  //setup dlights
  world_make_dlight( (self.origin + (v_up * 64) + (v_right * 32)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC, '-90 0 0', 0, 50);
  world_make_dlight( (self.origin + (v_up * 64) + (v_right * -28)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC, '-90 0 0', 0, 50); 
  world_make_dlight( (self.origin + (v_up * 64) + (v_right * 32) + (v_forward * -32)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC, '-90 0 0', 0, 50); 
  world_make_dlight( (self.origin + (v_up * 64) + (v_right * -28) + (v_forward * -32)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC, '-90 0 0', 0, 50); 
  
  world_make_dlight( (self.origin + (v_up * 10) + (v_right * 24)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW, '0 0 0', 0, 75); 
  world_make_dlight( (self.origin + (v_up * 10) + (v_right * -24)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW, '0 0 0', 0, 75); 
  world_make_dlight( (self.origin + (v_up * 10) + (v_right * 24) + (v_forward * -32)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW, '0 0 0', 0, 75); 
  world_make_dlight( (self.origin + (v_up * 10) + (v_right * -24) + (v_forward * -32)), self, 1, lightColor, 2, PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW, '0 0 0', 0, 75); 
  
  hrepair_th();
};

void() building_repair_touch={
  if( self.owner.trigger_field == world ){
    if(other.faction == self.owner.faction){
      if(self.owner.reloadValue > 0){
        if(util_getMechHpAverage(other) < 1){
          if( self.attack_state != ST_WALK ){
            self.owner.trigger_field = other;
            other.flags = other.flags | FL_NOSHOOT;
            client_send_event_weapons( self.owner.trigger_field, FALSE );
            client_send_event_repairs( self.owner.trigger_field, TRUE );
            self.touch = SUB_Null;
            self.attack_state = ST_WALK;
            world_update_dlight( self, 1, '-1 -1 -1', 0, -1, '-1 -1 -1');            
          }
        }
      }
    }
  }
  return;
};

void() building_repair_node_think={
  self.touch = building_repair_touch;
  self.attack_state = ST_STAND;
};  //cool down to prevent spam of notifications.

void() building_repair_die={
  self.cockpit.trigger_field = world;
  remove(self.cockpit);
  building_die();
};