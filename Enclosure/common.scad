$fn=100;

rounded_corner_radius = 3;
wall_thickness = 2;
wall_to_pcb_spacing = 1;

inner_width = 50;
inner_depth = 35;
inner_height = 17;

pcb_size = [50, 35, 1.6];

right_side_padding = 15;

screw_center_from_pcb_edge = 3;
ffc_connector_from_right_pcb_edge = 5.5;


// Calculated variables
pcb_to_wall_padding = [1, 1, 1] * (2*wall_to_pcb_spacing);
inner_size = [inner_width + right_side_padding, inner_depth, inner_height] + pcb_to_wall_padding;
inner_pocket_offset = [1, 1, 1] * wall_thickness;

left_screw_pos = [wall_thickness + wall_to_pcb_spacing + screw_center_from_pcb_edge, wall_thickness + wall_to_pcb_spacing + screw_center_from_pcb_edge, 0];

right_screw_pos = [wall_thickness + wall_to_pcb_spacing + pcb_size.x - screw_center_from_pcb_edge, wall_thickness + wall_to_pcb_spacing + pcb_size.y - screw_center_from_pcb_edge, 0];

two_walls = (wall_thickness * 2);
outer_size = inner_size + [two_walls, two_walls, wall_thickness];


// Modules
module rounded_box(size = [1, 1, 1], radius=1) {
	if (size[0] == undef) {
		size = [size, size, size];
	}

	hull() {
		translate([radius, radius, 0]) cylinder(size.z, r=radius);
		translate([size.x-radius, radius, 0]) cylinder(size.z, r=radius);
		translate([radius, size.y-radius, 0]) cylinder(size.z, r=radius);
		translate([size.x-radius, size.y-radius, 0]) cylinder(size.z, r=radius);
	}
}

module heat_set_insert_M2() {
	inner_d = 3.2;
	inner_h = pcb_spacer_height;
	outer_d = pcb_spacer_diameter;
	outer_h = inner_h + wall_thickness;
	inner_offset_z = (outer_h - inner_h);
	difference() {
		cylinder(outer_h, d=outer_d);
		translate([0, 0, inner_offset_z]) cylinder(inner_h, d=inner_d);
	}
}
