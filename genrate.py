import json
from nltk.corpus import words
from nltk.corpus import wordnet

english_words = words.words()

english_words = list(filter(lambda x : len(x) in [5,6,7],english_words))

mapper = {"5":[],"6":[],"7":[]}

for word in english_words:
    if not word.upper() in [x["word"] for x in mapper[str(len(word))]] and wordnet.synsets(word):
        mapper[str(len(word))].append({"word":word.upper(),"description":wordnet.synsets(word)[0].definition()})

with open("./assets/words_5.json","w") as fp:
    json.dump(mapper["5"],fp)

with open("./assets/words_6.json","w") as fp:
    json.dump(mapper["6"],fp)

with open("./assets/words_7.json","w") as fp:
    json.dump(mapper["7"],fp)