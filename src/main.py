import pyotherside
import PIL
from firebase import firebase


firebase = firebase.FirebaseApplication('https://hacker-news.firebaseio.com', None)


def getItems(items, startID=None, count=None):
    items = str(items)
    if count is None:
        count = 30

    if startID is None:
        itemIDs = firebase.get('/v0/'+items, None)
    else:
        allIDs = firebase.get('/v0/'+items, None)
        for i in allIDs:
            if i < startID:
                itemIDs.append(i)
            if len(itemIDs) >= count:
                break

    itemID = None
    i = 0
    for itemID in itemIDs:
        itemID = str(itemID)

        item = firebase.get_async('/v0/item/'+itemID, None, callback=eventNewItem)

        i += 1
        if i > count:
            break


def eventNewItem(response):
    pyotherside.send('new-item', response)
