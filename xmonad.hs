import qualified Data.Map as M
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Xfce
import XMonad.Layout.Maximize
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.NoBorders
import XMonad.Actions.NoBorders
-- import XMonad.Layout.Reflect
-- import XMonad.Layout.Maximize
-- import XMonad.Layout.ToggleLayouts
import XMonad.Hooks.ManageDocks

myLayout = toggleLayouts (smartBorders tall) (noBorders tall) ||| noBorders Full
  where tall = (Tall 1 (3/100) (1/2))

main = xmonad xfceConfig
  { terminal        = "xfce4-terminal"
  , modMask         = mod4Mask
  , layoutHook      = lessBorders OnlyFloat $ avoidStruts $ myLayout
  , borderWidth     = 2
  , keys            = \c -> mykeys c `M.union` keys xfceConfig c
  , handleEventHook = fullscreenEventHook
  }
  where
    mykeys (XConfig {modMask = modm}) = M.fromList $
     [ ((modm, xK_backslash), withFocused (sendMessage . maximizeRestore))
     , ((modm, xK_g), withFocused toggleBorder)
     , ((modm, xK_b), sendMessage ToggleStruts)
     , ((modm .|. controlMask, xK_space), sendMessage ToggleLayout)
     , ((mod1Mask, xK_F4), kill)
     -- , ((modm .|. controlMask, xK_space), sendMessage (Toggle "Full"))
     ]

