/*
battleMETAL 
Author: Peter Roohr
Date: 07/20/2020
Overview: 
  turrets are static buildings with rotating turrets,
    they're tanks treated like buildings.
    
  _die - all the death logic
*/

void() temp_chunk_burn={
  if( time > self.delay){
    self.think = SUB_Remove;
  }
  else{  
    te_smoke(self.origin, 1);
    self.think = temp_chunk_burn;
  }
	self.nextthink = time + 0.1;
};

void() ai_turret_clean={
  ctrl_unit_remove_piece(self.cockpit);
  ctrl_weapon_remove_all();
  ctrl_unit_remove_piece(self.torsoLeft);
  ctrl_unit_remove_piece(self.torsoRight);
  ctrl_unit_remove_piece(self.torsoCenter);
  
  self.think = ai_turret_die_burn;
  self.ai_action_time = time + 360;
  self.nextthink = time + 0.1;
};

/*
  TH_DIE
*/
void() ai_turret_die={

  if( self.deadflag > DEAD_NO ){
    return; //double play prevention
  }
  
  //ai_sfx_dead();
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.33 0.33 0.33';
  
  //annoying that turret corpses block a lot of fire.
  self.maxs_x = self.maxs_x * 0.33;
  self.maxs_y = self.maxs_y * 0.33;
  self.maxs_z = (self.maxs_z + (self.mins_z * -1)) * 0.67;
  self.mins_x = self.maxs_x * -1;
  self.mins_y = self.maxs_y * -1;
  self.mins_z = 0;
  setsize(self, self.mins, self.maxs);
  droptofloor();
  self.solid = SOLID_NOT;
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    ctrl_unit_part_death(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  ctrl_unit_part_death(self.cockpit);  
  ctrl_unit_part_death(self.torsoCenter);
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );

  makevectors( self.angles );
  
  ai_call_for_help( self.enemy );
  self.think = ai_turret_clean;
  self.nextthink = time + 0.75;
  
  te_debris( self.origin + (v_up * self.maxs_z * 0.33), self.angles, '0 0 0', rint(self.vec_size / 2 + (random() * self.vec_size+1)), self.vec_size );
  
  self.deadflag = DEAD_DEAD;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  self.effects = self.effects | EF_LOWPRECISION;
};

void() ai_turret_die_burn={  

  self.think = ai_turret_die_burn;
  self.nextthink = time + 0.1;
  
  if ( time > self.ai_action_time ){
    self.think = BecomeExplosion;
    self.nextthink = time + 0.01;
  }
};