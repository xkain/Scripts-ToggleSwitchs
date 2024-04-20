import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQml.Models
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.ScrollViewKCM {
    id: root
    property alias switchModel: switchModel


    property string cfg_switches


    property string cfg_statusScriptEnabled: statusScriptEnabledBox.checked

    property string cfg_statusScript: checkStatusScriptText.text
    property string cfg_runStatusOnStart: runStatusScriptBox.checked
    property string cfg_updateInterval: updateIntervalSpinBox.value
    property string cfg_updateIntervalUnit: updateIntervalUnitSpinBox.value



    function setInterval() {
        if (updateIntervalUnitSpinBox.value == 1) {
            plasmoid.configuration.interval = updateIntervalSpinBox.value * 60;
        } else if (updateIntervalUnitSpinBox.value == 2) {
            plasmoid.configuration.interval = updateIntervalSpinBox.value * 60 * 60;
        } else {
            plasmoid.configuration.interval = updateIntervalSpinBox.value;
        }
    }

    onVisibleChanged: {
        if (!visible)
            switchModel.save();
    }


    ListModel {
        id: switchModel


        Component.onCompleted: { switchModel.loadString(root.cfg_switches); }


        function loadString(string) {
            clear();
            let switches = JSON.parse(string);
            switches.forEach(function(switchis) {
                addSwitch(switchis.name, switchis.switchId, switchis.isMaster, switchis.isMain, switchis.checked, switchis.defaultPosition, switchis.onScriptEnabled, switchis.offScriptEnabled, switchis.onScript, switchis.offScript, switchis.statusScriptEnabled, switchis.statusScript, switchis.runStatusOnStart, switchis.updateInterval, switchis.updateIntervalUnitl, switchis.interval
                );
            });
        }

        function addSwitch(name, switchId, isMaster, isMain, checked, defaultPosition, onScriptEnabled, offScriptEnabled, onScript, offScript, statusScriptEnabled, statusScript, runStatusOnStart, updateInterval, updateIntervalUnitl, interval) {

            append({
                "name": name, "switchId": switchId, "isMaster": isMaster, "isMain": isMain, "checked": checked, "defaultPosition": defaultPosition, "onScriptEnabled": onScriptEnabled, "offScriptEnabled": offScriptEnabled, "onScript": onScript, "offScript": offScript,
                "statusScriptEnabled": statusScriptEnabled, "statusScript": statusScript,"runStatusOnStart": runStatusOnStart, "updateInterval": updateInterval, "updateIntervalUnitl": updateIntervalUnitl,"interval": interval});
        }

        function save() {
            var switchList = [];
            for (var i = 0; i < count; ++i) {
                switchList.push(get(i));
            }
            root.cfg_switches = JSON.stringify(switchList);
        }


        property string roleLabel: ""

        function updateLabels() {
            for (var i = 0; i < count; ++i) {
                var switchis = get(i);
                if (switchis.isMaster)
                    setProperty(i, "roleLabel", "Master");
                else
                    setProperty(i, "roleLabel", "Main");
            }
        }

        onCountChanged: updateLabels()
    }

    header: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing
    }

    view: ListView {
        id: switchView
        clip: true
        reuseItems: true
        model: switchModel

        delegate: Item {
            width: switchView.width
            implicitHeight: switchDelegate.height

            Kirigami.SwipeListItem {
                id: switchDelegate
                RowLayout {
                    height: parent.height
                    spacing: Kirigami.Units.largeSpacing

                    Kirigami.ListItemDragHandle {
                        Layout.leftMargin: Kirigami.Units.largeSpacing
                        listItem: switchDelegate
                        listView: switchView
                        onMoveRequested: (oldIndex, newIndex) => {
                            switchModel.move(oldIndex, newIndex, 1);
                            switchModel.save();
                        }
                    }

                    QQC2.Label {
                        Layout.minimumWidth : 60
                        text: roleLabel
                        font.italic: true
                        font.pixelSize: 10
                    }

                    QQC2.Label {
                        Layout.fillWidth: true
                        text: name
                    }
                }

                actions: [
                    Kirigami.Action {
                        text: i18n("Edit")
                        icon.name: "edit-entry-symbolic"
                        onTriggered: editSwitchSheet.openSwitch(index)
                    },
                    Kirigami.Action {
                        text: i18n("Delete")
                        icon.name: "edit-delete-remove-symbolic"
                        onTriggered: {
                            switchModel.remove(index, 1);
                            switchModel.save();
                        }
                    }
                ]

            }
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            visible: switchModel.count === 0
            icon.name: "adjustrgb-symbolic"
            text: "No Switch"
            explanation: "Click <i>%1</i> to get started".arg(addSwitchButton.text)
        }
    }

    footer: RowLayout {
        spacing: Kirigami.Units.smallSpacing

        QQC2.Button {
            id: addSwitchButtonMaster
            Layout.leftMargin: Kirigami.Units.largeSpacing - 6
            text: "Add Switch Master…"
            icon.name: "list-add-symbolic"
            onClicked: {
                var switchId = "isMaster_" + new Date().getTime();
                switchModel.addSwitch("Nom du switch ici", switchId, true, false, false, false, false, false, "sleep 3; exit 0", "dolphin; exit 1", false, "/bin/status_script.sh", false, "2", "1", "120");
                switchModel.save();
            }
        }

        QQC2.Button {
            id: addSwitchButton
            Layout.leftMargin: Kirigami.Units.largeSpacing - 6
            text: "Add Switch…"
            icon.name: "list-add-symbolic"
            onClicked: {
                var switchId = "isMain_" + new Date().getTime();
                switchModel.addSwitch("Nom du switch ici", switchId,false, true, false, false, false, false, "dolphin; exit 1", "sleep 3; exit 0", false, "/bin/status_script.sh", false, "2", "1", "120");
                switchModel.save();
            }
        }

        Item {
            Layout.fillWidth: true
        }
    }

    Kirigami.OverlaySheet {
        id: editSwitchSheet
        property var editingSwitch: null
        width:  Kirigami.Units.gridUnit * 30
        height: editSwitchesForm.implicitHeight + Kirigami.Units.gridUnit * 25
        title: "Edit Switch"

        Kirigami.FormLayout {
            id: editSwitchesForm
            anchors.fill: parent
            //wideMode: false


            QQC2.CheckBox {
                id: swapLabelsBox
                Layout.minimumWidth: 100
                Kirigami.FormData.label: "Labels :"
                text: "Show the switch name on the top"
                Layout.fillWidth: true
                font.italic: true

                onCheckedChanged: { cfg_swapLabels = editingSwitch.name; }
            }

            QQC2.TextField {
                id: switchNameField
                Layout.fillWidth: true
                Kirigami.FormData.label: "Name :"


                onTextChanged: {
                    editSwitchSheet.editingSwitch.name = text;
                    switchModel.save();
                }
            }

            QQC2.CheckBox {
                id: defaultPositionBox
                Layout.fillWidth: true
                Kirigami.FormData.label: "Position :"
                font.italic: true
                text: "switch positon activate"
                onCheckedChanged: {
                    if (editSwitchSheet.editingSwitch) {
                        editSwitchSheet.editingSwitch.defaultPosition = checked;
                        switchModel.save();
                    }
                }
            }

            QQC2.TextField {
                id: onScriptText
                Layout.fillWidth: true
                Kirigami.FormData.label: "On-Script :"
                placeholderText: i18nc("@info:placeholder", "exemple : sleep 2; exit 0")
                onTextChanged: {
                    if (editSwitchSheet.editingSwitch) {
                        editSwitchSheet.editingSwitch.onScript = text;
                        switchModel.save();
                    }
                }
            }

            QQC2.TextField {
                id: offScriptText
                Kirigami.FormData.label: "Off-Script :"
                Layout.fillWidth: true
                placeholderText: i18nc("@info:placeholder", " exemple : sleep 1; exit 0")
                onTextChanged: {
                    if (editSwitchSheet.editingSwitch) {
                        editSwitchSheet.editingSwitch.offScript = text;
                        switchModel.save();
                    }
                }
            }

            QQC2.CheckBox {
                Layout.row: 7
                Layout.column: 1
                id: statusScriptEnabledBox
                text: i18n("Run periodically")
                onCheckedChanged: {
                    if (editSwitchSheet.editingSwitch) {
                        editSwitchSheet.editingSwitch.statusScriptEnabledBox = checked;
                        checkStatusScriptText.forceActiveFocus();
                        switchModel.save();
                    }
                }
            }

            QQC2.TextField {
                id: checkStatusScriptText
                Kirigami.FormData.label: "Script :"
                Layout.minimumWidth: 300
                enabled: statusScriptEnabledBox.checked
            }

            GridLayout {
                columns: 2
                Layout.row: 9
                Layout.column: 1
                QQC2.SpinBox {
                    Layout.row: 0
                    Layout.column: 0
                    id: updateIntervalSpinBox
                    Kirigami.FormData.label: "Run every :"

                    enabled: statusScriptEnabledBox.checked
                    stepSize: 1
                    from: 1
                    onValueModified: setInterval()
                }
                QQC2.SpinBox {
                    Layout.row: 0
                    Layout.column: 1
                    id: updateIntervalUnitSpinBox
                    enabled: statusScriptEnabledBox.checked
                    from: 0
                    to: items.length - 1
                    onValueModified: setInterval()

                    property var items: ["s", "min", "h"]

                    validator: RegularExpressionValidator {
                        regularExpression: /(s|min|h)/i
                    }

                    textFromValue: function(value) {
                        return items[value];
                    }

                    valueFromText: function(text) {
                        for (var i = 0; i < items.length; ++i) {
                            if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                return i
                        }
                        return sb.value
                    }
                }
            }
            QQC2.CheckBox {
                Layout.row: 10
                Layout.column: 1
                id: runStatusScriptBox
                text: i18n("Check status on startup")
            }

            QQC2.Button {
                id: doneButton
                Layout.fillWidth: true
                Layout.rightMargin: Kirigami.Units.largeSpacing - 2
                icon.name: "edit-delete-remove-symbolic"
                text: i18nc("@action:button", "Done")
                onClicked: {
                    switchModel.save();
                    editSwitchSheet.close();
                }
            }
        }

        onEditingSwitchChanged: {
            if (editSwitchSheet.editingSwitch) {
                switchNameField.text = editingSwitch.name;
                defaultPositionBox.checked = editingSwitch.defaultPosition;
                onScriptText.text = editingSwitch.onScript;
                offScriptText.text = editingSwitch.offScript;
                statusScriptEnabledBox.checked = editingSwitch.statusScriptEnabled;
            }
        }

        function openSwitch(index) {
            if (index >= 0 && index < switchModel.count) {
                editingSwitch = switchModel.get(index);
                editSwitchSheet.open();
            } else {
                editingSwitch = null;
                console.error("Invalid switch index:", index);
            }
        }
    }
}
