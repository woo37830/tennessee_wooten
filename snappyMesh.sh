#!/bin/bash
# prepare your STL files and edit this script to match their names and directories
# command-line input

if [[ ! -d "skeleton_case" ]]
  then
    echo "You must be in a directory with master 'skeleton_case' directory present"
    exit
fi
   if (( $# < 3 ))
   then
      echo 'Usage: snappyMesh.sh <case_name> <dir-of-stls>  <hex size [m]> [expand-factor]'
     exit 1
    fi
    case=$1
    mkdir $case
    cd $case

    meta_path="../skeleton_case/input/meta_bc";

    cp  -r $meta_path 0


    stl_directory=../$2;
    cell_size=$3

    if (( $# > 3))
       then
        expand_factor=$4
    else
        expand_factor=1.001
    fi
output="tmp.stl"

cp -r "../skeleton_case/input/constant" constant

cp -r "../skeleton_case/input/system" system

# snappyHexMesh reads from constant/triSurface

cp  -r $stl_directory constant/triSurface

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
