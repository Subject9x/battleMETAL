/*
battleMETAL
Author: Peter Roohr
Date: 1/15/2019
Overview: 
  Impl file for AI voice events
  
ref: Globals
AI_VOICE_DEAD       = 0;
AI_VOICE_DYING      = 1;
AI_VOICE_HELP       = 2;
AI_VOICE_HUNT_END   = 3;
AI_VOICE_HUNT_START = 4;
AI_VOICE_KILL       = 5;
AI_VOICE_NOSPOT     = 6;
AI_VOICE_ROGER      = 7;
AI_VOICE_SPOTTED    = 8;
AI_VOICE_WARN       = 9;
*/

float AI_VOICE_TIME = 6;

void( float randomBool ) ai_voice_ini={
  local float randoVoice;
  
  if( (self.spawnflags & AI_SPAWNFLAG_MUTED) ){
    return;
  }
  
  if( randomBool ){
    randoVoice = random();
    
    if( randoVoice <= 0.4 ){
      //VOICE  A
      self.ai_voice_group = AI_VOICE_GROUP_A;
    }
    else if( randoVoice <= 0.7 ){
      //VOICE  B
      self.ai_voice_group = AI_VOICE_GROUP_B;
    }
    else{
      self.ai_voice_group = AI_VOICE_GROUP_C;
    }
  }
  else{
    //VOICE DEBUG
    //self.ai_voice_group = AI_VOICE_GROUP_C;
  }
};

void() ai_sfx_spotted={
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !self.ai_voice_group ){
        if( cvar("developer") ){
          cons_logAString(self.classname, "<missing 'spot' sound>"); 
          cons_logAString("ai says:", "target spotted!");
        }
        return;
      }
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
      client_send_ai_voice( self.enemy, self.ai_voice_group, AI_VOICE_SPOTTED, 1);
    } 
  }
};

void() ai_sfx_warning={
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !self.ai_voice_group ){
        if( cvar("developer") ){
          cons_logAString(self.classname, "<missing 'warn' sound>"); 
          cons_logAString("ai says", "I think I see something");
        }
        return;
      }
      self.voiceTime = time + (0.67 + (random() * AI_VOICE_TIME));
      client_send_ai_voice( self.enemy, self.ai_voice_group, AI_VOICE_WARN, 2);
    }
  }
};

void() ai_sfx_huntStart={
  if( !self.ai_voice_group ){
    if( cvar("developer") ){
      cons_logAString(self.classname, "<missing 'huntStart' sound>"); 
      cons_logAString("ai says", "hunting my target");
    }
    return;
  }
  self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
  client_send_ai_voice_all( self.ai_voice_group, AI_VOICE_HUNT_START, 1);
};

void() ai_sfx_huntEnd={
  if( time > self.voiceTime ){
    if( !self.ai_voice_group ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'huntEnd' sound>"); 
        cons_logAString("ai says", "can't find target, ending hunt");
      }
      return;
    }
    self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
    client_send_ai_voice_all( self.ai_voice_group, AI_VOICE_HUNT_END, 1) ;
  }
};

void() ai_sfx_dying={
  if( time > self.voiceTime ){
    if( !self.ai_voice_group ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'ai_voice_dying' sound>"); 
        cons_logAString("ai says", "I'm DYING");
      }
      return;
    }
    client_send_ai_voice_all( self.ai_voice_group, AI_VOICE_DYING, 1) ;
    self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
  }
};

void() ai_sfx_dead={
  if( time > self.voiceTime ){
    if( !self.ai_voice_group ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'ai_voice_dead' sound>"); 
        cons_logAString("ai says", "IM DEAD");
      }
      return;
    }
    if( random() < 0.33 ){
      client_send_ai_voice_all( self.ai_voice_group, AI_VOICE_DEAD, 1) ;
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));    
    }
  }
};

void() ai_sfx_kill={
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      if( !self.ai_voice_group ){
        if( cvar("developer") ){
          cons_logAString(self.classname, "<missing 'kill' sound>"); 
          cons_logAString("ai says", "can't find target, ending hunt");
        }
        return;
      }
      client_send_ai_voice_all( self.ai_voice_group, AI_VOICE_KILL, 1);
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
    }
  }
};

void() ai_sfx_roger={
  if( time > self.voiceTime ){
    if( !self.ai_voice_group ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'roger' sound>"); 
        cons_logAString("ai says", "hacknowledged!"); 
      }
      return;
    }
    self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
    client_send_ai_voice_all( self.ai_voice_group, AI_VOICE_ROGER, 1);
  }
};

void() ai_sfx_help={
  if( time > self.voiceTime ){
    if( !self.ai_voice_group ){
      if( cvar("developer") ){
        cons_logAString(self.classname, "<missing 'help' sound>"); 
        cons_logAString("ai says", "help me!"); 
      }
      return;
    }
    self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
    client_send_ai_voice_all( self.ai_voice_group, AI_VOICE_HELP, 1);
  }
};

