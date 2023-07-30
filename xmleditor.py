#! /usr/bin/env python3
from lxml import etree
import argparse
from pprint import pprint
import os

parser = argparse.ArgumentParser(description='XML Editor')
parser.add_argument('-a', '--append', action='store_true', help='Append')
parser.add_argument('-d', '--delete', action='store_true', help='Delete')
parser.add_argument('-m', '--modify', action='store_true', help='modify')
parser.add_argument('-p', '--path', type=str, help='Path to XML file')
parser.add_argument('-n', '--name', type=str,help='Name of property')
parser.add_argument('-v', '--value', type=str, help='Value of property')
args = parser.parse_args()

if (args.path is None or not os.path.exists(args.path)): 
    print('Error file!')
    exit()

if (args.append):
    tree = etree.parse(args.path)
    root = tree.getroot()

    # create property
    property = etree.SubElement(root, 'property')

    name = etree.SubElement(property, 'name')
    name.text = args.name

    value = etree.SubElement(property, 'value')
    value.text = args.value

    tree.write(args.path, pretty_print=True, xml_declaration=True, encoding='utf-8')

    print('Property added')

# xmleditor -a -p ./etc/hadoop/core-site.xml -n fs.defaultFS -v hdfs://localhost:9000