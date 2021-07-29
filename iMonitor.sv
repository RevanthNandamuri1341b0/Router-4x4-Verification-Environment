/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:08
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Input monitor file
File Name : iMonitor.sv
*File ID : 596931
*Modified by : #your name#
*/

class iMonitor extends uvm_monitor;
    `uvm_component_utils(iMonitor);
    virtual router_if.tb_mon vif;
    bit [31:0] no_of_pkts_recvd;
    static bit [2:0]id;
    bit [2:0]obj_id;
    uvm_analysis_port#(packet) analysis_port;

    packet pkt;
    
    function new(string name = "iMonitor", uvm_component parent);
        super.new(name, parent);
        id++;
        obj_id=id;
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    
    extern task run_phase(uvm_phase phase);

endclass: iMonitor

function void iMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual router_if.tb_mon)::get(get_parent(), "", "iMon_if", vif))
    begin
        `uvm_fatal("VIF_ERR",$sformatf("virtual interface in iMonitor %0d is NULL",obj_id));
    end
    analysis_port=new("analysis_port",this);
endfunction: build_phase

task iMonitor::run_phase(uvm_phase phase);
    bit[7:0] inp_q[$];
    byte unsigned pack_arr[];
    `uvm_info($sformatf("iMon %3d",obj_id),"Run Started", UVM_MEDIUM);
    forever 
    begin
        @(posedge vif.mcb.sa_valid[obj_id]);
        no_of_pkts_recvd++;
        while (1) 
        begin
            if (vif.mcb.sa_valid[obj_id]==0) 
            begin
                pkt=new;
                pack_arr=inp_q;
                void'(pkt.unpack_bytes(pack_arr));
                pkt.tot_pkt=inp_q;
                analysis_port.write(pkt);
                `uvm_info($sformatf("iMon %3d",obj_id),$sformatf("Sent packet %0d [SA(%0d) -> DA(%0d)]",no_of_pkts_recvd,pkt.sa,pkt.da), UVM_MEDIUM);
                //pkt.print();
                inp_q.delete();
                pack_arr.delete();
                break;
            end//if
            inp_q.push_back(vif.mcb.sa[obj_id]);
            @(vif.mcb);
        end//while
    end//forever
endtask: run_phase
