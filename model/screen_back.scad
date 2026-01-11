// -- Screen back panel ---------------------------------------------------------------
module screen_back()
{
	o = [0,10,7];
	offset_screen = [
		sum(screen_points[0],o),
		sum(screen_points[1],o),
		sum(screen_points[2],o),
		sum(screen_points[3],o),
		sum(screen_points[4],o),
		sum(screen_points[5],o)
	];
	
	diff_points(offset_screen)
	{
		cube([case_width,case_height,screen_back_panel_thickness],center=true);
		
		union()
		{
			cylinder(h=half(screen_back_panel_thickness) , r=m2p5_insert);
			cylinder(h=screen_back_panel_thickness + 2, r=m2p6_screw);
		}
	
	}
}