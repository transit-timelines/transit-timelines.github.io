#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import sys, subprocess, re

ET.register_namespace('', "http://www.w3.org/2000/svg")
ET.register_namespace('xlink', "http://www.w3.org/1999/xlink")
ET.register_namespace('rdf', "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
ET.register_namespace('cc', "http://creativecommons.org/ns#")
ET.register_namespace('dc', "http://purl.org/dc/elements/1.1/")

tree = ET.parse(sys.argv[1])
for path in tree.getroot().findall("{http://www.w3.org/2000/svg}path"):
    if path.attrib["id"] in ["path4189", "path4191", "path5002"]:
        path.attrib["style"] = re.sub("58585a", "3374ab", path.attrib["style"])
    if path.attrib["id"] in ["path4185", "path4504"]:
        path.attrib["style"] = re.sub("58585a", "cc575c", path.attrib["style"])
    if path.attrib["id"] == "path4499":
        path.attrib["style"] = re.sub("58585a", "688bab", path.attrib["style"])

tree.write(sys.argv[1] + "-temp", encoding="unicode")
subprocess.run(["inkscape", "-l", "-o", sys.argv[1], sys.argv[1] + "-temp"])
subprocess.run(["rm", sys.argv[1] + "-temp"])
