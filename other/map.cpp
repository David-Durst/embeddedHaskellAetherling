#include<printf.h>

int main(int argc, char** argv) {
  int inputs[200];
  for (int i = 0; i < 200; i++){
    inputs[i] = i;
  }
  int map_result[200];
  for (int i = 0; i < 200; i++){
    map_result[i] = inputs[i]+5;
  }
  for (int i = 0; i < 200; i++){
    printf("output %d: %d\n", i, map_result[i]);
  }
  return 0;
}
