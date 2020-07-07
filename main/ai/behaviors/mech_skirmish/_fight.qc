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
    cons_logAFloat("self.ai_movewait", self.ai_movewait); //debug
    cons_logAFloat("NEXT MOVE-MOVE_STAND_FACE", self.ai_move_next); //debug
    return;
  }
  //RANK - REG
  if( self.ai_rank == AI_RANK_REG ){
    if( dice <= 0.5 ){
      self.ai_movedist = 2;
      if( !(self.ai_blockflag & MOVE_BACK) ){
        self.ai_move_next = MOVE_BACK;
      cons_logAFloat("SK:Line26-MOVE_BACK", self.ai_move_next); //debug
      }
      else{
        self.ai_move_next = MOVE_STAND_FACE;
      cons_logAFloat("SK:Line30-MOVE_STAND_FACE", self.ai_move_next); //debug
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
      cons_logAFloat("SK:Line39-MOVE_CIRCLE_LEFT", self.ai_move_next); //debug
        }
        else{
          if( !(self.ai_blockflag & MOVE_CIRCLE_RIGHT) ){
            self.ai_move_next = MOVE_CIRCLE_RIGHT;
      cons_logAFloat("SK:Line44-MOVE_CIRCLE_RIGHT", self.ai_move_next); //debug
          }
          else{
            self.ai_move_next = MOVE_STAND_FACE;
      cons_logAFloat("SK:Line48-MOVE_STAND_FACE", self.ai_move_next); //debug
          }
        }
        return;
      }
      else{
        if( !(self.ai_blockflag & MOVE_CIRCLE_RIGHT) ){
          self.ai_move_next = MOVE_CIRCLE_RIGHT;
      cons_logAFloat("SK:Line53-MOVE_CIRCLE_RIGHT", self.ai_move_next); //debug
        }
        else{
          if( !(self.ai_blockflag & MOVE_CIRCLE_LEFT) ){
            self.ai_move_next = MOVE_CIRCLE_LEFT;
      cons_logAFloat("SK:Line58-MOVE_CIRCLE_LEFT", self.ai_move_next); //debug
          }
          else{
            self.ai_move_next = MOVE_STAND_FACE;
      cons_logAFloat("SK:Line60-MOVE_STAND_FACE", self.ai_move_next); //debug
          }
        }
        return;
      }
    }
    cons_logAFloat("self.ai_movewait", self.ai_movewait); //debug
    cons_logAFloat("NEXT MOVE", self.ai_move_next); //debug
    return;
  }
  //RANK - VET+
  self.ai_movedist = 1;
  if( dice <= 0.3 ){
    if( !(self.ai_blockflag & MOVE_BACK_RIGHT) ){
      self.ai_move_next = MOVE_BACK_RIGHT;
      cons_logAFloat("SK:Line74-MOVE_BACK_RIGHT", self.ai_move_next); //debug
    }
    else{
      self.ai_move_next = MOVE_STAND_FACE;
      cons_logAFloat("SK:Line78-MOVE_STAND_FACE", self.ai_move_next); //debug
    }
  }
  else if( dice <= 0.6 ){
    if( !(self.ai_blockflag & MOVE_BACK) ){
      self.ai_move_next = MOVE_BACK;
      cons_logAFloat("SK:Line84-MOVE_BACK", self.ai_move_next); //debug
    }
    else{
      self.ai_move_next = MOVE_STAND_FACE;
      cons_logAFloat("SK:Line88-MOVE_STAND_FACE", self.ai_move_next); //debug
    }
  }
  else{
    if( !(self.ai_blockflag & MOVE_BACK) ){
      self.ai_move_next = MOVE_BACK;
      cons_logAFloat("SK:Line94-MOVE_BACK", self.ai_move_next); //debug
    }
    else{
      self.ai_move_next = MOVE_STAND_FACE;
      cons_logAFloat("SK:Line98-MOVE_STAND_FACE", self.ai_move_next); //debug
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
      cons_logAFloat("SK:Line135-MOVE_CIRCLE_LEFT", self.ai_move_next); //debug
    }
    else if( dice < 0.66 ){
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
      cons_logAFloat("SK:Line139-MOVE_CIRCLE_RIGHT", self.ai_move_next); //debug
    }
    else{
      self.ai_move_next = MOVE_BACK;
      cons_logAFloat("SK:Line143-MOVE_BACK", self.ai_move_next); //debug
    }
    return;
  }
  //RANK REG
  if( self.ai_rank == AI_RANK_REG ){
    self.ai_movedist = 3;
    if(dice < 0.25 ){
      self.ai_move_next = MOVE_CIRCLE_LEFT;
      cons_logAFloat("SK:Line152-MOVE_CIRCLE_LEFT", self.ai_move_next); //debug
    }
    else if( dice < 0.5 ){
      self.ai_move_next = MOVE_CIRCLE_RIGHT;
      cons_logAFloat("SK:Line156-MOVE_CIRCLE_RIGHT", self.ai_move_next); //debug
    }
    else if( dice < 0.75 ){
      self.ai_move_next = MOVE_STRAFE_RIGHT;
      cons_logAFloat("SK:Line160-MOVE_STRAFE_RIGHT", self.ai_move_next); //debug
    }
    else{
      self.ai_move_next = MOVE_STRAFE_LEFT;
      cons_logAFloat("SK:Line164-MOVE_STRAFE_LEFT", self.ai_move_next); //debug
    }
    return;
  }
  //RANK VET+
  self.ai_movedist = 1.5;
  if(dice < 0.25 ){
    self.ai_move_next = MOVE_CIRCLE_LEFT;
    cons_logAFloat("SK:Line172-MOVE_CIRCLE_LEFT", self.ai_move_next); //debug
  }
  else if( dice < 0.5 ){
    self.ai_move_next = MOVE_CIRCLE_RIGHT;
    cons_logAFloat("SK:Line176-MOVE_CIRCLE_RIGHT", self.ai_move_next); //debug
  }
  else if( dice < 0.75 ){
    self.ai_move_next = MOVE_CHARGE_RIGHT;
    cons_logAFloat("SK:Line180-MOVE_CHARGE_RIGHT", self.ai_move_next); //debug
  }
  else{
    self.ai_move_next = MOVE_CHARGE_LEFT;
    cons_logAFloat("SK:Line184-MOVE_CHARGE_LEFT", self.ai_move_next); //debug
  }
  return;
};


