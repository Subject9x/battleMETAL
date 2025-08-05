/*
battleMETAL
Date: 11/29/2017
mod: 07/02/2019
Author: Peter Roohr
Overview: 
  custom TE_'s using the effectinfo.txt system
*/


vector( vector startOrg ) te_apply_wind={
  local vector windVel;
  
  makevectors(world.wind);
  windVel = startOrg + (v_up * WINDDIR_z) + (v_forward * (-1 * (WINDDIR_z/2)) );
  return windVel;
};

float( entity to, float changedFlags ) te_send_missile={
  WriteByte( MSG_ENTITY, SENDTYPE_PROJ );
  WriteLong( MSG_ENTITY, changedFlags );
  
  if( (changedFlags & SENDFLAG_UPDATE_FULL) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteByte( MSG_ENTITY, self.damageValue );
    WriteShort( MSG_ENTITY, num_for_edict(self.owner));
  }
  
  if( (changedFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  
  if( (changedFlags & SENDFLAG_VELOCITY) ){
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteFloat( MSG_ENTITY, self.velocity_x );
    WriteFloat( MSG_ENTITY, self.velocity_y );
    WriteFloat( MSG_ENTITY, self.velocity_z );
  }
  
  if( (changedFlags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }
    
  if( (changedFlags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.impactType );
  }
  
  if( (changedFlags & SENDFLAG_BURN) ){
    WriteByte( MSG_ENTITY, self.vec_size );
  }
  return TRUE;
};

//ported over from classice Quake C
void(string gibname, float dm) ThrowGib ={
	newmis = spawn();
  if( newmis ){
    newmis.origin = self.origin;
    setmodel (newmis, gibname);
    setsize (newmis, '0 0 0', '0 0 0');
    newmis.velocity = VelocityForDamage (dm);
    newmis.movetype = MOVETYPE_BOUNCE;
    newmis.solid = SOLID_NOT;
    newmis.avelocity_x = random()*600;
    newmis.avelocity_y = random()*600;
    newmis.avelocity_z = random()*600;
    newmis.think = SUB_Remove;
    newmis.ltime = time;
    newmis.nextthink = time + 10 + random()*10;
    newmis.frame = 0;
    newmis.flags = 0;
    newmis.effects = newmis.effects | EF_LOWPRECISION;
  }
};

//TE_SMOKE_TEST
void(vector org, float total) te_smoke={
  TEMP_VEC1 = te_apply_wind( org );
  client_send_particle(particleeffectnum("SMOKE_TEST"), org , normalize(TEMP_VEC1 - org) * WINDDIR_z, total);
};

/*
  Creates a small flying smoking debris field
  mostly used for mech piece explosions
*/
void() te_debris_th={
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_VELOCITY);
  self.nextthink = time + 0.01;
  self.think = te_debris_th;
  if( time > self.data_lifetime ){
    self.think = SUB_Remove;
    DEBRIS_COUNT = DEBRIS_COUNT - 1;
    return;
  }
};

void( vector org, vector angl, vector vel, float total, float debrType ) te_debris={
  local float totals;
  local string debrisMdl;
  local float trailNum;
  
  //<sigh> these little buggers dump on the net traffic.
  if( cvar("gamemode") != GAMEMODE_CAMPAIGN ){
    return;
  }
  
  switch( debrType ){
    default:
      debrisMdl = "models/fx/debris1/mdl_debris_1.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_SMALL");
      break;
    case 2:
      debrisMdl = "models/fx/debris2/mdl_debris_2.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_MED");
      break;
    case 3:
      debrisMdl = "models/fx/debris3/mdl_debris_3.md3";
      trailNum = particleeffectnum("TE_DEBRIS_TRAIL_BIG");
      break;
  }
  
  totals = total;
  while( totals > 0 ){
    if( DEBRIS_COUNT < MAX_DEBRIS_COUNT ){
      DEBRIS_COUNT = DEBRIS_COUNT + 1;
      newmis = spawn();
      if( newmis ){
        setmodel (newmis, debrisMdl);
        setsize (newmis, '0 0 0', '0 0 0');
        setorigin(newmis, org);
        newmis.velocity_x = 100 * crandom();
        newmis.velocity_y = 100 * crandom();
        newmis.velocity_z = 75 + 100 * random();
        newmis.effects = newmis.effects | (EF_NOSHADOW | EF_LOWPRECISION);
        newmis.movetype = MOVETYPE_BOUNCE;
        newmis.solid = SOLID_NOT;
        newmis.think = te_debris_th;
        newmis.ltime = time;
        newmis.nextthink = time + 0.01;
        newmis.data_lifetime = time + 0.5;
        newmis.frame = 0;
        newmis.flags = 0;
        newmis.gravity = 0.15;
        newmis.vec_size = debrType;
        newmis.data_idx = UID_ITEM_debris;
        newmis.SendEntity = te_send_missile;
        newmis.SendFlags = newmis.SendFlags | (SENDFLAG_MOVE | SENDFLAG_VELOCITY | SENDFLAG_BURN);
        newmis.partTypeId = trailNum;
      }
    }
    totals = totals - 1;
  }
};

