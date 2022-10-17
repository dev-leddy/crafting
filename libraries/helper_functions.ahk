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
