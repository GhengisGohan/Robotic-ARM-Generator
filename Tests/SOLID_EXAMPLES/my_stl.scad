

union() {
	union() {
		union() {
			cube(size = [0.5000000000, 10, 2]);
			translate(v = [0, 10, 0]) {
				cube(size = [5, 0.5000000000, 2]);
			}
		}
		translate(v = [7, 0, 0]) {
			cube(size = [2, 11, 0.5000000000]);
		}
	}
	translate(v = [11, 0, 0]) {
		cube(size = [2, 10, 0.5000000000]);
	}
}
/***********************************************
*********      SolidPython code:      **********
************************************************
 
import subprocess
# Numpy-stl
from stl import mesh
from mpl_toolkits import mplot3d
from matplotlib import pyplot
# SolidPython
from solid import *
from solid.utils import *


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


tick = 0.5
width = 2
base_length = 10
bLen = 5
humerus_length = 11
humerus_off = (bLen + width)
ulna_length = 10
ulna_off = (humerus_off + (width*2))

base = cube([tick, base_length, width]) + translate([0,base_length,0])(cube([bLen,tick,width]))

humerus = translate([humerus_off,0,0])(cube([width,humerus_length,tick]))

ulna = translate([ulna_off,0,0])(cube([width,ulna_length,tick]))

scad_obj = base + humerus + ulna


save_to_stl (scad_obj, "my_stl")
# plot_stl ("my_stl")




 
 
************************************************/
