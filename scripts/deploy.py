'''
SDP Deploy to Disk Image.
This script requires that a2kit be installed and in the path.
'''

import subprocess
import pathlib
import sys

if len(sys.argv)!=4:
    print('usage: python '+sys.argv[0]+' <img_type> <project_path> <distro_path>')
    exit(1)
img_fmt = sys.argv[1]
if img_fmt!='woz' and img_fmt!='do':
    print('format must be woz or do')
    exit(1)
home_path = pathlib.Path.home()
proj_path = pathlib.Path(sys.argv[2])
distro_path = pathlib.Path(sys.argv[3])

def a2kit_beg(args):
    '''run a2kit and pipe the output'''
    compl = subprocess.run(['a2kit']+args,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout
def a2kit_pipe(args,pipe_in):
    '''run a2kit with piped input and output'''
    compl = subprocess.run(['a2kit']+args,input=pipe_in,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout
def a2kit_end(args,pipe_in):
    '''run a2kit with piped input and terminate output'''
    compl = subprocess.run(['a2kit']+args,input=pipe_in,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout

bas_folder = proj_path
sprite_folder = proj_path / 'shapes'
mc_folder = proj_path / 'binaries'

disk_path = 'sdp.'+img_fmt

bas_files = [
    {"name": "BYFNDR", "load": 0x800, "folder": bas_folder},
    {"name": "FASTSHAPE", "load": 0x800, "folder": bas_folder},
    {"name": "FSVIEWER", "load": 0x800, "folder": bas_folder},
    {"name": "HELLO", "load": 0x800, "folder": bas_folder},
    {"name": "UTIL", "load": 0x800, "folder": bas_folder},
    {"name": "SDP", "load": 0x800, "folder": bas_folder},
    {"name": "SHAPE", "load": 0x800, "folder": bas_folder},
    {"name": "TEXT", "load": 0x800, "folder": bas_folder},
    {"name": "VIEWER", "load": 0x800, "folder": bas_folder}
]

file_images = [
    {"name": "D0", "folder": sprite_folder},
    {"name": "D1", "folder": sprite_folder},
    {"name": "D2", "folder": sprite_folder},
    {"name": "D3", "folder": sprite_folder},
    {"name": "D4", "folder": sprite_folder},
    {"name": "D5", "folder": sprite_folder},
    {"name": "D6", "folder": sprite_folder},
    {"name": "FRAMEM", "folder": sprite_folder},
    {"name": "ROBOT", "folder": sprite_folder},
    {"name": "ROBOT.FS", "folder": sprite_folder}
]

bin_files = [
    {"name": "DR#060300", "load": 0x300, "folder": mc_folder},
    {"name": "HS.INTRP#064000", "load": 0x4000, "folder": mc_folder},
    {"name": "SDP.INTRP#064b00", "load": 0x4b00, "folder": mc_folder},
    {"name": "SDP.INTRP.E#064b00", "load": 0x4b00, "folder": mc_folder},
    {"name": "SI#064000", "load": 0x4000, "folder": mc_folder}
]

# Create the bootable disk image

if img_fmt=='woz':
    img_fmt = 'woz2'
print('creating disk images')
a2kit_beg(['mkdsk','-d',disk_path,'-o','dos33','-t',img_fmt,'-v','254','-b'])

# Deploy BASIC programs
for dict in bas_files:
    print('processing',dict['name'])
    src = a2kit_beg(['get','-f',dict['folder']/(dict['name']+'.bas')])
    addr0 = dict['load']
    tok = a2kit_pipe(['tokenize','-t','atxt','-a',str(addr0+1)], src)
    max_len = 0x2000 - addr0 - 1
    if len(tok) > max_len:
        print('ERROR: program',dict['name'],'is too long')
        exit(1)
    a2kit_end(['put','-t','atok','-f',dict['name'],'-d',disk_path], tok)
    print('program length',len(tok))

# Deploy machine code
for dict in bin_files:
    name = dict['name'].split('#')[0]
    print('processing',name)
    obj = a2kit_beg(['get','-f',dict['folder']/dict['name']])
    a2kit_end(['put','-t','bin','-f',name,'-a',str(dict['load']),'-d',disk_path], obj)

# Deploy shapes
for dict in file_images:
    name = dict['name'] + '.json'
    print('processing',name)
    obj = a2kit_beg(['get','-f',dict['folder']/name])
    a2kit_end(['put','-t','any','-f',dict['name'],'-d',disk_path], obj)
