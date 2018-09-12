/*
  battleMETAL
  Date: 9/6/2018
  Author: Peter Roohr
  Overview: client particle system header
*/


float( float te_id ) te_effect_delegate;
vector() te_read_vector;

float(vector org, vector end) te_beam_laser;
float(vector org, vector end) te_beam_esr;
float(vector org, vector end) te_beam_pac;
float(vector org, vector vel, float cnt) te_smoke_test;