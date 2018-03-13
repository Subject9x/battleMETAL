/*
mech Mod
Author: Peter Roohr
Date: 2/1/2018
Overview: ai core implementation
*/
//============================
//   NODE QUACKERY         
//============================

/*
  Finds if the designated target (aggro) is within the AI_DEFEND_DIST
  of any defense nodes for group with groupId.
*/
float(entity aggro, string groupId) ai_node_defenseGroup_nodeToTarget={
  local float tDist, valid;
  local entity dNode;
  valid = FALSE;
  tDist =  vlen(aggro.origin - self.origin);
  dNode = findchain(group, groupId);
  while(dNode){
    if(dNode.isActive){
      local float nDist;
      nDist = vlen(aggro.origin - dNode.origin);
      if(nDist <= AI_RANGE_L){
        tDist = nDist;
        valid = TRUE;
      }
    }
    dNode = dNode.chain;
  }
  return valid;
};

/*
  given a target ent, find the closest defense node
  to that target, then plot a course to that node
*/
entity(entity aggro, string groupId) ai_node_defenseGroup_setCourse={
  local entity dNode, rNode;
  local float tDist, fDist;
  tDist = vlen(aggro.origin - self.origin);
  dNode = findchain(group, groupId);
  while(dNode){
    if(dNode.data_type == DATA_NODE){
      if(dNode.i_faction == self.i_faction){
        if(dNode.isActive == TRUE){
          local float nDist;
          nDist = vlen(aggro.origin - dNode.origin);
          if(nDist < tDist){
            tDist = nDist;
            rNode = dNode;
          }
        }
      }
    }
    dNode = dNode.chain;
  }
  if(rNode){
    return rNode;
  }
  return self.node;
};

/*
  finds a node based solely on the AI's groupId,
  regardless of vision, and ignores if the node
  isActive or not
*/
entity(string groupId) ai_node_searchGroup_ignoreActive={
  local entity tNode, rNode;
  local float pDist;
  pDist = self.radar_range;
  tNode = findchain(group, groupId);
  while(tNode){
    if(tNode.data_type == DATA_NODE){
      if(tNode.i_faction == self.i_faction){
        local float eDist;
        eDist = vlen(tNode.origin - self.origin);
        if(eDist < pDist){
          rNode = tNode;
        }
      }
    }
    tNode = tNode.chain;
  }
  return rNode;
};

/*
  finds a node based solely on the AI's groupId,
  regardless of vision, but node must be Active
*/
entity(string groupId) ai_node_searchGroup_checkActive={
  local entity tNode, rNode;
  local float pDist;
  pDist = self.radar_range;
  tNode = findchain(group, groupId);
  while(tNode){
    if(tNode.data_type == DATA_NODE){
      if(tNode.i_faction == self.i_faction){
        if(tNode.isActive == TRUE){
          local float eDist;
          eDist = vlen(tNode.origin - self.origin);
          if(eDist < pDist){
            pDist = eDist;
            rNode = tNode;
          }
        }
      }
    }
    tNode = tNode.chain;
  }
  return rNode;
};

/*
  loop search through the AI's patrol route to find
  the closest visible node, barring that, just return the
  closest node.
  self = AI making the call
*/
entity(entity pNode) ai_findNode_searchGroup={
  local entity tNode, rNode;
  local float tDist, pDist;
  pDist = vlen(pNode.origin - self.origin);
  tNode = findchain(group, pNode.group);
  traceline(self.e_cam.origin, pNode.origin, FALSE, self);
  if(trace_fraction >= 0.85){
    return pNode;
  }
  while(tNode){
    if(tNode.data_type == DATA_NODE){
      if(tNode.i_faction == self.i_faction){
        if(tNode.isActive == TRUE){
          traceline(self.e_cam.origin, tNode.origin, TRUE, self);
          if(trace_fraction >= 0.9){
            local float eDist;
            eDist = vlen(tNode.origin - self.origin);
            if(eDist < pDist){
              rNode = tNode;
            }
          }
        }
      }
    }
    tNode = tNode.chain;
  }
  return rNode;
};

