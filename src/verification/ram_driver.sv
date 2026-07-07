class ram_driver;
    mailbox #(ram_transaction) gen2drv_mbx;
    mailbox #(ram_transaction) drv2ref_mbx;
    virtual ram_if.DRV ram_vif;
    event drv_done;
    ram_transaction packet_drv;
    
    covergroup cg;
        option.per_instance = 1;
        c_address: coverpoint packet_drv.address {
            bins valid_addr = {[0:31]};
            bins oob_addr   = {[32:255]};
        }
        c_write: coverpoint packet_drv.write_enb;
        c_read:  coverpoint packet_drv.read_enb;
        c_reset: coverpoint packet_drv.reset;
        c_cross_op_addr: cross c_address, c_write, c_read;
    endgroup

    function new(mailbox #(ram_transaction) gen2drv_mbx, mailbox #(ram_transaction) drv2ref_mbx, virtual ram_if.DRV ram_vif);
        this.ram_vif = ram_vif;
        this.gen2drv_mbx = gen2drv_mbx;
        this.drv2ref_mbx = drv2ref_mbx;
        cg = new(); 
    endfunction
    
    task init_reset();
        ram_vif.DRV_cb.reset <= 0;
        #25;
        ram_vif.DRV_cb.reset <= 1;
    endtask
    
    task drv();
        forever begin
            gen2drv_mbx.get(packet_drv);
            @(ram_vif.DRV_cb);
            ram_vif.DRV_cb.reset     <= packet_drv.reset;
            ram_vif.DRV_cb.address   <= packet_drv.address;
            ram_vif.DRV_cb.write_enb <= packet_drv.write_enb;
            ram_vif.DRV_cb.read_enb  <= packet_drv.read_enb;
            ram_vif.DRV_cb.data_in   <= packet_drv.data_in;
            cg.sample(); 
            drv2ref_mbx.put(packet_drv);
            -> drv_done;
        end    
    endtask
    
    task drv_reset();
        ram_transaction reset_pkt;
        $display("[DRIVER] Executing Mid-Simulation Reset...");
        for (int i = 0; i < 2; i++) begin
            reset_pkt = new();
            reset_pkt.reset = 1'b0;   
            @(ram_vif.DRV_cb);
            ram_vif.DRV_cb.reset <= 1'b0;   
            packet_drv = reset_pkt; 
            cg.sample(); 
            drv2ref_mbx.put(reset_pkt); 
        end
        reset_pkt = new();
        reset_pkt.reset = 1'b1;    
        @(ram_vif.DRV_cb);
        ram_vif.DRV_cb.reset <= 1'b1;
        packet_drv = reset_pkt; 
        cg.sample(); 
        drv2ref_mbx.put(reset_pkt);
    endtask
endclass
