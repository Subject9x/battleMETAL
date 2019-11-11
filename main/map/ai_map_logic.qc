/*
battleMETAL
Author: Peter Roohr
Date: 3/2/2018
Overview: ai objects used for map logic
*/

void() ai_change_faction_use={
  local entity e;
  if( (self.spawnflags & 4) ){
    if( time < self.nextthink)
      return;
    self.think = ai_change_faction_use;
    self.nextthink = time + self.delay;
    return;
  }
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      e.faction = self.faction;
      e = e.chain;
    }
  }
  if(self.target){
    e = world;
		do{
			e = find(e, targetname, self.target);
			if (!e)
				return;
			e.faction = self.faction;
		} while ( 1 );
  }
  if( (self.spawnflags & 2) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_change_rank_use={
  local entity e, this;
  local float m;
  if( (self.spawnflags & 4) ){
    if( time < self.nextthink)
      return;
    self.think = ai_change_rank_use;
    self.nextthink = time + self.delay;
    return;
  }
  
  if(self.group){
    e = findchain(group, self.group);
    while(e){
      self = e;
        self.ai_rank = this.ai_rank;
      self = this;
      e = e.chain;
    }
  }
  if(self.target){
    e = find(world, targetname, self.target);
    if(e){
      self = e;
        self.ai_rank = this.ai_rank;
      self = this;
    }
  }
  if( (self.spawnflags & 2) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

/*QUAKED ai_change_faction (0.988 0.976 0.267) (-16 -16 -16) (16 16 16) START_OFF REMOVE_ONUSE DELAY_FIRE
changes the faction field of the targeted objects

-------- KEYS --------
.faction    <float> [faction id] - the faction to set the target to
.group        <string> [group] objects with this groupId will be affected
.target        <string> [targetname] objects with this targetname will be affected
.targetname    <string> [targetname] - for being called by other objects
.wait        <float> [time] - use with []2 for delay-after-being-called
-------- SPAWNFLAGS -------- 
START_OFF 1: start inactive
REMOVE_ONUSE 2: removed after its first use.
DELAY 4: wait after fire before execution
*/
void() ai_change_faction={
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  util_MapDeveloperMarker();
  setsize( self, '-3 -3 -3', '3 3 3' );
  setorigin( self, self.origin );
  
  self.use = ai_change_faction_use;
  
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
    return;
  }
  self.isActive = TRUE;
};

/*QUAKED ai_change_rank (0.988 0.976 0.267) (-16 -16 -16) (16 16 16) START_OFF REMOVE_ONUSE DELAY_FIRE
changes the rank field of the targeted objects, this will then also execute a recalculation of
that unit's stats using the ai_stats.qc functions. This is useful for adjusting level difficulty at
runtime.

-------- KEYS -------- 
.group        <string> [group] objects with this groupId will be affected
.target        <string> [targetname] objects with this targetname will be affected
.targetname    <string> [targetname] - for being called by other objects
.ai_rank    <float> [rank] rank to change the targets ai_rank to.
.wait        <float> [time] - use with []2 for delay-after-being-called
-------- SPAWNFLAGS -------- 
START_OFF 1: start inactive
REMOVE_ONUSE 2: removed after its first use.
DELAY 4: wait after fire before execution
*/
void() ai_change_rank={
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  util_MapDeveloperMarker();
 
  setsize( self, '-3 -3 -3', '3 3 3' );
  setorigin( self, self.origin );
 
  self.use = ai_change_rank_use;
  
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
    return;
  }
  self.isActive = TRUE;
};
