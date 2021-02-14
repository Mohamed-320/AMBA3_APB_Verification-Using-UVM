/**************************************************************************************************
// Sequence generates the stimulus and sends to driver via sequencer
// An agent can have any number of sequences
**************************************************************************************************/
`ifndef APB_SEQUENCE
`define APB_SEQUENCE

import uvm_pkg::*;        // Standard UVM pkg
`include "uvm_macros.svh" //Standard UVM macros
`include "apb_seq_item.sv" 

class apb_sequence extends uvm_sequence#(apb_seq_item);

`uvm_object_utils(apb_sequence)
function new (string name = "apb_sequence");
super.new(name);
endfunction

virtual task body();
repeat(2)  begin
      req=apb_seq_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
      end
endtask
endclass

`endif 