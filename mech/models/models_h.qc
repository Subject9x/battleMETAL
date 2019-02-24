/*
mech mod
Author: Peter Roohr
Date: 9/22/2016
Refactor: 12/29/2018
Overview: 
  old - header file for mech animation files
  
  header for any bespoke animation systems...
  
  these must be defined by their parent entity
  FrameStart - start of a specific frame group
  FrameEnd - end of specific frame group
  
  example:
    weapons
      fireFrameStart = 0
      fireFrameEnd = 3

*/

/*
  Weapons
*/
.float fireFrameStart;
.float fireFrameEnd;

/*
  LEGS
*/
float FRAMEGROUP_LEG_WALK = 1;
float FRAMEGROUP_LEG_RUN  = 2;

void( entity legs ) anim_leg_control;

.float legFrameState;
.float legFramePrev;

.float walkFrameStart;
.float walkFrameEnd;

.float runFrameStart;
.float runFrameEnd;

$frame l_stand1
$frame l_walk1 l_walk2 l_walk3 l_walk4 l_walk5 l_walk6 l_walk7 l_walk8
$frame l_die1 l_die2 l_die3 l_die4

void() leg_stand1;
void() leg_die1;
void() leg_die2;
void() leg_die3;
void() leg_die4;
void() leg_walk1;
void() leg_walk2;
void() leg_walk3;
void() leg_walk4;
void() leg_walk5;
void() leg_walk6;
void() leg_walk7;
void() leg_walk8;
//not sure how easy it is to reverse anims here;
void() leg_back1;
void() leg_back2;
void() leg_back3;
void() leg_back4;
void() leg_back5;
void() leg_back6;
void() leg_back7;
void() leg_back8;


void() bot_leg_stand1;
void() bot_leg_die1;
void() bot_leg_die2;
void() bot_leg_die3;
void() bot_leg_die4;
void() bot_leg_walk1;
void() bot_leg_walk2;
void() bot_leg_walk3;
void() bot_leg_walk4;
void() bot_leg_walk5;
void() bot_leg_walk6;
void() bot_leg_walk7;
void() bot_leg_walk8;
void() bot_leg_back1;
void() bot_leg_back2;
void() bot_leg_back3;
void() bot_leg_back4;
void() bot_leg_back5;
void() bot_leg_back6;
void() bot_leg_back7;
void() bot_leg_back8;
/*
  CENTER TORSO
*/
$frame ctorstand1

$frame ctorDie1 ctorDie2 ctorDie3

void() ctor_stand;
void() ctor_die1;
void() ctor_die2;
void() ctor_die3;


/*
  SIDE TORSO
*/

/*
  ARM
*/