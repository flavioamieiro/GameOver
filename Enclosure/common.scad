$fn=100;

CUTOUT_FOR_DEBUGGING = false;

inner_width = 50;
inner_depth = 35;
inner_height = 17;

rounded_corner_radius = 3;

wall_thickness = 2;
wall_to_pcb_spacing = 1;

pcb_lip = 2;

pcb_thickness = 1.6;
pcb_length = 50;
pcb_heigth = 35;

right_side_padding = 15;

screw_center_from_pcb_edge = 3;

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



// Calculated variables

pcb_to_wall_padding = [1, 1, 1] * (2*wall_to_pcb_spacing);
inner_size = [inner_width + right_side_padding, inner_depth, inner_height] + pcb_to_wall_padding;
inner_pocket_offset = [1, 1, 1] * wall_thickness;

two_walls = (wall_thickness * 2);
outer_size = inner_size + [two_walls, two_walls, wall_thickness];

cutout_offset = wall_thickness + wall_to_pcb_spacing + pcb_lip;
cutout_size = inner_size - [(wall_to_pcb_spacing+pcb_lip)*2, (wall_to_pcb_spacing+pcb_lip)*2, -100];


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

module support_spacer() {
	inner_h = pcb_spacer_height + nut_height;
	outer_d = pcb_spacer_diameter;
	outer_h = inner_h + wall_thickness;
	inner_offset_z = (outer_h - inner_h);
	cylinder(outer_h, d=outer_d);
}
