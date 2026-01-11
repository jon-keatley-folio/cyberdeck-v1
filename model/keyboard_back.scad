// -- keyboard ------------------------------------------------------------------------

module keyboard_case_back()
{
	difference()
	{
		cube([case_width,case_height,5],center=true);
		translate([0,0,2])
		cube([keyboard_width,keyboard_height,2],center=true);
	}
}