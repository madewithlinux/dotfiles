#!/usr/bin/freecadcmd
import os, sys
import Part
import Mesh

infile = sys.argv[2]
# make it .stl.step now, so it's real clear that this is not really much of a step file
outfile = infile + '.step'

print outfile + ': loading mesh ' + infile

mesh = Mesh.Mesh(infile)

print outfile + ': making mesh'
shape = Part.Shape()
shape.makeShapeFromMesh(mesh.Topology, 0.05)

print outfile + ': solidifying'
solid = Part.makeSolid(shape)

print outfile + ': exporting'
solid.exportStep(outfile)

print outfile + ': done'
