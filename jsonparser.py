#!/usr/bin/python
import json
import urllib2
import time


sum = 0
while (sum < 500):
    time.sleep(10)
    response = urllib2.urlopen('http://moe.eecs.qmul.ac.uk:8888/api/v1/query?query=akka_system_dead_letters_total')
    parsed = json.load(response)["data"]["result"] 
    sum = 0
    for metric in parsed:
        sum += int(metric["value"][1])
    print(sum)
exit(0)
