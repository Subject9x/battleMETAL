/*
battleMETAL
Author: Peter Roohr
Date: 3/2/2018
Overview: ai objects used for map logic
*/



void() ai_exec_order_use={
  local entity ent;
  local entity thisNode;
  local float entDist;
  local float hasPatrol;
  local float hasEnemy;
  
  if( self.delay ){
    self.think = self.use;
    self.nextthink = time + self.delay;
    self.use = SUB_Null;
    return;
  }
  thisNode = self;
  if( self.trigOnSpawn || self.trigOnSpawn != "" ){
    hasPatrol = TRUE;
  }
    if( self.trigOnAttack || self.trigOnAttack != "" ){
    hasEnemy = TRUE;
  }
  for( ent = nextent(world); ent.faction == self.faction; ent = nextent(ent) ){
    if( !(ent.flags & FL_UNIT) ){
      continue;
    }
    if( ent.deadflag != DEAD_NO ){
      continue;
    }
    if( hasPatrol ){
      ent.target = strzone(self.trigOnSpawn);
    }
    if( hasEnemy ){
      ent.enemy = find(world, targetname, self.trigOnAttack);
    }
    if( ent.use ){
      self = ent;
        ent.use();
      self = thisNode;
    }
  }
};

/*QUAKED ai_exec_order (0.85 0.976 0.267) (-10 -10 -18) (10 10 18) - IN_RADIUS
  Super primitive order execution system:
  

targetname = [REQUIRED]
target = fires the desired trigger
trigOnAttack = update AI to target THIS enemy.
trigOnSpawn = update AI to THIS patrol node.
trigOnDeath = update AI's tether node to THIS.

faction = faction matching, [default] FACTION_ALL == 255
-------- KEYS -------- 
.targetname = <string> used by AI to find node
.faction = <float> [faction number]
.delay = <float> game seconds before firing.
.ai_view = <float> only for IN_RADIUS, default 100

-------- SPAWNFLAGS --------
IN_RADIUS 2 : will find any <faction> units in .ai_vew
*/
void() ai_exec_order={
  if ( !self.targetname || self.targetname == "" ){
    objerror (strcat("[ERROR] ai_exec_order (", vtos(self.origin),") - missing targetname!"));
    return;
  }
  if ( !self.target || self.target == "" ){
    objerror (strcat("[ERROR] ai_exec_order (", vtos(self.origin),") - missing target!"));
    return;
  }
  node_setup();
  self.pausetime = 0;
  
  if( !self.ai_view ){
    self.ai_view = 100;
  }
  self.use = ai_exec_order_use;
};



