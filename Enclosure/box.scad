$fn=100;

CUTOUT_FOR_DEBUGGING = false;

inner_width = 50;
inner_depth = 35;
inner_height = 17;

rounded_corner_radius = 3;

wall_thickness = 2;
wall_to_pcb_spacing = 1;
pcb_thickness = 1.6;
pcb_length = 50;
pcb_heigth = 35;
pcb_lip = 2;

right_side_padding = 15;

screw_center_from_edge = 3;
nut_height = 0;

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

pcb_to_wall_padding = [1, 1, 1] * (2*wall_to_pcb_spacing);
inner_size = [inner_width + right_side_padding, inner_depth, inner_height] + pcb_to_wall_padding;
inner_pocket_offset = [1, 1, 1] * wall_thickness;

two_walls = (wall_thickness * 2);
outer_size = inner_size + [two_walls, two_walls, wall_thickness];

cutout_offset = wall_thickness + wall_to_pcb_spacing + pcb_lip;
cutout_size = inner_size - [(wall_to_pcb_spacing+pcb_lip)*2, (wall_to_pcb_spacing+pcb_lip)*2, -100];


module main_box() {

	difference() {
		rounded_box(outer_size, radius=rounded_corner_radius);
		translate(inner_pocket_offset) rounded_box(inner_size, radius=rounded_corner_radius);
		if (CUTOUT_FOR_DEBUGGING) {
			translate([1, 1, 0] * cutout_offset) rounded_box(cutout_size, radius=rounded_corner_radius);
		};
	}
}

module support_spacer() {
	inner_h = pcb_spacer_height + nut_height;
	outer_d = pcb_spacer_diameter;
	outer_h = inner_h + wall_thickness;
	inner_offset_z = (outer_h - inner_h);
	cylinder(outer_h, d=outer_d);
}


module pcb_spacers() {
	left_x = wall_thickness + wall_to_pcb_spacing + screw_center_from_edge;
        right_x = wall_thickness + wall_to_pcb_spacing + pcb_length - screw_center_from_edge;
	bottom_y = wall_thickness + wall_to_pcb_spacing + screw_center_from_edge;
	top_y = wall_thickness + wall_to_pcb_spacing + pcb_heigth - screw_center_from_edge;

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
