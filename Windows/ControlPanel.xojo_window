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
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Hint            =   ""
      Index           =   -2147483648
      InitialValue    =   "ComboMenuStyle"
      Italic          =   False
      Left            =   344
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
      Width           =   198
   End
   Begin DesktopButton ButtonSetMenuStyle
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Set"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
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
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   121
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
      Top             =   12
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   102
   End
   Begin DesktopLabel SetMenuStyle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   238
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
      Top             =   12
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   102
   End
   Begin DesktopCheckBox CheckCleanUp
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Clean Up"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   13
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
      Top             =   12
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   1
      Width           =   103
   End
   Begin DesktopButton ButtonSetLinuxMenuSorting
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Enable Linux Menu Sorting"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   364
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   86
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   226
   End
   Begin DesktopButton ButtonCleanDudLinuxMenuItems
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Cleanup Dud Linux Menu Items"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   126
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "This tests all linux shortcuts and removes if broken"
      Top             =   86
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   226
   End
   Begin DesktopCheckBox CheckRegenerate
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Regenerate"
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   13
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Regenerate ppApps/ppGames when you set the menu style"
      Top             =   48
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   1
      Width           =   103
   End
   Begin DesktopButton ButtonRegenerateItems
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Regenerate Items"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   128
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Regenerate ppApps/ppGames"
      Top             =   50
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   226
   End
   Begin DesktopLabel LabelMenu1
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "ppApp Drive:"
      TextAlignment   =   3
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   133
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   102
   End
   Begin DesktopComboBox ComboppAppDrive
      AllowAutoComplete=   False
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Hint            =   ""
      Index           =   -2147483648
      InitialValue    =   "ComboppAppDrive"
      Italic          =   False
      Left            =   121
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      SelectedRowIndex=   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   133
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   102
   End
   Begin DesktopLabel LabelMenu2
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   24
      Index           =   -2147483648
      Italic          =   False
      Left            =   250
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "ppGame Drive:"
      TextAlignment   =   3
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   133
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   102
   End
   Begin DesktopComboBox ComboppGameDrive
      AllowAutoComplete=   False
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Hint            =   ""
      Index           =   -2147483648
      InitialValue    =   "ComboppAppDrive"
      Italic          =   False
      Left            =   371
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      SelectedRowIndex=   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   133
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   102
   End
   Begin DesktopButton ButtonSetppDrives
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Set"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
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
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Apply pp Drive Letters"
      Top             =   133
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin DesktopButton ButtonRefreshppDrives
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "R"
      Default         =   True
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   502
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Refresh Available Drive Letters"
      Top             =   133
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
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
		Sub CleanDudLinuxMenuItems()
		  If Not TargetLinux Then Return ' Not the right OS
		  'MsgBox "Not Implemented"
		  
		  Dim I, J As Integer
		  Dim ScanPath As String
		  Dim Sh As New Shell
		  Dim Sp(), Sp2() As String
		  Dim DesktopFileData As String
		  Dim EXEC, PATH As String
		  Dim LineID, LineData, Lin As String
		  Dim EqPos As Integer
		  Dim CleanExec, CleanPath As String
		  Dim Test As String
		  Dim Res As Integer
		  
		  Dim ValidItem As Boolean = False
		  
		  
		  Sh.ExecuteMode = Shell.ExecuteModes.Synchronous
		  Sh.TimeOut =  -1
		  
		  ScanPath = Slash(HomePath)+".local/share/applications"
		  
		  Sh.Execute ("find "+Chr(34)+ScanPath+Chr(34)+" -type f -name "+Chr(34)+"*.desktop"+Chr(34))
		  Sp = Sh.Result.Split(EndOfLine)
		  If Sp.Count >=1 Then
		    For I = 0 To Sp.Count -1
		      DesktopFileData = LoadDataFromFile(Sp(I))
		      Sp2 = DesktopFileData.Split(EndOfLine)
		      EXEC = ""
		      PATH = ""
		      For J = 0 To Sp2.Count -1
		        Lin = Sp2(J)
		        EqPos = Lin.IndexOf(1,"=")
		        LineID = ""
		        LineData = ""
		        If  EqPos >= 1 Then
		          LineID = Left(Lin,EqPos)
		          LineData = Right(Lin,Len(Lin)-Len(LineID)-1)
		          LineID=LineID.Trim.Lowercase
		          LineData=LineData.Trim
		        End If
		        Select Case LineID
		        Case "EXEC"
		          EXEC = LineData
		        Case "PATH"
		          PATH = LineData
		        End Select
		        If EXEC <> "" And PATH <> "" Then Exit ' We have everything we need
		      Next J
		      ValidItem = False
		      If EXEC <> ""  Then 'Need at least this one or nothing can be tested
		        CleanPath = "" 'Start Fresh
		        CleanExec = ""
		        
		        If PATH <> "" Then CleanPath = Slash(PATH.ReplaceAll(Chr(34),"")) ' Remove quotes from paths, this should be the only cleaning we need to do
		        
		        CleanExec = EXEC
		        
		        If Left(CleanExec, 5) = "WINE " Then CleanExec = Right(CleanExec, Len(CleanExec)-5).Trim ' Remove WINE and trim it up
		        
		        CleanExec = CleanExec.ReplaceAll(Chr(34)+Chr(34), "") 'Remove all double quotes, they cause issues
		        CleanExec = CleanExec.ReplaceAll(Chr(34)+Chr(34), "")
		        CleanExec = CleanExec.ReplaceAll(Chr(34)+Chr(34), "")
		        CleanExec = CleanExec.ReplaceAll(Chr(34)+Chr(34), "")
		        
		        While Left(CleanExec, 1) = Chr(34) 'Keep removing Quotes until they are gone
		          CleanExec = Right(CleanExec,Len(CleanExec)-1) ' Remove First Quote so can find matching one to only use the EXEC name, no arguments etc
		          CleanExec = Left(CleanExec, CleanExec.IndexOf(Chr(34))) 'Check for matching Quote to crop out the main exe name
		        Wend
		        
		        CleanExec = CleanExec.ReplaceAll("%u", "")
		        CleanExec = CleanExec.ReplaceAll("%F", "")
		        CleanExec = CleanExec.ReplaceAll("%f", "")
		        CleanExec = CleanExec.ReplaceAll("env GDK_BACKEND=x11", "")
		        
		        CleanExec = CleanExec.Trim
		        
		        'Special Cases
		        If CleanExec = "notepad" Then ValidItem = True 'This item is built in to wine 
		        If CleanExec = "uninstall" Then ValidItem = True 'This item is built in to wine
		        If CleanExec = "uninstaller" Then ValidItem = True 'This item is built in to wine
		        If Left(CleanExec, 5) = "steam" Then ValidItem = True  ' Steam is self managed so if one breaks, I don't want to touch it with a ten foot pole
		        If Left(CleanExec, 8) = "/app/bin" Then ValidItem = True  ' Flatpaks are self managed so if one breaks, I don't want to touch it with a ten foot pole
		        If Left(CleanExec, 8) = "/app/bin" Then ValidItem = True  ' Flatpaks are self managed so if one breaks, I don't want to touch it with a ten foot pole
		        If Sp(I).IndexOf("webapp") >=0 Then ValidItem = True ' Skip Web Apps
		        If CleanExec = "start /unix" Then ValidItem = True 'This item is built in to wine ' I still need to knock off the space in the exec path for other items (GLENN)
		        
		        '
		        If CleanExec.IndexOf(".appimage") >=0 Then  'Has appimage so drop back to see if that exists
		          CleanExec = Left(CleanExec, CleanExec.IndexOf(".appimage") + 9).Trim 'Trim to appimage file name
		        End If
		        
		        'Now Check results
		        If Exist(CleanExec) Then ValidItem = True ' It exist
		        If Exist(CleanPath+CleanExec) Then ValidItem = True ' It exist
		        If Exist(CleanPath+CleanExec.Lowercase) Then ValidItem = True ' It's exist but the exe is actually lowercase
		        
		        If ValidItem = False Then   'And CleanPath = "" Then ' Check the system paths for the executable else it's not Valid 'Don't really need to care if path is given or not, if it's available it will work
		          'MsgBox "Testing: "+CleanExec
		          Sh.Execute("type -P "+Chr(34)+CleanExec+Chr(34)) 'Check if system wide call, if so it's a little valid at least
		          If  Sh.Result <> "" Then ValidItem = True 'If not nothing then found
		          
		          If Not ValidItem Then
		            Test = Right(CleanExec,Len(CleanExec) -InStrRev (CleanExec,"/")).Trim ' Remove path and see if system wide executable, including the path with a system wide variable still works
		            'MsgBox "Testing: "+Test
		            Sh.Execute("type -P "+Chr(34)+Test+Chr(34)) 'Check if system wide call, if so it's a little valid at least
		            If  Sh.Result <> "" Then ValidItem = True 'If not nothing then found
		          End If
		        End If
		        
		        If Not ValidItem Then ' Still more testing
		          If CleanExec.IndexOf(" ") >=0 Then  'Has a space, test before the space
		            Test = Left(CleanExec, CleanExec.IndexOf(" ")).Trim
		            'MsgBox "Testing: "+Test
		            Sh.Execute("type -P "+Chr(34)+Test+Chr(34)) 'Check if system wide call, if so it's a little valid at least
		            If  Sh.Result <> "" Then ValidItem = True 'If not nothing then found
		          End If
		        End If
		        
		        'MsgBox "Path: "+ CleanPath+" EXEC: "+ CleanExec
		        If Not ValidItem Then 'Remove It
		          Res = MsgBox ("Delete: "+Sp(I)+Chr(10)+Chr(10)+"EXEC Not found: "+CleanPath+CleanExec,52)
		          
		          If Res = 7 Then Return ' ABORT!
		          
		          If Res = 6 Then
		            'Delete Item
		            Deltree(Sp(I))
		          End If
		        Else
		          'If Sp(I).IndexOf("braid") >=0 Then MsgBox ("Kept Braid Why?")
		        End If
		      End If
		    Next I
		  End If
		  
		  MsgBox ("Finished Checking for Bad Links")
		  
		  Return
		  Dim D As Integer
		  Dim ItemFile As String
		  Dim F, G As FolderItem
		  
		  ScanPath = Slash(HomePath)+".local/share/applications"
		  F = GetFolderItem(ScanPath, FolderItem.PathTypeNative)
		  If F.IsFolder And F.IsReadable Then
		    If F.Count > 0 Then
		      For D = 1 To F.Count
		        ItemFile =F.Item(D).NativePath
		        If Not F.Item(D).Directory Then 'Look for files only
		          If Right(ItemFile, 8) = ".desktop" Then
		            'MsgBox ItemFile
		          End If
		        End If
		      Next D
		    End If
		  End If
		  
		  
		  
		  
		  ScanPath = "/usr/share/applications"
		  
		  MsgBox ScanPath
		End Sub
	#tag EndMethod

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
		Function ExpDefaults(Data As String) As String
		  Dim StartPath As String
		  
		  'StartPathAll = Slash(FixPath(SpecialFolder.SharedApplicationData.NativePath)) + "Microsoft/Windows/Start Menu/Programs/" 'All Users
		  'StartPathUser = Slash(FixPath(SpecialFolder.ApplicationData.NativePath)) + "Microsoft/Windows/Start Menu/Programs/" 'Current User
		  
		  StartPath = Slash(FixPath(SpecialFolder.SharedApplicationData.NativePath)) + "Microsoft/Windows/Start Menu/Programs" 'All Users
		  StartPath = StartPath.ReplaceAll("/","\")
		  
		  'Data = Data.ReplaceAll("","")
		  Data = Data.ReplaceAll("%%WinDir%","C:\windows")
		  Data = Data.ReplaceAll("%WinDir%","C:\windows")
		  Data = Data.ReplaceAll("%Programs%",StartPath)
		  Data = Data.ReplaceAll("%ProgramsCommon%",StartPath)
		  Data = Data.ReplaceAll("%StartmenuCommon%",StartPath)
		  Data = Data.ReplaceAll("%HOMEDRIVE%%HOMEPATH%",NoSlash(SpecialFolder.UserHome.NativePath).ReplaceAll("/","\"))
		  Data = Data.ReplaceAll("%ProgramFiles%",NoSlash(SpecialFolder.Applications.NativePath).ReplaceAll("/","\"))
		  Data = Data.ReplaceAll("%ProgramFiles(x86)%",NoSlash(SpecialFolder.Applications.NativePath).ReplaceAll("/","\")+" (x86)")
		  Data = Data.ReplaceAll("%CommonProgramFiles%",NoSlash(SpecialFolder.Applications.NativePath).ReplaceAll("/","\")+"\Common Files")
		  
		  Data = Data.ReplaceAll("%mydocuments%",NoSlash(SpecialFolder.UserHome.NativePath).ReplaceAll("/","\"))
		  
		  
		  
		  Data = Data.ReplaceAll("%COMSPEC%",System.EnvironmentVariable("COMSPEC"))
		  
		  '%StartmenuCommon% <_ Skipped, not used in 10
		  
		  
		  Return Data
		End Function
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
		  Else 'Running in Windows
		    ButtonSetLinuxMenuSorting.Enabled = False
		    ButtonCleanDudLinuxMenuItems.Enabled = False
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
		  
		  'List Drives available to use as ppDrives
		  If TargetLinux Then 'Disable this for Linux
		    ComboppAppDrive.Enabled = False
		    ComboppGameDrive.Enabled = False
		    ButtonSetppDrives.Enabled = False
		    ButtonRefreshppDrives.Enabled = False
		  Else 'Windows
		    RefreshppDrives()
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshppDrives()
		  Dim Let, I As Integer
		  Dim ScanPath, ScanDisk As String
		  Dim F As FolderItem
		  
		  ComboppAppDrive.RemoveAllRows
		  ComboppGameDrive.RemoveAllRows
		  
		  Let = Asc("C")
		  For I = 0 To 23
		    Let = Asc("C") + I
		    ScanDisk = Chr(Let)+":"
		    ScanPath = ScanDisk + "\ppApps"
		    F = GetFolderItem(ScanDisk+"\ppWriteTest.ini", FolderItem.PathTypeNative)
		    If F.IsWriteable Then
		      ComboppAppDrive.AddRow(ScanDisk)
		      ComboppGameDrive.AddRow(ScanDisk)
		    End If
		  Next I
		  
		  
		  ComboppAppDrive.Text = ppAppsDrive
		  ComboppGameDrive.Text = ppGamesDrive
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RegenerateItems()
		  If Debugging Then Debug("--- Starting Regenerating ---")
		  App.DoEvents(1) ' Refresh things first
		  
		  If Debugging Then Debug("--- Starting Regenerating ---")
		  
		  App.DoEvents(1) ' Refresh things first
		  
		  Dim Suc As Boolean
		  Dim Res As String
		  Dim ScanPath As String
		  Dim Sp() As String
		  Dim I As Integer
		  
		  Dim Sh As New Shell
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  Sh.TimeOut =  -1
		  
		  If TargetWindows Then
		    
		    Declare Function SetErrorMode Lib "Kernel32" (mode As Integer) As Integer
		    Const SEM_FAILCRITICALERRORS = &h1
		    
		    Dim oldMode As Integer = SetErrorMode( SEM_FAILCRITICALERRORS )
		    Dim reg As registryItem
		    Dim Ret As String
		    Dim J, A As Integer
		    Dim F As FolderItem
		    
		    #Pragma BreakOnExceptions Off
		    Try
		      reg = new registryItem(RegKeyHKLMccsWin) 'RegKeyHKLMccsWin = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows"
		      reg.Value("ErrorMode") = 2
		    Catch
		    End Try
		    
		    Ret = ""
		    A = Asc("C")
		    
		    Dim Test, Drive As String
		    
		    
		    For I = 0 To 23
		      Try
		        Drive = Chr(A+I)+":"
		        Test = Drive+"\ppApps"
		        'MsgBox(Test)
		        If Debugging Then Debug ("Testing for: "+Test)
		        If Exist (Test) Then
		          If Debugging Then Debug ("FOUND: "+Test)
		          F = GetFolderItem(Drive+"\ppWritable.ini", FolderItem.PathTypeNative)
		          If F.IsWriteable And WritableLocation(F) Then
		            If Debugging Then Debug ("WRITABLE: "+Test)
		            ScanPath = Slash(Test).ReplaceAll("/","\")
		            
		            If Debugging Then Debug ("Check for ppApp.app files in: "+ScanPath)
		            
		            ShellFast.Execute("dir /s /a /b "+Chr(34)+ScanPath+Chr(34)+"*.app")
		            Res = ShellFast.Result
		            Res = Res.ReplaceAll(Chr(10),Chr(13))
		            Res = Res.ReplaceAll(Chr(13)+Chr(13),Chr(13)) 'Reduce Duplicated Line Ends
		            
		            If Debugging Then Debug ("List of ppApp.app files to regenerate:- "+Chr(10)+Res)
		            
		            Sp() = Res.Split(Chr(13))
		            If Sp.Count >=1 Then
		              For J = 0 To Sp.Count -1
		                Sp(J) = Sp(J).Trim
		                If Sp(J).Trim <> "" Then
		                  Suc = LoadLLFile(Sp(J).Trim, "", False, True) 'The 2nd True makes it skip loading the Icons etc, only gets the details
		                  If Suc Then ' Only do for valid items
		                    InstallFromPath = GetFullParent(Sp(J).Trim) 'Removes .lla .app etc file ' just keep path
		                    InstallToPath = InstallFromPath
		                    
		                    Suc = ChDirSet(InstallFromPath) 'Change to App/Games INI Path to run  from
		                    If Suc Then ' Only do if in right path
		                      RunScripts 'Run Script File from the path (Expanded variables)
		                      RunRegistry'Run The Reg File from the path (Expanded variables)
		                    End If
		                  End If
		                End If
		              Next J
		            End If
		          End If
		        End If
		        
		        Test = Drive+"\ppGames"
		        
		        If Debugging Then Debug ("Testing for: "+Test)
		        If Exist (Test) Then
		          If Debugging Then Debug ("FOUND: "+Test)
		          F = GetFolderItem(Drive+"\ppWritable.ini", FolderItem.PathTypeNative)
		          If F.IsWriteable And WritableLocation(F) Then
		            If Debugging Then Debug ("WRITABLE: "+Test)
		            
		            ScanPath = Slash(Test).ReplaceAll("/","\")
		            
		            If Debugging Then Debug ("Check for ppGame.ppg files in: "+ScanPath)
		            
		            ShellFast.Execute("dir /s /a /b "+Chr(34)+ScanPath+Chr(34)+"*.ppg")
		            Res = ShellFast.Result
		            Res = Res.ReplaceAll(Chr(10),Chr(13))
		            Res = Res.ReplaceAll(Chr(13)+Chr(13),Chr(13)) 'Reduce Duplicated Line Ends
		            
		            If Debugging Then Debug ("List of ppGame.ppg files to regenerate:- "+Chr(10)+Res)
		            
		            Sp() = Res.Split(Chr(13))
		            If Sp.Count >=1 Then
		              For J = 0 To Sp.Count -1
		                Sp(J) = Sp(J).Trim
		                If Sp(J).Trim <> "" Then
		                  Suc = LoadLLFile(Sp(J).Trim, "", False, True) 'The 2nd True makes it skip loading the Icons etc, only gets the details
		                  If Suc Then ' Only do for valid items
		                    InstallFromPath = GetFullParent(Sp(J).Trim) 'Removes .lla .app etc file ' just keep path
		                    InstallToPath = InstallFromPath
		                    
		                    Suc = ChDirSet(InstallFromPath) 'Change to App/Games INI Path to run  from
		                    If Suc Then ' Only do if in right path
		                      RunScripts 'Run Script File from the path (Expanded variables)
		                      RunRegistry'Run The Reg File from the path (Expanded variables)
		                    End If
		                  End If
		                End If
		              Next J
		            End If
		          End If
		        End If
		      Catch
		      End Try
		    Next I
		    
		    Call SetErrorMode( oldMode )
		    #Pragma BreakOnExceptions Off
		    Try
		      reg = new registryItem(RegKeyHKLMccsWin) 'RegKeyHKLMccsWin = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows"
		      reg.Value("ErrorMode") = 0
		    Catch
		    End Try
		    
		  Else 'Linux
		    ScanPath = ppApps
		    
		    If Debugging Then Debug ("Check for ppApp.app files in: "+ScanPath)
		    
		    Sh.Execute ("find "+Chr(34)+ScanPath+Chr(34)+" -type f -name "+Chr(34)+"ppApp.app"+Chr(34))
		    While Sh.IsRunning
		      App.DoEvents(1)
		    Wend
		    Sp = Sh.Result.Split(EndOfLine)
		    If Sp.Count >=1 Then
		      For I = 0 To Sp.Count -1
		        Sp(I) = Sp(I).Trim
		        If Sp(I).Trim <> "" Then
		          Suc = LoadLLFile(Sp(I).Trim, "", False, True) 'The 2nd True makes it skip loading the Icons etc, only gets the details
		          If Suc Then ' Only do for valid items
		            InstallFromPath = GetFullParent(Sp(I).Trim) 'Removes .lla .app etc file ' just keep path
		            InstallToPath = InstallFromPath
		            
		            Suc = ChDirSet(InstallFromPath) 'Change to App/Games INI Path to run  from
		            If Suc Then ' Only do if in right path
		              RunScripts 'Run Script File from the path (Expanded variables)
		              RunRegistry'Run The Reg File from the path (Expanded variables)
		            End If
		          End If
		        End If
		      Next I
		    End If
		    
		    ScanPath = ppGames
		    
		    If Debugging Then Debug ("Check for ppGame.ppg files in: "+ScanPath)
		    
		    Sh.Execute ("find "+Chr(34)+ScanPath+Chr(34)+" -type f -name "+Chr(34)+"ppGame.ppg"+Chr(34))
		    While Sh.IsRunning
		      App.DoEvents(1)
		    Wend
		    Sp = Sh.Result.Split(EndOfLine)
		    If Sp.Count >=1 Then
		      For I = 0 To Sp.Count -1
		        Sp(I) = Sp(I).Trim
		        If Sp(I).Trim <> "" Then
		          Suc = LoadLLFile(Sp(I).Trim, "", False, True) 'The 2nd True makes it skip loading the Icons etc, only gets the details
		          If Suc Then ' Only do for valid items
		            InstallFromPath = GetFullParent(Sp(I).Trim) 'Removes .lla .app etc file ' just keep path
		            InstallToPath = InstallFromPath
		            
		            Suc = ChDirSet(InstallFromPath) 'Change to App/Games INI Path to run  from
		            If Suc Then ' Only do if in right path
		              RunScripts 'Run Script File from the path (Expanded variables)
		              RunRegistry'Run The Reg File from the path (Expanded variables)
		            End If
		          End If
		        End If
		      Next I
		    End If
		  End If
		  
		  #Pragma BreakOnExceptions On
		  
		  If Loading.Regenerate = False Then
		    MsgBox "Regenerating Items Done"
		  End If
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
		  
		  
		  F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeNative) 'This fixes the issue, yes whenever windows does folder stuff, convert it back until it returns, or it will add a backslash after the forward slash
		  
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

	#tag Method, Flags = &h0
		Sub SetppDrives()
		  If TargetWindows Then
		    If Len(ComboppAppDrive.Text) = 2 Then
		      SaveDataToFile (ComboppAppDrive.Text, "C:\Windows\ppAppDrive.ini")
		      ppApps = ComboppAppDrive.Text+"\ppApps" 'Set it as active straight away
		      ppAppsDrive = ComboppAppDrive.Text
		    End If
		    If Len(ComboppGameDrive.Text) = 2 Then
		      SaveDataToFile (ComboppGameDrive.Text, "C:\Windows\ppGameDrive.ini")
		      ppGames = ComboppGameDrive.Text+"\ppGames" 'Set it as active straight away
		      ppGamesDrive = ComboppGameDrive.Text
		    End If
		    MsgBox "Set ppApp Drive to: "+ ComboppAppDrive.Text +" and ppGame Drive to: "+ ComboppGameDrive.Text
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPressed()
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
		  Dim LineIn As String
		  Dim ID As String
		  Dim Sp() As String
		  Dim ReadMode As Integer
		  Dim StartPath As String
		  
		  StartPath = Slash(FixPath(SpecialFolder.SharedApplicationData.NativePath)) + "Microsoft/Windows/Start Menu/Programs" 'All Users
		  StartPath = StartPath.ReplaceAll("/","\")
		  
		  
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
		          
		          'GlennGlennGlenn - ReEnabled Below 2 after testing
		          'BuildStartMenuLocations()
		          'BuildMenuStyleFolder()
		          
		          SetMenuStyle.Text = MenuStyle 'Update GUI to how new menu style
		        Else
		          MsgBox ComboMenuStyle.Text+" not available to use as Menu"
		          Return
		        End If
		      End If
		    End If
		  End If
		  
		  'Load In Defaults (If Not already in)
		  
		  'Load In Menu Default Items
		  If LoadedDefaults = False Then
		    Dim FirstBit As String
		    Dim IDClean As String
		    Dim Valid As Boolean
		    LoadedDefaults = True
		    If Exist(Slash(ToolPath)+"MenuDefaults.ini") Then
		      LineIn = LoadDataFromFile(Slash(ToolPath)+"MenuDefaults.ini")
		      LineIn = LineIn.ReplaceAll(Chr(13),Chr(10))
		      LineIn = LineIn.ReplaceAll(Chr(10)+Chr(10),Chr(10))
		      Sp()=LineIn.Split(Chr(10))
		      StartMenuDefaultsCount = 0 ' Clear Styles Count
		      If Sp.Count >= 1 Then
		        For I = 1 To Sp.Count -1
		          Data = Right(Sp(I), Len(Sp(I))-InStr(Sp(I),"="))
		          If Sp(I).IndexOf("=") >=1 Then
		            ID = Left(Sp(I), Sp(I).IndexOf("="))
		          Else
		            Id = Sp(I).Trim
		          End If
		          
		          FirstBit = Left(ID,1)
		          
		          Select Case FirstBit
		          Case ";" 'Do Nothing
		          Case "[" 'Item Header, add new item
		            Valid = False
		            IDClean = ID.ReplaceAll("[","").ReplaceAll("]","") 'Remove Square Brackets
		            ID = IDClean 'Keep without Square Brackets to compare if blocked
		            IDClean = IDClean.ReplaceAll(".WIN_8","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_7","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_2008R2","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_2008","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_VISTA","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_2003","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_XPe","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_XP","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_2000","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".OSARCH_x86","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_None","") 'Remove This
		            
		            If ID = IDClean Then Valid = True
		            
		            'Clean the rest out
		            IDClean = IDClean.ReplaceAll(".lnk","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".WIN_10","") 'Remove This
		            IDClean = IDClean.ReplaceAll(".OSARCH_x64","") 'Remove This
		            
		            ID = IDClean
		            
		            If Valid = True Then
		              StartMenuDefaultsCount = StartMenuDefaultsCount + 1 ' Not 0 Based
		              StartMenuDefaults(StartMenuDefaultsCount).Name = ID
		              StartMenuDefaults(StartMenuDefaultsCount).Catalog = "Other" 'Set a default, in case it tried to use blank catalog
		              StartMenuDefaults(StartMenuDefaultsCount).WorkingDir = "C:\" 'Set a default, in case it tried to use blank Working Dir
		            End If
		          Case Else 'Most Likely a data line or blank
		            If Valid Then ' Only Process Valid Items
		              Select Case ID
		              Case "Target"
		                StartMenuDefaults(StartMenuDefaultsCount).Target = ExpDefaults(Data)
		              Case "Arguments"
		                StartMenuDefaults(StartMenuDefaultsCount).Arguments = ExpDefaults(Data)
		              Case "WorkingDir"
		                StartMenuDefaults(StartMenuDefaultsCount).WorkingDir = ExpDefaults(Data)
		              Case "Icon"
		                StartMenuDefaults(StartMenuDefaultsCount).Icon = ExpDefaults(Data)
		              Case "Index"
		                StartMenuDefaults(StartMenuDefaultsCount).Index = Data.ToInteger
		              Case "Description"
		                StartMenuDefaults(StartMenuDefaultsCount).Description = Data
		              Case "Default"
		                StartMenuDefaults(StartMenuDefaultsCount).Default = ExpDefaults(Data)
		              Case "Catalog"
		                StartMenuDefaults(StartMenuDefaultsCount).Catalog = Data.ReplaceAll("|",";") '+";" 'Trying to split items so they dual sort instead
		              Case "Shortcut"
		                StartMenuDefaults(StartMenuDefaultsCount).Shortcut = Data
		              Case "HotKey"
		                StartMenuDefaults(StartMenuDefaultsCount).HotKey = Data
		              End Select
		            End If
		            
		          End Select
		          'MsgBox "ID: "+ID+" Data: "+ Data
		        Next
		        'StartMenuDefaultsCount = StartMenuDefaultsCount - 1 'It's no 0 Based - it's 1 based, if = 0 then error
		      End If
		    End If
		  End If
		  
		  
		  'If Found Defaults process them
		  If StartMenuDefaultsCount >= 1 Then
		    LnkCount = 0
		    For I = 1 To StartMenuDefaultsCount
		      
		      'Make ItemLLItem contain the link data so can use MakeLinks routine to do the task of cleaning from other menu styles etc
		      If StartMenuDefaults(I).Shortcut = "" Then
		        ItemLLItem.TitleName = StartMenuDefaults(I).Name
		      Else
		        ItemLLItem.TitleName = StartMenuDefaults(I).Shortcut 'Use Shortcut Name instead of Title (Maybe?) May cause non sorts?
		      End If
		      
		      ItemLLItem.StartMenuSourcePath = StartMenuDefaults(I).Default.ReplaceAll(StartPath+"\","") 'Added "\" To See if Helps make folders
		      
		      ItemLLItem.Catalog = StartMenuDefaults(I).Catalog
		      ItemLLItem.FileIcon = StartMenuDefaults(I).Icon
		      
		      If Exist(StartMenuDefaults(I).Target) Then
		        If Debugging Then Debug("Default Found: "+ItemLLItem.TitleName+" Target: "+StartMenuDefaults(I).Target + Chr(10)+"StartMenuSorcePath: "+ItemLLItem.StartMenuSourcePath)
		        LnkCount = LnkCount + 1
		        ItemLnk(LnkCount).Title = ItemLLItem.TitleName 'Not 0 Based?
		        ItemLnk(LnkCount).Comment = StartMenuDefaults(I).Description 'I call the short blurb a comment because the description is use by LL Store to show details info for each shortcut
		        ItemLnk(LnkCount).Link.TargetPath = StartMenuDefaults(I).Target
		        ItemLnk(LnkCount).Link.Arguments = StartMenuDefaults(I).Arguments
		        ItemLnk(LnkCount).Link.WorkingDirectory = StartMenuDefaults(I).WorkingDir
		        ItemLnk(LnkCount).Link.IconLocation = StartMenuDefaults(I).Icon
		        ItemLnk(LnkCount).Categories = StartMenuDefaults(I).Catalog
		        ItemLnk(LnkCount).StartSourceMenu = ItemLLItem.StartMenuSourcePath
		      Else
		        If Debugging Then Debug("Default Not Found: "+ItemLLItem.TitleName+" Target: "+StartMenuDefaults(I).Target + Chr(10)+"StartMenuSorcePath: "+ItemLLItem.StartMenuSourcePath)
		      End If
		      'CreateShortcut(ItemLnk(I).Title, Target, Slash(FixPath(ItemLnk(I).Link.WorkingDirectory)), Slash(FixPath(LinkOutPathSet)))
		      
		    Next
		    If LnkCount >= 1 Then MakeLinks 'Do All Links at once, to speed it up
		  End If
		  
		  'Data = ""
		  'If StartMenuDefaultsCount >= 1 Then
		  'For I = 0 To StartMenuDefaultsCount
		  'Data = Data + StartMenuDefaults(I).Name +" "+ StartMenuDefaults(I).Target + Chr(10)
		  'Next
		  'If Data <> "" Then MsgBox Data
		  'End If
		  
		  
		  
		  ''Enable Them Again
		  'ButtonSetMenuStyle.Enabled = True
		  'ComboMenuStyle.Enabled = True
		  'CheckCleanUp.Enabled = True
		  'MsgBox "Done Creating Defaults"
		  'Return 'GlennGlennGlenn - Quit For now, to test only making the Defaults.
		  
		  
		  
		  
		  
		  Tims = (System.Microseconds/1000000)-StartTimeStamp
		  If Debugging Then Debug("* (Build Menu Folder Done) Time Since Start "+Tims.ToString)
		  
		  'Resort/Clean Here
		  If CheckCleanUp.Value = True Then
		    QueueDeltree = True
		    QueueDeltreeMajor = True
		    QueueDeltreeJobs = ""
		    DelJobsList.RemoveAll
		    
		    ResortStartMenu() 'Disabled for now so I can test cleaner - re-enable (GlennGlennGlenn)
		    
		    Tims = (System.Microseconds/1000000)-StartTimeStamp
		    If Debugging Then Debug("* (Resort Job Done) Time Since Start "+Tims.ToString)
		    
		    'Delete all items at once, MUCH faster
		    QueueDeltree = False
		    QueueDeltreeMajor = False ' Deltrees done
		    'Res = RunCommandResults 
		    RunCommand(QueueDeltreeJobs)
		    
		    'If Debugging Then Debug ("* Delete Menu Sort Jobs ***")
		    'If Debugging Then Debug ("Sent In:"+Chr(10)+ QueueDeltreeJobs)
		    'If Debugging Then Debug ("Results:"+Chr(10)+ Res)
		    
		    
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
		  
		  If Loading.SortMenuStyle = False Then ' Only show if not called from command line
		    If CheckCleanUp.Value = False Then
		      MsgBox "Done Sorting"
		    Else
		      MsgBox "Done Sorting and Cleaning"
		    End If
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
	#tag EndMethod


#tag EndWindowCode

#tag Events ButtonSetMenuStyle
	#tag Event
		Sub Pressed()
		  SetPressed()
		  If CheckRegenerate.Value = True Then RegenerateItems() 'Do this when pressing button and check enabled
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonSetLinuxMenuSorting
	#tag Event
		Sub Pressed()
		  InstallLinuxMenuSorting(False)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonCleanDudLinuxMenuItems
	#tag Event
		Sub Pressed()
		  CleanDudLinuxMenuItems()
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonRegenerateItems
	#tag Event
		Sub Pressed()
		  RegenerateItems()
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonSetppDrives
	#tag Event
		Sub Pressed()
		  SetppDrives()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonRefreshppDrives
	#tag Event
		Sub Pressed()
		  RefreshppDrives()
		  
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
