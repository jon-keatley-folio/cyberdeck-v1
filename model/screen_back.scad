include <utils.scad>
include <variables.scad>

// -- Screen back panel ---------------------------------------------------------------
module screen_back()
{
    //front panel screw holes
	o = [0,10,7];
	offset_screen = [
		sum(screen_points[0],o),
		sum(screen_points[1],o),
		sum(screen_points[2],o),
		sum(screen_points[3],o),
		sum(screen_points[4],o),
		sum(screen_points[5],o)
	];
    
    //screen screw holes
    smx = half(100);
    smy = half(50);
    screen_holes = [
        sum([-smx,-smy,side_wall_offset],o),
        sum([smx,smy,side_wall_offset],o),
        sum([-smx,smy,side_wall_offset],o),
        sum([smx,-smy,side_wall_offset],o)
    ];
    
    //all screw holes
    all_screw_holes = concat(offset_screen, screen_holes);
    
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
    
    
}