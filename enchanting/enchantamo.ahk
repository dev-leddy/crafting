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
global OpenMailX := 0
global OpenMailY := 0
global InboxX := 0
global InboxY := 0
global MailGroupsX := 0
global MailGroupsY := 0
global MailSelectedGroupX := 0
global MailSelectedGroupY := 0

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

;Disenchant Buttons
Gui, Add, Button, w92 h30 x10 gSet_OpenMailLocation, Open Mail Location
Gui, Add, Button, w90 h30 x+5 gSet_InboxLocation, Inbox Location
Gui, Add, Button, w90 h30 x+5 gSet_GroupsLocation, Groups Location
Gui, Add, Button, w95 h30 x+5 gSet_MailSelectedLocation, Mail Selected Groups

;Disenchant Button Labels
Gui, Add, Text, x35 w70 h30 vOpenMailLocationLabel, -
Gui, Add, Text, w65 h30 x+30 vInboxLocationLabel, -
Gui, Add, Text, w70 h30 x+40 vGroupsLocationLabel, -
Gui, Add, Text, w70 h30 x+20 vMailSelectedLocationLabel, -

;Leveler Iterations
Gui, Add, Text, x10, Iterations:
Gui, Font, s10 cBlack, Segoe UI
Gui, Add, Edit, w50 h30 vIterationNumber Number, 65

Gui, Add, Button, x+240 w100 h30 gStartLevelEnchantment, Start Leveler
Gui, Add, Button, x300 w100 h30 gStartDisenchanter, Disenchant

;Log Window
Gui, Font, s10 cWhite, Segoe UI
Gui, Add, Edit, x10 y+15 Readonly w385 h200 vDebug

;Status
Gui, Font, s18 cRed Bold, Verdana
Gui, Add, Text, w350 h30 vStatus_Text, Stopped

;Save Settings Button (he special)
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
Return

Set_ItemToEnchantLocation:
    ItemToEnchantLocationClicked := true
    ;GuiControl,, Set_ProspLoot_Text, Left click the pixel
Return

Set_EnchantOverwriteBox:
    EnchantOverwriteBoxClicked := true
    ;GuiControl,, Set_ProspLoot_Text, Left click the pixel
Return

Set_OpenMailLocation:
    OpenMailLocationClicked := true
Return

Set_InboxLocation:
    InboxLocationClicked := true
Return

Set_GroupsLocation:
    GroupsLocationClicked := true
Return

Set_MailSelectedLocation:
    MailSelectedLocationClicked := true
Return


Set_Save:
    IniWrite, %EnchantBtnLocationX%, settings.ini, EnchantmentLeveling, CraftButtonLocationX
    IniWrite, %EnchantBtnLocationY%, settings.ini, EnchantmentLeveling, CraftButtonLocationY
    IniWrite, %ItemToEnchantLocationX%, settings.ini, EnchantmentLeveling, ItemLocationX
    IniWrite, %ItemToEnchantLocationY%, settings.ini, EnchantmentLeveling, ItemLocationY
    IniWrite, %EnchantOverwriteBoxX%, settings.ini, EnchantmentLeveling, EnchantOverwriteBoxLocationX
    IniWrite, %EnchantOverwriteBoxY%, settings.ini, EnchantmentLeveling, EnchantOverwriteBoxLocationY

    IniWrite, %OpenMailX%, settings.ini, Disenchanting, OpenMailLocationX
    IniWrite, %OpenMailY%, settings.ini, Disenchanting, OpenMailLocationY
    IniWrite, %InboxX%, settings.ini, Disenchanting, InboxLocationX
    IniWrite, %InboxY%, settings.ini, Disenchanting, InboxLocationY
    IniWrite, %MailGroupsX%, settings.ini, Disenchanting, MailGroupsLocationX
    IniWrite, %MailGroupsY%, settings.ini, Disenchanting, MailGroupsLocationY
    IniWrite, %MailSelectedGroupX%, settings.ini, Disenchanting, MailSelectedGroupLocationX
    IniWrite, %MailSelectedGroupY%, settings.ini, Disenchanting, MailSelectedGroupLocationY

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


#If OpenMailLocationClicked = true
    LButton::
    MouseGetPos, OpenMailX, OpenMailY
    OpenMailLocationClicked := false
return

#If InboxLocationClicked = true
    LButton::
    MouseGetPos, InboxX, InboxY
    InboxLocationClicked := false
return

#If GroupsLocationClicked = true
    LButton::
    MouseGetPos, MailGroupsX, MailGroupsY
    GroupsLocationClicked := false
return

#If MailSelectedLocationClicked = true
    LButton::
    MouseGetPos, MailSelectedGroupX, MailSelectedGroupY
    MailSelectedLocationClicked := false
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
    ;get items first!
    GetMail()
    ;send DE'd stuff!
    SendMail()

    GuiControlGet, IterationNumber
    log("Starting disenchantment loop...")

    WinGet, wowid, ID, World of Warcraft
    WinActivate, "World of Warcraft"

    GuiControl,, Status_Text, Disenchanting
    Gui, Font, s18 cBlue Bold, Verdana
    GuiControl, Font, Status_Text

    Loop, %IterationNumber% {
        if(GetKeyState("Numpad9")){
            log("Terminating disenchant loop")
            break
        }

        ControlSend,, {F9}, ahk_id %wowid%
        sleepRandom(4200, 4800)
    }

    if(true){
        DisenchantItems()
    }
    else{        
        GuiControl,, Status_Text, Stopped
        Gui, Font, s18 cRed Bold, Verdana
        GuiControl, Font, Status_Text
        return
    }    
}

GetMail(){
    log("Getting Mail...")
    MouseClick, left, %InboxX%, %InboxY%
    sleepRandom(2000, 2100)

    MouseClick, left, %OpenMailX%, %OpenMailY%
    sleepRandom(55000, 65000)
}

SendMail(){
    log("Sending Mail...")
    MouseClick, left, %MailGroupsX%, %MailGroupsY%
    sleepRandom(2000, 2100)

    Loop, 3{
        MouseClick, left, %MailSelectedGroupX%, %MailSelectedGroupY%
        sleepRandom(650, 900)
    }

    sleepRandom(7000, 8000)s
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
    IniRead, OpenMailX, settings.ini, Disenchanting, OpenMailLocationX
    IniRead, OpenMailY, settings.ini, Disenchanting, OpenMailLocationY
    IniRead, InboxX, settings.ini, Disenchanting, InboxLocationX
    IniRead, InboxY, settings.ini, Disenchanting, InboxLocationY
    IniRead, MailGroupsX, settings.ini, Disenchanting, MailGroupsLocationX
    IniRead, MailGroupsY, settings.ini, Disenchanting, MailGroupsLocationY
    IniRead, MailSelectedGroupX, settings.ini, Disenchanting, MailSelectedGroupLocationX
    IniRead, MailSelectedGroupY, settings.ini, Disenchanting, MailSelectedGroupLocationY
    GuiControl,, OpenMailLocationLabel, %OpenMailX% / %OpenMailY%
    GuiControl,, InboxLocationLabel, %InboxX% / %InboxY%
    GuiControl,, GroupsLocationLabel, %MailGroupsX% / %MailGroupsY%
    GuiControl,, MailSelectedLocationLabel, %MailSelectedGroupX% / %MailSelectedGroupY%
}

GuiClose:
ExitApp	