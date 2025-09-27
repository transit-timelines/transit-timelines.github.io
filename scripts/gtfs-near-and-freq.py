#!/usr/bin/env python3

import re
from math import pi, sqrt, cos
import sys
import datetime

# Parameters and defaults
distance = int(sys.argv[1]) if len(sys.argv) > 1 else 5
headway = int(sys.argv[2]) if len(sys.argv) > 2 else 20
day = "wednesday"
today = datetime.datetime.today()
wednesdayAfterNext = today + datetime.timedelta(days=(8 + ((1-today.weekday()) % 7)))
if len(sys.argv) > 3:
    date = sys.argv[3]
else:
    date = (lambda d: str(d.year) + str(d.month).zfill(2) + str(d.day).zfill(2))(wednesdayAfterNext)
startHour = 11
endHour = 15

def preProc(x):
    retString = ''
    inQuote = False
    for c in x:
        if c == '\n':
            continue
        elif c == '"':
            inQuote = not inQuote
        elif c == "," and inQuote:
            continue
        else:
            retString += c
    return retString
   
def minsFromTime(timeString):
    timeArray = timeString.split(':')
    return int(timeArray[1])+int(timeArray[0])*60

def coordDist(pointA, pointB):
    x = cos((pi/180)*pointA[0]) * (40075/360) * (pointA[1] - pointB[1])
    y = (40075/360) * (pointA[0] - pointB[0])
    return sqrt(x**2 + y**2)

def posInHeading(columnName, heading):
    headingArray = heading.split(',')
    for i in range(0, len(headingArray)):
        if re.search(columnName, headingArray[i]):
            return i

def isFrequent(timeSet):
    lastTime = startHour * 60
    inRange = 0
    for time in sorted(timeSet):
        if time < startHour * 60:
            continue
        if time > endHour * 60:
            continue
        inRange += 1
        if time - lastTime > 1.1 * headway:
            return False
        lastTime = time
    if inRange < (endHour - startHour) * (60 / headway):
        return False
    return True

stoptimes_f = open("stop_times.txt", "r")
stoptimes = stoptimes_f.readlines()
stoptimes_f.close()
stops_f = open("stops.txt", "r")
stops = stops_f.readlines()
stops_f.close()
trips_f = open("trips.txt", "r")
trips = trips_f.readlines()
trips_f.close()
routes_f = open("routes.txt", "r")
routes = routes_f.readlines()
routes_f.close()
cal_f = open("calendar.txt", "r")
cal = cal_f.readlines()
cal_f.close()
caldates_f = open("calendar_dates.txt", "r")
caldates = caldates_f.readlines()
caldates_f.close()


calDayPos = posInHeading(day, cal[0])
calStartdatePos = posInHeading("start_date", cal[0])
calEnddatePos = posInHeading("end_date", cal[0])
calServidPos = posInHeading("service_id", cal[0])
relevantServids = set()
for line in cal[1:]:
    lineArray = preProc(line).split(',')
    if lineArray[calDayPos] == '1' or lineArray[calDayPos] == '"1"':
        if date >= lineArray[calStartdatePos] and date <= lineArray[calEnddatePos]:
            relevantServids.add(lineArray[calServidPos])
caldateServidPos = posInHeading("service_id", caldates[0])
caldatePos = posInHeading("date", caldates[0])
caldateTypePos = posInHeading("exception_type", caldates[0])
for line in caldates[1:]:
    lineArray = preProc(line).split(',')
    if lineArray[caldatePos] == date:
        if lineArray[caldateTypePos] == '1':
            relevantServids.add(lineArray[caldateServidPos])
        if lineArray[caldateTypePos] == '2':
            relevantServids.remove(lineArray[caldateServidPos])

routeidTypes = {}
routeIdPos = posInHeading("route_id", routes[0])
routeTypePos = posInHeading("route_type", routes[0])
for line in routes[1:]:
    lineArray = preProc(line).split(',')
    routeidTypes[lineArray[routeIdPos]] = lineArray[routeTypePos]

relevantTrips = set()
tripRouteidPos = posInHeading("route_id", trips[0])
tripServidPos = posInHeading("service_id", trips[0])
tripIdPos = posInHeading("trip_id", trips[0])
for line in trips[1:]:
    lineArray = preProc(line).split(',')
    if lineArray[tripServidPos] in relevantServids and routeidTypes[lineArray[tripRouteidPos]] != '3':
        relevantTrips.add(lineArray[tripIdPos])

stopCoords = {}
stopNames = {}
fromAtoB = {}

stopLatPos = posInHeading("stop_lat", stops[0])
stopLonPos = posInHeading("stop_lon", stops[0])
stopIdPos = posInHeading("stop_id", stops[0])
stopNamePos = posInHeading("stop_name", stops[0])
for line in stops[1:]:
    lineArray = preProc(line).split(',')
    stopid = lineArray[stopIdPos]
    stopname = lineArray[stopNamePos]
    if len(lineArray) < 2:
        continue
    stopNames[stopid] = lineArray[stopNamePos]
    stopCoords[stopname] = float(lineArray[stopLatPos]), float(lineArray[stopLonPos])
    fromAtoB[stopname] = {}


stTripidPos = posInHeading("trip_id", stoptimes[0])
stTimePos = posInHeading("departure_time", stoptimes[0])
stStopidPos = posInHeading("stop_id", stoptimes[0])
stPickupPos = posInHeading("pickup_type", stoptimes[0])
stDropoffPos = posInHeading("drop_off_type", stoptimes[0])
currentTripid = ''
currentTrip = {}
for line in stoptimes[1:]:
    lineArray = preProc(line).split(',')
    if len(lineArray[stTimePos]) < 4:
        continue
    tripid = lineArray[stTripidPos]
    time = minsFromTime(lineArray[stTimePos])
    stopid = lineArray[stStopidPos]
    if tripid not in relevantTrips:
        continue
    if tripid != currentTripid:
        currentTrip = {}
        currentTripid = tripid
    for origin in currentTrip:
        if stopNames[stopid] not in fromAtoB[stopNames[origin]]:
            fromAtoB[stopNames[origin]][stopNames[stopid]] = set()
        if lineArray[stDropoffPos] != '1':
            fromAtoB[stopNames[origin]][stopNames[stopid]].add(currentTrip[origin])
    if lineArray[stPickupPos] != '1':
        currentTrip[stopid] = time

print('<?xml version="1.0" encoding="UTF-8"?>')
print('<kml xmlns="http://www.opengis.net/kml/2.2"><Document>')
for orig in fromAtoB:
    for dest in fromAtoB[orig]:
        if coordDist(stopCoords[orig], stopCoords[dest]) > distance:
            continue
        if isFrequent(fromAtoB[orig][dest]):
            print('<Placemark><name>',
                  orig,
                  '</name><Point><coordinates>',
                  stopCoords[orig][1],
                  ',',
                  stopCoords[orig][0],
                  '</coordinates></Point></Placemark>')
            break
print('</Document></kml>')

def printFrequentDests(orig):
    for dest in fromAtoB[orig]:
        if isFrequent(fromAtoB[orig][dest]):
            print(dest)

def printQualifyingDests(orig):
    for dest in fromAtoB[orig]:
        if isFrequent(fromAtoB[orig][dest]) and coordDist(stopCoords[orig], stopCoords[dest]) <= distance:
            print(dest)
