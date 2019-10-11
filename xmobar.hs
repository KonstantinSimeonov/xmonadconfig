Config { font = "xft:Monospace:pixelsize=15:bold:antialias=true"
       , additionalFonts = []
       , borderColor = "black"
       , border = TopB
       , bgColor = "black"
       , fgColor = "grey"
       , alpha = 164
       , position = Top
       , textOffset = -1
       , iconOffset = -1
       , lowerOnStart = False
       , pickBroadest = False
       , persistent = False
       , hideOnStart = False
       , iconRoot = "."
       , allDesktops = False
       , overrideRedirect = False
       , commands = [ Run Cpu
                      ["-L","3","-H","50"
                      , "--normal", "green", "--high", "red"] 10
                    , Run Battery
                      [ "-t", "<acstatus>: <left>%"
                      , "--"
                      , "-O", "AC"
                      , "-o", "Bat"
                      , "-h", "green"
                      , "-l", "red"
                      ] 10
                    , Run DynNetwork
                      [ "-t", "<dev>: <rx>/<tx> KB/s"
                      , "-L", "0", "-H", "256"
                      , "--low", "cyan"
                      , "--normal", "red"
                      , "--high", "green"
                      ] 30
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    , Run Kbd [ ("us", "<fc=#7f7fff>EN</fc>")
                              , ("bg(phonetic)", "<fc=#ffff00>BG</fc>")
                              ]
                    , Run XMonadLog
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "<fc=#ff0000>%XMonadLog%</fc> }{ %cpu% | %memory% * %swap% | <action=`nm-connection-editor`>%dynnetwork%</action> | [%kbd%] | <action=`nautilus`>[<fc=#00aa00>Files</fc>]</action> | %battery% | <fc=#ee9a00>%date%</fc> "
}
