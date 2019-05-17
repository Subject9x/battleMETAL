import re

def parse_qents(file):
    # Note that this breaks on nested entities.
    # To fix that you'll need to make it recursive.
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
            strings = find_strings(line)
            if len(strings) == 2:
                key, value = strings
                entity[key] = value
    return entity_list

def find_strings(line):
    # Doing this with regex proved too much of a pain.
    strings = []
    current_string = None
    for char in line:
        if char == '"':
            if current_string is not None:
                strings.append(current_string)
                current_string = None
            else:
                current_string = ''
        elif current_string is not None:
            current_string += char
    return strings

if __name__ == "__main__":
    with open("anim_test.map") as entfile:
        with open("anim_test.out.rlights", "w") as outfile:
            ents = parse_qents(entfile)
            for ent in ents:
                if ent["classname"] == "realtime_light":
                    prefix = "!" if ent["rtlShadows"] == "1" else ""
                    suffix = " ".join([
                            "{origin}",
                            "{rtlLight}",
                            "{color}",
                            "{rtlStyle}",
                            "\"{vec_name}\"",
                            "{rtlCorona}",
                            "{angles}",
                            "{rtlCoronaSize}",
                            "{rtlAmbient}",
                            "{rtlDiffuse}",
                            "{rtlSpecular}",
                            "{rtlMode}",
                            ]).format(**ent)
                    outfile.write(prefix + suffix + "\n")

