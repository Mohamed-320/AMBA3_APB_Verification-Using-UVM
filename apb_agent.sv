
/***************************************Agent is a container class contains driver, sequencer, and monitor**********************************/
`ifndef APB_AGENT
`define APB_AGENT

import uvm_pkg::*;        // Standard UVM pkg
`include "uvm_macros.svh" //Standard UVM macros
`include"apb_driver.sv"
`include"apb_monitor.sv"

class apb_agent extends uvm_agent;
// agent components instance
apb_sequencer sequencer;
apb_driver driver;
apb_monitor monitor;

`uvm_component_utils(apb_agent)

function new(string name,uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
 monitor = apb_monitor::type_id::create("monitor", this);

//Depending on Agent type, create agent components in the build phase,
//driver and sequencer will be created only for the active agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = apb_driver::type_id::create("driver", this);
      sequencer = apb_sequencer::type_id::create("sequencer", this);
    end
      monitor = apb_monitor::type_id::create("monitor", this); //in case of the agent is not active
  endfunction

//Connect the driver seq_item_port to sequencer seq_item_export for communication between driver and sequencer in the connect phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass 
`endif