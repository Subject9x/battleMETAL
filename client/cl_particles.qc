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
    case TE_SHIELD_TEST:
      hand = te_shield_test( te_read_vector(), te_read_vector() ) ;
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

float(vector org, vector end) te_beam_laser={
  trailparticles(world, particleeffectnum("BEAM_LASER"), org, end);
  return TRUE;
};


float(vector org, vector end) te_beam_esr={
  trailparticles(world, particleeffectnum("BEAM_ESR"), org, end);
  return TRUE;
};

float(vector org, vector end) te_beam_pac={
  trailparticles(world, particleeffectnum("BEAM_PAC"), org, end);
  return TRUE;
};


float(vector org, vector vel, float cnt) te_smoke_test={
  pointparticles(particleeffectnum("SMOKE_TEST"), org , vel, cnt);
  return TRUE;
};

float(vector org, vector angl) te_shield_test={
  local entity burst;
  makevectors( angl );
  org = org + v_forward * 10;
  burst = spawn();
  setorigin(burst, org);
  setmodel(burst, "q3mdl/fx_shield.md3");
  setsize(burst, '-1 -1 -1', '1 1 1');
  burst.angles = angl;
  burst.alpha = 1;
  burst.effects = EF_NOSHADOW | EF_BLUE | EF_ADDITIVE;
  burst.movetype = MOVETYPE_NONE;
  burst.solid = SOLID_NOT;
  burst.think = te_shield_think;
  burst.nextthink = time + 0.1;
  burst.drawmask = MASK_NORMAL;
  sound(burst, CHAN_VOICE, "sound/fx_shieldhit.ogg", 0.75, ATTN_NORM);

  te_customflash(org, 50, 0.3, '0 0 1'); 
  return TRUE;
};

/*
  Fog subsystem
*/
float( float fogColor, float fogColorTarg ) cl_particles_fogColorAdjust={
  local float result;
  
  result = fogColor;
  if( result > fogColorTarg ){
    result = result - 0.0001;
  }
  if( result < fogColorTarg ){
    result = result + 0.0001;
  }
  return result;
};

float( float fogDist, float fogDistTarg ) cl_particles_fogDistAdjust={
  local float result;
  
  result = fogDist;
  if( result > fogDistTarg ){
    result = result - 1;
  }
  if( result < fogDistTarg ){
    result = result + 1;
  }
  return result;
};

/*
  checks every frame to see if fog needs to transition
*/
void() cl_particles_fogFrame={
  local string newFog;
    
  if( FOG_STATE == TRUE ){
    FOG_DENSITY = cl_particles_fogColorAdjust( FOG_DENSITY, FOG_TARG_DENSITY);
    
    FOG_RED = cl_particles_fogColorAdjust( FOG_RED, FOG_TARG_RED);
    FOG_GREEN = cl_particles_fogColorAdjust( FOG_GREEN, FOG_TARG_GREEN);
    FOG_BLUE = cl_particles_fogColorAdjust( FOG_BLUE, FOG_TARG_BLUE);
    
    FOG_ALPHA = cl_particles_fogColorAdjust( FOG_ALPHA, FOG_TARG_ALPHA);
    
    FOG_DIST_MIN = cl_particles_fogDistAdjust( FOG_DIST_MIN, FOG_TARG_DIST_MIN );
    FOG_DIST_MAX = cl_particles_fogDistAdjust( FOG_DIST_MAX, FOG_TARG_DIST_MAX );
    FOG_DIST_TOP = cl_particles_fogDistAdjust( FOG_DIST_TOP, FOG_TARG_DIST_TOP );
    FOG_FADE_DEPTH = cl_particles_fogDistAdjust( FOG_FADE_DEPTH, FOG_TARG_FADE_DEPTH );

    newFog = strcat("fog ", ftos(FOG_DENSITY)," ");
    newFog = strcat(newFog, ftos(FOG_RED)," ");
    newFog = strcat(newFog, ftos(FOG_GREEN)," ");
    newFog = strcat(newFog, ftos(FOG_BLUE)," ");
    newFog = strcat(newFog, ftos(FOG_ALPHA)," ");
    newFog = strcat(newFog, ftos(FOG_DIST_MIN)," ");
    newFog = strcat(newFog, ftos(FOG_DIST_MAX)," ");
    newFog = strcat(newFog, ftos(FOG_DIST_TOP)," ");
    newFog = strcat(newFog, ftos(FOG_FADE_DEPTH),"\n");
    localcmd(newFog);
  }
};