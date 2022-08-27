include <common.scad>

BOX_HAS_LOGO = true;

pcb_spacer_height = 5;
pcb_spacer_diameter = 6;
usb_support_offset = 5;

strap_cutout_size = [20, 100, 1.5];

button_hole_radius = 1;
button_center_height_from_board = 1.7;
button_1_from_left_edge = 18.8;
button_2_from_left_edge = 34.9;
button_3_from_left_edge = 40.5;

led_window_radius = 0.6;
led_window_thickness = 0.4;
led_from_left_edge = 25.3;
led_center_height_from_board = 0.5;

usb_height = 7;
usb_length = 13;
usb_z_padding = 1.5;
usb_center_from_pcb_bottom_edge = 24.65;


module main_box() {
	difference() {
		rounded_box(outer_size, radius=rounded_corner_radius);
		translate(inner_pocket_offset) rounded_box(inner_size, radius=rounded_corner_radius);
	}
}

module support_spacer() {
	inner_h = pcb_spacer_height;
	outer_d = pcb_spacer_diameter;
	outer_h = inner_h + wall_thickness;
	inner_offset_z = (outer_h - inner_h);
	cylinder(outer_h, d=outer_d);
}

module pcb_spacers() {
	translate(left_screw_pos) heat_set_insert_M2();
	translate([left_screw_pos.x+usb_support_offset, right_screw_pos.y, 0]) support_spacer();
	translate([right_screw_pos.x, left_screw_pos.y, 0]) support_spacer();
	translate(right_screw_pos) heat_set_insert_M2();
}

module strap_cutout() {
	translate([(outer_size.x / 2)-(strap_cutout_size.x/2), 0, wall_thickness]) cube(strap_cutout_size);
}

module led_window() {
	x = wall_thickness + wall_to_pcb_spacing + led_from_left_edge;
	y = outer_size.y - led_window_thickness;
	z = pcb_spacer_height + wall_thickness - led_center_height_from_board;
	cylinder_height = wall_thickness - led_window_thickness;
	translate([x, y, z]) rotate(a=90, v=[1, 0, 0]) cylinder(cylinder_height, r=led_window_radius);
}

module button_access(dist_from_left_pcb_edge) {
	x = wall_thickness + wall_to_pcb_spacing + dist_from_left_pcb_edge;
	y = outer_size.y;
	z = pcb_spacer_height + wall_thickness + pcb_size.z + button_center_height_from_board;
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
	z = wall_thickness + pcb_spacer_height - usb_height + usb_z_padding;
	translate([wall_thickness*2, y, z]) rotate(a=270, v=[0, 1, 0]) hull() {
		translate([radius, radius, 0]) cylinder(wall_thickness*2, r=radius);
		translate([radius, usb_length-radius, 0]) cylinder(wall_thickness*2, r=radius);
	}
}

module logo() {
	translate([outer_size.x-(wall_thickness/2), outer_size.y-(inner_size.y-wall_thickness), 0]) rotate([90, 0, 90]) scale([0.1, 0.1, 1]) linear_extrude(height=wall_thickness/2) import("logo.svg");
}

difference() {
	main_box();
	strap_cutout();
	button_accesses();
	led_window();
	usb_port_access();
	if (BOX_HAS_LOGO) {
		logo();
	}
}
pcb_spacers();
