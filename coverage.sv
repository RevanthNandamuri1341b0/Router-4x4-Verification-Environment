/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:05
*Project name : Router 4x4 verification
*Domain : UVM
*Description : Coverage File
File Name : coverage.sv
*File ID : 222986
*Modified by : #your name#
*/

class coverage extends uvm_subscriber#(packet);
    `uvm_component_utils(coverage);
    packet pkt;
    real coverage_score;
    bit [31:0] no_of_pkts_recvd;

    //  Covergroup: cov_mem
    //
    covergroup cov_mem with function sample(packet pkt);
        
        coverpoint pkt.sa   //source
        {
            bins sa_0={0};
            bins sa_1={1};
            bins sa_2={2};
            bins sa_3={3};
        }

        coverpoint pkt.da   //destination
        {
            bins da_0={0};
            bins da_1={1};
            bins da_2={2};
            bins da_3={3};
        }
        cross pkt.sa,pkt.da;
    endgroup: cov_mem

    function new(string name = "coverage", uvm_component parent);
        super.new(name, parent);
        cov_mem=new;
    endfunction: new

    function void write(T t);
        if (!$cast(pkt, t.clone)) 
        begin
            `uvm_fatal("FCOV","Transaction object supplied is NULL in coverage component");
        end
        no_of_pkts_recvd++;
        cov_mem.sample(pkt);
        coverage_score=cov_mem.get_coverage();
        `uvm_info("FCOV",$sformatf("Coverage = %0f",coverage_score),UVM_NONE);
    endfunction: write

    extern function void extract_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
            
endclass: coverage



function void coverage::extract_phase(uvm_phase phase);
    uvm_config_db#(real)::set(null, "uvm_test_top.env", "cov_score", coverage_score);        
endfunction: extract_phase

function void coverage::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("FCOV",$sformatf("Total packets received = %0d AND Coverage = %0d",no_of_pkts_recvd,coverage_score), UVM_NONE);
endfunction: report_phase
