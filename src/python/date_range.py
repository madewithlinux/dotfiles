#!/usr/bin/env python
# (c) Copyright 2015 Josh Wright
import datetime,sys
range_length = int(sys.argv[1])

date_spec = "%Y-%m-%d %a" # as per ISO 8601
# if "fn" in sys.argv:
# 	date_spec = "%Y.%m.%d %a"
current_day = datetime.date.today()

if range_length>0:
	# go range_length days into the future
	for i in range(1,range_length):
		current_day += datetime.timedelta(1)
		print(current_day.strftime(date_spec))
else:
	# going from range_length days ago to today
	current_day += datetime.timedelta(range_length) # add because range_length is negative
	for i in range(1,-range_length):
		current_day += datetime.timedelta(1)
		print(current_day.strftime(date_spec))

