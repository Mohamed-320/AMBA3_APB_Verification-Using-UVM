
/*********************************** APB_Bridge*******************************/
module apb_bridge ( 
                    output   reg PENABLE, // R/W enable 
                    output   reg PSEL, // select signal
                    output   reg PWRITE, //control signal
                    output   reg [7:0] PADDR,
                    output   reg [7:0] PWDATA, // data Write [8-bit]
                    input    PCLK,  // @(posedge)
                    input   bit   RESET, //@(negedge)
                    input [3:0] PRDATA, // data sent by slave
		            input [20:0] system_bus );
 
 /*Registers Declarations*/
  reg PENABLE1;
  reg PSEL1;
  reg [7:0] PADDR1;
  reg [7:0] PWDATA1;
  reg [1:0] state;
  reg [7:0] sys_data;
  reg [7:0] sys_addr;
  reg [1:0] sys_type;
  reg sys_active; 
  
  /*****[R/W] = 0/1*****/
 parameter READ= 2'd0;
 parameter WRITE=2'd1; 
 
  /*****States Definiations*****/
 parameter IDLE = 2'd0;
 parameter SETUP = 2'd1;
 parameter ACCESS  = 2'd2;
 
 
always @ ( * )
  begin
    sys_data = system_bus [7:0];
    sys_addr = system_bus [15:8];
    sys_type = system_bus [19:18];
    sys_active =system_bus [20];  
  end

  /*******************************APB_Bridge Config. [R/W]**********************/
  always @ (posedge PCLK or negedge RESET)
  begin
    if(!RESET)
     PWRITE <= 1'b0;
    else 
    begin
      if ( state == SETUP )
       begin
	 case (sys_type)
	    READ :
	     begin
	       PWRITE  <= 1'b0;
	     end
	    WRITE :
	     begin
 	       PWRITE  <= 1'b1;
	     end
	  endcase
     end  
end  
 end  
   /*******************************RESET Condition***********************************/
  always @ ( posedge PCLK or negedge RESET )
  begin 
    if(!RESET)
      state <= IDLE;
    else
  /********************** States Transitions **************************/
  begin 
    PENABLE = 0;
    PSEL    = 0;
    PADDR   = 0;
    PWDATA  = 0;
    state = IDLE; 
    case ( state )
      /*************** IDLE STATE**************/
      IDLE :  
        begin
          if (sys_active == 1)
          begin
              state = SETUP;
              PENABLE1 = 0;
              PSEL1 = 4'b0;
          end
          else 
	      PENABLE1 = 0;
	   end
      /*************** SETUP STATE**************/
      SETUP :
        begin 
           PENABLE1  = 0;
		   PWDATA1 = sys_data;
	       PADDR1 = sys_addr;
           state  = ACCESS;
        if ((sys_type == 2'b01)||(sys_type == 2'b10)) 
		   begin
	        PSEL1 = 1'b1;
			end
	    else if ((sys_type == 2'b00)||(sys_type == 2'b11))
		  begin
	             state    = IDLE ;
		  end
	     end
     /*************** SETUP STATE**************/
      ACCESS  :
        begin            
            PENABLE1 = 1;  
	        PSEL1 = 1; 
	     if (sys_type == 2'b10 )   //READ   
           begin		  
            PADDR1 = sys_type;
	    	end
         else if( sys_type == 2'b01) //WRITE
          begin    
            PWDATA1   = sys_data;		  
            PADDR1    = sys_addr;
          end
    /*********state transition to SETUP in case of back to back write ***********/
          if ((sys_type == 2'b01)||( sys_type == 2'b10))
  	        state = SETUP;
	      else    
            state = IDLE;          
        end  
      default : state = IDLE; 
    endcase 
  end 
end

  /*************assigning the internal signal values to the outputs of SLAVE*************/
  always @ (posedge PCLK or negedge RESET)
  begin
    if (!RESET)
    begin
      PSEL <= 4'b0000;
      PENABLE   <= 1'b0;
	  PWDATA <= 8'b0;
      PADDR <= 8'b0;
    end

    else if ((state == SETUP)||(state == ACCESS)||(sys_active == 0))
    begin
      PSEL    <= PSEL1;
      PENABLE <= PENABLE1;
	  PWDATA  <= PWDATA1;
      PADDR   <= PADDR1;
    end
  end
endmodule
