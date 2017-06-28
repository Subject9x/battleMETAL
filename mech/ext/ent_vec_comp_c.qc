/*
mech mod
Author: Subject9x
Date: 8/27/2016
Overview: 'class' for a vehicle component
commented vars mean they're already implemented and are here for reference!
*/

//.string faction;
//.float i_techLevel;
//.string data_type;

//.frame;
//.health;
//.max_health;
//.armortype;
//.armorvalue

.string c_model;
.string c_parent;
.string c_name;    //data reference, different than ‘classname
.vector c_ofs;
.vector c_alt_ofs;    //useful alt offset
.vector c_bbx_n;    //min / max of bbox
.vector c_bbx_x;
.entity c_part;