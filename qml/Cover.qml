import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
  CoverPlaceholder {
    id: placeholder
    visible: true
    Image {
      anchors.centerIn: parent
      source: "cover.png"
    }
  }
}
