textures/desert/sand_desert_high_a
{
	qer_editorimage textures/desert/sand_desert_high_a.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/desert/sand_desert_high_a.tga
    tcMod scale 2 2
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
  
}
textures/desert/sand_desert_a
{
  qer_editorimage textures/desert/sand_desert_a.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 4 4
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

textures/desert/sand_desert_basin_a
{
  qer_editorimage textures/desert/sand_desert_basin_a.tga
  q3map_terrain
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  {
    map textures/desert/sand_desert_basin_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

textures/desert/sand_desert_rock_a
{
	qer_editorimage textures/desert/sand_desert_rock_a.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )

	{
		map textures/desert/sand_desert_rock_a.tga
    tcMod scale 4 4
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/desert/mud_a
{
	qer_editorimage textures/desert/mud_a.tga

	{
		map textures/desert/mud_a.tga
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}


textures/desert/sand_desert_rock_b
{
	qer_editorimage textures/desert/sand_desert_rock_b.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )

	{
		map textures/desert/sand_desert_rock_b.tga
    tcMod scale 2 2
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/desert/sand_desert_high_b
{
	qer_editorimage textures/desert/sand_desert_high_b.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/desert/sand_desert_high_b.tga
    tcMod scale 1 1
    rgbGen vertex
	}
	{
    map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
  
}

textures/desert/sand_basin_b
{
  qer_editorimage textures/desert/sand_basin_b.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  {
    map textures/desert/sand_basin_b.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

textures/desert/sand_desert_b
{
  qer_editorimage textures/desert/sand_desert_b.tga
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}