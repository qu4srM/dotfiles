pragma Singleton
pragma ComponentBehavior: Bound

import qs
import qs.configs

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int focusTime: Config.options.time.pomodoro.focus
    property int breakTime: Config.options.time.pomodoro.breakTime
    property int longBreakTime: Config.options.time.pomodoro.longBreak
    property int cyclesBeforeLongBreak: Config.options.time.pomodoro.cyclesBeforeLongBreak
    property string alertSound: Config.options.time.pomodoro.alertSound

    property bool pomodoroRunning: Persistent.states.timer.pomodoro.running
    property bool pomodoroBreak: Persistent.states.timer.pomodoro.isBreak
    property bool pomodoroLongBreak: pomodoroBreak && (pomodoroCycle + 1 == cyclesBeforeLongBreak)
    property int pomodoroLapDuration: pomodoroLongBreak ? longBreakTime : pomodoroBreak ? breakTime : focusTime
    property int pomodoroSecondsLeft: pomodoroLapDuration
    property int pomodoroCycle: Persistent.states.timer.pomodoro.cycle

    property bool stopwatchRunning: Persistent.states.timer.stopwatch.running
    property int stopwatchTime: 0
    property int stopwatchStart: Persistent.states.timer.stopwatch.start
    property var stopwatchLaps: Persistent.states.timer.stopwatch.laps

    Component.onCompleted: {
        if (!stopwatchRunning)
            stopwatchReset()
    }

    function nowSeconds() { return Math.floor(Date.now() / 1000) }
    function now10ms() { return Math.floor(Date.now() / 10) }

    function refreshPomodoro() {
        if (nowSeconds() >= Persistent.states.timer.pomodoro.start + pomodoroLapDuration) {

            Persistent.states.timer.pomodoro.isBreak = !Persistent.states.timer.pomodoro.isBreak
            Persistent.states.timer.pomodoro.start = nowSeconds()

            let msg

            if (Persistent.states.timer.pomodoro.isBreak && (pomodoroCycle + 1 == cyclesBeforeLongBreak))
                msg = `🌿 Long break: ${Math.floor(longBreakTime/60)} minutes`
            else if (Persistent.states.timer.pomodoro.isBreak)
                msg = `☕ Break: ${Math.floor(breakTime/60)} minutes`
            else
                msg = `🔴 Focus: ${Math.floor(focusTime/60)} minutes`

            Quickshell.execDetached(["notify-send", "Pomodoro", msg, "-a", "Shell"])

            if (alertSound)
                Quickshell.execDetached(["ffplay","-nodisp","-autoexit","-loglevel","quiet",alertSound])

            if (!pomodoroBreak)
                Persistent.states.timer.pomodoro.cycle =
                    (Persistent.states.timer.pomodoro.cycle + 1) % cyclesBeforeLongBreak
        }

        pomodoroSecondsLeft =
            pomodoroLapDuration -
            (nowSeconds() - Persistent.states.timer.pomodoro.start)
    }

    Timer {
        interval: 200
        running: pomodoroRunning
        repeat: true
        onTriggered: refreshPomodoro()
    }

    function togglePomodoro() {
        Persistent.states.timer.pomodoro.running = !pomodoroRunning

        if (Persistent.states.timer.pomodoro.running)
            Persistent.states.timer.pomodoro.start =
                nowSeconds() + pomodoroSecondsLeft - pomodoroLapDuration
    }

    function addTimePomodoro(sec) {
        Persistent.states.timer.pomodoro.start += sec
        refreshPomodoro()
    }

    function removeTimePomodoro(sec) {
        Persistent.states.timer.pomodoro.start -= sec
        refreshPomodoro()
    }

    function resetPomodoro() {
        Persistent.states.timer.pomodoro.running = false
        Persistent.states.timer.pomodoro.isBreak = false
        Persistent.states.timer.pomodoro.start = nowSeconds()
        Persistent.states.timer.pomodoro.cycle = 0
        refreshPomodoro()
    }

    function refreshStopwatch() {
        stopwatchTime = now10ms() - stopwatchStart
    }

    Timer {
        interval: 10
        running: stopwatchRunning
        repeat: true
        onTriggered: refreshStopwatch()
    }

    function toggleStopwatch() {
        if (stopwatchRunning)
            Persistent.states.timer.stopwatch.running = false
        else {
            if (stopwatchTime === 0)
                Persistent.states.timer.stopwatch.laps = []

            Persistent.states.timer.stopwatch.running = true
            Persistent.states.timer.stopwatch.start = now10ms() - stopwatchTime
        }
    }

    function stopwatchReset() {
        stopwatchTime = 0
        Persistent.states.timer.stopwatch.laps = []
        Persistent.states.timer.stopwatch.running = false
    }

    function stopwatchRecordLap() {
        Persistent.states.timer.stopwatch.laps.push(stopwatchTime)
    }

}
