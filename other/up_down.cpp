#include<printf.h>

int main(int argc, char** argv) {
    int inputs[1000];
    for (int i = 0; i < 1000; i++){
        inputs[i] = i;
    }
    int downsample_result[200];
    for (int i = 0; i < 200; i++){
        downsample_result[i] = inputs[i*5];
    }
    int upsample_result[800];
    for (int i = 0; i < 200; i++){
        for (int j = 0; j < 4; j++){
            upsample_result[i*4+j] = downsample_result[i];
        }
    }
    for (int i = 0; i < 800; i++){
        printf("output %d: %d\n", i, upsample_result[i]);
    }
    return 0;
}