/*
  Armor debris is a more spalling like effect where debris flies out
  from impact point.
*/
void( vector org, vector angl, vector vel, float total, float debrType ) te_debris_armor={
  local float totals;
  local string debrisMdl;
  local vector back;
  
  //<sigh> these little buggers dump on the net traffic.
  if( cvar("gamemode") != GAMEMODE_CAMPAIGN ){
    return;
  }
  
  switch( debrType ){
    case 2:
      debrisMdl = "models/fx/debris2/mdl_debris_2.md3";
      break;
    case 3:
      debrisMdl = "models/fx/debris3/mdl_debris_3.md3";
      break;
    default:
      debrisMdl = "models/fx/debris1/mdl_debris_1.md3";
      break;
  }
  makevectors(angl);
  back = org + (v_forward * -10);
  back = normalize(back - org);
  
  totals = total;
  while( totals > 0 ){
    if( DEBRIS_COUNT < MAX_DEBRIS_COUNT ){
      DEBRIS_COUNT = DEBRIS_COUNT + 1;
      newmis = spawn();
      if( newmis ){
        setmodel (newmis, debrisMdl);
        setsize (newmis, '0 0 0', '0 0 0');
        setorigin(newmis, org);
        newmis.velocity_x = (back_x * 400) + (random() * 200);
        newmis.velocity_y = (back_y * 400) + (random() * 200);
        newmis.velocity_z = (back_z + 50) + (random() * 50);
        newmis.effects = newmis.effects | (EF_NOSHADOW | EF_LOWPRECISION);
        newmis.movetype = MOVETYPE_BOUNCE;
        newmis.solid = SOLID_NOT;
        newmis.think = te_debris_th;
        newmis.ltime = time;
        newmis.nextthink = time + 0.025;
        newmis.data_lifetime = time + 1 + random() * 3;
        newmis.frame = 0;
        newmis.flags = 0;
        newmis.gravity = 0.15;
        newmis.vec_size = debrType;
        newmis.data_idx = UID_ITEM_debris;
        newmis.SendEntity = te_send_missile;
        newmis.SendFlags = newmis.SendFlags | (SENDFLAG_MOVE | SENDFLAG_VELOCITY | SENDFLAG_BURN);
      }
    }
    totals = totals - 1;
  }
};

void( vector org, vector angl, vector vel, float total) te_unit_dust={
  local float partcle;
  
  makevectors(self.angles);
  TEMP_VEC2 = org + (v_up * (self.mins_z / 1.5) ) + (v_forward * (self.mins_x / 4));
  TEMP_VEC3 = te_apply_wind( TEMP_VEC2 );
  TEMP_VEC3 = normalize( TEMP_VEC3 - org ) * WINDDIR_z;
  
  switch( world.worldtype ){
    default:
      partcle = particleeffectnum("TE_DUST_DESERT");
      break;
    case 1:
      partcle = particleeffectnum("TE_DUST_ICE");
      break;
    case 2: 
      partcle = particleeffectnum("TE_DUST_URBAN");
      break;
    case 3:
      partcle = particleeffectnum("TE_DUST_BADLANDS");
      break;
    case 4:
      partcle = particleeffectnum("TE_DUST_TUNDRA");
      break;
  }
  
  client_send_particle( partcle, TEMP_VEC2 , TEMP_VEC3 * 2, total);
};

void() te_flame_th={
  
  self.compAltOffset = te_apply_wind( self.origin );
  client_send_particle( particleeffectnum(self.vec_name), self.origin, normalize(self.compAltOffset - self.origin) * WINDDIR_z, self.count);

  self.think = te_flame_th;
  if( self.data_lifetime > 0 ){
    if( time > self.data_lifetime ){
      self.think = SUB_Remove;
    }
  }
  if( self.health > 0 ){
    if( time > self.health ){
      self.think = SUB_Remove;
    }
  }
  self.nextthink = time + self.count2;
};


