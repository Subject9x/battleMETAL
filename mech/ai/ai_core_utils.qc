/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/


/*
  checks to see if bot has any weapons left,
  RETURN TRUE - bot has guns left
  RETURN FALSE - bot has no guns left
  only really call on t_damage or mech component death functions
*/
float() ai_core_noguns={
  local float idx;
  local entity wslot;
  idx = 0;
  wslot = self.w_slot;
  while(wslot){
    if(wslot.deadflag > DEAD_NO){
      idx = idx + 1;
    }
    wslot = wslot.w_slot;
  }
  if(idx >= (self.w_proj - 2)){
    return TRUE;
  }
  return FALSE;
};


entity(vector org, float start_dist) ai_core_findgraphnode={
  local entity e, near;
  local float prox;
  prox = start_dist;
  e = findchain(classname, "ai_node");
  while(e){
    local float d;
    if(self.node_id){
      traceline(e.origin, org, FALSE, self);
      if(trace_fraction == 1){
        d = vlen(e.origin - org);
        if( d < prox){
          prox = d;
          near = e;
        }
      }
    }
    e = e.chain;
  }
  return near;
};

entity() ai_core_findfriendly={
  local entity friend, found;
  local vector me, forg;
  local float rad, dist;
  makevectors(self.angles);
  me = friend.origin + v_up*64;
  dist = rad = self.radar_range;
  friend = findradius(self.origin, rad);
  while(friend){
    if(friend != world){
      if(friend.i_faction == self.i_faction){
        if((friend.data_type == DATA_VEHC) || (friend.data_type == DATA_MECH)){
          makevectors(friend.angles);
          forg = friend.origin + v_up*32;
          traceline(me, forg, TRUE, self);
          if(trace_fraction > 0.25){
            local float f;
            f = vlen(friend.origin - self.origin);
            if(f < dist){
              dist = f;
              found = friend;
            }
          }
        }
      }
    }
    friend = friend.chain;
  }
  return found;
};

//gets convergence factor for pilot rating
float() ai_pilot_rating_converg={
  if(self.p_damage == AI_RANK_ACE){
    return AI_CNV_ACE;
  }
  else if(self.p_damage == AI_RANK_VET){
    return AI_CNV_VET;
  }
  else if(self.p_damage == AI_RANK_REG){
    return AI_CNV_REG;
  }
  else{
    return AI_CNV_ROK;
  }
};

//gets range modifier for pilot rating
float() ai_pilot_rating_range={
  if(self.p_damage == AI_RANK_ACE){
    return AI_RNG_ACE;
  }
  else if(self.p_damage == AI_RANK_VET){
    return AI_RNG_VET;
  }
  else if(self.p_damage == AI_RANK_REG){
    return AI_RNG_REG;
  }
  else if(self.p_damage == AI_RANK_ROK){
    return AI_RNG_ROK;
  }
  else{
    return 1;
  }
};

/*
  Determines how good the AI is at turning their mech around.
  Each mech has a set yaw speed, but this determines if the AI
  is good enough to turn the mech at its set speed, rather than
  having 'slower reflexes'.
*/
float() ai_pilot_yaw_mod={
  if(self.p_damage == AI_RANK_ACE){
    return AI_ROT_ACE;
  }
  else if(self.p_damage == AI_RANK_VET){
    return AI_ROT_VET;
  }
  else if(self.p_damage == AI_RANK_REG){
    return AI_ROT_REG;
  }
  else if(self.p_damage == AI_RANK_ROK){
    return AI_ROT_ROK;
  }
  else{
    return 1;
  }
};

/*
  Armor amounts for AI units is modified by the game's skill
  rating. Easier skill modes mean each AI has less armor.
*/
float() ai_pilot_armor_mod={
  if(skill == 0){
    return AI_ARMOR_EASY;
  }
  else if(skill == 1){
    return AI_ARMOR_MEDM;
  }
  else if(skill == 2){
    return AI_ARMOR_HARD;
  }
  else if(skill == 3){
    return AI_ARMOR_NIGHT;
  }
  else{
    return AI_ARMOR_EASY;
  }
}