/*
  used mostly by AI's with assault orders, this finds an enemy contact
  that is closes to the AI invoking the call BUT also near an assault node.
*/
entity(entity aNode) ai_node_closestTargNearNode={
  local entity found, contact;
  local float nDist;
  nDist = AI_ASSAULT_DIST;
  contact = found = world;
  contact = findradius(aNode.origin, nDist);
  while(contact){
    if(ai_target_isValid(contact)){
      if(ai_target_isValid_useDataType(contact)){
        local float cDist;
        cDist = vlen(contact.origin - aNode.origin);
        if(cDist < nDist){
          nDist = cDist;
          found = contact;
        }
      }
    } 
    contact = contact.chain;
  }
  return found;
};
//============================
//   COMBAT SHENANIGANS
//============================
/*
  How many friendlies have this entity targeted?
*/
float(entity targ, float faction) ai_combat_locksOnTarget={
  local entity f;
  local float cont;
  cont = 0;
  f = findchainfloat(i_faction, faction);
  while(f){
    if( (f.trigger_field == targ) ){
      cont = cont + 1;
    }
    f = f.chain;
  }
  return cont;
};

/*
  ai_target_visible
    determines if an entity can be seen by caller
    -ported from classic qc
*/
float(entity targ) ai_target_canSee={
  local vector eyes;
  makevectors(self.angles);
  eyes = self.origin + (v_up * self.maxs_z);
  traceline(eyes, targ.origin + (v_up * (targ.maxs_z / 2) ), FALSE, self);
  if( trace_ent == targ ){
    return TRUE;
  }
  return FALSE;
};

/*
  Identical to ai_target_canSee, except returns the thing
  that's blocking the way, also make's sure the AI is looking
  at the target.
*/
entity(entity targ) ai_target_checkBlock={
  if(ai_target_inForwardArc(targ)){
    tracebox(targ.origin, targ.absmin, targ.absmax, self.origin, FALSE, self);
    if(ai_target_isValid_useDataType(trace_ent)){
      return trace_ent;
    }    
  }
  return world; //really should have made a null ent, there, iD.
};

/*
  checks to see if target is in the AI's forward (90ish deg) arc
*/
float(entity targ) ai_target_inForwardArc={
  local vector v;
  local float d;
  makevectors(self.angles);
  v = normalize(targ.origin - self.origin);
  d = v * v_forward;
  if( d > 0.3){
    return TRUE;
  }
  return FALSE;
};

/*
traceline formula like how player radar works
  assumes target passed through ai_target_isValid()
  and radar mode is ACTIVE (TRUE)
*/
float(entity t) ai_target_radarPing={
  local vector ang, radorg, torg;
  local float radFidelityY, radFidelityZ;
  torg = t.origin;
  torg_z = torg_z + t.maxs_z + 4;
  radFidelityZ = (self.radar_range * ai_pilot_yaw_mod()) * 0.25;
  radFidelityY = (RADAR_PASSIVE_ARC_PLAYER_y * ai_pilot_yaw_mod()) + self.maxs_y;
  ang = vectoangles(radorg - torg);
  makevectors(ang);
  radorg = self.origin + (v_up * radFidelityZ) + (v_forward * radFidelityY);
  traceline(radorg, torg , FALSE, self);
  
  if(trace_fraction >= 0.9){
    return TRUE;
  }
  return FALSE;
};

/*
traceline formula like how player radar works
  assumes target passed through ai_target_isValid()
  and radar mode is PASSIVE (FALSE)
  uses self.e_cam as the origin to represent 'true LoS'
*/
float(entity t) ai_target_visualPing={
  local float delt;
  local vector torg;
  torg = t.origin;
  torg_z = torg_z + t.maxs_z + 4;
  delt = 16; //adjust trace origin
  makevectors(vectoangles(self.origin - t.origin));
  traceline( self.e_cam.origin + (v_forward * delt), torg , TRUE, self);
  
  if(trace_fraction >= 0.85){
    if(trace_ent == self.trigger_field){
      return TRUE;
    }
    return FALSE;
  }
  return FALSE;
};

/*
  validate possible target
*/
float(entity t) ai_target_isValid={
  if(!t){
    //dead simple check
    return FALSE;
  }
  if(t == world){
    return FALSE;
  }
  if(t == self){
    return FALSE;
  }
  if(t.owner == self){
    return FALSE;
  }
  if(t.data_type == DATA_POBS){
    return FALSE;
  }
  if(t.deadflag >= DEAD_DYING){
    return FALSE;
  }
  if(t.health <= 0){
    return FALSE;
  }
  if(t.classname == MECH_PIECE){
    return FALSE;
  }
  if(t.i_faction == self.i_faction){
    return FALSE;
  }
  return TRUE;
};

/*
  validate possible target using data_type
  field, used by blocking checker
*/
float(entity t) ai_target_isValid_useDataType={
  if(t.data_type == DATA_MECH){
    return TRUE;
  }
  else if(t.data_type == DATA_VEHC){
    return TRUE;
  } 
  else if(t.data_type == DATA_BLD){
    return TRUE;
  } 
  else if(t.data_type == DATA_MECH_AI){
    return TRUE;
  } 
  else if(t.data_type == DATA_PLR){
    return TRUE;
  }
  return FALSE;
};

