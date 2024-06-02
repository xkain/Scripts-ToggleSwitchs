/*
    SPDX-FileCopyrightText: 2012 xkain <xkain123@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
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

PlasmoidItem {
    id: root

    switchWidth: Kirigami.Units.gridUnit * 9.5
        switchHeight: Kirigami.Units.gridUnit * 2.5

            Layout.minimumWidth: Kirigami.Units.gridUnit * 9.5
            Layout.minimumHeight: Kirigami.Units.gridUnit * 2.5

            property var switches: JSON.parse(Plasmoid.configuration.switches || '[]')
            property bool positionByCompact: false

            property bool customCompactChecked: Plasmoid.configuration.compactCustomDefaultPosition

            Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground

            signal newDataReceived(string sourceName, var data, string switchId, bool checked)
            signal triggerDependentToggles(int indexGroupSwitch, bool checked)
            signal newCompactDataReceived(string sourceName, var data)
            signal compactSwitchToggled(bool checked)

            readonly property bool checked: Plasmoid.configuration.checked
            readonly property string oncompactScript: Plasmoid.configuration.oncompactScript
            readonly property string offcompactScript: Plasmoid.configuration.offcompactScript
            readonly property bool compactDefaultPosition: Plasmoid.configuration.compactDefaultPosition
            readonly property bool compactCustomDefaultPosition: Plasmoid.configuration.compactCustomDefaultPosition

            readonly property bool runStatusOnStartCompact: Plasmoid.configuration.runStatusOnStartCompact

            readonly property bool startnotifOnCompact: Plasmoid.configuration.startnotifOnCompact
            readonly property string notifTitleOnCompact: Plasmoid.configuration.notifTitleOnCompact
            readonly property string notifTextOnCompact: Plasmoid.configuration.notifTextOnCompact
            readonly property string iconOnCompact: Plasmoid.configuration.iconOnCompact

            readonly property bool startnotifOffCompact: Plasmoid.configuration.startnotifOffCompact
            readonly property string notifTitleOffCompact: Plasmoid.configuration.notifTitleOffCompact
            readonly property string notifTextOffCompact: Plasmoid.configuration.notifTextOffCompact
            readonly property string iconOffCompact: Plasmoid.configuration.iconOffCompact

            readonly property bool compactLabelVisible: Plasmoid.configuration.compactLabelVisible
            readonly property string compactName: Plasmoid.configuration.compactName
            readonly property string compactNameColor: Plasmoid.configuration.compactNameColor
            readonly property bool italicTextCompact: Plasmoid.configuration.italicTextCompact
            readonly property bool boldTextCompact: Plasmoid.configuration.boldTextCompact

            readonly property string toolTipSubCompactText: Plasmoid.configuration.toolTipSubCompactText
            readonly property bool toolTipSubCompactTextOutPut: Plasmoid.configuration.toolTipSubCompactTextOutPut
            readonly property int interval: Math.max(0, plasmoid.configuration.interval)
            readonly property bool intervalRun: Plasmoid.configuration.intervalRun

            property string stdout: ""

            toolTipMainText: (Plasmoid.configuration.toolTipMainCompactText && Plasmoid.configuration.toolTipMainCompactText !== "") ? Plasmoid.configuration.toolTipMainCompactText : i18n("Scripts ToggleSwitchs")
            toolTipSubText: {
                var defaultText = i18n("Configurable switches to launch scripts.");
                var configuredText = root.toolTipSubCompactText;

                if (root.toolTipSubCompactTextOutPut) {
                    if (root.stdout && root.stdout !== "") {
                        console.log("stdout content: " + root.stdout);
                        return root.stdout.trim();
                    } else {
                        if (configuredText === "") {
                            return defaultText;
                        } else {
                            return configuredText;
                        }
                    }
                } else {
                    if (configuredText === "") {
                        return defaultText;
                    } else {
                        return configuredText;
                    }
                }
            }

            Plasma5Support.DataSource {
                id: compactexecutable
                engine: "executable"
                connectedSources: []
                onNewData: function(sourceName, data) {
                    root.newCompactDataReceived(sourceName, data);
                    stdout = data['stdout'];
                    compactexecutable.disconnectSource(sourceName);
                }

                function execcompact(cmd) {
                    connectSource(cmd);
                }
            }

            Timer {
                id: compactTimer
                interval: root.interval
                repeat: root.intervalRun
                running: true
                onTriggered: {
                    console.log("Timer triggered, executing compact script");
                    compactexecutable.execcompact(oncompactScript);
                }
            }

            onIntervalChanged: {
                compactTimer.restart()
            }

            onIntervalRunChanged: {
                if (root.intervalRun) {
                    compactTimer.restart()
                }
            }

            Component.onCompleted: {
                console.log("Component completed. Initializing switch states.");
                checkInitialSwitchStates();
                if (runStatusOnStartCompact) {
                    compactTimer.start();
                } else {
                    compactTimer.stop();
                }
            }

            function compactAction(checked) {
                console.log("compactAction called with checked:", checked);
                root.stdout = ""; // Réinitialiser stdout
                if (checked) {
                    compactexecutable.execcompact(oncompactScript);
                    compactTimer.start();
                    if (startnotifOnCompact) {
                        sendNotification(myNotification, notifTitleOnCompact, notifTextOnCompact, iconOnCompact);
                    }
                } else {
                    compactexecutable.execcompact(offcompactScript);
                    compactTimer.stop();
                    if (startnotifOffCompact) {
                        sendNotification(myNotification, notifTitleOffCompact, notifTextOffCompact, iconOffCompact);
                    }
                }
                if (positionByCompact) {
                    compactSwitchToggled(checked);
                }
            }

            Notification {
                id: myNotification
                componentName: "com.xkain.Ultimat-ToggleSwitch"
                eventId: "Switch"
                title: qsTr("Loading...")
                text: i18n("The switch has been activated")
                iconName: iconOnCompact
                urgency: Notification.LowUrgency
                onClosed: console.log("Notification for Switch On closed.")
            }

            function sendNotification(notification, title, text, iconName) {
                notification.title = title;
                notification.text = text;
                notification.iconName = iconName;
                notification.sendEvent();
            }

            function checkInitialSwitchStates() {
                switches.forEach(function(switchItem, index, checked) {
                    if (switchItem.runStatusOnStart) {
                        toggleAction(switchItem.switchId, switchItem.checked);
                    }
                });
                if (runStatusOnStartCompact) {
                    compactAction(compactdefaultPosition);
                }
            }

            Plasma5Support.DataSource {
                id: executable
                engine: "executable"
                connectedSources: []

                onNewData: function(sourceName, data) {
                    var parts = sourceName.split('|');
                    var switchId = parts[0];
                    var checked = parts[1];
                    root.newDataReceived(sourceName, data, switchId, checked);
                    executable.disconnectSource(sourceName);
                }

                function exec(switchId, cmd) {
                    var commandWithId = switchId + "|" + cmd;
                    connectSource(commandWithId);
                }
            }

            function toggleAction(switchId, checked) {
                for (var i = 0; i < switches.length; ++i) {
                    if (switches[i].switchId === switchId) {
                        switches[i].checked = checked;
                        var script = checked ? switches[i].onScript : switches[i].offScript;

                        executable.exec(switchId, script);
                        if (checked && switches[i].startnotifOn) {
                            sendNotification(myNotification, switches[i].notificationTitleOn, switches[i].notificationTextOn, switches[i].iconOn);
                        } else if (!checked && switches[i].startnotifOff) {
                            sendNotification(myNotification, switches[i].notificationTitleOff, switches[i].notificationTextOff, switches[i].iconOff);
                        }
                        if (switches[i].isGroup) {
                            root.triggerDependentToggles(i, checked);
                        }
                        break;
                    }
                }
            }

            fullRepresentation: GridLayout {
                id: grid
                width: root.width

                Layout.minimumWidth: Kirigami.implicitWidth * 9
                Layout.minimumHeight: Kirigami.implicitHeight * 2
                Layout.preferredWidth: Kirigami.gridUnit * 9.5
                Layout.preferredHeight: Kirigami.gridUnit * 2.5
                Layout.maximumWidth: Kirigami.Units.gridUnit * 80
                Layout.maximumHeight: Kirigami.Units.gridUnit * 40

                Layout.fillHeight: Plasmoid.formFactor === PlasmaCore.Types.Vertical
                Repeater {
                    id: switchRepeater
                    model: root.switches
                    delegate: RowLayout {

                        width: grid.width / grid.columns
                        height: grid.height

                        Layout.column: modelData.columnIndex !== undefined ? modelData.columnIndex : 0
                        Layout.row: modelData.rowIndex !== undefined ? modelData.rowIndex : 0

                        PlasmaComponents3.Switch {
                            id: switchItem
                            Layout.alignment: Qt.AlignHLeft | Qt.AlignVCenter
                            checked: modelData.customDefaultPosition
                            onCheckedChanged: {
                                root.toggleAction(modelData.switchId, switchItem.checked);
                            }

                            PlasmaCore.ToolTipArea {
                                id: toolTipFullArea
                                width: parent.width
                                height: parent.height
                                anchors.fill: parent
                                active: modelData.tooltipFullEnabled
                                mainText: modelData.displayName ? modelData.toolTipFullMainText : ""
                                subText: modelData.toolTipFullSubText
                            }

                        }

                        PlasmaComponents3.Label {
                            id: switchLabel
                            text: modelData.displayName ? modelData.name : ""
                            font.bold: modelData.boldText
                            font.italic: modelData.italicText
                            color: modelData.switchNameColor ? modelData.switchNameColor : Kirigami.Theme.textColor
                            Layout.alignment: Qt.AlignHRight | Qt.AlignVCenter
                        }
                    }
                }

                Connections {
                    target: root
                    function onNewDataReceived(sourceName, data, switchId, checked) {
                        for (var i = 0; i < root.switches.length; ++i) {
                            if (switches[i].switchId === switchId) {
                                var switchDelegate = switchRepeater.itemAt(i).children[0];
                                if (!switchDelegate) {
                                    continue;
                                }
                                if (data['exit code'] != 0) {
                                    switchDelegate.checked = !switchDelegate.checked;
                                }
                            }
                        }
                    }
                }

                Connections {
                    target: root
                    function onTriggerDependentToggles(indexGroupSwitch, checked) {
                        for (var i = indexGroupSwitch + 1; i < root.switches.length; i++) {
                            if (switches[i].isGroup) break;
                            if (switches[i].positionByGroup) {
                                var switchDelegate = switchRepeater.itemAt(i).children[0];
                                if (switchDelegate) {
                                    switchDelegate.checked = checked;
                                    var script = checked ? switches[i].onScript : switches[i].offScript;
                                    executable.exec(switches[i].switchId, script);
                                }
                            }
                        }
                    }
                }

                Connections {
                    target: root
                    function onCompactSwitchToggled(checked) {
                        for (var i = 0; i < root.switches.length; i++) {
                            if (root.switches[i].positionByCompact) {
                                var switchDelegate = switchRepeater.itemAt(i).children[0];
                                if (switchDelegate) {
                                    switchDelegate.checked = checked;
                                }
                            }
                        }
                    }
                }
            }

            compactRepresentation: CompactRepresentation  {}
}

