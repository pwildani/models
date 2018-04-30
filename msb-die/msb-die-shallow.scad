// units: mm

size = 18;
margin = size/5;
imagesize = size - (margin*2);
imprint = .5;
overage = 0.001;
fillet = .9;
face_roundness=1;

dog_paw_stl = ADD_ME;



module letter(letter, aspect_ratio=1) {
    offset(r=fillet)
        resize([imagesize, imagesize*aspect_ratio, 0], auto=true)
            text(letter, halign="center", valign="center");
}

module image2dfrom3d(filename, convexity=10, aspect_ratio=1) {
    projection()
    translate([-imagesize/2, -imagesize/2, 0])
    resize([imagesize, imagesize, 0])
    import(filename, convexity=6);
}
        
module bare_die() {
    intersection() {
        sphere(r=size/(sqrt(2)*face_roundness), center=true);
        cube(size, center=true);
    };
}


module side() {
    linear_extrude(imprint)
        resize([imagesize, imagesize, 0], auto=true)
                children();
    
}

module imprinted_die() {
    
    difference() {
        bare_die();
        
        // X Faces
        translate([-size/2 - overage, 0, 0])
          rotate([0, 90, 0]) side() mirror([1, 1, 0]) children(0); 
        translate([size/2 + overage, 0, 0])
          rotate([0, -90, 0]) rotate([0, 0, 90]) side() mirror([0, 1, 0]) children(1);
        
        // Y Faces
        translate([0, size/2 + overage, 0])
            rotate([90, 0, 0]) side() mirror() children(2);
        translate([0, -size/2 - overage + imprint])
            rotate([90, 0, 0]) side() children(3);
        
        // Z Faces
        translate([0, 0, size/2 + overage - imprint])
            rotate([0, 0, 0]) side() children(4);    
        translate([0, 0, -size/2 - overage + imprint])
            rotate([180, 0, 0]) side() mirror([1, 0, 1]) children(5);
    }
}

module blank() { }    
module S() { letter("S"); }
module M() { letter("M"); }
module D() { image2dfrom3d(dog_paw_stl); }


imprinted_die() { 
    
    // X Faces
    S();
    S();
    
    // Y Faces
    M();
    M();
    
    // Z Faces
    D();
    D();
}