/*
  when acquiring targets, only specific data_types
  should be checked
*/
float(entity t) ai_target_validType={
  if(t.data_type == DATA_MECH){
    return TRUE;
  } 
  if(t.data_type == DATA_VEHC){
    return TRUE;
  } 
  if(t.data_type == DATA_BLD){
    return TRUE;
  } 
  if(t.data_type == DATA_PLR){
    return TRUE;
  } 
  if(t.data_type == DATA_MECH_AI){
    return TRUE;
  } 
  return FALSE;
};

/*
visually spots an enemy in 'front' of it
*/
entity() ai_target_visualTarget={
  local float tDist;
  local entity t, p;
  if(self.stat_rdr_mode){
    tDist = self.radar_range / 2;
  }
  else{
    tDist = self.radar_range;
  }
  tDist = tDist * ai_pilot_yaw_mod(); //better pilots are better at spotting
  t = findradius(self.origin, tDist);
  while(t){
    if( ai_target_isValid(t) ){
      if(  ai_target_validType(t) ){
        if( ai_target_inForwardArc(t) ){
          if( ai_target_visualPing(t) ){
             local float fDist;
             fDist = vlen(t.origin - self.origin);
             if(fDist < tDist){
                p = t;
                tDist = fDist;
             }
          }
        }
      }
    }
    t = t.chain;
  }
  return p;
};

/*
finds enemy based on active radar
  assumes AI flipped its radar mode to ACTIVE 
  stat_rdr_mode = TRUE;
*/
entity() ai_target_radarTarget={
  local float tDist;
  local entity t, p;
  //only active radar works here
  if(self.stat_rdr_mode){
    tDist = self.radar_range;
    t = findradius(self.origin, self.radar_range);
    while(t){
      if( ai_target_isValid(t) ){
        if(  ai_target_validType(t) ){
          local float fDist;
          fDist = vlen(t.origin - self.origin);
          //target's ACTIVE radar makes detecting easier
          if(t.stat_rdr_mode){
            if(fDist < tDist){
              if(ai_target_radarPing(t)){
                p = t;
                tDist = fDist;
              }
            }   
          }
          else{
            if(fDist <= (self.radar_range / 2)){
              if(fDist < tDist){
                if(ai_target_radarPing(t)){
                  p = t;
                  tDist = fDist;
                }
              }  
            }
          }
        }
      }
      t = t.chain;
    }
  }
  return p;
};

/*
  pretty much radar target impl but 
  ignores the existing target (filter)
*/
entity(entity filter) ai_target_radarTarget_other={
 local float tDist;
  local entity t, p;
  //only active radar works here
  if(self.stat_rdr_mode){
    tDist = self.radar_range;
    t = findradius(self.origin, self.radar_range);
    while(t){
      if(ai_target_isValid(t)){
        if(  ai_target_validType(t) ){
          if(t != filter){
            local float fDist;
            fDist = vlen(t.origin - self.origin);
            //target's ACTIVE radar makes detecting easier
            if(t.stat_rdr_mode){
              if(fDist < tDist){
                if(ai_target_radarPing(t)){
                  p = t;
                  tDist = fDist;
                }
              }   
            }
            else{
              if(fDist <= (self.radar_range / 2)){
                if(fDist < tDist){
                  if(ai_target_radarPing(t)){
                    p = t;
                    tDist = fDist;
                  }
                }  
              }
            }
          }
        }
      }
      t = t.chain;
    }
  }
  return p;
};

/*
  Reset AI's entity buffers
  only the enemy and goalentity
*/ 
void() ai_target_clearBuffers={
  self.trigger_field = world;
  self.oldenemy = world;
  self.enemy = world;
  self.goalentity = world;
};

/*
  determines if AI's angle is in line with its ideal yaw
  this is check before the ai makes an attack
*/
float() ai_target_facingideal={
  local	float	delta;
  delta = anglemod( self.angles_y - self.ideal_yaw);
  //if (delta > 45 && delta < 315)
  if (delta > 25 && delta < 335){
    return FALSE;
  }
  return TRUE;
};

/*
  checks to see if the target is in the forward
  arc of this unit
*/
float(entity targ) ai_target_isInFront={
  local vector v;
  local float d;
  makevectors(targ.angles);
  v = normalize(self.origin - targ.origin);
  d = v * v_forward;
  if( d > 0.3){
    return TRUE;
  }
  return FALSE;
};

