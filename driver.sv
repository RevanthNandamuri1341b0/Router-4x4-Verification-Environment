/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:06
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Stimulus driving file
File Name : driver.sv
*File ID : 043984
*Modified by : #your name#
*/

class driver extends uvm_driver#(packet);
    `uvm_component_utils(driver);
    bit[31:0] no_of_pkts_recvd;
    virtual router_if.tb vif;
    bit [31:0] csr_rdata;
    static bit[2:0] id;
    bit[2:0] obj_id;

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
        id++;
        obj_id=id;
    endfunction: new

    extern task run_phase(uvm_phase phase);    
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task drive(ref packet pkt);
    extern virtual task drive_stimulus(input packet pkt);
    extern virtual task drive_reset(input packet pkt);
    extern virtual task configure_dut_csr(input packet pkt);
    extern virtual task read_dut_csr(ref packet pkt);
    
endclass: driver

task driver::run_phase(uvm_phase phase);
    `uvm_info($sformatf("Drvr %2d",obj_id),"run started",UVM_MEDIUM);
    forever 
    begin
        seq_item_port.get_next_item(req);
        no_of_pkts_recvd++;
        `uvm_info("get_pkt",$sformatf("Driver %0d Received %0s Transaction %0d From TLM port",obj_id,req.mode.name(),no_of_pkts_recvd),UVM_HIGH);
        drive(req);
        seq_item_port.item_done();
        `uvm_info("get_pkt",$sformatf("Driver %0d Transaction %0d Done",obj_id,no_of_pkts_recvd), UVM_MEDIUM);        
    end
endtask: run_phase

function void driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual router_if.tb)::get(get_parent(),"", "drvr_if", vif);
    assert (vif!=null)else   
    `uvm_fatal("VIF_ERR",$sformatf("virtual interface in Driver %0d is null ",obj_id));
endfunction: build_phase

task driver::drive(ref packet pkt);
    case (pkt.mode)
        RESET     : drive_reset(pkt);
        CSR_WRITE : configure_dut_csr(pkt);
        CSR_READ  : read_dut_csr(pkt);
        STIMULUS  : drive_stimulus(pkt);
        default   : begin   `uvm_info($sformatf("[DRVR %2d]",obj_id ), "Unknown packet recieved", UVM_MEDIUM);end
    endcase
endtask: drive

task driver::drive_reset(input packet pkt);
    `uvm_info("RESET_PKT",$sformatf("[DRVR %2d] Applying Reset to DUT",obj_id), UVM_MEDIUM);
    vif.reset<=1'b1;
    repeat(pkt.reset_cycles) @(vif.cb);
    vif.reset<=1'b0;
    `uvm_info("RESET_PKT",$sformatf("[DRVR %2d] DUT is out of Reset",obj_id), UVM_MEDIUM);
endtask: drive_reset

task driver::configure_dut_csr(input packet pkt);
    `uvm_info("REG_READ",$sformatf("[DRVR %2d] Register Write operation started",obj_id), UVM_MEDIUM);
    vif.cb.wr<=1;
    vif.cb.addr<=pkt.addr;
    vif.cb.wdata<=pkt.data;
    @(vif.cb);
    vif.cb.wr<=0;
    `uvm_info("REG_READ",$sformatf("[DRVR %2d] Register Write operation ended",obj_id), UVM_MEDIUM);
endtask: configure_dut_csr


task driver::read_dut_csr(ref packet pkt);
    `uvm_info("REG_READ",$sformatf("[DRVR %2d] Register Read operation started",obj_id), UVM_MEDIUM);
    @(vif.cb);
    vif.cb.rd<=1;
    vif.cb.addr<=pkt.addr;
    @(vif.cb.rdata);
    csr_rdata=vif.cb.rdata;
    vif.cb.rd<=0;
    `uvm_info("REG_READ",$sformatf("[DRVR %2d] Register Read operation ended",obj_id), UVM_MEDIUM);    
endtask: read_dut_csr

task driver::drive_stimulus(input packet pkt);
    @(vif.cb);
    `uvm_info($sformatf("Drvr %2d",obj_id),$sformatf("Driving of packet %0d (Size = %0d) started",no_of_pkts_recvd,pkt.len), UVM_MEDIUM);
    vif.cb.sa_valid[obj_id]<=1;
    foreach(pkt.tot_pkt[i])
    begin
        vif.cb.sa[obj_id]<=pkt.tot_pkt[i];
        @(vif.cb);
    end
    `uvm_info($sformatf("Drvr %2d",obj_id),$sformatf("Driving of packet %0d (Size = %0d) [SA(%0d) -> DA(%0d)] Ended",no_of_pkts_recvd,pkt.len,pkt.sa,pkt.da), UVM_MEDIUM);
    vif.cb.sa_valid[obj_id]<=0;
    vif.cb.sa[obj_id]<='z;
    repeat(5)@(vif.cb);
    `uvm_info($sformatf("Drvr %2d",obj_id),"DRIVE Operation ENDED .....XxXxX", UVM_FULL)
endtask: drive_stimulus
