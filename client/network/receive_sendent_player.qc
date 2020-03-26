/*
battleMETAL
Author: Peter Roohr
Date: 3/25/2020
Overview: 
  SendEnt impl for turret buildings
  
  handles
    sv/main/sv/sv_client_api.send_client_data()
*/


//todo - pipe hit offsets from common/data/ to this spot.
void( float critBits ) sendevent_player_critical={
  if( (critBits & M_TOR_LEFT) ){
    //te_missile_explode( self.torsoLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;

  }
  if( (critBits & M_TOR_RIGHT) ){
    //te_missile_explode( self.torsoRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;

  }
  if( (critBits & M_ARM_LEFT) ){
    //te_missile_explode( self.armLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;

  }
  if( (critBits & M_ARM_RIGHT) ){
    //te_missile_explode( self.armRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;

  }
  if( (critBits & M_LEGS) ){
    //te_missile_explode( self.legs.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;

  }

};

void( float isNew, float changeFlags) sendent_handle_player={
  local float prevShield;
  local float prevCrit;
  
  prevShield = self.shield;
  prevCrit = self.damageValue;
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
  
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
  
  if( (changeFlags & SENDFLAG_CRIT) ){
    self.damageValue = ReadByte();
    if( prevCrit < self.damageValue ){
    }
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
  
  
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
    self.netname = strzone( ReadString() );
  }
};