#ifndef FUNCTION_UTIL
#define FUNCTION_UTIL

float pulse(float a, float b, float x) {
    return step(a, x) - step(b, x);
}

float smoothpulse(float a1, float a2, float b1, float b2, float x) {
    return smoothstep(a1, a2, x) - smoothstep(b1, b2, x);
}

#endif