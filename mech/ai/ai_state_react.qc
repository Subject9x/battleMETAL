/*
mech Mod
Author: Peter Roohr
Date: 2/26/2-18
Overview: not exactly an explicit state, just more of an interrupt.
AI has to handle the reaction to being hit.
*/

/*
  Primary entry point for reaction filtering,
  this is solely called by t_damage!
*/
float(entity atk) ai_react_enter={
  local float tFlags, friendLocks, atkHpAvg, selfHpAvg, atkDist, isVis;
  //regardless of state, if AI lacks for enemies, take this one
  if( (self.enemy == world) && (self.oldenemy == world)){
    ai_update_switchToTarget(atk);
    ai_state_control(ai_combat_adjustPosition);
    return;
  }

  atkDist = vlen(atk.origin - self.origin);
  friendLocks = ai_combat_locksOnTarget(atk, self.i_faction);
  //BUILD DFLAGS SET
  if(self.ai_type == AI_TYPE_AGGRO){
    tFlags = tFlags | AI_DFLAG_TYPE_AGGRO;
  }
  
  if(self.ai_type == AI_TYPE_COWRD){
    tFlags = tFlags | AI_DFLAG_TYPE_COWRD;
  }
  
  if(util_getMechHpAverage(self) <= 0.35){
    tFlags = tFlags | AI_DFLAG_HPLOW;
  }
  
  if(self.p_damage <= AI_RANK_VET){
    tFlags = tFlags | AI_DFLAG_RANK_VET;
  }
  
  if(atkDist < self.stat_trg_dist){
    tFlags = tFlags | AI_DFLAG_DIST_LESS;
  }
  else if(atkDist > self.stat_trg_dist){
    tFlags = tFlags | AI_DFLAG_DIST_MORE;
  }
  
  if(0 < atkDist <= AI_RANGE_S){
    tFlags = tFlags | AI_DFLAG_DIST_RANGE_S;
  }
  else if(AI_RANGE_S < atkDist <= AI_RANGE_M){
    tFlags = tFlags | AI_DFLAG_DIST_RANGE_M;
  }
  else if(AI_RANGE_M < atkDist <= AI_RANGE_L){
    tFlags = tFlags | AI_DFLAG_DIST_RANGE_L;
  }
  
  if(util_getMechHpAverage(atk) < util_getMechHpAverage(self.enemy)){
    tFlags = tFlags | AI_DFLAG_ATK_HPLOW;
  }
  
  if(atk.vec_size < self.enemy.vec_size){
    tFlags = tFlags | AI_DFLAG_ATK_SMALL;
  }
  
  if(atk.vec_size > self.enemy.vec_size){
    tFlags = tFlags | AI_DFLAG_ATK_BIGGR;
  }
  
  if(ai_target_canSee(atk) && !ai_target_canSee(self.enemy)){
    tFlags = tFlags | AI_DFLAG_ATK_CANSEE;
  }
  
  if(ai_target_isInFront(atk)){
    tFlags = tFlags | AI_DFLAG_ATK_FRONT;
  }
  
  if( (self.enemy.vec_size > self.vec_size) && (self.enemy.vec_size > atk.vec_size)){
    tFlags = tFlags | AI_DFLAG_ENM_BIGGEST;
  }
  
  if(ai_target_canSee(self.enemy)){
    tFlags = tFlags | AI_DFLAG_ENM_CANSEE;
  }
  
  if(ai_target_isInFront(self.enemy)){
    tFlags = tFlags | AI_DFLAG_ENM_FRONT;
  }
  
  if(ai_combat_locksOnTarget(atk, self.i_faction) < ai_combat_locksOnTarget(self.enemy, self.i_faction)){
    tFlags = tFlags | AI_DFLAG_ATK_LOCK;
  }
  //======================================
  if(self.ai_style == AI_STYLE_SNIPER){
    return ai_react_sniper(tFlags, atk, friendLocks, atkDist);
  }
  if(self.ai_style == AI_STYLE_BRAWL){
    return ai_react_brawl(tFlags, atk, friendLocks, atkDist);
  }
  if(self.ai_style == AI_STYLE_SKIRM){
    return ai_react_skirmish(tFlags, atk, friendLocks, atkDist);
  }
  if(self.ai_style == AI_STYLE_STALK){
    return ai_react_stalker(tFlags, atk, friendLocks, atkDist);
  }
  if(self.ai_style == AI_STYLE_FLANK){
   return ai_react_flanker(tFlags, atk, friendLocks, atkDist);
  }
  return FALSE;
};

/*
  AI_TYPE_SNIPE
*/
float(float dFlags, entity atk, float numLocks, float atkDist) ai_react_sniper={
  
};


/*
  AI_TYPE_BRAWL
*/
float(float dFlags, entity atk, float numLocks, float atkDist) ai_react_brawl={
  

};


/*
  AI_TYPE_SKIRM
*/
float(float dFlags, entity atk, float numLocks, float atkDist) ai_react_skirmish={

};

/*
  AI_TYPE_STALK
*/
float(float dFlags, entity atk, float numLocks, float atkDist) ai_react_stalker={
  
};
/*
  AI_TYPE_FLANK
*/
float(float dFlags, entity atk, float numLocks, float atkDist) ai_react_flanker={

};