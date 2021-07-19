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
  if( self.deadflag == DEAD_NO ){
    makevectors(self.w_adj_ang);
    adddynamiclight2( self.origin + (v_forward * 32), 128, '1 1 0.4', self.partTypeId, "", PFLAGS_FULLDYNAMIC);
  }
};

/*
  Guard Post - Think
*/
void() guard_post_th={
  if( self.spawnflags & 2097152){
    //shutoff lights
    self.render_dlights = SUB_Null;
    return;
  }
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
  building_sound_explode();
  
  self.think = guard_post_die2;
  self.nextthink = time + 0.1;
};

void() guard_post_die2={
  makevectors(self.angles);
  
  te_missile_explode( self.origin + (v_up * 24), 5, '1 0.75 1', 0.01 );
  building_sound_explode();
  
  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};
