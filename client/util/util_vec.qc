/*
battleMETAL 
Author: Peter Roohr
Date: 11/10/2021
Overview:
  darkplaces engine vec funcs
*/

vector nullvec;

vector opvecA;
vector opvecB;

vector() vec_add={
  local vector out;
  
  out_x = opvecA_x + opvecB_x;
  out_y = opvecA_y + opvecB_y;
  out_z = opvecA_z + opvecB_z;
  
  opvecA = nullvec;
  opvecB = nullvec;
  
  return out;
};

vector() vec_subtract={
  local vector out;
  
  out_x = opvecA_x - opvecB_x;
  out_y = opvecA_y - opvecB_y;
  out_z = opvecA_z - opvecB_z;
  
  opvecA = nullvec;
  opvecB = nullvec;
  
  return out;
};

vector() vec_multiply={
  local vector out;
  
  out_x = opvecA_x * opvecB_x;
  out_y = opvecA_y * opvecB_y;
  out_z = opvecA_z * opvecB_z;
  
  opvecA = nullvec;
  opvecB = nullvec;
  
  return out;
};

vector(vector v, vector c) vec_copy={
  
  v_x = c_x;
  v_y = c_y;
  v_z = c_z;
  
  return v;
};

//ha, mutators
vector storeVec1;
vector storeVec2;

float storeVal1;
float storeVal2;

float (float value, float frac, float store)lowpass={
  
	frac = bound(0, frac, 1);
  storeVal1 = store * (1 - frac) + value * frac;
	return storeVal1;
};

float (float value, float frac, float limit, float store)lowpass_limited={
  lowpass(value, frac, store);
  storeVal1 = bound(value - limit, storeVal1, value + limit);
  return storeVal1;
};

float (float value, float frac, float store)highpass={
	return value - lowpass(value, frac, store);
};

float (float value, float frac, float limit, float store)highpass_limited={
	return value - lowpass_limited(value, frac, limit, store);
};

//set storeVec1 before op
vector (vector value, float fracx, float fracy, float fracz)lowpass3={
  local vector out;
  
  storeVal1 = 0;
  storeVal1 = storeVec1_x;
  out_x = lowpass(value_x, fracx, storeVal1);
  storeVec1_x = storeVal1;
  
  storeVal1 = 0;
  storeVal1 = storeVec1_y;
  out_y = lowpass(value_y, fracy, storeVal1);
  storeVec1_y = storeVal1;
  
  storeVal1 = 0;
  storeVal1 = storeVec1_z;
  out_z = lowpass(value_z, fracz, storeVal1);
  storeVec1_z = storeVal1;
  
  return out;
};

//set storeVec1 before op
vector (vector value, float fracx, float fracy, float fracz)highpass3={
  local vector out;
  
  storeVal1 = 0;
  storeVal1 = storeVec1_x;
  out_x = highpass(value_x, fracx, storeVal1);
  storeVec1_x = storeVal1;
  
  
  storeVal1 = 0;
  storeVal1 = storeVec1_y;
  out_y = highpass(value_y, fracy, storeVal1);
  storeVec1_y = storeVal1;
	
  
  storeVal1 = 0;
  storeVal1 = storeVec1_z;
  out_z = highpass(value_z, fracz, storeVal1);
  storeVec1_z = storeVal1;
  
  return out;
};

//set storeVec1 before op
vector (vector value, float fracx, float limitx, float fracy, float limity, float fracz, float limitz )highpass3_limited={
  local vector out;
  
  storeVal1 = 0;
  storeVal1 = storeVec1_x;
  out_x = highpass_limited(value_x, fracx, storeVal1);
  storeVec1_x = storeVal1;
  
  storeVal1 = 0;
  storeVal1 = storeVec1_y;
  out_y = highpass_limited(value_y, fracy, storeVal1);
  storeVec1_y = storeVal1;
  
  storeVal1 = 0;
  storeVal1 = storeVec1_z;
  out_z = highpass_limited(value_z, fracz, storeVal1);
  storeVec1_z = storeVal1;
  
  return out;
};

float cl_leanmodel_side_speed = 0.7;  //0.7
float cl_leanmodel_side_limit = 35; //35
float cl_leanmodel_side_highpass1 = 30;//30
float cl_leanmodel_side_highpass = 3; //3
float cl_leanmodel_side_lowpass = 20; //20

float cl_leanmodel_up_speed = 0.65;
float cl_leanmodel_up_limit = 50;
float cl_leanmodel_up_highpass1 = 5;
float cl_leanmodel_up_highpass = 15;
float cl_leanmodel_up_lowpass = 20;


vector input_angles_prev;

vector hudangles_prev;
vector hudangles_highpass;
vector hudangles_adjustment_lowpass;
vector hudangles_adjustment_highpass;

void(entity struts) hud_rotate_delay={
  local vector gunangles;
  local vector viewangles;
  
  viewangles = input_angles;
  
  opvecA = hudangles_highpass;
  opvecB = hudangles_prev;
  hudangles_highpass = vec_add();
  
  hudangles_highpass_x = 0;//hudangles_highpass_x + (360 * floor((viewangles_x - hudangles_highpass_x / 360 + 0.5)));
  hudangles_highpass_y = hudangles_highpass_y + (360 * floor((viewangles_y - hudangles_highpass_y / 360 + 0.5)));
  hudangles_highpass_z = 0;//hudangles_highpass_z + (360 * floor((viewangles_z - hudangles_highpass_z / 360 + 0.5)));
  
  storeVec1 = nullvec;
  storeVec1 = hudangles_highpass;
    gunangles = highpass3_limited(viewangles, frametime*cl_leanmodel_up_highpass1, cl_leanmodel_up_limit, frametime*cl_leanmodel_side_highpass1, cl_leanmodel_side_limit, 0, 0);
  hudangles_highpass = storeVec1;

  hudangles_prev = vec_copy(hudangles_prev, viewangles);
  
  opvecA = hudangles_highpass;
  opvecB = hudangles_prev;
  hudangles_highpass = vec_subtract();

  gunangles_x = 0;//gunangles_x * (cl_leanmodel_up_speed * -1);
  gunangles_y = gunangles_y * (cl_leanmodel_side_speed * -1);
  gunangles_z = 0;
  
  storeVec1 = nullvec;
  storeVec1 = hudangles_adjustment_highpass;
    gunangles = highpass3(gunangles, frametime*cl_leanmodel_up_highpass, frametime*cl_leanmodel_side_highpass, 0);
  hudangles_adjustment_highpass = storeVec1;
  
  storeVec1 = nullvec;
  storeVec1 = hudangles_adjustment_lowpass;
    gunangles = lowpass3(gunangles, frametime*cl_leanmodel_up_lowpass, frametime*cl_leanmodel_side_lowpass, 0);
  hudangles_adjustment_lowpass = storeVec1;
  
  opvecA = gunangles;
  opvecB = input_angles;
  gunangles = vec_add();
  
  struts.angles_x = 0;
  struts.angles_y = anglemod(gunangles_y);
  struts.angles_z = 0;
};