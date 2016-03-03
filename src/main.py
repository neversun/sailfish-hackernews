import pyotherside
from firebase import firebase


firebase = firebase.FirebaseApplication('https://hacker-news.firebaseio.com', None)
responses = []
getItemsCount = 0
eventCount = 0
itemIDs = []


def getItems(items, startID=None, count=None):
    if items is None and startID is None and count is None:
        return

    currentlyDownloading(True)

    global getItemsCount
    global itemIDs

    items = str(items)
    if count is None:
        getItemsCount = 30
    else:
        getItemsCount = count

    if startID is None:
        itemIDs = firebase.get('/v0/'+items, None)

        if len(itemIDs) < getItemsCount:
            getItemsCount = len(itemIDs)
    else:
        allIDs = firebase.get('/v0/'+items, None)

        startIDFound = False
        for i in allIDs:
            if i == startID:
                startIDFound = True
                continue

            if startIDFound is False:
                continue

            itemIDs.append(i)
            if len(itemIDs) >= getItemsCount:
                break

    itemID = None
    i = 0
    for itemID in itemIDs:
        itemID = str(itemID)

        item = firebase.get_async('/v0/item/'+itemID, None, callback=cbNewItem)

        i += 1
        if i >= getItemsCount:
            break


def cbNewItem(response):
    global eventCount
    eventCount += 1

    bufferResponse(response)


def bufferResponse(response):
    global getItemsCount
    global eventCount
    global itemIDs
    global responses

    responses.append(response)

    # print(eventCount, getItemsCount)

    if eventCount == getItemsCount:
        orderedResponses = []
        # print(itemIDs)

        for r in responses:
            index = itemIDs.index(r['id'])
            if index is None:
                continue

            orderedResponses.insert(index, r)

        sendResponses(orderedResponses)


def sendResponses(responses):
    for r in responses:
        pyotherside.send('new-item', r)

    resetDownloader()
    currentlyDownloading(False)


def resetDownloader():
    global eventCount
    global itemIDs
    global responses
    global getItemsCount

    eventCount = 0
    itemIDs[:] = []
    responses[:] = []
    getItemsCount = 0


def currentlyDownloading(b):
    pyotherside.send('items-currently-downloading', b)
