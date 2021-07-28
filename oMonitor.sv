//  Class: oMonitor
//
class oMonitor extends uvm_monitor;
    `uvm_component_utils(oMonitor);
    
    virtual router_if.tb_mon vif;
    bit[31:0] no_of_pkts_recvd;
    
    static bit[2:0] id;
    bit[2:0]obj_id;

    uvm_analysis_port #(packet) analysis_port;
    packet pkt;

    function new(string name = "oMonitor", uvm_component parent);
        super.new(name, parent);
        id++;
        obj_id=id;
    endfunction: new

    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);       
    
endclass: oMonitor

function void oMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual router_if.tb_mon)::get(get_parent(),"","oMon_if",vif))
    begin
        `uvm_fatal("VIF_ERR",$sformatf("Virtual Interface in oMonitor %0d is NULL",obj_id))       
    end
    analysis_port=new("analysis_port",this);
endfunction: build_phase

task oMonitor::run_phase(uvm_phase phase);
    bit[7:0] outp_q[$];
    byte unsigned pack_arr[];
    `uvm_info($sformatf("oMon %3d",obj_id),"Run Started", UVM_MEDIUM);
    forever 
    begin
        @(posedge vif.mcb.da_valid[obj_id]);
        no_of_pkts_recvd++;
        while (1) 
        begin
            if (vif.mcb.da_valid[obj_id]==0) 
            begin 
                pkt=new;
                pack_arr=outp_q;
                void'(pkt.unpack_bytes(pack_arr));
                pkt.tot_pkt=outp_q;
                analysis_port.write(pkt);
                `uvm_info($sformatf("oMon %3d",obj_id),$sformatf("Sent packet %0d [SA(%0d -> DA(%0d)] to scoreboard",no_of_pkts_recvd,pkt.sa,pkt.da), UVM_MEDIUM);
                // pkt.print();
                outp_q.delete();
                pack_arr.delete();
                break;
            end//if
            outp_q.push_back(vif.mcb.da[obj_id]);
            @(vif.mcb);
        end//while
    end//forever
    
endtask: run_phase

