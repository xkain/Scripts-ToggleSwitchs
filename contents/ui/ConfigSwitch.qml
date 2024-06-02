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

KCM.ScrollViewKCM {
    id: root

    property string cfg_switches: ""
    property alias switchModel: switchModel
    property int groupCounter: 1
    property int mainCounter: 1


// HACK: Present to suppress errors
    property string cfg_iconName
    property string cfg_iconNameDefault
    property string cfg_compactName
    property string cfg_compactNameDefault
    property bool cfg_boldTextCompact
    property bool cfg_boldTextCompactDefault
    property bool cfg_italicTextCompact
    property bool cfg_italicTextCompactDefault
    property string cfg_compactNameColor
    property string cfg_compactNameColorDefault
    property bool cfg_compactLabelVisible
    property bool cfg_compactLabelVisibleDefault
    property string cfg_oncompactScript
    property string cfg_oncompactScriptDefault
    property string cfg_offcompactScript
    property string cfg_offcompactScriptDefault
    property bool cfg_runStatusOnStartCompact
    property bool cfg_runStatusOnStartCompactDefault
    property bool cfg_compactDefaultPosition
    property bool cfg_compactDefaultPositionDefault
    property bool cfg_compactCustomDefaultPosition
    property bool cfg_compactCustomDefaultPositionDefault
    property string cfg_toolTipMainCompactText
    property string cfg_toolTipMainCompactTextDefault
    property string cfg_toolTipSubCompactText
    property string cfg_toolTipSubCompactTextDefault
    property bool cfg_toolTipSubCompactTextOutPut
    property bool cfg_toolTipSubCompactTextOutPutDefault
    property bool cfg_intervalRun
    property bool cfg_intervalRunDefault
    property int cfg_interval
    property int cfg_intervalDefault
    property bool cfg_startnotifOnCompact
    property bool cfg_startnotifOnCompactDefault
    property string cfg_notifTitleOnCompact
    property string cfg_notifTitleOnCompactDefault
    property string cfg_notifTextOnCompact
    property string cfg_notifTextOnCompactDefault
    property string cfg_iconOnCompact
    property string cfg_iconOnCompactDefault
    property bool cfg_startnotifOffCompact
    property bool cfg_startnotifOffCompactDefault
    property string cfg_notifTitleOffCompact
    property string cfg_notifTitleOffCompactDefault
    property string cfg_notifTextOffCompact
    property string cfg_notifTextOffCompactDefault
    property string cfg_iconOffCompact
    property string cfg_iconOffCompactDefault
    property bool cfg_switchesDefault
    property bool cfg_checked
    property bool cfg_checkedDefault

    onVisibleChanged: {
        if (!visible)
            switchModel.saveConfigurations();
    }

    ListModel {
        id: switchModel

        Component.onCompleted: {
            loadConfigurations();
            updateGridPositions();
        }

        function loadConfigurations() {
            clear();
            var dataString = root.cfg_switches.trim();
            if (dataString === "") {
                loadDefaultConfiguration();
                return;
            }
            parseConfiguration(dataString);
        }

        function parseConfiguration(dataString) {
            try {
                let configurations = JSON.parse(dataString);
                configurations.forEach(switchItem => {
                    addSwitchFromObject(switchItem);
                });
            } catch (e) {
                loadDefaultConfiguration();
            }
        }

         function loadDefaultConfiguration() {
            addSwitch(
                 i18n("Default Group Switch"), "defaultGroupSwitch", true, false,
                    "0", "0",
                    false,
                    true, false,
                    false, false,
                    "sleep 5; exit 0","sleep 5; exit 0", true,
                    true, "", false, false,
                    true, i18n("Default Group Switch"), i18n("This is the description of the Default Group Switch. Switch Groups create a new column and can control the position of all the switches that are in their column."),
                    true, true,
                    i18n("Switch activation"), i18n("This notification is displayed because the Default switch Group has been activated."), "emblem-success",
                    i18n("Switch deactivation"), i18n("This notification is displayed because the Default switch Group has been deactivated."), "emblem-remove"
            );
        }

        function addSwitchFromObject(switchItem) {
            addSwitch(
                switchItem.name, switchItem.switchId, switchItem.isGroup, switchItem.isMain,
                switchItem.rowIndex, switchItem.columnIndex,
                switchItem.checked,
                switchItem.defaultPosition, switchItem.customDefaultPosition,
                switchItem.positionByCompact, switchItem.positionByGroup,
                switchItem.onScript, switchItem.offScript, switchItem.runStatusOnStart,
                switchItem.displayName, switchItem.switchNameColor, switchItem.boldText, switchItem.italicText,
                switchItem.tooltipFullEnabled, switchItem.toolTipFullMainText, switchItem.toolTipFullSubText,
                switchItem.startnotifOn, switchItem.startnotifOff,
                switchItem.notificationTitleOn, switchItem.notificationTextOn, switchItem.iconOn,
                switchItem.notificationTitleOff, switchItem.notificationTextOff, switchItem.iconOff
            );
        }

        function addSwitch(name, switchId, isGroup, isMain,
                           rowIndex, columnIndex,
                           checked,
                           defaultPosition, customDefaultPosition,
                           positionByCompact, positionByGroup,
                           onScript, offScript, runStatusOnStart,
                           displayName, switchNameColor, boldText, italicText,
                           tooltipFullEnabled, toolTipFullMainText, toolTipFullSubText,
                           startnotifOn, startnotifOff,
                           notificationTitleOn, notificationTextOn, iconOn,
                           notificationTitleOff, notificationTextOff, iconOff
        ) {



            append({
                "name": name, "switchId": switchId, "isGroup": isGroup, "isMain": isMain,
                "rowIndex": Number(rowIndex), "columnIndex": Number(columnIndex),
                "checked": checked,
                "defaultPosition": defaultPosition, "customDefaultPosition": customDefaultPosition,
                "positionByCompact": positionByCompact, "positionByGroup": positionByGroup,
                "onScript": onScript, "offScript": offScript, "runStatusOnStart": runStatusOnStart,
                "displayName": displayName, "switchNameColor": switchNameColor, "boldText": boldText, "italicText": italicText,
                "tooltipFullEnabled": tooltipFullEnabled, "toolTipFullMainText": toolTipFullMainText, "toolTipFullSubText": toolTipFullSubText,
                "startnotifOn": startnotifOn, "startnotifOff": startnotifOff,
                "notificationTitleOn": notificationTitleOn, "notificationTextOn": notificationTextOn, "iconOn": iconOn,
                "notificationTitleOff": notificationTitleOff, "notificationTextOff": notificationTextOff, "iconOff": iconOff
            });
        }

        function saveConfigurations() {
            var configArray = [];
            for (var i = 0; i < count; ++i) {
                configArray.push(get(i));
            }
            root.cfg_switches = JSON.stringify(configArray);
        }

        function updateGridPositions() {
            var groupColumnIndex = 0;
            var mainRowIndex = [];
            for (var i = 0; i < count; i++) {
                var item = get(i);
                if (item.isGroup) {
                    setProperty(i, "columnIndex", groupColumnIndex);
                    setProperty(i, "rowIndex", 0);
                    mainRowIndex[groupColumnIndex] = 1;
                    groupColumnIndex++;
                } else if (item.isMain) {
                    var columnIndex = groupColumnIndex - 1;
                    setProperty(i, "columnIndex", columnIndex);
                    setProperty(i, "rowIndex", mainRowIndex[columnIndex]);
                    mainRowIndex[columnIndex]++;
                }
            }
        }
    }

     function generateUniqueSwitchId(prefix) {
        var counter = prefix === "isMain" ? root.mainCounter : root.groupCounter;
        var newId = prefix + "_" + counter;
        var takenIds = getTakenSwitchIds(prefix);
        if (takenIds.length === 0) {
            return newId;
        }

        var availableId = findAvailableId(takenIds, prefix);
        if (availableId) {
            return availableId;
        }

        while (isSwitchIdTaken(newId)) {
            counter++;
            newId = prefix + "_" + counter;
        }

        if (prefix === "isMain") {
            root.mainCounter = counter + 1;
        } else {
            root.groupCounter = counter + 1;
        }

        return newId;
    }

    function getTakenSwitchIds(prefix) {
        var takenIds = [];
        for (var i = 0; i < switchModel.count; ++i) {
            var switchId = switchModel.get(i).switchId;
            if (switchId.startsWith(prefix + "_")) {
                takenIds.push(parseInt(switchId.split("_")[1], 10));
            }
        }
        return takenIds.sort((a, b) => a - b);
    }

    function findAvailableId(takenIds, prefix) {
        for (var i = 1; i <= takenIds[takenIds.length - 1]; i++) {
            if (!takenIds.includes(i)) {
                return prefix + "_" + i;
            }
        }
        return null;
    }

    function isSwitchIdTaken(id) {
        for (var i = 0; i < switchModel.count; ++i) {
            if (switchModel.get(i).switchId === id) {
                return true;
            }
        }
        return false;
    }

    view: ListView {
        id: switchView
        clip: true
        reuseItems: true
        model: switchModel
        spacing: 1

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
                            switchModel.updateGridPositions();
                            switchModel.saveConfigurations();
                        }
                    }

                    QQC2.Label {
                        Layout.minimumWidth: isMain ? 70 : 50
                        font.italic: true
                        font.pixelSize: 10
                    }

                    QQC2.Label {
                        Layout.fillWidth: true
                            text:  name
                        font.bold : isGroup
                    }
                }

                actions: [
                    Kirigami.Action {
                        text: i18n("Edit")
                        icon.name: "edit-entry-symbolic"
                        onTriggered: {
                            editSwitchSheetLoader.item.openSwitch(index)
                           //onTriggered: editSwitchSheet.openSwitch(index)
                        }
                    },
                    Kirigami.Action {
                        text: i18n("Delete")
                        icon.name: "edit-delete-remove-symbolic"
                        visible: model.switchId !== "defaultGroupSwitch"
                        onTriggered: {
                            switchModel.remove(index, 1);
                            switchModel.updateGridPositions();
                            switchModel.saveConfigurations();
                        }
                    }
                ]
            }
        }
    }

    footer: RowLayout {
        spacing: Kirigami.Units.mediumSpacing
        anchors.fill: parent

        QQC2.Button {
            id: addSwitchButtonGroup
            Layout.leftMargin: Kirigami.Units.largeSpacing - 6
            text: i18n("Add Switch Group…")
            icon.name: "list-add-symbolic"
            onClicked: {
                var switchId = generateUniqueSwitchId("isGroup");
                var suffix = switchId.split('_')[1];
                var fullName = `${i18n("Group")} ${suffix}`;

                switchModel.addSwitch(
                    fullName, switchId, true, false,
                    "0", "0",
                    false,
                    true, false,
                    false, false,
                    "sleep 5; exit 0", "sleep 5; exit 0", false,
                    true, "", true, false,
                    false, fullName, i18n("This is the description of the Group Switch. Switch Groups create a new column and can control the position of all the switches that are in their column."),
                    false, false,
                    i18n("Switch activation"), i18n("This notification is displayed because the switch Group has been activated."), "emblem-success",
                    i18n("Switch deactivation"), i18n("This notification is displayed because the switch Group has been deactivated."), "emblem-remove"
                );
                switchModel.updateGridPositions();
                switchModel.saveConfigurations();
            }
        }

        QQC2.Button {
            id: addSwitchButton
            Layout.leftMargin: Kirigami.Units.largeSpacing - 6
            text: i18n("Add Switch…")
            icon.name: "list-add-symbolic"
            onClicked: {
                var switchId = generateUniqueSwitchId("isMain");
                var suffix = switchId.split('_')[1];
                var fullName = `${i18n("Switch")} ${suffix}`;

                switchModel.addSwitch(
                    fullName, switchId, false, true,
                    "0", "0",
                    false,
                    true, false,
                    false, true,
                    "sleep 5; exit 1", "sleep 5; exit 0", false,
                    true, "", false, true,
                    true, fullName, i18n("This is the description of a normal Switch. It is always placed below a Switch Group, and its activation can be controlled by a Switch Group."),
                                      false, false,
                                      i18n("Switch activation"), i18n("This notification is displayed because the switch has been activated."), "emblem-success",
                                      i18n("Switch deactivation"), i18n("This notification is displayed because the switch has been deactivated."), "emblem-remove"
                );
                switchModel.updateGridPositions();
                switchModel.saveConfigurations();
            }
        }

        Item {
            Layout.fillWidth: true
        }
    }

     Loader {
    		id: editSwitchSheetLoader
                source: "EditSwitchDialog.qml"
                width:  Kirigami.Units.gridUnit * 30
                height: editSwitchesForm.implicitHeight + Kirigami.Units.gridUnit * 30
    	}
}



