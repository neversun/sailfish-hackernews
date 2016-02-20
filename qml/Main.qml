import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3


Page {
  id: main
  property string currentItemsName: 'top'
  property string currentItemsIdentifier: 'topstories'

  property bool __pushedAttached: false
  onStatusChanged: {
    if (main.status == PageStatus.Active && !__pushedAttached) {
      pageStack.pushAttached(Qt.resolvedUrl('Items.qml'));
      __pushedAttached = true;

      main.getItems('topstories', null, null);
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
    console.log(JSON.stringify(item))
    items.append(item)
  }

  ViewPlaceholder {
    anchors.fill: parent
    enabled: items.count <= 12
    BusyIndicator {
      size: BusyIndicatorSize.Large
      anchors.centerIn: parent
      running: parent.enabled
    }
  }

  SilicaListView {
    anchors.fill: parent
    model: items
    width: parent.width
    height: parent.height

    header: PageHeader {
      title: main.currentItemsName
    }

    VerticalScrollDecorator {}

    PullDownMenu {
      MenuItem {
        text: "Refresh"
        onClicked: {
          main.clearItems();
          main.getItems(main.currentItemsIdentifier);
        }
      }
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
