
`include "apb_top.sv"
`include "apb_test.sv"


module apb_testbench_top;

  bit clk;                //clock signal declaration
  bit reset;                //reset signal declaration
  always #5 clk = ~clk;   //clock generation
  
  //reset Generation
  initial begin
    reset = 1;
    #5 reset =0;
  end
  
  //interface instance
  apb_intf intf(clk,reset);
  
  //DUT instance, interface signals are connected to the DUT ports
  top_apb DUT (
    .clk(intf.clk),
    .reset(intf.rst),
    .sysbus(intf.sysbus),
    .prdata(intf.rdata)
   );
  
  //passing the interface handle to lower heirarchy using set method and enabling the wave dump
  initial begin 
    uvm_config_db#(virtual apb_intf)::set(uvm_root::get(),"*","intf",intf);
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  initial begin 
    run_test();
  end
  
endmodule