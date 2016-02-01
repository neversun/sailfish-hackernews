import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: items

  ListModel {
    id: itemsModel
    ListElement {
      name: 'New Stories'
      item: 'newstories'
    }
    ListElement {
      name: 'Top Stories'
      item: 'topstories'
    }
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
      onClicked: {
        pageStack.previousPage().clearItems();
        pageStack.previousPage().getItems(model.item);
        pageStack.previousPage().currentItemsName = model.name
        pageStack.previousPage().currentItemsIdentifier = model.item
        pageStack.navigateBack(PageStackAction.Animated);
      }

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
