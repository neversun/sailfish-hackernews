import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: items
  allowedOrientations: Orientation.All

  RemorsePopup { id: remorse }

  ListModel {
    id: itemsModel
    ListElement {
      name: 'top'
      item: 'topstories'
    }
    ListElement {
      name: 'new'
      item: 'newstories'
    }
    ListElement {
      name: 'show'
      item: 'showstories'
    }
    // Webview is not loading URLs provided by these items
    // ListElement {
    //   name: 'ask'
    //   item: 'askstories'
    // }
    ListElement {
      name: 'job'
      item: 'jobstories'
    }
  }

  function executeRemorse(modelName, modelItem) {
    remorse.execute("Waiting for current download to finish", function() { items.reloadMainWithItem(modelName, modelItem) }, 3000)
  }

  function reloadMainWithItem(modelName, modelItem) {
    if(pageStack.previousPage().currentlyDownloading) {
      executeRemorse(modelName, modelItem);
      return;
    }

    pageStack.previousPage().clearItems();
    pageStack.previousPage().getItems(modelItem, null, null);
    pageStack.previousPage().currentItemsName = modelName
    pageStack.previousPage().currentItemsIdentifier = modelItem
    pageStack.navigateBack(PageStackAction.Animated);
  }

  SilicaListView {
    anchors.fill: parent
    model: itemsModel
    width: parent.width
    height: parent.height

    header: PageHeader {
      title: "Categories"
    }

    VerticalScrollDecorator {}

    delegate: ListItem {
      width: parent.width
      anchors {
        left: parent.left
        leftMargin: Theme.horizontalPageMargin
        right: parent.right
        rightMargin: Theme.horizontalPageMargin
      }
      onClicked: { reloadMainWithItem(model.name, model.item); }

      Label {
        id: itemName
        text: model.name
        font.pixelSize: Theme.fontSizeMedium
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
        horizontalAlignment: Text.AlignLeft
        truncationMode: TruncationMode.Fade
        anchors {
          left: parent.left
          right: parent.right
        }
      }
    }
  }
}
