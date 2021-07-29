/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:07
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Environment file 
File Name : environment.sv
*File ID : 443427
*Modified by : #your name#
*/

class environment extends uvm_env;
    `uvm_component_utils(environment);
    
    bit[31:0]exp_pkt_count;
    real tot_cov_score;
    bit[31:0] m_matches,mis_matches;

    master_agent        m_agent [4:1];
    slave_agent         s_agent [4:1];
    scoreboard#(packet) scb;
    coverage            cov_comp;

    function new(string name = "environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
    extern virtual function void extract_phase(uvm_phase phase);
    
endclass: environment

function void environment::build_phase(uvm_phase phase);
    super.build_phase(phase);
    for (bit[2:0]k=1; k<=4;k++) 
    begin
        m_agent[k]=master_agent::type_id::create($sformatf("m_agent[%0d]",k ),this);    
        s_agent[k]=slave_agent::type_id::create($sformatf("s_agent[%0d]",k ),this);    
    end
    scb=scoreboard#(packet)::type_id::create("scb",this);
    cov_comp=coverage::type_id::create("cov_comp",this);
endfunction: build_phase

function void environment::connect_phase(uvm_phase phase);
    for (bit[2:0]k=1; k<=4;k++)
    begin
        m_agent[k].ap.connect(scb.mon_inp);
        m_agent[k].ap.connect(cov_comp.analysis_export);
        s_agent[k].ap.connect(scb.mon_outp);
    end
endfunction: connect_phase

function void environment::extract_phase(uvm_phase phase);
    uvm_config_db#(int)::get(this, "", "item_count", exp_pkt_count);
    uvm_config_db#(real)::get(this, "", "cov_score", tot_cov_score);
    uvm_config_db#(int)::get(this, "", "matches", m_matches);
    uvm_config_db#(int)::get(this, "", "mismatches", mis_matches);
endfunction: extract_phase

function void environment::report_phase(uvm_phase phase);
    bit [31:0] tot_scb_cnt;
    tot_scb_cnt=m_matches+mis_matches;
    
    if(exp_pkt_count!=tot_scb_cnt)
    begin
        `uvm_info("FAIL", "=====================================================", UVM_NONE);
        `uvm_info("FAIL", "Test failed dud to packet count MIS_MATCH!", UVM_NONE);
        `uvm_info("FAIL", $sformatf("Expected count=%0d Received count=%0d", exp_pkt_count,tot_scb_cnt), UVM_NONE);
        `uvm_fatal("FAIL","=====================TEST FAILED=====================");        
    end
    else if (mis_matches!=0) 
    begin
        `uvm_info("FAIL", "=====================================================", UVM_NONE);
        `uvm_info("FAIL", "Failed due to mismatched packets in Scoreboard", UVM_NONE)
        `uvm_info("FAIL", $sformatf("Matches=%0d    MisMatches=%0d",m_matches,mis_matches), UVM_NONE);
        `uvm_fatal("FAIL","=====================TEST FAILED=====================");        
    end
    else
    begin
        `uvm_info("PASS", "=====================TEST PASSED=====================", UVM_NONE);
        `uvm_info("PASS", $sformatf("Matches=%0d    MisMatches=%0d",m_matches,mis_matches), UVM_NONE);
        `uvm_info("PASS", $sformatf("Expected count=%0d Received count=%0d", exp_pkt_count,tot_scb_cnt), UVM_NONE);
        `uvm_info("PASS", $sformatf("Coverage = %0f%%",tot_cov_score), UVM_NONE);
        `uvm_info("PASS", "=====================================================", UVM_NONE);
    end
endfunction: report_phase
