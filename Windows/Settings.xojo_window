#tag DesktopWindow
Begin DesktopWindow Settings
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   430
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   False
   Title           =   "Settings"
   Type            =   0
   Visible         =   False
   Width           =   700
   Begin DesktopCheckBox SetCheckForUpdates
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Check for Updates"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   11
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   149
   End
   Begin DesktopCheckBox SetQuitOnComplete
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Quit on Complete"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   158
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Closes the main windows after installing any items"
      Top             =   11
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopCheckBox SetVideoPlayback
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Video Playback"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   642
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   77
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   False
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopTextField SetVideoVolume
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   27
      Hint            =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   663
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "20"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   57
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   False
      Width           =   37
   End
   Begin DesktopLabel VideoVolumeLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   642
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Video Playback Volume"
      TextAlignment   =   1
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   38
      Transparent     =   False
      Underline       =   False
      Visible         =   False
      Width           =   141
   End
   Begin DesktopCheckBox SetUseLocalDBFiles
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Use Local DB Files"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   50
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   149
   End
   Begin DesktopCheckBox SetCopyToRepoBuild
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Copy Items to Repo"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   311
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "This will copy the items to the Repository being built"
      Top             =   50
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopCheckBox SetIgnoreCache
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Ignore Cache Repo"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   466
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "If this is enabled it will not scan for pre-downloaded items, so you can build Repos cleaner"
      Top             =   50
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopCheckBox SetFlatpakAsUser
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Flatpak as User"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Flatpaks will be installed to the curent user only (Default)"
      Top             =   89
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   149
   End
   Begin DesktopCheckBox SetFlatpakAsSystem
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Flatpak as System"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   158
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Flatpaks will be installed System Wide"
      Top             =   89
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   149
   End
   Begin DesktopCheckBox SetUseManualLocations
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Manual Locations:"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   167
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   149
   End
   Begin DesktopTextArea SetManualLocations
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   True
      HasVerticalScrollbar=   True
      Height          =   90
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   6
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   18
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   1
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   199
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   687
   End
   Begin DesktopCheckBox SetUseOnlineRepos
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Online Repositories:"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   19
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   292
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   149
   End
   Begin DesktopTextArea SetOnlineRepos
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   True
      HasVerticalScrollbar=   True
      Height          =   97
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   21
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "https://raw.githubusercontent.com/LiveFreeDead/LastOSLinux_Repository/main/.lldb/lldb.ini\nhttps://www.lastos.org/linuxrepo/.lldb/lldb.ini\nhttps://www.lastos.org/linuxrepogames/.lldb/lldb.ini"
      TextAlignment   =   1
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   324
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   685
   End
   Begin DesktopButton DefaultRepos
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Load Defaults"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   185
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   20
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   292
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   114
   End
   Begin DesktopButton ButtonSaveRescan
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Save/Rescan"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   579
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   167
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   114
   End
   Begin DesktopCheckBox SetHideGameCats
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Hide Game Categories"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   466
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   128
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   227
   End
   Begin DesktopCheckBox SetHideInstalled
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Hide Installed On Startup"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   466
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "This will hide installed items on startup"
      Top             =   89
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   227
   End
   Begin DesktopCheckBox SetDebugEnabled
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Debugger Enabled"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   128
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopCheckBox SetAlwaysShowRes
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Always Show Res"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   158
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   128
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopButton ButtonSave
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Save"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   466
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   167
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   101
   End
   Begin DesktopCheckBox SetSudoAsNeeded
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Sudo As Needed"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   311
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "If this is disabled it will Ask for the password at the start of the Mini Install, otherwise you'll have to wait for it to get to the Sudo Scripts before it asks"
      Top             =   128
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopCheckBox SetRecoverScreenRes
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Recover Screen Res"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   311
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   22
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "This will try to get the screen back to how it was prior to launching a game"
      Top             =   89
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopCheckBox SetHideUnsetFlags
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Hide Undefined"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   158
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   23
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Hides items in the list that do not have the Working Desktop Environment Set"
      Top             =   50
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   152
   End
   Begin DesktopCheckBox SetScanLocalItems
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Scan Local Items"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   158
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   24
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "This will disable using ny local path except the manual ones if set"
      Top             =   167
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   1
      Width           =   149
   End
   Begin DesktopCheckBox SetNoUpdateDBOnStart
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Don't Auto Update Online DB's"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   311
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   25
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Hides items in the list that do not have the Working Desktop Environment Set"
      Top             =   291
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   224
   End
   Begin DesktopComboBox ThemeCombo
      AllowAutoComplete=   True
      AllowAutoDeactivate=   False
      AllowFocusRing  =   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Hint            =   ""
      Index           =   -2147483648
      InitialValue    =   "No Theme"
      Italic          =   False
      Left            =   433
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      SelectedRowIndex=   -1
      TabIndex        =   26
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   11
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   260
   End
   Begin DesktopLabel Label1
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   311
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   27
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "LLStore Theme:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   15
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   110
   End
   Begin DesktopTextField SetRefreshAfter
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   27
      Hint            =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   656
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   28
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "20"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   292
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   37
   End
   Begin DesktopLabel RefreshAfterLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   27
      Index           =   -2147483648
      Italic          =   False
      Left            =   532
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   29
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Refresh After (Mins):"
      TextAlignment   =   1
      TextColor       =   &c000000
      Tooltip         =   "Sets how long before it re-downloads databases"
      Top             =   292
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   119
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Activated()
		  Dim I As Integer
		  
		  SettingsChanged = True
		  
		  If LastTheme <> "" Then
		    If ThemeCombo.RowCount >= 1 Then
		      For I = 0 to ThemeCombo.RowCount-1
		        If ThemeCombo.RowTextAt(I) = LastTheme Then
		          ThemeCombo.SelectedRowIndex = I
		          ThemeCombo.Text = LastTheme
		        End If
		      Next
		    End If
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
		  If ForceQuit = False Then
		    Me.Hide
		    Return True
		  Else
		    Return False
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub Closing()
		  Debug("-- Settings Closed")
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  If Debugging Then Debug("--- Starting Settings Opening ---")
		  If ForceQuit = True Then Return 'Don't bother even opening if set to quit
		  
		  'Get Available Themes
		  ThemeCombo.RemoveAllRows
		  
		  Dim F As FolderItem
		  Dim I, D As Integer
		  Dim DirToCheck As String
		  Dim ItemPath As String
		  
		  DirToCheck = NoSlash(AppPath)+"/Themes"
		  
		  'DirToCheck = Left(DirToCheck, InStrRev(DirToCheck, "/",-1)) ' Checks up one level from the LastOSLinux Store    
		  
		  If TargetWindows Then
		    F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeNative)
		  Else
		    F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		  End If
		  If F.IsFolder And F.IsReadable Then
		    If F.Count > 0 Then
		      For D = 1 To F.Count
		        ItemPath = Slash(FixPath(F.Item(D).NativePath))
		        If Exist(ItemPath+"Style.ini") Then
		          ItemPath = NoSlash(ItemPath)
		          ThemeCombo.AddRow(Right(ItemPath,Len(ItemPath)-InStrRev(ItemPath,"/",-1)))
		        End If
		      Next D
		    End If
		  End If
		  
		End Sub
	#tag EndEvent


