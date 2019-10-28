#include<printf.h>
#include<cstdint>
#include<array>
#define ROW_SIZE 4
#define KERNEL_SIZE 3
#define INT_TO_IGNORE 253


// this makes one window of the stencil
std::array< std::array< int, KERNEL_SIZE >, KERNEL_SIZE >
stencil(std::array< std::array< int, ROW_SIZE > , ROW_SIZE > inputs, int row, int col) {
  std::array< std::array< int, KERNEL_SIZE > , KERNEL_SIZE > result;
  for (int k = 2; k >= 0; k--) {
    // each stencil's window puts the new pixel at the bottom, right corner index 2,2
    int k_index = 2-k;
    if (row - k >= 0) {
      result[k_index][0] = (col >= 2) ? inputs[row-k][col-2] : INT_TO_IGNORE;
      result[k_index][1] = (col >= 1) && (col < ROW_SIZE + 1) ?
        inputs[row-k][col-1] : INT_TO_IGNORE;
      result[k_index][2] = (col < ROW_SIZE) ?
        inputs[row-k][col] : INT_TO_IGNORE;
    }
    else {
      result[k_index][0] = INT_TO_IGNORE;
      result[k_index][1] = INT_TO_IGNORE;
      result[k_index][2] = INT_TO_IGNORE;
    }
  }
  return result;
}

// this convolves each window of the stencil with the blur kernel
int conv(std::array< std::array< int, KERNEL_SIZE >, KERNEL_SIZE > inputs) {
  int result = 0;
  int kernel[KERNEL_SIZE][KERNEL_SIZE] = {{1,2,1},{2,4,2},{1,2,1}};
  for (int i = 0; i < KERNEL_SIZE; i++) {
    for (int j = 0; j < KERNEL_SIZE; j++) {
      if (inputs[i][j] == INT_TO_IGNORE) {
        return INT_TO_IGNORE;
      }
      result += kernel[i][j] * inputs[i][j];
    }
  }
  return (result % 255) / 16;
}

int thres_const = 15;
int sharpen_one_pixel(int blur_px, int in_px) {
  int h = abs(in_px - blur_px) > 15 ? in_px - blur_px : 0;
  return blur_px == INT_TO_IGNORE ? blur_px : in_px + (h / 5);
}

int main(int argc, char** argv) {
  std::array< std::array<int, ROW_SIZE > , ROW_SIZE > inputs; 
  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      inputs[i][j] = (i*ROW_SIZE + j + 1) * 5;
    }
  }
  #ifdef DEBUG
  for (int i = 0; i < ROW_SIZE; i++){
    printf("[");
    for (int j = 0; j < ROW_SIZE; j++){
      printf("%d, ", inputs[i][j]);
    }
    printf("]\n");
  }
  printf("done initializing\n");
  #endif
  
  std::array< std::array<
    std::array< std::array< int, KERNEL_SIZE > , KERNEL_SIZE >
      , ROW_SIZE > , ROW_SIZE > stencil_result;
  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      #ifdef DEBUG
      printf("starting %d,%d stencil\n", i, j);
      #endif
      stencil_result[i][j] = stencil(inputs, i, j);
      #ifdef DEBUG
      for (int k = 0; k < KERNEL_SIZE; k++){
        printf("[");
        for (int l = 0; l < KERNEL_SIZE; l++){
          printf("%d, ", stencil_result[i][j][k][l]);
        }
        printf("]\n");
      }
      printf("done %d,%d stencil\n", i, j);
      #endif
    }
  }
  #ifdef DEBUG
  printf("done generating stencil windows\n");
  #endif

  std::array< std::array< int, ROW_SIZE >, ROW_SIZE > conv_result;
  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      conv_result[i][j] = conv(stencil_result[i][j]);
    }
  }
  #ifdef DEBUG
  printf("done convolving blur\n");
  #endif


  std::array< std::array< int, ROW_SIZE >, ROW_SIZE > sharpen_result;
  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      sharpen_result[i][j] = sharpen_one_pixel(conv_result[i][j],
                                               inputs[i][j]);
    }
  }
  #ifdef DEBUG
  printf("done sharpening\n");
  #endif

  for (int i = 0; i < ROW_SIZE; i++){
    printf("[");
    for (int j = 0; j < ROW_SIZE; j++){
      printf("%d, ", sharpen_result[i][j]);
    }
    printf("]\n");
  }
  return 0;
}
