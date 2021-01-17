#!/bin/bash
# prepare your STL files and edit this script to match their names and directories
# command-line input

   if (( $# < 5 ))
   then
      echo 'Usage: snappyMesh.sh <case_name> <dir-of-stls> <meta_data> <ouput.stl> <hex size [m]> [expand-factor]'
     exit 1
    fi
    $case=$1
    $meta=$2
    directory=$3
    output=$4
    cell_size=$5

    if (( $# > 5))
       then
        expand_factor=$6
    else
        expand_factor=1.001
    fi

# command-line input
echo  $2
# snappyHexMesh reads from constant/triSurface
mv $2 constant/triSurface

# create a background mesh from the prepared model
python ~/bin/create_blockmesh.py constant/triSurface/$output $cell_size $expand_factor

# remove relics from old tries
rm -r 1 2 3

# edges and other features; system/surfaceFeatureExtractDict must be defined
surfaceFeatureExtract

# background mesh
blockMesh

# remove output.stl used to create blockMesh
rm -f constant/triSurface/$output

# meshing in parallel: system/decomposeParDict must be defined;
# use mpiexec on windows and mpirun on linux
decomposePar -force
mpiexec -np 4 snappyHexMesh -parallel
reconstructParMesh -latestTime

# sets and zones, if there's anything in system/topoSetDict;
# also, updates on patches if there's anything in system/changeDictionaryDict
topoSet
setsToZones
changeDictionary

# check and see
checkMesh
paraFoam

# convert output files to vtk for ParaView
foamToVTK

# zip up VTK and move to home directory

tar -cf - VTK | gzip > ~/$case_VTK.tar.gz

echo "All Done!"
