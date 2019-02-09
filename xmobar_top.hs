Config
    { font              = "xft:xos4 Terminus:pixelsize=16:antialias=true:hinting=true"
    , additionalFonts   = [ "xft:Font Awesome 5 Free:style=solid:pixelsize=14:antialias=true:hinting=true" ]
    , allDesktops       = True
    , bgColor           = "#000000"
    , fgColor           = "gray"
    , alpha             = 200
    , overrideRedirect  = True
    , commands           = [
        Run Date "<fn=1>\xf017</fn> %H:%M:%S " "time" 10
        , Run UnsafeStdinReader
        ]
        , sepChar            = "%"
        , alignSep           = "}{"
        , template           = " %UnsafeStdinReader% }{ %time%"
    }

-- not really haskell, but close enough
-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4
