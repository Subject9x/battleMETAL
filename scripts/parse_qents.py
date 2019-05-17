import re

def parse_qents(file):
    entity = None
    entity_list = []
    for line in file:
        line = line.strip()
        if not line:
            continue
        if line.startswith("//"):
            continue
        if line == "{":
            entity = {}
        elif line == "}":
            if entity:
                entity_list.append(entity)
                entity = None
        else:
            # https://stackoverflow.com/questions/9085558/python-regex-match-text-between-quotes
            strings = re.findall('"([A-Za-z0-9_\./\\-]*)"', line)
            if len(strings) == 2:
                key, value = strings
                entity[key] = value
    return entity_list


if __name__ == "__main__":
    with open("anim_test.map") as entfile:
        ents = parse_qents(entfile)
        for ent in ents:
            print(ent)

