/*
*Author : Revanth Sai Nandamuri
*GitHUB : https://github.com/RevanthNandamuri1341b0
*Date of update : 29 July 2021
*Time of update : 15:13
*Project name : Router 4x4 Verification
*Domain : UVM
*Description : Package file to import all the files in the environment
File Name : router_env_pkg.sv
*File ID : 836234
*Modified by : #your name#
*/

package router_env_pkg;
    //  Group: Typedefs
    typedef enum  {IDLE,RESET,STIMULUS,CSR_WRITE,CSR_READ} pkt_type_t;

    //  Group: Parameters
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "packet.sv"
    
    `include "reset_sequence.sv"
    `include "config_sequence.sv"
    `include "sa1_sequence.sv"
    `include "sa2_sequence.sv"
    `include "sa3_sequence.sv"
    `include "sa4_sequence.sv"

    `include "sequencer.sv"
    `include "driver.sv"
    `include "iMonitor.sv"
    `include "master_agent.sv"

    `include "oMonitor.sv"
    `include "slave_agent.sv"

    `include "coverage.sv"
    `include "scoreboard.sv"
    `include "environment.sv"

endpackage: router_env_pkg
