/*
battleMETAL
Author: Peter Roohr
Date: 08/05/2020
Overview: 
  Simple Campaign file that both the Menu and Client reference.
  
  Campaign files simply keep track of sets of levels by referencing the 'start' map for a campaign.
  The campaign name is also saved to the player save file and shown when choosing a save file.
*/

#ifdef MENUQC
void() campaign_loadfiles={
  local float itr;
  local float flannel, line_tag, token;
  local string contents, line;
  local float searchHandle;
  local float files;
  local string filename;
  local float inObject;
  local string filenameClean;
  
  //quake/dp functionality is really wierd, lots of reliance
  //on inaccessible / hidden arrays for things like search results and server host lists...
  searchHandle = search_begin("data/campaigns/*.dat", TRUE, FALSE);
  
  files = search_getsize(searchHandle);
  itr = 0;
  token = 4; //general pointer inside tokenized msn file value
  
  inObject = FALSE;
  if( files > 0 ){
    while( itr < files ){
      filename = search_getfilename(searchHandle, itr);
      
      if( filename && filename != "" ){
        flannel = fopen(filename, FILE_READ);
        contents = fgets(flannel);
        
        tokenizebyseparator(filename, "/", ".");
        filenameClean = strcat(argv(2), ".", argv(3));
        cacheGlobalString( CAMP_FILES[itr], filenameClean )
        
        tokenizebyseparator(contents, "{",",","}");
        line = fgets(flannel);
      
        while( (line != "") ){
          if( substring(line,0, 2) != "//" ){
            if( line == "{" ){
              inObject = TRUE;
            }
            else if( line == "}" && inObject){
              inObject = FALSE;
            }
            else{
              if( inObject ){
                //LOAD CAMPAIGN DATA
                line_tag = tokenizebyseparator(line, "'", "'", ": ","'","'");
                if (argv(1) == CAMP_TAG_NAME){
                  if( argv(token) != "" ){
                    cacheGlobalString( CAMP_NAME[itr+1], substring(argv(token),0, 32) )
                  }
                }
                if (argv(1) == CAMP_TAG_START){
                  if( argv(token) != "" ){
                    cacheGlobalString( CAMP_START[itr+1], argv(token) )
                  }
                }
                if (argv(1) == CAMP_TAG_INFO){
                  if( argv(token) != "" ){
                    cacheGlobalString( CAMP_INFO[itr+1], argv(token) )
                  }
                }
                if (argv(1) == CAMP_TAG_DESC){
                  if( argv(token) != "" ){
                    cacheGlobalString( CAMP_DESC[itr+1], argv(token) )
                  }
                }
                if (argv(1) == CAMP_TAG_AUTHOR){
                  if( argv(token) != "" ){
                    cacheGlobalString( CAMP_AUTH[itr+1], argv(token) )
                  }
                }
                if (argv(1) == CAMP_TAG_MECHS){
                  if( argv(token) != "" ){
                    cacheGlobalString( CAMP_MECHS[itr+1], argv(token) )
                  }
                }
                if (argv(1) == CAMP_TAG_ITEMS){
                  if( argv(token) != "" ){
                    cacheGlobalString( CAMP_ITEMS[itr+1], argv(token) )
                  }
                }
              }
            }
          }
          line = fgets(flannel);
        }
        //always close a file :3
        fclose(flannel);
      }
      itr = itr + 1;
    }
  }
  search_end(searchHandle);
};
#endif

//CAMP_FILES[<id>] = campaignName
/*
  -> cvar("sv_campaign") usually
    Initialize MapList array in-VM, usually called at only specific times.
*/
void( string campaignName ) campaign_loadMapList={
  local float flannel;
  local string contents, line;
  local string filename;
  local float inObject;
  local float mapId;
  
  inObject = FALSE;
  
  mapId = 0;
  
  filename = strcat("data/campaigns/", campaignName);
  
  flannel = fopen(filename, FILE_READ);
  if( flannel != -1 ){
    contents = fgets(flannel);
    
    tokenizebyseparator(contents, "{",",","}");
    line = fgets(flannel);
  
    while( (line != "") ){
      if( substring(line,0, 2) != "//" ){
        if( line == "{" ){
          inObject = TRUE;
        }
        else if( line == "}" && inObject){
          inObject = FALSE;
        }
        else{
          if( !inObject ){
            cacheGlobalString( CAMP_MAPS[mapId], line )
            mapId = mapId + 1;
          }
        }
      }
      line = fgets(flannel);
    }
    //always close a file :3
    fclose(flannel);
  }
};

#ifndef MENUQC
/*
  map list loading duplicated because func calls are somewhat expensive.
  
  
*/
string( string campaignName, string mapName, float missionStat ) campaign_nextMap={
  local float flannel;
  local string contents, line;
  local string filename;
  local float inObject;
  local float mapId;
  
  local float itr;
  
  if( CAMP_MAPS[mapId] == "" ){
    inObject = FALSE;
    mapId = 0;
    filename = strcat("data/campaigns/", campaignName);
    flannel = fopen(filename, FILE_READ);
    
    if( flannel != -1 ){
      contents = fgets(flannel);
      tokenizebyseparator(contents, "{",",","}");
      line = fgets(flannel);
    
      while( (line != "") ){
        if( substring(line,0, 2) != "//" ){
          if( line == "{" ){
            inObject = TRUE;
          }
          else if( line == "}" && inObject){
            inObject = FALSE;
          }
          else{
            if( !inObject ){
              cacheGlobalString( CAMP_MAPS[mapId], line )
              mapId = mapId + 1;
            }
          }
        }
        line = fgets(flannel);
      }
      //always close a file :3
      fclose(flannel);
    }
    else{
      dprint("no maps found!\n"); //debug
      return "menu";
    }
  }
  
  if( mapId == 0 ){
    dprint("no maps found!\n"); //debug
    return "menu";
  }
  itr = 0;
  while( itr < mapId ){
    line = CAMP_MAPS[itr];
    tokenizebyseparator(line, ":", "|");
    if(argv(0) == mapName){
      if(missionStatus){
        return argv(1);
      }
      else{
        if( argv(2) == "none" ){
          return "menu";
        }
        else{
          return argv(2);
        }
      }
    }
    itr = itr + 1;
  }
  return "menu";  //default
};
#endif