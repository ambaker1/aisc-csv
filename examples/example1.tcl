# example1.tcl
################################################################################
# Basic access to database/demo of dictionary commands
#
# Written by Alex Baker, 2022
################################################################################

# Load database
source ../readAISC.tcl
set aisc [readAISC ../v15.0/Shapes-US.csv]

# Perform simple query
puts "Area of W14X90: [dict get $aisc W14X90 A]"; # 26.5

# Filter by shape pattern (all wide-flange shapes)
set Wshapes [dict filter $aisc key {W[0-9]*}]
puts "\nNumber of total shapes: [dict size $aisc]"
puts "Number of wide-flange shapes: [dict size $Wshapes]"

# Filter by value
set selected [dict filter $Wshapes script {shape properties} {
    expr {[dict get $properties A] > 200.0}
}]
puts "\nWide-flange shapes with A > 200.0:"
puts "Shape\tA"
dict for {shape properties} $selected {
    puts "$shape\t[dict get $properties A]"
}

# Get list of values to go with list of shapes (with lmap and dict get)
puts "\nGetting list of property values for list of shapes"
set shapes {W14X90 W21X101 W16X100}
set Ix [lmap shape $shapes {dict get $aisc $shape Ix}]
puts "Shapes:\t$shapes"
puts "Ix:\t$Ix"
