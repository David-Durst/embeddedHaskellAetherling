#include<printf.h>

int main(int argc, char** argv) {
  int inputs[1000];
  for (int i = 0; i < 1000; i++){
    inputs[i] = i;
  }
  int map_result[1000];
  for (int i = 0; i < 1000; i++){
    map_result[i] = inputs[i]*5;
  }
  for (int i = 0; i < 1000; i++){
    printf("output %d: %d\n", i, map_result[i]);
  }
  return 0;
}
