/*
battleMETAL 
Author: Peter Roohr
Date: 7/17/2018
mod - 01/20/2019
Overview: ai nodes
  all the various nodes needed for the game
*/

void() ai_node_counter_th={
  local entity nearbot;
  local float countCheck;
  
  if( self.isActive ){
    countCheck = 0;
    for( nearbot = findradius(self.origin, self.ai_view); nearbot != world; nearbot = nearbot.chain){
      if( nearbot.data_type == DATA_BLD ){
        continue;
      }
      if( nearbot.faction != self.faction ){
        continue;
      }
      if( !ai_valid_target(nearbot) ){
        continue;
      }
      countCheck = countCheck + 1;
    }
    if( countCheck >= self.count ){
      if( self.trigOnAttack != "" ){
        trigger_event( self, self.trigOnAttack );
        self.trigOnAttack = "";
        self.think = SUB_Null;
        self.nextthink = time + 0.1;
        return;
      }
    }
  }
  self.think = ai_node_counter_th;
  self.nextthink = time + 1;
};

void() node_use={
  if( !self.isActive ){
    self.isActive = TRUE;
    trigger_event( self, self.trigOnSpawn );
    if( self.classname == "ai_node_counter" ){
      self.think = ai_node_counter_th;
      self.nextthink = time + 1;
    }
  }
};

/*
  common ini for any node entity
*/
void() node_setup={

  self.flags = FL_NODE;
  self.data_type = DATA_NODE;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.isActive = TRUE;
  
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  setsize(self, '-10 -10 -18','10 10 18');
  setorigin(self, self.origin);
  
  trigger_event( self, self.trigOnSpawn );
  if( !self.pausetime ){
    self.pausetime = ((4 - skill) * -1) * 1.65; 
  }
};

/*
  Map now links patrol nodes together into custom linked-list, and adds .owner as the end node in the chain
  for querying.
*/
void() ai_node_check={
  local entity nexNode;
  local float contentCache;

  if( self.target || self.target != "" ){
    nexNode = find(world, targetname, self.target );
    if( nexNode ){
      if( nexNode.data_idx <= 0){
        nexNode.partTypeId = self.partTypeId + 1;
        nexNode.partPrev = self;
        self.partNext = nexNode;
      }
    }
    else{
      if( cvar("developer") ){
        cons_log2Strings("node", self.targetname, "can't find target of", self.target);  //DEBUG
      }
      self.target = "";
    }
  }
  if( self.classname == "ai_node_counter" ){
    self.think = ai_node_counter_th;
    self.nextthink = time + 1;
  }
  else{
    if( !self.ai_view ){
      local float minDist;
      local float checkDist;
      local float itr;
      local vector checkAng;
      minDist = AI_RANGE_M;
      itr = 0;
      checkAng = '0 0 0';
      contentCache = self.dphitcontentsmask;
      self.dphitcontentsmask = (DPCONTENTS_BOTCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP);
      while( itr < 12 ){
        checkAng_y = itr * 30;
        makevectors(checkAng);
        tracebox(self.origin - (v_up * 5), '-10 -10 -9', '10 10 9', self.origin - (v_up * 5) + (v_forward * AI_RANGE_M), MOVE_NORMAL, self);
        checkDist = vlen(trace_endpos - self.origin);
        minDist = minDist + checkDist;
        itr = itr + 1;
      }
      self.ai_view = max(minDist / 12, 100);
      self.dphitcontentsmask = contentCache;
    }
    if( cvar("developer") ){
      cons_logAVector(self.classname, self.origin); //debug
      cons_logAFloat(self.classname, self.ai_view);
    }
  }
};


/*QUAKED ai_node (0.988 0.976 0.267) (-10 -10 -18) (10 10 18) - START_INACTIVE

This is used to setup patrol and move paths for AI.
For best results, place manually as close to ground as possible!

!NOTE! Make sure nodes can reliably see each other around walls and steep floors!
when in doubt, add more nodes, because the bot uses these to 'see' around corners
in their patrol path.

-------- KEYS -------- 
.faction = <float> [faction number]
.targetname = <string> used by AI to find node
.target = <string> should target another AI node to form a chain
.trigOnDeath = <string> [target] trigger this item when node is removed
.trigOnSpawn = <string> [target] trigger this item when node isActive = true;

-------- SPAWNFLAGS -------- 
START_INACTIVE 1: start with .isActive = FALSE
*/
void() ai_node={
  
  if ( !self.targetname ){
    objerror (strcat("[ERROR] ai_node (", vtos(self.origin),") - missing targetname!"));
    return;
  }
  self.angles = '0 0 0';
  node_setup();
  //set the collision filter to help AI when making traceline calls.
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  self.think = ai_node_check;
  self.nextthink = time + 0.01;
};