#tag EndWindowCode

#tag Events SetFlatpakAsUser
	#tag Event
		Sub ValueChanged()
		  If Me.Value = True Then
		    SetFlatpakAsSystem.Value = False
		  Else
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SetFlatpakAsSystem
	#tag Event
		Sub ValueChanged()
		  If Me.Value = True Then
		    SetFlatpakAsUser.Value = False
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DefaultRepos
	#tag Event
		Sub Pressed()
		  SetOnlineRepos.Text = "https://raw.githubusercontent.com/LiveFreeDead/LastOSLinux_Repository/main/.lldb/lldb.ini"+Chr(10)+"https://www.lastos.org/linuxrepo/.lldb/lldb.ini"+Chr(10)+"https://www.lastos.org/linuxrepogames/.lldb/lldb.ini"
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonSaveRescan
	#tag Event
		Sub Pressed()
		  Settings.Hide
		  Loading.SaveSettings
		  Loading.LoadSettings 'Make sure they get applied properly before reloading the GUI
		  Loading.RefreshDBs
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonSave
	#tag Event
		Sub Pressed()
		  Settings.Hide
		  Loading.SaveSettings
		  Loading.LoadSettings 'Make sure they get applied properly before reloading the GUI
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SetSudoAsNeeded
	#tag Event
		Sub ValueChanged()
		  SudoAsNeeded = Settings.SetSudoAsNeeded.Value
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SetHideUnsetFlags
	#tag Event
		Sub ValueChanged()
		  Main.HideUnsetFlags = SetHideUnsetFlags.Value
		  Main.GenerateItems()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SetNoUpdateDBOnStart
	#tag Event
		Sub ValueChanged()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ThemeCombo
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  Loading.LoadTheme (ThemeCombo.Text)
		  Main.ResizeMainForm()
		  'LastTheme = ThemeCombo.Text
		  'Save Theme here, GlennGlenn
		  
		  If LastTheme <> "" Then
		    If StoreMode = 0 Then
		      SaveDataToFile(LastTheme, Slash(AppPath)+"Themes/Theme.ini")
		    Else ' Launcher Mode
		      SaveDataToFile(LastTheme, Slash(AppPath)+"Themes/ThemeLauncher.ini")
		    End If
		    'MsgBox Slash(AppPath)+"Themes/Theme.ini" + " Theme: "+ LastTheme
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
