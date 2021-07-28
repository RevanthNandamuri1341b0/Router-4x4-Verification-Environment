//  Class: reset_sequence
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
