`timescale 1ns / 1ps

//OJO por protocolo no son mas de 8, hay un estudio de todo esto teniendo en cuenta la longitud del cable etc.. por eso es que no es mas de 8 bits
`define DATA_LENGTH 8//cant de bits del dato 

module TxUART(
        input wire i_clock,
        input wire i_reset,
        
        input wire i_tick,
        input wire i_txStart,//empieza el tx a cargar el dato, es para activarlo digamos.. 
        
        input wire [`DATA_LENGTH-1:0] i_data,
        
        
        
        output wire o_doneTick,//se pone en alto cuando finalizó su tarea solamente por 1 ciclo de clock
        output wire o_txData
        
         
    );
    //INTERFAZZ!!!
    /*
        i_clock
        i_reset
        i_tick
        i_txStart
        i_data
        o_doneTick
        o_txData
    */
    
    localparam DATA_LENGTH= `DATA_LENGTH;
    
    //estados 
    localparam [1:0] IDLE_STATE      = 2'b00;
    localparam [1:0] START_STATE     = 2'b01;
    localparam [1:0] READ_DATA_STATE = 2'b10;
    localparam [1:0] STOP_STATE      = 2'b11;
    
    reg [DATA_LENGTH-1:0]i_reg_data;
    
    reg [1:0] reg_actualState;
    reg [4-1:0] reg_ticksCounter;
    reg [4-1:0] reg_bitsTxCounter;
    //reg [4-1:0] reg_transmitedBitsCounter;
    
    reg o_reg_txData;
    reg o_reg_doneTick;
    
    always@( posedge i_tick) begin
        if(i_reset) begin
            reg_actualState<=IDLE_STATE;
            reg_ticksCounter<=0;
            reg_bitsTxCounter<=0;
            //reg_transmitedBitsCounter<=0;
            o_reg_txData<=1;
            o_reg_doneTick<=0;
        end
        else begin
            o_reg_doneTick<=1'b0;
            if(reg_actualState == IDLE_STATE)begin
                o_reg_txData=1;
                if(i_txStart)begin
                    reg_actualState<= START_STATE;
                end
            end
            else if(reg_actualState==START_STATE) begin
                o_reg_txData<=0;
                if(reg_ticksCounter==15) begin 
                    i_reg_data<=i_data;
                    reg_actualState<= READ_DATA_STATE;
                    //reg_transmitedBitsCounter<=0;
                end 
                else begin
                    reg_ticksCounter<=reg_ticksCounter+1;
                end
            end
            else if(reg_actualState==READ_DATA_STATE) begin
                if(reg_ticksCounter==15)begin
                    o_reg_txData<=i_data[reg_bitsTxCounter];
                    reg_bitsTxCounter<=reg_bitsTxCounter+1;
                    reg_ticksCounter<=0;
                    if(reg_bitsTxCounter==8)begin
                         reg_actualState<=STOP_STATE;
                    end
                end
                else begin
                    reg_ticksCounter<=reg_ticksCounter+1; 
                end  
            end
            else if(reg_actualState==STOP_STATE)begin 
                o_reg_txData<=1'b1;
                if(reg_ticksCounter==15) begin
                     reg_actualState<= IDLE_STATE;
                     o_reg_doneTick<=1'b1;
                end
                else begin
                    reg_ticksCounter<=reg_ticksCounter+1;
                end
                
            end
        end
        
    end
    
    assign o_txData=o_reg_txData;
    assign o_doneTick=o_reg_doneTick;
endmodule
