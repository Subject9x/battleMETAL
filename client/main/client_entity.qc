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
  sendent_handle_update( isnew );
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
  local entity weps;
  local entity next;
  local entity rem;
  
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
      weps = self.w_slot;
      while( weps ){
        next = weps.w_slot;
        rem = weps;
        weps = next;
        if( rem.owner == self ){
          remove(rem);
        }
      }
      if( self.torsoCenter.owner == self ){
        remove(self.torsoCenter);
      }
      if( self.torsoLeft.owner == self ){
        remove(self.torsoLeft);
      }
      if( self.torsoRight.owner == self ){
        remove(self.torsoRight);
      }
      if( self.armLeft.owner == self ){
        remove(self.armLeft);
      }
      if( self.armRight.owner == self ){
        remove( self.armRight);
      }
      if( self.legs.owner == self ){
        remove(self.legs );
      }
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