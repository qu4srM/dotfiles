pragma Singleton

import QtQuick
import Qt.labs.platform
import Quickshell

QtObject {
    id: root

    readonly property url home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property url data: StandardPaths.standardLocations(StandardPaths.GenericDataLocation)[0]
    readonly property url state: StandardPaths.standardLocations(StandardPaths.GenericStateLocation)[0]
    readonly property url cache: StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]
    readonly property url config: StandardPaths.standardLocations(StandardPaths.GenericConfigLocation)[0]
    //readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    //readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    //readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]

    property string assetsPath: Quickshell.shellPath("assets")
    property string scriptPath: Quickshell.shellPath("scripts")

    readonly property string imagecache: cache + "/imagecache"
    

    function stringify(path: url): string {
        return path.toString().replace(/%20/g, " ");
    }

    function expandTilde(path: string): string {
        return strip(path.replace("~", stringify(root.home)));
    }

    function shortenHome(path: string): string {
        return path.replace(strip(root.home), "~");
    }

    function strip(path: url): string {
        return stringify(path).replace("file://", "");
    }

    function mkdir(path: url): void {
        Quickshell.execDetached(["mkdir", "-p", strip(path)]);
    }

    function copy(from: url, to: url): void {
        Quickshell.execDetached(["cp", strip(from), strip(to)]);
    }
}
