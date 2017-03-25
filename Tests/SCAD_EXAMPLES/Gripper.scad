
module cage(tick, B, D, F, objectLen) {
    // Inside is equal to size plus tick
    B=B+tick*2;
    D=D+tick*2;
    F=F+tick*2;
    holderSpace = (objectLen - B)/2;
	difference() {
		union() {
			cube([B,D,F]);
            // For conecting grippers
            translate([-holderSpace,-tick*2,F-tick]) cube([B+(holderSpace*2),D+(tick*4),tick]);
		}
        // Z
		translate([tick,tick,tick]) cube([B-(tick*2),D-(tick*2),F]);
        // X
		translate([-1,tick,tick]) cube([B+2,D-(tick*2),F/2-tick]);
        //translate([B/2,0,D/2]) rotate([-90,0,0]) cylinder(r=B/2,h=D, $fn=45);
        // Y
		translate([tick,tick,tick]) cube([B-(tick*2),D-(tick*2),F-(tick*2)]);
	}
   
}



module gripper(tick, A, D, F, objectLen) {
    
    // Basic Info
    gearSpace = A - F;
    gripperLen = objectLen;
    
    // Starts and Lengths
    extraSpaceStart = gripperLen + tick;
    extraSpaceLen = gearSpace + gearSpace/4.0;
    holdersStart = extraSpaceStart+extraSpaceLen+tick;
    holdersLen = tick+0.5;
    TotalLen = holdersStart + holdersLen + tick;
    
    // Width and heigth
    heigth = tick*4;
    width = D + (tick*6);
    
    // A small hole
    holeStart = extraSpaceStart +  gearSpace/2;
    
	difference() {
		cube([TotalLen,width,heigth]);
		translate([extraSpaceStart,tick,-0.1]) cube([extraSpaceLen,width- (tick*2),heigth+1]);
        translate([extraSpaceStart,tick*2,-0.1]) cube([TotalLen-extraSpaceStart+ 0.1,width-(tick*4),heigth+1]);
        translate([holdersStart,tick,-0.1]) cube([holdersLen, width-(tick*2), heigth+1]);
        translate([-0.1,-0.1,-0.1]) cube([gripperLen, width/3+(0.1), heigth+1]);
		translate([-0.1,width-(width/3)+(0.1),-0.1]) cube([gripperLen, width/3, heigth+1]);
        
        // A small hole
		translate([holeStart,-0.1,heigth/2]) cube([tick,tick+0.2,tick]);
		//translate([23.5,-0.1,2]) cube([3.9,2.5,4.4]);
	}

}


cage(1.5, 41, 20, 26, 20);
*gripper(1.5, 25, 10, 12, 10);