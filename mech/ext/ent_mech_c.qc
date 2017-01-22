/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: 'class' for mech data / actual ents

commented vars mean they're already implemented and are here for reference!
*/

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

//local vars
//reactor
.float en_max;   //max amount
.float en_cur;  //current amount
.float en_rate; //how much energy built per frame

.float sh_max;    //max shields
.float sh_cur;    //current amount of shields
.float sh_rate;   //shield recharge rate
.float sh_hit;


.float l_dmg;
.float m_rot_speed;
.string m_pitch_min;
.string m_pitch_max;
//.string faction;
//.float i_techLevel;
//.string data_type;

//.void() w_group1;
//.void() w_group2;
//.void() w_group3;
.void() th_ctrl;    //update function

//child entites
.entity e_legs;
.entity e_leg_l;
.entity e_leg_r;
.entity e_cam;    //now using the dp client camera, this is here for data purposes
.entity e_tor_c;  //now is the player themselves, this is here for data purposes
.entity e_tor_l;
.entity e_arm_l;  //arms can be optional
.entity e_tor_r;
.entity e_arm_r;  //arms can be optional
.entity e_cpit;

//Client-side data and cosmetics
.float m_fspeed; //forward speed
.float m_sspeed; //side strafe speed
.float m_bspeed; //backward speed
.string m_maccel;

.string m_bob;    //bob settings are important for dat immersion
.string m_bcycle;
.string m_bup;  
.string m_rollangle;
.string m_bmodel;
.string m_bside;
.string m_bobspd;

//cockpit
.string m_cockpit;
.vector m_view;
.string m_cockpit_model;

