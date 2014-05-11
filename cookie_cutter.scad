// Cookie cutter generator
// Pau Fernández <pauek@minidosis.org>
// GNU GPL v2

module dxf(file, layer, height) {
   orig = dxf_cross(file = file, layer = layer);
   translate([-orig[0], -orig[1], 0])
      linear_extrude(height = height)
         import(file = file, layer = layer);
}

module needle(height, thin1, thin2, edge_height) {
   union() {
      cylinder(r = thin1, h = height - edge_height, $fn = 6);
      cylinder(r = thin2, h = height, $fn = 6);
   }
}

module wall(file, layer, height, thin) {
   difference() {
      minkowski() {
        dxf(file, layer, 0.01);
        cylinder(r = thin, h = height, $fn = 6);
      }
      translate([0, 0, -1]) dxf(file, layer, height + 2);
   }
}

module cutter(file, layer, height, edge_height, nozzle_diameter) {
   thin1 = nozzle_diameter * 2.4;
   thin2 = nozzle_diameter * 1.2;
   difference() {
      minkowski() {
        dxf(file, layer, 0.01);
        needle(height, thin1, thin2, edge_height);
      }
      translate([0, 0, -1]) dxf(file, layer, height + 2);
   }
}

module cookie_cutter(file, height, edge_height, nozzle_diameter) {
   union () {
      cutter(file, "cutter", height, edge_height, nozzle_diameter);
      wall(file, "outer", 1, 5);
   }
}

module cookie_cutter_join(file, height, edge_height, nozzle_diameter) {
   mirror([1, 0, 0]) union () {
      cutter(file, "cutter", height, edge_height, nozzle_diameter);
      wall(file, "outer", 1.5, 6);
      dxf(file, "join", 1.5);
   }
}
