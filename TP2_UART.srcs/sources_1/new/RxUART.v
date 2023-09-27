`timescale 1ns / 1ps

`define DATA_LENGTH 8//cant de bits del dato

module RxUART(
        input wire i_rxData,//recievedData recibe el bit de información
        input wire i_clock,
        input wire i_tick,
        input wire i_reset,
        
        output wire [`DATA_LENGTH-1:0] o_data,
        output wire o_rxDone,
        output wire o_fail
    );
    //Interface!!
    /*
    i_rxData
    i_clock
    i_tick
    i_reset
     
    o_data
    o_rxDone
    o_fail
    */
    
    parameter DATA_LENGTH = `DATA_LENGTH;
    
    reg [DATA_LENGTH-1:0] o_reg_data;
    reg o_reg_rxDone;
    reg o_reg_fail;
       
    
    localparam [1:0] IDLE_STATE     = 2'b00;
    localparam [1:0] START_STATE    = 2'b01;
    localparam [1:0] READ_DATA_STATE = 2'b10;
    localparam [1:0] STOP_STATE     = 2'b11;
    
    reg [1:0] reg_actualState;
    reg [4-1:0] reg_ticksCounter;//cuenta 1ro hasta 7 y dsps hasta 15
    reg [4-1:0] reg_bitsRxCounter;
    
    
    always@( posedge i_clock) begin
    
        
    end
    
    always@( posedge i_tick) begin
        if(i_reset)begin
            reg_actualState<=IDLE_STATE;
            reg_ticksCounter<=0;
            reg_bitsRxCounter<=0;
            
            o_reg_data<=0;
            o_reg_fail<=0;
            o_reg_rxDone<=0;
        end
        else begin
            if(reg_actualState == IDLE_STATE) begin
               if(i_rxData==0) begin
                    reg_actualState<=START_STATE;
                    reg_ticksCounter<=0;
                    //o_reg_data<=0;
                    o_reg_fail<=0;
               end
               else begin
                    reg_actualState<=IDLE_STATE;
                    reg_ticksCounter<=0;
                    o_reg_rxDone<=0;
                    //o_reg_data<=0;
                    o_reg_fail<=0;
               end
                
            end
            else if(reg_actualState == START_STATE) begin
            //cuento 7 ticks antes de pasar al siguiente estado para posicionarme en el centro del diente de sierra para poder tener un margen de error de 1/16
                if(reg_ticksCounter==7) begin
                    reg_ticksCounter<=0;
                    reg_bitsRxCounter<=0;
                    o_reg_data<=0;
                    reg_actualState <= READ_DATA_STATE;
                end
                else begin
                    reg_actualState<=START_STATE;
                    reg_bitsRxCounter<=0;
                    reg_ticksCounter<=reg_ticksCounter+1;
                end
            end
            else if(reg_actualState == READ_DATA_STATE) begin
            //espero a tener 16 pulsos para poder ler el siguiente bit e ir conformando el dato
                if(reg_ticksCounter==15) begin
                    reg_ticksCounter<=0;
                    reg_bitsRxCounter=reg_bitsRxCounter+1;
                    //AGREGO EL BIT
                    o_reg_data <= {i_rxData, o_reg_data[7:1]};
                end
                else begin
                    reg_ticksCounter<=reg_ticksCounter+1; 
                end
                
                if(reg_bitsRxCounter==DATA_LENGTH)begin
                    reg_actualState <= STOP_STATE;
                    reg_ticksCounter<=0;
                    reg_bitsRxCounter<=0;
                end
            end
            else if(reg_actualState == STOP_STATE) begin
            //recibo el bit de verificación 
                if(reg_ticksCounter==15)begin
                    if(i_rxData==0) begin
                         o_reg_rxDone<=1;
                         o_reg_fail<=0;
                         reg_actualState=IDLE_STATE;
                         reg_ticksCounter<=0;
                    end
                    else begin
                        o_reg_rxDone<=1;
                        o_reg_fail<=1;
                        reg_actualState=IDLE_STATE;
                        reg_ticksCounter<=0;
                    end
                end
                else begin
                    reg_ticksCounter=reg_ticksCounter+1;
                end
            end
        end
        
    end
assign o_fail=o_reg_fail;
assign o_rxDone= o_reg_rxDone;
assign o_data=o_reg_data; 
    
endmodule
