/*
  battleMETAL
  Date: 9/6/2018
  Author: Peter Roohr
  Overview: impl of the client particle system
*/

/*
  TE_ delegate for all particle effects,
  other TE's are routed in a different direction
*/
float( float te_id ) te_effect_delegate={
  local float hand;
  hand = TRUE;
  switch( te_id ){
    case TE_LASER_BEAM:
      hand = te_beam_laser( te_read_vector(), te_read_vector() );
      break;
    case TE_ESR_BEAM:
      hand = te_beam_esr( te_read_vector(), te_read_vector() );
      break;
    case TE_PAC_BEAM:
      hand = te_beam_pac( te_read_vector(), te_read_vector() );
      break;
    case TE_SMOKE_TEST:
      hand = te_smoke_test( te_read_vector(), te_read_vector(), ReadByte() );
      break;
    default:
      hand = FALSE;
      break;
  }
  return hand;
};

/*
  probably should be a utility.
  in context of Write_*'s
  this assumes the next 3 Read_*'s
  should be a vector
*/
vector() te_read_vector={
  local vector newv;
  newv_x = ReadCoord();
  newv_y = ReadCoord();
  newv_z = ReadCoord();
  return newv;
};

//TE_LASER_BEAM = 61
float(vector org, vector end) te_beam_laser={
  trailparticles(world, particleeffectnum("BEAM_LASER"), org, end);
  return TRUE;
};

//TE_PAC_BEAM = 62;
float(vector org, vector end) te_beam_esr={
  trailparticles(world, particleeffectnum("BEAM_ESR"), org, end);
  return TRUE;
};

//TE_ESR_BEAM = 63
float(vector org, vector end) te_beam_pac={
  trailparticles(world, particleeffectnum("BEAM_PAC"), org, end);
  return TRUE;
};

//TE_SMOKE_TEST = 64;
float(vector org, vector vel, float cnt) te_smoke_test={
  pointparticles(particleeffectnum("SMOKE_TEST"), org , vel, cnt);
  return TRUE;
};