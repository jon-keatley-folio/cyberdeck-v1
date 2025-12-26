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
function amount(x,a) = x * a;
function quarter(x) = x / 4;
function wedge_offset(total_width, section_width, count) = half(total_width) - (section_width * count);

$fn=128;

//connectors
//M2.5x4x3.5mm <-- need to match the smaller side of the insert
m2p5_insert = half(3);
m2p5_depth = 5;
stand_radius = m2p5_insert * 2.2;
stand_insert_radius = m2p5_insert;

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
t_bof = 8;
brace_points = [
	[half(sw_mt) - 4,half(sh_mt) + t_bof, -half(screen_back_depth) - 2],
	[half(sw_mt) - 4 ,-half(sh_mt) - b_bof, -half(screen_back_depth) - 2],
	[-half(sw_mt) + 4 ,-half(sh_mt) - b_bof, -half(screen_back_depth) - 2],
	[-half(sw_mt) + 4,half(sh_mt) + t_bof, -half(screen_back_depth) - 2]
];

//screen wedge

screen_wedge = [10,6,10];

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



//-- helpers -----------------------------------------------------------------------------------

module mount_points(points, height)
{
	for(p = points)
	{
		translate(p)
		difference()
		{
			cylinder(h=height,r=stand_radius,center=true);
			translate([0,0,-(half(height) - half(m2p5_depth))])
			cylinder(h=m2p5_depth + 1,r=stand_insert_radius,center=true);
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

module panel(points, hole_size, has_hole=false)
{
    hole = has_hole ?
        [
        half(points[0]),
        points[1] + 1,
        points[2] - amount(points[2],0.3)
    ] : [0,0,0];
    
    hs = has_hole ? hole_size : 0;
    
    difference()
    {
        cube(points, center=true);
        cube(hole,   center=true);
        
        translate([-quarter(points[0]) - 3,0,0])
        rotate([90,0,0])
        cylinder(h=points[1] + 1, r= hs,center=true);
        
        translate([quarter(points[0]) + 3,0,0])
        rotate([90,0,0])
        cylinder(h=points[1] + 1, r= hs,center=true);
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

module diff_points(points)
{
    difference()
    {
        children(0);
        echo("kids ",$children);
        for(x = [1:$children-1])
        {
            translate(points[x - 1])
            children(x);
        }
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
	side_wall_offset = -half(screen_stands) - 2;
	mount_offset_t = 7;
	mount_offset_b = -4;
	mount_offset_h = 8;
	screen_points = [
		[-half(case_width) + mount_offset_h, -half(case_height) + mount_offset_b, side_wall_offset],
		[half(case_width) - mount_offset_h, -half(case_height) + mount_offset_b, side_wall_offset],
		[-half(case_width) + mount_offset_h, half(case_height_without_panel) - mount_offset_t, side_wall_offset],
		[half(case_width) - mount_offset_h, half(case_height_without_panel) - mount_offset_t, side_wall_offset],
	];
	mount_points(screen_points, screen_stands);
	
	//screen brace
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
        [[-half(case_width-corner_size),half(case_height)-corner_size,side_wall_offset],
        [panel_size,-panel_size]],
        [[half(case_width-corner_size),half(case_height)-corner_size,side_wall_offset],
        [-panel_size,-panel_size]],
        [[-half(case_width-corner_size),-half(case_height),side_wall_offset],
        [panel_size,panel_size]],
        [[half(case_width-corner_size),-half(case_height),side_wall_offset],[-panel_size,panel_size]]
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
    
    //top side panel - need to split
    fp_yo = half(case_height_without_panel - panel_size);
    split_width = (case_width - double(corner_size)) / 3;
    
    translate([0,fp_yo,side_wall_offset])
    panel([split_width,panel_size,screen_stands]);
    
    for(p = [[-split_width,fp_yo,side_wall_offset], [split_width,fp_yo,side_wall_offset]])
    {
        translate(p)
        panel([split_width,panel_size,screen_stands],panel_hole,true);
    }

	//hinge brackets
	hinge_points = [
	[hinge_offset,-half(case_height + screen_panel_height - 20),side_wall_offset],
	[hinge_offset + hinge_tw,-half(case_height + screen_panel_height - 20),side_wall_offset],
	[-hinge_offset,-half(case_height + screen_panel_height - 20),side_wall_offset],
	[-hinge_offset - hinge_tw,-half(case_height + screen_panel_height - 20),side_wall_offset],
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
	
	bsp_width =  half(case_width) - (hinge_offset + hinge_tw + corner_size);
	bsp_offset = hinge_offset + hinge_tw + half(bsp_width);
	middle_panel_width = double(hinge_offset);
	
	//bottom center
    translate([0,-half(case_height + screen_panel_height - panel_size),side_wall_offset])
    panel([middle_panel_width,panel_size,screen_stands]);
	
	//bottom left side panel
	translate([-bsp_offset,-half(case_height + screen_panel_height - panel_size),side_wall_offset])
    panel([bsp_width,panel_size,screen_stands],panel_hole,true);
	
	//bottom right side panel
	translate([bsp_offset,-half(case_height + screen_panel_height - panel_size),side_wall_offset])
    panel([bsp_width,panel_size,screen_stands],panel_hole,true);
	
	
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

//-- screen wedge ---------------------------------------------------------------------
// A wedge shape used to attach the different sections 
module screen_wedge_insert()
{
	
	swi_p = [
		[0,0],
		[0,screen_wedge.z],
		[screen_wedge.y,0],
		[0,0]
	];
	
	rotate([-90,0,0])
	linear_extrude(screen_wedge.x,center=true)
	{
		polygon(swi_p);
	}
	
	//cube(screen_wedge,center=true);
}

//-- screen braces --------------------------------------------------------------------
// creates a long rectangle with screw holes that can been screwed to the front screen panel to hold the screen in place
module screen_brace(screw_points, offset)
{
	padding = 8;
	hole_gap = max(screw_points[0][1],screw_points[1][1]) - min(screw_points[0][1],screw_points[1][1]);
	brace_len = hole_gap + padding;
	
	translate([screw_points[0][0],-amount(padding,0.20),screw_points[0][2] - half(offset) - 1.2])
	color("#00FF00")
	difference()
	{
		cube([10,brace_len,4],center=true);
		
		for(p = screw_points)
		{
			translate([0,p[1] + amount(padding,0.20),0])
			cylinder(h=5,r=1,center=true);
		}
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
show_screen_extras = false;

if(show_front)
{
    section_index = 2;
    section_width = case_width / 3;
    wedge_offset_one = wedge_offset(case_width, section_width, 1);
    wedge_offset_two = wedge_offset(case_width, section_width, 2);
    
    joint_cubes = [
            [wedge_offset_one,-half(case_height) - amount(6,1.05), -6],
            [wedge_offset_one,half(case_height) - amount(6,2.35), -6],
            [wedge_offset_two,-half(case_height) - amount(6,1.05), -6],
            [wedge_offset_two,half(case_height) - amount(6,2.35), -6]
    ];
    
	//split([case_width,case_height + 2,case_depth + 2],[0,-10,-7],3,section_index)
	//{
        diff_points(joint_cubes)
        {
            screen_front();

            cube(screen_wedge,center=true);
            cube(screen_wedge,center=true);
            cube(screen_wedge,center=true);
            cube(screen_wedge,center=true);
        }
	//}
}

if(show_screen_extras)
{
	//screen brace bars
	//screen_brace([brace_points[0],brace_points[1]],screen_back_depth);
	//screen_brace([brace_points[2],brace_points[3]],screen_back_depth);
	screen_wedge_insert();
}

if(show_back)
{
	translate([0,-half(case_width) - 60,0])
	keyboard_case();
}

