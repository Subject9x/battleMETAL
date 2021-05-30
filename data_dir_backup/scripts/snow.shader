textures/ice/snow_high_a
{
	qer_editorimage textures/ice/snow_high_a.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/ice/snow_high_a.tga
    tcMod scale 2 2
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
  
}
textures/ice/snow_a
{
  qer_editorimage textures/ice/snow_a.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

textures/ice/ice_a
{
  qer_editorimage textures/ice/ice_a.tga
  q3map_terrain
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  {
    map textures/ice/ice_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

textures/ice/rock_a
{
	qer_editorimage textures/ice/rock_a.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )

	{
		map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}
//flat surfaces=-==========================================
textures/ice/snow_high_a_brush
{
	qer_editorimage textures/ice/snow_high_a.tga
  q3map_shadeangle 179
	{
		map textures/ice/snow_high_a.tga
    tcMod scale 2 2
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
  
}
textures/ice/snow_a_brush
{
  qer_editorimage textures/ice/snow_a.tga
  q3map_shadeangle 179
  {
    map textures/ice/snow_a.tga
    tcMod scale 1 1
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

textures/ice/ice_a_brush
{
  qer_editorimage textures/ice/ice_a.tga
  q3map_shadeangle 179
  {
    map textures/ice/ice_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

textures/ice/rock_a_brush
{
	qer_editorimage textures/ice/rock_a.tga
  q3map_shadeangle 179

	{
		map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}



//==============================================

textures/ice/snow_b
{
	qer_editorimage textures/ice/snow_b.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/ice/snow_b.tga
		tcMod scale 1 1
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
	{
		map $lightmap
		rgbGen identity
	}
}

textures/ice/ice_b
{
	qer_editorimage textures/ice/ice_b.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/ice/ice_b.tga
		tcMod scale 1 1
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
	{
		map $lightmap
		rgbGen identity
	}
}



textures/ice/rock_b
{
	qer_editorimage textures/ice/ice_rock_b.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/ice/rock_b.tga
		tcMod scale 6 6
		rgbGen identity
	}

	{
		map $lightmap
		rgbGen identity
	}
}

//flat surfaces=-==========================================
textures/ice/rock_a_brush
{

	qer_editorimage textures/ice/rock_a.tga
  q3map_shadeangle 179
	{
		map textures/ice/rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}


textures/ice/rock_b_brush
{
	qer_editorimage textures/ice/ice_rock_b.tga
  q3map_shadeangle 179
	{
		map textures/ice/rock_b.tga
		tcMod scale 6 6
		rgbGen vertex
	}

	{
		map $lightmap
		rgbGen identity
	}
}

//==============================================