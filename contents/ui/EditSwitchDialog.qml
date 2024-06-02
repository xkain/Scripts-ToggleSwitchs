/*
 *    SPDX-FileCopyrightText: 2012 xkain <xkain123@gmail.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only
 */
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQml.Models
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import QtQuick.Dialogs
import "./libconfig" as LibConfig

Kirigami.PromptDialog {
    id: editSwitchSheet
    property var editingSwitch: null
    property int comboIndex: 0

    width: switchView.width - Kirigami.Units.gridUnit * 1
    height: switchView.height - Kirigami.Units.gridUnit * 1

    function getPath(fileUrl) {
        return fileUrl.toString().replace(/^file:\/\//, "");
    }

    title: i18n("Edit Switch")

    Kirigami.FormLayout {
        id: editSwitchesForm
        anchors.fill: parent

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Name Switch")
            Layout.fillWidth: true
        }

        Kirigami.ActionTextField {
            id: switchNameField
            Layout.fillWidth: true
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                editSwitchSheet.editingSwitch.name = text;
                switchModel.saveConfigurations();
            }

            rightActions: [
                Kirigami.Action {
                    icon.name: "edit-clear"
                    text: i18nc("@action:button", "Clear Name")
                    onTriggered: {
                        switchNameField.text = ""
                        switchNameField.accepted()
                    }
                }
            ]
        }

        RowLayout {
            Layout.fillWidth: true
            QQC2.Label {
                text: i18n("Options font :")
                Layout.fillWidth: true
            }

            QQC2.Button {
                id: boldTextBox
                Layout.fillWidth: true
                icon.name: "format-text-bold"
                checkable: true
                onToggled: {
                        editSwitchSheet.editingSwitch.boldText = checked;
                        switchModel.saveConfigurations();
                }
            }

            QQC2.Button {
                id: italicTextBox
                Layout.fillWidth: true
                icon.name: "format-text-italic"
                checkable: true
                onToggled: {
                        editSwitchSheet.editingSwitch.italicText = checked;
                        switchModel.saveConfigurations();
                }
            }

            QQC2.TextField {
                id: switchNameColorField
                placeholderText: i18nc("@info:placeholder", "exemple : #00ff00")
                Layout.fillWidth: true
                onTextChanged: {
                    editSwitchSheet.editingSwitch.switchNameColor = text;
                    switchModel.updateGridPositions();
                    switchModel.saveConfigurations();
                }
            }

            ColorDialog {
                id: colorDialog
                onAccepted: {
                    switchNameColorField.text = colorDialog.selectedColor
                        switchModel.updateGridPositions();
                        switchModel.saveConfigurations()
                }
            }

            QQC2.TextField {
                Layout.fillWidth: true
                implicitWidth:30
                background: Rectangle{color:switchNameColorField.text
                    radius: 4
                }
                readOnly: true
            }
        }

        QQC2.CheckBox {
            id: displayNameCheckBox
            Layout.fillWidth: true
            text: i18n("Will be displayed on desktop")
            onCheckedChanged: {
                    editSwitchSheet.editingSwitch.displayName = checked;
                    switchModel.saveConfigurations();
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Scripts")
            Layout.fillWidth: true
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Activated :")
            Layout.fillWidth: true

            Kirigami.ActionTextField {
                id: onScriptText
                Layout.fillWidth: true
                placeholderText: i18nc("@info:placeholder", "exemple : sleep 2; exit 0")
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                        editSwitchSheet.editingSwitch.onScript = text;
                        switchModel.saveConfigurations();
                }

                rightActions: [
                    Kirigami.Action {
                        icon.name: "edit-clear"
                        //visible: searchField.text !== ""
                        onTriggered: {
                            onScriptText.text = ""
                            onScriptText.accepted()
                        }
                    }
                ]
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: onScriptTextDialog.open();
            }

            FileDialog {
                id: onScriptTextDialog

                title: i18n("Choose script for position activated")
                currentFolder: '~/'
                nameFilters: ["All files (*)"]
                onAccepted: {
                    onScriptText.text = getPath(onScriptTextDialog.currentFile);
                    switchModel.updateGridPositions();
                    switchModel.saveConfigurations()
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Disabled :")
            Layout.fillWidth: true

            Kirigami.ActionTextField {
                id: offScriptText
                Layout.fillWidth: true
                placeholderText: i18nc("@info:placeholder", "exemple : sleep 2; exit 0")
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                        editSwitchSheet.editingSwitch.offScript = text;
                        switchModel.saveConfigurations();
                }

                rightActions: [
                    Kirigami.Action {
                        icon.name: "edit-clear"
                        //visible: searchField.text !== ""
                        onTriggered: {
                            offScriptText.text = ""
                            offScriptText.accepted()
                        }
                    }
                ]
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: offScriptTextDialog.open();
            }

            FileDialog {
                id: offScriptTextDialog
                title: i18n("Choose script for position activated")
                currentFolder: '~/'
                nameFilters: ["All files (*)"]
                onAccepted: {
                    offScriptText.text = getPath(offScriptTextDialog.currentFile);
                    switchModel.saveConfigurations()
                }
            }
        }

        QQC2.CheckBox {
            Layout.fillWidth: true
            id: runStatusOnStartBox
            text: i18n("Run script at startup")
            onCheckedChanged: {
                    editSwitchSheet.editingSwitch.runStatusOnStart = checked;
                    switchModel.saveConfigurations();
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Position"
            Layout.fillWidth: true
        }

        QQC2.Label {
            text: i18n("Position on startup :")
            Layout.fillWidth: true
        }

        QQC2.ComboBox {
            id: positionComboBox
            width: parent.width * 0.8
            model: [i18n("Disabled position"), i18n("Position activated")]
            onCurrentIndexChanged: {
                if (editSwitchSheet.editingSwitch) {
                    switch (currentIndex) {
                        case 0:
                            editSwitchSheet.editingSwitch.defaultPosition = false;
                            editSwitchSheet.editingSwitch.customDefaultPosition = false;
                            break;
                        case 1:
                            editSwitchSheet.editingSwitch.defaultPosition = false;
                            editSwitchSheet.editingSwitch.customDefaultPosition = true;
                            break;
                    }
                    switchModel.saveConfigurations();
                }
            }
        }

        QQC2.CheckBox {
            id: positionByCompactBox
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Follow Compact :")
            font.italic: true
            text: i18n("It will follow the position of the Compact Switch")
            onCheckedChanged: {
                    editSwitchSheet.editingSwitch.positionByCompact = checked;
                    switchModel.saveConfigurations();
            }
        }

        QQC2.CheckBox {
            id: positionByGroupBox
            Layout.fillWidth: true
            visible: editSwitchSheet.editingSwitch ? !editSwitchSheet.editingSwitch.isGroup : false
            Kirigami.FormData.label: i18n("Follow Group :")
            font.italic: true
            text: i18n("It will follow the position of the Group switch")
            onCheckedChanged: {
                    editSwitchSheet.editingSwitch.positionByGroup = checked;
                    switchModel.saveConfigurations();
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("ToolTip")
        }

        QQC2.CheckBox {
            id: tooltipFullEnabledCheckbox
            Layout.fillWidth: true
            icon.name: "dialog-information-symbolic"
            Kirigami.FormData.label: i18n("Show ToolTip :")
            text: i18n("Display a tooltip on switch when mouse hover.")
            onCheckedChanged: {
                editSwitchSheet.editingSwitch.tooltipFullEnabled = checked;
                switchModel.saveConfigurations();
            }
        }

        QQC2.TextArea {
            id: toolTipFullMainTextField
            Layout.fillWidth: true
            enabled: tooltipFullEnabledCheckbox.checked
            Kirigami.FormData.label: i18nc("@title:label", "Title :")
            wrapMode: TextEdit.Wrap
            text: switchNameField.text
            onTextChanged: {
                if (editSwitchSheet.editingSwitch) {
                    editSwitchSheet.editingSwitch.toolTipFullMainText = text;
                    switchModel.saveConfigurations();
                }
            }
        }

        QQC2.TextArea {
            id: toolTipFullSubTextField
            Layout.fillWidth: true
            enabled: tooltipFullEnabledCheckbox.checked
            Kirigami.FormData.label: i18nc("@title:label", "Description :")
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                if (editSwitchSheet.editingSwitch) {
                    editSwitchSheet.editingSwitch.toolTipFullSubText = text;
                    switchModel.saveConfigurations();
                }
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Notifications")

            Kirigami.FormData.isSection: true

        }

        QQC2.CheckBox {
            id: startnotifOnBox
            Layout.fillWidth: true
            text: i18n("Show notification when the switch becomes activated")
            icon.name: "notifications"
            onCheckedChanged: {
                    editSwitchSheet.editingSwitch.startnotifOn = checked;
                    switchModel.saveConfigurations();
            }
        }

        QQC2.TextArea {
            id: notificationTitleOnField
            Kirigami.FormData.label: i18nc("@title:label", "Title :")
            Layout.fillWidth: true
            enabled: startnotifOnBox.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                if (editSwitchSheet.editingSwitch) {
                    editSwitchSheet.editingSwitch.notificationTitleOn = text;
                    switchModel.saveConfigurations();
                }
            }
        }

        QQC2.TextArea {
            id: notificationTextOnField
            Kirigami.FormData.label: i18nc("@title:label", "Text :")
            Layout.fillWidth: true
            enabled: startnotifOnBox.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                if (editSwitchSheet.editingSwitch) {
                    editSwitchSheet.editingSwitch.notificationTextOn = text;
                    switchModel.saveConfigurations();
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18nc("@title:label", "Icon :")

            IconPicker {
                id: iconOnPicker
                Layout.fillWidth: true
                defaultIcon: "emblem-success"
                    enabled: startnotifOnBox.checked
                    onIconChanged: {
                        if (editSwitchSheet.editingSwitch) {
                            editSwitchSheet.editingSwitch.iconOn = iconName;
                            switchModel.saveConfigurations();
                        }
                    }
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            color: "transparent"
        }

        QQC2.CheckBox {
            id: startnotifOffBox
            Layout.fillWidth: true
            text: i18n("Show notification when switch becomes disabled")
            icon.name: "notifications"
            onCheckedChanged: {
                if (editSwitchSheet.editingSwitch) {
                    editSwitchSheet.editingSwitch.startnotifOff = checked;
                    switchModel.saveConfigurations();
                }
            }
        }

        QQC2.TextArea {
            id: notificationTitleOffField
            Kirigami.FormData.label: i18nc("@title:label", "Title :")
            Layout.fillWidth: true
            enabled: startnotifOffBox.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                if (editSwitchSheet.editingSwitch) {
                    editSwitchSheet.editingSwitch.notificationTitleOff = text;
                    switchModel.saveConfigurations();
                }
            }
        }

        QQC2.TextArea {
            id: notificationTextOffField
            Kirigami.FormData.label: i18nc("@title:label", "Text :")
            Layout.fillWidth: true
            enabled: startnotifOffBox.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                if (editSwitchSheet.editingSwitch) {
                    editSwitchSheet.editingSwitch.notificationTextOff = text;
                    switchModel.saveConfigurations();
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18nc("@title:label", "Icon :")

            IconPicker {
                id: iconOffPicker
                Layout.fillWidth: true
                defaultIcon: "emblem-remove"
                    enabled: startnotifOffBox.checked
                    onIconChanged: {
                        if (editSwitchSheet.editingSwitch) {
                            editSwitchSheet.editingSwitch.iconOff = iconName;
                            switchModel.saveConfigurations();
                        }
                    }
            }
        }
    }

    onEditingSwitchChanged: {
        if (editSwitchSheet.editingSwitch) {
            switchNameField.text = editingSwitch.name;
            switchNameColorField.text = editingSwitch.switchNameColor;
            displayNameCheckBox.checked = editingSwitch.displayName;
            boldTextBox.checked = editingSwitch.boldText;
            italicTextBox.checked = editingSwitch.italicText;

            onScriptText.text = editingSwitch.onScript;
            offScriptText.text = editingSwitch.offScript;
            runStatusOnStartBox.checked = editingSwitch.runStatusOnStart;
            positionByCompactBox.checked = editingSwitch.positionByCompact;
            positionByGroupBox.checked = editingSwitch.positionByGroup;

            tooltipFullEnabledCheckbox.checked = editingSwitch.tooltipFullEnabled;
            toolTipFullMainTextField.text = editingSwitch.toolTipFullMainText;
            toolTipFullSubTextField.text = editingSwitch.toolTipFullSubText;

            startnotifOnBox.checked = editingSwitch.startnotifOn;
            notificationTitleOnField.text = editingSwitch.notificationTitleOn;
            notificationTextOnField.text = editingSwitch.notificationTextOn;
            iconOnPicker.currentIcon = editingSwitch.iconOn;
            startnotifOffBox.checked = editingSwitch.startnotifOff;
            notificationTitleOffField.text = editingSwitch.notificationTitleOff;
            notificationTextOffField.text = editingSwitch.notificationTextOff;
            iconOffPicker.currentIcon = editingSwitch.iconOff;

            if (editingSwitch.customDefaultPosition) {
                positionComboBox.currentIndex = 0;
            } else {
                positionComboBox.currentIndex = 1;
            }
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
