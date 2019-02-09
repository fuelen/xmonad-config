--, additionalFonts    = ["xft:Raleway:size=12:antialias=true:hinting=true", "xft:Inconsolata for Powerline:size=12:antialias=true:hinting=true"]

Config
    { font              = "xft:xos4 Terminus:pixelsize=16:antialias=true:hinting=true"
    , additionalFonts   = [ "xft:Font Awesome 5 Free:style=solid:pixelsize=14:antialias=true:hinting=true" ]
    , allDesktops       = True
    , bgColor           = "#000000"
    , fgColor           = "gray"
    , alpha             = 50
    , position          = Bottom
    , overrideRedirect  = True
    , commands           = [
        Run Memory
            [ "-t", "<fn=1>\xf538</fn> <used>/<total> MB    "
            , "-p", "2"
            --, "-l", "#586e75"
            --, "-h", "#268bd2" -- blue, just to differentiate from cpu bar
            ] 10
        , Run Battery
            [ "-t", "<fc=gray><acstatus></fc>"
            , "-L", "20"
            , "-H", "85"
            , "-l", "#dc322f"
            , "-n", "#b58900"
            , "-h", "gray"
            , "--" -- battery specific options
            -- discharging status
            , "-o"  , "<fn=1>\xf242</fn> <left>% (<timeleft>) <watts>"
            -- AC "on" status
            , "-O"  , "<fn=1>\xf1e6</fn> <left>%"
            -- charged status
            , "-i"  , "<fn=1>\xf1e6</fn> <left>%"
            , "--off-icon-pattern", "<fn=1>\xf1e6</fn>"
            , "--on-icon-pattern", "<fn=1>\xf1e6</fn>"
            ] 10
        , Run MultiCpu ["-t", "<fn=1>\xf2db</fn> <autobar>", "-L","3","-H","50","--normal","#126263","--high","#00b9cd"] 10
        , Run Com "bash" ["-c", "sensors | grep Package | sed -E 's/^.*?: +\\+([0-9.]+)°C.*$/\\1/'"] "cpu_temp" 10

        ]
        , sepChar            = "%"
        , alignSep           = "}{"
        , template           = "%multicpu% %cpu_temp%°C }{  %memory% %battery%"
    }

-- not really haskell, but close enough
-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4
