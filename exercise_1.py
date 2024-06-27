import json


def word_cnt(s: str) -> dict:
    word_list = [i.lower() for i in s.split(' ')]
    result = {}
    for word in word_list:
        if word in result.keys():
            result[word] += 1
        else:
            result[word] = 1
    return result


sample_dict = word_cnt('Hello Unigap Data Engineer Course')

print(sample_dict)


def to_json(dict, path='./archive/result.json'):
    with open(path, 'w') as json_file:
        json.dump(dict, json_file, indent=4)

    print(f"Data has been written to {path}")


to_json(sample_dict)


def to_json_recursion(dict, i, limit=100):
    if i > limit:
        return
    to_json(dict, f'./archive/result{i}.json')
    to_json_recursion(dict, i+1, limit=100)


to_json_recursion(sample_dict, 1)
