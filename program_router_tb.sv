`include "router_env_pkg.sv"
program program_router_tb(router_if pif);
    import uvm_pkg::*;
    import router_env_pkg::*;

    `include "base_test.sv"

    initial 
    begin
        $timeformat(-9, 1, "ns", 10);
        uvm_config_db#(virtual router_if)::set(null, "uvm_test_top", "vif", pif);
        run_test();   
    end

endprogram //program_router_tb