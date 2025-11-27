/*
style

clam shell design with a oversized two point hinge and a built in handle

pc and batteries are external bolted to the outside of the shell

this allows maximum access / cooling etc

*/

function double(x) = x * 2;
function half(x) = x / 2;
function pad(x) = x + 2;

//connectors
//M3x4x5mm
m3_insert = half(4.5);
m3_depth = 5;
stand_radius = m3_insert * 1.5;
stand_insert_radius = m3_insert - 0.5;

//screen wider than my print bed!
screen_width = 26 * 10;
screen_height = 12 * 10;
screen_trim_v = 5.5;
screen_trim_h = 9.5;

screen_depth = 16;
screen_glass_depth = 1;
screen_stands = screen_depth - screen_glass_depth;

sw_mt = screen_width - (screen_trim_h * 2);
sh_mt = screen_height - (screen_trim_v * 2);

//screen pad
sp_pcb_width = 68;
sp_pcb_height = 7.5;
sp_pcb_btn_depth = 6;
sp_pcb_port_depth = 6;
sp_buttons = 5;
sp_btn_width = sp_pcb_width / sp_buttons;

//panel
screen_panel_height = double(sp_pcb_height) + 5;

//keyboard
keyboard_width = 288;
keyboard_height =  125;

case_width = pad(max(screen_width,keyboard_width));
case_height = pad(max(screen_height, keyboard_height));



//screen case

module screen_front()
{
	//panel
	difference()
	{
		cube([case_width,case_height,4],center=true);
		cube([sw_mt,sh_mt,5],center=true);
		
		translate([0,0,-1.6])
		cube([screen_width,screen_height,screen_glass_depth],center=true);
	}
	
	//screen mount points
	mount_offset_v = 7;
	mount_offset_h = 8;
	screen_points = [
		[-half(case_width) + mount_offset_h, -half(case_height) + mount_offset_v, -half(screen_stands) - 2],
		[half(case_width) - mount_offset_h, -half(case_height) + mount_offset_v, -half(screen_stands) - 2],
		[-half(case_width) + mount_offset_h, half(case_height) - mount_offset_v, -half(screen_stands) - 2],
		[half(case_width) - mount_offset_h, half(case_height) - mount_offset_v, -half(screen_stands) - 2],
	];
	
	for(p = screen_points)
	{
		translate(p)
		difference()
		{
			cylinder(h=screen_stands,r=stand_radius,center=true);
			translate([0,0,-(half(screen_stands) - half(m3_depth))])
			cylinder(h=m3_depth + 1,r=stand_insert_radius,center=true);
		}
	}
	
	//screen panel
	translate([0,-half(screen_height + screen_panel_height),0])
	screen_panel();
	
}

module screen_panel()
{
	//screen pad
/*	sp_pcb_width = 68;
	sp_pcb_height = 7.5;
	sp_pcb_btn_depth = 6;
	sp_pcb_port_depth = 6;
	sp_buttons = 5;
	sp_btn_width = sp_pcb_width / sp_buttons;*/
	difference()
	{
		cube([case_width, screen_panel_height, 4],center=true);
		
		cube([sp_pcb_width, sp_pcb_height , 5],center=true);
	}

	translate([0,half(sp_pcb_height) + 0.5,0])
	difference()
	{
		union()
		{
			for (x = [0:sp_buttons -1])
			{
				translate([(x * sp_btn_width) - half(sp_pcb_width - sp_btn_width),-half(sp_pcb_height),0])
				cube([sp_btn_width - 0.5,sp_pcb_height,4],center=true);
			}
		}
		translate([0,-0.9,-0.4])
		cube([sp_pcb_width, 2, 4],center=true);
	}
	
	
	
	
}

module keyboard_case()
{
	difference()
	{
		cube([case_width,case_height,5],center=true);
		translate([0,0,2])
		cube([keyboard_width,keyboard_height,2],center=true);
	}
}

show_front = true;
show_back = false;

if(show_front)
{
	screen_front();
}

if(show_back)
{
	translate([0,-half(case_width),0])
	keyboard_case();
}