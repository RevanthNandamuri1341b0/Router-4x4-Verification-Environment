/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:47
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Sequence [SA2 -> Rest all OP ports]
File Name : sa2_sequence.sv
*File ID : 789833
*Modified by : #your name#
*/

class sa2_sequence extends uvm_sequence#(packet);
    int unsigned item_count;
    `uvm_object_utils(sa2_sequence);

    function new(string name = "sa2_sequence");
        super.new(name);
        set_automatic_phase_objection(1);
    endfunction: new

    extern virtual task pre_start();
    extern virtual task body();
    
endclass: sa2_sequence

task sa2_sequence::pre_start();
    if(!uvm_config_db #(int)::get(get_sequencer(),"","item_count",item_count))
    begin
        `uvm_warning(get_full_name(),"item_count is not set in sa2_sequencer");
        item_count=10;
    end
endtask: pre_start

task sa2_sequence::body();
    bit[31:0]count;
    REQ ref_pkt;
    ref_pkt=packet::type_id::create("ref_pkt",,get_full_name());
    repeat(item_count)
    begin
        `uvm_create(req);
        assert(ref_pkt.randomize() with {sa==2;});
        req.copy(ref_pkt);
        req.mode=STIMULUS;
        start_item(req);
        finish_item(req);
        count++;
        `uvm_info("SEQ",$sformatf("MASTER SEQUENCE : Transaction %0d DONE ",count ), UVM_MEDIUM);
    end
endtask: body
