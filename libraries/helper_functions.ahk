log(Data)
{
    FormatTime, TimeString, R 20040228 LSys D1 D4 T0
    GuiControlGet, Debug
    GuiControl,, Debug, %TimeString% - %Data%`r`n%Debug%
}

sleepRandom(min, max)
{
    Random, rand, %min%, %max%
    Sleep, %rand%
}

class SecondCounter {
    __New() {
        this.interval := 1000
        this.count := 0
        ; Tick() has an implicit parameter "this" which is a reference to
        ; the object, so we need to create a function which encapsulates
        ; "this" and the method to call:
        this.timer := ObjBindMethod(this, "Tick")
    }
    Start() {
        ; Known limitation: SetTimer requires a plain variable reference.
        timer := this.timer
        SetTimer % timer, % this.interval
        return % "Counter started"
    }
    Stop() {
        ; To turn off the timer, we must pass the same object as before:
        timer := this.timer
        SetTimer % timer, Off
        return % "Counter stopped at " this.count
    }
    ; In this example, the timer calls this method:
    Tick() {
        return % ++this.count
    }
}