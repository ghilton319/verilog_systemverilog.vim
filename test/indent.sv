// Code based on: https://github.com/vhda/verilog_systemverilog.vim/issues/2
class z;

    // this is a comment
    // -----------------
    typedef struct {
        real a;
        int b;
        int c;
        real d; } ts;

    ts s[];

    // if there are
    // more comments
    typedef struct {
        real a;
        int b;
        int c;
        real d;
    } ts2;

    ts2 t[];

    int unsigned cnt=0;

    function new();
        super.new();
    endfunction;

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/4
    task run_phase(uvm_phase phase);

        assert(my_seq.randomize());
        my_seq.start(low_sequencer_h);

        assert(my_seq.randomize() with {Nr==6;});
        my_seq.start(low_sequencer_h);

        assert(my_seq.randomize() with
            {Nr==6; Time==8;});
        my_seq.start(low_sequencer_h);

        assert(
            my_seq.randomize() with
            {Nr==6; Time==8;}
        );
        my_seq.start(low_sequencer_h);

        // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/5
        fork
            begin : isolating_thread
                do_something();
            end : isolating_thread
        join
        // End of copied code

    endtask
    // End of copied code

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/7
    task run_phase2(uvm_phase phase);
        assert(out>0) else $warning("xxx");
        assert(out>0) else $warning("xxx");
        foreach(out[i]) begin
            out[i]=new;
        end
    endtask
    // End of copied code

    // Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/12
    task my_seq::body();
        `uvm_info({get_type_name(),"::body"}, "something" ,UVM_HIGH)
        req = my_seq_item_REQ::type_id::create("req");
    endtask
    // End of copied code

    // Oter tests
    task fork_test;
        fork
            do_something1();
            do_something2();
        join_none // {}
        do_something3();
    endtask

    task while_one_line;
        while (1)
            do_something();
    endtask

    task while_block;
        while (1)
        begin
            do_something();
        end
    endtask

    task while_block2;
        while (1) begin
            do_something();
        end
    endtask

    function old_style_function_with_var(
        input a
    );
    reg test;
    begin 
        do_something1();
        do_something2();
        begin
            do_something3();
        end
    end
    endfunction

    function old_style_function_without_var(
        input a
    );
    begin
        do_something1();
        do_something2();
        begin
            do_something3();
        end
    end
    endfunction

    //function old_style_function_with_var(
    //    input a
    //);
    //reg test;
    //begin 
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    //function old_style_function_without_var(
    //    input a
    //);
    //begin
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    //function old_style_function_one_line_with_var(input a);
    //    reg x;
    //begin
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    //function old_style_function_one_line_without_var(input a);
    //begin
    //    do_something1();
    //    do_something2();
    //    begin
    //        do_something3();
    //    end
    //end
    //endfunction

    function unique_priority_if void (input int a);
        unique if (a==3)
            do_something1();
        else begin
            doe_something2();
        end
        unique0 if (a inside {[10:20]})
        begin
            do_something3();
        end
        priority if (a==3) do_something1();
        else if (a inside {[10:20]}) do_something2();
        else do_something3();

    endfunction

    function unique_priority_case void (input int a);
        unique case (a)
            3:
                do_something1();
            default:
                doe_something2();
        endcase
        unique0 case (a) inside
            [10:20] :
                do_something3();
        endcase
        priority case(1'b1)
            (a==3) : do_something1();
            (a inside {[10:20]}) : do_something2();
            default : do_something3();
        endcase
    endfunction

    // Zero or more method_qualifier :: IEEE1800-2012 A.1.9 Class items
    protected virtual function protected_virtual_func void (input a);
    endfunction
    virtual protected task virtual_protected_task (input a);
    endtask

endclass

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/14
virtual class base;

    extern function void x(input int unsigned N, ref t Data);
    extern function void y(input int unsigned N, ref t Data);

    function old_style_function_one_line_without_var(input a);
    begin
        do_something1();
        do_something2();
        begin
            do_something3();
        end
    end
    endfunction

endclass

module m (
    portA,
    portB
);

device d0 (
    .port (port[1]),
    .port2(), // comment
    .portA(port[2])
);

// Code from: https://github.com/vhda/verilog_systemverilog.vim/issues/6
device d1 (
    .port (port[1]),
    // .port2(), // comment
    .*
);
// End of copied code

device d1 (
    .port (port[1]),
    // .port1(), comment
    /**/.port2(), // comment
    /*.port3(), */   
    // .port4(), comment
    .portA(port[2])
);

`ifdef V95
    device d2 ( out, portA, portB );
`elsif V2K
    device d2 ( .out(out), .* );
`endif
`ifndef SWAP
    device d3 ( .out(out), .* );
`else
    device d3 ( .out(out), .portA(portB), .portB(portA) );
`endif

endmodule

module m2(interface ifc);
logic drive_busy, next_drive_busy;
always_comb begin
    ifc.next = ifc.current;
    unique case(1'b1)
        ifc.current==IDLE : if (ifc.start) ifc.next = START;
        ifc.current==START : begin
            priority if (~ifc.rst_n) ifc.next = IDLE;
            else if (~ifc.busy_n) ifc.next = RUN;
        end
        ifc.current==RUN: begin
            next_drive_busy = 1'b1;
            if (ifc.stop) ifc.next = STOP;
        end
        ifc.current==STOP: begin
            unique0 if (~ifc.rest_n) begin
                ifc.next = IDLE;
            end
            else if (ifc.start) ifc.next = RUN;
        end
    endcase
end

for(genvar i=$right(ifc.bus);i<$left(ifc.bus);i=i*(i+1)) begi
    always_comb if(i%2==1) ifc.bus[i+:i] ifc.bus2[i-:i];
    always_comb if(i%2==0) ifc.bus3[i-:i] ifc.bus[i+:i];
end

endmodule

// vim: set sts=4 sw=4 nofen:
