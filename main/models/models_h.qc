/*
battleMETAL
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

.float legFrameState;
.float legFramePrev;

.float walkFrameStart;
.float walkFrameEnd;

.float runFrameStart;
.float runFrameEnd;

$frame l_stand1
$frame l_walk1 l_walk2 l_walk3 l_walk4 l_walk5 l_walk6 l_walk7 l_walk8
$frame l_die1 l_die2 l_die3 l_die4

void() leg_die1;

void() leg_die_touch;
void() bot_leg_die1;
void() bot_leg_die2;
void() bot_leg_die3;