/*
  used by 
    ai_order_patrol()
    ai_order_exec_tether()
    
    given self.tether, pass this on to .target entities, and set them off to those behaviors.
*/
void() ai_order_exec_tether={
  local entity t;
  local entity ptrTarg;
  
  ptrTarg = find( world, targetname, self.message );
  
  if( !ptrTarg ){
    objerror (sprintf("[ERROR] ai_order_exec_tether (%s) - message entity [%s] not found!\n", vtos(self.origin), self.message));
    return;
  }
  if( ptrTarg.classname != "ai_node" || ptrTarg.classname != "ai_node_tether" ){
    objerror (sprintf("[ERROR] ai_order_exec_tether (%s) - message entity [%s] had wrong classname %s!\n", vtos(self.origin), self.message, ptrTarg.classname));
    return;
  }
  
  for(t = nextent(world); t != world; t = nextent(t) ){
    if( !(t.flags & FL_UNIT) ){
      continue;
    }
    if( t.deadflag != DEAD_NO ){
      continue;
    }
    if( t.targetname != self.target ){
      continue;
    }
    t.tether = self.tether;
    t.patrolNode = ptrTarg;
  }
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};
/*QUAKED ai_order_patrol (0.85 0.976 0.267) (-10 -10 -18) (10 10 18) ? ? NO_EASY NO_NORM NO_HARD NO_NIGHT
  single-use, removed after use!
  
  finds ALL entities of <TARGET>.
  FOR EACH
    + set self.tether = TETHER_PATROL
    + set self.target = <MESSAGE>
  
targetname = [REQUIRED]
target = [REQUIRED]
message = [REQUIRED]

-------- KEYS -------- 
.targetname = <string> used by AI to find node
.target = <string> 
.message = <string> the target [ai_node] path.
.delay = <float> game seconds before firing.
-------- SPAWNFLAGS --------
NO_EASY 2 : remove when skill = 0
NO_NORM 4 : remove when skill = 1
NO_HARD 8 : remove when skill = 2
NO_NIGHT 16 : remove when skill = 3
*/
void() ai_order_patrol={
  if ( !self.targetname || self.targetname == "" ){
    objerror (strcat("[ERROR] ai_order_patrol (", vtos(self.origin),") - missing targetname!"));
    return;
  }
  if ( !self.target || self.target == "" ){
    objerror (strcat("[ERROR] ai_order_patrol (", vtos(self.origin),") - missing target!"));
    return;
  }
  if ( !self.message ){
    objerror (strcat("[ERROR] ai_order_patrol (", vtos(self.origin),") - missing message!"));
    return;
  }
  node_setup();
  
  self.pausetime = 0;
  self.tether = TETHER_PATROL;
  
  self.use = ai_order_exec_tether;
};



/*QUAKED ai_order_tether(0.85 0.976 0.267) (-10 -10 -18) (10 10 18) ? ? NO_EASY NO_NORM NO_HARD NO_NIGHT
  single-use, removed after use!
  
  finds ALL entities of <TARGET>.
  FOR EACH
    + set self.tether = TETHER_PATROL
    + set self.target = <MESSAGE>
  
  
targetname = [REQUIRED]
target = [REQUIRED]
message = [REQUIRED]

-------- KEYS -------- 
.targetname = <string> used by AI to find node
.target = <string> 
.message = <string> the target [ai_node] path.
.delay = <float> game seconds before firing.
-------- SPAWNFLAGS --------
NO_EASY 2 : remove when skill = 0
NO_NORM 4 : remove when skill = 1
NO_HARD 8 : remove when skill = 2
NO_NIGHT 16 : remove when skill = 3
*/
void() ai_order_tether={
  if ( !self.targetname || self.targetname == "" ){
    objerror (strcat("[ERROR] ai_order_tether (", vtos(self.origin),") - missing targetname!"));
    return;
  }
  if ( !self.target || self.target == "" ){
    objerror (strcat("[ERROR] ai_order_tether (", vtos(self.origin),") - missing target!"));
    return;
  }
  if ( !self.message ){
    objerror (strcat("[ERROR] ai_order_tether (", vtos(self.origin),") - missing message!"));
    return;
  }
  node_setup();
  
  self.pausetime = 0;
  self.tether = TETHER_NODE;
  
  self.use = ai_order_exec_tether;
};








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
      if( e.data_type == DATA_BLD ){
        e.SendFlags = e.SendFlags | SENDFLAG_VELOCITY;
      }
      e = e.chain;
    }
  }
  if(self.target){
    e = world;
    do{
      e = find(e, targetname, self.target);
      if (!e){
        return;
      }
      e.faction = self.faction;
      if( e.data_type == DATA_BLD ){
        e.SendFlags = e.SendFlags | SENDFLAG_VELOCITY;
      }
    } while ( 1 );
  }
  if( (self.spawnflags & 2) ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_change_rank_use={
  local entity e, this;
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
  util_DeveloperNodeMark();
  
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
  util_DeveloperNodeMark();
 
  setsize( self, '-3 -3 -3', '3 3 3' );
  setorigin( self, self.origin );
 
  self.use = ai_change_rank_use;
  
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
    return;
  }
  self.isActive = TRUE;
};


