/*
 * Copyright 2014 Martin Klapetek <mklapetek@kde.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtra
import QtQuick.Window 2.2

RowLayout {
    property QtObject rootItem
    property int iconSize: units.iconSizes.medium

    height: iconSize
    width: units.gridUnit * 20
    spacing: units.smallSpacing * 2
    
    TextMetrics {
        id: labelMetrics
        font: label.font
        text: "000"
    }

    PlasmaCore.IconItem {
        id: icon
        height: iconSize
        width: iconSize
        source: rootItem.icon
    }

    PlasmaComponents.ProgressBar {
        id: progressBar
        Layout.fillWidth: true
        visible: rootItem.showingProgress
        minimumValue: 0
        maximumValue: 100
        value: Number(rootItem.osdValue)
    }

    PlasmaExtra.Heading {
        id: label
        Layout.preferredWidth: rootItem.showingProgress ? labelMetrics.boundingRect.width : -1
        Layout.fillWidth: true
        Layout.fillHeight: true
        level: 3
        text: rootItem.osdValue ? rootItem.osdValue : ""
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.NoWrap
        elide: Text.ElideRight
        textFormat: Text.PlainText
    }
}
