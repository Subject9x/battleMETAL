/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/


//TE_LASER_BEAM = 60
void(vector org, vector end) te_beam_laser={
  trailparticles(world, particleeffectnum("BEAM_LASER"), org, end);
};

//TE_PAC_BEAM = 62;
void(vector org, vector end) te_beam_esr={
  trailparticles(world, particleeffectnum("BEAM_ESR"), org, end);
};

//TE_ESR_BEAM = 61
void(vector org, vector end) te_beam_pac={
  trailparticles(world, particleeffectnum("BEAM_PAC"), org, end);
};

//TE_SMOKE_TEST = 63;
void(vector org, vector vel, float cnt) te_smoke_test={
  pointparticles(particleeffectnum("SMOKE_TEST"), org , vel, cnt);
};