//========================================================================== //
// Copyright (c) 2016, Stephen Henry
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//========================================================================== //

module dpsram #(parameter int W = 32, parameter int N = 128)
(
    input                               clk1
  , input                               csn1
  , input                               wen1
  , input                               oen1
  , input         [$clog2(N)-1:0]       a1
  , input         [W-1:0]               di1
  //
  , output logic  [W-1:0]               dout1
  //
  , input                               clk2
  , input                               csn2
  , input                               wen2
  , input                               oen2
  , input         [$clog2(N)-1:0]       a2
  , input         [W-1:0]               di2
  //
  , output logic  [W-1:0]               dout2
);

  typedef logic [W-1:0]       w_t;
  typedef w_t [N-1:0]         mem_t;

  /* verilator lint_off MULTIDRIVEN */
  mem_t                       mem_r;
  /* verilator lint_on MULTIDRIVEN */

  logic                       do_write1;
  logic                       do_read1;

  logic                       do_write2;
  logic                       do_read2;

  always_comb do_write1  = (~csn1) & (~wen1);
  always_comb do_read1   = (~csn1) & (~oen1) & wen1;

  always_comb do_write2  = (~csn2) & (~wen2);
  always_comb do_read2   = (~csn2) & (~oen2) & wen2;

  always_ff @(posedge clk1)

    if (do_write1)
      mem_r [a1] <= di1;

  always_ff @(posedge clk2)
    if (do_write2)
      mem_r [a2] <= di2;

  always_ff @(posedge clk1)
    dout1 <= do_read1 ? mem_r [a1] : 'x;

  always_ff @(posedge clk2)
    dout2 <= do_read2 ? mem_r [a2] : 'x;

endmodule // dpsram