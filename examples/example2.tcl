# example2.tcl
################################################################################
# Cantilever column example in OpenSees
# 
# For point loads within the elastic range of the steel shape, the magnitude of
# the OpenSees fiber model deflection should be slightly larger, due to 
# slightly smaller section properties of the fiber section.
# For point loads that cause the cantilever column to yield, the deflection
# should be significantly larger in magnitude with the OpenSees fiber section.
#
# Units are kips and inches
# Written by Alex Baker, 2022
################################################################################

# Load database
source ../readAISC.tcl
set aisc [readAISC ../v15.0/Shapes-US.csv]

# Define model parameters
set shape W14X90
set L 100.0; # Length of cantilever, in
set Fy 50.0; # Yield stress, ksi
set E 29000.0; # Elastic modulus, ksi
set I [dict get $aisc $shape Ix]; # Moment of inertia, in^4
set Z [dict get $aisc $shape Zx]; # Plastic section modulus, in^3
set Mp [expr {$Z*$Fy}]; # Full plastic yield moment, kip-in
set Py [expr {$Mp/$L}]; # Full plastic yield point load, kip
set r 0.5; # Ratio of point load to full plastic yield point load
set P [expr {$Py*$r}]; # Point load for example (stays linear), kip

# Define model geometry
wipe
model BasicBuilder -ndm 2
node 1 0 0
node 2 $L 0
fix 1 1 1 1

# Define non-linear uniaxialMaterial for fibers
set matTag 1
uniaxialMaterial ElasticPP $matTag $E [expr {$Fy/$E}]

# Define fiber section
set secTag 1
set d [dict get $aisc $shape d]
set tw [dict get $aisc $shape tw]
set bf [dict get $aisc $shape bf]
set tf [dict get $aisc $shape tf]
set nfw 10; # number of fibers in web
set nff 10; # number of fibers in flange
section WFSection2d $secTag $matTag $d $tw $bf $tf $nfw $nff

# Create force-based beam column with fiber section
set nPts 5; # number of integration points
geomTransf Linear 1
element forceBeamColumn 1 1 2 1 "Lobatto $secTag $nPts"

# Add vertical load to end of cantilever
timeSeries Linear 1
pattern Plain 1 1 {
    load 2 0 -$P 0
}

# Perform static analysis
constraints Plain
numberer RCM
system UmfPack
test EnergyIncr 1.0e-8 10
integrator LoadControl 0.1
algorithm Newton
analysis Static
analyze 10

# Get displacement at cantilever end
set modelDisp [nodeDisp 2 2]

# Compute theoretical deflection from elastic cantilever beam equation
set theoryDisp [expr {-$P*$L**3/(3*$E*$I)}]; # AISC Manual Table 3-23 (22)

# Percent difference from OpenSees to theoretical
set percentDiff [expr {100*($modelDisp - $theoryDisp)/$theoryDisp}]

puts "--Cantilever Column---------------------------------"
puts "  Steel Shape:  $shape"
puts "  Length:       [format %.6f $L] in"
puts "  Point Load:   [format %.6f $P] kip"
puts ""
puts "--Analysis Results----------------------------------"
puts "  Theoretical Linear Deflection:        [format %.6f $theoryDisp] in"
puts "  Fiber Section OpenSees Deflection:    [format %.6f $modelDisp] in"; 
puts "  Percent Difference:                   [format %.2f $percentDiff] %"
