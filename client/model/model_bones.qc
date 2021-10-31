/*
battleMETAL
Author: Peter Roohr
Date: 10/30/2021
Overview: 
  An attempt to incorporate either MD3 tag nodes, or IQM bones to models?
  
  csprogsdef reference
  ---------------------
    float(entity ent, string tagname) gettagindex = #451;
    vector(entity ent, float tagindex) gettaginfo = #452;

    float gettaginfo_parent;
    string gettaginfo_name;
    vector gettaginfo_offset;
    vector gettaginfo_forward;
    vector gettaginfo_right;
    vector gettaginfo_up;
  
*/

//for debugging
void(entity tagEntity, string tagNameVal) md3_tags_info={
  local float f;
  local vector v;
  f = gettagindex(tagEntity, tagNameVal);
  v = gettaginfo(tagEntity,  f);
  
  cons_logAString("Tag name", gettaginfo_name);
  cons_logAVector("         origin?",  v);
  cons_logAFloat("          index", f );  //debug
  cons_logAVector( "        gettaginfo_offset", gettaginfo_offset );  //debug
  cons_logAVector( "        gettaginfo_forward", gettaginfo_forward );  //debug
  cons_logAVector( "        gettaginfo_right", gettaginfo_right );  //debug
  cons_logAVector( "        gettaginfo_up", gettaginfo_up );  //debug
  cons_logAFloat("          gettaginfo_parent", gettaginfo_parent );  //debug
};

void(entity skel, string boneName) iqm_bone_info={

};


//construct a tag 'skeleton'
void(entity skel) md3_tags_build={
  local entity hardpoint;
  
  skel.tagParent = "null";
  skel.tagName = tag_origin;
  
  if( skel.torsoCenter ){
    skel.torsoCenter.tagName = tag_torso;
    skel.torsoCenter.tagParent = tag_origin;
    skel.torsoCenter.tagParentEnt = skel;
  }
  
  if( skel.torsoLeft ){
    skel.torsoLeft.tagName = tag_torLeft;
    skel.torsoLeft.tagParent = tag_torso;
    skel.torsoLeft.tagParentEnt = skel.torsoCenter;
  }

  if( skel.torsoRight ){
    skel.torsoRight.tagName = tag_torRight;
    skel.torsoRight.tagParent = tag_torso;
    skel.torsoRight.tagParentEnt = skel.torsoCenter;
  }
  
  if( skel.armRight ){
    skel.armRight.tagName = tag_armRight;
    skel.armRight.tagParent = tag_torRight;
    skel.armRight.tagParentEnt = skel;
  }
  if( skel.armLeft ){
    skel.armLeft.tagName = tag_armLeft;
    skel.armLeft.tagParent = tag_torLeft;
    skel.armLeft.tagParentEnt = skel;
  }
  
  hardpoint = skel.w_slot;
  while( hardpoint ){
    
    md3_tags_build_weapon(skel, hardpoint);
    
    hardpoint = hardpoint.w_slot;
  }
  
  
};

//find weapon tag and bind to hardpoint entity;
void(entity skel, entity hpoint) md3_tags_build_weapon={
  local float tagIndex;
  local string tag;
  
  switch(hpoint.w_group){
    case WEAPON1:
      tag = tag_weapon1;
      break;
    case WEAPON2:
      tag = tag_weapon2;
      break;
    case WEAPON3:
      tag = tag_weapon3;
      break;
    case WEAPON4:
      tag = tag_weapon4;
      break;
    case WEAPON5:
      tag = tag_weapon5;
      break;
    case WEAPON6:
      tag = tag_weapon6;
      break;
    case WEAPON7:
      tag = tag_weapon7;
      break;
    case WEAPON8:
      tag = tag_weapon8;
      break;
    case WEAPON9:
      tag = tag_weapon9;
      break;
  }
  hpoint.tagName = tag;
  
  if( self.armRight ){
    if( gettagindex(self.armRight, tag) != 0 ){
      md3_tags_info(self.armRight, tag);  //debug
      hpoint.tagParent = tag_armRight;
      return;
    }
  }
  
  if( self.armLeft ){
    if( gettagindex(self.armLeft, tag) != 0 ){
      md3_tags_info(self.armLeft, tag);  //debug
      hpoint.tagParent = tag_armLeft;
      return;
    }
  }
  
  if( self.torsoLeft ){
    if( gettagindex(self.torsoLeft, tag) != 0 ){
      md3_tags_info(self.torsoLeft, tag);  //debug
      hpoint.tagParent = tag_torLeft;
      return;
    }
  }

  if( self.torsoRight ){
    if( gettagindex(self.torsoRight, tag) != 0 ){
      md3_tags_info(self.torsoRight, tag);  //debug
      hpoint.tagParent = tag_torRight;
      return;
    }
  }
  //fall-back / default center torso, good luck!
  hpoint.tagParent = tag_torso;
  md3_tags_info(self, tag);  //debug
  
};


/*
  root ->
      angles
      origin
      
      -> torso
        angles
        offset
        
          -> torleft
            angles
            offset

*/
void(entity part, float pitchFlag) md3_tags_predraw={
  local float tagIndex;
  local vector tagInfo;
  local vector tagOfs;
  local vector org;
  local vector ang;
  
  tagIndex = gettagindex(part.tagParentEnt, part.tagName);
  tagInfo = gettaginfo(part.tagParentEnt, tagIndex);
  
  tagOfs = gettaginfo_offset;
  
  ang = part.tagParentEnt.angles;
  ang_x = 0;
  
  makevectors(ang);
  
  /*
  ang = parent.angles;
  ang_x = 0;
  makevectors(ang);
  
  org = self.origin + (gettaginfo_up * tagOfs_z) + (v_right * tagOfs_x) + (v_forward * tagOfs_y);
  part.origin = org;
  
  part.angles = ang;
  if(pitchFlag){
    part.angles_x = 0 - parent.angles_x;
  }*/
  /*
  cons_logAString("Tag name", gettaginfo_name);
  cons_logAVector("         origin?",  tagInfo);
  cons_logAVector("         org",  org);
  */
};


void(entity part, float pitchFlag) md3_tags_predraw_tag={
};



