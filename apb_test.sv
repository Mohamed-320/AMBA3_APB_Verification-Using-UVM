
/************************** The test defines the test scenario for the testbench **********************************/  
`ifndef APB_TEST
`define APB_TEST

import uvm_pkg::*;        // Standard UVM pkg
`include "uvm_macros.svh" //Standard UVM macros
`include "apb_env.sv"

class apb_test extends uvm_test;
`uvm_component_utils(apb_test)
apb_env env;

 function new(string name="apb_test",uvm_component parent=null);
  super.new(name,parent);
 endfunction : new

 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create the env
    env = apb_env::type_id::create("env", this);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask : run_phase

/*
  virtual function void end_of_elaboration();
    print();
  endfunction

  // end_of_elobaration phase (Report Phase)  
 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 
*/
endclass 
`endif