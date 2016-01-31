import pyotherside
import PIL
from firebase import firebase


firebase = firebase.FirebaseApplication('https://hacker-news.firebaseio.com', None)


def getNewstories():
    newstories = firebase.get('/v0/newstories', None)
    newstory = None
    i = 0

    for newstory in newstories:
        newstory = str(newstory)

        story = firebase.get_async('/v0/item/'+newstory, None, callback=eventNewStory)

        i += 1

        if i > 30:
            break


def eventNewStory(response):
    pyotherside.send('new-story', response)
