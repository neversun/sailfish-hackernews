import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

ApplicationWindow {
    id: root
    allowedOrientations: Orientation.All

    cover: Qt.resolvedUrl("Cover.qml")
    Python {
        id: py
        Component.onCompleted: {
            py.addImportPath(Qt.resolvedUrl('../src'));
            py.importModule_sync("os")

            py.addImportPath(Qt.resolvedUrl('../src/pyPackages/requests-noarch'));
            py.addImportPath(Qt.resolvedUrl('../src/pyPackages/python_firebase-noarch'));

            py.importModule('main',function(){
              pageStack.push(Qt.resolvedUrl("Main.qml"))
            })
        }
    }
}
