/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:09
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Master agent which is Active agent
File Name : master_agent.sv
*File ID : 114587
*Modified by : #your name#
*/

class master_agent extends uvm_agent;
    `uvm_component_utils(master_agent);

    driver    drvr;
    iMonitor  iMon;
    sequencer seqr;
    uvm_analysis_port#(packet)ap;

    function new(string name = "master_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass: master_agent

function void master_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap=new("master_ap",this);
    if(is_active==UVM_ACTIVE)
    begin
        seqr=sequencer::type_id::create("seqr",this);
        drvr=driver::type_id::create("drvr",this);
    end
    iMon=iMonitor::type_id::create("iMon",this);
endfunction: build_phase

function void master_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active==UVM_ACTIVE)
    begin
        drvr.seq_item_port.connect(seqr.seq_item_export);
    end
    iMon.analysis_port.connect(this.ap);
endfunction: connect_phase