void() node_counter_die={
  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};

/*QUAKED ai_node_counter (0.988 0.5 0.267) (-10 -10 -18) (10 10 18) - START_INACTIVE

Special node; this actively counts how many bots are near this node,
firing off .trigOnAttack when the .count is reached.

This is used to setup patrol and move paths for AI.
For best results, place manually as close to ground as possible!

ai_view = 100 [default]

-------- KEYS -------- 
.count = <float> [2]number of bots that need to be in-radius.
.ai_view = <float> range to check for units.
.faction = <float> [faction number]
.targetname = <string> used by AI to find node
.target = <string> should target another AI node to form a chain
.trigOnDeath = <string> [target] trigger this item when node is removed
.trigOnAttack = <string> [target] trigger this when .count limit is hit.
.isActive = <float> [1] on/off, default ON.

-------- SPAWNFLAGS -------- 
START_INACTIVE 1: start with .isActive = FALSE
*/
void() ai_node_counter={
  
  if ( !self.targetname || self.targetname == "" ){
    objerror (strcat("[ERROR] ai_node_counter (", vtos(self.origin),") - missing targetname!"));
    return;
  }
  if( !self.trigOnAttack || self.trigOnAttack == "" ){
    objerror (strcat("[ERROR] ai_node_counter (", vtos(self.origin),") - missing trigOnAttack!"));
    return;
  }
  node_setup();
  self.th_die = node_counter_die;
  
  if( !self.target ){
    self.target = "";
  }
  
  if( self.ai_view == 0 || !self.ai_view ){
    self.ai_view = 250;
  }
  if( self.count == 0 || !self.count  ){
    self.count = 2;
  }
  self.think = ai_node_check;
  self.nextthink = time + 0.5;
};

/*QUAKED ai_node_tether (0.988 0.5 0.5) (-10 -10 -18) (10 10 18)
  Tether nodes help anchor AI to a specific location on the map.
  When an AI moves out of range of its tether, it will be compelled to make its way BACK
    to a random <vector> inside (ai_view / 4).
  
  AI WILL lookup these nodes when they spawn in!
  AI cannot accept a node with a pitch difference of > 45d
    ie: keep nodes on relativaly flat plane with AI's
  
For best results, place manually as close to ground as possible!

targetname = [REQUIRED]
ai_view = game-units of leash size. [default]AI_RANGE_M == 1000 
faction = faction matching, [default] FACTION_ALL == 255
-------- KEYS -------- 
.ai_view = <float> tether radius
.faction = <float> [faction number]
.targetname = <string> used by AI to find node

-------- SPAWNFLAGS -------- 
*/
void() ai_node_tether={
    
  if ( !self.targetname || self.targetname == "" ){
    //objerror (strcat("[ERROR] ai_node_tether (", vtos(self.origin),") - missing targetname!"));
    //return;
  }
 
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP);
  node_setup();
  self.pausetime = 0;
  
  self.think = ai_node_check;
  self.nextthink = time + 1;
};

/*QUAKED ai_node_path (0.988 0.75 0.5) (-10 -10 -18) (10 10 18)
  used with generating .nodes files for maps.
  
  AI will use this node data to pathfind their way to targets, and other ai_node types.
-------- KEYS -------- 

-------- SPAWNFLAGS -------- 
*/
void() ai_node_path={
  local vector sMin, sMax;
  
  if( cvar("developer") ){
    self.effects = self.effects | (EF_FULLBRIGHT | EF_NOSHADOW | EF_BLUE);
  }
  else{
    remove(self);
    return;
  }
  
  //assign then increment global node id counter, this saves us a for-loop at the export phase to establish IDs.
  //do not mess with these...ever
  self.data_idx = NODE_ID_EXPORT_COUNT;
  NODE_ID_EXPORT_COUNT = NODE_ID_EXPORT_COUNT + 1;
    
  sMin = '-10 -10 -18';
  sMax = '10 10 18';
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, sMin, sMax);
  setorigin(self, self.origin);
  

  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP | DPCONTENTS_BODY);
};

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
    entDist = vlen(ent.origin - self.origin);
    if( entDist > self.ai_view ){
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