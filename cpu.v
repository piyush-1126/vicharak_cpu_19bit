// 19-bit CPU Architecture for Vicharak
// Developed in Verilog - Modular, Pipelined, Custom Instruction Set
// Module: CPU Top


module CPU (
     input clk,
     input reset
);
     reg [18:0] instruction_register;
     reg [15:0] r [0:15];
     reg [15:0] mem [0:255];
     reg [15:0] pc;
     reg [15:0] stack [0:15];
     reg [3:0] sp;

     wire [4:0] opcode;
     wire [3:0] r1, r2; 
     wire [5:0] re_or_addr;

     assign opcode=instruction_register[18:14];
     assign r1=instruction_register[13:10];
     assign r2=instruction_register[9:6];
     assign r3_or_addr=instruction_register[5:0];

     wire [15:0] r3_data;
     assign r3_data=r3_or_addr[5] ? {{10{r3_or_addr[5]}}, r3_or_addr} : r[r3_or_addr[3:0]];

     always @(posedge clk or posedge reset) begin
         if(reset) begin
             pc<=0;
             sp<=0;
         end else begin
             instruction_register<=memory[pc];
             pc<=pc+1;
             case (opcode)
                 5'b00000: r[r1] <= r[r2] + r3_data;
                 5'b00001: r[r1] <= r[r2] - r3_data;
                 5'b00010: r[r1] <= r[r2] * r3_data;
                 5'b00011: r[r1] <= r[r2] / r3_data;
                 5'b00100: r[r1] <= r[r1] + 1;
                 5'b00101: r[r1] <= r[r1] - 1;
                 5'b00110: r[r1] <= r[r2] & r3_data;
                 5'b00111: r[r1] <= r[r2] | r3_data;
                 5'b01000: r[r1] <= r[r2] ^ r3_data;
                 5'b01001: r[r1] <= ~r[r2]
                 5'b01010: r[r1] <= pc <= {r1, r2, r3_or_addr};
                 5'b01011: r[r1] <= if (r[r1] == r[r2]) pc <= {r3_or_addr, 10'b0};
                 5'b01100: r[r1] <= if (r[r1] != r[r2]) pc <= {r3_or_addr, 10'b0};
                 5'b01101: begin stack[sp] <= pc; sp <= sp + 1; pc <= {r1, r2, r3_or_addr}; end
                 5'b01110: begin sp <= sp - 1; pc <= stack[sp]; end
                 5'b01111: r[r1] <= r[r1] <= memory[{r2,r3_or_addr[3:0]}];
                 5'b10000: r[r1] <= memory[{r2, r3_or_addr[3:0]}] <= r[r1];
                 5'b10001: r[r1] <= memory[r[r1]] <= fft(memory[r[r2]]);
                 5'b10010: r[r1] <= memory[r[r1]] <= encrypt(memory[r[r2]]);
                 5'b10011: r[r1] <= memory[r[r1]] <= decrypt(memory[r[r2]]);
                 default;
             endcase
          end
      end
    
      function [15:0] fft;
          input [15:0]data;
          begin fft = data ^ 16'hAAAA; end
      endfunction

     function [15:0] encrypt;
          input [15:0] data;
          begin encrypt = data + 16'h3F3F; end
     endfunction

     function [15:0] decrypt;
          input [15:0] data;
          begin decrypt = data - 16'h3F3F; end
     endfunction
endmodule            









