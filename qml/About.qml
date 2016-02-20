import QtQuick 2.0
import Sailfish.Silica 1.0

Page{
  id: aboutPage
  SilicaFlickable {
    id: flickerList
    anchors.fill: aboutPage
    contentHeight: content.height

    Column {
      id: content
      anchors {
        left: parent.left
        right: parent.right
        margins: Theme.paddingLarge
      }
      spacing: Theme.paddingMedium

      PageHeader {
        title: "About"
        width: parent.width
      }

      Column {
        id: portrait
        width: parent.width

        SectionHeader {
          text: 'Made by'
        }

        Label {
          text: 'neversun'
          anchors.horizontalCenter: parent.horizontalCenter
        }

        SectionHeader {
          text: 'Source'
        }

        Label {
          text: "github.com"
          font.underline: true;
          anchors.horizontalCenter: parent.horizontalCenter
          MouseArea {
            anchors.fill : parent
            onClicked: Qt.openUrlExternally("https://github.com/neversun/sailfish-hackernews")
          }
        }

        SectionHeader {
          text: 'Credits'
        }

        Label {
          wrapMode: TextEdit.WordWrap
          textFormat: Text.RichText;
          width: parent.width
          color: Theme.primaryColor
          font.pixelSize: Theme.fontSizeSmall
          onLinkActivated: {
            Qt.openUrlExternally(link)
          }
          text:  "<style>a:link { color: " + Theme.primaryColor + "; }</style>" +
          "Many thanks to <a href=\"https://github.com/dasimmet/Sailfish-Python\">dasimmet</a> for creating a  Sailfish OS Python template"
        }
      }
    }
  }
}
