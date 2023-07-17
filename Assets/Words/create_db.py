
FILENAMES = ['data.adj', 'data.adv', 'data.noun', 'data.verb']
SQL_FILENAME = 'words.sql'
DB_FILENAME = 'words.sqlite'
EXCLUDED_WORDS_CONTAINING = ['sex', 'erotic']
EXCLUDED_DEFINITIONS_CONTAINING = ['sexual', 'erotic', 'erectile', ' raped', ' kill', 'criminal', 'terrorist', 'torture']

def read_lines():
    lines = []

    for filename in FILENAMES:
        f = open(filename)
        
        for line in f.readlines():
            lines.append( {'line':line, 'type':filename[filename.index('.')+1:]} )

        f.close()

    # filter out comments
    lines = [line for line in lines if not line['line'].startswith(' ')]

    print "Read %d entries" % (len(lines))

    return lines

def extract_word_data(line):
    words, definition = line.split('|')
    words = words.strip()
    definition = definition.strip()

    words = words.split(' ')
    words = [word for word in words if len(word) >= 3 and word.isalpha()]

    return {'words':words, 'definition':definition}

def filter_words(words, definition):
    for excluded_word in EXCLUDED_WORDS_CONTAINING:
        for word in words:
            if excluded_word.lower() in word.lower():
                #print "skipping", word
                return []

    for excluded_word in EXCLUDED_DEFINITIONS_CONTAINING:
        if excluded_word.lower() in definition.lower():
            #print "skipping", definition
            return []

    # filter out phrases (for example "ready_to_hand(p)")
    return [word for word in words if '_' not in word]

def make_data():
    word_dict = {}

    #
    # make dict of words and definitions 
    #
    for line in read_lines():
        word_type = line['type']
        word_data = extract_word_data(line['line'])

        words = word_data['words']
        definition = word_data['definition']
        filtered_words = filter_words(words, definition)

        if len(filtered_words) == 0:
            continue

        #
        # parse words and definitions, if word already parsed then add definition
        #
        for word in filtered_words:
            if word in word_dict:
                word_dict[word]['definitions'].append({'definition':definition, 'type':word_type})
            else:
                word_dict[word] = {'definitions':[{'definition':definition, 'type':word_type}]}

    #
    # make words list
    #
    words = []

    for word in word_dict.keys():
        words.append({'word':word, 'definitions':word_dict[word]['definitions']})

    #
    # sort words by length
    #
    words.sort(key=lambda word: len(word['word']))

    #
    # assign IDs
    #
    wordid = 0
    definitionid = 0

    for word in words:
        word['id'] = wordid

        for definition in word['definitions']:
            definition['id'] = definitionid
            definitionid = definitionid + 1

        wordid = wordid + 1

    return words

def make_sql(words):
    print "Creating SQL..."

    sql = []

    sql.append('CREATE TABLE word(id INTEGER PRIMARY KEY NOT NULL, word TEXT NOT NULL);\n')
    sql.append('CREATE TABLE definition(id INTEGER PRIMARY KEY NOT NULL, type TEXT NOT NULL, definition TEXT NOT NULL);\n')
    sql.append('CREATE TABLE word_definition(word_id INTEGER NOT NULL, definition_id INTEGER NOT NULL, FOREIGN KEY (word_id) REFERENCES word(id), FOREIGN KEY (definition_id) REFERENCES definition(id));\n')
    sql.append('CREATE TABLE word_length_ids(length INTEGER PRIMARY KEY NOT NULL, first_word_id INTEGER NOT NULL, last_word_id INTEGER NOT NULL);\n')
    sql.append('CREATE TABLE word_count(count INTEGER NOT NULL);\n')

    word_count = len(words)
    first_word_id = words[0]['id']
    
    for index, word in enumerate(words):
        if (index < word_count - 1 and len(words[index + 1]['word']) > len(word['word'])) or index == word_count - 1:
            last_word_id = word['id']
            sql.append( "INSERT INTO word_length_ids(length, first_word_id, last_word_id) VALUES(%d, %d, %d);\n" % (len(word['word']), first_word_id, last_word_id) )
            print "Word %s length %d" % (word['word'], len(word['word']))

            if index < word_count - 1:
                first_word_id = words[index + 1]['id']

        # word
        sql.append( "INSERT INTO word(id, word) VALUES(%d, '%s');\n" % (word['id'], word['word']) )

        # definitions
        for definition in word['definitions']:
            sql.append( "INSERT INTO definition(id, type, definition) VALUES(%d, '%s', '%s');\n" % (definition['id'], definition['type'], definition['definition'].replace("'", "''")) )
            sql.append( "INSERT INTO word_definition(word_id, definition_id) VALUES(%d, %d);\n" % (word['id'], definition['id']) )

    sql.append('INSERT INTO word_count(count) SELECT count(*) FROM word;\n')

    print "Word count: %d" % (word_count)

    return sql

def create_db():
    import subprocess, os, os.path, sys
    
    # remove current db
    subprocess.call(['rm', DB_FILENAME])

    sql = make_sql(make_data())

    print "Writing to file..."

    #
    # write to file
    #
    f = open(SQL_FILENAME, 'w')
    f.writelines(sql)
    f.close()

    print "Populating db..."

    #
    # populate db
    #
    subprocess.call("sqlite3 %s < %s" % (DB_FILENAME, SQL_FILENAME), shell=True)

create_db()
