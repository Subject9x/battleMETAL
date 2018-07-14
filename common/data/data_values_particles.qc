/*
battleMETAL
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for particles
*/

//TE_ ID's
float TE_LASER_BEAM = 60;
float TE_ESR_BEAM = 61;
float TE_PAC_BEAM = 62;
float TE_SMOKE_TEST = 63;

//TE IMPL
void(vector org, vector end) te_beam_laser;
void(vector org, vector end) te_beam_esr;
void(vector org, vector end) te_beam_pac;
void(vector org, vector vel, float cnt) te_smoke_test;
