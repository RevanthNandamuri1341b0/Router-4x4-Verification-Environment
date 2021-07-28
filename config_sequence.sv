//  Class: config_sequence
//
class config_sequence extends uvm_sequence#(packet);
    `uvm_object_utils(config_sequence);

    function new(string name = "config_sequence");
        super.new(name);
        set_automatic_phase_objection(1);//uvm 1.2
    endfunction: new
    extern virtual task body();

endclass: config_sequence
task config_sequence::body();
    `uvm_create(req);
    req.mode=CSR_WRITE;
    req.addr=8'h20;
    req.data=8'b0000_1111;
    start_item(req);
    finish_item(req);

    `uvm_create(req);
    req.mode=CSR_WRITE;
    req.addr=8'h24;
    req.data=8'b0000_1111;
    start_item(req);
    finish_item(req);
endtask: body
