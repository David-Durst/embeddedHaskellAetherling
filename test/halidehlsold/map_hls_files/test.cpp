#include "hls_target.h"

#include <iostream>

using namespace std;

int main() {

  //int in[1];
  //in[0] = 10;
  //int out[1];
  //hls_target(in, out);

  //assert(out[0] == in[0]);

  hls::stream<int> hw_input;
  hls::stream<int> hw_output;

  hw_input.write(10);


  hls_target(hw_input, hw_output);

  assert(hw_output.read() == 10);


  //hls::stream<AxiPackedStencil<uint8_t, 1, 1> > hw_input;
  //hls::stream<AxiPackedStencil<uint8_t, 1, 1> > hw_output;


  //for (int i = 0; i < 200; i++) {
    //Stencil<uint8_t, 1, 1> s;
    //s(0, 0) = i;
    ////for (int k = 0; k < 8; k++) {
      ////s(k, 0) = 10;
    ////}
    //AxiPackedStencil<uint8_t, 1, 1> p = s;
    //if (i < 199) {
      //p.last = 0;
    //} else {
      //p.last = 1;
    //}
    //hw_input.write(s);
  //}

  //hls_target(hw_input, hw_output);

  //for (int i = 0; i < 200; i++) {
    //AxiPackedStencil<uint8_t, 1, 1> val = hw_output.read();
    //Stencil<uint8_t, 1, 1> res = val;
    ////cout << "Val 0 = " << (int) res(0, 0) << endl;
  //}
}
