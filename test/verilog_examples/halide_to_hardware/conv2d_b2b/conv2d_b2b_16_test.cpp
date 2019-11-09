#include "hls_target.h"

#include <iostream>

using namespace std;

#define IMG_SIZE 4

int main() {


  hls::stream<AxiPackedStencil<uint8_t, 1, 1> > hw_input;
  hls::stream<AxiPackedStencil<uint8_t, 1, 1> > hw_output;

  for (int i = 0; i < IMG_SIZE; i++) {
    for (int j = 0; j < IMG_SIZE; j++) {
      Stencil<uint8_t, 1, 1> s;
      s(0, 0) = i*IMG_SIZE + j + 1;
      AxiPackedStencil<uint8_t, 1, 1> p = s;
      hw_input.write(s);
    }
  }

  hls_target(hw_input, hw_output);

  for (int i = 0; i < IMG_SIZE - 3; i++) {
    for (int j = 0; j < IMG_SIZE - 3; j++) {
      AxiPackedStencil<uint8_t, 1, 1> val = hw_output.read();
      Stencil<uint8_t, 1, 1> res = val;
      cout << "Val 0 = " << (int) res(0, 0) << endl;
    }
  }
}
