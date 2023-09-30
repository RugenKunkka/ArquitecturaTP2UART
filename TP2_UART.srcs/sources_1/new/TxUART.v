`timescale 1ns / 1ps

//OJO por protocolo no son mas de 8, hay un estudio de todo esto teniendo en cuenta la longitud del cable etc.. por eso es que no es mas de 8 bits
//`define DATA_LENGTH 8//cant de bits del dato 

/*module TxUART(
        input wire i_clock,
        input wire i_reset,
        
        input wire i_tick,
        input wire i_txStart,//empieza el tx a cargar el dato, es para activarlo digamos.. 
        
        input wire [`DATA_LENGTH-1:0] i_data,
        
        
        
        output wire o_doneTick,//se pone en alto cuando finalizó su tarea solamente por 1 ciclo de clock
        output wire o_txData
        
         
    );*/
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
    
    
module TxUART
# (
  parameter DATA_LENGTH = 8, // # data bits
  SB_TICK = 16 // # ticks for stop bits
)
(
  input wire i_clock, i_reset,
  input wire i_tick, i_txStart,
  input wire [7:0] i_data,
  output reg o_doneTick,
  output wire o_txData
);
  // Declaración de estados simbólicos
  localparam [1:0] IDLE_STATE = 2'b00;
  localparam [1:0] START_STATE = 2'b01;
  localparam [1:0] DATA_STATE = 2'b10;
  localparam [1:0] STOP_STATE = 2'b11;

  // Declaración de señales
  reg [1:0] reg_actualState, reg_nextActualState;
  reg [3:0] reg_ticksCounter, reg_nextTicksCounter;
  reg [2:0] reg_bitsTxCounter, reg_nextBitsTxCounter;
  reg [7:0] b_reg, b_next;
  reg tx_reg, tx_next;

  // Registros de estado y datos de la FSMD
    always @(posedge i_clock or posedge i_reset)
    begin
        if (i_reset) begin
            reg_actualState <= IDLE_STATE;
            reg_ticksCounter <= 0;
            reg_bitsTxCounter <= 0;
            b_reg <= 0;
            tx_reg <= 1'b1;
        end
        else begin
            reg_actualState <= reg_nextActualState;
            reg_ticksCounter <= reg_nextTicksCounter;
            reg_bitsTxCounter <= reg_nextBitsTxCounter;
            b_reg <= b_next;
            tx_reg <= tx_next;
        end
    end

    // Lógica de próximo estado de la FSMD y unidades funcionales
    always @(*) begin
        reg_nextActualState = reg_actualState;
        o_doneTick = 1'b0;
        reg_nextTicksCounter = reg_ticksCounter;
        reg_nextBitsTxCounter = reg_bitsTxCounter;
        b_next = b_reg;
        tx_next = tx_reg;

        if(reg_actualState==IDLE_STATE) begin
            tx_next = 1'b1;
            if (i_txStart) begin
                reg_nextActualState = START_STATE;
                reg_nextTicksCounter = 0;
                b_next = i_data;
            end
        end
        else if(reg_actualState==START_STATE)begin
            tx_next = 1'b0;
            if (i_tick) begin
                if (reg_ticksCounter == 15) begin
                    reg_nextActualState = DATA_STATE;
                    reg_nextTicksCounter = 0;
                    reg_nextBitsTxCounter = 0;
                end
                else begin
                    reg_nextTicksCounter = reg_ticksCounter + 1;
                end
            end
        end
        else if(reg_actualState==DATA_STATE) begin
            tx_next = b_reg[0];
            if (i_tick) begin
                if (reg_ticksCounter == 15) begin
                    reg_nextTicksCounter = 0;
                    b_next = b_reg >> 1;
                    if (reg_bitsTxCounter == (DATA_LENGTH - 1)) begin
                        reg_nextActualState = STOP_STATE;
                    end
                    else begin
                        reg_nextBitsTxCounter = reg_bitsTxCounter + 1;
                    end
                end
                else begin
                    reg_nextTicksCounter = reg_ticksCounter + 1;
                end
            end
        end
        else if(reg_actualState==STOP_STATE)begin
            tx_next = 1'b1;
            if (i_tick) begin
                if (reg_ticksCounter == (SB_TICK - 1)) begin
                    reg_nextActualState = IDLE_STATE;
                    o_doneTick = 1'b1;
                end
                else begin
                    reg_nextTicksCounter = reg_ticksCounter + 1;
                end
            end
        end
  end
  // Salida
  assign o_txData = tx_reg;

endmodule

