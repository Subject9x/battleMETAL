/*
mech Mod
Date: 6/15/2017
Overview: all the functions related to ai weapon attacks in the ai core system

*/

void() ai_mech_attack={
  local entity ai, wep_chain, oself;
  local float dist;
  ai = self;
  wep_chain = self.w_slot;
  while(wep_chain){
    local float fire;
    fire = FALSE;
    if((self.stat_trg_dist <= wep_chain.w_range) && (wep_chain.w_isburst == FALSE)){
      fire = TRUE;
    }
    else if(wep_chain.w_isburst == TRUE) {
      fire =  TRUE;
    }
    if(fire){
      if((wep_chain.p_dmgtype & DMG_ENE)){
        ai_attack_ene(wep_chain);
      }
      else if((wep_chain.p_dmgtype & DMG_BAL)){
        ai_attack_bal(wep_chain);
      }
      else if((wep_chain.p_dmgtype & DMG_EXP)){
        ai_attack_exp(wep_chain);
      }
      else{
        ai_attack_basic(wep_chain);
      }
    }
    wep_chain = wep_chain.w_slot;
  }
};
void(entity wep) ai_attack_basic={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;

  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;
};

void(entity wep) ai_attack_ene={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;

  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if((wep.p_dmgtype & EFF_STX) && (wep.w_isburst == FALSE)){
    if(self.enemy.sh_cur >= (self.enemy.sh_max/4)){
      attack = TRUE;
    }
    else{
      attack = FALSE; //cancel attack regardless of weapon state
    }
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;
};

void(entity wep) ai_attack_bal={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;
  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;  
};
void(entity wep) ai_attack_exp={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;
  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if((wep.p_dmgtype & DMG_EXP)){
    if(self.enemy.sh_cur >= (self.enemy.sh_max/5)){
      attack = TRUE;
    }
    else{
      attack = FALSE; //cancel attack regardless of weapon state
    }
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;
};