/*
battleMETAL
Author: Peter Roohr
Date: 8/31/2016
mod: 08/01/2019
Overview: header for all 'global'-ish player funcs
*/

void() PlayerDie;
void() PlayerDieEnd;  //replaces think functions originally set by player animations.
void() PlayerDead;
void() PlayerDeathThink;
void() PlayerJump;
//ENGINE REQUIRED===================================
void() PlayerPreThink;
void() PlayerPostThink;