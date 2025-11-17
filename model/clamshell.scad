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
m3_insert = 4.5;

//screen wider than my print bed!
screen_width = 26 * 10;
screen_height = 12 * 10;
screen_trim_v = 5.5;
screen_trim_h = 9.5;

screen_depth = 16;

sw_mt = screen_width - (screen_trim_h * 2);
sh_mt = screen_height - (screen_trim_v * 2);

//screen pad
sp_pcb_width = 68;
sp_pcb_height = 7.5;
sp_pcb_btn_depth = 6;
sp_pcb_port_depth = 6;
sp_buttons = 5;
sp_btn_width = sp_pcb_width / sp_buttons;



//keyboard
keyboard_width = 277;
keyboard_height =  125;

case_width = pad(max(screen_width,keyboard_width));
case_height = pad(max(screen_height, keyboard_height));


//screen mount points


//screen case

module screen_front()
{
	difference()
	{
		cube([case_width,case_height,4],center=true);
		cube([sw_mt,sh_mt,5],center=true);
	}
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
	cube([sp_pcb_width, sp_pcb_height, 2],center=true);
	
	for (x = [0:sp_buttons -1])
	{
		translate([(x * sp_btn_width) - half(sp_pcb_width - sp_btn_width),-half(sp_pcb_height),2])
		cube([sp_btn_width - 1,double(sp_pcb_height),2],center=true);
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
	translate([0,-80,0])
	screen_panel();
}

if(show_back)
{
	translate([0,-half(case_width),0])
	keyboard_case();
}