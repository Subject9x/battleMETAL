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
//  ICE_BASIN_A -----------------------------
//--------------------------------------------------
textures/blend/snow/ice_blend_rock_a
{
  qer_editorimage textures/ice/icon/ice_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.88 )
  q3map_alphaMod dotproduct2 ( 0 0 0.92 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/ice/ice_a.tga
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

textures/blend/snow/ice_blend_snow_a
{
  qer_editorimage textures/ice/icon/ice_a_to_snow_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaGen const 0.45
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/ice/ice_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
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
//  SNOW_A -----------------------------
//--------------------------------------------------
//=============================================
textures/blend/snow/snow_blend_rock_a
{
  qer_editorimage textures/ice/icon/snow_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  //q3map_alphaMod dotproduct2 ( 0 0 0.72 )
  q3map_alphaGen const 0.45
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }
  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
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
//=============================================
textures/blend/snow/snow_blend_ice_a
{
  qer_editorimage textures/ice/icon/snow_a_to_ice_a.tga  
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  
  q3map_alphaGen const 0.65
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/ice/ice_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
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
//=============================================
textures/blend/snow/snow_blend_high_a
{
  qer_editorimage textures/ice/icon/snow_a_to_high_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaGen const 0.35

  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
    rgbGen vertex
  }
  {
    map textures/ice/snow_high_a.tga
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

//--------------------------------------------------
//  SNOW_HIGH_A -----------------------------
//--------------------------------------------------
textures/blend/snow/high_blend_snow_a
{
  qer_editorimage textures/ice/icon/high_a_to_snow_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaGen const 0.6
  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
    rgbGen vertex
  }
  {
    map textures/ice/snow_high_a.tga
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

textures/blend/snow/high_blend_rock_a
{
  qer_editorimage textures/ice/icon/high_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.78 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/ice/snow_high_a.tga
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
//  SNOW_ROCK_A -----------------------------
//--------------------------------------------------

textures/blend/snow/rock_a_blend_snow_a
{
  qer_editorimage textures/ice/icon/rock_a_75%_snow_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaGen const 0.55
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
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
textures/blend/snow/rock_a_blend_high_a
{
  qer_editorimage textures/ice/icon/rock_a_75%_high_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaGen const 0.65
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
  }

  {
    map textures/ice/snow_high_a.tga
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