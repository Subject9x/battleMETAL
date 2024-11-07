/*
battleMETAL
Author: Peter Roohr
Date: 12/06/2021
Overview:
  Breaking client_main into pieces for better maintainability.
*/


// called when a network slot was previously empty, before parsing begins
// this basically lets you do extra work before returning the result of spawn()
// OPTIONAL, probably should be deprecated as well
// do. not. use. - tis borked - Roohr
/*entity(float entNum) CSQC_Ent_Spawn =
{
  local entity e;
  e = spawn();
  e.entnum = entNum;
  return e;
};*/



// parse a network update, isnew indicates this network slot was previously empty
// if you wish to do interpolation, be sure to make use the proper time variables: 
//  time is previous packet time, 
//  servertime is new packet time, 
//so the tick time between packets is servertime - time and the interpolation should begin 
//the new move at servertime and end at servertime + (servertime - time)
void(float isnew) CSQC_Ent_Update =
{
  local float entType;
  local float entFlags;
  
  entType = ReadByte();
  entFlags = ReadLong(); //expanding entFlags values -> data/common
  
  switch(entType){
    case SENDTYPE_TANK:
      sendent_handle_tank( isnew, entFlags );
      break;
    case SENDTYPE_SPG:
      sendent_handle_spg( isnew, entFlags );
      break;
    case SENDTYPE_GEV:
      sendent_handle_gev( isnew, entFlags );
      break;
    case SENDTYPE_TURRET:
      sendent_handle_turret( isnew, entFlags );
      break;
    case SENDTYPE_BUILD:
      sendent_handle_building( isnew, entFlags );
      break;
    case SENDTYPE_MECH_AI:
      sendent_handle_mech_ai( isnew, entFlags );
      break;
    case SENDTYPE_PROJ:
      sendent_handle_missile( isnew, entFlags );
      break;
    case SENDTYPE_MAP:
      sendent_handle_map( isnew, entFlags );
      break;
    case SENDTYPE_TERRAIN:
      sendent_handle_terrain( isnew, entFlags );
      break;
    //case SENDTYPE_MISC: //note: see main/map/map_scenery
      //sendent_handle_misc( isnew, entFlags );
      //break;
    case SENDTYPE_MISC_BLD:
      sendent_handle_misc_bld( isnew, entFlags );
      break;
    case SENDTYPE_ITEM:
      sendent_handle_item( isnew, entFlags );
      break;
    case SENDTYPE_CLIENT:
      sendent_handle_client( isnew, entFlags );
      break;
  }
};

// 
/*
  called when a network slot is emptied, you may choose to remove(self) or not - Darkplaces
  
  context: CSQC DOES NOT know the 'why' behind calling the Remove() function, but its important
    to know the 2 main 'whys'.
      1) Entity was removed/deallocated from the Server, ie SSQC.remove(entity);
      2) Entity fell out of client's view scope, and no longer visible to client.
      
    knowing these 2 cases makes all the difference about executing this function.
*/
void() CSQC_Ent_Remove ={
  
  self.entnum = 0; //clears out old reference, must have!
  
  if( (self.flags & FL_CLIENT) ){
    if(self.t_remove){
      if(!self.t_remove()){
        remove(self);
      }
    }
    else{
      remove(self);
    }
  }
  else{  
    if( self.data_type == DATA_VEHC || self.data_type == DATA_MECH || self.data_type == DATA_BLD ){
      if( self.effect1.owner == self ){
        remove(self.effect1 );
      }
      if( self.effect2.owner == self ){
        remove(self.effect2 );
      }
      if( self.effect3.owner == self ){
        remove(self.effect3 );
      }
    }
    freeGlobalString(self.netname)
  }
  if( wasfreed(self) ){
    return;
  }
  remove(self);
};