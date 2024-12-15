'''
SDP Deploy to Disk Image.
Depends on a2kit v3.
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
proj_path = pathlib.Path(sys.argv[2])
distro_path = pathlib.Path(sys.argv[3])

def a2kit(args,pipe_in=None):
    compl = subprocess.run(['a2kit']+args,input=pipe_in,capture_output=True)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout

vers = tuple(map(int, a2kit(['-V']).decode('utf-8').split()[1].split('.')))
if vers < (3,0,0):
    print("script requires a2kit v3 or higher")
    exit(1)

bas_folder = proj_path
sprite_folder = proj_path / 'shapes'
mc_folder = proj_path / 'binaries'

disk_path = distro_path / ('sdp.'+img_fmt)

bas_files = [
    {"name": "BYFNDR", "folder": bas_folder},
    {"name": "FASTSHAPE", "folder": bas_folder},
    {"name": "FSVIEWER", "folder": bas_folder},
    {"name": "HELLO", "folder": bas_folder},
    {"name": "UTIL", "folder": bas_folder},
    {"name": "SDP", "folder": bas_folder},
    {"name": "SHAPE", "folder": bas_folder},
    {"name": "TEXT", "folder": bas_folder},
    {"name": "VIEWER", "folder": bas_folder}
]

fixed_images = [
    {"name": "D0", "folder": sprite_folder},
    {"name": "D1", "folder": sprite_folder},
    {"name": "D2", "folder": sprite_folder},
    {"name": "D3", "folder": sprite_folder},
    {"name": "D4", "folder": sprite_folder},
    {"name": "D5", "folder": sprite_folder},
    {"name": "D6", "folder": sprite_folder},
    {"name": "FRAMEM", "folder": sprite_folder},
    {"name": "ROBOT", "folder": sprite_folder},
    {"name": "ROBOT.FS", "folder": sprite_folder},
    {"name": "DR", "folder": mc_folder},
    {"name": "HS.INTRP", "folder": mc_folder},
    {"name": "SDP.INTRP", "folder": mc_folder},
    {"name": "SDP.INTRP.E", "folder": mc_folder},
    {"name": "SI", "folder": mc_folder}
]

all_file_images = "["

# Create the bootable disk image
if img_fmt=='woz':
    img_fmt = 'woz2'
print('creating disk images')
a2kit(['mkdsk','-d',disk_path,'-o','dos33','-t',img_fmt,'-v','254','-b'])
a2kit(['put','-d',disk_path,'-t','meta'],a2kit(['get','-f',proj_path / 'scripts' / 'meta.json']))

# Build images of BASIC programs
load_addr = 0x801
max_end = 0x1E00 # leave 2 pages for variables
for dict in bas_files:
    print('processing',dict['name'])
    src = a2kit(['get','-f',dict['folder']/(dict['name']+'.bas')])
    tok = a2kit(['tokenize','-t','atxt','-a',str(load_addr)], src)
    if load_addr + len(tok) > max_end:
        print('ERROR: program',dict['name'],'is too long')
        exit(1)
    all_file_images += a2kit(['pack','-t','atok','-f',dict['name'],"-o","dos33"], tok).decode('utf-8') + ","

# Add fixed file images
for dict in fixed_images:
    name = dict['name'] + '.json'
    print('processing',name)
    all_file_images += a2kit(['get','-f',dict['folder']/name]).decode('utf-8') + ","

all_file_images = all_file_images[:-1] + "]"

# Write all file images at once
a2kit(['mput','-d',disk_path], all_file_images.encode('utf-8'))