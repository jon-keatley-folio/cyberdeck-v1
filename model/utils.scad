function double(x) = x * 2;
function half(x) = x / 2;
function pad(x) = x + 2;
function fault(x) = x + 0.4;
function amount(x,a) = x * a;
function quarter(x) = x / 4;
function wedge_offset(total_width, section_width, count) = half(total_width) - (section_width * count);
function sum(a,b) = [a.x + b.x, a.y + b.y, a.z + b.z];

//--- modules ----------------------------------------------------------------


module mount_points(points, height)
{
	for(p = points)
	{
		translate(p)
		difference()
		{
			cylinder(h=height,r=stand_radius,center=true);
			translate([0,0,-(half(height) - half(m2p5_depth))])
            color("#FF00FF")
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
        for(x = [0:len(points) -1])
        {
			let (index =  x + 1 < $children ? x + 1 : $children - 1)
			{
				translate(points[x])
				children(index);
			}
        }
    }  
}