/*
  Armor amounts for AI units is modified by tshe game's skill
  rating. Easier skill modes mean each AI has less armor.
*/
float() ai_pilot_shield_mod={
  if(skill == 0){
    return AI_SHIELD_EASY;
  }
  else if(skill == 1){
    return AI_SHIELD_MEDM;
  }
  else if(skill == 2){
    return AI_SHIELD_HARD;
  }
  else if(skill == 3){
    return AI_SHIELD_NIGHT;
  }
  else{
    return AI_SHIELD_EASY;
  }
}

/*
  This determines how good the AI is at 'leading' its target.
  In practice, this is how badly the AI's aim should trail BEHIND
  its target. Better AI's are better at this.
*/
float() ai_pilot_rating_leading={
  if(self.p_damage == AI_RANK_ACE){
    return AI_LEAD_ACE;
  }
  else if(self.p_damage == AI_RANK_VET){
    return AI_LEAD_VET;
  }
  else if(self.p_damage == AI_RANK_REG){
    return AI_LEAD_REG;
  }
  else if(self.p_damage == AI_RANK_ROK){
    return AI_LEAD_ROK;
  }
  else{
    return AI_LEAD_ROK;
  }
};

/*
  Determines the starting patience value of the AI.
  Patience is primarily used for ai_combat_huntTarget,
  where patience is initialized to: time + <this value>
  better AI's can hold their patience a bit longer
*/
float() ai_pilot_rating_patience={
  local float ePatience;
  if(self.p_damage == AI_RANK_ACE){
    ePatience = AI_PTNCE_ACE;
  }
  else if(self.p_damage == AI_RANK_VET){
    ePatience =  AI_PTNCE_VET;
  }
  else if(self.p_damage == AI_RANK_REG){
    ePatience =  AI_PTNCE_REG;
  }
  else if(self.p_damage == AI_RANK_ROK){
    ePatience =  AI_PTNCE_ROK;
  }
  else{
    ePatience =  AI_PTNCE_ROK;
  }
  //skill mod
  ePatience = ePatience + (ePatience * (skill / 15));
  
  //ai quirks mods
  if(self.count1 == AI_STYLE_STALK){
    //stalkers should have the longest patience
    ePatience = ePatience + (ePatience * 0.5);
  }
  else if(self.count1 ==- AI_STYLE_FLANK){
    //flankers get a minor bump in patience
    ePatience = ePatience + (ePatience * 0.25);
  }
  //yes you can have an aggressive stalker, but it wont be great
  //for long hunts
  if(self.count2 == AI_TYPE_AGGRO){
    ePatience = ePatience - (ePatience / 2);
  }
  return ePatience; 
};

/*
  time in seconds in-between checks for anger_monster();
*/
float() ai_core_hitTimeCalc={
  local float sec;
  sec = (self.p_damage + 2);
  sec = sec * 1.5;
  
  if(self.state_1 == AI_ORDER_ATTACK){
    sec = sec + 1;
  }
  if(self.ai_style == AI_STYLE_STALK){
    sec = sec + 2.5;
  }
  if(self.ai_type == AI_TYPE_AGGRO){
    sec = sec - ( sec * 0.25);
  }
  if(self.ai_type == AI_TYPE_COWRD){
    sec = sec - ( sec * 0.5);
  }
  return sec;
};

/*
  a design conceit, to make sure bots are perfectly firing,
  or inhumanly relentlessly attacking, this function creates
  a random amount of time to make the next attack.
*/
float() ai_core_attackInterval={
  local float cooldown;
  cooldown = self.p_damage / 2;

  if(self.ai_style == AI_STYLE_SNIPER){
    cooldown = cooldown + 0.35;
  }
  else if(self.ai_style == AI_STYLE_BRAWL){
    cooldown = cooldown + 0.15;
  }
  else if(self.ai_style == AI_STYLE_SKIRM){
    cooldown = cooldown + 0.25;
  }

  if(self.ai_type == AI_TYPE_AGGRO){
    cooldown = cooldown - 0.05;
  }

  if(skill == 0){
    cooldown = cooldown + 1;
  }
  else if(skill == 2){
    cooldown = cooldown + 0.75;
  }
  else if(skill == 2){
    cooldown = cooldown + 0.50;
  }
  else if(skill == 3){
    cooldown = cooldown + 0.25;
  }
  cooldown = util_roll_dice( fabs(cooldown) );
  return cooldown;
};

