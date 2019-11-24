/*
battleMETAL
Author: Peter Roohr
Date: 11/02/2016
mod:  05/16/2019
Overview: 
  CSQC definition extensions for battleMETAL.
  Extends {entity} with new vars for use around CSQC.
*/

//widget vars
.float drawme;
.vector drawsize;
.vector drawcolor1; //these are interpreted differently

//navpoint
.float isActive;
.float nav_name;
.vector ui_org;
.vector uequipSize;
