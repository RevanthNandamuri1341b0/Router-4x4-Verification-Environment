/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:12
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Reset stimulus file
File Name : reset_sequence.sv
*File ID : 306075
*Modified by : #your name#
*/

class reset_sequence extends uvm_sequence#(packet);
    `uvm_object_utils(reset_sequence);

    function new(string name = "reset_sequence");
        super.new(name);
        set_automatic_phase_objection(1);//uvm 1.2 onwards
    endfunction: new

    extern virtual task body();    
endclass: reset_sequence

task reset_sequence::body();
    `uvm_create(req);
    req.mode=RESET;
    req.reset_cycles=2;
    start_item(req);
    finish_item(req);
endtask: body
