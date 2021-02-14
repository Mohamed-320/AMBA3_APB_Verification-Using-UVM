
module top_apb(clk,reset,sysbus,prdata);
input clk,reset;
output reg [7:0] prdata;
input [20:0] sysbus;

wire psel,penable,pwrite;
wire [7:0] paddr;
wire [7:0] pwdata;

apb_bridge DUT1( .psel(psel),// select signals
             .penable(penable),      // enable signal
              .pwrite(pwrite), // write signal
               .paddr(paddr),  // 8-bit address
              .pwdata(pwdata), // 8-bit data                    	
               .clk(clk),   // clock signal
                .reset(reset), // negedge reset
		.system_bus(sysbus),       
	         .prdata(prdata)    
);

apb_slave DUT2( .prdata(prdata), //dataout from slave 
               .penable(penable),// to enable read or write
               .pwrite(pwrite), // control signal 
                .psel(psel),  // select signal
                .clk(clk),   // posedge clk
                 .reset(reset), // negedge reset              
                 .paddr(paddr),  // 8-bit address            
                  .pwdata(pwdata)  // 8-bit write data
);
endmodule
