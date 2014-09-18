import os
import sqlite3

from speaker_stats import db

def create_db():
    '''Create the database which will be populated by the rest of the functions
    in this module, filling it with empty tables.'''
    with sqlite3.connect('coaltrain.db') as conn:
        c = conn.cursor()
        c.execute('''
        create table authors (
            id integer primary key,
            author varchar(128),
            city varchar(16),
            section varchar(64),
            page integer);''')
        c.execute('''
        create table paths (
            id integer primary key,
            city varchar(16),
            section varchar(64),
            page integer,
            path varchar(256))''')

def get_lines_from_file(path):
    with open(path, 'r') as f:
        return f.readlines()
        
def capitalize_first_letter_all_words(string):
    return ' '.join(map(lambda word: word[0].capitalize() + word[1:],
                        string.split(' ')))

def replace_all_char(string, old, new):
    return ''.join(list(map(lambda c: new if c == old else c, string)))

def fix_fives(string):
    return replace_all_char(string, 'S', '5')

def capitalize_words(line):
    return ' '.join(map(lambda word: word.upper(), line.split(' ')))

def insert_authors(names, nums, city, section):
    with sqlite3.connect('coaltrain.db') as conn:
        c = conn.cursor()
        for name, num in zip(names, nums):
            cmd = "insert into authors values (NULL, '%s', '%s', '%s', %s);" % (
                name.replace("'", "''"),
                city,
                section,
                str(num) if num else 'NULL')
            c.execute(cmd)
    
def _pbpvcr1i_get_names_from_lines(lines):
    return map(capitalize_words,
               map(lambda line: line.strip(),
                   filter(lambda line: line != '\n', lines)))

def _pbpvcr1i_get_nums_from_lines(lines):
    return map(int,
               map(fix_fives,
                   filter(lambda line: line != '\n', lines)))

def insert_bellingham_pvc_room1_index():
    lines = get_lines_from_file('pages/bellingham/pvc_room1_index/cat.txt')

    names = []
    nums = []
    for names_low, names_high, nums_low, nums_high in [
            (3, 40, 43, 82),
            (85, 113, 113, 160),
            (161, 191, 192, 237)]:
        page_names = _pbpvcr1i_get_names_from_lines(lines[names_low:names_high])
        page_nums = _pbpvcr1i_get_nums_from_lines(lines[nums_low:nums_high])
        assert(len(list(page_names)) == len(list(page_nums)))
        names += page_names
        nums += page_nums

    names += _pbpvcr1i_get_names_from_lines(lines[240:266])
    nums += _pbpvcr1i_get_nums_from_lines(lines[267:302])
    nums += [110, 111, 112, 114, 115]
    assert(len(names) == len(nums))

    names += _pbpvcr1i_get_names_from_lines(lines[307:320])
    nums += _pbpvcr1i_get_nums_from_lines(lines[327:334])
    nums += [119, 120, 121]
    assert(len(names) == len(nums))

    insert_authors(names,
                   nums,
                   'BELLINGHAM',
                   'PUBLIC VERBAL COMMENTS (ROOM 1)')

def insert_bellingham_pvc_room2_index():
    lines = get_lines_from_file('pages/bellingham/pvc_room2_index/cat.txt')

    names, nums = [], []

    names += _pbpvcr1i_get_names_from_lines(lines[3:32])
    nums += _pbpvcr1i_get_nums_from_lines(lines[37:59])
    assert(len(names) == len(nums))

    names += _pbpvcr1i_get_names_from_lines(lines[59:100])
    nums += _pbpvcr1i_get_nums_from_lines(lines[101:127])
    assert(len(names) == len(nums))

    names += _pbpvcr1i_get_names_from_lines(lines[128:157])
    nums += _pbpvcr1i_get_nums_from_lines(lines[158:184])
    assert(len(names) == len(nums))

    names += _pbpvcr1i_get_names_from_lines(lines[185:221])
    nums += _pbpvcr1i_get_nums_from_lines(lines[222:248])
    assert(len(names) == len(nums))

    weird_lines = _pbpvcr1i_get_names_from_lines(lines[249:255])
    for weird_line in weird_lines:
        names.append(weird_line[:-4])
        nums.append(weird_line[-3:])
    assert(len(names) == len(nums))

    insert_authors(names,
                   nums,
                   'BELLINGHAM',
                   'PUBLIC VERBAL COMMENTS (ROOM 2)')

