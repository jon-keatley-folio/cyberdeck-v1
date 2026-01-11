
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

//--- screen panel pcb holder -----------------------------------------------------------
module screen_panel_holder(mod=0)
{
	pcb_holder = [sp_pcb.x + half(mod) + 2,(sp_btn_height  + 4) + half(mod),screen_stands + 2 ];
	
    //translate([0,-half(case_height_without_panel + screen_panel_height),-6.5])
	difference()
	{
		cube(pcb_holder, center=true);
		translate([0,0,half(screen_stands - sp_pcb.z) + 1.001])
		cube([pcb_holder.x + mod + 1,(sp_pcb.y + 5) - half(mod),sp_pcb.z],center=true);
		
		translate([0,0,half(screen_stands - sp_pcb.z) ])
		cube([sp_pcb.x + mod - 2,sp_pcb.y + 1,sp_pcb.z],center=true);
		
		//port hole
		translate([half(sp_pcb.x - sp_pcb_port_width) - sp_pcb_port_offset,0, -sp_pcb.z + 4 ])
		cube([sp_pcb_port_width, 4, screen_stands + 4],center=true);
	}
}

//--- screen panel ----------------------------------------------------------------------

module screen_panel()
{
	//screen pad
	show_holder=false;
	
	difference()
	{
		union()
		{
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
						cube([sp_btn_width - 0.8,sp_btn_height - 1,4],center=true);
					}
				}
				translate([0,-0.9,-0.4])
				cube([sp_pcb_width , 2, 4],center=true);
			}
		}
		translate([0, 0,-half(screen_panel_height) + 1.5])
		screen_panel_holder(1.6);
	}
	
	if(show_holder)
	{
		translate([0, 0,-half(screen_panel_height) + 1.5 ])
		screen_panel_holder();
	}
}

//-- screen wedge ---------------------------------------------------------------------
// A wedge shape used to attach the different sections 
module screen_wedge_insert()
{
	shrink = 0.4;
	swi_p = [
		[0,0],
		[0,screen_wedge.z - shrink],
		[screen_wedge.y - shrink,0],
		[0,0]
	];
	
	rotate([-90,0,0])
	linear_extrude(screen_wedge.x - shrink,center=true)
	{
		polygon(swi_p);
	}
	
	//cube(screen_wedge,center=true);
}

//-- screen braces --------------------------------------------------------------------
// creates a long rectangle with screw holes that can been screwed to the front screen panel to hold the screen in place
module screen_brace(screw_points, offset)
{
	padding = 7;
	hole_gap = max(screw_points[0][1],screw_points[1][1]) - min(screw_points[0][1],screw_points[1][1]);
	brace_len = hole_gap + padding - 4;
	
	translate([screw_points[0][0],-amount(padding,0.20),screw_points[0][2] - half(offset) - 1.2])
	color("#00FF00")
	difference()
	{
        minkowski()
        {
		cube([6,brace_len,2],center=true);
        cylinder(r=2,h=1);
        }
		
		for(p = screw_points)
		{
			translate([0,p[1] + amount(padding,0.20),0])
			cylinder(h=5,r=m2p6_screw,center=true);
		}
	}
}