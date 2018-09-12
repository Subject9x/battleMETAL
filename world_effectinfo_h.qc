/*
  battleMETAL
  Date: 11/29/2017
  Author: Peter Roohr
  Overview: custom TE_'s using the effectinfo.txt system
*/

//compound effects

/*void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};*/

void() s_mzl_las1 = [0, s_mzl_las2]{};
void() s_mzl_las2 = [1, s_mzl_las3]{};
void() s_mzl_las3 = [2, s_mzl_las3]{};
void() s_mzl_las4 = [3, SUB_Remove]{};

void(vector org, vector color) te_muzzle_laser;

//TE IMPL
void(vector org, vector end) te_beam_laser;
void(vector org, vector end) te_beam_esr;
void(vector org, vector end) te_beam_pac;
void(vector org, vector vel, float cnt) te_smoke_test;