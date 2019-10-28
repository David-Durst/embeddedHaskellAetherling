#include<printf.h>
#include<vector>
#define ROW_SIZE 4
#define KERNEL_SIZE 3
#define INT_TO_IGNORE -23451


// this makes one window of the stencil
std::vector< std::vector< int > > stencil(std::vector< std::vector< int > > inputs,
                                          int row, int col) {
  std::vector< std::vector< int > >
  for (int k = 2; k >= 0; k++) {
    
  }
  
}

// this convolves each window of the stencil with the blur kernel
int conv(std::vector< std::vector< int > > inputs) {
  int result = 0;
  int kernel[ROW_SIZE][ROW_SIZE] = {{1,2,1},{2,4,2},{1,2,1}};
  for (int i = 0; i < KERNEL_SIZE; i++) {
    for (int j = 0; j < KERNEL_SIZE; j++) {
      result += kernel[i][j] * inputs[i][j];
    }
  }
  return result;
}


int main(int argc, char** argv) {
  std::vector< std::vector<int> > inputs; 
  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      inputs[i][j] = i*ROW_SIZE + j + 1;
    }
  }
  std::vector< std::vector< std::vector< std::vector< int > > > > stencil_result;
  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      stencil_result[i][j] = stencil(inputs, i, j);
    }
  }
  
  std::vector< std::vector< int > > conv_result;
  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      conv_result[i][j] = conv(stencil_result[i][j]);
    }
  }

  for (int i = 0; i < ROW_SIZE; i++){
    for (int j = 0; j < ROW_SIZE; j++){
      printf("conv_result (%d, %d): %d\n", i, j, conv_result[i][j]);
    }
  }
  return 0;
}
