/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:28
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Interface file
File Name : router_if.sv
*File ID : 600055
*Modified by : #your name#
*/

interface router_if(input clk);
    
    logic reset;
    logic [7:0]sa[4:1];
    logic sa_valid[4:1];
    logic [7:0]da[4:1];
    logic da_valid[4:1];

    logic wr,rd;
    logic [7:0] addr;
    logic [31:0] wdata;
    logic [31:0] rdata;

    clocking cb@(posedge clk);
        output sa;
        output sa_valid;
        input da;
        input da_valid;
        output wr,rd;
        output addr,wdata;
        input rdata;
    endclocking

    clocking mcb@(posedge clk);
        input sa;
        input sa_valid;
        input da;
        input da_valid;
        input rdata;
    endclocking
    
    modport tb (clocking cb,output reset);
    modport tb_mon (clocking mcb);

endinterface: router_if
