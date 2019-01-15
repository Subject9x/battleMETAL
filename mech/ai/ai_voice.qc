/*
battleMETAL
Author: Peter Roohr
Date: 1/15/2019
Overview: 
  Impl file for AI voice events
*/

void(float ifaction, float datatype) ai_sfx_spotted={
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !self.ai_voice_spot ){
        if( cvar("developer") ){
          cons_logAString(self.classname, "<missing 'spot' sound>"); 
          cons_logAString("ai says:", "target spotted!");
        }
        return;
      }
      self.voiceTime = time + 3;
      client_send_ai_voice( self.enemy, self.ai_voice_spot );
    } 
  }
};

void(float ifaction, float datatype ) ai_sfx_warning={
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !self.ai_voice_warn ){
        if( cvar("developer") ){
          cons_logAString(self.classname, "<missing 'warn' sound>"); 
          cons_logAString("ai says", "I think I see something");
        }
        return;
      }
      self.voiceTime = time + 2;
      client_send_ai_voice( self.enemy, self.ai_voice_warn );
    }
  }
};

void() ai_sfx_huntStart={
  if( (self.enemy.flags & FL_CLIENT) ){
    if( !self.ai_voice_huntStart ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'huntStart' sound>"); 
        cons_logAString("ai says", "hunting my target");
      }
      return;
    }
    self.voiceTime = time + 0.5;
    client_send_ai_voice( self.enemy, self.ai_voice_huntStart );
  }
};

void() ai_sfx_huntEnd={
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !self.ai_voice_huntEnd ){
        if( cvar("developer") ){
          cons_logAString(self.classname, "<missing 'huntEnd' sound>"); 
          cons_logAString("ai says", "can't find target, ending hunt");
        }
        return;
      }
      self.voiceTime = time + 1;
      client_send_ai_voice( self.enemy, self.ai_voice_huntEnd );
    }
  }
};

void() ai_sfx_dying={
  if( time > self.voiceTime ){
    if( !self.ai_voice_dying ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'ai_voice_dying' sound>"); 
        cons_logAString("ai says", "I'm DYING");
      }
      return;
    }
    local entity clients;
    clients = findchainflags(flags, FL_CLIENT);
    while( clients ){
      client_send_ai_voice( clients, self.ai_voice_dying );
      clients = clients.chain;
    }
    self.voiceTime = time + 4;
  }
};

void() ai_sfx_dead={
  if( !self.ai_voice_dead ){
    if( cvar("developer") ){
      cons_logAString(self.classname, "<missing 'ai_voice_dead' sound>"); 
      cons_logAString("ai says", "IM DEAD");
    }
    return;
  }
  local entity clients;
  clients = findchainflags(flags, FL_CLIENT);
  while( clients ){
    client_send_ai_voice( clients, self.ai_voice_dead );
    clients = clients.chain;
  }
};

void() ai_sfx_kill={
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !self.ai_voice_kill ){
        if( cvar("developer") ){
          cons_logAString(self.classname, "<missing 'kill' sound>"); 
          cons_logAString("ai says", "can't find target, ending hunt");
        }
        return;
      }
      client_send_ai_voice( self.enemy, self.ai_voice_kill );
      self.voiceTime = time + 1;
    }
  }
};

void() ai_sfx_roger={
  if( time > self.voiceTime ){
    if( !self.ai_voice_roger ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'roger' sound>"); 
        cons_logAString("ai says", "hacknowledged!"); 
      }
      return;
    }
    self.voiceTime = time + 1;
    local entity clients;
    clients = findchainflags(flags, FL_CLIENT);
    while( clients ){
      client_send_ai_voice( clients, self.ai_voice_roger );
      clients = clients.chain;
    }
  }
};

void() ai_sfx_help={
  if( time > self.voiceTime ){
    if( !self.ai_voice_help ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'help' sound>"); 
        cons_logAString("ai says", "help me!"); 
      }
      return;
    }
    self.voiceTime = time + 1;
    local entity clients;
    clients = findchainflags(flags, FL_CLIENT);
    while( clients ){
      client_send_ai_voice( clients, self.ai_voice_help );
      clients = clients.chain;
    }
  }
};

