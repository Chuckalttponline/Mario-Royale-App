#Requires AutoHotkey v2.0 ;Tells the AHK interpreter that we're using v2.
#SingleInstance Force
#Include WebViewToo.ahk   ;Includes this class into our script
#NoTrayIcon


MyMenu := Menu()
MyMenu.Add("Retun to Home menu (Ctrl+R|F5)", (*) => MyWindow.Reload())
MyMenu.Add("Full Screen (Alt+Enter|F11)", (*) => FullScreen())
MyMenu.Add()
MyMenu.Add("Allow Update (Clear cache)", (*) => ClearCache())
MyMenu.Add()
MyMenu.Add("Exit (Alt+F4)", (*) => ExitApp())






Main := Gui("+Resize", "Mario Royale")
Main.Opt("-Resize -Caption")
Main.Show("x0 y0 w" A_ScreenWidth "h" A_ScreenHeight)
Main.Onevent("Size", Gui_Size)
Main.Onevent("Close", (*) => ExitApp())

Global Toggle := false
MyWindow := WebViewToo(,,, true)
MyWindow.Load("https://marioroyale.com/legacy/")
MyWindow.Opt("-Resize +Parent" Main.Hwnd)
MyWindow.Show("x-1 y-1 w" A_ScreenWidth +2 "h" A_ScreenHeight +2)
MyWindow.Onevent("Close", (*) => ExitApp())

Gui_Size(GuiObj, MinMax, Width, Height) {
MyWindow.Show("x-1 y-1 w" Width +2 "h" Height +2)
}


WinActivate("ahk_id " Main.Hwnd)





#HotIf MouseIsOver("ahk_id " Main.Hwnd)

Rbutton::
{
If(WinActive("ahk_id " Main.Hwnd)) {
MyMenu.Show()
}
}

#HotIf

MouseIsOver(WinTitle) {
    MouseGetPos ,, &Win
    return WinExist(WinTitle " ahk_id " Win)
}


#HotIf WinActive("ahk_id " Main.Hwnd)



~LButton::
{
    if (A_PriorHotkey = "~LButton" and A_TimeSincePriorHotkey < 200)
    {
        FullScreen()
    }
}

!Enter::FullScreen()
F11::FullScreen()

FullScreen()
{
Global Toggle := !Toggle

If(!Toggle) {
Main.Opt("-Resize -Caption")
Main.Show("x0 y0 w" A_ScreenWidth "h" A_ScreenHeight)
}
If(Toggle) {
Main.Show("Center w1400 h700")
Main.Opt("+Resize +Caption")
}
}


!f4::
{
ExitApp
}


ClearCache()
{
MyWindow.Profile.ClearBrowsingDataAll(ClearBrowsingDataAllHandler)
ClearBrowsingDataAllHandler()
{
Run(A_ScriptName)
}
}