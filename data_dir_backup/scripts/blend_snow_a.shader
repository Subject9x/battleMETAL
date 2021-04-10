//=====================================
// Game: battleMETAL
// info: blend_snow_a.shaders
//=====================================
//
//BLENDS
//  ice_a -> snow_a
//  snow_a -> rock_a
//  snow_a -> basin_a
//  snow_a -> high_a
//  high_a -> rock_a
//
//In a practical sense, you can think of the dotproduct vector ( 0 0 0.9 ) as meaning that all vertex normal 
//vectors pointing straight up along the z-axis ( 0 0 1 ) will have a vertex alpha value of 90% opacity.

//--------------------------------------------------
//  SAND_DESERT_BASIN_A -----------------------------
//--------------------------------------------------
textures/blend/snow/desert_basin_rock_a
{
  qer_editorimage textures/desert/icon/basin_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.9 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/snow_desert_rock_a.tga
    tcMod scale 6 6
    rgbGen vertex
  }

  {
    map textures/desert/snow_desert_basin_a.tga
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

//basin_a -> desert_a
textures/blend/snow/basin_blend_snow_a
{
  qer_editorimage textures/desert/icon/basin_a_to_snow_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.5 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/snow_desert_basin_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/desert/snow_desert_a.tga
    tcMod scale 5 5
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
//  SAND_DESERT_A -----------------------------
//--------------------------------------------------
//desert_a -> rock_a =============================================
textures/blend/snow/snow_blend_rock_a
{
  qer_editorimage textures/desert/icon/snow_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.95 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/snow_desert_rock_a.tga
    tcMod scale 6 6
    rgbGen vertex
  }
  {
    map textures/desert/snow_desert_a.tga
    tcMod scale 5 5
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
//desert_a -> basin_a =============================================
textures/blend/snow/snow_blend_basin_a
{
  qer_editorimage textures/desert/icon/snow_a_to_basin_a.tga  
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.65 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/snow_desert_a.tga
    tcMod scale 5 5
    rgbGen vertex
  }

  {
    map textures/desert/snow_desert_basin_a.tga
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
//desert_a -> high_a =============================================
textures/blend/snow/snow_blend_high_a
{
  qer_editorimage textures/desert/icon/snow_a_to_high_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.65 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/snow_desert_high_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/desert/snow_desert_a.tga
    tcMod scale 5 5
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
//  SAND_DESERT_HIGH_A -----------------------------
//--------------------------------------------------
//high_a -> desert_a
textures/blend/snow/high_blend_snow_a
{
  qer_editorimage textures/desert/icon/high_a_to_snow_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.55 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/snow_desert_a.tga
    tcMod scale 5 5
    rgbGen vertex
  }
  {
    map textures/desert/snow_desert_high_a.tga
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


//high_a -> rock_a
textures/blend/snow/high_blend_rock_a
{
  qer_editorimage textures/desert/icon/high_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.9 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/snow_desert_rock_a.tga
    tcMod scale 6 6
    rgbGen vertex
  }

  {
    map textures/desert/snow_desert_high_a.tga
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