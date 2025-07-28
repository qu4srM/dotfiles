pragma Singleton

import QtQuick
import Qt.labs.platform
import Quickshell

QtObject {
    id: root

    readonly property string home: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property string pictures: StandardPaths.writableLocation(StandardPaths.PicturesLocation)

    readonly property string data: homePath(StandardPaths.GenericDataLocation)
    readonly property string state: homePath(StandardPaths.GenericStateLocation)
    readonly property string cache: homePath(StandardPaths.GenericCacheLocation)
    readonly property string config: homePath(StandardPaths.GenericConfigLocation)

    readonly property string imagecache: cache + "/imagecache"
    

    function stringify(path) {
        return path.toString().replace(/%20/g, " ");
    }

    function expandTilde(path) {
        return path.replace(/^~(?=\/|$)/, home);
    }

    function shortenHome(path) {
        return path.startsWith(home) ? "~" + path.slice(home.length) : path;
    }

    function strip(url) {
        return url.toString().replace(/^file:\/\//, "").replace(/%20/g, " ");
    }

    function mkdir(path) {
        Quickshell.execDetached(["mkdir", "-p", path]);
    }

    function copy(from, to) {
        Quickshell.execDetached(["cp", strip(from), strip(to)]);
    }

    function homePath(location, subfolder) {
        return StandardPaths.writableLocation(location) + "/" + subfolder;
    }
}
