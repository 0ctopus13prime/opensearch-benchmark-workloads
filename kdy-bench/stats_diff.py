import json
from prettytable import PrettyTable

def flatten(d, parent_key="", sep="."):
    items = {}
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.update(flatten(v, new_key, sep=sep))
        else:
            items[new_key] = v
    return items

s1 = "./stats1.json"
s2 = "./stats2.json"

with open(s1, 'rt') as f:
    stats1 = json.load(f)
    stats1 = stats1['nodes']
    stats1 = stats1[list(stats1.keys())[0]]['remote_vector_index_build_stats']

with open(s2, 'rt') as f:
    stats2 = json.load(f)
    stats2 = stats2['nodes']
    stats2 = stats2[list(stats2.keys())[0]]['remote_vector_index_build_stats']

stats1 = flatten(stats1)
stats2 = flatten(stats2)


# Start comparison
keys1 = sorted(list(stats1.keys()))
keys2 = sorted(list(stats2.keys()))

if keys1 != keys2:
    print("#############")
    print("[WARN] Keys are different! " + str(set(keys2).symmetric_difference(set(keys1))))
    print("#############")

target_keys = set(keys1) & set(keys2)
table = PrettyTable()
table.field_names = ["Metric", "Diff", "Stats1", "Stats2"]
for k in target_keys:
    diff = stats2[k] - stats1[k]
    table.add_row([k, diff, stats1[k], stats2[k]])
    table.add_divider()
print(table)
