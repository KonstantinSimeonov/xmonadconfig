import XMonad
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe)
import qualified XMonad.StackSet as W
import System.IO
import qualified Data.Map as M

altMask = mod1Mask

colorBlackAlt       = "#040404"
colorDarkGray       = "#161616"

myXPConfig :: XPConfig
myXPConfig =
    defaultXPConfig { font                  = "xft: fixed-14"
                    , bgColor               = colorBlackAlt
                    , fgColor               = "#cc2222"
                    , bgHLight              = "#5599ff"
                    , fgHLight              = colorDarkGray
                    , borderColor           = colorBlackAlt
                    , promptBorderWidth     = 0
                    , height                = 25
                    , position              = Top
                    , historySize           = 100
                    , historyFilter         = deleteConsecutive
                    }

main =
    xmonad $ docks defaultConfig
        { terminal    = "gnome-terminal"
        , borderWidth = 0
        , modMask = mod4Mask
        , manageHook = myManageHook
        , workspaces = words "1 2 3 4 5 6 7 8 9 0"
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , keys = keyBindings
        , logHook = dynamicLogString defaultPP >>= xmonadPropLog
        }

alsaGetSinkCommand = "$(pactl list short sinks | grep alsa_output | egrep -o '[0-9]+' | head -1)"
changeVolumeCommand = "pactl set-sink-volume " ++ alsaGetSinkCommand

keyBindings :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keyBindings conf@XConfig {XMonad.modMask = modm} = M.fromList $
                [ ((modm, xK_l), spawn "~/.xmonad/lock.sh")
                , ((modm, xK_Return), spawn $ XMonad.terminal conf)
                , ((modm, xK_space), sendMessage NextLayout)
                , ((modm, xK_p), spawn "rofi -show drun -show-icons")
                , ((modm, xK_t), withFocused $ windows . W.sink)
                , ((modm, xK_Left), spawn "xdotool mousemove 960 540")
                , ((modm, xK_Right), spawn "xdotool mousemove 2880 540")
                , ((shiftMask .|. modm, xK_Left), spawn "xdotool mousemove_relative -- -100 0")
                , ((shiftMask .|. modm, xK_Up), spawn "xdotool mousemove_relative -- 0 -100")
                , ((shiftMask .|. modm, xK_Right), spawn "xdotool mousemove_relative -- 100 0")
                , ((shiftMask .|. modm, xK_Down), spawn "xdotool mousemove_relative -- 0 100")
                , ((controlMask .|. altMask, xK_g), spawn "gpaste-client ui")
                , ((modm, xK_w), windowPromptGoto myXPConfig)
--                , ((0, 0xffc0), spawn $ changeVolumeCommand ++ " -10%") -- F3
--                , ((0, 0xffc1), spawn $ changeVolumeCommand ++ " +10%") -- F4
--                , ((0, 0xffbf), spawn $ "pactl set-sink-mute " ++ alsaGetSinkCommand ++ " toggle") -- F2
                , ((0, xK_Print), spawn "scrot /home/kon/Pictures/sceenshots/%m-%d-%H-%M-%Y.png")
                , ((shiftMask, xK_Print), spawn "scrot -s /home/kon/Pictures/sceenshots/%m-%d-%H-%M-%Y.png")
                , ((modm .|. shiftMask, xK_c), kill)
                ]
                ++
                [ ((modm .|. modifier, key), windows $ fn i)
                        | (i, key) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
                        , (modifier, fn) <- [(0, W.greedyView), (shiftMask, W.shift)]
                ]

matchAny :: String -> Query Bool
matchAny x = foldr ((<||>) . (=? x)) (return False) [className, title, name, role]
-- Match against @WM_NAME@.
name :: Query String
name = stringProperty "WM_CLASS"

-- Match against @WM_WINDOW_ROLE@.
role :: Query String
role = stringProperty "WM_WINDOW_ROLE"
myManageHook = mconcat [ manageDocks <+> manageHook defaultConfig, matchAny "gnome-terminal" --> doIgnore]

