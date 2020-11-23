/*
battleMETAL 
Author: Peter Roohr
10/29/2020 - nodegraph
Overview: ai nodes
  all the various nodes needed for the game
*/

//NODEGRAPH API-----------------------------------
//simple, clears out entire path, used generally when bot spawns,
//because values MUST be -1; (nodeID 0 is a valid ID).
void() ai_nodegraph_clear_path={
  self.nq1 = -1;
  self.nq2 = -1;
  self.nq3 = -1;
  self.nq4 = -1;
  self.nq5 = -1;
  self.nq6 = -1;
  self.nq7 = -1;
  self.nq8 = -1;
  self.nq9 = -1;
  self.nq10 = -1;
  self.nq11 = -1;
  self.nq12 = -1;
  self.nq13 = -1;
  self.nq14 = -1;
  self.nq15 = -1;
  self.nq16 = -1;
  self.nq17 = -1;
  self.nq18 = -1;
  self.nq19 = -1;
  self.nq20 = -1;
  self.nq21 = -1;
  self.nq22 = -1;
  self.nq23 = -1;
  self.nq24 = -1;
};

/*
  makes sure to clear any lingering node block flags
*/
void() ai_nodegraph_clear_locks={
  local float nodeItr;
  
  while( nodeItr < NODE_ID_COUNT ){
    if( NODEGRAPH_DATA_BLOCK[nodeItr] == self.entnum ){
      NODEGRAPH_DATA_BLOCK[nodeItr] = FALSE;
    }
    nodeItr = nodeItr + 1;
  }
};

/*
  AI spawn edge-case.
  Assists mappers when placing AI, it scans for the closest node to the AI when the AI spawns in.
  
  IF that node is too close (128 units or less) AND the node is not blocked by another ent, mark it as blocked.
  
  This way, bots have a better idea of the nodegraph state as they spawn in, allowing moving bots to know
  if a just-ini'd bot is in the way.
*/
void() ai_nodegraph_mark_start={
  local float nodeItr;
  local float nodeDist;
  local float foundNode;
  local float testLen;
  
  node_t proxNode;
  nodeDist = 64;
  foundNode = -1;
  
  for( nodeItr = 0; nodeItr < NODE_ID_COUNT; nodeItr = nodeItr + 1){
    proxNode = NODEGRAPH_DATA[nodeItr];
    if( proxNode.id == -1 ){
      continue;
    }
    testLen = ai_check_dist_node( self.origin, proxNode.orig );
    if( testLen > nodeDist ){
      continue;
    }
    if( NODEGRAPH_DATA_BLOCK[nodeItr] == FALSE ){
      continue;
    }
    nodeDist = testLen;
    foundNode = nodeItr;
  }
  if( foundNode > -1 ){
    //mark as blocked, set nq1 reference to node id, so that it will be cleared when the AI calls their trace_route for the first time.
    NODEGRAPH_DATA_BLOCK[nodeItr] = self.entnum;
    self.nq1 = nodeItr;
  }
};

/*
  updates .nodeQueue slots, returns FALSE if there are no nodes left in the path.
*/
float() ai_nodegraph_next={
  
  NODEGRAPH_DATA_BLOCK[self.nq1] = FALSE; //always make sure AI clears the last node because AI has arrived here.
    
  self.nq1 = self.nq2;
  self.nq2 = self.nq3;
  self.nq3 = self.nq4;
  self.nq4 = self.nq5;
  self.nq5 = self.nq6;
  self.nq6 = self.nq7;
  self.nq7 = self.nq8;
  self.nq8 = self.nq9;
  self.nq9 = self.nq10;
  self.nq10 = self.nq11;
  self.nq11 = self.nq12;
  self.nq12 = self.nq13;
  self.nq13 = self.nq14;
  self.nq14 = self.nq15;
  self.nq15 = self.nq16;
  self.nq16 = self.nq17;
  self.nq17 = self.nq18;
  self.nq18 = self.nq19;
  self.nq19 = self.nq20;
  self.nq20 = self.nq21;
  self.nq21 = self.nq22;
  self.nq22 = self.nq23;
  self.nq23 = self.nq24;
  self.nq24 = -1;
  
  if( self.nq1 == -1 ){
    //end of queue
    return FALSE;
  }
  
  if( NODEGRAPH_DATA_BLOCK[self.nq1] > FALSE && NODEGRAPH_DATA_BLOCK[self.nq1] != self.entnum ){
    //requested next node was occupied by someone else.
    return FALSE;
  }
  
  NODEGRAPH_DATA_BLOCK[self.nq1] = self.entnum;
  
  return TRUE;
};

