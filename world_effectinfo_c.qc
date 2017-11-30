/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/


//TE_LASER_BEAM = 60
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

//TE_ESR_BEAM = 61
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

//TE_PAC_BEAM = 62;
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
