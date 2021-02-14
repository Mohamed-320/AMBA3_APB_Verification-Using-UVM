
/****************Sequencer is written by extending uvm_sequencer, there is no extra logic required to be added in the sequencer****************/
`ifndef APB_SEQUENCER
`define APB_SEQUENCER

import uvm_pkg::*;        // Standard UVM pkg
`include "uvm_macros.svh" //Standard UVM macros
`include"apb_seq_item.sv"
`include"apb_sequence.sv"

class apb_sequencer extends uvm_sequencer#(apb_seq_item);
`uvm_sequencer_utils(apb_sequencer)

     function new(string name="apb_sequencer",uvm_component parent);
         super.new(name,parent);
     endfunction
endclass
`endif