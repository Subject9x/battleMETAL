/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/


//TE_LASER_BEAM
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

//TE_ESR_BEAM
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

//TE_PAC_BEAM
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


//TE_SMOKE_TEST
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

//HUD Sound Effects
//make sure to scope self to target client
void() te_nav_reach={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_NAV_REACH );
};

void(float type) te_objective_complete={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_OBJECTIVE_COMPLETE );
  WriteByte( MSG_ONE, type );
};

void() te_objective_failed={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_OBJECTIVE_FAILED );
};

void() te_mission_win={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MISSION_WIN );
};

void() te_mission_lose={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MISSION_LOSE );
};











