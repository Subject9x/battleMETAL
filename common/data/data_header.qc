/*
battleMETAL
Author: Peter Roohr
Date: 01/22/2017
  mod: 11/26/2017
  mod: 01/28/2018
  mod: 05/20/2019
Overview: 
  header for all game-data related functions,
  its up to either the client or the server to define these functions
  
*/

entity weaponList;  //used by data functions to populate weapon lists for units
entity weaponBuild; //used by vehicle factory to build current weapon

/*
  called when building something with common/data info.
  instantiates the target object and populates it with
  parameter values.
*/
void( float partId, string modelPath, float maxHp, vector partOffset, entity parentPart, .entity partSlot ) data_ini_unitPiece_={
  local entity piece;
  piece = spawn();
  piece.comp_id = partId;
  piece.c_parent = parentPart.comp_id;
  piece.max_health = piece.health = maxHp;
  piece.model = modelPath;
  piece.c_ofs = partOffset;
  self.partSlot = piece;
  parentPart.partSlot = piece;
  piece.owner = self;
};

void( float weaponNum, float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_={
  local entity item;
  item = spawn();
  item.data_idx = 0;
  item.w_group = weaponNum;
  item.c_parent = parentPartId;
  item.c_ofs = pointOffset;
  item.w_adj_ang = adjustAngle;
  item.owner = self;
  item.vec_size = hardpointSize;
  item.p_dmgtype = hardpointType;
  weaponList.w_slot = item;
  weaponList = item;
  self.hardpoint_cnt = self.hardpoint_cnt + 1;
};

/*
  Simple wrapper functions for data_ini_unitHardpoint_.
  these are probably easier to read / write than t
*/
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_1={
 data_ini_unitHardpoint_( WEAPON1, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_2={
 data_ini_unitHardpoint_( WEAPON2, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_3={
 data_ini_unitHardpoint_( WEAPON3, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_4={
 data_ini_unitHardpoint_( WEAPON4, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_5={
 data_ini_unitHardpoint_( WEAPON5, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_6={
 data_ini_unitHardpoint_( WEAPON6, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_7={
 data_ini_unitHardpoint_( WEAPON7, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_8={
 data_ini_unitHardpoint_( WEAPON8, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};
void( float parentPartId, vector pointOffset, vector adjustAngle, float hardpointSize, float hardpointType ) data_ini_unitHardpoint_9={
 data_ini_unitHardpoint_( WEAPON9, parentPartId, pointOffset, adjustAngle, hardpointSize, hardpointType );
};



.void() unit_ini;
.void() unit_legs;
.void() unit_ctor;
.void() unit_ltor;
.void() unit_rtor;
.void() unit_larm;
.void() unit_rarm;
.void() unit_cam;
.void() unit_wep1;
.void() unit_wep2;
.void() unit_wep3;
.void() unit_wep4;
.void() unit_wep5;
.void() unit_wep6;
.void() unit_wep7;
.void() unit_wep8;
.void() unit_wep9;

//WEAPON INI
void() data_emp_ini;
void() data_esr_ini;
void() data_las_ini;
void() data_latc_ini;
void() data_marh_ini;
void() data_mis_ini;
void() data_mlgd_ini;
void() data_pac_ini;
void() data_qrfl_ini;
void() data_rplas_ini;
void() data_sfga_ini;
void() data_flak_ini;
void() data_swrm_ini;

//EQUIP INI
void() data_eqp_atgm_ini;
void() data_eqp_enbat_ini;
void() data_eqp_recap_ini;
void() data_eqp_lsar_ini;
void() data_eqp_hsem_ini;
void() data_eqp_scap_ini;

//PROJECTILE INI
void() data_prj_emp_ini;
void() data_prj_sfga_ini;
void() data_prj_marh_ini;
void() data_prj_mis_ini;
void() data_prj_mlgd_ini;
void() data_prj_qrfl_ini;
void() data_prj_rplas_ini;
void() data_prj_sfga_ini;
void() data_prj_flak_ini;
void() data_prj_swrm_ini;