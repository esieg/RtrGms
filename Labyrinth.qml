import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

pragma ComponentBehavior: Bound

Item {
    id: labyrinth

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    // define functions
    function resetGame() {
    }
}
