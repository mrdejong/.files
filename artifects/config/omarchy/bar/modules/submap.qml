import QtQuick
import Quickshell.Hyprland

Item {
    id: root

    // Injected by the Omarchy bar
    property var bar
    property string moduleName
    property var settings

    property string submap: ""

    visible: submap !== ""
    implicitWidth: visible ? label.implicitWidth + 16 : 0
    implicitHeight: bar ? bar.barSize : 26

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "submap")
                root.submap = event.data   // "" means back to default
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        radius: 4
        color: "#f5a97f"
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.submap === "group_management" ? "󰕰 GROUP" : root.submap
        color: root.bar ? root.bar.background : "black"
        font.family: root.bar ? root.bar.fontFamily : "monospace"
    }
}
