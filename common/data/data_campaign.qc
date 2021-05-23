/*
battleMETAL
Author: Peter Roohr
Date: 08/05/2020
Overview: 
  Simple Campaign file that both the Menu and Client reference.
  
  Campaign files simply keep track of sets of levels by referencing the 'start' map for a campaign.
  The campaign name is also saved to the player save file and shown when choosing a save file.
*/

void() campaign_loadfiles={
  local float itr;
  local float flannel, argc, line_tag, token;
  local string contents, line;
  local float searchHandle;
  local float files;
  local string filename;
  //quake/dp functionality is really wierd, lots of reliance
  //on inaccessible / hidden arrays for things like search results and server host lists...
  searchHandle = search_begin("data/campaigns/*.dat", TRUE, FALSE);
  
  files = search_getsize(searchHandle);
  itr = 0;
  token = 4; //general pointer inside tokenized msn file value
  
  if( files > 0 ){
    while( itr < files ){
      filename = search_getfilename(searchHandle, itr);
      //cons_logAString("filename", filename);  //debug
      
      if( filename && filename != "" ){
        flannel = fopen(filename, FILE_READ);
        contents = fgets(flannel);
        
        argc = tokenizebyseparator(contents, "{",",","}");
        line = fgets(flannel);
      
        while( (line != "") ){
          if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
            line_tag = tokenizebyseparator(line, "'", "'", ": ","'","'");
            if (argv(1) == CAMP_TAG_NAME){
              if( argv(token) != "" ){
                CAMP_NAME[itr+1] = strzone(substring(argv(token),0, 32));
              }
            }
            if (argv(1) == CAMP_TAG_START){
              if( argv(token) != "" ){
                CAMP_START[itr+1] = strzone(argv(token));
              }
            }
            if (argv(1) == CAMP_TAG_INFO){
              if( argv(token) != "" ){
                CAMP_INFO[itr+1] = strzone(argv(token));
              }
            }
            if (argv(1) == CAMP_TAG_DESC){
              if( argv(token) != "" ){
                CAMP_DESC[itr+1] = strzone(argv(token));
              }
            }
            if (argv(1) == CAMP_TAG_AUTHOR){
              if( argv(token) != "" ){
                CAMP_AUTH[itr+1] = strzone(argv(token));
              }
            }
            if (argv(1) == CAMP_TAG_MECHS){
              if( argv(token) != "" ){
                CAMP_MECHS[itr+1] = strzone(argv(token));
              }
            }
            if (argv(1) == CAMP_TAG_ITEMS){
              if( argv(token) != "" ){
                CAMP_ITEMS[itr+1] = strzone(argv(token));
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
