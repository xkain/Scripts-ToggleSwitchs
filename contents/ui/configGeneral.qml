/*
 *    SPDX-FileCopyrightText: 2012 xkain <xkain123@gmail.com>
 *
 *    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only
 */
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import QtQuick.Dialogs

import org.kde.kcmutils as KCM
import "./libconfig" as LibConfig

KCM.SimpleKCM {
    id: appearancePage

    property string cfg_compactName
    property alias cfg_boldTextCompact: boldTextCompact.checked
    property alias cfg_italicTextCompact: italicTextCompact.checked
    property alias cfg_compactNameColor: compactNameColor.text
    property alias cfg_compactLabelVisible: compactLabelVisible.checked

    property alias cfg_oncompactScript: onScriptText.text
    property alias cfg_offcompactScript: offScriptText.text
    property alias cfg_runStatusOnStartCompact: runStatusOnStartCompact.checked

    property bool cfg_compactDefaultPosition: compactDefaultPosition.currentIndex
    property bool cfg_compactCustomDefaultPosition: compactCustomDefaultPosition.currentIndex
    property int comboIndex: 0

    property alias cfg_toolTipMainCompactText: toolTipMainCompactText.text
    property alias cfg_toolTipSubCompactText: toolTipSubCompactText.text
    property alias cfg_toolTipSubCompactTextOutPut: toolTipSubCompactTextOutPut.checked
    property alias cfg_intervalRun: intervalRun.checked
    property alias cfg_interval: interval.value

    property alias cfg_startnotifOnCompact: startnotifOnCompact.checked
    property string cfg_notifTitleOnCompact: notifTitleOnCompact.text
    property string cfg_notifTextOnCompact: notifTextOnCompact.text
    property string cfg_iconOnCompact: plasmoid.configuration.iconOnCompact


    property alias cfg_startnotifOffCompact: startnotifOffCompact.checked
    property string cfg_notifTitleOffCompact: notifTitleOffCompact.text
    property string cfg_notifTextOffCompact: notifTextOffCompact.text
    property string cfg_iconOffCompact: plasmoid.configuration.iconOffCompact


    // HACK: Present to suppress errors
    property string cfg_iconName
    property string cfg_iconNameDefault
    property bool cfg_compactNameDefault
    property string cfg_boldTextCompactDefault
    property bool cfg_italicTextCompactDefault
    property string cfg_compactNameColorDefault
    property string cfg_oncompactScriptDefault
    property string cfg_offcompactScriptDefault
    property bool cfg_runStatusOnStartCompactDefault
    property bool cfg_compactDefaultPositionDefault
    property bool cfg_compactCustomDefaultPositionDefault
    property string cfg_toolTipMainCompactTextDefault
    property string cfg_toolTipSubCompactTextDefault
    property bool cfg_toolTipSubCompactTextOutPutDefault
    property bool cfg_intervalRunDefault
    property int cfg_intervalDefault
    property bool cfg_startnotifOnCompactDefault
    property string cfg_notifTitleOnCompactDefault
    property string cfg_notifTextOnCompactDefault
    property string cfg_iconOnCompactDefault
    property bool cfg_startnotifOffCompactDefault
    property string cfg_notifTitleOffCompactDefault
    property string cfg_notifTextOffCompactDefault
    property string cfg_iconOffCompactDefault
    property string cfg_switches
    property bool cfg_switchesDefault
    property bool cfg_checked
    property bool cfg_checkedDefault
    property bool cfg_compactLabelVisibleDefault

    function getPath(fileUrl) {
        // remove prefixed "file://"
        return fileUrl.toString().replace(/^file:\/\//, "");
    }

    Kirigami.FormLayout {

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Name Switch")
            Layout.fillWidth: true
        }

        Kirigami.ActionTextField {
            id: compactName
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Name :")
            text: cfg_compactName
            onTextChanged: cfg_compactName = compactName.text
            rightActions: [
                QQC2.Action {
                    icon.name: "edit-clear"
                    enabled: compactName.text !== ""
                    text: i18nc("@action:button", "Clear Name")
                    onTriggered: {
                        compactName.clear()
                        cfg_compactName = ''
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
                id: boldTextCompact
                Layout.fillWidth: true
                icon.name: "format-text-bold"
                checkable: true
            }

            QQC2.Button {
                id: italicTextCompact
                Layout.fillWidth: true
                icon.name: "format-text-italic"
                checkable: true
            }

            QQC2.TextField {
                id: compactNameColor
                Layout.fillWidth: true
                placeholderText: i18nc("@info:placeholder", "exemple : #00ff00")
                onTextChanged: cfg_compactNameColor = compactNameColor.text
            }

            ColorDialog {
                id: colorDialog
            }

            QQC2.TextField {
                Layout.fillWidth: true
                implicitWidth: 30
                background: Rectangle {
                    color: compactNameColor.text
                    radius: 4
                }
                readOnly: true
            }
        }

        QQC2.CheckBox {
            id: compactLabelVisible
            Layout.fillWidth: true
            text: i18n("Will be displayed on desktop")
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
                wrapMode: TextEdit.Wrap
                placeholderText: i18nc("@info:placeholder", "exemple : sleep 2; exit 0")
                rightActions: [
                    QQC2.Action {
                        icon.name: "edit-clear"
                        enabled: onScriptText.text !== ""
                        text: i18nc("@action:button", "Clear script")
                        onTriggered: {
                            onScriptText.clear()
                            cfg_oncompactScript = ''
                        }
                    }
                ]
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: onScriptTextDialog.open()
            }

        }

        FileDialog {
            id: onScriptTextDialog

            title: i18n("Choose script for position activated")
            currentFolder: '~/'
            nameFilters: ["Script file (*.sh)", "All files (*)"]
            onAccepted: {
                cfg_oncompactScript = getPath(onScriptTextDialog.currentFile);
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Disabled :")

            Layout.fillWidth: true
            Kirigami.ActionTextField {
                id: offScriptText
                Layout.fillWidth: true
                wrapMode: TextEdit.Wrap
                placeholderText: i18nc("@info:placeholder", "exemple : sleep 2; exit 0")
                rightActions: [
                    QQC2.Action {
                        icon.name: "edit-clear"
                        enabled: offScriptText.text !== ""
                        text: i18nc("@action:button", "Clear script")
                        onTriggered: {
                            offScriptText.clear()
                            cfg_offcompactScript = ''
                        }
                    }
                ]
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: offScriptTextDialog.open()
            }
        }

        FileDialog {
            id: offScriptTextDialog

            title: i18n("Choose script for position activated")
            currentFolder: '~/'
            nameFilters: ["Script file (*.sh)", "All files (*)"]
            onAccepted: {
                cfg_offcompactScript = getPath(offScriptTextDialog.currentFile);
            }
        }

        QQC2.CheckBox {
            Layout.fillWidth: true
            id: runStatusOnStartCompact
            text: i18n("Run script at startup")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Position")
            Layout.fillWidth: true
        }

        QQC2.Label {
            text: i18n("Position on startup :")
            Layout.fillWidth: true
        }

        QQC2.ComboBox {
            id: positionComboBox
            width: parent.width * 0.8
            model: [i18n("Remembers last position"), i18n("Disabled position"), i18n("Position activated")]
            currentIndex: comboIndex
            onCurrentIndexChanged: {
                switch (currentIndex) {
                    case 0:
                        cfg_compactDefaultPosition = true;
                        cfg_compactCustomDefaultPosition = false;
                        break;
                    case 1:
                        cfg_compactDefaultPosition = false;
                        cfg_compactCustomDefaultPosition = false;
                        break;
                    case 2:
                        cfg_compactDefaultPosition = false;
                        cfg_compactCustomDefaultPosition = true;
                        break;
                }
            }
        }

        Component.onCompleted: {
            if (plasmoid.configuration.compactDefaultPosition) {
                positionComboBox.currentIndex = 0;
            } else if (plasmoid.configuration.compactCustomDefaultPosition) {
                positionComboBox.currentIndex = 2;
            } else {
                positionComboBox.currentIndex = 1;
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("ToolTip")
            Layout.fillWidth: true
        }

        QQC2.TextField {
            id: toolTipMainCompactText
            Kirigami.FormData.label: i18nc("@title:label", "Title :")
            Layout.fillWidth: true
            wrapMode: TextEdit.Wrap
            onTextChanged: cfg_toolTipMainCompactText = toolTipMainCompactText.text;
        }

        QQC2.TextField {
            id: toolTipSubCompactText
            Kirigami.FormData.label: i18nc("@title:label", "Description :")
            Layout.fillWidth: true
            enabled: !toolTipSubCompactTextOutPut.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: cfg_toolTipSubCompactText = toolTipSubCompactText.text;
        }


        QQC2.CheckBox {
            id: toolTipSubCompactTextOutPut
            Layout.fillWidth: true
            text: i18n("Will display output script")
        }

        RowLayout {
            QQC2.CheckBox {
                id: intervalRun
                Layout.fillWidth: true
                text: i18n("Output script will refresh every :")
            }

            LibConfig.SpinBox {
                id: interval
                enabled: intervalRun.checked
                Kirigami.FormData.label: i18n("Output script will refresh every :")
                configKey: 'interval'
                suffix: i18n("ms")
                stepSize: 500
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Notifications")
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: startnotifOnCompact
            Layout.fillWidth: true
            text: i18n("Show notification when the switch becomes activated")
            icon.name: "notifications"
        }

        property string fext: "Enter text here..."

        QQC2.TextField {
            id: notifTitleOnCompact
            Kirigami.FormData.label: i18nc("@title:label", "Title :")
            Layout.fillWidth: true
            enabled: startnotifOnCompact.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: cfg_notifTitleOnCompact = notifTitleOnCompact.text;

        }

        QQC2.TextField {
            id: notifTextOnCompact
            Kirigami.FormData.label: i18nc("@title:label", "Text :")
            Layout.fillWidth: true
            enabled: startnotifOnCompact.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: cfg_notifTextOnCompact = notifTextOnCompact.text;

        }

        RowLayout {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18nc("@title:label", "Icon :")

            IconPicker {
                id: iconOnPicker
                Layout.fillWidth: true
                currentIcon: cfg_iconOnCompact
                defaultIcon: "emblem-success"
                    enabled: startnotifOnCompact.checked
                    onIconChanged: cfg_iconOnCompact = iconName
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            color: "transparent"
        }

        QQC2.CheckBox {
            id: startnotifOffCompact
            Layout.fillWidth: true
            text: i18n("Show notification when switch becomes disabled")
            icon.name: "notifications"
        }

        QQC2.TextField {
            id: notifTitleOffCompact
            Kirigami.FormData.label: i18nc("@title:label", "Title :")
            Layout.fillWidth: true
            enabled: startnotifOffCompact.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: cfg_notifTitleOffCompact = notifTitleOffCompact.text;
        }

        QQC2.TextField {
            id: notifTextOffCompact
            Kirigami.FormData.label: i18nc("@title:label", "Text :")
            Layout.fillWidth: true
            enabled: startnotifOffCompact.checked
            wrapMode: TextEdit.Wrap
            onTextChanged: cfg_notifTextOffCompact = notifTextOffCompact.text
        }

        RowLayout {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18nc("@title:label", "Icon :")

            IconPicker {
                id: iconOffPicker
                Layout.fillWidth: true
                currentIcon: cfg_iconOffCompact
                defaultIcon: "emblem-remove"
                    enabled: startnotifOffCompact.checked
                    onIconChanged: cfg_iconOffCompact = iconName
            }
        }
    }
}
