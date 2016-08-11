#!/usr/bin/env python2
import sys

# I'm rewriting all of this
# There were just too many lines...
def factor(x):
	print "Factors:        Sum:    Difference:"
	for n in xrange(2,x):
		if x%n == 0:
			a = n
			b = x/n
			print str(n).ljust(8) + str(b).ljust(8) + str(a+b).ljust(8) + str(abs(a-b)).ljust(8)
number = int( sys.argv[1] )
factor(number)