/*
  ai_nodegraph_trace_vec_route() is the core tracing func for the AI.
  
  generally maintain 1 func that calls most of the nodegraph stuff to keep func jumps low.
    Its advised that you wrap nodegraph_trace() with other functions though, which
    is more maintainable.
*/
float( float startId, float endId ) ai_nodegraph_trace_route={
  
  local float traceEndId;
  local float pathCnt;
  
  ai_nodegraph_clear_locks();
  
  if( startId == -1 ){
    return FALSE;
  }
  
  if( endId == -1 ){
    return FALSE;
  }
  traceEndId = nodegraph_trace(startId, endId);
  if( traceEndId > -1 ){
    pathCnt = nodegraph_build_path( startId, traceEndId );
    if( pathCnt > -1 ){
      self.pathEndId = NODEGRAPH_SEARCH_PATH[0];  //set the end node so we can remember the end if we need to.
      ai_nodegraph_clear_path();
      
      pathCnt = ai_nodegraph_set_queue_val( nq1, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq2, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq3, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq4, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq5, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq6, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq7, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq8, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq9, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq10, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq11, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq12, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq13, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq14, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq15, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq16, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq17, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq18, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq19, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq20, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq21, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq22, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq23, pathCnt );
      pathCnt = ai_nodegraph_set_queue_val( nq24, pathCnt );
      
      if( self.nq1 > -1 ){
        return TRUE;
      }
    }
  }
  
  return FALSE;
};

float( .float queueVar, float pathCountVal ) ai_nodegraph_set_queue_val={
  if( -1 < pathCountVal ){
    self.queueVar = NODEGRAPH_SEARCH_PATH[pathCountVal];
    return pathCountVal - 1;
  }
  return -1;
};

float( float nodeStartId, float nodeEndId ) ai_nodegraph_trace_norm={
  
  local float traceStat;
  local float startNode;
  local float endNode;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  traceStat = ai_nodegraph_trace_route( nodeStartId, nodeEndId );
  
  return traceStat;
};

/*
  Wraps ai_nodegraph_trace_route() by allowing VECTOR input
*/
float( vector startPos, vector endPos ) ai_nodegraph_trace_vec={
  
  local float traceStat;
  local float startNode;
  local float endNode;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  startNode = ai_nodegraph_to_org( startPos, TRUE );
  endNode = ai_nodegraph_to_org( endPos, TRUE );
  
  traceStat = ai_nodegraph_trace_route( startNode, endNode );
  
  return traceStat;
};

/*
  Wraps ai_nodegraph_trace_route() by allowing VECTOR input for src, but you know the endId
*/
float( vector startPos, float endId ) ai_nodegraph_trace_vecToNode={
  
  local float traceStat;
  local float startNode;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  startNode = ai_nodegraph_to_org( startPos, TRUE );
  
  traceStat = ai_nodegraph_trace_route( startNode, endId );
  
  return traceStat;
};
//given a known endId, and a map org

/*
  Wraps ai_nodegraph_trace_route() by allowing NODE ID input for start, and you want to find closest node to a map position.
*/
float( float startId, vector endPos ) ai_nodegraph_trace_nodeToVec={
  
  local float traceStat;
  local float endNode;
  
  if( time < self.ai_timer_tracepath ){
    return FALSE;
  }
  self.ai_timer_tracepath = time + (0.5 + (random() * 1.5));
  
  endNode = ai_nodegraph_to_org( endPos, TRUE );
  
  traceStat = ai_nodegraph_trace_route( startId, endNode );
  
  return traceStat;
};

/*
  Find closest node to a desire map point (usually self, or target ai_node).
  Make sure that node is WALKABLE to that spot.
*/
float( vector testOrg, float checkLock ) ai_nodegraph_to_org={

  local float minDist;
  local float nodeItr;
  
  node_t closeNode;
  
  local float aNode;
  
  local vector ndOrg;
  local float testDist;
  local float testVis;
  
  aNode = -1;
  minDist = 1024;
  for( nodeItr = 0; nodeItr < NODE_ID_COUNT; nodeItr = nodeItr + 1){
    closeNode = NODEGRAPH_DATA[nodeItr];
    
    if( closeNode.id == -1 ){
      continue;
    }
    
    if( checkLock ){
      if( NODEGRAPH_DATA_BLOCK[nodeItr] > FALSE && NODEGRAPH_DATA_BLOCK[nodeItr] != self.entnum ){
        continue;
      }
    }
    
    ndOrg = closeNode.orig;
    testDist = ai_check_dist_node(testOrg, ndOrg);
    if( testDist > minDist ){
      continue;
    }
    
    testVis = ai_check_terrain_move( testOrg, ndOrg ); 
    if( !testVis ){
      continue;
    }
    
    minDist = testDist;
    aNode = nodeItr;
  }
  return aNode;
};

