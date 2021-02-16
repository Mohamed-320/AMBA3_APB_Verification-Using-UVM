/********************************************************************************************************
//fields required to generate the stimulus are declared in the sequence_item
//sequence_item can be used as a placeholder for the activity monitored by the monitor on DUT signals
*********************************************************************************************************/
`ifndef APB_SEQ_ITEM
`define APB_SEQ_ITEM
 
import uvm_pkg::*;        // Standard UVM pkg
`include "uvm_macros.svh" //Standard UVM macros

class apb_seq_item extends uvm_sequence_item;

 rand bit [20:0] sysbus; 
 bit [7:0] PRDATA; // data sent by slave

  //Utility macros
  `uvm_object_utils_begin(apb_seq_item)
  `uvm_field_int(sysbus,UVM_ALL_ON)
  `uvm_object_utils_end


  //Constructor
  function new(string name= "apb_seq_item");
      super.new(name);
  endfunction
endclass
`endif 