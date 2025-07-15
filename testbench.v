//Testbench

`timescale 1ns / 1ps

module testbench ();
     reg clk;
     reg reset;
     
     wire [18:0] instruction;
     wire [31:0] result;
 
    // Instantiate CPU
    cpu uut (
         .clk(clk),
         .reset(reset)
    );
    
    // Clock generation
    always #5 clk=~clk;

    initial begin
        clk=0;
        reset=1;
         #10;
         reset=0;
         #1000; //run for sufficient cycles
         $stop 

    end
endmodule