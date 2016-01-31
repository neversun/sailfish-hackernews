import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: webview

  // property from lower stack page
  property string url

  SilicaWebView {
    PullDownMenu {
      MenuItem {
        text: "Back"
        onClicked: pageStack.pop()
      }

      MenuItem {
        text: "Open in browser"
        onClicked: {
          Qt.openUrlExternally(url)
          pageStack.pop();
        }
      }
    }
    anchors.fill: parent
    url: webview.url
  }
}
