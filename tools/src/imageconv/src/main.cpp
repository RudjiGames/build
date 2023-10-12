//--------------------------------------------------------------------------//
/// Copyright 2023 Milos Tosic. All Rights Reserved.                       ///
/// License: http://www.opensource.org/licenses/BSD-2-Clause               ///
//--------------------------------------------------------------------------//

// NB:	VERY FRAGILE - assumes a lot about input
//		No argument verification, destination file ext must be lower case,
//		(almost) no error checks, etc.

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_RESIZE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION

#include <stb/stb_image.h>
#include <stb/stb_image_resize2.h>
#include <stb/stb_image_write.h>

#include <stdlib.h>

int main(int argc, char* argv[])
{
	if (argc != 5)
		return 1;

	const char* src	= argv[1];
	const char* dst	= argv[2];
	int width		= atoi(argv[3]);
	int height		= atoi(argv[4]);

	int srcW = 0;
	int srcH = 0;
	int srcC = 0;
	unsigned char* srcData = stbi_load(src, &srcW, &srcH, &srcC, 4);

	unsigned char* dstData = new unsigned char[width*height*4];

	stbir_resize_uint8_linear( srcData, srcW, srcH, srcW*4, dstData, width, height, width*4, STBIR_RGBA);

	if (strstr(dst, ".png"))
		stbi_write_png(dst, width, height, 4, dstData, width*4);

	if (strstr(dst, ".bmp"))
		stbi_write_bmp(dst, width, height, 4, dstData);

	if (strstr(dst, ".tga"))
		stbi_write_tga(dst, width, height, 4, dstData);


	delete[] dstData;
	stbi_image_free(srcData);

	return 0;
}
