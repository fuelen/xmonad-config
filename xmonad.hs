import           Data.Char                    (toLower)
import           System.IO                    (hPutStrLn)
import           XMonad
import           XMonad.Config.Desktop
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops    (fullscreenEventHook)
import           XMonad.Hooks.ManageDocks     (manageDocks)
import           XMonad.Hooks.ManageHelpers   (doFullFloat, isFullscreen)
import           XMonad.Hooks.Place           (fixed, placeHook)
import           XMonad.Layout.ExcludeBorders
import           XMonad.Layout.NoBorders      (smartBorders)
import           XMonad.Util.EZConfig
import           XMonad.Util.Run              (spawnPipe)

newtype Workspace = Workspace String

formatWorkspace (Workspace name) = name

leftMouseButton = "1"

type KeyBinding = String

data ClickableWorkspace = ClickableWorkspace Workspace KeyBinding

instance Show ClickableWorkspace where
  show (ClickableWorkspace workspace keyBinding) = xmobarAction ("xdotool key " ++ keyBinding) leftMouseButton $ formatWorkspace workspace


makeWorkspaceClickable :: Int -> Workspace -> ClickableWorkspace
makeWorkspaceClickable position workspace = ClickableWorkspace workspace ("super+" ++ show position)

makeWorkspacesClickable :: [Workspace] -> [ClickableWorkspace]
makeWorkspacesClickable = zipWith makeWorkspaceClickable [1..]

myClickableWorkspaces :: [ClickableWorkspace]
myClickableWorkspaces = makeWorkspacesClickable workspaces
  where workspaces = [Workspace "browser", Workspace "editor", Workspace "chat", Workspace "other", Workspace "office"]

myManageHook = composeAll
   [ className =? "Chromium"        --> doShift (show $ myClickableWorkspaces !! 0) -- browser
   , className =? "nvim-qt"         --> doShift (show $ myClickableWorkspaces !! 1) -- editor
   , className =? "Slack"           --> doShift (show $ myClickableWorkspaces !! 2) -- chat
   , className =? "TelegramDesktop" --> doShift (show $ myClickableWorkspaces !! 2) -- chat
   , className =? "copyq"           --> doFloat
   , resource  =? "albert"          --> placeHook ( fixed (0.5,0.3) ) <+> doFloat
   , isFullscreen --> doFullFloat
   , manageDocks
   ] <+> manageHook desktopConfig

myLayoutHook = smartBorders $ excludeBorders [ExcludeClassName "albert"] $ layoutHook desktopConfig

main = do
  xmobarTopProc    <- spawnPipe "xmobar ~/.xmonad/xmobar_top.hs"
  xmobarBottomProc <- spawnPipe "xmobar ~/.xmonad/xmobar_bottom.hs"
  xmonad $ desktopConfig {
    modMask            = mod4Mask,
    terminal           = "alacritty",
    startupHook        = spawn "~/.xmonad/autostart",
    workspaces         = map show myClickableWorkspaces,
    handleEventHook    = handleEventHook desktopConfig <+> fullscreenEventHook,
    manageHook         = myManageHook,
    layoutHook         = myLayoutHook,
    focusedBorderColor = "#00b9cd",
    normalBorderColor  = "#5F5F5F",
    borderWidth        = 1,
    logHook            = dynamicLogWithPP xmobarPP
      { ppOutput = hPutStrLn xmobarTopProc -- <+> hPutStrLn(xmobarBottomProc)
                                                             ,
        ppTitle = xmobarColor "#00b9cd" "" . shorten 400,
        ppCurrent = xmobarColor "#00b9cd" "" ,
        ppHiddenNoWindows = xmobarColor "#586e75" ""
      }
                         } `additionalKeysP` [
      ("M-<F2>",                    spawn "albert toggle"),
      ("<Print>",                 spawn "flameshot gui"),
      ("<XF86AudioMute>",         spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"),
      ("<XF86AudioRaiseVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
      ("<XF86AudioLowerVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
      ("<XF86MonBrightnessDown>", spawn $ notifyBrightnessChange "brightnessctl s 1%- -m"),
      ("<XF86MonBrightnessUp>",   spawn $ notifyBrightnessChange "brightnessctl s +1% -m"),
      ("<XF86AudioMicMute>",      spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
      ("<XF86Display>",           spawn "arandr")
                                             ]

notifyBrightnessChange command = "notify-send ' ' -i notification-display-brightness -h int:value:$(" ++ command ++ " | sed -r 's/^.+,(.+)%.+$/\\1/') -h string:synchronous:brightness"
