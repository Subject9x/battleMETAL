/*
  battleMETAL
  Date: 9/6/2018
  Author: Peter Roohr
  Overview: client particle system header
*/

/*
  Fog fun
*/
float FOG_STATE;  //0 = no change, 1 = change
float FOG_DENSITY;
float FOG_RED;
float FOG_GREEN;
float FOG_BLUE;
float FOG_ALPHA;
float FOG_DIST_MIN;
float FOG_DIST_MAX;
float FOG_DIST_TOP;
float FOG_FADE_DEPTH;

float FOG_TARG_DENSITY;
float FOG_TARG_RED;
float FOG_TARG_GREEN;
float FOG_TARG_BLUE;
float FOG_TARG_ALPHA;
float FOG_TARG_DIST_MIN;
float FOG_TARG_DIST_MAX;
float FOG_TARG_DIST_TOP;
float FOG_TARG_FADE_DEPTH;

float( float fogColor, float fogColorTarg  ) cl_particles_fogColorAdjust;
float( float fogDist, float fogDistTarg ) cl_particles_fogDistAdjust;
void() cl_particles_fogFrame;


//===================================
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