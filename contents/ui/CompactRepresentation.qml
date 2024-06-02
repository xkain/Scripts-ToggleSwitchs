/*
 *    SPDX-FileCopyrightText: 2012 xkain <xkain123@gmail.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only
 */
import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import org.kde.notification

RowLayout {
    id: mainItem


    Layout.minimumWidth: mainItem.implicitWidth
    Layout.minimumHeight: mainItem.implicitHeight

    PlasmaComponents3.Switch {
        id: compactSwitch
        checked: root.compactDefaultPosition ? root.Plasmoid.configuration.checked : root.customCompactChecked
        Layout.alignment: Qt.AlignHLeft | Qt.AlignVTop
        onCheckedChanged: {
            console.log("compactSwitch checked changed:", compactSwitch.checked);
            if (root.compactDefaultPosition) {
                root.Plasmoid.configuration.checked = compactSwitch.checked;
            } else {
                root.customCompactChecked = compactSwitch.checked;
            }
            root.compactAction(compactSwitch.checked);
            root.compactSwitchToggled(compactSwitch.checked);
        }
    }

    PlasmaComponents3.Label {
        id: compactLabel
        text: root.compactName
        font.bold: root.boldTextCompact
        font.italic: root.italicTextCompact
        visible: Plasmoid.configuration.compactLabelVisible
        color: root.compactNameColor ? root.compactNameColor : Kirigami.Theme.textColor
        Layout.alignment: Qt.AlignHRight | Qt.AlignVBottom
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        hoverEnabled: true

        acceptedButtons: Qt.MiddleButton
        onClicked: (mouse) => {
            if (mouse.button == Qt.MiddleButton)
                root.expanded = !root.expanded;
        }

    }
 Connections {
            target: root
            function onNewCompactDataReceived(sourceName, data) {
                if (data['exit code'] != 0) {
                    compactSwitch.checked = !compactSwitch.checked;
                    compactTimer.stop();
                } else {
                    // Si besoin, mettez à jour d'autres propriétés ou états ici
                }
            }
        }

}
