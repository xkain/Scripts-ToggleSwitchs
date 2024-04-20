/*
    SPDX-FileCopyrightText: 2023 Oliver Beard <olib141@outlook.com>
    SPDX-License-Identifier: MIT
*/

import QtQuick
import org.kde.plasma.configuration

ConfigModel {

    ConfigCategory {
         name: i18n("Switch")
         icon: "adjustrgb-symbolic"
         source: "ConfigSwitch.qml"
    }

}
