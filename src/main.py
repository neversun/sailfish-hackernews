import pyotherside
import PIL
from firebase import firebase


firebase = firebase.FirebaseApplication('https://hacker-news.firebaseio.com', None)


def getNewstories():
    newstories = firebase.get('/v0/newstories', None)

    results = []
    newstory = ''

    # this is super slow. takes about 1s per request
    for newstory in newstories:
        print(newstory)
        newstory = str(newstory)

        story = firebase.get('/v0/item/'+newstory, None)
        if story:
            results.append(story)

    print(results)

    return results
