
/*********************************** APB_SLAVE*******************************/
module apb_slave (  input    PCLK,  // @(posedge)
                    input    RESET, //@(negedge)
                    input    PENABLE, // R/W enable 
                    input    PSEL, // select signal
                    input    PWRITE, //control signal
                    input    [7:0] PADDR,
                    input    [7:0] PWDATA, // data Write [8-bit]
                    output  reg [3:0] PRDATA // data sent by slave
);
  reg [7:0] slave [0:255];  // 256 bytes
  reg [1:0]state;
  reg [7:0] PRDATA1;
  
  parameter IDLE=2'b00;
  parameter SETUP=2'b01;
  parameter ACCESS=2'b10;

/*finite state machine logic for slave*/
  always @ (posedge PCLK or negedge RESET )
  begin
    if (!RESET)
      state = IDLE;
    else 
     begin
     PRDATA1 = 8'b0;
     case(state)
    
   /*IDLE STATE*/
      IDLE   :
        begin 
	  if (!PENABLE )
	   begin
            if (PSEL == 0) 
	     begin
              state = IDLE;
	      PRDATA1 = 8'b0;
             end
	    
            else if ((PSEL == 1)&&(PENABLE == 0))
             begin
              state = SETUP;
	     end    
        end 
      end
     /*SETUP STATE*/
      SETUP  :
        begin 
	  
          if((PSEL == 1)&&(PENABLE == 0))
            begin
            state = SETUP;
            end
        end 
      /*ACCESS STATE*/
      ACCESS :
        begin
          if ((PSEL == 1)&&(PENABLE == 1))
            state  = ACCESS;
          else
          begin 
            state  = IDLE; // No Transfer (IDLE State)
          end 
	  if(!PWRITE)        
            PRDATA1 = slave[PADDR];
	  
          if ((PSEL == 0)&&(PENABLE == 0)) 
            state = IDLE;
        end 
      default : state = IDLE;
    endcase
end
  end 
  
  always @ (posedge PCLK or negedge RESET)
  begin 
    if (!RESET)
    begin
      PRDATA = 8'b0;
    end  
    else
      if ((state == ACCESS)&&(PWRITE == 0))
        PRDATA = PRDATA1;
  end

  always @ (posedge PCLK or negedge RESET)
  begin
    if ((state == ACCESS)&&(PWRITE ==1))
     begin
        slave [PADDR] = PWDATA; 
     end 
  end
  
endmodule