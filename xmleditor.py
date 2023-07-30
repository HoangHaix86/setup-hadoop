#! /usr/bin/env python3
from lxml import etree
import argparse
from pprint import pprint
import os


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def message(text, _color):
    print(f'{_color}{text}{_color}')

parser = argparse.ArgumentParser(description='XML Editor')
parser.add_argument('-a', '--append', type=str, help='Append')
parser.add_argument('-d', '--delete', type=str, help='Delete')
parser.add_argument('-m', '--modify', type=str, help='modify')
parser.add_argument('-p', '--path', type=str, help='Path to XML file')
parser.add_argument('-n', '--name', type=str,help='Name of property')
parser.add_argument('-v', '--value', type=str, help='Value of property')
args = parser.parse_args()

if (args.path is None or not os.path.exists(args.path)): 
    message('Error file!', bcolors.FAIL)
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

    message('Property added', bcolors.OKGREEN)

# xmleditor -a -p ./etc/hadoop/core-site.xml -n fs.defaultFS -v hdfs://localhost:9000