

module gridtable(dims, bar_dims, n, bar_child=undef) {
    function default(val, default) = val == undef ? default : val;
    
    w = dims[0];
    d = dims[1];
    foot_h = default(dims[2], 20);
    bar_h = default(bar_dims[1], 2);
    bar_w = default(bar_dims[0], 2);

    
    module array(n, space) {
       for (i = [0 : n-1])
         translate([ space*i, 0, 0 ]) children(0);
    }

    module bar(length) {
        if (bar_child == undef) {
            cube([bar_w, d , bar_h]);
        } else {
            $bar_length = d;
            translate([0, d, 0])
            rotate([90,  0])
            children(0);
            
        }
    }
    
    module bars(w, d, h, n, bar_w) {
        gap = (w - (n * bar_w)) / n;
        translate([gap+bar_w, 0, 0])
        array(n-1, gap + bar_w)
            bar(d) children();
    }

    module cornerfoot() { 
        linear_extrude(height=foot_h, scale=0.6, slices=1)
            polygon(points=[[0, 0], [0, 7], [7, 0]]);
    }
    
    module centerfoot() {
        linear_extrude(height=foot_h, scale=0.6, slices=1)
          rotate([0, 0, 45]) square([7, 7], center=true);
        
    }

    module corners(w, d) {
        children();
        translate([w, 0, 0]) rotate([0, 0, 90]) children();    
        translate([0, d, 0]) rotate([0, 0, -90]) children();
        translate([w, d, 0]) rotate([0, 0, 180]) children(); 
    }
    

    module tabletop() {

        // frame
        cube([bar_w, d+bar_w, bar_h]);
        translate([w, 0, 0]) cube([bar_w, d+bar_w, bar_h]);
        translate([0, d, 0]) cube([w+bar_w, bar_w, bar_h]);
        translate([0, 0, 0]) cube([w+bar_w, bar_w, bar_h]);

        // grid
        translate([w, 0, 0]) rotate([0, 0, 90])
            bars(w=w, d=d, h=h, n=n, bar_w=bar_w) children();

        translate([0, 0, 0]) rotate([0, 0, 0])
            bars(w=d, d=w, h=h, n=n, bar_w=bar_w) children();

    }


    module feet() {
        corners(w+bar_w, d+bar_w) cornerfoot();
        
        translate([w/2+bar_w/2, d/2+bar_w/2]) {
            // patch in the missing center crossing if n is odd
            if (n/2 != ceil(n/2)) {
                gap = (w - (n * bar_w)) / n;
                translate([0, 0, bar_h/2]) {
                    cube([gap+bar_w, bar_w, bar_h], center=true);
                    rotate([0, 0, 90])
                        cube([gap+bar_w, bar_w, bar_h], center=true);
                }
            }
            
            centerfoot(w, d, h, n, bar_w);
        }

    }


    tabletop() children();
    feet();
}


gridtable([95, 95, 15], [2, 2], n=7, bar_child=0)
  linear_extrude(height=$bar_length) polygon([[0, 0], [2, 0], [1, 2]])
;




