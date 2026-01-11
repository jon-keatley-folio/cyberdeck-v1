include <utils.scad>
//--- variables ----------------------------------------------------------------

$fn=128;

//connectors
//M2.5x4x3.5mm <-- need to match the smaller side of the insert
m2p5_insert = half(3.2);
m2p5_depth = 5;
m2p6_screw = half(2.4);
stand_radius = m2p5_insert * 2.2;
stand_insert_radius = m2p5_insert + 0.2;

//screen wider than my print bed!
screen_width = 26 * 10;
screen_height = 12 * 10;
screen_trim_v = 5.5;
screen_trim_h = 9.5;

screen_depth = 16;
screen_glass_depth = 1;
screen_back_depth = 7;
screen_stands = screen_depth - screen_glass_depth;

sw_mt = screen_width - (screen_trim_h * 2);
sh_mt = screen_height - (screen_trim_v * 2);

//screen brace
b_bof = 11;
t_bof = 8.3;
brace_points = [
	[half(sw_mt) - 4,half(sh_mt) + t_bof, -half(screen_back_depth) - 2],
	[half(sw_mt) - 4 ,-half(sh_mt) - b_bof, -half(screen_back_depth) - 2],
	[-half(sw_mt) + 4 ,-half(sh_mt) - b_bof, -half(screen_back_depth) - 2],
	[-half(sw_mt) + 4,half(sh_mt) + t_bof, -half(screen_back_depth) - 2],
];

//screen wedge - used to attach sections of the screen together
screen_wedge = [10,6,10];

//connector rods - also used to attach sections of the screen together
rod_width = 14;
rod_radius = half(1.6);

//screen control panel pcb details
sp_pcb_width = 69;
sp_pcb_height = 7.5;
sp_pcb_btn_depth = 6;
sp_pcb_port_depth = 7.3;
sp_pcb_port_width = 16.51;
sp_pcb_port_offset = -1.001;
sp_pcb = [sp_pcb_width + 2, sp_pcb_height, sp_pcb_btn_depth + 2];
sp_buttons = 5;
sp_btn_width = sp_pcb_width / sp_buttons;
sp_btn_height = sp_pcb_height * 1.5;

//screen control panel details
screen_panel_height = double(sp_pcb_height) + 5;
panel_hole = half(2.5);

//hinge
hinge_offset = 70;
hinge_tw = 30;
hinge_bolt = half(2.5);

//keyboard
keyboard_width = 288;
keyboard_height =  125;

//case
case_width = pad(max(screen_width,keyboard_width));
case_height = pad(screen_height + screen_panel_height + 15);
case_height_without_panel = case_height - screen_panel_height;

case_depth = screen_depth + 4;

//screen mount points
side_wall_offset = -half(screen_stands) - 2;
mount_offset_t = 7;
mount_offset_b = -4;
mount_offset_h = 8;
screen_points = [
	[-half(case_width) + mount_offset_h, -half(case_height) + mount_offset_b, side_wall_offset],
	[half(case_width) - mount_offset_h, -half(case_height) + mount_offset_b, side_wall_offset],
	[-half(case_width) + mount_offset_h, half(case_height_without_panel) - mount_offset_t, side_wall_offset],
	[half(case_width) - mount_offset_h, half(case_height_without_panel) - mount_offset_t, side_wall_offset],
	[0, -half(case_height) + mount_offset_b + 17, side_wall_offset],
	[0, half(case_height_without_panel) - (mount_offset_t - 1.2), side_wall_offset],
];

//screen back panel thickness
screen_back_panel_thickness = 4;
