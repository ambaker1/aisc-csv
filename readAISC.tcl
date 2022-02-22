# readAISC.tcl
################################################################################
# Import in the AISC database from CSV as a double-nested dictionary.
# The CSV parsing is very minimal here - does not handle escaped characters, but
# is adequate for loading the AISC files.
# The first keys in the resulting dictionary are the EDI_Std_Nomenclature field
# in the AISC database, not the AISC_Manual_Label.

# Copyright (C) 2022 Alex Baker, ambaker1@mtu.edu
# All rights reserved. 

# See the file "LICENSE" in the top level directory for information on usage, 
# redistribution, and for a DISCLAIMER OF ALL WARRANTIES.
################################################################################

# readAISC --
#
# Reads the AISC database from CSV and stores in a sparse double-nested dict
#
# Arguments:
# filename:     Filename of AISC csv file.

proc readAISC {filename} {
    # Try to open file for reading
    if {[catch {open $filename r} fid]} {
        return -code error "Unable to read file"
    }
    # Read file and separate header from data
    set data [read -nonewline $fid]
    close $fid
    set lines [lassign [split $data \n] header]
    set fields [lrange [split $header ,] 1 end]
    # Create AISC database dictionary
    set aiscDict ""
    foreach line $lines {
        # Separate key (EDI_Std_Nomenclature) from property values
        set values [lassign [split $line ,] key]
        dict set aiscDict $key ""
        foreach field $fields value $values {
            # Only include if data exists.
            if {$value ne ""} {
                dict set aiscDict $key $field $value
            }
        }
    }
    return $aiscDict
}
