include <common.scad>


module main_box() {

	difference() {
		rounded_box(outer_size, radius=rounded_corner_radius);
		translate(inner_pocket_offset) rounded_box(inner_size, radius=rounded_corner_radius);
		if (CUTOUT_FOR_DEBUGGING) {
			translate([1, 1, 0] * cutout_offset) rounded_box(cutout_size, radius=rounded_corner_radius);
		};
	}
}

module pcb_spacers() {
	left_x = wall_thickness + wall_to_pcb_spacing + screw_center_from_pcb_edge;
	right_x = wall_thickness + wall_to_pcb_spacing + pcb_length - screw_center_from_pcb_edge;
	bottom_y = wall_thickness + wall_to_pcb_spacing + screw_center_from_pcb_edge;
	top_y = wall_thickness + wall_to_pcb_spacing + pcb_heigth - screw_center_from_pcb_edge;

	translate([left_x, bottom_y, 0]) heat_set_insert_M2();
	translate([left_x+usb_support_offset, top_y, 0]) support_spacer();
	translate([right_x, bottom_y, 0]) support_spacer();
	translate([right_x, top_y, 0]) heat_set_insert_M2();
}

module strap_cutout() {
	translate([(outer_size.x / 2)-(strap_cutout_size.x/2), 0, wall_thickness]) cube(strap_cutout_size);
}

module led_window() {
	x = wall_thickness + wall_to_pcb_spacing + led_from_left_edge;
	y = outer_size.y - led_window_thickness;
	z = pcb_spacer_height + nut_height + wall_thickness - led_center_height_from_board;
	cylinder_height = wall_thickness - led_window_thickness;
	translate([x, y, z]) rotate(a=90, v=[1, 0, 0]) cylinder(cylinder_height, r=led_window_radius);
}

module button_access(dist_from_left_pcb_edge) {
	x = wall_thickness + wall_to_pcb_spacing + dist_from_left_pcb_edge;
	y = outer_size.y;
	z = pcb_spacer_height + nut_height + wall_thickness + pcb_thickness + button_center_height_from_board;
	translate([x, y, z]) rotate(a=90, v=[1, 0, 0])  cylinder(wall_thickness, r=button_hole_radius);
}

module button_accesses() {
	button_access(button_1_from_left_edge);
	button_access(button_2_from_left_edge);
	button_access(button_3_from_left_edge);
}

module usb_port_access() {
	radius = usb_height/2;
	center_y = wall_thickness + wall_to_pcb_spacing + usb_center_from_pcb_bottom_edge;
	y = center_y - (usb_length/2);
	z = wall_thickness + pcb_spacer_height + nut_height - usb_height + usb_z_padding;
	translate([wall_thickness*2, y, z]) rotate(a=270, v=[0, 1, 0]) hull() {
		translate([radius, radius, 0]) cylinder(wall_thickness*2, r=radius);
		translate([radius, usb_length-radius, 0]) cylinder(wall_thickness*2, r=radius);
	}
}

difference() {
	main_box();
	strap_cutout();
	button_accesses();
	led_window();
	usb_port_access();
}
pcb_spacers();
