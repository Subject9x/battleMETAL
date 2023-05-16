textures/dirt/dirt_a
{
	qer_editorimage textures/dirt/dirt_a.tga
	q3map_baseShader textures/blend/terrain_base
	q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/dirt/dirt_a.tga
		tcMod scale 2 2
		rgbGen vertex
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}
textures/dirt/grass_a
{
	qer_editorimage textures/dirt/gass_a.tga
	q3map_baseShader textures/blend/terrain_base
	q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/dirt/grass_a.tga
		tcMod scale 2 2
		rgbGen vertex
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}
textures/dirt/mud_a
{
	qer_editorimage textures/dirt/mud_a.tga
	q3map_baseShader textures/blend/terrain_base
	q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/dirt/mud_a.tga
		tcMod scale 2 2
		rgbGen vertex
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}
textures/dirt/rock_c
{
	qer_editorimage textures/dirt/rock_c.tga
	q3map_baseShader textures/blend/terrain_base
	q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
	{
		map textures/dirt/rock_c.tga
		tcMod scale 2 2
		rgbGen vertex
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}
textures/dirt/rock_c_brush
{
	qer_editorimage textures/dirt/rock_c.tga
	q3map_shadeangle 179
	{
		map textures/dirt/rock_c.tga
		tcMod scale 2 2
		rgbGen vertex
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}