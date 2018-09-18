/*
  battleMETAL
  Date: 9/6/2018
  Author: Peter Roohr
  Overview: client particle system header
*/

void() te_quick_remove={
};

void() te_shield_think={
  local entity player;
  player = entitybyindex(PLAYER_ENTITYNUM);
  self.alpha = self.alpha - 0.3;
  self.angles = vectoangles( player.entorg - self.origin );
  if( self.alpha <= 0 ){
    self.alpha = 0;
    
    remove(self);
    return;
  }
  self.think = te_shield_think;
  self.nextthink = time + 0.1;
};

float( float te_id ) te_effect_delegate;
vector() te_read_vector;

float(vector org, vector end) te_beam_laser;
float(vector org, vector end) te_beam_esr;
float(vector org, vector end) te_beam_pac;
float(vector org, vector vel, float cnt) te_smoke_test;
float(vector org, vector angl ) te_shield_test;