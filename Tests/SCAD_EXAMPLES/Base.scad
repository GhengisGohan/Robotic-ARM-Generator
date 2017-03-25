
module base(tick, B, D, F) {
    // Inside is equal to servo dimensions plus tick
    // Extra space
    Extra= 1.5;
    B=B+tick*2+(Extra*2);
    D=D+tick*2+(Extra*2);
    F=F+tick;
    
    union() {
        difference() {
            cube([B,D,F]);
            // Z
            translate([tick,tick,tick]) cube([B-(tick*2),D-(tick*2),F]);
            // X
            translate([-1,tick,tick]) cube([B+2,D-(tick*2),F/2-tick]);
            // Y
            translate([tick,tick,tick]) cube([B-(tick*2),D-(tick*2),F-(tick*2)]);  
        }
    
     // Legs
    translate([B/2-B/8,-B*2+D,0]) cube([B/4,B*4-D,tick]);
    translate([-B*2+B/2,D/2-D/4,0]) cube([B*4,B/4,tick]);
    }
   
}


base(1.5, 41, 20, 26, 20);