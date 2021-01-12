#!/bin/bash
# prepare your STL files and edit this script to match their names and directories
# command-line input
 
   if (( $# < 3 )) 
   then
      echo 'Usage: snappyMesh.sh <dir-of-stls> <ouput.stl> <hex size [m]> [expand-factor]'
     exit 1
    fi 
    directory=$1
    output=$2
    cell_size=$3
 
    if (( $# > 3))
       then
        expand_factor=$4
    else
        expand_factor=1.001
    fi

# command-line input
echo  $2
# snappyHexMesh reads from constant/triSurface
mv $2 constant/triSurface
 
# create a background mesh from the prepared model
python ~/bin/create_blockmesh.py constant/triSurface/impeller.stl 0.001 1.001
 
# remove relics from old tries
rm -r 1 2 3
 
# edges and other features; system/surfaceFeatureExtractDict must be defined
surfaceFeatureExtract
 
# background mesh
blockMesh
 
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

