/*
battleMETAL
Author: Peter Roohr
Date: 03/24/2020
Overview: 
  CSQC-side animations for guard towers
*/

/*
  Guard Post - Dynamic Lights
*/
void() guard_post_dlights={
  local vector spotlight;
  
  if( self.deadflag == DEAD_NO ){
    makevectors(self.w_adj_ang);
    adddynamiclight2( self.origin + (v_forward * 32), 128, '1 1 0.4', 0, "", PFLAGS_NOSHADOW);
  }
};

/*
  Guard Post - Think
*/
void() guard_post_th={
  if( self.deadflag == DEAD_NO ){
    self.w_adj_ang_y = anglemod(self.w_adj_ang_y + 4);
  }
  self.think = guard_post_th;
  self.nextthink = time + 0.05;
};

/*
  Guard Post - DEATH
*/
void() guard_post_die1={
  
  
  self.think = guard_post_die2;
  self.nextthink = time + 0.1;
};

void() guard_post_die2={
  makevectors(self.angles);
  
  te_missile_explode( self.origin + (v_up * 24), 5, '1 0.75 1', 0.01 );
  pointsound( self.origin + (v_up * 24), "sound/fx_boom.ogg", (0.3 + random() * 0.3), ATTN_NORM);
  
  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};
