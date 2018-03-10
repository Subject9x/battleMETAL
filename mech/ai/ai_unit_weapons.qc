/*
mech Mod
Date: 3/9/2018
Overview: Main file for executing AI weapon attacks

*/


void() ai_attack={
  local entity wep_chain, oself;
  local float wep_count, fired;
  oself = self;
  wep_chain = self.w_slot;
  wep_count = wep_chain.w_group;
  while(wep_chain){
    local float wgrp;
    wgrp = wep_chain.w_group;
    if( ai_target_facingideal() && (self.stat_trg_dist <= wep_chain.w_range) ){
      if(wep_chain.w_state == READY){
        
        
        self = wep_chain;
          self.w_attack();
        self = oself;
      }
    }
    else{
      if(wep_chain.w_isburst == TRUE){
        if(wep_chain.w_state == READY){
          self = wep_chain;
            self.w_attack();
          self = oself;
        }
      }
    }
    wep_chain = wep_chain.w_slot;
  }
  if( fired > FALSE){
    if( time > self.attack_finished){
      self.attack_finished = time + ai_core_attackInterval();
    }
  }
}


void() ai_attack_filter={
  

};