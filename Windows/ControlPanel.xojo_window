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
      Left            =   342
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
      Top             =   12
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
      Left            =   550
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
      Top             =   10
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
      Left            =   119
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
      Top             =   11
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   88
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
      Left            =   222
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
      Top             =   11
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   99
   End
   Begin DesktopCheckBox CheckCleanUp
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Clean Up"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Removes Empty Folders"
      Top             =   13
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   1
      Width           =   81
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
		Sub CleanStartMenu()
		  Dim I, J As Integer
		  Dim StartUser, StartAll As String
		  Dim Res As String
		  Dim Sp(), Sp2() As String
		  Dim Found As Boolean
		  Dim DelCount As Integer
		  Dim DelCommand As String
		  
		  StartAll = Slash(StartPathAll).ReplaceAll("/","\") 'All Users
		  StartUser = Slash(StartPathUser).ReplaceAll("/","\") ' Used to delete User Link if making System Wide Link
		  
		  ShellFast.Execute("dir /s /a /b "+Chr(34)+StartAll+Chr(34)+"*.lnk")
		  Res = ShellFast.Result
		  ShellFast.Execute("dir /s /a /b "+Chr(34)+StartUser+Chr(34)+"*.lnk")
		  Res = Res + ShellFast.Result
		  Res = Res.ReplaceAll(Chr(10),Chr(13))
		  Res = Res.ReplaceAll(Chr(13)+Chr(13),Chr(13)) 'Reduce Duplicated Line Ends
		  
		  Sp() = Res.Split(Chr(13))
		  If Sp.Count >=1 Then
		    For I = 0 To Sp.Count - 1
		      If Sp(I) <> "" Then
		        Sp(I) = GetParent(Sp(I))
		        'MsgBox Sp(I)
		      End If
		    Next
		  End If
		  
		  'dir /s /aD /b *
		  
		  ShellFast.Execute("dir /s /aD /b "+Chr(34)+StartAll+Chr(34)+"*")
		  Res = ShellFast.Result
		  ShellFast.Execute("dir /s /aD /b "+Chr(34)+StartUser+Chr(34)+"*")
		  Res = Res + ShellFast.Result
		  Res = Res.ReplaceAll(Chr(10),Chr(13))
		  Res = Res.ReplaceAll(Chr(13)+Chr(13),Chr(13)) 'Reduce Duplicated Line Ends
		  
		  Sp2() = Res.Split(Chr(13))
		  If Sp2.Count >=1 Then
		    For I = 0 To Sp2.Count - 1
		      If Sp2(I) <> "" Then
		        Found = False
		        For J = 0 To Sp.Count - 1
		          If Sp(J) <> "" Then
		            If Sp(J).IndexOf(Sp2(I)) >= 0 Then 'If the path to the Link is within the Scanned folders then keep it
		              Found = True
		              Exit
		            End If
		          End If
		        Next
		        If Found = False Then
		          'Msgbox "Delete: "+ Sp2(I)
		          If Sp2(I).IndexOf("StartUp")<0 Then 'Don't remove this folder, even if empty, it will be 0 or greater if so, making this false and not ran
		            DelCommand = DelCommand+"rmdir /q /s " + Chr(34)+Sp2(I)+Chr(34)+Chr(10)
		            DelCount = DelCount + 1
		          End If
		        End If
		      End If
		    Next
		  End If
		  
		  'MsgBox DelCount.ToString
		  
		  If DelCommand <> "" Then
		    'MsgBox DelCommand
		    RunCommand(DelCommand) 'Delete the lot at once
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopulateControlPanel()
		  'Get current set Menu Style from C:\Windows\SetupSMenu.ini
		  Dim I, G As Integer
		  Dim MenuIn As String
		  Dim MenuName As String
		  Dim Sp() As String
		  
		  
		  If Not TargetWindows Then 'Disable it all for Linux for now
		    ButtonSetMenuStyle.Enabled = False
		    ComboMenuStyle.Enabled = False
		    CheckCleanUp.Enabled = False
		  End If
		  
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

	#tag Method, Flags = &h0
		Sub RegenLinks(DirToCheck As String)
		  RegenPathIn = ""
		  Regenerating = True
		  'MsgBox DirToCheck
		  Dim D As Integer
		  Dim Suc As Boolean
		  Dim F As FolderItem
		  Dim ItemToCheck As String
		  Dim LLFile As String
		  
		  
		  F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeShell) 'This fixes the issue, yes whenever windows does folder stuff, convert it back until it returns, or it will add a backslash after the forward slash
		  
		  If F.IsFolder And F.IsReadable Then
		    If F.Count > 0 Then
		      For D = 1 To F.Count
		        RegenPathIn = ""
		        If F.Item(D).Directory Then 'Look for Valid Items only
		          RegenPathIn = F.Item(D).NativePath 'This is use by ExpPath to make sure the Link are pointing to the actual path, not the Set pp Drives etc
		          LLFile = F.Item(D).NativePath+"ssApp.app"
		          If Exist (LLFile) Then
		            'MsgBox LLFile
		            Suc = LoadLLFile(LLFile, "",False,True) 'True Skips loading icons, screenshots etc
		            If Suc = True Then MakeLinks (True) 'This will make and remove links for loaded item
		            Continue
		          End If
		          LLFile = F.Item(D).NativePath+"ppApp.app"
		          If Exist (LLFile) Then
		            'MsgBox LLFile
		            Suc = LoadLLFile(LLFile, "",False,True) 'True Skips loading icons, screenshots etc
		            If Suc = True Then MakeLinks (True) 'This will make and remove links for loaded item
		            Continue
		          End If
		          LLFile = F.Item(D).NativePath+"ppGame.ppg"
		          If Exist (LLFile) Then
		            'MsgBox LLFile
		            Suc = LoadLLFile(LLFile, "",False,True) 'True Skips loading icons, screenshots etc
		            If Suc = True Then MakeLinks (True) 'This will make and remove links for loaded item
		            Continue
		          End If
		        End If
		      Next
		    End If
		  End If
		  
		  Regenerating = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResortStartMenu()
		  Dim Let As Integer
		  Dim I, D As Integer
		  Dim F As FolderItem
		  Dim DirToCheck As String
		  'If StartMenuUsed = -1 Then 'UnSorted
		  'Else 'Menu Style Used
		  If TargetWindows Then
		    MakeFolderAttribBatch = ""
		    'ppApps And ppGames on all drives
		    Let = Asc("C")
		    For I = 0 To 23
		      Let = Asc("C") + I
		      DirToCheck = Chr(Let)+":\" 'Windows Path
		      
		      If Exist(DirToCheck+"ppApps") Then
		        RegenLinks (DirToCheck+"ppApps")
		      End If
		      If Exist(DirToCheck+"ppGames") Then
		        RegenLinks (DirToCheck+"ppGames")
		      End If
		    Next
		    'ssApps
		    RegenLinks ("C:\Program Files")
		    RegenLinks ("C:\Program Files (x86)")
		    
		    'Attrib ALL Folders and desktop.ini files at once
		    If MakeFolderAttribBatch <> "" Then
		      If Debugging Then Debug ("attrib ALL Folders and desktop.ini files")
		      RunCommand(MakeFolderAttribBatch)
		    End If
		    
		  End If
		  'End If
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events ButtonSetMenuStyle
	#tag Event
		Sub Pressed()
		  'Disable them until done
		  ButtonSetMenuStyle.Enabled = False
		  ComboMenuStyle.Enabled = False
		  CheckCleanUp.Enabled = False
		  
		  
		  Dim I As Integer
		  'Dim OriginalMenuStyle As String
		  'Dim Sp() As String
		  Dim Data As String
		  Dim Found As Boolean
		  Dim MenuPath As String
		  Dim Suc As Boolean
		  Dim Res As String
		  
		  
		  'TimeOut = System.Microseconds + (5 *1000000) 'Set Timeout after 5 seconds
		  
		  StartTimeStamp = System.Microseconds/1000000
		  
		  Dim Tims As Double
		  
		  Tims = (System.Microseconds/1000000)-StartTimeStamp
		  If Debugging Then Debug("* Starting Timer "+Tims.ToString)
		  
		  'Set current set Menu Style
		  If ComboMenuStyle.Text <> "" Then
		    If ComboMenuStyle.Text = "UnSorted" Then
		      Deltree ("C:\windows\ssTek\Definitions.ini") 'If not set, remove it
		      Deltree ("C:\windows\SetupSMenu.ini") 'If not set, remove it
		      Deltree ("C:\windows\ssTek\Menu")
		      Deltree ("C:\windows\ssTek\Icons")
		      MenuStyle = ComboMenuStyle.Text.Trim
		      StartMenuUsed = -1
		      SetMenuStyle.Text = MenuStyle 'Update GUI to how new menu style
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
		  
		  Tims = (System.Microseconds/1000000)-StartTimeStamp
		  If Debugging Then Debug("* (Build Menu Folder Done) Time Since Start "+Tims.ToString)
		  
		  'Resort/Clean Here
		  If CheckCleanUp.Value = True Then
		    QueueDeltree = True
		    QueueDeltreeMajor = True
		    QueueDeltreeJobs = ""
		    
		    ResortStartMenu() 'Disabled for now so I can test cleaner - re-enable (GlennGlennGlenn)
		    
		    Tims = (System.Microseconds/1000000)-StartTimeStamp
		    If Debugging Then Debug("* (Resort Job Done) Time Since Start "+Tims.ToString)
		    
		    'Delete all items at once, MUCH faster
		    QueueDeltree = False
		    QueueDeltreeMajor = False ' Deltrees done
		    RunCommand (QueueDeltreeJobs)
		    QueueDeltreeJobs = ""
		    
		    Tims = (System.Microseconds/1000000)-StartTimeStamp
		    If Debugging Then Debug("* (DelJob Done) Time Since Start "+Tims.ToString)
		    
		    CleanStartMenu()
		    
		    Tims = (System.Microseconds/1000000)-StartTimeStamp
		    If Debugging Then Debug("* (Clean Start Job Done) Time Since Start "+Tims.ToString)
		    
		  End If
		  
		  'Enable Them Again
		  ButtonSetMenuStyle.Enabled = True
		  ComboMenuStyle.Enabled = True
		  CheckCleanUp.Enabled = True
		  
		  If CheckCleanUp.Value = False Then
		    MsgBox "Done Sorting"
		  Else
		    MsgBox "Done Sorting and Cleaning"
		  End If
		  
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
