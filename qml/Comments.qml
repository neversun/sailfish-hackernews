import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5


Page {
  id: comments
  allowedOrientations: Orientation.All

  property int itemID // property from lower stack page
  property string itemURL // property from lower stack page
  property string itemTitle // property from lower stack page

  function getComments() {
    py.call("main.getCommentsForItem",[itemID], {})
  }

  property bool __pushedAttached: false
  onStatusChanged: {
    if (comments.status == PageStatus.Active && !__pushedAttached) {
      __pushedAttached = true;

      comments.getComments();
    }
  }

  Python {
    Component.onCompleted: {
      setHandler('comment-downloaded', comments.appendComment)
    }
  }

  function appendComment(comment) {
    // This page is re-pushed on PageStack and all pages share the same page identifier.
    // Because of this, we need to check if current item belongs here
    if (comment.parent != comments.itemID) {
      return
    }

    if (!comment.deleted || !comment.dead) {
      commentsModel.append(comment)
    }
  }

  ListModel {
    id: commentsModel
  }

  SilicaFlickable {
    anchors.fill: parent
    width: parent.width
    height: parent.height

    ViewPlaceholder {
      id: placeholder
      anchors.fill: parent
      enabled: commentsModel.count == 0
      ProgressBar {
        indeterminate: true
        width: parent.width
        anchors.centerIn: parent
      }
    }

    SilicaListView {  
      anchors.fill: parent
      model: commentsModel
      width: parent.width
      height: parent.height
      spacing: Theme.paddingMedium

      VerticalScrollDecorator {}

      PullDownMenu {
        MenuItem {
          text: "Open article URL in Browser"
          onClicked: Qt.openUrlExternally(comments.itemURL)
        }
        MenuItem {
          text: "Open article URL in Webview"
          onClicked: pageStack.push(Qt.resolvedUrl('Webview.qml'), { url: comments.itemURL })
        }
      }

      header: Label {
        anchors {
          left: parent.left
          leftMargin: Theme.horizontalPageMargin
          right: parent.right
          rightMargin: Theme.horizontalPageMargin
        }
        text: "> " + comments.itemTitle
        font.pixelSize: Theme.fontSizeSmall

        maximumLineCount: 2
        wrapMode: Text.WordWrap
        truncationMode: TruncationMode.Fade
	
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        color: Theme.highlightColor
      }

      delegate: BackgroundItem {
        width: parent.width
        height: comment.height + info.height
        anchors {
          left: parent.left
          leftMargin: Theme.horizontalPageMargin
          right: parent.right
          rightMargin: Theme.horizontalPageMargin
        }
        onClicked: {
          if (model.kids != null) {
            pageStack.push(Qt.resolvedUrl('Comments.qml'), { itemID: model.id, itemTitle: comments.itemTitle })
          }
        }

        Label {
          id: comment
          text: "<style>a:link { color: " + Theme.primaryColor + "; }</style>" + model.text
          textFormat: Text.RichText;
          wrapMode: Text.WordWrap
          font.pixelSize: Theme.fontSizeSmall
          color: highlighted ? Theme.highlightColor : Theme.primaryColor
          horizontalAlignment: Text.AlignLeft
          anchors {
            left: parent.left
            right: parent.right
          }
          onLinkActivated: {
            pageStack.push(Qt.resolvedUrl('Webview.qml'), { url: link })
          }
        }

        Label {
          id: info
          function timestamp(unixTime) {
            var date = new Date(unixTime * 1000);
            var elapsed = Format.formatDate(date, Formatter.DurationElapsed);
            return (elapsed ? ' (' + elapsed + ')' : '');
          }

          text: {
            if (model.kids != null) {
              'by ' + model.by + timestamp(model.time) + ' | ' + model.kids.count + ' replies'
            } else {
              'by ' + model.by + timestamp(model.time);
            }
          }
          color: Theme.highlightColor
          font.pixelSize: Theme.fontSizeExtraSmall
          horizontalAlignment: Text.AlignLeft
          anchors {
            top: comment.bottom
            right: parent.right
          }
        }
      }
    }
  }
}
