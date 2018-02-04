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
  traceline(self.origin + '0 0 24', pNode.origin, TRUE, self);
  if(trace_fraction == 1){
    return pNode;
  }
  while(tNode){
    if(tNode.isActive == TRUE){
      traceline(self.origin + '0 0 24', tNode.origin, TRUE, self);
      if(trace_fraction == 1){
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

entity() ai_findNode_knowPatrol={
  

};

//============================
//   COMBAT SHENANIGANS
//============================
/*
        ai_target_visible
determins if an entity can be seen by caller
-ported from classic qc
*/
float(entity targ) ai_target_canSee={
  traceline(self.origin, targ.origin, TRUE, self);
  if(trace_fraction == 1){
    return TRUE;
  }
  return FALSE;
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
  radFidelityY = (RADAR_PASSIVE_ARC_PLAYER * ai_pilot_yaw_mod()) + self.maxs_y;
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
  delt = 16; //adjust trace origin
  makevectors(vectoangles(self.origin - t.origin));
  traceline( self.e_cam.origin+ (v_forward * delt), t.origin, TRUE, self);
  if(trace_fraction == 1){
    return TRUE;
  }
  return FALSE;
};

/*
validate possible target
*/
float(entity t) ai_target_isValid={
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
  if(t.i_faction == self.i_faction){
    return FALSE;
  }
  return TRUE;
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
      if(ai_target_isValid(t)){
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
  Reset AI's entity buffers
*/ 
void() ai_target_clearBuffers={
  self.enemy = world;
  self.oldenemy = world;
  self.trigger_field = world;
  self.goalentity = world;
};