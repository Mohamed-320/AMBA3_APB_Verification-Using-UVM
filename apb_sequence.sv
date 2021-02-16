/**************************************************************************************************
// Sequence generates the stimulus and sends to driver via sequencer
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

//Logic to generate and send the sequence_item is added inside the body() method
virtual task body();

      req=apb_seq_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
      
endtask
endclass

`endif 