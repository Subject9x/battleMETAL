/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/


//TE_LASER_BEAM = 61
void(vector org, vector end) te_beam_laser={
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte (MSG_BROADCAST, TE_LASER_BEAM);
  WriteCoord (MSG_BROADCAST, org_x);
  WriteCoord (MSG_BROADCAST, org_y);
  WriteCoord (MSG_BROADCAST, org_z);
  WriteCoord (MSG_BROADCAST, end_x);
  WriteCoord (MSG_BROADCAST, end_y);
  WriteCoord (MSG_BROADCAST, end_z);
};

//TE_ESR_BEAM = 62
void(vector org, vector end) te_beam_esr={
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte (MSG_BROADCAST, TE_ESR_BEAM);
  WriteCoord (MSG_BROADCAST, org_x);
  WriteCoord (MSG_BROADCAST, org_y);
  WriteCoord (MSG_BROADCAST, org_z);
  WriteCoord (MSG_BROADCAST, end_x);
  WriteCoord (MSG_BROADCAST, end_y);
  WriteCoord (MSG_BROADCAST, end_z);
};

//TE_PAC_BEAM = 63;
void(vector org, vector end) te_beam_pac={
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte (MSG_BROADCAST, TE_PAC_BEAM);
  WriteCoord (MSG_BROADCAST, org_x);
  WriteCoord (MSG_BROADCAST, org_y);
  WriteCoord (MSG_BROADCAST, org_z);
  WriteCoord (MSG_BROADCAST, end_x);
  WriteCoord (MSG_BROADCAST, end_y);
  WriteCoord (MSG_BROADCAST, end_z);
};


//TE_SMOKE_TEST = 64;
void(vector org, vector vel, float cnt) te_smoke_test={
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte (MSG_BROADCAST, TE_SMOKE_TEST);
  WriteCoord (MSG_BROADCAST, org_x);
  WriteCoord (MSG_BROADCAST, org_y);
  WriteCoord (MSG_BROADCAST, org_z);
  WriteCoord (MSG_BROADCAST, vel_x);
  WriteCoord (MSG_BROADCAST, vel_y);
  WriteCoord (MSG_BROADCAST, vel_z);
  WriteByte (MSG_BROADCAST, cnt);
};


void(vector org, vector angl) te_shield_test={
  WriteByte( MSG_BROADCAST, SVC_TEMPENTITY );
  WriteByte( MSG_BROADCAST, TE_SHIELD_TEST );
  WriteCoord (MSG_BROADCAST, org_x);
  WriteCoord (MSG_BROADCAST, org_y);
  WriteCoord (MSG_BROADCAST, org_z);
  WriteCoord (MSG_BROADCAST, angl_x);
  WriteCoord (MSG_BROADCAST, angl_y);
  WriteCoord (MSG_BROADCAST, angl_z);
};

//compound effects
void(vector org, vector clr) te_muzzle_laser={
  local entity vfx;
  vfx = spawn();
  vfx.movetype = SOLID_NOT;
  vfx.classname = "missile";
  setmodel(vfx, "q3mdl/muzzle_laser.spr32");
  setsize(vfx, '-1 -1 -1', '1 1 1');
  setorigin(vfx, org);
  vfx.alpha = 0.85;
  vfx.glow_color = 250;
  vfx.glow_size = 1;
  vfx.glow_trail = TRUE;
  vfx.color = util_rgbToFloat(clr);
  vfx.scale = 0.15;
  s_mzl_las1();
};