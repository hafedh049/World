import json
from nltk.corpus import words

english_words = words.words()

english_words = list(filter(lambda x : len(x) in [5,6,7],english_words))

mapper = {"5":[],"6":[],"7":[]}

for word in english_words:
    mapper[str(len(word))].append(word.upper())

with open("./assets/words.json","w") as fp:
    json.dump(mapper,fp)