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
  if( self.ai_rank < AI_RANK_VET ){
    if( dice < 0.6 ){
      self.ai_movedist = 5;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    else{
      self.ai_movedist = 3;
      self.ai_move_next = MOVE_SNIPESHOT;
      return;
    }
  }
  else{
    self.ai_movedist = 1;
    self.ai_move_next = MOVE_SNIPESHOT;
    if( dice <= 0.35 ){
      if( (self.ai_moveflag & MOVE_CHARGE_LEFT) ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CHARGE_LEFT;
      }
    }
    else if( dice <= 0.75 ){
      if( (self.ai_moveflag & MOVE_CHARGE_RIGHT) ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CHARGE_RIGHT;
      }
    }
    return;
  }
};
//----------------------------------------------------
//FIGHT: Melee / Enemy behind
void(float dice) spg_fight_close_rear={
  if( self.ai_rank < AI_RANK_VET ){
    if( dice < 0.6 ){
      self.ai_movedist = 4;
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    else{
      self.ai_movedist = 3;
      self.ai_move_next = MOVE_SNIPESHOT;
      return;
    }
  }
  else{
    self.ai_movedist = 3;
    self.ai_move_next = MOVE_SNIPESHOT;
    if( dice <= 0.35 ){
      if( (self.ai_moveflag & MOVE_CHARGE_LEFT) ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CHARGE_LEFT;
      }
    }
    else if( dice <= 0.75 ){
      if( (self.ai_moveflag & MOVE_CHARGE_RIGHT) ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CHARGE_RIGHT;
      }
    }
    return;
  }
};

//----------------------------------------------------
//FIGHT: ranged / Enemy in front
void(float dice) spg_fight_mid_front={
  local float lean;
  lean = vectoyaw(self.enemy.origin - self.origin);
  if( self.ai_rank == AI_RANK_ROK ){
    self.ai_movedist = 6;
    if( dice < 0.4 ){
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    else if( dice < 0.7 ){
      self.ai_move_next = MOVE_SNIPESHOT;
      return;
    }
    else{
      self.ai_move_next = MOVE_BACK;
      return;
    }
  }
  if( self.ai_rank == AI_RANK_REG ){
    if( dice < 0.4 ){
      if( (self.ai_moveflag & MOVE_CHARGE_LEFT) ){
        if( lean > (anglemod(self.angles_y + 45)) ){
          self.ai_movedist = 5;
          self.ai_move_next = MOVE_CHARGE_LEFT;
          return;
        }
      }
    }
    else if( dice < 0.7 ){
      if( (self.ai_moveflag & MOVE_CHARGE_RIGHT) ){
        if( lean > (anglemod(self.angles_y - 45)) ){
          self.ai_movedist = 5;
          self.ai_move_next = MOVE_CHARGE_RIGHT;
          return;
        }
      }
    }
    self.ai_movedist = 10;
    self.ai_move_next = MOVE_SNIPESHOT;
    return;
  }
  if( self.ai_rank == AI_RANK_VET ){
    if( (self.ai_moveflag & MOVE_CHARGE_LEFT) ){
      if( lean > (anglemod(self.angles_y + 45)) ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CHARGE_LEFT;
        return;
      }
    }
    if( (self.ai_moveflag & MOVE_CHARGE_RIGHT) ){
      if( lean > (anglemod(self.angles_y - 45)) ){
        self.ai_movedist = 5;
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
    }
    self.ai_movedist = 3;
    if( dice < 0.5 ){
      if( dice < 0.2 ){
        if( (self.ai_moveflag & MOVE_BACK_LEFT) ){
          self.ai_move_next = MOVE_BACK_LEFT;
          return;
        }
      }
      if( (self.ai_moveflag & MOVE_BACK_RIGHT) ){
        self.ai_move_next = MOVE_BACK_RIGHT;
        return;
      }
    }
    self.ai_move_next = MOVE_SNIPESHOT;
    return;
  }
  if( self.ai_rank == AI_RANK_ACE ){
    self.ai_movedist = 2;
    if( dice <= 0.25 ){
      if( (self.ai_moveflag & MOVE_BACK_RIGHT) ){
        self.ai_move_next = MOVE_BACK_RIGHT;
        return;
      }
    }
    else if( dice <= 0.5 ){
      if( (self.ai_moveflag & MOVE_BACK_LEFT) ){
        self.ai_move_next = MOVE_BACK_LEFT;
        return;
      }
    }
    else if( dice <= 0.75 ){
      if( (self.ai_moveflag & MOVE_CHARGE_RIGHT) ){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
    }
    else{    
      if( (self.ai_moveflag & MOVE_CHARGE_LEFT) ){
        self.ai_move_next = MOVE_CHARGE_LEFT;
        return;
      }
    }
    self.ai_move_next = MOVE_SNIPESHOT;
    return;
  }
};
//----------------------------------------------------
//FIGHT: ranged / Enemy behind
void(float dice) spg_fight_mid_rear={
  if( self.ai_rank <= AI_RANK_VET ){
    self.ai_movedist = 5;
    if( dice <= 0.25 ){
      self.ai_move_next = MOVE_SNIPESHOT;
      return;
    }
    else if( dice <= 0.5 ){
      self.ai_move_next = MOVE_STAND_FACE;
      return;
    }
    else if( dice <= 0.75 ){
      if( (self.ai_moveflag & MOVE_CHARGE_RIGHT) ){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
        return;
      }
    }
    else{    
      if( (self.ai_moveflag & MOVE_CHARGE_LEFT) ){
        self.ai_move_next = MOVE_CHARGE_LEFT;
        return;
      }
    }
    self.ai_move_next = MOVE_SNIPESHOT;
    return;
  }
  if( self.ai_rank == AI_RANK_ACE ){
    self.ai_movedist = 2;
    self.ai_move_next = MOVE_SNIPESHOT;
    if( dice <= 0.35 ){
      if( (self.ai_moveflag & MOVE_CHARGE_LEFT) ){
        self.ai_move_next = MOVE_CHARGE_LEFT;
      }
    }
    else if( dice <= 0.75 ){
      if( (self.ai_moveflag & MOVE_CHARGE_RIGHT) ){
        self.ai_move_next = MOVE_CHARGE_RIGHT;
      }
    }
    return;
  }
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