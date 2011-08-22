import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.SetWMName

main = xmonad gnomeConfig
  {
    startupHook = setWMName "LG3D"
  }
