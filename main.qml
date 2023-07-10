import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQml.Models 2.15

Window {
    visible: true
    width: 1920
    height: 720
    title: qsTr("Hello World")

    property var fileLists : []
    Item {
        id:fileSelectArea
        anchors.top: parent.top
        anchors.left: parent.left
        width : 400
        height : parent.height

        Button {
            id:selectButton
            anchors.top:parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            text:"File Select"
            height:30
            onClicked: {
                fileDialog.open()
            }
        }

        Button {
            id:clearButton
            anchors.top:parent.top
            anchors.topMargin: 10
            anchors.left: selectButton.right
            anchors.leftMargin: 10
            text:"Clear"
            height:30
            onClicked: {
                fileModel.clear()
                image.source = ""
            }
        }

        Text {
            id:fileListText
            text:"File List"
            height:20
            width:380
            anchors.top: selectButton.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        Rectangle {
            anchors.fill: fileList
            border.color: "black"
        }

        ListView {
            id:fileList
            width:380
            height:610
            anchors.top: fileListText.bottom
            anchors.left: parent.left
            anchors.leftMargin: 10
            highlight: Rectangle { width:fileList.width; color: "lightsteelblue"; radius: 1 }
            highlightMoveDuration: 0
            focus: true
            model:ListModel {
                id:fileModel
            }
            delegate: Item {
                width:fileList.width
                height:20
                Button {
                    width:fileList.width
                    height:20
                    flat:true
                    text: name
                    onClicked: {
                        fileList.currentIndex = index
                        image.source = path
                    }
                }
            }

            clip: true
            DropArea {
                id:dropArea
                anchors.fill: parent

                onDropped: {
                    console.log(drop.urls);
                    addFiles(drop.urls);
                }
            }
        }
    }

    Item {
        id : imageArea
        anchors.left: fileSelectArea.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        width:1400
        height:700

        Text {
            id:imageview
            text:"ASTC Image"
            height:20
            width:380
            y: 50
            x: 0
        }

        Rectangle {
            id:imageRectangle
            width : parent.width
            height : 610
            anchors.top:  imageview.bottom
            border.color: "black"

            Image {
                id: image
                width:parent.width
                height:parent.height
                anchors.centerIn: imageRectangle
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: StandardPaths.writableLocation(StandardPaths.HomeLocation)
        visible: false
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            console.log("You chose: " + fileDialog.files)
            addFiles(fileDialog.files)
        }
        onRejected: {
            console.log("Canceled")
        }
    }

   function addFiles(files) {
       if (files.length <= 0) {
           return
       }

       files.forEach(function(element){
           let filePath = element

           fileModel.append({"name":filePath.split("/").pop(), "path":filePath})
       })

       image.source = files[0]
   }
}
