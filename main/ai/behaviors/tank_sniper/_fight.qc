/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 
  tank snipers are basically missile / tank hunter vehicles.
  they're limited in mobility and aiming, very sluggish.
  
  _fight is tied to _combat, where _fight prescribes the move selection.
*/
//----------------------------------------------------
//FIGHT: Melee / Enemy in front
void(float dice) spg_fight_close_front={

};
//----------------------------------------------------
//FIGHT: Melee / Enemy behind
void(float dice) spg_fight_close_rear={

};

//----------------------------------------------------
//FIGHT: ranged / Enemy in front
void(float dice) spg_fight_mid_front={

};
//----------------------------------------------------
//FIGHT: ranged / Enemy behind
void(float dice) spg_fight_mid_rear={

};

//----------------------------------------------------
void(float dice) spg_fight_far_front={
  if(self.ai_rank == AI_RANK_ROK ){
    self.ai_movedist = rint(random() * (self.ai_rank * 1.25));
    self.ai_move_next = MOVE_SNIPESHOT;
    return;
  }
  self.ai_move_next = MOVE_PATROLNODE;
  return;
};
//----------------------------------------------------
void(float dice) spg_fight_far_rear={
  self.ai_movedist = rint(random() * (self.ai_rank * 1.25));
  self.ai_move_next = MOVE_SNIPESHOT;
};

//----------------------------------------------------
void(float dice) spg_hunt_far_front={

};
//----------------------------------------------------
void(float dice) spg_hunt_far_rear={
  self.ai_movedist = rint(random() * (self.ai_rank * 1.25));
  self.ai_move_next = MOVE_SNIPESHOT;
};