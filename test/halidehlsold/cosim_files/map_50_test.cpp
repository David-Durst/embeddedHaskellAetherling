#include "hls_target.h"

#include <iostream>

using namespace std;

#define IMG_SIZE 200
#define LEN 4

int main() {
  hls::stream<AxiPackedStencil<uint8_t, LEN, 1> > hw_input;
  hls::stream<AxiPackedStencil<uint8_t, LEN, 1> > hw_output;

  for (int i = 0; i < IMG_SIZE; i+=LEN) {
    Stencil<uint8_t, LEN, 1> s;
    for (int k = 0; k < LEN; k++) {
      s(k, 0) = i + k;
    }
    AxiPackedStencil<uint8_t, LEN, 1> p = s;
    hw_input.write(s);
  }

  hls_target(hw_input, hw_output);

  for (int i = 0; i < IMG_SIZE; i+=LEN) {
    AxiPackedStencil<uint8_t, LEN, 1> val = hw_output.read();
    Stencil<uint8_t, LEN, 1> res = val;
    for (int k = 0; k < LEN; k++) {
      cout << "Val 0 = " << (int) res(k, 0) << endl;
    }
  }
}
