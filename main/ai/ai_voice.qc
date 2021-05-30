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

void() ai_sfx_spotted={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
      self.ai_voice_id = AI_VOICE_SPOTTED;
      self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
    } 
  }
};

void() ai_sfx_warning={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      self.voiceTime = time + ((AI_VOICE_TIME / 2) + (random() * AI_VOICE_TIME));
      self.ai_voice_id = AI_VOICE_WARN;
      self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
    }
  }
};

void() ai_sfx_huntStart={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( (self.enemy.flags & FL_CLIENT) ){
    self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
      self.ai_voice_id = AI_VOICE_HUNT_START;
      self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
  }
};

void() ai_sfx_huntEnd={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 4));
      self.ai_voice_id = AI_VOICE_HUNT_END;
      self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
    }
  }
};

void() ai_sfx_dying={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( time > self.voiceTime ){
    self.voiceTime = time + (AI_VOICE_TIME + (random() * 2));
    self.ai_voice_id = AI_VOICE_DYING;
    self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
  }
};

void() ai_sfx_dead={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( time > self.voiceTime ){
    if( random() < 0.33 ){
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 8));
      self.ai_voice_id = AI_VOICE_DEAD;
      self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
    }
  }
};

void() ai_sfx_kill={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 3));
      self.ai_voice_id = AI_VOICE_KILL;
      self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
    }
  }
};

void() ai_sfx_roger={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD  ){
    return;
  }
  if( time > self.voiceTime ){
    self.voiceTime = time + (AI_VOICE_TIME + (random() * 12));
    self.ai_voice_id = AI_VOICE_ROGER;
    self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
  }
};

void() ai_sfx_help={
  if( (self.spawnflags & MUTE_ME) || self.data_type == DATA_BLD ){
    return;
  }
  if( time > self.voiceTime ){
    if( (self.enemy.flags & FL_CLIENT) ){
      self.voiceTime = time + (AI_VOICE_TIME + (random() * 16));
      self.ai_voice_id = AI_VOICE_HELP;
      self.SendFlags = self.SendFlags | SENDFLAG_VOICE;
    }
  }
};