entity lastDestination;
vector lastDestinationUp;
vector lastDestinationRight;
vector lastDestinationForward;

entity lastTeleTarg;

void() tele_source_touch={
  local entity shortTemp, shortOther;
  
  local vector testAngle;
  local vector testSpot;
  local float angleCount;
  local float testDistance;
  local float checkDist;
  if( (other.flags & FL_UNIT) && other.faction == self.faction ){
    other.solid = SOLID_NOT;
    if( lastDestination.targetname != self.target ){
      lastDestination = find(world, targetname, self.target);
      makevectors(lastDestination.angles);
      lastDestinationUp = v_up;
      lastDestinationRight = v_right;
      lastDestinationForward = v_forward;
    }
    checkDist = 32;
    testAngle_y = anglemod(lastDestination.angles_y + angleCount * 90);
    testAngle_x = lastDestination.angles_x;
    testAngle_z = lastDestination.angles_z;
    for(angleCount = 1; angleCount < 5; angleCount = angleCount + 1){
      testAngle_y = anglemod(testAngle_y + 90);
      makevectors(testAngle);
      traceline(lastDestination.origin, lastDestination.origin + (v_forward * (other.maxs_x * 3)) + (v_up * -256), MOVE_NORMAL, self);
      testDistance = vlen(trace_endpos - lastDestination.origin);
      if( testDistance >= checkDist ){
        checkDist = testDistance;
        testSpot = trace_endpos;
      }
    }
    //traceline(lastDestination.origin, lastDestination.origin + (v_forward * (checkDist - other.maxs_x / 2)), MOVE_NORMAL, self);
    if( testSpot == '0 0 0' ){
      testSpot = self.origin;
    }
    traceline( testSpot, testSpot + (v_up * (other.maxs_z * 3)) - (v_forward * (other.maxs_x * 0.5)), MOVE_NORMAL, other);
    setorigin(other, trace_endpos);
    other.angles = lastDestination.angles;
    other.flags = other.flags - other.flags & FL_ONGROUND;
    other.solid = SOLID_SLIDEBOX;
    if( lastDestination.target ){
      if( lastTeleTarg.targetname != lastDestination.target ){
        lastTeleTarg = find(world, targetname, lastDestination.target);
      }
      if( (lastTeleTarg.flags & FL_NODE) ){
        shortTemp = self;
        shortOther = other;
        self = shortOther;
          self.target = strzone(lastTeleTarg.targetname);
          self.movetarget = lastTeleTarg;
          self.goalentity = self.movetarget;
        self = shortTemp;
      }
    }
  }
};

/*QUAKED ai_teleportarium_source (0.33 0.33 0.33) (-24 -24 -12) (24 24 12)
+ teleports bots on-touch to the destination
+ this method preserves the bot offset from origin of THIS.
+ bot must have matching faction id.
-------- KEYS -------- 
.faction = <float> faction id.
*/
void() ai_teleportarium_source={
  if( !self.target ){
    dprint("ERROR: ai_teleportarium_source, missing target destination, removing!\n");
    remove(self);
    return;
  }
  self.touch = tele_source_touch;
  self.solid = SOLID_TRIGGER;
  setsize(self, '-24 -24 -12', '24 24 12');
  setorigin(self, self.origin);
};

/*QUAKED ai_teleportarium_dest (0.33 0.33 0.33) (-24 -24 -12) (24 24 12)
  destination of teleportarium
-------- KEYS -------- 
.angles = <vector> facing of destination.
.target = <string> use this as a .target for post-teleport.
*/
void() ai_teleportarium_dest={
  if( !self.targetname ){
    dprint("ERROR: ai_teleportarium_dest, missing targetname, removing!\n");
    remove(self);
    return;
  }
  setsize(self, '-24 -24 -12', '24 24 12');
  setorigin(self, self.origin);
};
