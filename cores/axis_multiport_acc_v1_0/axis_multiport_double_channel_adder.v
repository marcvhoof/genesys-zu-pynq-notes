
`timescale 1 ns / 1 ps

module axis_multiport_double_channel_adder #
(
  parameter integer AXIS_TDATA_PORT_WIDTH = 32,
  parameter integer AXIS_TDATA_ACC_WIDTH = 64,
  parameter         AXIS_TDATA_SIGNED = "FALSE"
)
(
  // System signals
  input  wire                        aclk,

  // Slave side
  output wire                             s_axis_0_tready,
  input  wire [AXIS_TDATA_PORT_WIDTH-1:0] s_axis_0_tdata,
  input  wire                             s_axis_0_tvalid,
  input  wire                             s_axis_0_tlast,

  output wire                             s_axis_1_tready,
  input  wire [AXIS_TDATA_PORT_WIDTH-1:0] s_axis_1_tdata,
  input  wire                             s_axis_1_tvalid,
  input  wire                             s_axis_1_tlast,

  output wire                             s_axis_2_tready,
  input  wire [AXIS_TDATA_PORT_WIDTH-1:0] s_axis_2_tdata,
  input  wire                             s_axis_2_tvalid,
  input  wire                             s_axis_2_tlast,

  output wire                             s_axis_accin_tready,
  input  wire [AXIS_TDATA_ACC_WIDTH-1:0]  s_axis_accin_tdata,
  input  wire                             s_axis_accin_tvalid,
  input  wire                             s_axis_accin_tlast,

  // Master side
  input  wire                                m_axis_tready,
  output wire [AXIS_TDATA_ACC_WIDTH-1:0]     m_axis_tdata,
  output wire                                m_axis_tvalid,
  output wire                                m_axis_tlast
);

  wire [AXIS_TDATA_ACC_WIDTH-1:0] int_tdata_wire;
  wire int_tready_wire, int_tvalid_wire, int_tlast_wire;

  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_0a_tdata;
  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_0b_tdata; 
  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_1a_tdata; 
  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_1b_tdata; 
  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_2a_tdata; 
  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_2b_tdata; 
  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_accina_tdata; 
  wire  signed [AXIS_TDATA_PORT_WIDTH-1:0] reg_axis_accinb_tdata; 

  assign reg_axis_0a_tdata = $signed(s_axis_0_tdata[AXIS_TDATA_PORT_WIDTH/2-1:0]);
  assign reg_axis_0b_tdata = $signed(s_axis_0_tdata[AXIS_TDATA_PORT_WIDTH-1:AXIS_TDATA_PORT_WIDTH/2]);
  assign reg_axis_1a_tdata = $signed(s_axis_1_tdata[AXIS_TDATA_PORT_WIDTH/2-1:0]);
  assign reg_axis_1b_tdata = $signed(s_axis_1_tdata[AXIS_TDATA_PORT_WIDTH-1:AXIS_TDATA_PORT_WIDTH/2]);
  assign reg_axis_2a_tdata = $signed(s_axis_2_tdata[AXIS_TDATA_PORT_WIDTH/2-1:0]);
  assign reg_axis_2b_tdata = $signed(s_axis_2_tdata[AXIS_TDATA_PORT_WIDTH-1:AXIS_TDATA_PORT_WIDTH/2]);
  assign reg_axis_accina_tdata = $signed(s_axis_accin_tdata[AXIS_TDATA_ACC_WIDTH/2-1:0]);
  assign reg_axis_accinb_tdata = $signed(s_axis_accin_tdata[AXIS_TDATA_ACC_WIDTH-1:AXIS_TDATA_ACC_WIDTH/2]);
  
  generate
    if(AXIS_TDATA_SIGNED == "TRUE")
    begin : SIGNED
      wire signed [AXIS_TDATA_PORT_WIDTH-1:0] int_tdata_a_wire;
      wire signed [AXIS_TDATA_PORT_WIDTH-1:0] int_tdata_b_wire;
      assign int_tdata_a_wire = reg_axis_0a_tdata + reg_axis_1a_tdata + reg_axis_2a_tdata + reg_axis_accina_tdata;
      assign int_tdata_b_wire = reg_axis_0b_tdata + reg_axis_1b_tdata + reg_axis_2b_tdata + reg_axis_accinb_tdata;
      assign int_tdata_wire = {int_tdata_b_wire, int_tdata_a_wire};
    end
    else
    begin : UNSIGNED
      wire [AXIS_TDATA_PORT_WIDTH-1:0] int_tdata_a_wire;
      wire [AXIS_TDATA_PORT_WIDTH-1:0] int_tdata_b_wire;
      assign int_tdata_a_wire = reg_axis_0a_tdata + reg_axis_1a_tdata + reg_axis_2a_tdata + reg_axis_accina_tdata;
      assign int_tdata_b_wire = reg_axis_0b_tdata + reg_axis_1b_tdata + reg_axis_2b_tdata + reg_axis_accinb_tdata;
      assign int_tdata_wire = {int_tdata_b_wire, int_tdata_a_wire};
    end
  endgenerate

  assign int_tvalid_wire = s_axis_0_tvalid & s_axis_1_tvalid & s_axis_2_tvalid & s_axis_accin_tvalid;
  assign int_tlast_wire = s_axis_0_tlast & s_axis_1_tlast & s_axis_2_tlast & s_axis_accin_tlast;
  assign int_tready_wire = int_tvalid_wire & m_axis_tready;

  assign s_axis_0_tready = int_tready_wire;
  assign s_axis_1_tready = int_tready_wire;
  assign s_axis_2_tready = int_tready_wire;
  assign s_axis_accin_tready = int_tready_wire;
  assign m_axis_tdata = int_tdata_wire;
  assign m_axis_tvalid = int_tvalid_wire;
  assign m_axis_tlast = int_tvalid_wire;

endmodule
