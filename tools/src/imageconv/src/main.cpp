//--------------------------------------------------------------------------//
/// Copyright (c) 2018 Milos Tosic. All Rights Reserved.                   ///
/// License: http://www.opensource.org/licenses/BSD-2-Clause               ///
//--------------------------------------------------------------------------//

// NB:	VERY FRAGILE - assumes a lot about input
//		No argument verification, destination file ext must be lower case,
//		(almost) no error checks, etc.

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_RESIZE_IMPLEMENTATION
#define STBIR_DEFAULT_FILTER_DOWNSAMPLE STBIR_FILTER_BOX

#include "fpng.h"
#include "stb_image.h"
#include "stb_image_resize.h"

int main(int argc, char* argv[])
{
	if (argc != 5)
		return 1;

	const char* src	= argv[1];
	const char* dst	= argv[2];
	int width		= atoi(argv[3]);
	int height		= atoi(argv[4]);

	std::vector<uint8_t> pixels;
	uint32_t srcW = 0, srcH = 0;
	uint32_t channels;
	uint32_t desired_channels = 4;
	fpng::fpng_decode_file(src, pixels, srcW, srcH, channels, desired_channels);

	unsigned char* dstData = new unsigned char[width*height*4];

	stbir_resize_uint8( pixels.data(),	srcW, srcH, srcW*4, 
						dstData,	width, height, width*4, 4);

	fpng::fpng_encode_image_to_file(dst, dstData, width, height, 4);
	delete[] dstData;

	return 0;
}
