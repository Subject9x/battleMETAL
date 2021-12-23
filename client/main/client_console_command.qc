/*
battleMETAL
Author: Peter Roohr
Date: 12/06/2021
Overview:
  Breaking client_main into pieces for better maintainability.
*/


// called on all console commands, but be sure to registercmd() first so the tab completion works!
// return FALSE to let engine process command, TRUE to eat command

/*
  note: currently not used in battleMETAL, functional, but I never found a good use-case.
*/
float(string s) CSQC_ConsoleCommand =
{
  return FALSE;
};