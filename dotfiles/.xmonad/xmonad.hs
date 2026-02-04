{-# LANGUAGE TupleSections #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

import Data.Ratio
import Data.IORef
import Data.List
--import Data.Default (def)
import Control.Monad (when)
import System.IO.Unsafe (unsafePerformIO)
import XMonad.Actions.UpdatePointer
import System.Posix.Files (readSymbolicLink)
import System.Posix.Signals (installHandler, sigUSR1, Handler(CatchOnce))
import System.FilePath.Posix (takeBaseName)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn (shellPromptHere, manageSpawn)
import XMonad.Actions.UpdatePointer
import XMonad.Actions.MostRecentlyUsed
import XMonad.Hooks.EwmhDesktops (ewmh)
--import XMonad.Hooks.EwmhDesktops (ewmhFullscreen)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
--import XMonad.Util.Scratchpad
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Maximize
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.ResizeScreen
import XMonad.Layout.Spacing
--import XMonad.Layout.Spiral as S
import XMonad.Layout.Dwindle as D
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts (ToggleLayout(ToggleLayout))
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.NamedWindows
import XMonad.Util.Paste
import XMonad.Util.Run
import XMonad.Util.Font
import XMonad.Util.Image
import qualified XMonad.Layout.HintedTile as HT

import qualified XMonad.StackSet as W
import qualified Data.IORef as IORef

trackMousePosition :: IORef.IORef (Int, Int) -> X ()
trackMousePosition posRef = withDisplay $ \dpy -> do
    rootw <- asks theRoot
    (_, _, _, x, y, _, _, _) <- io $ queryPointer dpy rootw
    io $ IORef.writeIORef posRef (fi x, fi y)

moveToLastPosition :: IORef.IORef (Int, Int) -> X ()
moveToLastPosition posRef = do
    (x, y) <- io $ IORef.readIORef posRef
    withDisplay $ \dpy -> do
        rootw <- asks theRoot
        io $ warpPointer dpy none rootw 0 0 0 0 (fi x) (fi y)

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- W.findTag w <$> gets windowset

        safeSpawn "notify-send" [show name, "workspace " ++ idx]

data OurTheme =
      BasicTheme ThemeType String String
    | FullTheme {
          themeType :: ThemeType
        , themeActiveColor   :: String
        , themeInactiveColor :: String
        , themeActiveText    :: String
        , themeInactiveText  :: String
      }
    deriving (Show, Read, Eq, Typeable)

getThemeType (BasicTheme typ _ _) = typ
getThemeType FullTheme{..} = themeType

data Center = Center deriving (Show, Read, Eq, Typeable)
data Maximized = Maximized deriving (Show, Read, Eq, Typeable)
data Gapz = Gapz deriving (Show, Read, Eq, Typeable)
data TabbedFull = TabbedFull OurTheme deriving (Show, Read, Eq, Typeable)
data ThemeType = LightTheme | DarkTheme deriving (Show, Read, Eq, Typeable)

orig (ModifiedLayout _   o) = o
modi (ModifiedLayout mod _) = mod

instance Transformer Center Window where
    transform Center x k = k (centered x) (orig . orig)

instance Transformer Gapz Window where
    transform Gapz x k = k (smartSpacingWithEdge gapSize x) orig

instance Transformer TabbedFull Window where
    transform (TabbedFull theme) x k =
        k (tabs (mkTabTheme theme) ||| Full) (const x)

-- TODO: this should be a ratio based off current screen width
centeredGap = 270
centered = resizeHorizontal centeredGap . resizeHorizontalRight centeredGap

gapSize = 5
sideGaps = False

ourFont = "xft:terminus:size=12"
tabs = tabbed shrinkText

baseTabTheme :: Theme
baseTabTheme = def { fontName = ourFont }

mkTabTheme FullTheme{..} =
    baseTabTheme {
        inactiveBorderColor = themeInactiveColor
      , inactiveColor       = themeInactiveColor
      , inactiveTextColor   = themeInactiveText
      , activeColor         = themeActiveColor
      , activeBorderColor   = themeActiveColor
      , activeTextColor     = themeActiveText
    }
mkTabTheme (BasicTheme _ active inactive) =
    baseTabTheme {
        inactiveBorderColor = inactive
      , inactiveColor       = inactive
      , activeColor         = active
      , activeBorderColor   = active
    }

darkTheme :: OurTheme
darkTheme = BasicTheme DarkTheme "#282C34" "#323742"

darkThemeOled :: OurTheme
darkThemeOled = BasicTheme DarkTheme "#000000" "#111111"


--darkTheme :: OurTheme
--darkTheme = FullTheme {
--    themeActiveColor   = "#282C34"
--  , themeInactiveColor = "#323742"
--  , themeActiveText    = "#000000"
--  , themeInactiveText  = "#777777"
--}


lightTheme :: OurTheme
lightTheme = FullTheme {
    themeType = LightTheme
  , themeActiveColor   = "#FFFFFF"
  , themeInactiveColor = "#EEEEEE"
  , themeActiveText    = "#000000"
  , themeInactiveText  = "#777777"
}

allGaps = (U, if sideGaps then gapSize else 0) :
            if sideGaps then map (,gapSize) (enumFrom D)
                        else []

baseLayout =
    let
        tall = ResizableTall 1 (3/100) (1/2) []
    in
        --D.Dwindle D.R D.CW 1.5 1.1 |||
            --D.Squeeze D.R 1.38 1.1
        -- ||| D.Spiral D.R D.CW 0.8 1.1
        D.Spiral D.R D.CW 0.8 1.1
        ||| Grid
        --S.spiral (4/3) |||
        --Mirror tall --S.spiralWithDir S.South S.CW (4/3)

layout theme
    = smartBorders
    . mkToggle (Center ?? EOT)
    . mkToggle ((TabbedFull theme) ?? EOT)
    . mkToggle (Gapz ?? EOT)
    . mkToggle (MIRROR ?? EOT)
    $ baseLayout


getTheme :: IO OurTheme
getTheme = do
  themePath <- readSymbolicLink "/home/jb55/.Xresources.d/themes/current"
  case takeBaseName themePath of
    "light" -> return lightTheme
    _       -> return darkThemeOled


myStartupHook :: Layout Window -> X ()
myStartupHook lout = do
  setWMName "LG3D"
  setLayout lout -- needed until we have themeSwitch implemented

readTheme :: IORef OurTheme -> OurTheme
readTheme = unsafePerformIO . readIORef

otherTheme :: OurTheme -> OurTheme
otherTheme t =
    case getThemeType t of
      LightTheme -> darkTheme
      DarkTheme  -> lightTheme

shouldntFloat :: String -> Bool
shouldntFloat = isPrefixOf "qutebrowser"

shouldFloat :: Query Bool
shouldFloat = do
  fs   <- isFullscreen
  name <- appName
  return (fs && not (shouldntFloat name))

--scratchHook = scratchpadManageHook (W.RationalRect 0.1 0.1 0.6 0.6)
--myManageHook = scratchHook <+> (shouldFloat --> doFullFloat)
myManageHook = composeAll [ 
	shouldFloat --> doFullFloat
      , className =? "Steam" --> doFloat
      , className =? "steam" --> doFullFloat
      ]

myConfig theme =
  let lout = layout theme
      cfg = def {
                terminal           = termName
              , modMask            = mod4Mask
              , layoutHook         = lout
              , logHook            = updatePointer (0.5, 0.5) (0, 0)
              , startupHook        = myStartupHook (Layout lout)
              , manageHook         = myManageHook
              , normalBorderColor  = "#222"
              , focusedBorderColor = "#BE5046"
            }
  in
    withUrgencyHook LibNotifyUrgencyHook
  $ ewmh
  $ cfg
  `additionalKeysP` (myKeys theme)

main = do
  installHandler sigUSR1 (CatchOnce doRestart) Nothing
  theme <- getTheme
  xmonad (myConfig theme)

myXPConfig =
    def {
      font        = ourFont,
      height      = 20,
      borderColor = "#000000"
    }

nWindows :: X Int
nWindows = fmap go get
  where
    go = length . W.integrate'
                . W.stack
                . W.workspace
                . W.current
                . windowset

toggleGaps       = sendMessage (Toggle Gapz)
toggleFull theme = sendMessage (Toggle (TabbedFull theme))
toggleMirror     = sendMessage (Toggle MIRROR)
toggleCenter     = sendMessage (Toggle Center)

termName :: String
termName = "urxvtc"

myKeys theme = [
    ("M-p", spawn "dmenu_run -fn \"terminus-12\" -p \"run\"")
  , ("M-a", focusUrgent)
  , ("M-d", toggleWS)
  , ("M-f", toggleFull theme)
  , ("M-c", toggleCenter)
  , ("M-b", toggleMirror)
  , ("M-g", toggleGaps)
  --, ("M-s", scratchpadSpawnActionTerminal termName)
  --, ("M-s", scratchpadSpawnActionTerminal termName)
  -- , ("M-r", toggleFull)
  , ("M-v", sendKey shiftMask xK_Insert)
  ]




sendRestart :: IO ()
sendRestart = do
    dpy <- openDisplay ""
    rw <- rootWindow dpy $ defaultScreen dpy
    xmonad_restart <- internAtom dpy "XMONAD_RESTART" False
    allocaXEvent $ \e -> do
        setEventType e clientMessage
        setClientMessageEvent e rw xmonad_restart 32 0 currentTime
        sendEvent dpy rw False structureNotifyMask e
    sync dpy False


doRestart = spawn "xmonad --restart"
