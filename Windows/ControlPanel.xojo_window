#tag DesktopWindow
Begin DesktopWindow ControlPanel
   Backdrop        =   0
   BackgroundColor =   &c00000000
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   True
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   400
   MaximumWidth    =   600
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   400
   MinimumWidth    =   600
   Resizeable      =   False
   Title           =   "Control Panel"
   Type            =   0
   Visible         =   False
   Width           =   600
   Begin DesktopComboBox ComboMenuStyle
      AllowAutoComplete=   False
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Hint            =   ""
      Index           =   -2147483648
      InitialValue    =   "ComboMenuStyle"
      Italic          =   False
      Left            =   312
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      SelectedRowIndex=   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   15
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
   End
   Begin DesktopButton ButtonSetMenuStyle
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Set"
      Default         =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   519
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
      Tooltip         =   "This applies to Windows only (not used by Linux)"
      Top             =   15
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin DesktopLabel LabelMenu
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   51
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "Current Menu:"
      TextAlignment   =   3
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   15
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   118
   End
   Begin DesktopLabel SetMenuStyle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   181
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
      TabStop         =   False
      Text            =   "SetMenuStyle"
      TextAlignment   =   1
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   15
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   118
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  PopulateControlPanel()
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub PopulateControlPanel()
		  'Get current set Menu Style from C:\Windows\SetupSMenu.ini
		  Dim I, G As Integer
		  Dim MenuIn As String
		  Dim MenuName As String
		  Dim Sp() As String
		  
		  ComboMenuStyle.RemoveAllRows
		  ComboMenuStyle.AddRow("UnSorted")
		  
		  
		  'Get Available Menu Styles
		  If Exist(Slash(ToolPath)+ Slash("Menus")+"MenuStyles.ini") Then
		    MenuIn = LoadDataFromFile(Slash(ToolPath)+ Slash("Menus")+"MenuStyles.ini")
		    MenuIn = MenuIn.ReplaceAll(Chr(13),Chr(10))
		    MenuIn = MenuIn.ReplaceAll(Chr(10)+Chr(10),Chr(10))
		    Sp()=MenuIn.Split(Chr(10))
		    StartMenuStylesCount = 0 ' Clear Styles Count
		    If Sp.Count >= 1 Then
		      For I = 1 To Sp.Count -1
		        MenuName = Right(Sp(I), Len(Sp(I))-InStrRev(Sp(I),"="))
		        ComboMenuStyle.AddRow(MenuName)
		        StartMenuStyles(StartMenuStylesCount) = MenuName
		        StartMenuStylesCount = StartMenuStylesCount + 1
		      Next
		      StartMenuStylesCount = StartMenuStylesCount - 1
		    End If
		  End If
		  
		  
		  'Get Current Menu Style
		  If Exist("C:\windows\SetupSMenu.ini") Then
		    MenuIn = LoadDataFromFile("C:\windows\SetupSMenu.ini")
		    MenuIn = MenuIn.ReplaceAll(Chr(13),Chr(10))
		    Sp()=MenuIn.Split(Chr(10))
		    Sp(0) = Sp(0).Trim
		    If Sp(0) <>"" Then
		      MenuStyle = Sp(0)
		      'ComboMenuStyle.AddRow(MenuStyle)
		      For G = 0 To StartMenuStylesCount
		        If StartMenuStyles(G) = MenuStyle Then
		          StartMenuUsed = G
		          Exit
		        End If
		      Next
		    End If
		  Else
		    MenuStyle = "UnSorted"
		    StartMenuUsed = -1
		  End If
		  
		  If TargetLinux Then MenuStyle = "Linux"
		  
		  SetMenuStyle.Text = MenuStyle
		  
		  ComboMenuStyle.Text = MenuStyle
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events ButtonSetMenuStyle
	#tag Event
		Sub Pressed()
		  Dim I As Integer
		  'Dim OriginalMenuStyle As String
		  'Dim Sp() As String
		  Dim Data As String
		  Dim Found As Boolean
		  Dim MenuPath As String
		  Dim Suc As Boolean
		  Dim Res As String
		  
		  'Set current set Menu Style
		  If ComboMenuStyle.Text <> "" Then
		    If ComboMenuStyle.Text = "UnSorted" Then
		      Deltree ("C:\windows\SetupSMenu.ini") 'If not set, remove it
		      Deltree ("C:\windows\ssTek\Menu")
		      MenuStyle = ComboMenuStyle.Text.Trim
		      StartMenuUsed = -1
		    Else
		      'Test it's valid
		      Found = False
		      For I = 0 To ComboMenuStyle.RowCount -1
		        If ComboMenuStyle.Text = ComboMenuStyle.RowTextAt(I) Then
		          Found = True
		          Exit
		        End If
		      Next
		      If Found = True Then 'Available from Combo, use it
		        MenuPath = Slash(Slash(ToolPath)+ Slash("Menus")+ComboMenuStyle.Text.Trim+"Menu")
		        If Exist(MenuPath) Then 'Only do it if Source Menu path found in Tools
		          
		          MenuStyle = ComboMenuStyle.Text.Trim
		          'Get the correct Menu Number ASAP
		          For I = 0 To StartMenuStylesCount
		            If StartMenuStyles(I) = MenuStyle Then StartMenuUsed = I 'Gets the current Menu Style Number
		            'Start
		          Next
		          
		          'Update Menu Style ini File here
		          Data = MenuStyle + Chr(10)
		          Data = Data + "[SetupS Menu]" + Chr(10)
		          Data = Data + "Style="+ MenuStyle + Chr(10)
		          SaveDataToFile (Data, "C:\windows\SetupSMenu.ini")
		          
		          'Extract menu style to ssTek folder
		          MkDir("C:\windows\ssTek\Icons") 'Check folder exists
		          MkDir("C:\windows\ssTek\Menu") 'Check folder exists
		          'Set Ownership to Users, so anyone can modify this folder
		          Res = RunCommandResults ("icacls "+Chr(34)+ "C:\windows\ssTek"+Chr(34)+ " /grant "+ "Users:F /t /c /q") 'Using Chr(10) instead of ; as scripts don't allow them, only the prompt does
		          
		          XCopyFile(MenuPath+"Definitions.ini", "C:\windows\ssTek\")
		          Suc = Extract(MenuPath+"Icons.7z", "C:\windows\ssTek\Icons\", "")
		          
		          BuildStartMenuLocations()
		          BuildMenuStyleFolder()
		          
		          SetMenuStyle.Text = MenuStyle 'Update GUI to how new menu style
		        Else
		          MsgBox ComboMenuStyle.Text+" not available to use as Menu"
		          Return
		        End If
		      End If
		    End If
		  End If
		  
		  
		  'Resort/Clean Here
		  
		  
		  '------------------------------------------------------------------------------------------------------------
		  
		  'ComboMenuStyle.RemoveAllRows
		  'ComboMenuStyle.AddRow("UnSorted")
		  '
		  '
		  ''Get Available Menu Styles
		  'If Exist(Slash(ToolPath)+ Slash("Menus")+"MenuStyles.ini") Then
		  'MenuIn = LoadDataFromFile(Slash(ToolPath)+ Slash("Menus")+"MenuStyles.ini")
		  'MenuIn = MenuIn.ReplaceAll(Chr(13),Chr(10))
		  'MenuIn = MenuIn.ReplaceAll(Chr(10)+Chr(10),Chr(10))
		  'Sp()=MenuIn.Split(Chr(10))
		  'If Sp.Count >= 1 Then
		  'For I = 1 To Sp.Count -1
		  'ComboMenuStyle.AddRow(Right(Sp(I), Len(Sp(I))-InStrRev(Sp(I),"=")))
		  'Next
		  'End If
		  'End If
		  '
		  '
		  ''Get Current Menu Style
		  'If Exist("C:\windows\SetupSMenu.ini") Then
		  'MenuIn = LoadDataFromFile("C:\windows\SetupSMenu.ini")
		  'MenuIn = MenuIn.ReplaceAll(Chr(13),Chr(10))
		  'Sp()=MenuIn.Split(Chr(10))
		  'Sp(0) = Sp(0).Trim
		  'If Sp(0) <>"" Then
		  'MenuStyle = Sp(0)
		  ''ComboMenuStyle.AddRow(MenuStyle)
		  'End If
		  'Else
		  'MenuStyle = "UnSorted"
		  'End If
		  '
		  'SetMenuStyle.Text = MenuStyle
		  '
		  'ComboMenuStyle.Text = MenuStyle
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