float( vector testOrg , float ignoreId, float checkLock ) ai_nodegraph_to_org_filter={
    local float minDist;
  local float nodeItr;
  
  node_t closeNode;
  
  local float aNode;
  
  local vector ndOrg;
  local float testDist;
  local float testVis;
  
  aNode = -1;
  minDist = 1024;
  for( nodeItr = 0; nodeItr < NODE_ID_COUNT; nodeItr = nodeItr + 1){
    closeNode = NODEGRAPH_DATA[nodeItr];
    
    if( closeNode.id == -1 ){
      continue;
    }
    
    if( ignoreId != -1 && closeNode.id == ignoreId ){
      continue;
    }
    
    if( checkLock ){
      if( NODEGRAPH_DATA_BLOCK[nodeItr] > FALSE && NODEGRAPH_DATA_BLOCK[nodeItr] != self.entnum ){
        continue;
      }
    }
    
    ndOrg = closeNode.orig;
    testDist = ai_check_dist_node(testOrg, ndOrg);
    if( testDist > minDist ){
      continue;
    }
    
    testVis = ai_check_terrain_move( testOrg, ndOrg ); 
    if( !testVis ){
      continue;
    }
    
    minDist = testDist;
    aNode = nodeItr;
  }
  return aNode;
};

void() ai_nodegraph_debug_queue={

  dprint("*****************NODE QUEUE THIS FRAME ************************\n");  //debug
  dprint(sprintf("    nq1 = %s\n", ftos(self.nq1)));  //debug
  dprint(sprintf("    nq2 = %s\n", ftos(self.nq2)));  //debug
  dprint(sprintf("    nq3 = %s\n", ftos(self.nq3)));  //debug
  dprint(sprintf("    nq4 = %s\n", ftos(self.nq4)));  //debug
  dprint(sprintf("    nq5 = %s\n", ftos(self.nq5)));  //debug
  dprint(sprintf("    nq6 = %s\n", ftos(self.nq6)));  //debug
  dprint(sprintf("    nq7 = %s\n", ftos(self.nq7)));  //debug
  dprint(sprintf("    nq8 = %s\n", ftos(self.nq8)));  //debug
  dprint(sprintf("    nq9 = %s\n", ftos(self.nq9)));  //debug
  dprint(sprintf("    nq10 = %s\n", ftos(self.nq10)));  //debug
  dprint(sprintf("    nq11 = %s\n", ftos(self.nq11)));  //debug
  dprint(sprintf("    nq12 = %s\n", ftos(self.nq12)));  //debug
  dprint(sprintf("    nq13 = %s\n", ftos(self.nq13)));  //debug
  dprint(sprintf("    nq14 = %s\n", ftos(self.nq14)));  //debug
  dprint(sprintf("    nq15 = %s\n", ftos(self.nq15)));  //debug
  dprint(sprintf("    nq16 = %s\n", ftos(self.nq16)));  //debug
  dprint(sprintf("    nq17 = %s\n", ftos(self.nq17)));  //debug
  dprint(sprintf("    nq18 = %s\n", ftos(self.nq18)));  //debug
  dprint(sprintf("    nq19 = %s\n", ftos(self.nq19)));  //debug
  dprint(sprintf("    nq20 = %s\n", ftos(self.nq20)));  //debug
  dprint(sprintf("    nq21 = %s\n", ftos(self.nq21)));  //debug
  dprint(sprintf("    nq22 = %s\n", ftos(self.nq22)));  //debug
  dprint(sprintf("    nq23 = %s\n", ftos(self.nq23)));  //debug
  dprint(sprintf("    nq24 = %s\n", ftos(self.nq24)));  //debug
  dprint("*****************************************\n");  //debug

};

//=============MAP NODE ENTS===========================================
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

  self.flags = self.flags | FL_NODE;
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
  
  self.pathEndId = ai_nodegraph_to_org( self.origin, FALSE );  //snap patrolnode to nodegraph
  self.compOffset = nodegraph_get_node_origin( self.pathEndId );
  if( self.target ){
    nexNode = find(world, targetname, self.target );
    if( nexNode ){
      //nexNode.partTypeId = self.partTypeId + 1;
      //nexNode.partPrev = self;
      self.partNext = nexNode;
     //dprint(sprintf("%s - nearby node id %s - and next node %s \n", self.targetname, ftos(self.pathEndId), self.partNext.targetname ));  //debug 
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
    //if( cvar("developer") ){
     // cons_logAVector(self.classname, self.origin); //debug
      //cons_logAFloat(self.classname, self.ai_view);
    //}
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
  self.nextthink = time + 0.1;
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
    self.effects = self.effects | EF_NOSHADOW;
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
  
  self.dphitcontentsmask = (DPCONTENTS_SOLID | DPCONTENTS_MONSTERCLIP | DPCONTENTS_DONOTENTER | DPCONTENTS_BOTCLIP | DPCONTENTS_BODY | DPCONTENTS_OPAQUE);
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