void() ai_core_calcranges={
  local entity w;
  w = self.w_slot;
  while(w){
    if(w.deadflag <= DEAD_NO){
      local float damg;
      damg = w.p_damage * w.w_clipsize;
      if(w.w_range <= AI_RANGE_S){ 
        self.ai_dmg_s = self.ai_dmg_s + damg;
      }
      if(w.w_range > AI_RANGE_S){
        if(w.w_range <= AI_RANGE_M){
          self.ai_dmg_m = self.ai_dmg_m + damg;
          self.ai_dmg_s = self.ai_dmg_s + damg;
        }
      }
      if(w.w_range > AI_RANGE_M){
        self.ai_dmg_m = self.ai_dmg_m + damg;
        self.ai_dmg_s = self.ai_dmg_s + damg;
        self.ai_dmg_l = self.ai_dmg_l + damg;
      }
    }
    w = w.w_slot;
  }
  if((self.ai_dmg_l > self.ai_dmg_s) && (self.ai_dmg_l  > self.ai_dmg_s)){
    self.ai_minrange = AI_RANGE_L;
  }
  else if((self.ai_dmg_m > self.ai_dmg_l) && (self.ai_dmg_m  > self.ai_dmg_s)){
    self.ai_minrange = AI_RANGE_M;
  }
  else if((self.ai_dmg_s > self.ai_dmg_l) && (self.ai_dmg_s  > self.ai_dmg_m)){
    self.ai_minrange = AI_RANGE_S;
  }
  else{
    self.ai_minrange = AI_RANGE_S;
  }
};

//moving this to bottom for readability
//galaxy forgive me
entity(entity gnode, float id) ai_query_graphnode={
  local entity n;
  local float idx;
  if(id == 1){
    idx = gnode.nexnode1;
  }
  else if(id == 2){
    idx = gnode.nexnode2;
  }
  else if(id == 3){
    idx = gnode.nexnode3;
  }
  else if(id == 4){
    idx = gnode.nexnode4;
  }
  else if(id == 5){
    idx = gnode.nexnode5;
  }
  else if(id == 6){
    idx = gnode.nexnode6;
  }
  else if(id == 7){
    idx = gnode.nexnode7;
  }
  else if(id == 8){
    idx = gnode.nexnode8;
  }
  else if(id == 9){
    idx = gnode.nexnode9;
  }
  else if(id == 10){
    idx = gnode.nexnode10;
  }
  else if(id == 11){
    idx = gnode.nexnode11;
  }
  else if(id == 12){
    idx = gnode.nexnode12;
  }
  else if(id == 13){
    idx = gnode.nexnode13;
  }
  else if(id == 14){
    idx = gnode.nexnode14;
  }
  else if(id == 15){
    idx = gnode.nexnode15;
  }
  else if(id == 16){
    idx = gnode.nexnode16;
  }
  else if(id == 17){
    idx = gnode.nexnode17;
  }
  else if(id == 18){
    idx = gnode.nexnode18;
  }
  else if(id == 19){
    idx = gnode.nexnode19;
  }
  else if(id == 20){
    idx = gnode.nexnode20;
  }
  else if(id == 21){
    idx = gnode.nexnode21;
  }
  else if(id == 22){
    idx = gnode.nexnode22;
  }
  else if(id == 23){
    idx = gnode.nexnode23;
  }
  else if(id == 24){
    idx = gnode.nexnode24;
  }
  else if(id == 25){
    idx = gnode.nexnode25;
  }
  else if(id == 26){
    idx = gnode.nexnode26;
  }
  else if(id == 27){
    idx = gnode.nexnode27;
  }
  else if(id == 28){
    idx = gnode.nexnode28;
  }
  else if(id == 29){
    idx = gnode.nexnode29;
  }
  else if(id == 30){
    idx = gnode.nexnode30;
  }
  else if(id == 31){
    idx = gnode.nexnode31;
  }
  else if(id == 32){
    idx = gnode.nexnode32;
  }
  n = findfloat(world, node_id, idx);
  return n;
};