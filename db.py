import sqlite3


def create_db():
    '''Create the database which will be populated by the rest of the functions
    in this module, filling it with empty tables.'''
    with sqlite3.connect('coaltrain.db') as conn:
        c = conn.cursor()
        c.execute('''
        create table authors (
            author varchar(128) primary key,
            city varchar(16),
            section varchar(64),
            int page);''')
        

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
        assert(len(page_names) == len(page_nums))
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

    with sqlite3.connect('coaltrain.db') as conn:
        c = conn.cursor()
        for name, num in zip(names, nums):
            c.execute("insert into authors values ('" +
                      name + "', 'BELLINGHAM', 'PVC_ROOM1', " + str(num) + ")")
