import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3


Page {
  id: main

  Component.onCompleted: {
    py.call("main.getNewstories",[], function(data) {
      if (data && data.length > 0) {
        for (var i=0; i<data.length; i++) {
          items.append(data[i]);
        }
      }
    })
  }

  Python {
    Component.onCompleted: {
      setHandler('new-story', main.appendStory)
    }

    onReceived: console.log('Unhandled event: ' + data)
  }

  ListModel {
    id: items
  }

  function appendStory(story) {
    console.log(JSON.stringify(story))
    items.append(story)
  }

  SilicaListView {
    anchors.fill: parent
    model: items
    width: parent.width
    height: parent.height

    header: PageHeader {
        title: "Stories"
    }

    delegate: ListItem {
      width: parent.width
      anchors {
        left: parent.left
        right: parent.right
      }

      Label {
        width: parent.width
        text: '#' + model.id
        font.pixelSize: Theme.fontSizeLarge
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
        horizontalAlignment: Text.AlignHCenter
      }
    }
  }
}
