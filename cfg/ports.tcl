### create clk
create_bd_port -dir I clk_i

### LED
create_bd_port -dir O -from 3 -to 0 led_o

###RGB LED
create_bd_port -dir O -from 2 -to 0 ledRGB_o

### PMOD
create_bd_port -dir IO -from 7 -to 0 pmod_a_tri_io
create_bd_port -dir IO -from 7 -to 0 pmod_b_tri_io

### BUTTONS
create_bd_port -dir I -from 4 -to 0 pl_buttons

### SWITCHES
create_bd_port -dir I -from 3 -to 0 pl_switches

## Audio CODEC I2S, I2C
create_bd_port -dir I aud_adc_sdata
create_bd_port -dir O aud_bclk
create_bd_port -dir O aud_dac_sdata
create_bd_port -dir O aud_lrclk
create_bd_port -dir O aud_mclk

## DP
create_bd_port -dir I dp_aux_din
create_bd_port -dir O -from 0 -to 0 dp_aux_doe
create_bd_port -dir O dp_aux_dout
create_bd_port -dir I dp_aux_hotplug_detect

## VADJ
create_bd_port -dir O -from 0 -to 0 vadj_auton
create_bd_port -dir O -from 0 -to 0 vadj_level_0
create_bd_port -dir O -from 0 -to 0 vadj_level_1 

### GZU ZMOD A
### FMC2ZMOD A
### FMC2ZMOD B
