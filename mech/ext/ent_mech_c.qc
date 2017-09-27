/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: 'class' for mech data / actual ents

commented vars mean they're already implemented and are here for reference!
*/

//local vars
.vector prev_angle;
//reactor
.float en_max;   //max amount
.float en_cur;  //current amount
.float en_rate; //how much energy built per frame
.float sh_max;    //max shields
.float sh_cur;    //current amount of shields
.float sh_rate;   //shield recharge rate
.float sh_hit;

.vector conv_min;
.vector conv_max;

.float m_rot_speed;
.string m_pitch_min;
.string m_pitch_max;
.float m_speed;
//.float i_techLevel;
//.string data_type;

//child entites
.entity e_legs;
.entity e_cam;
.entity e_tor_c;  //now is the player themselves, this is here for data purposes
.entity e_tor_l;
.entity e_arm_l;  //arms can be optional
.entity e_tor_r;
.entity e_arm_r;  //arms can be optional

//Client-side data and cosmetics
.float m_fspeed; //forward speed
.float m_sspeed; //side strafe speed
.float m_bspeed; //backward speed
.float m_maccel;

.string m_bob;    //bob settings are important for dat immersion
.string m_bcycle;
.string m_bup;  
.string m_rollangle;
.string m_bmodel;
.string m_bside;
.string m_bobspd;

