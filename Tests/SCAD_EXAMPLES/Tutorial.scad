module base (off, length, baseLen, tick, width) {
    translate([off,0,0]){
        cube([tick, length, width]);
    }
    translate([0,length,0]){
        cube([baseLen,tick,width]);
    }
}

module humerus (off, length, tick, width) {
    translate([off,0,0]){
        cube([width,length,tick]);
    }
}

module ulna (off, length, tick, width) {
    translate([off,0,0]){
        cube([width,length,tick]);
    }
}

module wrist (off, length, baseLen, tick, width) {
    translate([off,0,0]){
        cube([tick, length, width]);
    }
    translate([off,length,0]){
        cube([baseLen,tick,width]);
    }
}



base(0, 10, 5, 0.5, 2);
humerus(5+2, 11, 0.5, 2);
ulna(5+2+2+2, 10, 0.5, 2);
wrist(15, 10, 5, 0.5, 2);




