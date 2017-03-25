

union() {
	difference() {
		cube(size = [33.0000000000, 22.0000000000, 17]);
		translate(v = [5, 5, 5]) {
			cube(size = [23.0000000000, 12.0000000000, 17]);
		}
		translate(v = [-1, 5, 5]) {
			cube(size = [35.0000000000, 12.0000000000, 3.5000000000]);
		}
		translate(v = [5, 5, 5]) {
			cube(size = [23.0000000000, 12.0000000000, 7.0000000000]);
		}
	}
	translate(v = [12.3750000000, -44.0000000000, 0]) {
		cube(size = [8.2500000000, 110.0000000000, 5]);
	}
	translate(v = [-49.5000000000, 5.5000000000, 0]) {
		cube(size = [132.0000000000, 8.2500000000, 5]);
	}
}
/***********************************************
*********      SolidPython code:      **********
************************************************
 
## This program finds the required torque
## for each joint of a robotic arm. 
## Jorge Garza

import argparse
import json
import operator
import subprocess
# Numpy-stl
from stl import mesh
from mpl_toolkits import mplot3d
from matplotlib import pyplot
# SolidPython
from solid import *
from solid.utils import *


## (In mm) Average Width of material
AVG_WIDTH = 20
## (In mm) Average Thickness of materials
AVG_TICKNES = 5
## (In mm) Min Distance between Servos
## [Gripper, Wrist2, Wrist, Ulna, Humerus, Base]
AVG_MIN_SERVO_SPACE = [0,40,(40*2+AVG_TICKNES),40,40,40]
## MINIMIZE or MAXIMIZE
## This means that the program will try to make the parts large 
## where Maximize or true is indicated, and will try to use the minimum 
## servo space where Minimize or false is indicated. 
## [Gripper, Wrist2, Wrist, Ulna, Humerus, Base]
SPEC_MIN_MAX = [False, False, False, True, True, False]

#######################################
##  CALCULATE ROBOTIC ARM PARTS #######
#######################################

def find_roboticarm_sizes (arm_length, object_tolift_weight, DoF, 
							min_servo_space, spec_min_max, material_densty):

	## Tuple of arm [[Length],[Weight]]
	## Length (In mm)  of each arm extremity from pivot to pivot.	
	## Starting from gripper to base 
	## Weight (In g)  of each arm extremity	 
	## Starting from gripper to base
	arm_tuple_list = [[], []]
	LENGTH = 0
	WEIGHT = 1


	curr_alength = arm_length
	AVG_DENSITY = 1.2/1000.0	## (in g/mm^3) Average density of X material
	MIN_SERVO_SPACE = 40 		## (In mm) Min Servo space between joints. 
	GRIPPER_MUL = 1.5			## Gripper multiplier number
	material_half_weight = material_densty/1000.0 * AVG_TICKNES * AVG_WIDTH
	for x in range(1, DoF+1):
		alength = 0
		aweight = 0

		## (1DoF) Gripper 
		if (x == 1):
			## Get Volume = (weight (g) / density (g/cm^3) ) and multiply it by 2
			min_gripper = 1.5 * (((object_tolift_weight) / AVG_DENSITY)**(1/3.0))
			if (DoF == 1):
				if (curr_alength < min_gripper):
					print "Gripper may not grab the object"
				alength = curr_alength
				aweight = (material_half_weight * alength)
			else:

				if (curr_alength < min_gripper):
					print "Gripper can't accommodate servo"
					return None

				## Maximize or Minimize the joint
				if (spec_min_max[x-1] == True):
					## Maximize the length of this joint
					missing_space = 0
					missing_toMaximize = 1
					for i in range(x, DoF):
						if (spec_min_max[i] == False):
							missing_space = missing_space + min_servo_space[i]
						if (spec_min_max[i] == True):
							missing_toMaximize = missing_toMaximize + 1
					alength = ((curr_alength) - missing_space) / missing_toMaximize
				else:
					## Don't maximize this joint
					alength = min_gripper

				aweight = (material_half_weight * alength)
				curr_alength = curr_alength - alength
			arm_tuple_list[LENGTH].append(alength)
			arm_tuple_list[WEIGHT].append(aweight)

		## (2DoF) Wrist
		if (x == 2):
			min_wrist = min_servo_space[x-1]
			if (DoF == 2):
				if (curr_alength < min_wrist):
					print "Wrist may not accommodate servo"
				alength = curr_alength
				aweight = (material_half_weight * alength)
			else:
				if (curr_alength < min_wrist):
					print "Wrist can't accommodate servo"
					return None

				## Maximize or Minimize the joint
				if (spec_min_max[x-1] == True):
					## Maximize the length of this joint
					missing_space = 0
					missing_toMaximize = 1
					for i in range(x, DoF):
						if (spec_min_max[i] == False):
							missing_space = missing_space + min_servo_space[i]
						if (spec_min_max[i] == True):
							missing_toMaximize = missing_toMaximize + 1
					alength = ((curr_alength) - missing_space) / missing_toMaximize
				else:
					## Don't maximize this joint
					alength = min_wrist

				aweight = (material_half_weight * alength)
				curr_alength = curr_alength - alength
			arm_tuple_list[LENGTH].append(alength)
			arm_tuple_list[WEIGHT].append(aweight)

		## (3DoF) Wrist 2
		if (x == 3):
			min_wristtwo = min_servo_space[x-1]
			if (DoF == 2):
				if (curr_alength < min_wristtwo):
					print "Wrist may not accommodate servo"
				alength = curr_alength
				aweight = (material_half_weight * alength)
			else:
				if (curr_alength < min_wristtwo):
					print "Wrist can't accommodate servo"
					break;

				## Maximize or Minimize the joint
				if (spec_min_max[x-1] == True):
					## Maximize the length of this joint
					missing_space = 0
					missing_toMaximize = 1
					for i in range(x, DoF):
						if (spec_min_max[i] == False):
							missing_space = missing_space + min_servo_space[i]
						if (spec_min_max[i] == True):
							missing_toMaximize = missing_toMaximize + 1
					alength = ((curr_alength) - missing_space) / missing_toMaximize
				else:
					## Don't maximize this joint
					alength = min_wristtwo

				aweight = (material_half_weight * alength)
				curr_alength = curr_alength - alength
			arm_tuple_list[LENGTH].append(alength)
			arm_tuple_list[WEIGHT].append(aweight)

		## (4DoF) Ulna
		if (x == 4):
			min_ulna = min_servo_space[x-1]
			if (DoF == 4):
				if (curr_alength < min_ulna):
					print "Ulna may not accommodate servo"
				alength = curr_alength
				aweight = (material_half_weight * alength)
			else:
				if (curr_alength < min_ulna):
					print "Ulna can't accommodate servo"
					return None

				## Maximize or Minimize the joint
				if (spec_min_max[x-1] == True):
					## Maximize the length of this joint
					missing_space = 0
					missing_toMaximize = 1
					for i in range(x, DoF):
						if (spec_min_max[i] == False):
							missing_space = missing_space + min_servo_space[i]
						if (spec_min_max[i] == True):
							missing_toMaximize = missing_toMaximize + 1
					alength = ((curr_alength) - missing_space) / missing_toMaximize
				else:
					## Don't maximize this joint
					alength = min_ulna

				##alength = ((curr_alength - MIN_SERVO_SPACE) / 2.0)
				aweight = (material_half_weight * alength)
				curr_alength = curr_alength - alength
			arm_tuple_list[LENGTH].append(alength)
			arm_tuple_list[WEIGHT].append(aweight)

		## (5DoF) Humerus
		if (x == 5):
			min_humerus = min_servo_space[x-1]
			if (DoF == 5):
				if (curr_alength < min_humerus):
					print "Humerus may not accommodate servo"
				alength = curr_alength
				aweight = (material_half_weight * alength)
			else:
				if (curr_alength < min_humerus):
					print "Humerus can't accommodate servo"
					return None

				## Maximize or Minimize the joint
				if (spec_min_max[x-1] == True):
					## Maximize the length of this part
					missing_space = 0
					missing_toMaximize = 1
					for i in range(x, DoF):
						if (spec_min_max[i] == False):
							missing_space = missing_space + min_servo_space[i]
						if (spec_min_max[i] == True):
							missing_toMaximize = missing_toMaximize + 1
					alength = ((curr_alength) - missing_space) / missing_toMaximize
				else:
					## Don't maximize this part
					alength = min_humerus

				aweight = (material_half_weight * alength)
				curr_alength = curr_alength - alength
			arm_tuple_list[LENGTH].append(alength)
			arm_tuple_list[WEIGHT].append(aweight)

		## (6DoF) Base
		if (x == 6):
			min_base = min_servo_space[x-1]
			if (curr_alength < min_base):
				print "Base can't accommodate servo"
				return None

			## Maximize or Minimize the joint
			if (spec_min_max[x-1] == True):
				alength = curr_alength
			else:
				alength = min_base

			aweight = (material_half_weight * alength)
			curr_alength = curr_alength - alength
			arm_tuple_list[LENGTH].append(alength)
			arm_tuple_list[WEIGHT].append(aweight)


		if (x >= 7):
			print "Robotic Arm can't have more than 6 degrees of freedom"
			return None


	return arm_tuple_list


def find_roboticarm_servos (arm_tuple_list, object_tolift_weight, DoF, 
							servo_torque_dic):

	## Find two available servos for the stall torque found. 
	def find_servo (torque, dictionary):
		print ("Torque Required for joint {} ".format(torque))
		for x in range(len(dictionary)):
			if (dictionary[x][1][0] > torque):
				return servo_torque_dic[x]
		# If nothing found
		return None

	## (In mm) Length of each arm extremity from pivot to pivot.	
	## Starting from gripper to base 
	arm_length_list = arm_tuple_list[0]
	## (In g) Weight of each arm extremity	 
	## Starting from gripper to base
	arm_weight_list =  arm_tuple_list[1]

	print arm_length_list
	print arm_weight_list


	## Find stall torque required for each servo.
	roboticarm_dic = {}
	## (In kg) Weight of each joints/servos, the first value being the object to lift.
	## Starting from object weight to base 	 
	servos_weight_list = [object_tolift_weight]
	for i in range(DoF):
		torque = 0
		length_sum = 0
		for x in reversed(range(0,i+1)):
			## Do the calculation of torque using Kg and cm.
			arm_length = arm_length_list[x] / 10.0 			## From mm to cm
			arm_weight = arm_weight_list[x] / 1000.0		## From g to kg
			servo_weight =  servos_weight_list[x] / 1000.0 	## From g to kg
			torque += ( ((arm_length + length_sum) * servo_weight) +
				(((0.5 * arm_length) + length_sum) * arm_weight) )
			length_sum += arm_length

		## Fin Servo for the found torque	
		servo = find_servo(torque, servo_torque_dic)

		if (servo == None): 
			print "No servo fit required torque of {} kg/cm".format(torque)
			return None

		## Append the weight of the servo found to the servo_weight_list
		## and Translate the weight from g to kg. 
		servos_weight_list.append(servo[1][1])
		print servo
		roboticarm_dic.update({i:(servo, torque, arm_length_list[i])})

	## return Robotic ARM dictionary
	print roboticarm_dic
	return roboticarm_dic


## Get The Min Servo Spaces Constrains for each joint
def get_min_servo_spaces (roboticarm_dic, DoF):

	## --- Dictionary Data --- (TODO Ordrer this)
	## Joints 
	dic_base = 5
	dic_humerus = 4
	dic_ulna = 3
	dic_wrist = 2
	dic_wrist2 = 1
	dic_gripper = 0
	## Data
	dic_servoData = 0
	dic_requiredTorque = 1
	dic_armLen = 2
	## servoData
	dic_servoLink = 0
	dic_servoSizes = 1
	## sevrvoSizes
	dic_Torque = 0
	dic_Weight = 1
	dic_A = 2
	dic_B = 3
	dic_C = 4
	dic_D = 5
	dic_E = 6
	dic_F = 7

	min_servo_space = []

	for x in range(1, DoF+1):

		## (1DoF) Gripper 
		if (x == 1):
			min_servo_space.append(0)
		## (2DoF) Wrist (TODO)
		if (x == 2):
			min_servo_space.append(40)
		## (3DoF) Wrist 2
		if (x == 3):
			wrist2_ALen = roboticarm_dic[dic_wrist2][dic_servoData][dic_servoSizes][dic_A]
			wrist_ELen = roboticarm_dic[dic_wrist][dic_servoData][dic_servoSizes][dic_E]
			min_servo_space.append(wrist2_ALen+AVG_TICKNES+wrist_ELen)
		## (4DoF) Ulna
		if (x == 4):
			wrist_ELen = roboticarm_dic[dic_wrist][dic_servoData][dic_servoSizes][dic_E]
			ulna_ELen = roboticarm_dic[dic_ulna][dic_servoData][dic_servoSizes][dic_E]
			min_servo_space.append(wrist_ELen+ulna_ELen)
		## (5DoF) Humerus
		if (x == 5):
			ulna_ELen = roboticarm_dic[dic_ulna][dic_servoData][dic_servoSizes][dic_E]
			humerus_ELen = roboticarm_dic[dic_humerus][dic_servoData][dic_servoSizes][dic_E]
			min_servo_space.append(ulna_ELen+humerus_ELen)
		## (6DoF) Base
		if (x == 6):
			humerus_ELen = roboticarm_dic[dic_humerus][dic_servoData][dic_servoSizes][dic_E]
			min_servo_space.append(humerus_ELen)

		if (x >= 7):
			print "Robotic Arm can't have more than 6 degrees of freedom"
			return None


	return min_servo_space



## Finds the servos and 3D part lengths
## arm_length (in cm)
## object_tolift_weight (in kg)
## DoF (From 1 to 6)
## material (Material to use)
def get_roboticarm_dic (arm_length, object_tolift_weight, DoF, material, display_materials):

	## Load json Servo List
	data = json.load(open('servos3.json'))
	servo_torque_dic = {}
	for data_list in data:
		servo_torque_dic.update({data_list['Servo']:					## Key, link to Servo part
								(data_list['Torque(kg)(min. 0.01kg)'],	## Torque in (kg/cm)
								 data_list['Weight(g)'],				## Weight in grams (g)
								 data_list['A(mm)'],					## Total Servo Height
								 data_list['B(mm)'],					
								 data_list['C(mm)'],
								 data_list['D(mm)'],					## Total Servo Width
								 data_list['E(mm)'],					## Total Servo Length
								 data_list['F(mm)'])})		
	## Sort List by Torque
	servo_torque_dic = sorted(servo_torque_dic.items(), key=lambda x:x[1][0])

	## Load json Densities List
	data = json.load(open('densities.json'))
	materials_densities_dic = {}
	for data_list in data:
		materials_densities_dic.update({data_list['Material']: 	## Name of Material
									 	data_list['Density']})	## Material Density in (g/cm^3)

	## Display available materials if requested, then exits. 
	if (display_materials):
		print "-- Avialble materials:"
		for materials in materials_densities_dic:
			print materials

		exit(0)


	## Get Material Density if found in the material densities dictionay 
	material_densty = ""
	if material in materials_densities_dic:
		## Get Material Density from dictionary
		material_densty = materials_densities_dic[material]
	else:
		print "Material '{}' not found in the materials list".format(material)
		return None


	## Find Arm length and its weight for each joint
	arm_tuple_list = find_roboticarm_sizes(arm_length, object_tolift_weight, DoF,
											AVG_MIN_SERVO_SPACE, SPEC_MIN_MAX,
											material_densty)
	if (arm_tuple_list == None):
		return None
	
	## Find servos and required torque according the calculated arm lengths.  
	roboticarm_dic = find_roboticarm_servos(arm_tuple_list, object_tolift_weight, DoF,
											servo_torque_dic)
	if (roboticarm_dic == None):
		return None

	## Get new min min servo spaces with the caluclated servos. 
	min_servo_space = get_min_servo_spaces(roboticarm_dic, DoF)

	## NOW WITH NEW MIN SERVO SPACE REQUIREMENTS ##
	## TODO PUT THIS IN AL LOOP OR FUNCTION

	print " "
	print min_servo_space
	print " "

	## Find Arm length and its weight for each joint
	arm_tuple_list = find_roboticarm_sizes(arm_length, object_tolift_weight, DoF,
											min_servo_space,  SPEC_MIN_MAX, 
											material_densty)
	if (arm_tuple_list == None):
		return None
	
	## Find servos and required torque according the calculated arm lengths.  
	roboticarm_dic = find_roboticarm_servos(arm_tuple_list, object_tolift_weight, DoF,
											servo_torque_dic)
	if (roboticarm_dic == None):
		return None


	# Return robot arm_length_list
	return roboticarm_dic



##########################
##  3D PRINT PARTS #######
##########################


## Conversts a scad object to a SCAD file and then to a STL file
def save_to_stl (scad_obj, output_name):

	scad_output_name = output_name + ".scad"
	stl_output_name = output_name + ".stl"

	scad_render_to_file(scad_obj, scad_output_name)

	args = ["openscad", "-o", stl_output_name, "-D", 'quality="production"', scad_output_name];

	try:
		subprocess.check_call(args)
	except subprocess.CalledProcessError as e:
		print "Could not convert SCAD to STL"

	return

## Plots a 3D representation of a stl file name using matlibplot
def plot_stl (input_name):
    stl_input_name = input_name + ".stl"

    # Create a new plot
    figure = pyplot.figure()
    axes = mplot3d.Axes3D(figure)

    # Load the STL files and add the vectors to the plot
    file_mesh = mesh.Mesh.from_file(stl_input_name)
    axes.add_collection3d(mplot3d.art3d.Poly3DCollection(file_mesh.vectors))

    # Auto scale to the mesh size
    scale = file_mesh.points.flatten(-1)
    axes.auto_scale_xyz(scale, scale, scale)

    # Show the plot to the screen
    pyplot.show()

    return 


def generate_3d_parts (roboticarm_dic, display):

    ## --- Dictionary Data --- (TODO Ordrer this)
    ## Joints 
    dic_base = 5
    dic_humerus = 4
    dic_ulna = 3
    dic_wrist = 2
    dic_wrist2 = 1
    dic_gripper = 0
    ## Data
    dic_servoData = 0
    dic_requiredTorque = 1
    dic_armLen = 2
    ## servoData
    dic_servoLink = 0
    dic_servoSizes = 1
    ## sevrvoSizes
    dic_Torque = 0
    dic_Weight = 1
    dic_A = 2
    dic_B = 3
    dic_C = 4
    dic_D = 5
    dic_E = 6
    dic_F = 7

    print roboticarm_dic

    tick = AVG_TICKNES



    ## Arms of the robotic arm
    base_off = 0
    base_length = roboticarm_dic[dic_base][dic_armLen]
    base_bLen = roboticarm_dic[dic_base][dic_servoData][dic_servoSizes][dic_E]
    base_height = roboticarm_dic[dic_base-1][dic_servoData][dic_servoSizes][dic_D]
    base = part_base (base_off, base_length, base_bLen, tick, base_height)

    humerus_off = (base_off + base_bLen + base_height)
    humerus_length = roboticarm_dic[dic_humerus][dic_armLen]
    humerus_height = roboticarm_dic[dic_humerus-1][dic_servoData][dic_servoSizes][dic_D]
    humerus = part_humerus(humerus_off, humerus_length, tick, humerus_height)

    ulna_off = (humerus_off + (humerus_height*2))
    ulna_length = roboticarm_dic[dic_ulna][dic_armLen]
    ulna_height = roboticarm_dic[dic_ulna-1][dic_servoData][dic_servoSizes][dic_D]
    ulna = part_humerus(ulna_off, ulna_length, tick, ulna_height)

    wrist_off = (ulna_off + (ulna_height*2))
    wrist_bLen = roboticarm_dic[dic_wrist][dic_servoData][dic_servoSizes][dic_E]
    wrist2_ALen = roboticarm_dic[dic_wrist2][dic_servoData][dic_servoSizes][dic_A]
    ## Reduce the Wrist2 servo motor fromt the Wrist arm length (TODO make this a spec)
    wrist_length = roboticarm_dic[dic_wrist][dic_armLen] - wrist2_ALen - tick
    wrist_height = roboticarm_dic[dic_wrist-1][dic_servoData][dic_servoSizes][dic_D]
    wrist = part_wrist (wrist_off, wrist_length, wrist_bLen, tick, wrist_height)

    scad_obj = base + humerus + ulna + wrist

    save_to_stl (scad_obj, "arms_stl")
    if (display):
        plot_stl ("arms_stl")



    ## Gripper

    A = roboticarm_dic[dic_gripper][dic_servoData][dic_servoSizes][dic_A]
    B = roboticarm_dic[dic_gripper][dic_servoData][dic_servoSizes][dic_B]
    D = roboticarm_dic[dic_gripper][dic_servoData][dic_servoSizes][dic_D]
    F = roboticarm_dic[dic_gripper][dic_servoData][dic_servoSizes][dic_F]
    objectLen = 10

    # gripper_cage =  part_cage(tick, B, D, F, objectLen)
    # gripper1 =  translate([B+D,0,0]) (part_gripper(tick, A, D, F, objectLen))
    # gripper2 = translate([B+D,D*2,0]) (part_gripper(tick, A, D, F, objectLen))

    # scad_obj = gripper_cage + gripper1 + gripper2
    # save_to_stl (scad_obj, "gripper_stl")
    # if (display):
    #     plot_stl ("gripper_stl")


    ## Base Support
    scad_obj = part_support(tick, B, D, F)
    save_to_stl (scad_obj, "support_stl")
    if (display):
        plot_stl ("support_stl")


    return

def part_base (off, length, bLen, tick, height):

    base = translate([off,0,0])(
            cube([tick, length, height])
           ) + translate([0,length,0])(
            cube([bLen,tick, height])
           )
    return base


def part_humerus (off, length, tick, height):

    humerus = translate([off,0,0])(
                cube([height,length,tick])
              )
    return humerus


def part_ulna (off, length, tick, height):

    ulna = translate([off,0,0])(
                cube([height,length,tick])
              )
    return ulna

def part_wrist (off, length, bLen, tick, height):

    wrist = translate([off,0,0])(
                cube([tick, length, height])
            ) + translate([off,length,0])(
                cube([bLen,tick,height])
            )
    return wrist



def part_gripper (tick, A, D, F, objectLen):

	## Basic Info
    gearSpace = A - F
    gripperLen = objectLen
    
    ## Starts and Lengths
    extraSpaceStart = gripperLen + tick
    extraSpaceLen = gearSpace + gearSpace/4.0
    holdersStart = extraSpaceStart+extraSpaceLen+tick
    holdersLen = tick+0.5
    TotalLen = holdersStart + holdersLen + tick
    
    ## Width and heigth
    heigth = tick*4.0
    width = D + (tick*6.0)
    
    ## A small hole
    holeStart = extraSpaceStart +  gearSpace/2.0;
    
    gripper = difference() (
        cube([TotalLen,width,heigth]),
        translate([extraSpaceStart,tick,-0.1]) (cube([extraSpaceLen,width-(tick*2.0),heigth+1])),
        translate([extraSpaceStart,tick*2.0,-0.1]) (cube([TotalLen-extraSpaceStart+ 0.1,width-(tick*4.0),heigth+1])),
        translate([holdersStart,tick,-0.1]) (cube([holdersLen, width-(tick*2.0), heigth+1])),
        translate([-0.1,-0.1,-0.1]) (cube([gripperLen, width/3.0+(0.1), heigth+1])),
        translate([-0.1,width-(width/3.0)+(0.1),-0.1]) (cube([gripperLen, width/3.0, heigth+1])),
        
        ## A small hole
        translate([holeStart,-0.1,heigth/2.0]) (cube([tick,tick+0.2,tick]))
    )


    return gripper


def part_cage(tick, B, D, F, objectLen):
    ## Inside is equal to size plus tick
    B=B+(tick*2)
    D=D+(tick*2)
    F=F+(tick*2)

    if (objectLen > B):
        holderSpace = (objectLen - B)/2.0
    else:
        holderSpace = tick

    cage = difference() (
        union() (
            cube([B,D,F]),
            ## For conecting grippers
            translate([-holderSpace,-tick*2.0,F-tick]) (cube([B+(holderSpace*2.0),D+(tick*4.0),tick])),
        ),
        ## Z
        translate([tick,tick,tick]) (cube([B-(tick*2.0),D-(tick*2),F])),
        ## X
        translate([-1,tick,tick]) (cube([B+2,D-(tick*2.0),F/2.0-tick])),
        ## Y
        translate([tick,tick,tick]) (cube([B-(tick*2.0),D-(tick*2.0),F-(tick*2.0)]))
    )
   
    return cage

def part_support(tick, B, D, F):
    ## Exta space so servo can fit (in mm)
    ExtraD = 2.0
    ExtraB = 3.0
    ## Inside size is equal to servo dimensions plus tick
    B=B+(tick*2)+(ExtraB)
    D=D+(tick*2)+(ExtraD)
    F=F+(tick)

    base = union() (

    	difference() (
    		cube([B,D,F]),
	        ## Z
	        translate([tick,tick,tick]) (cube([B-(tick*2.0),D-(tick*2),F])),
	        ## X
	        translate([-1,tick,tick]) (cube([B+2,D-(tick*2.0),F/2.0-tick])),
	        ## Y
	        translate([tick,tick,tick]) (cube([B-(tick*2.0),D-(tick*2.0),F-(tick*2.0)]))
    	),

    	## Legs
	    translate([B/2-B/8,-B*2+D,0]) (cube([B/4,B*4-D,tick])),
    	translate([-B*2+B/2,D/2-D/4,0]) (cube([B*4,B/4,tick]))

	)
   
    return base



def main():

    ## RoboticArm command line Arguments
    parser = argparse.ArgumentParser(
        description="Automatically generate 3D files for building a Robotic Arm"
    )
    parser.add_argument("-l","--length",
                        help="The length of the robotic arm in centimetrs (cm)",
                        type=int,
                        required=True)
    parser.add_argument("-w","--weight",
                        help="Weight of the object to carry in grams (g)",
                        type=int,
                        required=True)
    parser.add_argument("-m","--material",
                        help="Material Density to use, 'PLA Filament' by default",
                        type=str,
                        default='PLA Filament',
                        dest='material')
    parser.add_argument("-d","--display",
                        help="Displays the generated 3D parts",
                        action='store_true', dest='display')
    parser.add_argument("-a","--available",
                        help="Displays the list of available materials",
                        action='store_true', dest='available')

    args = parser.parse_args()

    ## Number of joints/servos / Degrees of Freedom
    DoF = 6
    ## (In kg) Weight of the object to lift.		
    #object_tolift_weight = 0.058
    ## (In cm) ARM length
    #arm_length = 30


    roboticarm_dic = get_roboticarm_dic(args.length*10.0, args.weight, 
    									DoF, args.material, args.available)
    if (roboticarm_dic == None):
    	print "Robotic Arm Error, Exit..."
    	exit(1)
    else:
    	generate_3d_parts(roboticarm_dic, args.display)



    ## Exit
    exit(0)




if __name__ == "__main__":
	main()


 
 
************************************************/
