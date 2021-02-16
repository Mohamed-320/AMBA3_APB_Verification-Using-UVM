
/*******************************************driver receives the stimulus from sequence via sequencer and drives on interface signals***************************************/
`ifndef APB_DRIVER
`define APB_DRIVER

import uvm_pkg::*;        // Standard UVM pkg
`include "uvm_macros.svh" //Standard UVM macros
`include "apb_seq_item.sv"
`include "apb_sequencer.sv"

` define driv_if intf.DRIVER.driver_cb

class apb_driver extends uvm_driver#(apb_seq_item);
   // Declare the virtual interface
    virtual apb_intf intf;

    `uvm_component_utils(apb_driver)
     function new(string name, uvm_component parent);
        super.new(name,parent);
     endfunction : new

    //Get the interface handle using get config_db & adding the get config_db in the build_phase
     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      if(!uvm_config_db#(virtual apb_intf)::get(this,"","intf",intf))`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
     endfunction : build_phase

  // run phase
 virtual task run_phase(uvm_phase phase);
 forever begin
 seq_item_port.get_next_item(req);
 drive();
 seq_item_port.item_done();
 end
 endtask : run_phase
 
 // drive phase
 virtual task drive();
 req.print();
 
 @(posedge intf.DRIVER.PCLK);
  `driv_if.sysbus <= req.sysbus;

 @(posedge intf.DRIVER.PCLK);
  req.PRDATA= `driv_if.PRDATA;
 endtask : drive
endclass : apb_driver
 `endif