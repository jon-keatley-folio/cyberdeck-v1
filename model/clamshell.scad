/*
style

clam shell design with a oversized two point hinge and a built in handle

pc and batteries are external bolted to the outside of the shell

this allows maximum access / cooling etc

*/

include <utils.scad>
include <variables.scad>
include <screen_front.scad>
include <screen_back.scad>
include <keyboard_back.scad>


// -- display elements ---------------------------------------------------------------

show_screen_front = true;
show_screen_back = true;
show_keyboard_back = true;
show_screen_extras = false;

if(show_screen_front)
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
	
	joint_rods = [
	        [wedge_offset_one,-half(case_height) - amount(6,1.05), 0.5],
			[wedge_offset_one,-half(case_height) + 18, 0.5],
            [wedge_offset_one,half(case_height) - amount(6,2.35), 0.5],
			[wedge_offset_one,half(case_height) - 22, 0.5],
            [wedge_offset_two,-half(case_height) - amount(6,1.05), 0.5],
			[wedge_offset_two,-half(case_height) + 18, 0.5],
            [wedge_offset_two,half(case_height) - amount(6,2.35), 0.5],
			[wedge_offset_two,half(case_height) - 22, 0.5]
	];
    
	difference()
	{
		union()
		{
			//split([case_width,case_height + 2,case_depth + 2],[0,-10,-7],3,section_index)
			//{
				diff_points(joint_cubes)
				{
					screen_front();
					cube(screen_wedge,center=true);
				}
			//}
		}
	
		repeater(joint_rods)
		{
			rotate([0,90,0])
			cylinder(h=rod_width,r=rod_radius,center=true);
		}
	
	}
	
	
	
}

if(show_screen_back)
{
	translate([0,-half(screen_panel_height),-screen_stands - screen_back_panel_thickness])
	screen_back();
	
}

if(show_screen_extras)
{
	//screen brace bars
	screen_brace([brace_points[0],brace_points[1]],screen_back_depth);
	screen_brace([brace_points[2],brace_points[3]],screen_back_depth);
	//screen_wedge_insert();
    
	/*translate([0,0,-half(screen_stands) + 1])
	rotate([180,0,0])
	screen_panel_holder();*/
}

if(show_keyboard_back)
{
	translate([0,-half(case_width) - 60,-screen_stands - screen_back_panel_thickness])
	keyboard_case_back();
}