/*
  Short mod to ai_target_isInFront(),
  switches perspective to a unit's target
  to see if target is heading this way
*/
float(entity targ) ai_target_isFacingThis={
  local float bool;
  local entity this;
  bool = FALSE;
  this = self;
    self = targ;
    bool = ai_target_isInFront(this);
  self = this;
  return bool;
};

//============================
//   UPDATE FUNCTIONS
//============================
/*
  Updates an AI .goalentity / .enemy to its target (.trigger_field)
*/
void(entity newTarget) ai_update_switchToTarget={
  //maybe AI has room for old target 
  if(self.oldenemy == world){
    self.oldenemy = self.trigger_field;
  }
  self.trigger_field = newTarget;
  self.enemy = self.trigger_field;
  self.goalentity = self.trigger_field;
};

/*
  Updates an AI .goalentity / .enemy to a new node' (.node)
*/
void(entity newNode) ai_update_switchToNode={
  self.node = newNode;
  self.enemy = self.node;
  self.goalentity = self.node;
};

/*
  Changes an AI's combat ai_style
*/
void(float new_style) ai_update_combatStyle={
  if(self.ai_style != new_style){
    self.ai_style = new_style;
  }
};

/*
  Changes an AI's personality ai_type
*/
void(float new_type) ai_update_combatType={
  if(self.ai_type != new_type){
    self.ai_type = new_type;
  }
};

/*
  Change a target Ent's Group ID
*/
void(entity t, string groupId) ai_update_entityGroup={
  if(t.group){
    if(t.group != groupId){
      t.group = groupId;
    }
  }
};

/*
  Change an entity's current target
*/
void(entity t, string newTarg) ai_update_entityTarget={
  local entity test;
  //lets make sure this target even exists
  test = find(world, targetname, newTarg);
  if(test){
    if(t.target){
      if(t.target !=  newTarg){
        t.target = newTarg;
      }
    }
  }
};

/*
  makes AI resistant to changing targets too frequently
*/
void() ai_update_dmgTime={
  if(time > self.dmgtime){
    self.dmgtime = time + ai_core_hitTimeCalc();
  }
};

//============================
//      UTIL FUNCTIONS
//============================
/*
  only call this guy for non-static AI units
  (mechs and vecs), this converts the AI's
  state_1 value into the corresponding initial AI state
*/
void(float ai_state) ai_util_firstOrder_nonStatic={
 
  self.state_1 = ai_state;
  if(self.state_1 == AI_ORDER_ATTACK){
    if(self.target){
      ai_state_control(ai_assault_startWithNode);
    }
    else{
      ai_state_control(ai_assault_findNode);
    }
  }
  else if(self.state_1 == AI_ORDER_DEFEND){
    if(self.target){
      ai_state_control(ai_defend_startWithNode);
    }
    else{
      ai_state_control(ai_defend_findNode);
    }
  }
  else if(self.state_1 == AI_ORDER_PATROL){
    if(self.target){
      ai_state_control(ai_patrol_startWithNode);
    }
    else {
      ai_state_control(ai_patrol_findNode);
    }
  }
  else if(self.state_1 == AI_ORDER_STAND){
    ai_state_control(ai_misc_stand);
    ai_move_controller( ai_move_stand, 1);
  }
  else {
    ai_state_control(ai_misc_stand_debug);
    ai_move_controller(ai_move_stand, 1);
  }
};

/*
  AI calls to any nearby friendly units
  that are under 'defense' orders to save it
*/
void(entity aggro) ai_util_defense_callForHelp={
  local float tDist, rDist, justOne;
  local entity friend;
  justOne = FALSE;
  rDist = vlen(aggro.origin - self.origin);
  friend = findchainfloat(i_faction, self.i_faction);
  while(friend){
    if( (friend.data_type == DATA_MECH) || (friend.data_type == DATA_VEHC)){
      if(friend.state_1 == AI_ORDER_DEFEND){
        local float fDist;
        fDist = vlen(aggro.origin - friend.origin);
        if(fDist < rDist){
          rDist = fDist;
          if(justOne == FALSE){
            if(friend.trigger_field != world){
              friend.oldenemy = friend.trigger_field;
            }
            friend.trigger_field = aggro;
            friend.enemy = friend.trigger_field;
            friend.goalentity = friend.trigger_field;
            local entity this;
            this = self;
            self = friend;
              if(self.trigger_field != world){
                self.oldenemy = self.trigger_field;
              }
              self.trigger_field = aggro;
              self.enemy = self.trigger_field;
              self.goalentity = self.trigger_field;
              self.delay = time + self.maxpatience;
              ai_state_control(ai_combat_huntTarget);
            self = this;
            justOne = TRUE;
          }
        }
      }
    }
    friend = friend.chain;
  }
};

