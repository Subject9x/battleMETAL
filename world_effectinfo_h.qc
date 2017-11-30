/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/


float TE_LASER_BEAM = 60;
float TE_ESR_BEAM = 61;
float TE_PAC_BEAM = 62;

void(vector org, vector end) te_beam_laser;
void(vector org, vector end) te_beam_esr;
void(vector org, vector end) te_beam_pac;
