/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:11
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Program file to run the test cases
File Name : program_router_tb.sv
*File ID : 825107
*Modified by : #your name#
*/

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