def insert_mount_vernon_ivc_transcriptionist_index():
    path = 'pages/mount_vernon/ivc_transcriptionist_index/cat.txt'
    lines = get_lines_from_file(path)
    names, nums = [], []

    names += _pbpvcr1i_get_names_from_lines(lines[3:29])
    nums += [4, 4, 6, 8, 8, 9]
    nums += _pbpvcr1i_get_nums_from_lines(lines[32:63])
    assert(len(names) == len(nums))

    names += _pbpvcr1i_get_names_from_lines(lines[66:105])
    nums += _pbpvcr1i_get_nums_from_lines(lines[106:])
    assert(len(names) == len(nums))

    insert_authors(names,
                   nums,
                   'MOUNT VERNON',
                   'INDIVIDUAL VERBAL COMMENTS (TRANSCRIPTIONIST)')

def insert_mount_vernon_pvc_room1_index():
    path = 'pages/mount_vernon/pvc_room1_index/cat.txt'
    lines = get_lines_from_file(path)
    names, nums = [], []

    names += _pbpvcr1i_get_names_from_lines(lines[3:65])
    nums += _pbpvcr1i_get_nums_from_lines(lines[68:113])
    assert(len(names) == len(nums))

    names += _pbpvcr1i_get_names_from_lines(lines[114:156])
    nums += _pbpvcr1i_get_nums_from_lines(lines[156:])
    assert(len(names) == len(nums))

    insert_authors(names,
                   nums,
                   'MOUNT VERNON',
                   'PUBLIC VERBAL COMMENTS (ROOM 1)')

################################################################################

def get_ordered_page_paths(root):
    return sorted(filter(lambda p: p != 'cat.txt', os.listdir(root)),
                  key = lambda p: p[-7:-4])

def ordered_pages(root):
    for path in get_ordered_page_paths(root):
        yield os.path.join(root, path)

def find_in_page_lines(term, page_lines):
    for i, line in enumerate(page_lines):
        if line.find(term) != -1:
            return i
    return -1

def automatically_parse_pages(city, section, root):
    names = list(map(lambda n: n.upper(), db[city][section]))
    nums = [None] * len(names)

    pages = {}
    for path in ordered_pages(root):
        with open(path, 'r') as f:
            pages[int(path[-7:-4])] = list(
                map(lambda l: l.strip().upper(),
                    f.readlines()))

    for i, name in enumerate(names):
        for pp in pages.keys():
            page_lines = pages[pp]
            line = find_in_page_lines(name, page_lines)
            if line != -1:
                nums[i] = pp
    
    insert_authors(names, nums, city.upper(), section.upper())

def insert_bellingham_ivc_tape_recorder():
    automatically_parse_pages(
        'Bellingham',
        'Individual Verbal Comments (Recorder)',
        'pages/bellingham/ivc_tape_recorder')

def insert_ferndale_ivc_tape_recorder():
    automatically_parse_pages(
        'Ferndale',
        'Individual Verbal Comments (Recorder)',
        'pages/ferndale/ivc_tape_recorder')

def insert_ferndale_ivc_transcriptionist():
    automatically_parse_pages(
        'Ferndale',
        'Individual Verbal Comments (Court Reporter)',
        'pages/ferndale/ivc_transcriptionist')

def insert_ferndale_pvc_room1():
    automatically_parse_pages(
        'Ferndale',
        'Public Verbal Comments (Room 1)',
        'pages/ferndale/pvc_room1')

def insert_friday_harbor_ivc_transcriptionist():
    automatically_parse_pages(
        'Friday Harbor',
        'Individual Verbal Comments (Court Reporter)',
        'pages/friday_harbor/ivc_transcriptionist')

def insert_friday_harbor_pvc_room1():
    automatically_parse_pages(
        'Friday Harbor',
        'Public Verbal Comments (Room 1)',
        'pages/friday_harbor/pvc_room1')

def insert_mount_vernon_ivc_tape_recorder():
    automatically_parse_pages(
        'Mount Vernon',
        'Individual Verbal Comments (Recorder)',
        'pages/mount_vernon/ivc_tape_recorder')

def insert_seattle_ivc_tape_recorder():
    automatically_parse_pages(
        'Seattle',
        'Individual Verbal Comments (Recorder)',
        'pages/seattle/ivc_tape_recorder')

def insert_seattle_pvc_room1():
    automatically_parse_pages(
        'Seattle',
        'Public Verbal Comments (Room 1)',
        'pages/seattle/pvc_room1')

