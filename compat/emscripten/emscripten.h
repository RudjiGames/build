#ifndef EMSCRIPTEN_COMPATIBILITY_H
#define EMSCRIPTEN_COMPATIBILITY_H

inline static uint64_t emscripten_get_now()
{
	return 0;
}

#define EMSCRIPTEN_KEEPALIVE

#endif // EMSCRIPTEN_COMPATIBILITY_H
