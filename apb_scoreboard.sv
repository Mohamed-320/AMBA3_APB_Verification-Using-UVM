/*************************scoreboard receives the transaction from the monitor and compares it with the reference values*********************************/
`ifndef APB_SCOREBOARD
`define APB_SCOREBOARD

import uvm_pkg::*;        // Standard UVM pkg
`include "uvm_macros.svh" //Standard UVM macros
`include "apb_agent.sv"

class apb_scoreboard extends uvm_scoreboard;
`uvm_component_utils(apb_scoreboard)
  uvm_analysis_imp#(apb_seq_item, apb_scoreboard) item_collected_export;
 
  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction: build_phase
endclass

`endif

