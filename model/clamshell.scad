/*
style

clam shell design with a oversized two point hinge and a built in handle

pc and batteries are external bolted to the outside of the shell

this allows maximum access / cooling etc

*/

function double(x) = x * 2;
function half(x) = x / 2;
function pad(x) = x + 2;
function fault(x) = x + 0.4;

$fn=128;

//connectors
//M3x4x5mm <-- need to match the smaller side of the insert
m3_insert = half(3);
m3_depth = 5;
stand_radius = m3_insert * 2;
stand_insert_radius = m3_insert - 0.5;

//screen wider than my print bed!
screen_width = 26 * 10;
screen_height = 12 * 10;
screen_trim_v = 5.5;
screen_trim_h = 9.5;

screen_depth = 16;
screen_glass_depth = 1;
screen_back_depth = 5.6;
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
sp_btn_height = sp_pcb_height * 1.5;

//panel
screen_panel_height = double(sp_pcb_height) + 5;

//hinge
hinge_tw = 30;
hinge_bolt = half(2.5);

//keyboard
keyboard_width = 288;
keyboard_height =  125;

case_width = pad(max(screen_width,keyboard_width));
case_height = pad(screen_height + screen_panel_height + 15);

case_height_without_panel = case_height - screen_panel_height;

case_depth = screen_depth + 4;

//-- helpers -----------------------------------------------------------------------------------

module mount_points(points, height)
{
	for(p = points)
	{
		translate(p)
		difference()
		{
			cylinder(h=height,r=stand_radius,center=true);
			translate([0,0,-(half(height) - half(m3_depth))])
			cylinder(h=m3_depth + 1,r=stand_insert_radius,center=true);
		}
	}
}

module split(size,offset, splits, section)
{
	section_width = size[0] / splits;
	
	o = half(size[0] - section_width) + offset[0];
	
	difference()
	{
		children(0);
		
		for(i = [0:splits -1])
		{
			if(i != section)
			{
				translate([o - (i * section_width),offset[1],offset[2]])
				cube([section_width,size[1],size[2]],center=true);
			}
		}
	}
}

module repeater(points)
{
	for(p = points)
	{
		translate(p)
		children(0);
	}
}



//-- screen front -----------------------------------------------------------------------------

module screen_front()
{
	//panel
	difference()
	{
		color("#00FFFF")
		cube([case_width,case_height_without_panel,4],center=true);
		
		translate([0,-1,0])
		cube([sw_mt,sh_mt,5],center=true);
		
		translate([0,-1,-1.6])
		cube([fault(screen_width),fault(screen_height),screen_glass_depth],center=true);
	}
	
	//screen mount points
	mount_offset_t = 7;
	mount_offset_b = -4;
	mount_offset_h = 8;
	screen_points = [
		[-half(case_width) + mount_offset_h, -half(case_height) + mount_offset_b, -half(screen_stands) - 2],
		[half(case_width) - mount_offset_h, -half(case_height) + mount_offset_b, -half(screen_stands) - 2],
		[-half(case_width) + mount_offset_h, half(case_height_without_panel) - mount_offset_t, -half(screen_stands) - 2],
		[half(case_width) - mount_offset_h, half(case_height_without_panel) - mount_offset_t, -half(screen_stands) - 2],
	];
	mount_points(screen_points, screen_stands);
	
	//screen brace
	b_bof = 11;
	t_bof = 8;
	brace_points = [
		[-half(sw_mt) + 4 ,-half(sh_mt) - b_bof, -half(screen_back_depth) - 2],
		[half(sw_mt) - 4,half(sh_mt) + t_bof, -half(screen_back_depth) - 2],
		[half(sw_mt) - 4 ,-half(sh_mt) - b_bof, -half(screen_back_depth) - 2],
		[-half(sw_mt) + 4,half(sh_mt) + t_bof, -half(screen_back_depth) - 2]
	];
	mount_points(brace_points, screen_back_depth);
    
    //vertical bars
    bar_height = case_height - 30;
    translate([screen_points[0][0] - 3,-10,-half(screen_stands) -2])
    cube([10,bar_height,screen_stands],center=true);
    
    translate([screen_points[1][0] + 3,-10,-half(screen_stands)-2])
    cube([10,bar_height,screen_stands],center=true);
    
    //corner sections
    corner_size = 20;
    panel_size = 2;
    corners = [
        [[-half(case_width-corner_size),half(case_height)-corner_size,-half(screen_stands) - 2],
        [panel_size,-panel_size]],
        [[half(case_width-corner_size),half(case_height)-corner_size,-half(screen_stands) - 2],
        [-panel_size,-panel_size]],
        [[-half(case_width-corner_size),-half(case_height),-half(screen_stands) - 2],
        [panel_size,panel_size]],
        [[half(case_width-corner_size),-half(case_height),-half(screen_stands) -2],[-panel_size,panel_size]]
    ];
    for(c = corners)
    {
        translate(c[0])
        difference()
        {
            cube([corner_size,corner_size,screen_stands],center=true);
            translate([c[1][0],c[1][1],0])
            cube([corner_size,corner_size,screen_stands + 1],center=true);
        }
    }
    
    //top and bottom panel stands <- turn into an object with holes and renforcements
    //top
    translate([0,half(case_height_without_panel - panel_size),-half(screen_stands)])
    cube([60,panel_size,screen_stands],center=true);
    
    //bottom
    translate([0,-half(case_height + screen_panel_height - panel_size),-half(screen_stands)])
    cube([100,panel_size,screen_stands],center=true);
	
	//hinge brackets
	hinge_points = [
	[50,-half(case_height + screen_panel_height - 20),-half(screen_stands)],
	[50 + hinge_tw,-half(case_height + screen_panel_height - 20),-half(screen_stands)],
	[-50,-half(case_height + screen_panel_height - 20),-half(screen_stands)],
	[-50 - hinge_tw,-half(case_height + screen_panel_height - 20),-half(screen_stands)],
	];
	
	repeater(hinge_points)
	{
		difference()
		{
			cube([panel_size,20,screen_stands],center=true);
			
			repeater([
				[0,6,-4],
				[0,-5,2],
				[0,6,2],
				[0,-5,-4]
			])
			{
				rotate([0,90,0])
				cylinder(h=panel_size + 1, r=hinge_bolt,center=true);
			}
		}
	}
	
	
	//screen panel
	translate([0,-half(case_height_without_panel + screen_panel_height),0])
	screen_panel();	
}

//--- screen panel ----------------------------------------------------------------------

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
		color("#00FFFF")
		cube([case_width, screen_panel_height, 4],center=true);
		
		cube([sp_pcb_width + 1, sp_btn_height , 5],center=true);
	}

	translate([0,half(sp_btn_height) + 0.5,0])
	difference()
	{
		union()
		{
			for (x = [0:sp_buttons -1])
			{
				translate([(x * sp_btn_width) - half(sp_pcb_width - sp_btn_width),-half(sp_btn_height),0])
				cube([sp_btn_width - 0.5,sp_btn_height,4],center=true);
			}
		}
		translate([0,-0.9,-0.4])
		cube([sp_pcb_width , 2, 4],center=true);
	}
}

// -- keyboard ------------------------------------------------------------------------

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
	//split([case_width,case_height + 2,case_depth + 2],[0,-10,-7],3,0)
	//{
		screen_front();
	//}
}

if(show_back)
{
	translate([0,-half(case_width) - 60,0])
	keyboard_case();
}

