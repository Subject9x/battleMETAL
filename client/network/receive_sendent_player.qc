/*
battleMETAL
Author: Peter Roohr
Date: 3/25/2020
Overview: 
  SendEnt impl for turret buildings
  
  handles
    sv/main/sv/sv_client_api.send_client_data()
*/

void( float isNew, float changeFlags) sendent_handle_player={

  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin = te_read_vector();
    setorigin(self, self.origin);
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.radar_range = ReadByte();
    self.stat_rdr_mode = ReadByte();
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_TURRET) ){
    self.data_type = ReadByte();
    self.faction = ReadByte();
    self.vec_size = ReadByte();
  }
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    self.vec_size = ReadByte();
    self.origin = te_read_vector();
    setorigin(self, self.origin);
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.radar_range = ReadByte();
    self.stat_rdr_mode = ReadByte();
    self.shield = ReadByte();
  }
};