import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3


Page {
  id: main
  allowedOrientations: Orientation.All
  property string currentItemsName: 'top'
  property string currentItemsIdentifier: 'topstories'
  property bool currentlyDownloading
  property bool currentlyDownloadingMore
  property int itemsToDownloadCount: 20
  property int itemsAlreadyDownloaded: 0

  property bool __pushedAttached: false
  onStatusChanged: {
    if (main.status == PageStatus.Active && !__pushedAttached) {
      pageStack.pushAttached(Qt.resolvedUrl('Items.qml'));
      __pushedAttached = true;

      main.getItems('topstories', null, main.itemsToDownloadCount);
    }
  }

  function getItems (itemName, startID, count) {
    py.call("main.getItems",[itemName, startID, count], {})
  }

  function clearItems() {
    items.clear();
  }

  Python {
    Component.onCompleted: {
      setHandler('new-item', main.appendItem)
      setHandler('items-currently-downloading', main.setDownloadingStatus)
      setHandler('item-downloaded', main.itemDownloaded)
    }

    onReceived: console.log('Unhandled event: ' + data)
  }

  ListModel {
    id: items
  }

  function getItemsCount() {
    return items.count
  }

  function appendItem(item) {
    // console.log(JSON.stringify(item))
    items.append(item)
  }

  function setDownloadingStatus(b) {
    main.currentlyDownloading = b;

    if (!b) {
      main.currentlyDownloadingMore = false
      main.itemsAlreadyDownloaded = 0
    }
  }

  function itemDownloaded() {
    main.itemsAlreadyDownloaded = main.itemsAlreadyDownloaded + 1
  }

  SilicaFlickable {
    anchors.fill: parent
    width: parent.width
    height: parent.height

    ViewPlaceholder {
      id: placeholder
      anchors.fill: parent
      enabled: items.count == 0 || main.currentlyDownloadingMore
      Slider {
        enabled: false // user cannot interact
        handleVisible: false
        width: parent.width
        anchors.centerIn: parent
        minimumValue: 0
        maximumValue: 100
        value: { (100 / main.itemsToDownloadCount) * main.itemsAlreadyDownloaded }
      }
    }

    SilicaListView {
      id: listView
      anchors.fill: parent
      model: items
      width: parent.width
      height: parent.height

      VerticalScrollDecorator {}

      PullDownMenu {
        MenuItem {
          text: "About"
          onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
        }
        MenuItem {
          text: "Refresh"
          onClicked: {
            if (main.currentlyDownloading === true) { return }

            main.clearItems();
            main.getItems(main.currentItemsIdentifier, null, null);
          }
        }
      }

      PushUpMenu {
        MenuItem {
          text: "Load more"
          onClicked: {
            main.currentlyDownloadingMore = true
            if (main.currentlyDownloading === true) { return }

            var lastItem = items.get(items.count-1)
            // console.log(JSON.stringify(lastItem))
            main.getItems(main.currentItemsIdentifier, lastItem.id, null);
          }
        }
      }

      header: PageHeader {
        title: main.currentItemsName
      }

      delegate: ListItem {
        width: parent.width
        anchors {
          left: parent.left
          leftMargin: Theme.horizontalPageMargin
          right: parent.right
          rightMargin: Theme.horizontalPageMargin
        }
        onClicked: pageStack.push(Qt.resolvedUrl('Webview.qml'), { url: model.url})

        Label {
          id: title
          text: model.title
          font.pixelSize: Theme.fontSizeMedium
          color: highlighted ? Theme.highlightColor : Theme.primaryColor
          horizontalAlignment: Text.AlignLeft
          truncationMode: TruncationMode.Fade
          anchors {
            left: parent.left
            right: parent.right
          }
        }

        Label {
          function timestamp(unixTime) {
            var date = new Date(unixTime * 1000);
            var elapsed = Format.formatDate(date, Formatter.DurationElapsed);
            return (elapsed ? ' (' + elapsed + ')' : '');
          }

          text: model.score + ' points by ' + model.by + timestamp(model.time)
          color: Theme.highlightColor
          font.pixelSize: Theme.fontSizeExtraSmall
          horizontalAlignment: Text.AlignLeft
          anchors {
            top: title.bottom
            left: parent.left
          }
        }
      }
    }
  }
}
