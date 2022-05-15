//=====================================
// Game: battleMETAL
// info: unit shaders
//=====================================

//----------------------------------------------------
//                 Wreckage no shadow
//----------------------------------------------------
q3mdl/map/ruins/ruin_small
{
  dpNoShadow
  {
    map q3mdl/map/ruins/ruin_large
    rgbgen lightingDiffuse
  }
}
q3mdl/map/ruins/ruin_medium
{
  dpNoShadow
  {
    map q3mdl/map/ruins/ruin_large
    rgbgen lightingDiffuse
  }
}
q3mdl/map/ruins/ruin_large
{
  dpNoShadow
  {
    map q3mdl/map/ruins/ruin_large
    rgbgen lightingDiffuse
  }
}
//----------------------------------------------------
//                 Turret stuff
//----------------------------------------------------
q3mdl/buildings/turret_light/bld_h_turret_c
{
  dpShadow
  dpmeshcollisions
  {
    map q3mdl/buildings/turret_light/bld_h_turret_c
    rgbgen lightingDiffuse
  }
}
q3mdl/buildings/turret_missile/bld_turret_missile
{
  dpShadow
  {
    map q3mdl/buildings/turret_missile/bld_turret_missile
    rgbgen lightingDiffuse
  }
}
q3mdl/buildings/turret_heavy/bld_turret_heavy
{
  dpShadow
  {
    map q3mdl/buildings/turret_heavy/bld_turret_heavy
    rgbgen lightingDiffuse
  }
}