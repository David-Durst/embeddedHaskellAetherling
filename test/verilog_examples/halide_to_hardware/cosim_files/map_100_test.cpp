#include "hls_target.h"

#include <iostream>

using namespace std;

#define IMG_SIZE 200

int main() {
  hls::stream<AxiPackedStencil<uint8_t, 2, 1> > hw_input;
  hls::stream<AxiPackedStencil<uint8_t, 2, 1> > hw_output;

  for (int i = 0; i < IMG_SIZE; i+=2) {
    Stencil<uint8_t, 2, 1> s;
    s(0, 0) = i;
    s(1, 0) = i + 1;
    AxiPackedStencil<uint8_t, 2, 1> p = s;
    hw_input.write(s);
  }

  hls_target(hw_input, hw_output);

  for (int i = 0; i < IMG_SIZE; i+=2) {
    AxiPackedStencil<uint8_t, 2, 1> val = hw_output.read();
    Stencil<uint8_t, 2, 1> res = val;
    cout << "Val 0 = " << (int) res(0, 0) << endl;
    cout << "Val 0 = " << (int) res(1, 0) << endl;
  }
}
