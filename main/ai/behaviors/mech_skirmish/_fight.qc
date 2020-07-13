/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish mechs are the basic mech behavior type in the game.
  the _fight file contains the code for combat-state movement.
*/


void(float dice) mech_sk_fight_close_front={
  //RANK - ROOKIE
  if( self.ai_rank == AI_RANK_ROK ){
    self.ai_movewait = 3;
    self.ai_move_next = MOVE_STAND_FACE;
    return;
  }
  //RANK - REG
  if( self.ai_rank == AI_RANK_REG ){
    if( dice <= 0.5 ){
      self.ai_movedist = 2;
      if( !(self.ai_blockflag & MOVE_BACK) ){
        self.ai_move_next = MOVE_BACK;
      }
      else{
        self.ai_move_next = MOVE_STAND_FACE;
      }
      return;
    }
    else{
      local float coin;
      coin = random() * 1;
      self.ai_movedist = 4;
      if( coin < 0.6) {
        if( !(self.ai_blockflag & MOVE_CIRCLE_LEFT) ){
          self.ai_move_next = MOVE_CIRCLE_LEFT;
        }
        else{
          if( !(self.ai_blockflag & MOVE_CIRCLE_RIGHT) ){
            self.ai_move_next = MOVE_CIRCLE_RIGHT;
          }
          else{
            self.ai_move_next = MOVE_STAND_FACE;
          }
        }
        return;
      }
      else{
        if( !(self.ai_blockflag & MOVE_CIRCLE_RIGHT) ){
          self.ai_move_next = MOVE_CIRCLE_RIGHT;
        }
        else{
          if( !(self.ai_blockflag & MOVE_CIRCLE_LEFT) ){
            self.ai_move_next = MOVE_CIRCLE_LEFT;
          }
          else{
            self.ai_move_next = MOVE_STAND_FACE;
          }
        }
        return;
      }
    }
    return;
  }
  //RANK - VET+
  self.ai_movedist = 1;
  if( dice <= 0.3 ){
    if( !(self.ai_blockflag & MOVE_BACK_RIGHT) ){
      self.ai_move_next = MOVE_BACK_RIGHT;
    }
    else{
      self.ai_move_next = MOVE_STAND_FACE;
    }
  }
  else if( dice <= 0.6 ){
    if( !(self.ai_blockflag & MOVE_BACK) ){
      self.ai_move_next = MOVE_BACK;
    }
    else{
      self.ai_move_next = MOVE_STAND_FACE;
    }
  }
  else{
    if( !(self.ai_blockflag & MOVE_BACK) ){
      self.ai_move_next = MOVE_BACK;
    }
    else{
      self.ai_move_next = MOVE_STAND_FACE;
    }
  }
};

void(float dice) mech_sk_fight_close_rear={
  //------------------> FACING REAR
  if( self.ai_rank < AI_RANK_VET ){
    self.ai_movedist = 3;
    self.ai_move_next = MOVE_STAND_FACE;
    return;
  }
  if( dice < 0.6 ){
    self.ai_movedist = 5;
    self.ai_move_next = MOVE_CHARGE_RIGHT;
    return;
  }
  self.ai_movedist = 5;
  self.ai_move_next = MOVE_CHARGE_LEFT;
};



void(float dice) mech_sk_fight_mid_front={
  //RANK ROK
  if( self.ai_rank == AI_RANK_ROK ){
    self.ai_movedist = 5;
    if(dice < 0.33 ){
      self.ai_move_next = MOVE_CIRCLE_LEFT;
    }
    else if( dice < 0.66 ){
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
    }
    else{
      self.ai_move_next = MOVE_BACK;
    }
    return;
  }
  //RANK REG
  if( self.ai_rank == AI_RANK_REG ){
    self.ai_movedist = 3;
    if(dice < 0.25 ){
      self.ai_move_next = MOVE_CIRCLE_LEFT;
    }
    else if( dice < 0.5 ){
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
    }
    else if( dice < 0.75 ){
      self.ai_move_next = MOVE_STRAFE_RIGHT;
    }
    else{
      self.ai_move_next = MOVE_STRAFE_LEFT;
    }
    return;
  }
  //RANK VET+
  self.ai_movedist = 1.5;
  if(dice < 0.25 ){
    self.ai_move_next = MOVE_CIRCLE_LEFT;
  }
  else if( dice < 0.5 ){
    self.ai_move_next = MOVE_CIRCLE_RIGHT;
  }
  else if( dice < 0.75 ){
    self.ai_move_next = MOVE_CHARGE_RIGHT;
  }
  else{
    self.ai_move_next = MOVE_CHARGE_LEFT;
  }
  return;
};


void(float dice) mech_sk_fight_mid_rear={
  //RANK ROK
  if( self.ai_rank == AI_RANK_ROK ){
    self.ai_movedist = 7;
    if( dice < 0.33 ){
      self.ai_move_next = MOVE_STAND_FACE;
    }
    else if( dice < 0.66 ){
      self.ai_move_next = MOVE_CHARGE;
    }
    else{
      self.ai_move_next = MOVE_CHARGE_LEFT;
    }
    return;
  }
  //RANK REG
  if( self.ai_rank == AI_RANK_REG ){
    self.ai_movedist = 4;
    if( dice < 0.6 ){
      self.ai_move_next = MOVE_CHARGE_RIGHT;
    }
    else{
      self.ai_move_next = MOVE_CHARGE_LEFT;    
    }
    return;
  }
  //RANK VET+
    self.ai_movedist = 2;
  if( dice < 0.33 ){
    self.ai_move_next = MOVE_STRAFE_RIGHT;
  }
  else if( dice < 0.66 ){
    self.ai_move_next = MOVE_BACK;
  }
  else{
    self.ai_move_next = MOVE_STRAFE_LEFT;
  }
};



void(float dice) mech_sk_fight_far_front={

};


void(float dice) mech_sk_fight_far_rear={

};
