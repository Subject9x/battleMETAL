//textures/skies/storm1
//{
//	qer_editorimage textures/skies/storm1.jpg
//	surfaceparm sky
//	surfaceparm noimpact
//	surfaceparm nolightmap
//	q3map_globaltexture
//	skyparms textures/skies/env/storm1/storm1 - -
//}
//q3map_sunExt red green blue intensity degrees elevation deviance samples

//-------------------------------------
//  STORM 1 and Cloud dome
//--------------------------------------
textures/skies/storm1
{
	qer_editorimage textures/skies/storm1.jpg
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	q3map_globaltexture
	q3map_sunExt 0.65 0.25 0.15 125 135 55 4 16
	q3map_skylight 50 2
	skyparms textures/skies/env/storm1/storm1 - -
}

textures/skies/cloud_storm1
{
  surfaceparm nolightmap
	surfaceparm noimpact
  surfaceparm nonsolid
  surfaceparm trans
  dpnoshadow
  {
    map textures/skies/cloud_storm1.tga
    tcMod scale 4 6
    tcMod scroll 0 0.005
    blendFunc blend
  }
}

//-------------------------------------
//  STORM 2
//--------------------------------------
textures/skies/storm2
{
	qer_editorimage textures/skies/storm2.jpg
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	q3map_globaltexture
	q3map_sunExt 0.9 0.75 0.33 75 135 65 2 16
	q3map_skylight 100 3
	skyparms textures/skies/env/storm2/storm2 - -
}
textures/skies/cloud_storm2
{
  surfaceparm nolightmap
	surfaceparm noimpact
  surfaceparm nonsolid
  surfaceparm trans
  dpnoshadow
  {
    map textures/skies/cloud_storm2.tga
    tcMod scale 4 4
    tcMod scroll -0.01 -0.01
    blendFunc blend
  }
}

//-------------------------------------
//  STORM 3
//--------------------------------------
textures/skies/storm3
{
	qer_editorimage textures/skies/storm3.jpg
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	q3map_globaltexture
	q3map_sunExt 1.0 0.33 0.9 175 135 60 4 32
	q3map_skylight 15 2
	skyparms textures/skies/env/storm3/storm3 - -
}
textures/skies/cloud_storm3
{
  surfaceparm nolightmap
	surfaceparm noimpact
  surfaceparm nonsolid
  surfaceparm trans
  dpnoshadow
  {
    map textures/skies/cloud_storm3.tga
    tcMod scale 6 3
    tcMod scroll 0.003 -0.001
    blendFunc blend
  }
}
//-------------------------------------
//  FROST 1
//--------------------------------------
textures/skies/frost1
{
	qer_editorimage textures/skies/frost1.jpg
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	q3map_globaltexture
	q3map_sunExt 0.33 0.8 0.9 67 135 67 2 16
	q3map_skylight 10 4
	skyparms textures/skies/env/frost1/frost1 - -
}
textures/skies/cloud_frost1
{
  surfaceparm nolightmap
	surfaceparm noimpact
  surfaceparm nonsolid
  surfaceparm trans
  dpnoshadow
  {
    map textures/skies/cloud_frost1.tga
    tcMod scale 2 1
    tcMod scroll -0.002 0.002
    blendFunc blend
  }
}
//-------------------------------------
//  FROST 2
//--------------------------------------
textures/skies/frost2
{
	qer_editorimage textures/skies/frost2.jpg
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	q3map_globaltexture
	q3map_sunExt 0.1 0.4 0.67 25 135 75 3 16
	q3map_skylight 50 3
	skyparms textures/skies/env/frost2/frost2 - -
}

textures/skies/cloud_frost2
{
  surfaceparm nolightmap
	surfaceparm noimpact
  surfaceparm nonsolid
  surfaceparm trans
  dpnoshadow
  {
    map textures/skies/cloud_frost2.tga
    tcMod scale 2 1
    tcMod scroll -0.01 -0.0075
    blendFunc blend
  }
}
//-------------------------------------
//  ARK 1
//--------------------------------------
textures/skies/ark1
{
	qer_editorimage textures/skies/ark1.jpg
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	q3map_globaltexture
	q3map_sunExt 0.65 0.85 0.65 512 135 50 3 8
	q3map_skylight 200 2
	skyparms textures/skies/env/ark1/ark1 - -
}
//-------------------------------------
//  ARK 2
//--------------------------------------
textures/skies/ark2
{
	qer_editorimage textures/skies/ark2.jpg
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	q3map_globaltexture
	q3map_sunExt 0.55 0.65 0.45 512 150 80 3 8
	q3map_skylight 100 2
	skyparms textures/skies/env/ark2/ark2 - -
}