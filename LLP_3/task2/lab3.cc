#include <stdio.h>

extern void access8(int a, float b, int c, float d);

int main() {
    int a1 = 45;
    float a2 = 1300.0f;
    int a3 = 2000;
    float a4 = 45.0f;

    access8(a1, a2, a3, a4);

    return 0;
}

void access8(int a, float b, int c, float d) {
    if ((a * b - d * c) < 0.0f) {
        if (((int)((b + c - a) - d)) == 3210) {
            printf("Access granted.\n");
        }
        else {
            printf("Access denied.\n");
        }
    }
    else {
        printf("Access denied.\n");
    }
}