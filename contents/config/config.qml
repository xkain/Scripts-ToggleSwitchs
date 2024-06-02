/*
    SPDX-FileCopyrightText: 2012 xkain <xkain123@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import org.kde.plasma.configuration

ConfigModel {

    ConfigCategory {
         name: i18n("Compact Switch")
         icon: "configure-symbolic"
         source: "configGeneral.qml"
    }


    ConfigCategory {
         name: i18n("Extended Switches")
         icon: "adjustrgb-symbolic"
         source: "ConfigSwitch.qml"
    }

}
