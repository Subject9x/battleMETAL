//=====================================
// Game: battleMETAL
// info: blend_sand.shaders
//=====================================
//
//BLENDS
//  mud_a_to_dirt_a
//  mud_a_to_rock_c
//  dirt_a_to_rock_c
//  dirt_a_to_grass_a
//
//In a practical sense, you can think of the dotproduct vector ( 0 0 0.9 ) as meaning that all vertex normal 
//vectors pointing straight up along the z-axis ( 0 0 1 ) will have a vertex alpha value of 90% opacity.

//--------------------------------------------------
//  MUD_A -----------------------------
//--------------------------------------------------
textures/blend/dirt/mud_a_to_rock_c
{
  qer_editorimage textures/dirt/icon/mud_a_to_rock_c.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.9 )
  q3map_alphaMod dotproduct ( 0 0 0.94 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/rock_c.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/dirt/mud_a.tga
    tcMod scale 3 3
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

//mud_a_to_rock_c
textures/blend/dirt/mud_a_to_dirt_a
{
  qer_editorimage textures/dirt/icon/mud_a_to_dirt_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.45 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/mud_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }
  {
    map textures/dirt/dirt_a.tga
    tcMod scale 3 3
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

//--------------------------------------------------
//  DIRT_A -----------------------------
//--------------------------------------------------
//dirt_a -> rock_c =============================================
textures/blend/dirt/dirt_a_to_rock_c
{
  qer_editorimage textures/dirt/icon/dirt_a_to_rock_c.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.88 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/rock_c.tga
    tcMod scale 3 3
    rgbGen vertex
  }
  {
    map textures/dirt/dirt_a.tga
    tcMod scale 4 4
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}
//dirt_a -> mud_a =============================================
textures/blend/dirt/dirt_a_to_mud_a
{
  qer_editorimage textures/dirt/icon/dirt_a_to_mud_a.tga  
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.4 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/dirt_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/dirt/mud_a.tga
    tcMod scale 3 3
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  } 

}
//dirt_a -> grass_a =============================================
textures/blend/dirt/dirt_a_to_grass_a
{
  qer_editorimage textures/dirt/icon/dirt_a_to_grass_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.6 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/grass_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/dirt/dirt_a.tga
    tcMod scale 3 3
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}
//--------------------------------------------------

//--------------------------------------------------
//  GRASS_A -----------------------------
//--------------------------------------------------
//grass_a -> dirt_a
textures/blend/dirt/grass_a_to_dirt_a
{
  qer_editorimage textures/dirt/icon/grass_a_to_dirt_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.55 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/dirt_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }
  {
    map textures/dirt/grass_a.tga
    tcMod scale 2 2
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}


//grass_a -> rock_c
textures/blend/dirt/grass_a_to_rock_c
{
  qer_editorimage textures/dirt/icon/grass_a_to_rock_c.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.78 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/rock_c.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/dirt/grass_a.tga
    tcMod scale 2 2
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

//--------------------------------------------------
//  ROCK_C -----------------------------
//--------------------------------------------------
//rock_c -> dirt_a  =============================================
textures/blend/dirt/rock_c_to_dirt_a
{
  qer_editorimage textures/dirt/icon/rock_c_to_dirt_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.88 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/dirt_a.tga
    tcMod scale 4 4
    rgbGen vertex
  }
  {
    map textures/dirt/rock_c.tga
    tcMod scale 3 3
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}
textures/blend/dirt/rock_c_to_mud_a
{
  qer_editorimage textures/dirt/icon/rock_c_to_mud_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.9 )
  q3map_alphaMod dotproduct ( 0 0 0.94 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/dirt/mud_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/dirt/rock_c.tga
    tcMod scale 3 3
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}