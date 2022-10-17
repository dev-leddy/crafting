SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\..\libraries\helper_functions.ahk

#SingleInstance, Force
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
Gui, Font, cWhite
Gui,+AlwaysOnTop -resize

global AppTitle := "Enchantment Assistant"
global EnchantBtnLocationX := 0
global EnchantBtnLocationY := 0
global ItemToEnchantLocationX := 0
global ItemToEnchantLocationY := 0
global EnchantOverwriteBoxX := 0
global EnchantOverwriteBoxY := 0

Gui, Add, Text,,%AppTitle%

Gui, Add, Text,, Settings for Leveler:
;Leveler Buttons
Gui, Add, Button, w125 h30 gSet_EnchantBtnLocation, Enchant Btn Location
Gui, Add, Button, w125 h30 x+5 gSet_ItemToEnchantLocation, Item To Enchant Location 
Gui, Add, Button, w125 h30 x+5 gSet_EnchantOverwriteBox, Enchant Overwrite Box Loc 
;Leveler Button Labels
Gui, Add, Text, x50 w100 h30 vEnchantBtnLocationLabel, -
Gui, Add, Text, w100 h30 x+25 vItemToEnchantLocationLabel, -
Gui, Add, Text, w100 h30 x+25 vEnchantOverwriteBoxLabel, -

;Leveler Iterations
Gui, Add, Text, x10, Iterations:
Gui, Font, s10 cBlack, Segoe UI
Gui, Add, Edit, w50 h30 vIterationNumber Number, 1

Gui, Add, Button, x+240 w100 h30 gStartLevelEnchantment, Start Leveler

;Log Window
Gui, Font, s10 cWhite, Segoe UI
Gui, Add, Edit, x10 y+15 Readonly w385 h200 vDebug

;Status
Gui, Font, s18 cRed Bold, Verdana
Gui, Add, Text, w160 h30 vStatus_Text, Stopped

;Save Setings Button (he special)
Gui, Font, s10 cWhite w400, Segoe UI
Gui, Add, Button, w100 h20 x295 y10 gSet_Save, Save Settings

Gui, Color, Black
Gui, Show,, %AppTitle%

ReadSettingsIni()
log("Hello.")
return

;==============
;Button Actions
;==============
Set_EnchantBtnLocation:
    EnchantBtnLocationClicked := true
    ;GuiControl,, Set_ProspLoot_Text, Left click the pixel
return

Set_ItemToEnchantLocation:
    ItemToEnchantLocationClicked := true
    ;GuiControl,, Set_ProspLoot_Text, Left click the pixel
return

Set_EnchantOverwriteBox:
    EnchantOverwriteBoxClicked := true
    ;GuiControl,, Set_ProspLoot_Text, Left click the pixel
return

Set_Save:
    IniWrite, %EnchantBtnLocationX%, settings.ini, EnchantmentLeveling, CraftButtonLocationX
    IniWrite, %EnchantBtnLocationY%, settings.ini, EnchantmentLeveling, CraftButtonLocationY
    IniWrite, %ItemToEnchantLocationX%, settings.ini, EnchantmentLeveling, ItemLocationX
    IniWrite, %ItemToEnchantLocationY%, settings.ini, EnchantmentLeveling, ItemLocationY
    IniWrite, %EnchantOverwriteBoxX%, settings.ini, EnchantmentLeveling, EnchantOverwriteBoxLocationX
    IniWrite, %EnchantOverwriteBoxY%, settings.ini, EnchantmentLeveling, EnchantOverwriteBoxLocationY
    ReadSettingsIni()
    log("Saving settings...")
return

StartLevelEnchantment:
    LevelEnchantment()
return

StartDisenchanter:
    DisenchantItems()
return

;=========================
;Left Click Event Handler
;=========================
#If EnchantBtnLocationClicked = true
    LButton::
    MouseGetPos, EnchantBtnLocationX, EnchantBtnLocationY    
    EnchantBtnLocationClicked := false
return

#If ItemToEnchantLocationClicked = true
    LButton::
    MouseGetPos, ItemToEnchantLocationX, ItemToEnchantLocationY
    ItemToEnchantLocationClicked := false
return

#If EnchantOverwriteBoxClicked = true
    LButton::
    MouseGetPos, EnchantOverwriteBoxX, EnchantOverwriteBoxY
    EnchantOverwriteBoxClicked := false
return

;=========================
;Functions
;=========================	
LevelEnchantment(){
    WinGet, wowid, ID, World of Warcraft
    WinActivate, "World of Warcraft"
    
    log("Enchantment leveling started...") 
    Gui, Font, s18 cGreen Bold, Verdana
    GuiControl,, Status_Text, Leveling Enchantment

    Loop, %IterationNumber%{
        ;click crafting button
        MouseMove, %EnchantBtnLocationX%, %EnchantBtnLocationY%, 5
        sleepRandom(500, 1000)

        ;click item to enchant
        MouseMove, %ItemToEnchantLocationX%, %ItemToEnchantLocationY%, 5
        sleepRandom(500, 1000)

        ;click warning
        MouseMove, %EnchantOverwriteBoxX%, %EnchantOverwriteBoxY%, 5
        sleepRandom(10000, 12000)
    }

}

DisenchantItems(){
    return
}

ReadSettingsIni(){
    ;[EnchantmentLeveling] settings
    IniRead, EnchantBtnLocationX, settings.ini, EnchantmentLeveling, CraftButtonLocationX
    IniRead, EnchantBtnLocationY, settings.ini, EnchantmentLeveling, CraftButtonLocationY
    IniRead, ItemToEnchantLocationX, settings.ini, EnchantmentLeveling, ItemLocationX
    IniRead, ItemToEnchantLocationY, settings.ini, EnchantmentLeveling, ItemLocationY
    IniRead, EnchantOverwriteBoxX, settings.ini, EnchantmentLeveling, EnchantOverwriteBoxLocationX
    IniRead, EnchantOverwriteBoxY, settings.ini, EnchantmentLeveling, EnchantOverwriteBoxLocationY

    GuiControl,, EnchantBtnLocationLabel, %EnchantBtnLocationX% / %EnchantBtnLocationY%
    GuiControl,, ItemToEnchantLocationLabel, %ItemToEnchantLocationX% / %ItemToEnchantLocationY%
    GuiControl,, EnchantOverwriteBoxLabel, %EnchantOverwriteBoxX% / %EnchantOverwriteBoxY%

    ;Disenchant Settings
}

GuiClose:
ExitApp	