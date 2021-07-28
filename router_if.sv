//  Interface: router_if
//
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
