/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview: class file for the client -> server command layer

*/

void(float slot, float w_bit) cl_setweapon={

  local string cmd;
  cmd = strcat("cmd mech setwep ", ftos(slot), " ", ftos(w_bit), "\n");
  localcmd(cmd);

};

void(float sz, float id) cl_setmech={
  local string cmd;
  cmd = strcat("cmd mech setmech ", ftos(sz)," ", ftos(id), "\n");
  localcmd(cmd);
};

void() cl_spawnmech={
  local string cmd;
  cmd = "cmd mech spawn\n";
  localcmd(cmd);
};

void(float grp_id, float grp_val) cl_setweapongroup={
  local string cmd;
  cmd = strcat("cmd mech setgroup ", ftos(grp_id)," ",ftos(grp_val), "\n");
  localcmd(cmd);
};

void(float nav_id) cl_setspawnpoint={
  local string cmd;
  cmd = strcat("cmd mech setnav ", ftos(nav_id), "\n");
  localcmd(cmd);
};