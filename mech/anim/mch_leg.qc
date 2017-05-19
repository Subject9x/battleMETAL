/*
mech mod
Author: Subject9x
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
  if ((self.owner.velocity_x || self.owner.velocity_y) && !self.owner.velocity_z){
		self.walkframe=0;
		leg_walk1();
		return;
	}
};

void() leg_walk1;

void() leg_walk1 = [$l_walk1, leg_walk2]{
  if (!self.owner.velocity_x && !self.owner.velocity_y){
		self.walkframe=8;
		leg_stand1();
		return;
	}
  /*self.walkframe = self.walkframe + 1;
  if(self.walkframe >= 7){
    self.walkframe = 0;
  }*/
  //self.frame = self.walkframe;
};

void() leg_walk2 = [$l_walk2, leg_walk3]{
  local entity player;
  player = self.owner;
  if((player.flags & FL_ONGROUND)){
    local vector ofs;
    makevectors(player.angles);
    ofs = player.origin + ((v_up*-44)+(v_forward*8)+(v_right*10));
    te_spark(ofs, '0 0 25', 15);
  }

};
void() leg_walk3 = [$l_walk3, leg_walk4]{};
void() leg_walk4 = [$l_walk4, leg_walk5]{
  local entity player;
  player = self.owner;
  if((player.flags & FL_ONGROUND)){
    local vector ofs;
    makevectors(player.angles);
    ofs = player.origin + ((v_up*-44)+(v_forward*8)+(v_right*-10));
    te_spark(ofs, '0 0 25', 15);
  }
};
void() leg_walk5 = [$l_walk5, leg_walk6]{};
void() leg_walk6 = [$l_walk6, leg_walk7]{};
void() leg_walk7 = [$l_walk7, leg_walk1]{};



void() leg_die1 = [$l_die1, leg_die2]{
  //setsize(self, '-12 -12 -4','12 12 4');
  self.movetype = MOVETYPE_BOUNCE;
};
void() leg_die2 = [$l_die2, leg_die3]{};
void() leg_die3 = [$l_die3, leg_die4]{};
void() leg_die4 = [$l_die4, leg_die4]{
  
  self.deadflag = DEAD_DEAD;
  self.nextthink = -1;
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