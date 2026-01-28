include <utils.scad>
include <variables.scad>

// -- Screen back panel ---------------------------------------------------------------
module screen_back()
{
    //front panel screw holes
	o = screen_back_panel_offset;
	offset_screen = [
		sum(screen_points[0],o),
		sum(screen_points[1],o),
		sum(screen_points[2],o),
		sum(screen_points[3],o),
		sum(screen_points[4],o),
		sum(screen_points[5],o)
	];
    
    //all screw holes
    all_screw_holes = concat(offset_screen, screen_holes);
    
	diff_points(pc_mount_holes)
	{
		union()
		{
			diff_points(all_screw_holes)
			{
				cube([case_width,case_height,screen_back_panel_thickness],center=true);
				
				union()
				{
					cylinder(h=half(screen_back_panel_thickness) , r=m2p5_insert);
					cylinder(h=screen_back_panel_thickness + 2, r=m2p6_screw);
				}	
			}
		}
		
		union()
		{
			cylinder(h=screen_back_panel_thickness + 2, r=m2p6_screw);
			translate([0,0,half(screen_back_panel_thickness) + 0.6])
			cylinder(h=half(screen_back_panel_thickness) , r=m2p5_insert);

		}
	}
    
    //screen mount legs
    leg_height = 5;
    slo = half(screen_back_panel_thickness + leg_height);
    screen_legs = [
        [-smx,-smy + 10,slo],
        [smx,smy + 10,slo],
        [-smx,smy + 10,slo],
        [smx,-smy + 10,slo]
    ];
    
    repeater(screen_legs)
    {
        difference()
        {
            cylinder(h=leg_height , r=stand_radius, center=true);
            cylinder(h=leg_height + 1, r=m2p6_screw, center=true);
        }
    }  
	
	computer_mount();
}

module computer_mount()
{
	
	diff_points(pc_mount_holes)
	{
		translate([0,screen_back_panel_offset[1],-half(screen_back_panel_thickness + pc_mount_z)])
		cube([pc_mount_x,pc_mount_y,pc_mount_z],center=true);
		
		color("#FF00FF")
		translate([0,0,-quarter(pc_mount_z) - 0.4])
		cylinder(h=m2p5_depth + 1,r=stand_insert_radius,center=true);
	}
}