//  Class: base_test
//
class base_test extends uvm_test;
    `uvm_component_utils(base_test);
    virtual router_if vif;
    bit[31:0] pkt_count;
    environment env;

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern function void build_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);      

endclass: base_test


function void base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=environment::type_id::create("env",this);
    uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
    for (bit[2:0]k=0;k<=4;k++) 
    begin
        uvm_config_db#(virtual router_if.tb)::set(this, $sformatf("env.m_agent[%0d]",k),"drvr_if",vif.tb);
        uvm_config_db#(virtual router_if.tb_mon)::set(this, $sformatf("env.m_agent[%0d]",k),"iMon_if",vif.tb_mon);
        uvm_config_db#(virtual router_if.tb_mon)::set(this, $sformatf("env.s_agent[%0d]",k),"oMon_if",vif.tb_mon);
    end
    
    pkt_count=5;

    for (bit[2:0]k = 1; k<=4; k++)
    uvm_config_db#(int)::set(this, $sformatf("env.m_agent[%0d].seqr",k), "item_count", pkt_count);
    
    uvm_config_db#(int)::set(this,"env","item_count",pkt_count*4);

    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.reset_phase", "default_sequence", reset_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.configure_phase", "default_sequence", config_sequence::get_type());

    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.main_phase", "default_sequence", sa1_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[2].seqr.main_phase", "default_sequence", sa2_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[3].seqr.main_phase", "default_sequence", sa3_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[4].seqr.main_phase", "default_sequence", sa4_sequence::get_type());
    
endfunction: build_phase

function void base_test::final_phase(uvm_phase phase);
    super.final_phase(phase);
    //uvm_top.print_topology()
    //factory.print();
endfunction: final_phase


task base_test::main_phase(uvm_phase phase);
    uvm_objection objection;
    super.main_phase(phase);
    objection=phase.get_objection();
    objection.set_drain_time(this,5000ns);
endtask: main_phase
