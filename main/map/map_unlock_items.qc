/*
battleMETAL
Author: 
Date: 10/29/2019
Overview: 
  map_unlock_item, when triggered via its use() method, this will add its unlock value to the
  map's .unlockMechs and .unlockEquip fields. it does check for duplicates when running the unlock.

DEPRECATED - UNSTABLE - 4/19/2020

*/

void() map_unlock_item_use={
  local string itemId, newItems;
  local float tokens, tokenIterator;
  local float tokenLen;
  local float add;
  add = 0;
  newItems = "";
  tokens = tokenizebyseparator(self.unlockMechs, " ");
  tokenIterator = 0;
  
  while( tokenIterator < tokens ){
    itemId = argv(tokenIterator);
    tokenLen = strlen(itemId);
    add = strstrofs(MAP_UNLOCK_MECHS, itemId, 0);
    
    if( add == -1 ){
      newItems = strcat(newItems, " ", itemId);
    }
    tokenIterator = tokenIterator + 1;
  }
  MAP_UNLOCK_MECHS = strzone(strcat(MAP_UNLOCK_MECHS, newItems));
  
  newItems = "";
  tokens = tokenizebyseparator(self.unlockEquip, " ");
  tokenIterator = 0;
  while( tokenIterator < tokens ){
    itemId = argv(tokenIterator);
    tokenLen = strlen(itemId);
    add = strstrofs(MAP_UNLOCK_EQUIP, itemId, 0);
    
    if( add == -1 ){
      newItems = strcat(newItems, " ", itemId);
    }
    tokenIterator = tokenIterator + 1;
  }
  MAP_UNLOCK_EQUIP = strzone(strcat(MAP_UNLOCK_EQUIP, newItems));
  
  if( self.target ){
    self.enemy = find(world, classname, "player");
    multi_use();
  }
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

/*QUAKED map_unlock_items (-32 -32 -64) (32 32 64) - ONTOUCH
  will provide unlocked mechs and items to player.
  + format is space-separated values
  + each value is the UID of the mech or item.
-------- KEYS -------- 
.targetname = <string> call by trigger.
.target = <string> will fire other triggers after being used.
.unlockMechs = <string> 
.unlockEquip = <string>
-------- SPAWNFLAGS --------
ONTOUCH 2 : will fire ontouch instead of by targetname.
*/
void() map_unlock_items={
  util_MapDeveloperMarker();
  util_DeveloperNodeMark();
  
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  
  if( (self.spawnflags & 2) ){
    self.solid = SOLID_TRIGGER;
    self.touch = map_unlock_item_use;
  }
  
  setsize(self, '-16 -16 -32', '16 16 32');
  setorigin(self, self.origin);
};