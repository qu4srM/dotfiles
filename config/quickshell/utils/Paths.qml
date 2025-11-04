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
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]

    property string assetsPath: Quickshell.shellPath("assets")
    property string scriptPath: Quickshell.shellPath("scripts")
    property string statePath: state + "/quickshell/states.json"
    property string todoPath: state + "/user/todo.json"
    property string hackingPath: state + "/Machines/"
    property string avatarPath: assetsPath + "/avatar.jpg"
    property string notificationsPath: cache + "/notifications/notifications.json"
    property string pdfImagesPath: cache + "/quickshell/pdfImages/pdf.json"

    readonly property string imagecache: cache + "/imagecache"


    function getName(path: string): string {
        let clean = strip(path);
        let file  = clean.split("/").pop();
        let base  = file.replace("-overlay", "");
        return base.split(".")[0];
    }

    function stringify(path: url): string {
        let str = path.toString();
        if (str.startsWith("root:/"))
            str = `file://${Quickshell.shellDir}/${str.slice(6)}`;
        else if (str.startsWith("/"))
            str = `file://${str}`;
        return new URL(str).pathname;
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
