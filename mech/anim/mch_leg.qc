/*
mech mod
Author: Peter Roohr
Date: 9/22/2016
Overview: test animation harness
*/

/*void()	mech_walk2 =	[$walk2, mech_walk3] {};
void()	mech_walk3 =	[$walk3, mech_walk4] {};
void()	mech_walk4 =	[$walk4, mech_walk5] {};
void()	mech_walk5 =	[$walk5, mech_walk6] {};
void()	mech_walk6 =	[$walk6, mech_walk7] {};
void()	mech_walk7 =	[$walk7, leg_walk1] {};*/

void() leg_stand1 = [$l_stand1, leg_stand1]{
  
  if (self.owner.velocity_x || self.owner.velocity_y){
    leg_walk1();
    return;
  }
};

void() leg_walk1;

void() leg_walk1 = [$l_walk1, leg_walk2]{
  self.walkframe = $l_walk1;
  if((self.owner.flags & FL_CLIENT)){  
    if (!self.owner.velocity_x && !self.owner.velocity_y){
      leg_stand1();
      return;
    }
  }
};

void() leg_walk2 = [$l_walk2, leg_walk3]{};
void() leg_walk3 = [$l_walk3, leg_walk4]{
  local entity player;
  player = self.owner;
  if( (player.flags & FL_ONGROUND) ){
    local vector ofs;
    makevectors(player.angles);
    ofs = player.origin + ((v_up*-44)+(v_forward*8)+(v_right*10));
    te_spark(ofs, '0 0 25', 15);
    sound (self, CHAN_BODY, "sound/mech_stomp.ogg", 1, ATTN_NORM);
  }
};
void() leg_walk4 = [$l_walk4, leg_walk5]{};
void() leg_walk5 = [$l_walk5, leg_walk6]{};
void() leg_walk6 = [$l_walk6, leg_walk7]{
  local entity player;
  player = self.owner;
  if((player.flags & FL_ONGROUND)){
    local vector ofs;
    makevectors(player.angles);
    ofs = player.origin + ((v_up*-44)+(v_forward*8)+(v_right*-10));
    te_spark(ofs, '0 0 25', 15);
    sound (self, CHAN_BODY, "sound/mech_stomp.ogg", 1, ATTN_NORM);
  }
};
void() leg_walk7 = [$l_walk7, leg_walk8]{};
void() leg_walk8 = [$l_walk8, leg_walk1]{};

void() leg_die1 = [$l_die1, leg_die2]{
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_BBOX;
};
void() leg_die2 = [$l_die2, leg_die3]{};
void() leg_die3 = [$l_die3, leg_die4]{};
void() leg_die4 = [$l_die4, leg_die4]{
  
  self.deadflag = DEAD_DEAD;
  self.think = SUB_Remove;
  self.nextthink = time + 100;
};

void() player_movestart =
{
  self.walkframe = 0;
  if(self.owner.velocity_x || self.owner.velocity_y){
    leg_walk1();
  }else{
    leg_stand1();
  }
};