/*
  Converts angle to direction bitflag
  used for translating a vector to a world-aligned
  direction
  generally used for comparing two velocities
*/
float(vector toAngle) ai_util_angleToDir={
  local float anglee;
  anglee = vectoyaw(toAngle);
  
  if(anglee >= 337.5 || anglee < 22.5){
    return AI_DIR_N;
  }
  else if(anglee >= 22.5 && anglee < 67.5){
    return AI_DIR_NE; 
  }
  else if(anglee >= 67.5 && anglee < 112.5){
    return AI_DIR_E;  
  }
  else if(anglee >= 112.5 && anglee < 157){
    return AI_DIR_SE; 
  }
  else if(anglee >= 157 && anglee < 202){
    return AI_DIR_S;
  }
  else if(anglee >= 202 && anglee < 247){
    return AI_DIR_SW;  
  }
  else if(anglee >= 247 && anglee < 292){
    return AI_DIR_W;  
  }
  else if(anglee >= 292 && anglee < 337.5){
    return AI_DIR_NW; 
  }
  else{
    return 0;
  }
};

/*
  Gets the AI's target's move direction in relation
  to itself, so it can possibly choose a better move
  direction.
  returns
    float NULL        = -1;
    float AI_TARG_FWD = 0;
    float AI_TARG_BKD = 1;
    float AI_TARG_LFT = 2;
    float AI_TARG_RGT = 3;
*/
float(entity targ, entity this) ai_util_calcTargetMoveDir={
  local float arc, spot, tVel, meVel, back, left, right, isFront;
  //fix for stationary targets.
  if(targ.m_fspeed > 0){
    meVel = vectoyaw(this.velocity);
    tVel = vectoyaw(targ.velocity);
    arc = anglemod(this.angles_y + 180);
    spot = vectoyaw(targ.origin - this.origin);
    if( (spot > anglemod(arc - 90)) && (spot < anglemod(arc + 90)) ){
      isFront =  TRUE;
    }else{
      isFront =  FALSE;
    }
    if( (tVel >= anglemod(meVel - 45)) || (tVel <= anglemod(meVel + 45))){
      if(isFront){
        return AI_TARG_FWD;
      }
      else{
        return AI_TARG_BKD;
      }
    }
    else if( (tVel > anglemod(meVel + 45)) && (tVel < anglemod(meVel + 134))){
      if(isFront){
        return AI_TARG_LFT;
      }
      else{
        return AI_TARG_RGT;
      }
    }
    else if( (tVel >= anglemod(meVel + 135)) && (tVel <= anglemod(meVel + 225))){
      if(isFront){
        return AI_TARG_BKD;
      }
      else{
        return AI_TARG_FWD;
      }
    }
    else if( (tVel > anglemod(meVel + 225)) && (tVel < anglemod(meVel + 315))){
      if(isFront){
        return AI_TARG_RGT;
      }
      else{
        return AI_TARG_LFT;
      }
    }
  }
  //failure case
  return -1;
};

/*
  Compare's the AI's ideal_yaw to the given angle,
  used for movement adjusting
*/
float(float checkYaw) ai_util_compareYawIdeal={
  if(checkYaw == self.ideal_yaw){
    return TRUE;
  }
  return FALSE;
};

/*
  Get health of AI, used in movement adjusting
  TRUE = panic!
*/
float() ai_util_checkSelfHealth={
  local float total, avg;
  total = self.max_health;
  total = total + (self.e_tor_l.max_health * 2);
  total = total + (self.e_arm_l.max_health * 2);
  total = total + self.e_legs.max_health;
  avg = total / 5;
  if(avg <= (total * 0.25)){
    return TRUE; //panic
  }  
  return FALSE;
};

/*
  provides how many frames are needed to cover
  the distance
*/
float(vector torg, float tickRate) ai_util_calcMoveDist={
  local float dist, len;
  len = vlen(torg - self.origin);
  dist = self.m_fspeed * AI_RUN_SPD;
  dist = dist * (1 / tickRate);
  dist = len / dist;
  return ceil(dist);
};

float(float len, float tickRate) ai_util_calcMoveLen={
  local float dist;
  dist = self.m_fspeed * AI_RUN_SPD;
  dist = dist * (1 / tickRate);
  dist = len / dist;
  return ceil(dist);
};