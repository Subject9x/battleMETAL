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
    if(self.button0){
      if(wep_chain.w_state == READY){
        fire = TRUE;
      }
    }
    else{
      if(wep_chain.w_isburst == TRUE){
        if(wep_chain.w_state == READY){
          fire = TRUE;
        }
      }
    }
    if(fire == TRUE){
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
  local entity oself;
  oself = self;
  self = wep;
  if((self.p_dmgtype & EFF_STX) && (self.w_isburst == FALSE)){
    if(self.enemy.sh_cur >= (self.enemy.sh_max/4)){
      self.w_attack();
      self = oself;
      return;
    }
    else{
      self = oself;
      return;//cancel attack regardless of weapon state
    }
  }
  else{
    self.w_attack();
    self = oself;
    return;
  }
  self = oself;
  return;
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