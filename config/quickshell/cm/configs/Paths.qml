pragma Singleton

import QtQuick
import Qt.labs.platform
import Quickshell

QtObject {
    id: root

    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string genericCache: StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]
    readonly property string documents: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string music: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
    readonly property string videos: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]
    
    readonly property string imagecache: cache + "/imagecache"

    property string assetsPath: Quickshell.shellPath("assets")
    property string scriptPath: Quickshell.shellPath("scripts")
    property string shellConfig: config + "/cm"
    property string settingsQmlPath: Quickshell.shellPath("settings.qml")
    property string statesPath: Paths.stringify(state + "/user/states.json")
    property string materialThemePath: Paths.stringify(state + "/user/colors.json")
    property string avatarPath: Paths.stringify(assetsPath + "/avatar.jpg")
    property string notificationsPath: Paths.stringify(cache + "/notifications/notifications.json")


    Component.onCompleted: {
        //Quickshell.execDetached(["mkdir", "-p", `${shellConfig}`])
        //Quickshell.execDetached(["mkdir", "-p", `${favicons}`])
    }


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
