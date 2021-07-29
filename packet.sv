/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:11
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Stimulus file
File Name : packet.sv
*File ID : 762141
*Modified by : #your name#
*/

class packet extends uvm_sequence_item;
    rand bit [7:0] sa;
    rand bit [7:0] da;
    bit [31:0] len;
    bit [31:0] crc;
    rand bit[7:0] payload[];

    bit[7:0] tot_pkt[$];
    byte unsigned pack_arr[];
    
    pkt_type_t mode;
    bit[7:0] reset_cycles;

    bit[7:0] addr;      //control register signals
    logic[31:0] data;   //control register signals

    constraint valid_sa
    {
        sa inside{[1:4]};    
    }

    constraint valid_da
    {
        da inside{[1:4]};    
    }

    constraint valid_payload
    {
        // payload.size() inside {[1:1900]};
        payload.size()==5;
        foreach(payload[i]) payload[i] inside {[0:255]};
    }
    
    function void post_randomize();
        len=payload.size()+1+1+4+4;
        crc=payload.sum();
        uvm_default_packer.big_endian=0;
        void'(pack_bytes(pack_arr));
        tot_pkt=pack_arr;
        $display("tot_pkt=%p",tot_pkt);
        $display("pack_arr=%p",pack_arr);
    endfunction: post_randomize
    
    `uvm_object_utils_begin(packet)
        `uvm_field_int(sa,UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
        `uvm_field_int(da,UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
        `uvm_field_int(len,UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
        `uvm_field_int(crc,UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
        `uvm_field_array_int(payload,UVM_ALL_ON | UVM_NOCOMPARE)
        `uvm_field_queue_int(tot_pkt,UVM_ALL_ON | UVM_NOCOMPARE | UVM_NOPACK | UVM_NOPRINT)
    `uvm_object_utils_end
    
    virtual function string convert2string();
        return $sformatf("SA = %0d DA = %0d Len = %0d",sa,da,tot_pkt.size());
    endfunction

    function new(string name = "packet");
        super.new(name);
    endfunction: new
    
    extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    

endclass: packet


function bit packet::do_compare(uvm_object rhs , uvm_comparer comparer);
    packet pkt;
    bit status;
    if (!$cast(pkt,rhs)) 
    begin
        `uvm_fatal("CAST","do_compare casting failed \n");        
    end
    if(this.tot_pkt.size()==pkt.tot_pkt.size())
    begin
        foreach(pkt.tot_pkt[i])
        begin
            if (this.tot_pkt[i]==pkt.tot_pkt[i])    status = 1;
            else                                    return 0;
        end
    end
    else return 0;
    return status;
endfunction: do_compare
