import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

ApplicationWindow {
    id: root
    cover: Qt.resolvedUrl("Cover.qml")
    Python {
        id: py
        Component.onCompleted: {
            py.addImportPath(Qt.resolvedUrl('../src'));
            py.importModule_sync("os")
            if (py.evaluate("os.uname().machine") == "armv7l"){
                py.addImportPath(Qt.resolvedUrl('../src/pyPackages/pillow-armv7hl'));
                py.addImportPath(Qt.resolvedUrl('../src/pyPackages/requests-armv7hl'));
                py.addImportPath(Qt.resolvedUrl('../src/pyPackages/python_firebase-armv7hl'));
            } else {
                py.addImportPath(Qt.resolvedUrl('../src/pyPackages/pillow-i686'));
                py.addImportPath(Qt.resolvedUrl('../src/pyPackages/requests-i686'));
                py.addImportPath(Qt.resolvedUrl('../src/pyPackages/python_firebase-i686'));
            }
            py.importModule('main',function(){
              pageStack.push(Qt.resolvedUrl("Main.qml"))
            })
        }
    }
}
