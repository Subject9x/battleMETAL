//=====================================
// Game: battleMETAL
// info: unit shaders
//=====================================

//----------------------------------------------------
//                 Wreckage no shadow
//----------------------------------------------------
models/map/ruins/ruin_small
{
  dpNoShadow
  {
    map models/map/ruins/ruin_large
    rgbgen lightingDiffuse
  }
}
models/map/ruins/ruin_medium
{
  dpNoShadow
  {
    map models/map/ruins/ruin_large
    rgbgen lightingDiffuse
  }
}
models/map/ruins/ruin_large
{
  dpNoShadow
  {
    map models/map/ruins/ruin_large
    rgbgen lightingDiffuse
  }
}
//----------------------------------------------------
//                 Turret stuff
//----------------------------------------------------
models/buildings/turret_light/bld_h_turret_c
{
  dpShadow
  dpmeshcollisions
  {
    map models/buildings/turret_light/bld_h_turret_c
    rgbgen lightingDiffuse
  }
}
models/buildings/turret_missile/bld_turret_missile
{
  dpShadow
  {
    map models/buildings/turret_missile/bld_turret_missile
    rgbgen lightingDiffuse
  }
}
models/buildings/turret_heavy/bld_turret_heavy
{
  dpShadow
  {
    map models/buildings/turret_heavy/bld_turret_heavy
    rgbgen lightingDiffuse
  }
}