/*
  server side missile explosions because good lord, CSCQ doesn't give us any PVS culling whatsoever....
    so use this on the server if explosion is truly inconsequential for players to see.
*/
void() te_missile_explode_th={
  self.alpha = self.alpha - 0.025;
  self.scale = self.scale + self.data_lifetime;
  self.think = te_missile_explode_th;
  if( self.alpha < 0.01 ){
    remove(self);
    return;
  }
  self.nextthink = time + 0.01;
};
void( vector org, float explodeSize, vector explodeColor, float bloom ) te_missile_explode={

  newmis = spawn();
  if( newmis ){
    newmis.movetype = MOVETYPE_NONE;
    newmis.solid = SOLID_NOT;
    newmis.think = te_missile_explode_th;
    newmis.nextthink = time + 0.05;
    newmis.scale = explodeSize;
    newmis.alpha = 1;
    newmis.effects = newmis.effects | EF_NOSHADOW | EF_FULLBRIGHT | EF_LOWPRECISION;
    newmis.avelocity = randomvec() * 300;
    newmis.angles = randomvec() * 30;
    newmis.data_lifetime = bloom;
    
    if( explodeColor != '0 0 0' ){
      newmis.colormod = explodeColor;
    }
    
    setmodel( newmis, "models/fx/explosions/te_missile_explode.md3");
    setorigin( newmis, org);
  }

  te_customflash( org, explodeSize * 50, 1, explodeColor);
  
  
  makevectors(vectoangles(self.velocity));
  TEMP_VEC2 = org + (v_forward * -10);
  TEMP_VEC2 = normalize(TEMP_VEC2 - org);
  
  if(explodeSize < 2 ){
    pointparticles( particleeffectnum("TE_HIT_EXPL_SML"), org, TEMP_VEC2, 1);
  }
  if(explodeSize == 2){
    pointparticles( particleeffectnum("TE_HIT_EXPL_MED"), org, TEMP_VEC2, 1);
  }
  else{
    pointparticles( particleeffectnum("TE_HIT_EXPL_LRG"), org, TEMP_VEC2, 1);
  }
};



/*
  When a part is blown off a mech
*/
void() te_vehicle_chunk_th={  
  //trail effect for desired time, then a half-life as post-burn
  if( time > self.ai_action_time && self.traileffectnum ){
    self.traileffectnum = 0;
    self.ai_action_time = self.data_lifetime * 0.33;
    self.think = SUB_Remove;
    self.nextthink = time + self.ai_action_time;
    return;
  }
  if( time > self.ai_movewait ){
    self.solid = SOLID_CORPSE;
  }
  
  self.think = te_vehicle_chunk_th;
  self.nextthink = time + random() * 0.5;
  if( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

/*
  Scope
    self = calling unit
*/
void( string mdl, vector startOrg, vector wishVel, vector wishAngl, float trailnum, float lifetime, float grav ) te_vehicle_chunk={

  newmis = spawn();
  if( newmis ){
    newmis.effects = newmis.effects | (EF_NOSHADOW | EF_LOWPRECISION);
    newmis.movetype = MOVETYPE_TOSS;
    newmis.solid = SOLID_NOT;
    newmis.frame = 0;
    newmis.angles = wishAngl;
    newmis.skin = 3;
    
    setmodel(newmis, mdl);
    setsize (newmis, '-4 -4 -4', '4 4 4');
    setorigin(newmis, startOrg);
    
    newmis.traileffectnum = trailnum;
    if( wishVel != '0 0 0' ){
      newmis.velocity = wishVel;
    }
    else{
      newmis.velocity_x = 100 * crandom();
      newmis.velocity_y = 100 * crandom();
      newmis.velocity_z = 50 + 100 * random();
    }
    newmis.avelocity_x = random()*100;
    newmis.avelocity_y = random()*100;
    newmis.avelocity_z = random()*150;
    if( lifetime ){
      newmis.data_lifetime = lifetime;
      newmis.ai_action_time = time + lifetime;
    }
    else{
      newmis.data_lifetime = 30;
      newmis.ai_action_time = time + lifetime;
    }
    if( grav ){
      newmis.gravity = grav;
    }
    else{
      newmis.gravity = 0.67;
    }
    newmis.think = te_vehicle_chunk_th;
    newmis.nextthink = time + 0.1;
    newmis.ai_movewait = time + 3;
  }
};

void() te_msn_boundary={
  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MSN_BOUND );
};

//passive shield effects
void(entity e) te_shields_active={
  pointparticles(particleeffectnum("TE_SHIELD_ON"), e.origin + randomvec2() * e.maxs_x , '0 0 0', 1);
};
void(entity e) te_shields_down={
  trailparticles( e, particleeffectnum("TE_SHIELD_DOWN"), randompos(e.origin + e.mins, e.origin + e.maxs), randompos(e.origin + e.mins, e.origin + e.maxs)) ;
};