#tag DesktopWindow
Begin DesktopWindow Tools
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   Height          =   194
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   False
   Title           =   "LLStore Tools"
   Type            =   0
   Visible         =   False
   Width           =   290
   Begin DesktopButton ButtonInstallLLStore
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Install LLStore"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   40
      Index           =   -2147483648
      Italic          =   False
      Left            =   70
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Install LLStore to the current OS"
      Top             =   114
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   150
   End
   Begin DesktopButton ForceUpdate
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Force Full Update"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   40
      Index           =   -2147483648
      Italic          =   False
      Left            =   151
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Downloades the lastest full release and writes over the top of current version"
      Top             =   62
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin DesktopButton ForceUpdate1
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Force Exe Update"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   40
      Index           =   -2147483648
      Italic          =   False
      Left            =   9
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "download the latest EXE from github"
      Top             =   62
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin DesktopButton DeleteRepository
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Delete Repository Cache"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   40
      Index           =   -2147483648
      Italic          =   False
      Left            =   70
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "This deletes the downloaded items you have on your local system in ~/zLastOSRepository, you can delete them manually, or copy them out to USB to install again"
      Top             =   10
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   150
   End
End
#tag EndDesktopWindow

#tag WindowCode
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
		  Debug("-- Tools Closed")
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  ButtonInstallLLStore.Visible = True
		  
		  'Center Form
		  Tools.Left = (screen(0).AvailableWidth - Tools.Width) / 2
		  Tools.top = (screen(0).AvailableHeight - Tools.Height) / 2
		End Sub
	#tag EndEvent


#tag EndWindowCode

#tag Events ButtonInstallLLStore
	#tag Event
		Sub Pressed()
		  Tools.Hide
		  
		  Dim Old As String
		  Old = ButtonInstallLLStore.Caption
		  ButtonInstallLLStore.Caption = "Installing..."
		  App.DoEvents(7)
		  ButtonInstallLLStore.Visible = False
		  App.DoEvents(7)
		  InstallLLStore()
		  ButtonInstallLLStore.Caption = Old
		  ButtonInstallLLStore.Visible = True
		  App.DoEvents(7)
		  
		  Tools.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ForceUpdate
	#tag Event
		Sub Pressed()
		  Tools.Hide
		  'Store Windows Position to restore after window returns
		  PosLeft = Main.Left
		  PosTop = Main.Top
		  PosWidth = Main.Width
		  PosHeight = Main.Height
		  
		  Main.Visible = False 'Hide main form
		  App.DoEvents(4) 'Wait .004 of a second
		  
		  Loading.Left = (screen(0).AvailableWidth - Loading.Width) / 2
		  Loading.Top = (screen(0).AvailableHeight - Loading.Height) / 2
		  
		  Loading.Show
		  ForceFullUpdate = True
		  Loading.CheckForLLStoreUpdates
		  ForceFullUpdate = False
		  Loading.Hide
		  'Restore Position
		  If PosWidth <> 0 Then
		    Main.Left = PosLeft
		    Main.Top = PosTop
		    Main.Width = PosWidth
		    Main.Height = PosHeight
		  End If
		  
		  If StoreMode <> 99 Then Main.Visible = True ' Show Main Form Again
		  
		  If PosWidth <> 0 Then
		    Main.Left = PosLeft
		    Main.Top = PosTop
		    Main.Width = PosWidth
		    Main.Height = PosHeight
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ForceUpdate1
	#tag Event
		Sub Pressed()
		  Tools.Hide
		  'Store Windows Position to restore after window returns
		  PosLeft = Main.Left
		  PosTop = Main.Top
		  PosWidth = Main.Width
		  PosHeight = Main.Height
		  
		  Main.Visible = False 'Hide main form
		  App.DoEvents(4) 'Wait .004 of a second
		  
		  Loading.Left = (screen(0).AvailableWidth - Loading.Width) / 2
		  Loading.Top = (screen(0).AvailableHeight - Loading.Height) / 2
		  
		  Loading.Show
		  ForceExeUpdate = True
		  Loading.CheckForLLStoreUpdates
		  ForceExeUpdate = False
		  Loading.Hide
		  'Restore Position
		  If PosWidth <> 0 Then
		    Main.Left = PosLeft
		    Main.Top = PosTop
		    Main.Width = PosWidth
		    Main.Height = PosHeight
		  End If
		  
		  If StoreMode <> 99 Then Main.Visible = True ' Show Main Form Again
		  
		  If PosWidth <> 0 Then
		    Main.Left = PosLeft
		    Main.Top = PosTop
		    Main.Width = PosWidth
		    Main.Height = PosHeight
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DeleteRepository
	#tag Event
		Sub Pressed()
		  Dim Res As Integer
		  
		  Dim F As FolderItem
		  
		  Res = MsgBox ("Delete Local Repository Cache (Downloaded Items)?", 52)
		  
		  If Res = 7 Then Return ' ABORT!
		  
		  If Res = 6 Then
		    
		    Tools.Hide
		    'Store Windows Position to restore after window returns
		    PosLeft = Main.Left
		    PosTop = Main.Top
		    PosWidth = Main.Width
		    PosHeight = Main.Height
		    
		    Main.Visible = False 'Hide main form
		    App.DoEvents(4) 'Wait .004 of a second
		    
		    'Delete Local Repository path
		    #Pragma BreakOnExceptions Off
		    Deltree(RepositoryPathLocal)
		    
		    'Make Folders again to be used
		    F = GetFolderItem(Slash(RepositoryPathLocal)+".lldb", FolderItem.PathTypeNative)
		    If Not F.Exists Then
		      Try 
		        MakeFolder(F.NativePath)
		      Catch
		      End Try
		    End If
		    
		    'Make sure Repository path is accessiable to all
		    if TargetLinux then
		      ChMod(Slash(RepositoryPathLocal), "-R 777")
		    End If
		  End If
		  'Restore Position
		  If PosWidth <> 0 Then
		    Main.Left = PosLeft
		    Main.Top = PosTop
		    Main.Width = PosWidth
		    Main.Height = PosHeight
		  End If
		  
		  If StoreMode <> 99 Then Main.Visible = True ' Show Main Form Again
		  
		  If PosWidth <> 0 Then
		    Main.Left = PosLeft
		    Main.Top = PosTop
		    Main.Width = PosWidth
		    Main.Height = PosHeight
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
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
