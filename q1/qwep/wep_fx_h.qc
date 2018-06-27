/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: header for fx...ugh
*/

void()	s_explode1	=	[1,		s_explode2] {};
void()	s_explode2	=	[2,		s_explode3] {};
void()	s_explode3	=	[3,		s_explode4] {};
void()	s_explode4	=	[4,		s_explode5] {};
void()	s_explode5	=	[5,		s_explode6] {};
void()	s_explode6	=	[6,		SUB_Remove] {};

void() BecomeExplosion;

vector(float dm) VelocityForDamage;