void(float dice) mech_sk_fight_mid_rear={
  //RANK ROK
  if( self.ai_rank == AI_RANK_ROK ){
    self.ai_movedist = 7;
    if( dice < 0.33 ){
      self.ai_move_next = MOVE_STAND_FACE;
      cons_logAFloat("SK:Line196-MOVE_STAND_FACE", self.ai_move_next); //debug
    }
    else if( dice < 0.66 ){
      self.ai_move_next = MOVE_CHARGE;
      cons_logAFloat("SK:Line200-MOVE_CHARGE", self.ai_move_next); //debug
    }
    else{
      self.ai_move_next = MOVE_CHARGE_LEFT;
      cons_logAFloat("SK:Line204-MOVE_CHARGE_LEFT", self.ai_move_next); //debug
    }
    return;
  }
  //RANK REG
  if( self.ai_rank == AI_RANK_REG ){
    self.ai_movedist = 4;
    if( dice < 0.6 ){
      self.ai_move_next = MOVE_CHARGE_RIGHT;
      cons_logAFloat("SK:Line212-MOVE_CHARGE_RIGHT", self.ai_move_next); //debug
    }
    else{
      self.ai_move_next = MOVE_CHARGE_LEFT;
      cons_logAFloat("SK:Line216-MOVE_CHARGE_LEFT", self.ai_move_next); //debug
    }
    return;
  }
  //RANK VET+
    self.ai_movedist = 2;
  if( dice < 0.33 ){
    self.ai_move_next = MOVE_STRAFE_RIGHT;
    cons_logAFloat("SK:Line225-MOVE_STRAFE_RIGHT", self.ai_move_next); //debug
  }
  else if( dice < 0.66 ){
    self.ai_move_next = MOVE_BACK;
    cons_logAFloat("SK:Line229-MOVE_BACK", self.ai_move_next); //debug
  }
  else{
    self.ai_move_next = MOVE_STRAFE_LEFT;
    cons_logAFloat("SK:Line233-MOVE_STRAFE_LEFT", self.ai_move_next); //debug
  }
};



void(float dice) mech_sk_fight_far_front={

};


void(float dice) mech_sk_fight_far_rear={

};
