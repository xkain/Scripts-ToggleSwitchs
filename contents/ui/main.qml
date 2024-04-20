import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami


PlasmoidItem {
    id: root

    readonly property var switches: JSON.parse(Plasmoid.configuration.switches)
    readonly property bool hasSwitch: switches



    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: function(sourceName, data) {
            for (var i = 0; i < root.switches.length; ++i) {
                var switchItem = root.switches[i];

                if (switchItem.switchId === sourceName) {
                    switchItem.checked = data['exit code'] === 0;
                } else {
                    if (switchItem.checked && data['exit code'] !== 0) {
                        switchItem.checked = checked;
                    }
                }
            }

            disconnectSource(sourceName);
        }

        function exec(cmd) {
            connectSource(cmd);
        }
    }

    function toggleAction(switchId, checked) {
        for (var i = 0; i < switches.length; ++i) {
            var switchItem = switches[i];
            if (switchItem.switchId === switchId) {
                if (checked) {
                    executable.exec(switchItem.onScript);
                    switchItem.checked = false;
                } else {
                    executable.exec(switchItem.offScript);
                }
                break;
            }
        }
    }


    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground

    preferredRepresentation: hasSwitch ? fullRepresentation : compactRepresentation
    fullRepresentation: Item {
        GridLayout {
            readonly property bool isVertical: {
                switch (Plasmoid.formFactor) {
                    case PlasmaCore.Types.Planar:
                    case PlasmaCore.Types.MediaCenter:
                    case PlasmaCore.Types.Application:
                        return root.height > root.width;
                    case PlasmaCore.Types.Vertical:
                        return true;
                    case PlasmaCore.Types.Horizontal:
                        return false;
                }
            }
            width:  isVertical ? root.width : implicitWidth
            height: isVertical ? implicitHeight : root.height
            flow: isVertical ? GridLayout.TopToBottom : GridLayout.TopToBottom
            columnSpacing: Kirigami.Units.smallSpacing
            rowSpacing: Kirigami.Units.smallSpacing

            Repeater {
                model: root.switches
                delegate: PlasmaComponents3.Switch {
                    id: switchItem
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    checked: modelData.defaultPosition
                    onToggled: {
                        switchItem.checked = checked;
                        root.toggleAction(modelData.switchId, switchItem.checked);
                    }
                }
            }

            PlasmaComponents3.Button {
                visible: !root.hasSwitch
                text: "Configure…"
                onClicked: Plasmoid.internalAction("configure").trigger()
            }
        }
    }
}



