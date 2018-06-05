#!/usr/bin/python
import json
import urllib2

response = urllib2.urlopen('http://moon15:8888/api/v1/query?query=akka_system_dead_letters_total')
parsed = json.load(response)["data"]["result"]
sum = 0
for metric in parsed: 
    sum += int(metric["value"][1])

if (sum > 500):
    exit(0)
else:
    exit(1)
