/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:49
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Scoreboard file to calculated matches and mismatches
File Name : scoreboard.sv
*File ID : 728073
*Modified by : #your name#
*/

class scoreboard #(type T=packet) extends uvm_scoreboard;
    typedef scoreboard#(T)scb_type;
    `uvm_component_param_utils(scb_type)

    const static string type_name = $sformatf("scoreboard#(%0s)",$typename(T));
    virtual function string get_type_name();
        return type_name;
    endfunction

    `uvm_analysis_imp_decl(_inp);
    `uvm_analysis_imp_decl(_outp);
    
    uvm_analysis_imp_inp#(T,scb_type) mon_inp;
    uvm_analysis_imp_outp#(T,scb_type) mon_outp;

    T q_in[$];
    bit[31:0]m_matches,m_mismatches;
    bit[31:0]no_of_pkts_recvd;

    function new(string name = "scoreboard", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_type_name(), "NEW Scoreboard", UVM_NONE);       
    endfunction: new
    
    extern function void build_phase(uvm_phase phase);
    extern virtual function void write_inp(T pkt);
    extern virtual function void write_outp(T pkt);
    extern function void extract_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
        

endclass: scoreboard

function void scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_inp=new("mon_inp",this);
    mon_outp=new("mon_outp",this);
endfunction: build_phase

function void scoreboard::write_inp(T pkt);
    T pkt_in;
    $cast(pkt_in, pkt.clone());
    q_in.push_back(pkt_in);
endfunction: write_inp

function void scoreboard::write_outp(T pkt);
    T ref_pkt;
    int get_index[$];
    int index;
    bit done;
    no_of_pkts_recvd++;
    get_index = q_in.find_index() with (item.sa==pkt.sa && item.da==pkt.da);
    foreach(get_index[i])
    begin
        index=get_index[i];
        ref_pkt=q_in[index];
        if (ref_pkt.compare(pkt)) 
        begin
            m_matches++;
            q_in.delete(index);
            `uvm_info("SCB_MATCH",$sformatf("Packet %0d Matched",no_of_pkts_recvd), UVM_NONE);
            done=1;
            break;         
        end
        else done=0;
    end
    if(!done)
    begin
        m_mismatches++;
        `uvm_error("SCB_NO_MATCH",$sformatf("****** NO MATCHING PACKET fOUND FOR THE PACKET Id = %0d ******",no_of_pkts_recvd));
        `uvm_info("SCB",$sformatf("EXPECTED::%0p",ref_pkt.tot_pkt), UVM_NONE);
        `uvm_info("SCB",$sformatf("RECEIVED::%0p",pkt.tot_pkt), UVM_NONE);
        done=0;
    end
endfunction: write_outp

function void scoreboard::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    uvm_config_db#(int)::set(null, "uvm_test_top.env", "matches",m_matches);
    uvm_config_db#(int)::set(null, "uvm_test_top.env", "mismatches",m_mismatches);
endfunction: extract_phase

function void scoreboard::report_phase(uvm_phase phase);
    `uvm_info("SCB",$sformatf("SCOREBOARD COMPLETED with MATCHES=%0d MISMATCHED=%0d",m_matches,m_mismatches), UVM_NONE)
endfunction: report_phase

