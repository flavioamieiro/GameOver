include <common.scad>

LID_HAS_SCREW = false;
LID_HAS_LOGO = false;


lid_overhang = 5;
vertical_lid_wall_height = 1.5;
vertical_lid_wall_thickness = 1;

lid_outer_size = [outer_size.x, outer_size.y, wall_thickness*2];



module screw_hole() {
	inner_d = 3.2;
	inner_h = lid_outer_size.z;
	outer_d = 4.5;
	outer_h = inner_h/2;
	cylinder(inner_h, d=inner_d);
	translate([0, 0, outer_h]) cylinder(outer_h, d=outer_d);
}


module main_body() {
	opening_right_backoff = ((wall_to_pcb_spacing+wall_thickness)*2) + right_side_padding + ffc_connector_from_right_pcb_edge;
	opening_size = inner_size - [opening_right_backoff, lid_overhang, -100];
	translate([0, 0, vertical_lid_wall_height]) union() {
		difference() {
			rounded_box(lid_outer_size, radius=rounded_corner_radius);
			translate([lid_overhang, lid_overhang, 0]) rounded_box(opening_size, radius=rounded_corner_radius);
		};
	};
}


module vertical_walls() {
	out_size = lid_outer_size - [2*wall_thickness, 2*wall_thickness, -vertical_lid_wall_height];
	in_size = out_size - [2*vertical_lid_wall_thickness, 2*vertical_lid_wall_thickness, 0];
	translate([wall_thickness, wall_thickness, 0]) {
		difference() {
			rounded_box(out_size, radius=rounded_corner_radius);
			translate([vertical_lid_wall_thickness, vertical_lid_wall_thickness, 0]) rounded_box(in_size, radius=rounded_corner_radius);
		}
	}
}


module screw_opening() {
	z = vertical_lid_wall_height;
	translate([right_screw_pos.x, right_screw_pos.y, z]) screw_hole();
}


module logo() {
	translate([lid_outer_size.x, lid_outer_size.y-35, lid_outer_size.z]) rotate([0, 0, 90]) scale([0.1, 0.1, 1]) linear_extrude(height=lid_outer_size.z/2) import("logo.svg");
}


difference() {
	union() {
		main_body();
		vertical_walls();
	}
	if (LID_HAS_SCREW) {
		screw_opening();
	}
	if (LID_HAS_LOGO) {
		logo();
	}
}
