/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: function extensions to world.qc
*/

void() mh_world_ini={
  mh_world_iniData();
};

void() mh_world_iniData={
  //projectile data
  prj_latc_ini();
  prj_emp_ini();
  prj_mis_ini();
  //weapon data
  latc_ini();
  emp_ini();
  mis_ini();
  las_ini();
  //mech data
  prt_ini();
  tmk_ini();
};

entity(float id, string dat_type) mh_world_findData={
  local entity found, data_chain;
  data_chain = findchain(classname, "data");
  while(data_chain){
    local float idx;
    idx = data_chain.data_idx;
    if(data_chain.data_type == dat_type){
      if(id == idx){
        return data_chain;
      }
    }
    data_chain = data_chain.chain;
  }
  return data_chain;
};

void(float fwd, float side, float bck, string accel, string roll) mh_world_updateClientSpeed={
  stuffcmd(self, "cl_forwardspeed ");
  stuffcmd(self, ftos(fwd)); //400
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_sidespeed ");
  stuffcmd(self, ftos(side)); //350
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_backspeed ");
  stuffcmd(self, ftos(bck)); //400
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_movement_accelerate ");
  stuffcmd(self, accel); //10
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_rollangle ");
  stuffcmd(self, roll);
  stuffcmd(self, "\n"); //2
};

void(string bob, string cycle, string up) mh_world_updateClientViewBob={
  stuffcmd(self, "cl_bob ");
  stuffcmd(self, bob); //0.02
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobcycle ");
  stuffcmd(self, cycle); //0.6
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobup ");
  stuffcmd(self, up); //0.5
  stuffcmd(self, "\n");
};
void(string bobmodel, string side, string bmod_speed) mh_world_updateClientModelBob={
  stuffcmd(self, "cl_bobmodel ");
  stuffcmd(self, bobmodel); //1
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobmodel_side ");
  stuffcmd(self, side); //	0.05
  stuffcmd(self, "\n");
  stuffcmd(self, "cl_bobmodel_speed ");
  stuffcmd(self, bmod_speed); //	7
  stuffcmd(self, "\n");
};

void(string p_max, string p_min) mh_world_updateClientViewPitch={
  stuffcmd(self, "in_pitch_max ");
  stuffcmd(self, p_max);
  stuffcmd(self, "\n");
  stuffcmd(self, "in_pitch_min ");
  stuffcmd(self, p_min);
  stuffcmd(self, "\n");
};