def insert_seattle_pvc_room2():
    automatically_parse_pages(
        'Seattle',
        'Public Verbal Comments (Room 2)',
        'pages/seattle/pvc_room2')

def insert_spokane_ivc_transcriptionist():
    automatically_parse_pages(
        'Spokane',
        'Individual Verbal Comments (Court Reporter)',
        'pages/spokane/ivc_transcriptionist')

def insert_spokane_pvc_room1():
    automatically_parse_pages(
        'Spokane',
        'Public Verbal Comments (Room 1)',
        'pages/spokane/pvc_room1')

def insert_vancouver_ivc_tape_recorder():
    automatically_parse_pages(
        'Vancouver',
        'Individual Verbal Comments (Recorder)',
        'pages/vancouver/ivc_tape_recorder')

def insert_vancouver_pvc_room1():
    automatically_parse_pages(
        'Vancouver',
        'Public Verbal Comments (Room 1)',
        'pages/vancouver/pvc_room1')

def insert_vancouver_pvc_room2():
    automatically_parse_pages(
        'Vancouver',
        'Public Verbal Comments (Room 2)',
        'pages/vancouver/pvc_room2')

################################################################################


pvc_rm1_str = 'PUBLIC VERBAL COMMENTS (ROOM 1)'
pvc_rm2_str = 'PUBLIC VERBAL COMMENTS (ROOM 2)'
ivc_trans_str = 'INDIVIDUAL VERBAL COMMENTS (COURT REPORTER)'
ivc_rec_str = 'INDIVIDUAL VERBAL COMMENTS (RECORDER)'

def city_from_root(root):
    if root[6:16] == 'bellingham': return 'BELLINGHAM'
    elif root[6:14] == 'ferndale': return 'FERNDALE'
    elif root[6:19] == 'friday_harbor': return 'FRIDAY HARBOR'
    elif root[6:18] == 'mount_vernon': return 'MOUNT VERNON'
    elif root[6:13] == 'seattle': return 'SEATTLE'
    elif root[6:13] == 'spokane': return 'SPOKANE'
    elif root[6:15] == 'vancouver': return 'VANCOUVER'
    else: raise Exception('invalid root: %s' % root)

def insert_paths():
    ranges = [
        ('pages/bellingham/ivc_tape_recorder', 5, 19, ivc_rec_str),
        ('pages/bellingham/pvc_room1_comments', 27, 143, pvc_rm1_str),
        ('pages/bellingham/pvc_room2_comments', 151, 300, pvc_rm2_str),
        ('pages/ferndale/ivc_tape_recorder', 5, 18, ivc_rec_str),
        ('pages/ferndale/ivc_transcriptionist', 21, 68, ivc_trans_str),
        ('pages/ferndale/pvc_room1', 71, 219, pvc_rm1_str),
        ('pages/friday_harbor/ivc_transcriptionist', 5, 52, ivc_trans_str),
        ('pages/friday_harbor/pvc_room1', 56, 179, pvc_rm1_str),
        ('pages/mount_vernon/ivc_tape_recorder', 4, 7, ivc_rec_str),
        ('pages/mount_vernon/ivc_transcriptionist_comments', 12, 55,
         ivc_trans_str),
        ('pages/mount_vernon/pvc_room1_comments', 60, 173, pvc_rm1_str),
        ('pages/seattle/ivc_tape_recorder', 4, 18, ivc_rec_str),
        ('pages/seattle/pvc_room1', 21, 129, pvc_rm1_str),
        ('pages/seattle/pvc_room2', 135, 245, pvc_rm2_str),
        ('pages/spokane/ivc_transcriptionist', 6, 61, ivc_trans_str),
        ('pages/spokane/pvc_room1', 96, 194, pvc_rm1_str),
        ('pages/vancouver/ivc_tape_recorder', 4, 12, ivc_rec_str),
        ('pages/vancouver/pvc_room1', 16, 145, pvc_rm1_str),
        ('pages/vancouver/pvc_room2', 150, 260, pvc_rm2_str)
    ]

    cmd = "insert into paths values (NULL, '%s', '%s', %d, '%s');"

    with sqlite3.connect('coaltrain.db') as conn:
        c = conn.cursor()
        for root, low, high, section in ranges:
            for pp in range(low, high + 1):
                c.execute(cmd % (city_from_root(root),
                                 section,
                                 pp,
                                 os.path.join(root, '%03d.txt' % pp)))
        
     
