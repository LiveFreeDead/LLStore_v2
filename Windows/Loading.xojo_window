#tag DesktopWindow
Begin DesktopWindow Loading
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
   HasTitleBar     =   True
   Height          =   200
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   0
   MenuBarVisible  =   False
   MinimumHeight   =   200
   MinimumWidth    =   440
   Resizeable      =   False
   Title           =   "LLStore Loading..."
   Type            =   0
   Visible         =   False
   Width           =   440
   Begin Timer FirstRunTime
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   50
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin DesktopLabel Status
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   56
      Index           =   -2147483648
      Italic          =   False
      Left            =   7
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   True
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "Loading..."
      TextAlignment   =   2
      TextColor       =   &cFFFFFF00
      Tooltip         =   ""
      Top             =   140
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   427
   End
   Begin Timer DownloadTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   50
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin Timer VeryFirstRunTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   1
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin Timer QuitCheckTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   1000
      RunMode         =   2
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin Timer DownloadScreenAndIcon
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   100
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin Timer InstallTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   120
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin Timer BuildTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   120
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
		  If ForceQuit = False Then
		    Loading.Hide
		    QuitApp
		    Return False
		  Else
		    Return False
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub Closing()
		  Debug("-- Loading Closed")
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  Debug("-- Loading Opening")
		  
		  If ForceQuit = True Then Return 'Don't bother even opening if set to quit
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AreWeOnline()
		  ''Check if Online
		  IsOnline = True
		  'ShellFast.Execute("curl -fsS http://google.com > /dev/null" )
		  Dim Test As String
		  'If TargetWindows Then
		  ShellFast.Execute("curl --head --silent --fail --max-time 3 --connect-timeout 2 " + Chr(34) + "http://www.google.com" + Chr(34))
		  'Else
		  'ShellFast.Execute("curl --head --silent " + Chr(34) + "http://www.google.com" + Chr(34)) '+" > /dev/null")
		  'End If
		  Test = Left(ShellFast.Result.Trim, 30)
		  'MsgBox Test
		  If Test.IndexOf("200 ") >=0 Then
		    'MsgBox ("Online")
		    IsOnline = True
		  ElseIf Test.IndexOf("201 ") >=0 Then
		    'MsgBox ("Online")
		    IsOnline = True
		  ElseIf Test.IndexOf("202 ") >=0 Then
		    'MsgBox ("Online")
		    IsOnline = True
		  ElseIf Test.IndexOf("203 ") >=0 Then
		    'MsgBox ("Online")
		    IsOnline = True
		  ElseIf Test.IndexOf("204 ") >=0 Then
		    'MsgBox ("Online")
		    IsOnline = True
		  ElseIf Test.IndexOf("205 ") >=0 Then
		    'MsgBox ("Online")
		    IsOnline = True
		  ElseIf Test.IndexOf("206 ") >=0 Then
		    'MsgBox ("Online")
		    IsOnline = True
		  Else
		    'MsgBox ("Offline")
		    IsOnline = False
		  End If
		  'If  ShellFast.Result.Trim <> "" Then IsOnline = False
		  'If Test.Trim = "" Then IsOnline = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckCompatible()
		  If Debugging Then Debug("- Starting Check Compatible -")
		  App.DoEvents(1) 'This makes the Load Screen Update the Status Text, Needs to be in each Function and Sub call
		  
		  Dim I As Integer
		  Dim DeTest As String
		  Dim RowCount As Integer = Data.Items.RowCount
		  
		  ' Cache all column indices ONCE before the loop — was up to 10 dictionary lookups per item
		  Dim OSCompatCol  As Integer = Data.GetDBHeader("OSCompatible")
		  Dim BuildTypeCol As Integer = Data.GetDBHeader("BuildType")
		  Dim ArchCol      As Integer = Data.GetDBHeader("ArchCompatible")
		  Dim DECol        As Integer = Data.GetDBHeader("DECompatible")
		  Dim PMCol        As Integer = Data.GetDBHeader("PMCompatible")
		  Dim HiddenCol    As Integer = Data.GetDBHeader("Hidden")
		  
		  ' Cache frequently-tested globals as locals for tighter inner loop
		  Dim IsWin  As Boolean = TargetWindows
		  Dim IsLin  As Boolean = TargetLinux
		  Dim SysArch As String = SysArchitecture
		  Dim SysDE   As String = SysDesktopEnvironment
		  Dim SysPM   As String = SysPackageManager
		  
		  For I = 0 To RowCount - 1
		    Data.Items.CellTextAt(I, OSCompatCol) = "T" 'Default to Enabled on current OS
		    
		    If IsWin Then 'If Windows session, hide linux things that may be in wrong paths
		      DeTest = Data.Items.CellTextAt(I, BuildTypeCol)
		      If DeTest = "LLApp" Or DeTest = "LLGame" Then
		        Data.Items.CellTextAt(I, OSCompatCol) = "F"
		        Data.Items.CellTextAt(I, HiddenCol) = "T" 'Make sure they are NOT shown ever
		        Continue ' No further compatibility checks needed — skip to next item
		      End If
		    End If
		    
		    'Do Arch first as that will always be needed
		    DeTest = Data.Items.CellTextAt(I, ArchCol)
		    If DeTest <> "" Then 'Only do Items with Values set
		      If DeTest.IndexOf(SysArch) >= 0 Or DeTest = "All" Then
		        Data.Items.CellTextAt(I, OSCompatCol) = "T"
		      Else 'Not Compatible
		        Data.Items.CellTextAt(I, OSCompatCol) = "F"
		        Continue ' Arch failed — no point checking DE/PM
		      End If
		    End If
		    
		    If Data.Items.CellTextAt(I, OSCompatCol) = "T" Then 'Will only continue if Arch Passed
		      DeTest = Data.Items.CellTextAt(I, DECol)
		      If DeTest <> "" Then 'Only do Items with Values set
		        If DeTest = "All-Linux" And IsLin Then DeTest = "All"
		        If DeTest.IndexOf(SysDE) >= 0 Or DeTest = "All" Then
		          Data.Items.CellTextAt(I, OSCompatCol) = "T"
		        Else 'Not Compatible
		          Data.Items.CellTextAt(I, OSCompatCol) = "F"
		          Continue ' DE failed — skip PM check
		        End If
		      End If
		    End If
		    
		    If Data.Items.CellTextAt(I, OSCompatCol) = "T" Then 'Will only continue if Arch+DE passed
		      DeTest = Data.Items.CellTextAt(I, PMCol)
		      If DeTest <> "" Then 'Only do Items with Values set
		        If DeTest.IndexOf(SysPM) >= 0 Or DeTest = "All" Then
		          Data.Items.CellTextAt(I, OSCompatCol) = "T"
		        Else 'Not Compatible
		          Data.Items.CellTextAt(I, OSCompatCol) = "F"
		        End If
		      End If
		    End If
		    
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckForLLStoreUpdates()
		  If Debugging Then Debug("- Starting Check For LLStore Updates -")
		  ForceQuit = False ' Need to do this if using downloader as that aborts if it's set
		  
		  'Check if Online
		  AreWeOnline()
		  
		  If IsOnline = False Then
		    If ForceFullUpdate = True Or ForceExeUpdate = True Then
		      MessageBox ("No Internet Detected")
		      Return
		    End If
		  End If
		  Dim CurrentVersion As Double
		  Dim CurrentVersionS As String
		  Dim OnlineVersion As Double
		  Dim OnlineVersionS As String
		  Dim F As FolderItem
		  
		  'Cleanup Updated Store
		  Deltree Slash(AppPath)+"llstoreold"
		  Deltree Slash(AppPath)+"llstoreold.exe"
		  Deltree Slash(AppPath)+"XojoGUIFramework64old.dll"
		  Deltree Slash(AppPath)+"icudt73old.dll"
		  Deltree Slash(AppPath)+"icuin73old.dll"
		  Deltree Slash(AppPath)+"icuuc73old.dll"
		  Deltree Slash(AppPath)+"msvcr120old.dll"
		  Deltree Slash(AppPath)+"prntvptold.dll"
		  Deltree Slash(AppPath)+"vcruntime140old.dll"
		  Deltree Slash(AppPath)+"vcruntime140_1old.dll"
		  Deltree Slash(AppPath)+"llstore Libs\Cryptox64old.dll"
		  Deltree Slash(AppPath)+"llstore Libs\GZipx64old.dll"
		  Deltree Slash(AppPath)+"llstore Libs\Internet Encodingsx64old.dll"
		  Deltree Slash(AppPath)+"llstore Libs\Shellx64old.dll"
		  
		  'Check Version - direct async curl to stdout, skips DownloadTimer validation round-trip
		  ' Old path: AreWeOnline (1 round trip) + HEAD validation (1) + wget download (1) = 3 calls
		  ' New path: single curl fetch to stdout = 1 call, result available immediately on completion
		  Dim VersionURL As String
		  If App.MajorVersion = 1 Then
		    VersionURL = "https://github.com/LiveFreeDead/LLStore/raw/refs/heads/main/version.ini"
		  Else
		    VersionURL = "https://github.com/LiveFreeDead/LLStore_v2/raw/refs/heads/main/version.ini"
		  End If
		  
		  Dim VerShell As New Shell
		  VerShell.TimeOut = -1
		  VerShell.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  VerShell.Execute("curl -fsSL --max-time 5 --connect-timeout 5 " + Chr(34) + VersionURL + Chr(34))
		  
		  TimeOut = System.Microseconds + (6 * 1000000) ' 6 second hard timeout
		  While VerShell.IsRunning
		    App.DoEvents(20)
		    If System.Microseconds >= TimeOut Then
		      VerShell.Close
		      Exit
		    End If
		  Wend
		  
		  OnlineVersionS = VerShell.Result.Trim
		  
		  OnlineVersion = OnlineVersionS.ToDouble
		  
		  CurrentVersionS = Str(App.MajorVersion)+"."+Str(App.MinorVersion)
		  CurrentVersion = CurrentVersionS.ToDouble
		  
		  If Debugging Then Debug("--- Update Store Check ---")
		  If Debugging Then Debug("Running Version: " + CurrentVersionS +" Online Version Found: " + OnlineVersionS)
		  
		  Dim MajorRemote, MajorLocal As Double
		  MajorLocal = App.MajorVersion
		  MajorRemote = Val(Left(OnlineVersionS,OnlineVersionS.IndexOf(".")))
		  'MajorRemote = MajorRemote + 1
		  
		  If MajorRemote > MajorLocal  Or ForceFullUpdate = True Then
		    Dim Success As Boolean
		    'MsgBox "Full Update - Local: "+MajorLocal.ToString+" Remote: "+MajorRemote.ToString
		    
		    'Updating
		    UpdateLoading("Updating Full Store v" +CurrentVersionS+ " to v"+OnlineVersionS)
		    
		    GetOnlineFile ("https://github.com/LiveFreeDead/LastOSLinux_Repository/raw/refs/heads/main/llstore_latest.zip",Slash(TmpPath)+"llstore_latest.zip")
		    
		    While Downloading 'Wait for download to finish
		      App.DoEvents(20)
		      
		      If Exist(Slash(RepositoryPathLocal)+"FailedDownload") Then
		        Deltree(Slash(RepositoryPathLocal)+"FailedDownload")
		        Exit
		      End If
		      
		    Wend
		    
		    If TargetWindows Then
		      'Do Windows .exe
		      If Exist(Slash(TmpPath)+"llstore_latest.zip") Then
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"llstore.exe"+Chr(34) + " "+"llstoreold.exe") 'Rename
		        
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"XojoGUIFramework64.dll"+Chr(34) + " "+"XojoGUIFramework64old.dll") 'Rename file that wont overwrite
		        
		        
		        
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"icudt73.dll"+Chr(34) + " "+"icudt73old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"icuin73.dll"+Chr(34) + " "+"icuin73old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"icuuc73.dll"+Chr(34) + " "+"icuuc73old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"llstore Libs\Cryptox64.dll"+Chr(34) + " "+"Cryptox64old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"llstore Libs\GZipx64.dll"+Chr(34) + " "+"GZipx64old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"llstore Libs\Internet Encodingsx64.dll"+Chr(34) + " "+"Internet Encodingsx64old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"llstore Libs\Shellx64.dll"+Chr(34) + " "+"Shellx64old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"msvcr120.dll"+Chr(34) + " "+"msvcr120old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"prntvpt.dll"+Chr(34) + " "+"prntvptold.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"vcruntime140.dll"+Chr(34) + " "+"vcruntime140old.dll") 'Rename file that wont overwrite
		        ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"vcruntime140_1.dll"+Chr(34) + " "+"vcruntime140_1old.dll") 'Rename file that wont overwrite
		        
		        
		        
		        
		        'Extract full package here now I've renamed the main executable that is in use (Libraries may still crash things, we'll see)
		        Success = Extract(Slash(TmpPath)+"llstore_latest.zip",AppPath, "")
		      End If
		      
		    Else 'Linux
		      If Exist(Slash(TmpPath)+"llstore_latest.zip") Then
		        'Rename Existing as it's running
		        ShellFast.Execute ("mv -f "+Chr(34)+Slash(AppPath)+"llstore"+Chr(34) + " "+Chr(34)+Slash(AppPath)+"llstoreold"+Chr(34)) 'Move
		        
		        'Extract full package here now I've renamed the main executable that is in use (Libraries may still crash things, we'll see)
		        Success = Extract(Slash(TmpPath)+"llstore_latest.zip",AppPath, "")
		        
		        ShellFast.Execute ("chmod 777 "+Chr(34)+Slash(AppPath)+"llstore"+Chr(34)) 'Change Read/Write/Execute to defaults
		      End If
		    End If
		    'ReRun the newer Store version
		    If TargetWindows Then
		      F = GetFolderItem(Slash(AppPath)+"llstore.exe", FolderItem.PathTypeNative)
		      F.Launch
		    Else
		      F = GetFolderItem(Slash(AppPath)+"llstore", FolderItem.PathTypeNative)
		      F.Launch
		    End If
		    
		    'These Flags allow it to Quit after the update without rescanning when another timer triggers
		    'ForceQuit = True ' Not required as using QuitApp now
		    Quitting = True
		    'Main.Close
		    QuitApp
		    Return
		    
		  Else
		    'MsgBox "EXE Updates - Local: "+MajorLocal.ToString+" Remote: "+MajorRemote.ToString
		    If OnlineVersion > CurrentVersion Or ForceExeUpdate = True Then 'Is Newer, download and apply executables only, or if set to forced update
		      
		      'Updating Executables
		      UpdateLoading("Updating Executables v" +CurrentVersionS+ " to v"+ OnlineVersionS)
		      If App.MajorVersion = 1 Then ' Changed below so it only updates the current running exe, no point in a Linux user constantly updating the windows exe
		        If TargetWindows = False Then GetOnlineFile ("https://github.com/LiveFreeDead/LLStore/raw/refs/heads/main/llstore",Slash(TmpPath)+"llstore")
		        If TargetWindows = True Then GetOnlineFile ("https://github.com/LiveFreeDead/LLStore/raw/refs/heads/main/llstore.exe",Slash(TmpPath)+"llstore.exe")
		      Else
		        If TargetWindows = False Then GetOnlineFile ("https://github.com/LiveFreeDead/LLStore_v2/raw/refs/heads/main/llstore",Slash(TmpPath)+"llstore")
		        If TargetWindows = True Then GetOnlineFile ("https://github.com/LiveFreeDead/LLStore_v2/raw/refs/heads/main/llstore.exe",Slash(TmpPath)+"llstore.exe")
		      End If
		      
		      While Downloading 'Wait for download to finish
		        App.DoEvents(20)
		        
		        If Exist(Slash(RepositoryPathLocal)+"FailedDownload") Then
		          Deltree(Slash(RepositoryPathLocal)+"FailedDownload")
		          Exit
		        End If
		        
		      Wend
		      
		      If TargetWindows Then
		        'Do Windows .exe
		        If Exist(Slash(TmpPath)+"llstore.exe") Then
		          ShellFast.Execute ("ren "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+"llstore.exe"+Chr(34) + " "+"llstoreold.exe") 'Rename
		          ShellFast.Execute ("move /y "+Chr(34)+Slash(TmpPath).ReplaceAll("/","\")+"llstore.exe"+Chr(34) + " "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+Chr(34)) 'Move 
		        End If
		        
		        If Exist(Slash(TmpPath)+"llstore") Then
		          Deltree (Slash(AppPath)+"llstore")
		          ShellFast.Execute ("move /y "+Chr(34)+Slash(TmpPath).ReplaceAll("/","\")+"llstore"+Chr(34) + " "+Chr(34)+Slash(AppPath).ReplaceAll("/","\")+Chr(34)) 'Move 
		        End If
		        
		      Else 'Linux
		        If Exist(Slash(TmpPath)+"llstore") Then
		          'Rename Existing as it's running
		          ShellFast.Execute ("mv -f "+Chr(34)+Slash(AppPath)+"llstore"+Chr(34) + " "+Chr(34)+Slash(AppPath)+"llstoreold"+Chr(34)) 'Move
		          'Replace Original and Make Executable
		          ShellFast.Execute ("mv -f "+Chr(34)+Slash(TmpPath)+"llstore"+Chr(34) + " "+Chr(34)+Slash(AppPath)+"llstore"+Chr(34)) 'Move 
		          ShellFast.Execute ("chmod 777 "+Chr(34)+Slash(AppPath)+"llstore"+Chr(34)) 'Change Read/Write/Execute to defaults
		        End If
		        
		        'Now do Windows .exe
		        If Exist(Slash(TmpPath)+"llstore.exe") Then
		          Deltree (Slash(AppPath)+"llstore.exe")
		          ShellFast.Execute ("mv -f "+Chr(34)+Slash(TmpPath)+"llstore.exe"+Chr(34) + " "+Chr(34)+Slash(AppPath)+"llstore.exe"+Chr(34)) 'Move 
		        End If
		      End If
		      'ReRun the newer Store version
		      If TargetWindows Then
		        F = GetFolderItem(Slash(AppPath)+"llstore.exe", FolderItem.PathTypeNative)
		        F.Launch
		      Else
		        F = GetFolderItem(Slash(AppPath)+"llstore", FolderItem.PathTypeNative)
		        F.Launch
		      End If
		      
		      'These Flags allow it to Quit after the update without rescanning when another timer triggers
		      'ForceQuit = True ' Not required as using QuitApp now
		      Quitting = True
		      'Main.Close
		      QuitApp
		      Return
		    Else
		      'Continue without quitting
		    End If 
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckInstalled()
		  If Debugging Then Debug("- Starting Check Installed Items -")
		  App.DoEvents(1) 'This makes the Load Screen Update the Status Text, Needs to be in each Function and Sub call
		  
		  Dim I As Integer
		  Dim F As FolderItem
		  Dim RowCount As Integer = Data.Items.RowCount
		  
		  If RowCount <= 0 Then Return
		  
		  ' Cache column indices ONCE before the loop — avoids N × dictionary lookups per column
		  Dim PathAppCol  As Integer = Data.GetDBHeader("PathApp")
		  Dim InstalledCol As Integer = Data.GetDBHeader("Installed")
		  If PathAppCol < 0 Or InstalledCol < 0 Then Return ' Columns missing
		  
		  For I = 0 To RowCount - 1
		    Dim PathStr As String = Data.Items.CellTextAt(I, PathAppCol)
		    
		    ' Items with no install path cannot be installed — mark immediately and skip
		    If PathStr = "" Then
		      Data.Items.CellTextAt(I, InstalledCol) = "F"
		      Continue
		    End If
		    
		    ' Paths are already fully expanded at load time (GetItem / LoadDB both call ExpPath).
		    ' Only run the expensive 20+ ReplaceAll pass when unexpanded variables are present.
		    If PathStr.IndexOf("%") >= 0 Then PathStr = ExpPath(PathStr)
		    
		    F = GetFolderItem(PathStr, FolderItem.PathTypeNative)
		    If F <> Nil And F.Exists Then
		      Data.Items.CellTextAt(I, InstalledCol) = "T"
		    Else
		      Data.Items.CellTextAt(I, InstalledCol) = "F"
		    End If
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckPath(DirToCheck As String)
		  Dim F As FolderItem
		  
		  Try
		    If TargetWindows Then
		      F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeNative)
		    Else
		      F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		    End If
		    'If Debugging Then Debug("Checking Item Path: "+ FixPath(F.NativePath)) 'Don't need to show all these, the parent folder will do.
		    If F.IsFolder And F.IsReadable Then
		      Data.ScanPaths.AddRow(FixPath(F.NativePath))
		      If Debugging Then Debug("Adding Item Path: "+ FixPath(F.NativePath))
		    End If
		  Catch
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CompareVersionStrings(V1 As String, V2 As String) As Integer
		  ' Compare two pre-cleaned version strings component by component.
		  ' Both strings should already have noise (spaces, dashes, beta, etc.) removed,
		  ' and dots retained as the separator between numeric parts.
		  '
		  ' Returns: 1 if V1 > V2, -1 if V1 < V2, 0 if equal.
		  '
		  ' Examples:
		  '   "1.10.0" vs "1.9.0"  → 1  (correct; old dot-strip approach gave wrong result)
		  '   "2.0"    vs "1.99.9" → 1
		  '   "1.2"    vs "1.2.0"  → 0  (missing trailing parts treated as zero)
		  '   "1.2.3"  vs "1.2.4"  → -1
		  '
		  ' Only the first two components are strictly required; if one version has more
		  ' parts than the other, the shorter one's missing parts are treated as 0.
		  
		  If V1 = "" And V2 = "" Then Return 0
		  If V1 = "" Then Return -1 'No version is treated as lower
		  If V2 = "" Then Return 1
		  
		  Dim P1() As String = V1.Split(".")
		  Dim P2() As String = V2.Split(".")
		  
		  Dim Len1 As Integer = P1.Count
		  Dim Len2 As Integer = P2.Count
		  Dim MaxLen As Integer
		  If Len1 > Len2 Then MaxLen = Len1 Else MaxLen = Len2
		  
		  Dim K As Integer
		  For K = 0 To MaxLen - 1
		    Dim N1 As Integer = 0
		    Dim N2 As Integer = 0
		    If K < Len1 Then N1 = Val(P1(K))
		    If K < Len2 Then N2 = Val(P2(K))
		    If N1 > N2 Then Return 1
		    If N1 < N2 Then Return -1
		  Next K
		  
		  Return 0 'All components equal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExtractAll()
		  If Debugging Then Debug("--- Starting Extract All ---")
		  
		  App.DoEvents(1) 'This makes the Load Screen Update the Status Text, Needs to be in each Function and Sub call where it goes slow?, this also slows down loading a little
		  
		  Dim F As FolderItem
		  Dim I As Integer
		  Dim Exten, ItemInn As String
		  Dim TmpPathItems As String = Slash(TmpPath)+"items/"
		  Dim TmpItem As String
		  Dim ExcludesIncludes As String
		  Dim T As TextOutputStream
		  Dim EOL As String
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = -1 'Give it All the time it needs
		  
		  Dim ScriptOut As String 
		  Dim ScriptOutMkDir As String
		  
		  Dim ScriptOutFile As String = Slash(TmpPath)+"ExtractAll.sh"
		  
		  Dim ScriptOutMkDirFile As String = Slash(TmpPath)+"MakeDirAll.sh"
		  
		  If TargetWindows Then ScriptOutFile = Slash(TmpPath)+"ExtractAll.cmd" '.cmd is executable in Windows
		  
		  If TargetWindows Then ScriptOutMkDirFile = Slash(TmpPath)+"MakeDirAll.cmd" '.cmd is executable in Windows
		  
		  Dim S As string
		  if TargetMacOS then
		    S = "mkdir -p "
		  elseif TargetWindows then
		    S = "mkdir "
		  elseif TargetLinux then
		    S = "mkdir -p "
		  end if
		  
		  Dim Zip As String
		  Zip = Linux7z
		  if TargetWindows Then Zip = Win7z
		  
		  Dim TmpNumber As Integer = 10000 'Randomiser.InRange(10000, 20000)
		  TmpItem = Slash(TmpPathItems+"tmp" + TmpNumber.ToString)
		  While Exist(TmpItem)
		    TmpNumber = TmpNumber + 1000 'Count up by 1000 Items until none found, incase old temp items exist
		    TmpItem = Slash(TmpPathItems+"tmp" + TmpNumber.ToString)
		  Wend
		  
		  If Data.ScanItems.RowCount >=1 Then
		    For I = 0 To Data.ScanItems.RowCount - 1
		      Loading.Status.Text = "Processing Item: "+ Str(I)+"/"+Str(Data.ScanItems.RowCount - 1)
		      ItemInn = Data.ScanItems.CellTextAt(I,0)
		      
		      ItemInn = ItemInn.ReplaceAll("\","/") 'Linux Paths
		      
		      TmpNumber = TmpNumber + 1 'Can't use Random folders as it may duplicate
		      TmpItem = Slash(TmpPathItems+"tmp" + TmpNumber.ToString)
		      
		      'Store the Tmp Path to the item
		      Data.ScanItems.CellTextAt(I,1) = TmpItem 'Pre extracted Items are stored in the path to access from  LoadLLFile, if one isn't supplied it'll revert back to extractiung one at a time :D
		      
		      If TargetWindows Then
		        EOL = Chr(10) '+Chr(13) 'Don't need Chr(13) in windows command lines I don't think
		      Else
		        EOL = Chr(10)
		      End If
		      F = GetFolderItem(ItemInn,FolderItem.PathTypeNative)
		      If F.Exists Then
		        Exten = Right(ItemInn,4)
		        Exten = Exten.Lowercase
		        Select Case Exten
		        Case ".tar"
		          ScriptOutMkDir = ScriptOutMkDir + S + Chr(34)+TmpItem+Chr(34) + EOL 'Make Dir in the script before extraction command
		          ScriptOutMkDir = ScriptOutMkDir + EOL'Blank Line between items so they don't duplicate wrong
		          ExcludesIncludes = " LLApp.lla LLGame.llg LLScript.sh LLScript_Sudo.sh LLFile.sh LLApp.jpg LLApp.png LLApp.ico LLApp.svg LLGame.jpg LLGame.png LLGame.ico LLGame.svg LLApp1.jpg LLGame1.jpg LLApp2.jpg LLGame2.jpg LLApp3.jpg LLGame3.jpg LLApp4.jpg LLGame4.jpg LLApp5.jpg LLGame5.jpg LLApp6.jpg LLGame6.jpg"
		          ScriptOut = ScriptOut + Zip + " -mtc -aoa x "+Chr(34)+ItemInn+Chr(34)+ " -o"+Chr(34) + TmpItem+Chr(34)+ExcludesIncludes + EOL
		          Data.ScanItems.CellTextAt(I,2) = Left(ItemInn,InStrRev(ItemInn,"/")) 'Gets Parent Path
		        Case ".apz", ".pgz"
		          ScriptOutMkDir = ScriptOutMkDir + S + Chr(34)+TmpItem+Chr(34) + EOL 'Make Dir in the script before extraction command
		          ScriptOutMkDir = ScriptOutMkDir + EOL'Blank Line between items so they don't duplicate wrong
		          ExcludesIncludes = " ssApp.app ppApp.app ppGame.ppg ssApp.jpg ppApp.jpg ssApp.png ppApp.png ssApp.ico ppApp.ico ppGame.jpg ppGame.png ppGame.ico ppGame1.jpg ppGame2.jpg ppGame3.jpg ppGame4.jpg ppGame5.jpg ppGame6.jpg ppApp1.jpg ppApp2.jpg ppApp3.jpg ppApp4.jpg ppApp5.jpg ppApp6.jpg ssApp1.jpg ssApp2.jpg ssApp3.jpg ssApp4.jpg ssApp5.jpg ssApp6.jpg"
		          ScriptOut = ScriptOut + Zip + " -mtc -aoa x "+Chr(34)+ItemInn+Chr(34)+ " -o"+Chr(34) + TmpItem+Chr(34)+ExcludesIncludes + EOL
		          Data.ScanItems.CellTextAt(I,2) = Left(ItemInn,InStrRev(ItemInn,"/")) 'Gets Parent Path
		        Case Else'Not a compressed Item' just nab the path
		          Data.ScanItems.CellTextAt(I,2) = Left(ItemInn,InStrRev(ItemInn,"/")-1) 'Gets Parent Path
		          Data.ScanItems.CellTextAt(I,2) = Left(Data.ScanItems.CellTextAt(I,2),InStrRev(Data.ScanItems.CellTextAt(I,2),"/")) 'Gets Parent Path
		        End Select
		      End If
		    Next
		    
		    F = GetFolderItem(ScriptOutFile, FolderItem.PathTypeNative)
		    If F <> Nil Then
		      If F.IsWriteable Then 'And WritableLocation(F) = True
		        If F.Exists Then F.Delete
		        T = TextOutputStream.Create(F)
		        T.Write(ScriptOut)
		        T.Close
		        Sh.Execute ("chmod 775 "+Chr(34)+ScriptOutFile+Chr(34)) 'Change Read/Write/Execute to Output script
		      End If
		    End If
		    
		    F = GetFolderItem(ScriptOutMkDirFile, FolderItem.PathTypeNative)
		    If F <> Nil Then
		      If F.IsWriteable Then 'And WritableLocation(F) = True
		        If F.Exists Then F.Delete
		        T = TextOutputStream.Create(F)
		        T.Write(ScriptOutMkDir)
		        T.Close
		        Sh.Execute ("chmod 775 "+Chr(34)+ScriptOutMkDirFile+Chr(34)) 'Change Read/Write/Execute to Output script
		      End If
		    End If
		    
		    UpdateLoading("Making Folders...")
		    RunWait(ScriptOutMkDirFile)'Allows form to refresh
		    UpdateLoading("Extracting Compressed Items...")
		    RunWait(ScriptOutFile)'Allows form to refresh
		    UpdateLoading("Done Extracting Compressed Items...")
		    
		    'Try to Clean up Temp Folder
		    Deltree(ScriptOutFile)
		    Deltree(ScriptOutMkDirFile)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GenerateDataCategories()
		  App.DoEvents(1) 'This makes the Load Screen Update the Status Text, Needs to be in each Function and Sub call
		  
		  Dim I, J, K, CatCol, BuildTypeCol As Integer
		  Dim CatCheck As String
		  Dim Sp() As String
		  Dim HideCat As Boolean = False
		  Dim BuildType As String
		  
		  If ItemCount <=0 Then Return
		  
		  Dim SeenCats As New Dictionary  'O(1) seen-category lookup; avoids scanning listbox per category
		  CatCol = Data.GetDBHeader("Categories")
		  BuildTypeCol = Data.GetDBHeader("BuildType")
		  If CatCol = -1 Then Return 'Can't find the Column, it's broken, so return
		  For I = 0 To ItemCount
		    CatCheck = Data.Items.CellTextAt(I, CatCol)
		    BuildType = Data.Items.CellTextAt(I, BuildTypeCol)
		    
		    'Hide Linux items and Categories if in Windows
		    If TargetWindows Then
		      If BuildType = "LLApp" or BuildType = "LLGame" Then
		        Continue 'Don't even check it if in Windows and is a Linux Item
		      End If
		    End If
		    
		    Sp = CatCheck.Split(";")
		    For K = 0 To Sp.Count - 1
		      Sp(K) = Sp(K).Trim
		      If Right(Sp(K),4) = "Game" Then
		        Sp(K) = Left(Sp(K), Len(Sp(K))-4) 'Remove Game from Linux Categories
		      End If
		      If Sp(K) = "" Then Exit 'It's Empty, don't check or add
		      'Build the final category name, then do O(1) Dictionary check instead of scanning listbox
		      Dim CandCat As String = Sp(K)
		      If StoreMode = 0 Then
		        If BuildType = "LLGame" Or BuildType = "ppGame" Then
		          If Settings.SetHideGameCats.Value = False Then
		            CandCat = "Game " + Sp(K)
		          Else
		            CandCat = "Games"
		          End If
		        End If
		      End If
		      If Not SeenCats.HasKey(CandCat) Then
		        SeenCats.Value(CandCat) = True
		        'Restore original cross-check: if adding "Game X", also mark plain "X" as seen
		        'so a later non-game item with category "X" doesn't add it separately.
		        If Left(CandCat, 5) = "Game " Then SeenCats.Value(Mid(CandCat, 6)) = True
		        Data.Categories.AddRow(CandCat)
		      End If
		    Next K
		  Next
		  
		  'Sort the list Alphabettic
		  Data.Categories.SortingColumn = 0
		  Data.Categories.ColumnSortDirectionAt(0) = DesktopListBox.SortDirections.Ascending
		  Data.Categories.Sort ()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetAdminMode()
		  'Check If Admin Mode
		  If RunningInIDE = False Then
		    If FirstRun = False Then 'Only check it the first run, else you already quit or decided to run without admin
		      Quitting = False
		      If TargetWindows Then
		        If StoreMode = 0 Or StoreMode = 2 Or StoreMode = 4 Then 'If Install Mode or Installer then check has Admin, Or Install LLStore
		          If Debugging Then Debug("--- Checking Admin Mode in Windows")
		          If IsAdmin = False Then
		            Dim LLStoreAppExe As FolderItem
		            LLStoreAppExe = App.ExecutableFile
		            If InStr(LLStoreAppExe.NativePath, "Debugllstore.exe") <= 0 Then 'Don't request Admin if debugging code
		              
		              Dim RetVal as Boolean
		              RetVal = ShellExecuteEx(SEE_MASK_NOCLOSEPROCESS, _
		              0, _ //Window handle
		              StringToMB("runas"), _ //Operation to perform
		              StringToMB(LLStoreAppExe.NativePath), _ //Application path and name
		              StringToMB(System.CommandLine), _ //Additional parameters
		              StringToMB(LLStoreAppExe.Parent.NativePath), _ //Working Directory
		              SW_SHOWNORMAL, _
		              0, _
		              Nil, _
		              Nil, _
		              0, _
		              0, _
		              0, _
		              0)
		              
		              Loading.Show
		              App.DoEvents(1)
		              
		              If RetVal = False Then 'If denied UAC it will be false
		                Dim Ret As Integer
		                If StoreMode = 0 Then
		                  If Debugging Then Debug("Run Without Admin?")
		                  Ret = MsgBox ("Run LLStore Without Administrator Access", 52)
		                End If
		                If Ret = 7 Then
		                  ForceQuit = True
		                  Quitting = True
		                  QuitApp
		                  'Return
		                End If
		              Else
		                ForceQuit = True
		                Quitting = True
		                QuitApp
		                'Return
		              End If
		            End If
		            
		          End If
		        End If
		      End If
		      
		      If TargetWindows Then 'Make sure this only happens in Windows or makes random file called %WinDir%...
		        If IsAdmin = True Then AdminEnabled = True
		      End If
		    End If
		  End If 'End of Check Admin
		  
		  If Quitting = True Then
		    ForceQuit = True
		    QuitApp
		    Return ' If gets here then just return
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetItem(ItemInn As String, InnTmp As String = "") As Integer
		  If ItemInn = "" Then Return  -1 'Nothing given
		  
		  If Debugging Then Debug("Get Item: "+ ItemInn)
		  
		  Dim I, J As Integer
		  Dim F As FolderItem
		  Dim Exten As String
		  Dim Success As Boolean = False
		  
		  Dim MediaPath As String
		  Dim UniqueName As String = ""
		  Dim UniqueIcon As Boolean = False
		  
		  Dim FadeFile As String
		  
		  F = GetFolderItem(ItemInn,FolderItem.PathTypeNative)
		  If F.Exists Then
		    
		    Exten = Right(ItemInn,4)
		    Exten = Exten.Lowercase
		    Select Case Exten
		    Case ".lla"
		      Success = LoadLLFile (ItemInn)
		    Case ".llg"
		      Success = LoadLLFile (ItemInn)
		    Case ".app"
		      Success = LoadLLFile (ItemInn)
		    Case ".ppg"
		      Success = LoadLLFile (ItemInn)
		    Case ".tar"
		      Success = LoadLLFile (ItemInn, InnTmp) 'InnTmp is the PreExtracted items stored in the Data DB
		    Case".apz"
		      Success = LoadLLFile (ItemInn, InnTmp)
		    Case ".pgz"
		      Success = LoadLLFile (ItemInn, InnTmp)
		    End Select
		  End If
		  
		  'Checks
		  If ItemLLItem.TitleName = "" Then Return -1 'No Title given, don't add
		  'If ItemLLItem.Hidden = True Then Return -1 'Set as Hidden, hide it entirly. ' Don't Hide here, BAD idea as the DB loses access to its changes and it doesn't update the flags etc
		  
		  If Success = True Then ' Loaded Item fine, Add to Data
		    If Debugging Then Debug("Success Loading: "+ ItemInn)
		    ItemCount =  Data.Items.RowCount
		    Data.Items.AddRow(Data.Items.RowCount.ToString("000000")) 'This adds the Leading 0's or prefixes it to 6 digits as it sort Alphabettical, fixed 1,10,100,2 to 001,002,010,100 for example
		    
		    'Reference Only Keep
		    'LocalDBHeader = " BuildType Compressed HiddenAlways ShowAlways ShowSetupOnly Arch OS TitleName Version Categories Catalog Description URL Priority PathApp PathINI FileINI FileCompressed FileIcon FileScreenshot FileFader FileMovie Flags Tags Publisher Language Rating Additional Players License ReleaseVersion ReleaseDate RequiredRuntimes Builder InstalledSize LnkTitle LnkComment LnkDescription LnkCategories LnkRunPath LnkExec LnkArguments LnkFlags LnkAssociations LnkTerminal LnkMultiple LnkIcon LnkOSCompatible LnkDECompatible LnkPMCompatible ArchCompatible  NoInstall OSCompatible DECompatible PMCompatible ArchCompatible UniqueName Dependencies ""
		    
		    'Pre-resolve all column indices once via the O(1) Dictionary, then write directly.
		    'This replaces the old For/HeaderAt/Select Case loop (O(columns) per item).
		    Dim ciTitleName As Integer = Data.GetDBHeader("TitleName")
		    Dim ciVersion As Integer = Data.GetDBHeader("Version")
		    Dim ciDescription As Integer = Data.GetDBHeader("Description")
		    Dim ciPathApp As Integer = Data.GetDBHeader("PathApp")
		    Dim ciURL As Integer = Data.GetDBHeader("URL")
		    Dim ciCategories As Integer = Data.GetDBHeader("Categories")
		    Dim ciCatalog As Integer = Data.GetDBHeader("Catalog")
		    Dim ciBuildType As Integer = Data.GetDBHeader("BuildType")
		    Dim ciPriority As Integer = Data.GetDBHeader("Priority")
		    Dim ciPathINI As Integer = Data.GetDBHeader("PathINI")
		    Dim ciFileIcon As Integer = Data.GetDBHeader("FileIcon")
		    Dim ciFileFader As Integer = Data.GetDBHeader("FileFader")
		    Dim ciFileMovie As Integer = Data.GetDBHeader("FileMovie")
		    Dim ciFileINI As Integer = Data.GetDBHeader("FileINI")
		    Dim ciFileScreenshot As Integer = Data.GetDBHeader("FileScreenshot")
		    Dim ciTags As Integer = Data.GetDBHeader("Tags")
		    Dim ciPublisher As Integer = Data.GetDBHeader("Publisher")
		    Dim ciLanguage As Integer = Data.GetDBHeader("Language")
		    Dim ciLicense As Integer = Data.GetDBHeader("License")
		    Dim ciArch As Integer = Data.GetDBHeader("Arch")
		    Dim ciOS As Integer = Data.GetDBHeader("OS")
		    Dim ciRating As Integer = Data.GetDBHeader("Rating")
		    Dim ciReleaseVersion As Integer = Data.GetDBHeader("ReleaseVersion")
		    Dim ciReleaseDate As Integer = Data.GetDBHeader("ReleaseDate")
		    Dim ciBuilder As Integer = Data.GetDBHeader("Builder")
		    Dim ciInstalledSize As Integer = Data.GetDBHeader("InstalledSize")
		    Dim ciFlags As Integer = Data.GetDBHeader("Flags")
		    Dim ciHiddenAlways As Integer = Data.GetDBHeader("HiddenAlways")
		    Dim ciShowAlways As Integer = Data.GetDBHeader("ShowAlways")
		    Dim ciShowSetupOnly As Integer = Data.GetDBHeader("ShowSetupOnly")
		    Dim ciNoInstall As Integer = Data.GetDBHeader("NoInstall")
		    Dim ciUniqueName As Integer = Data.GetDBHeader("UniqueName")
		    Dim ciSelected As Integer = Data.GetDBHeader("Selected")
		    Dim ciCompressed As Integer = Data.GetDBHeader("Compressed")
		    Dim ciOSCompatible As Integer = Data.GetDBHeader("OSCompatible")
		    Dim ciDECompatible As Integer = Data.GetDBHeader("DECompatible")
		    Dim ciPMCompatible As Integer = Data.GetDBHeader("PMCompatible")
		    Dim ciArchCompatible As Integer = Data.GetDBHeader("ArchCompatible")
		    Dim ciLnkMultiple As Integer = Data.GetDBHeader("LnkMultiple")
		    Dim ciLnkTitle As Integer = Data.GetDBHeader("LnkTitle")
		    Dim ciLnkComment As Integer = Data.GetDBHeader("LnkComment")
		    Dim ciLnkDescription As Integer = Data.GetDBHeader("LnkDescription")
		    Dim ciLnkCategories As Integer = Data.GetDBHeader("LnkCategories")
		    Dim ciLnkRunPath As Integer = Data.GetDBHeader("LnkRunPath")
		    Dim ciLnkExec As Integer = Data.GetDBHeader("LnkExec")
		    Dim ciLnkArguments As Integer = Data.GetDBHeader("LnkArguments")
		    Dim ciLnkFlags As Integer = Data.GetDBHeader("LnkFlags")
		    Dim ciLnkAssociations As Integer = Data.GetDBHeader("LnkAssociations")
		    Dim ciLnkTerminal As Integer = Data.GetDBHeader("LnkTerminal")
		    Dim ciLnkIcon As Integer = Data.GetDBHeader("LnkIcon")
		    Dim ciLnkOSCompatible As Integer = Data.GetDBHeader("LnkOSCompatible")
		    Dim ciLnkDECompatible As Integer = Data.GetDBHeader("LnkDECompatible")
		    Dim ciLnkPMCompatible As Integer = Data.GetDBHeader("LnkPMCompatible")
		    Dim ciLnkArchCompatible As Integer = Data.GetDBHeader("LnkArchCompatible")
		    
		    'Write all fields directly — no loop, no string comparisons.
		    'ExpPath calls guarded with IndexOf("%") check to skip 40+ ReplaceAll ops
		    'for the vast majority of locally-scanned items that have no % tokens.
		    If ciTitleName >= 0 Then Data.Items.CellTextAt(ItemCount, ciTitleName) = ItemLLItem.TitleName
		    If ciVersion >= 0 Then Data.Items.CellTextAt(ItemCount, ciVersion) = ItemLLItem.Version
		    If ciDescription >= 0 Then Data.Items.CellTextAt(ItemCount, ciDescription) = ItemLLItem.Descriptions
		    If ciPathApp >= 0 Then
		      If ItemLLItem.PathApp.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.PathApp.IndexOf("\\") >= 0) Then
		        Data.Items.CellTextAt(ItemCount, ciPathApp) = ExpPath(ItemLLItem.PathApp)
		      Else
		        Data.Items.CellTextAt(ItemCount, ciPathApp) = ItemLLItem.PathApp
		      End If
		    End If
		    If ciURL >= 0 Then Data.Items.CellTextAt(ItemCount, ciURL) = ItemLLItem.URL
		    If ciCategories >= 0 Then Data.Items.CellTextAt(ItemCount, ciCategories) = ItemLLItem.Categories
		    If ciCatalog >= 0 Then Data.Items.CellTextAt(ItemCount, ciCatalog) = ItemLLItem.Catalog
		    If ciBuildType >= 0 Then Data.Items.CellTextAt(ItemCount, ciBuildType) = ItemLLItem.BuildType
		    If ciPriority >= 0 Then Data.Items.CellTextAt(ItemCount, ciPriority) = Str(ItemLLItem.Priority)
		    If ciPathINI >= 0 Then
		      If ItemLLItem.PathINI.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.PathINI.IndexOf("\\") >= 0) Then
		        Data.Items.CellTextAt(ItemCount, ciPathINI) = ExpPath(ItemLLItem.PathINI)
		      Else
		        Data.Items.CellTextAt(ItemCount, ciPathINI) = ItemLLItem.PathINI
		      End If
		    End If
		    If ciFileIcon >= 0 Then
		      If ItemLLItem.FileIcon.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.FileIcon.IndexOf("\\") >= 0) Then
		        Data.Items.CellTextAt(ItemCount, ciFileIcon) = ExpPath(ItemLLItem.FileIcon)
		      Else
		        Data.Items.CellTextAt(ItemCount, ciFileIcon) = ItemLLItem.FileIcon
		      End If
		    End If
		    If ciFileFader >= 0 Then
		      If ItemLLItem.FileFader.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.FileFader.IndexOf("\\") >= 0) Then
		        Data.Items.CellTextAt(ItemCount, ciFileFader) = ExpPath(ItemLLItem.FileFader)
		      Else
		        Data.Items.CellTextAt(ItemCount, ciFileFader) = ItemLLItem.FileFader
		      End If
		    End If
		    If ciFileMovie >= 0 Then
		      If ItemLLItem.FileMovie.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.FileMovie.IndexOf("\\") >= 0) Then
		        Data.Items.CellTextAt(ItemCount, ciFileMovie) = ExpPath(ItemLLItem.FileMovie)
		      Else
		        Data.Items.CellTextAt(ItemCount, ciFileMovie) = ItemLLItem.FileMovie
		      End If
		    End If
		    If ciFileINI >= 0 Then
		      If ItemLLItem.FileINI.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.FileINI.IndexOf("\\") >= 0) Then
		        Data.Items.CellTextAt(ItemCount, ciFileINI) = ExpPath(ItemLLItem.FileINI)
		      Else
		        Data.Items.CellTextAt(ItemCount, ciFileINI) = ItemLLItem.FileINI
		      End If
		    End If
		    If ciFileScreenshot >= 0 Then
		      If ItemLLItem.FileScreenshot.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.FileScreenshot.IndexOf("\\") >= 0) Then
		        Data.Items.CellTextAt(ItemCount, ciFileScreenshot) = ExpPath(ItemLLItem.FileScreenshot)
		      Else
		        Data.Items.CellTextAt(ItemCount, ciFileScreenshot) = ItemLLItem.FileScreenshot
		      End If
		    End If
		    If ciTags >= 0 Then Data.Items.CellTextAt(ItemCount, ciTags) = ItemLLItem.Tags
		    If ciPublisher >= 0 Then Data.Items.CellTextAt(ItemCount, ciPublisher) = ItemLLItem.Publisher
		    If ciLanguage >= 0 Then Data.Items.CellTextAt(ItemCount, ciLanguage) = ItemLLItem.Language
		    If ciLicense >= 0 Then Data.Items.CellTextAt(ItemCount, ciLicense) = Str(ItemLLItem.License)
		    If ciArch >= 0 Then Data.Items.CellTextAt(ItemCount, ciArch) = Str(ItemLLItem.Arch)
		    If ciOS >= 0 Then Data.Items.CellTextAt(ItemCount, ciOS) = Str(ItemLLItem.OS)
		    If ciRating >= 0 Then Data.Items.CellTextAt(ItemCount, ciRating) = Str(ItemLLItem.Rating)
		    If ciReleaseVersion >= 0 Then Data.Items.CellTextAt(ItemCount, ciReleaseVersion) = ItemLLItem.ReleaseVersion
		    If ciReleaseDate >= 0 Then Data.Items.CellTextAt(ItemCount, ciReleaseDate) = ItemLLItem.ReleaseDate
		    If ciBuilder >= 0 Then Data.Items.CellTextAt(ItemCount, ciBuilder) = ItemLLItem.Builder
		    If ciInstalledSize >= 0 Then Data.Items.CellTextAt(ItemCount, ciInstalledSize) = Str(ItemLLItem.InstallSize)
		    If ciFlags >= 0 Then Data.Items.CellTextAt(ItemCount, ciFlags) = ItemLLItem.Flags
		    If ciHiddenAlways >= 0 Then Data.Items.CellTextAt(ItemCount, ciHiddenAlways) = Str(ItemLLItem.HiddenAlways)
		    If ciShowAlways >= 0 Then Data.Items.CellTextAt(ItemCount, ciShowAlways) = Str(ItemLLItem.ShowAlways)
		    If ciShowSetupOnly >= 0 Then Data.Items.CellTextAt(ItemCount, ciShowSetupOnly) = Str(ItemLLItem.ShowSetupOnly)
		    If ciNoInstall >= 0 Then Data.Items.CellTextAt(ItemCount, ciNoInstall) = Str(ItemLLItem.NoInstall)
		    If ciUniqueName >= 0 Then
		      Dim UN As String = ItemLLItem.TitleName.Lowercase + ItemLLItem.BuildType.Lowercase
		      Data.Items.CellTextAt(ItemCount, ciUniqueName) = UN.ReplaceAll(" ","")
		    End If
		    If ciSelected >= 0 Then Data.Items.CellTextAt(ItemCount, ciSelected) = "F"
		    If ciCompressed >= 0 Then Data.Items.CellTextAt(ItemCount, ciCompressed) = Left(Str(ItemLLItem.Compressed),1)
		    If ciOSCompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciOSCompatible) = ItemLLItem.OSCompatible
		    If ciDECompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciDECompatible) = ItemLLItem.DECompatible
		    If ciPMCompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciPMCompatible) = ItemLLItem.PMCompatible
		    If ciArchCompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciArchCompatible) = ItemLLItem.ArchCompatible
		    If ciLnkMultiple >= 0 Then
		      If LnkCount > 1 And StoreMode = 1 Then
		        Data.Items.CellTextAt(ItemCount, ciLnkMultiple) = "Hide"
		      Else
		        Data.Items.CellTextAt(ItemCount, ciLnkMultiple) = "F"
		      End If
		    End If
		    If ciLnkTitle >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkTitle) = ItemLnk(1).Title
		    If ciLnkComment >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkComment) = ItemLnk(1).Link.Description
		    If ciLnkDescription >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkDescription) = ItemLnk(1).Description
		    If ciLnkCategories >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkCategories) = ItemLnk(1).Categories
		    If ciLnkRunPath >= 0 Then
		      Dim LRP As String = ItemLnk(1).Link.WorkingDirectory
		      If LRP.IndexOf("%") >= 0 Or (TargetWindows And LRP.IndexOf("\\") >= 0) Then LRP = ExpPath(LRP)
		      If LRP = "" Then
		        If ItemLLItem.PathApp.IndexOf("%") >= 0 Or (TargetWindows And ItemLLItem.PathApp.IndexOf("\\") >= 0) Then
		          LRP = ExpPath(ItemLLItem.PathApp)
		        Else
		          LRP = ItemLLItem.PathApp
		        End If
		      End If
		      Data.Items.CellTextAt(ItemCount, ciLnkRunPath) = LRP
		    End If
		    If ciLnkExec >= 0 Then
		      Dim LExec As String = ItemLnk(1).Link.TargetPath
		      If LExec.IndexOf("%") >= 0 Or (TargetWindows And LExec.IndexOf("\\") >= 0) Then LExec = ExpPath(LExec)
		      Data.Items.CellTextAt(ItemCount, ciLnkExec) = LExec
		    End If
		    If ciLnkArguments >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkArguments) = ItemLnk(1).Link.Arguments
		    If ciLnkFlags >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkFlags) = ItemLnk(1).Flags
		    If ciLnkAssociations >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkAssociations) = ItemLnk(1).Associations
		    If ciLnkTerminal >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkTerminal) = Left(Str(ItemLnk(1).Terminal),1)
		    If ciLnkIcon >= 0 Then
		      Dim LIcon As String = ItemLnk(1).Link.IconLocation
		      If LIcon.IndexOf("%") >= 0 Or (TargetWindows And LIcon.IndexOf("\\") >= 0) Then LIcon = ExpPath(LIcon)
		      Data.Items.CellTextAt(ItemCount, ciLnkIcon) = LIcon
		    End If
		    If ciLnkOSCompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkOSCompatible) = ItemLnk(1).LnkOSCompatible
		    If ciLnkDECompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkDECompatible) = ItemLnk(1).LnkDECompatible
		    If ciLnkPMCompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkPMCompatible) = ItemLnk(1).LnkPMCompatible
		    If ciLnkArchCompatible >= 0 Then Data.Items.CellTextAt(ItemCount, ciLnkArchCompatible) = ItemLnk(1).LnkArchCompatible
		    
		  End If
		  
		  'Reference Only Keep
		  '"RefID Selected BuildType Compressed Hidden ShowAlways ShowSetupOnly Installed Arch OS TitleName Version Categories Description URL Priority PathApp PathINI FileINI FileCompressed FileIcon IconRef FileScreenshot FileFader FileMovie Flags Tags Publisher Language Rating Additional Players License ReleaseVersion ReleaseDate RequiredRuntimes Builder InstalledSize
		  'LnkTitle LnkComment LnkDescription LnkCategories LnkRunPath LnkExec LnkArguments LnkFlags LnkAssociations LnkTerminal LnkMultiple LnkParentRef LnkIcon LnkOSCompatible LnkDECompatible LnkPMCompatible LnkArchCompatible NoInstall OSCompatible DECompatible PMCompatible ArchCompatible UniqueName Dependencies "
		  
		  Dim MainItem As Integer = ItemCount
		  
		  'Add Icon to Cache and associate Icon with item (Do Before the Links so can use same icon if none provided
		  If ItemIcon <> Nil Then
		    IconCount = Data.Icons.RowCount
		    Data.Icons.AddRow
		    Data.Icons.RowImageAt(IconCount) = ItemIcon
		    Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("IconRef")) = Str(IconCount)
		  Else 'Icon not found - Use Defaults
		    Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("IconRef")) = Str(0)
		  End If
		  
		  'If Launcher then duplicate Items to Shortcut Link Counts and point to Lnk's
		  If StoreMode = 1 Then 'Get all the links and clone
		    
		    'Dim ParentIcon As New Picture
		    'ParentIcon = ItemIcon
		    
		    If LnkCount >1 Then 'Clone Items
		      For J = 1 To LnkCount
		        ItemCount =  Data.Items.RowCount
		        Data.Items.AddRow(Str(Data.Items.RowCount))
		        Data.Items.CellTextAt(ItemCount,I) = ItemLnk(1).Link.IconLocation
		        For I = 1 To Data.Items.ColumnCount
		          Data.Items.CellTextAt(ItemCount,I) = Data.Items.CellTextAt(MainItem,I)
		          Select Case  Data.Items.HeaderAt(I)
		          Case "LnkMultiple" 'Links
		            If LnkCount >1 And StoreMode = 1 Then 'Only do this for Launcher mode so the SaveAllDB's works
		              Data.Items.CellTextAt(ItemCount,I) = "T"
		              Data.Items.CellTagAt(ItemCount,I) = CurrentScanPath 'Set this to the ScanPath Item so if the paths match it'll only add to that DB
		            Else 
		              Data.Items.CellTextAt(ItemCount,I) = "F" 'LnkMultiple, make them all not true, so can hide all the ones that are in Launcher
		            End If
		          Case "LnkTitle"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Title
		          Case "TitleName"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Title
		          Case "LnkComment"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Link.Description
		          Case "LnkDescription"
		            If ItemLnk(J).Description <> "" Then
		              Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Description
		              'Else ' Don't Add Description to links, It'll fall back to the main description as needed
		              'If ItemLnk(J).Link.Description <> "" Then Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Link.Description
		            End If
		          Case "Description"
		            If ItemLnk(J).Description <> "" Then
		              Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Description
		            Else
		              If ItemLnk(J).Link.Description <> "" Then Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Link.Description
		            End If
		          Case "LnkCategories"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Categories
		          Case "Categories"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Categories
		          Case "LnkRunPath"
		            Data.Items.CellTextAt(ItemCount,I) = ExpPath(ItemLnk(J).Link.WorkingDirectory)
		            If Data.Items.CellTextAt(ItemCount,I) = "" Then Data.Items.CellTextAt(ItemCount,I) = ExpPath(ItemLLItem.PathApp) 'Make sure it has some kind of path, so it has somewhere to be
		          Case "LnkExec"
		            Data.Items.CellTextAt(ItemCount,I) = ExpPath(ItemLnk(J).Link.TargetPath)
		          Case "LnkArguments"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Link.Arguments
		          Case "LnkFlags"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Flags
		          Case "LnkAssociations"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).Associations
		          Case "LnkTerminal"
		            Data.Items.CellTextAt(ItemCount,I) = Left(Str(ItemLnk(J).Terminal),1)
		          Case "LnkIcon"
		            Data.Items.CellTextAt(ItemCount,I) = ExpPath(ItemLnk(J).Link.IconLocation)
		            
		          Case "LnkOSCompatible"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).LnkOSCompatible
		          Case "LnkDECompatible"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).LnkDECompatible
		          Case "LnkPMCompatible"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).LnkPMCompatible
		          Case "LnkArchCompatible"
		            Data.Items.CellTextAt(ItemCount,I) = ItemLnk(J).LnkArchCompatible
		            
		          End Select
		        Next
		        
		        
		        'Get Screenshots, Faders and Icons ***********************
		        MediaPath = Slash(ExpPath(ItemLLItem.PathINI)) 
		        
		        'Set Unique Name to check for alternative screenshots and icons
		        UniqueName = ItemLnk(J).Title.Lowercase + ItemLLItem.BuildType.Lowercase
		        UniqueName= UniqueName.ReplaceAll(" ","")
		        
		        'Load Items Screenshot and Fader per Link
		        'Screenshot
		        Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileScreenshot")) =  MediaPath+UniqueName+".jpg"
		        F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileScreenshot")), FolderItem.PathTypeNative)
		        If Not F.Exists Then
		          Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileScreenshot")) =  MediaPath+ItemLLItem.BuildType+".jpg"
		          F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileScreenshot")), FolderItem.PathTypeNative)
		          If Not F.Exists Then Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileScreenshot")) =  "" 'None
		        End If
		        
		        'Fader
		        Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader"))  =  MediaPath+UniqueName+".png"
		        F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")), FolderItem.PathTypeNative)
		        If Not F.Exists Then
		          Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")) =  MediaPath+UniqueName+".svg"
		          F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")), FolderItem.PathTypeNative)
		          If Not F.Exists Then
		            Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")) =  MediaPath +ItemLLItem.BuildType+".png"
		            F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")), FolderItem.PathTypeNative)
		            If Not F.Exists Then
		              Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")) =  MediaPath+ItemLLItem.BuildType+".svg"
		              F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")), FolderItem.PathTypeNative)
		              If Not F.Exists Then 
		                Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")) =  MediaPath +ItemLLItem.BuildType+".ico"
		                F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")), FolderItem.PathTypeNative)
		                If Not F.Exists Then
		                  Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileFader")) =  "" 'None
		                End If
		              End If
		            End If
		          End If
		        End If
		        NewFileFader = ItemLLItem.FileFader
		        
		        'Icon
		        UniqueIcon = False
		        Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")) =  MediaPath+UniqueName+".svg"
		        F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")), FolderItem.PathTypeNative)
		        If Not F.Exists Then
		          Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")) =  MediaPath+UniqueName+".png"
		          F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")), FolderItem.PathTypeNative)
		          If Not F.Exists Then
		            Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")) =  MediaPath +ItemLLItem.BuildType+".svg"
		            F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")), FolderItem.PathTypeNative)
		            If Not F.Exists Then
		              Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")) =  MediaPath +ItemLLItem.BuildType+".png"
		              F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")), FolderItem.PathTypeNative)
		              If Not F.Exists Then
		                'Disabled .ico because Linux doesn't always display them right, Re-enabled as you can build on Windows
		                Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")) =  MediaPath +ItemLLItem.BuildType+".ico"
		                F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")), FolderItem.PathTypeNative)
		                If Not F.Exists Then 
		                  UniqueIcon = False
		                End If
		              End If
		            End If
		          Else
		            UniqueIcon = True 'png found
		          End If
		        Else
		          UniqueIcon = True 'svg found
		        End If
		        
		        If UniqueIcon = True Then 'Add new Icon
		          IconCount = Data.Icons.RowCount
		          Data.Icons.AddRow
		          FadeFile = Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon"))
		          F = GetFolderItem(FadeFile, FolderItem.PathTypeNative)
		          If F.Exists Then
		            ItemIcon = Picture.Open(F)
		            Data.Icons.RowImageAt(IconCount) = ItemIcon
		            Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("IconRef")) = Str(IconCount)
		          End If
		        End If
		        
		        'Movie
		        Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileMovie")) =  MediaPath+UniqueName+".mp4"
		        F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileMovie")), FolderItem.PathTypeNative)
		        If Not F.Exists Then
		          Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileMovie")) =  MediaPath +ItemLLItem.BuildType+".mp4"
		          F = GetFolderItem(Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileMovie")), FolderItem.PathTypeNative)
		          If Not F.Exists Then
		            Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileMovie")) =  "" 'None
		          End If
		        End If
		        
		      Next
		    End If
		    
		  End If
		  
		  Return MainItem
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetItems(Inn As String)
		  Dim F, G As FolderItem
		  Dim D As Integer
		  Dim DirToCheck As String
		  Dim Exten As String
		  Dim ItemPath As String
		  
		  'Add folders with an item in it and add files that match
		  DirToCheck = Slash(Inn)
		  If TargetWindows Then
		    F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeNative) 'When Getting items, best use correct OS paths
		  Else
		    F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		  End If
		  If F.IsFolder And F.IsReadable Then
		    If F.Count > 0 Then
		      For D = 1 To F.Count
		        ItemPath = Slash(FixPath(F.Item(D).NativePath))
		        If StoreMode = 0 Then
		          If F.Item(D).Directory Then 'Look for folders only
		            G = GetFolderItem(ItemPath + "LLApp.lla", FolderItem.PathTypeNative)
		            If G.Exists Then
		              Data.ScanItems.AddRow(FixPath(G.NativePath))
		            End If
		            G = GetFolderItem(ItemPath + "LLGame.llg", FolderItem.PathTypeNative)
		            If G.Exists Then
		              Data.ScanItems.AddRow(FixPath(G.NativePath))
		            End If
		            G = GetFolderItem(ItemPath+ "ssApp.app", FolderItem.PathTypeNative)
		            If G.Exists Then
		              Data.ScanItems.AddRow(FixPath(G.NativePath))
		            End If
		            G = GetFolderItem(ItemPath + "ppApp.app", FolderItem.PathTypeNative)
		            If G.Exists Then
		              Data.ScanItems.AddRow(FixPath(G.NativePath))
		            End If
		            G = GetFolderItem(ItemPath + "ppGame.ppg", FolderItem.PathTypeNative)
		            If G.Exists Then
		              Data.ScanItems.AddRow(FixPath(G.NativePath))
		            End If
		          Else 'Check if it's a Compressed Item
		            Exten = Right(FixPath(F.Item(D).NativePath),4)
		            If Len(Exten) >=4 Then
		              Exten = Exten.Lowercase
		              Select Case Exten
		              Case ".tar"
		                Data.ScanItems.AddRow(FixPath(F.Item(D).NativePath))
		              Case".apz"
		                Data.ScanItems.AddRow(FixPath(F.Item(D).NativePath))
		              Case".pgz"
		                Data.ScanItems.AddRow(FixPath(F.Item(D).NativePath))
		              End Select
		            End If
		          End If
		        ElseIf StoreMode = 1 Then 'Launcher
		          If F.Item(D).Directory Then 'Look for folders only
		            If TargetWindows Then
		              G = GetFolderItem(Slash(F.Item(D).NativePath.ReplaceAll("/","\")) + "LLGame.llg", FolderItem.PathTypeNative)
		            Else
		              G = GetFolderItem(Slash(F.Item(D).NativePath) + "LLGame.llg", FolderItem.PathTypeNative)
		            End If
		            If G.Exists Then
		              Data.ScanItems.AddRow(FixPath(G.NativePath), ItemPath, DirToCheck) 'Instead of TmpPath use ScanedInPath for Games
		            End If
		            If TargetWindows Then
		              G = GetFolderItem(Slash(FixPath(F.Item(D).NativePath.ReplaceAll("/","\"))) + "ppGame.ppg", FolderItem.PathTypeNative)
		            Else
		              G = GetFolderItem(Slash(FixPath(F.Item(D).NativePath)) + "ppGame.ppg", FolderItem.PathTypeNative)
		            End If
		            If G.Exists Then
		              Data.ScanItems.AddRow(FixPath(G.NativePath), ItemPath, DirToCheck) 'Instead of TmpPath use ScanedInPath for Games
		            End If
		          End If
		        End If
		      Next
		    End If
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetItemsPaths(Inn As String, ScanRoot As Boolean = False)
		  'If Debugging Then Debug("- Starting Get Item Path -")
		  Dim F As FolderItem
		  Dim DirToCheck As String
		  Dim TestLocations As String
		  Dim Sp() As String
		  Dim I As Integer
		  If Inn = "" Then Return
		  Inn = Slash(FixPath(Inn))
		  
		  If ScannedRootFoldersCount >=1 Then 'Make sure this actuall allows root item to show
		    '- Only add Paths not already added, but I only send through the root, need to check if scanned before
		    For I = 1 To ScannedRootFoldersCount 'See if already added and skip it
		      If Inn = ScannedRootFolders(I) Then Return 'Skip existing items
		    Next I
		  End If
		  
		  ScannedRootFoldersCount = ScannedRootFoldersCount + 1
		  ScannedRootFolders(ScannedRootFoldersCount) = Inn
		  
		  If Debugging Then Debug("Scanning For Items In: "+ Inn)
		  
		  #Pragma BreakOnExceptions False
		  Try
		    If ScanRoot = True Then
		      CheckPath(Slash(Inn))
		    End If
		    
		    'Look in paths for correct folders
		    CheckPath(Slash(Inn + "LLAppsInstalls"))
		    CheckPath(Slash(Inn + "LLGamesInstalls"))
		    CheckPath(Slash(Inn +"ssAppsInstalls"))
		    CheckPath(Slash(Inn + "ppAppsInstalls"))
		    CheckPath(Slash(Inn + "ppAppsLive"))
		    CheckPath(Slash(Inn + "ppGamesInstalls"))
		    
		    If StoreMode = 1 Then ' Get Games path if set to Launcher
		      CheckPath(Slash(Inn) + Slash("ppGames"))
		      CheckPath(Slash(Inn) + Slash("LLGames"))
		    End If
		    
		    'Get Manual Locations If %ExtraPath%
		    If Settings.SetUseManualLocations.Value = True And TargetLinux Then 'Only use them if set to use them
		      If Debugging Then Debug("--- Get %ExtraPath% Manual Locations: ---")
		      TestLocations = Settings.SetManualLocations.Text
		      TestLocations = TestLocations.ReplaceAll(Chr(10), Chr(13))
		      Sp() = TestLocations.Split(Chr(13))
		      If Sp.Count >= 1 Then
		        For I = 0 To Sp.Count - 1
		          DirToCheck = Sp(I).Trim
		          If DirToCheck.IndexOf("%ExtraPath%") >=0 Then
		            DirToCheck = DirToCheck.Replace("%ExtraPath%", NoSlash(Inn))
		            CheckPath(DirToCheck) 'This is a checker
		          End If
		        Next
		      End If
		    End If
		    
		    
		  Catch
		  End Try
		  #Pragma BreakOnExceptions True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetOnlineDBs()
		  ForceQuit = False 'To allow quitting while loading, this is set, it breaks the downloader though as it aborts if your quitting, to make it cleaner.
		  Dim I As Integer
		  Dim Sp() As String
		  Dim UniqueName As String
		  
		  If OnlineDBs.Trim = "" Then OnlineDBs = Settings.SetOnlineRepos.Text.ReplaceAll(Chr(10), Chr(13)) ' Convert to standard format so it works in Windows and Linux
		  
		  Sp() = OnlineDBs.Split(Chr(13)) 'Text Areas use Chr (13) In Windows
		  
		  'Clean Up
		  Deltree(Slash(RepositoryPathLocal)+"FailedDownload")
		  
		  If Sp.Count >= 1 Then
		    
		    ' --- Pass 1: Gather all valid repo URLs and local paths into arrays ---
		    Dim DBURLs(1024) As String
		    Dim DBLocals(1024) As String
		    Dim DBUniqueNames(1024) As String
		    Dim DBCount As Integer = 0
		    
		    For I = 0 To Sp.Count-1
		      If Left(Sp(I).Trim, 1) = "#" Then Continue 'Skip remarked Repo's
		      If Sp(I).Trim = "" Then Continue 'Skip blank lines
		      
		      UniqueName = Sp(I).ReplaceAll("lldb.ini","")
		      UniqueName = UniqueName.ReplaceAll(".lldb","")
		      UniqueName = UniqueName.ReplaceAll("https://","")
		      UniqueName = UniqueName.ReplaceAll("http://","")
		      UniqueName = UniqueName.ReplaceAll("/","")
		      UniqueName = UniqueName.ReplaceAll(".","")
		      UniqueName = "00-"+UniqueName+".lldbini"
		      
		      If ForceNoOnlineDBUpdates = False Then
		        If Exist(Slash(RepositoryPathLocal)+UniqueName) Then Deltree(Slash(RepositoryPathLocal)+UniqueName) 'Remove Cached download
		      End If
		      
		      CurrentDBURL = Sp(I).ReplaceAll(".lldb/lldb.ini", "") 'Only want the parent, not the sub path and file
		      DBURLs(DBCount)        = Sp(I)
		      DBLocals(DBCount)      = Slash(RepositoryPathLocal)+UniqueName
		      DBUniqueNames(DBCount) = UniqueName
		      DBCount = DBCount + 1
		    Next
		    
		    ' --- Pass 2: Download (parallel if curl supports it, sequential fallback) ---
		    If ForceNoOnlineDBUpdates = False And DBCount > 0 Then
		      
		      Dim UseParallel As Boolean = False
		      
		      If DBCount > 1 Then 'No point parallelising a single file
		        ' Check curl version supports --parallel (needs 7.66.0+, released Sep 2019)
		        ' Use the resolved curl path (WinCurl/LinuxCurl) set at startup - not bare "curl"
		        ' which won't be in PATH on Windows unless it's the Win10 system one.
		        Dim CurlBin As String = LinuxCurl
		        If TargetWindows Then CurlBin = WinCurl
		        Dim cvSh As New Shell
		        cvSh.TimeOut = -1
		        cvSh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		        cvSh.Execute(CurlBin + " --version 2>&1")
		        Dim cvBuf As String = ""
		        While cvSh.IsRunning
		          App.DoEvents(10)
		          cvBuf = cvBuf + cvSh.ReadAll
		        Wend
		        cvBuf = cvBuf + cvSh.ReadAll.Trim
		        Dim cvParts() As String = cvBuf.Split(" ")
		        If cvParts.Count >= 2 Then
		          Dim vp() As String = cvParts(1).Split(".")
		          If vp.Count >= 2 Then
		            If Val(vp(0)) > 7 Or (Val(vp(0)) = 7 And Val(vp(1)) >= 66) Then UseParallel = True
		          End If
		        End If
		      End If
		      
		      If UseParallel Then
		        ' === PARALLEL: fire all DB downloads simultaneously in one curl command ===
		        Dim DoneFlag As String = Slash(RepositoryPathLocal)+"AllDBsDone"
		        Deltree(DoneFlag)
		        
		        Dim ParallelShell As New Shell
		        ParallelShell.TimeOut = -1
		        ParallelShell.ExecuteMode = Shell.ExecuteModes.Asynchronous
		        
		        StartParallelDownload(DBURLs, DBLocals, DBCount, DoneFlag, ParallelShell)
		        
		        Dim ParallelTimeout As Double = System.Microseconds + (30 * 1000000) '30s total for all DBs together
		        If CheckingForDatabases Then UpdateLoading("Databases: Downloading (parallel)...") 'Set once - not inside the loop to avoid flicker
		        Dim ParBuf As String = ""
		        While ParallelShell.IsRunning
		          App.DoEvents(20)
		          ParBuf = ParBuf + ParallelShell.ReadAll 'Drain pipe to prevent buffer deadlock
		          If System.Microseconds >= ParallelTimeout Then
		            ParallelShell.Close
		            Exit While
		          End If
		          If ForceQuit Or CancelDownloading Then
		            ParallelShell.Close
		            CancelDownloading = False
		            Exit While
		          End If
		        Wend
		        ParBuf = ParBuf + ParallelShell.ReadAll 'Final drain
		        
		        ' Rename all .partial -> final
		        Dim renameSh As New Shell
		        For I = 0 To DBCount - 1
		          If Exist(DBLocals(I)+".partial") Then
		            If Exist(DBLocals(I)) Then Deltree(DBLocals(I))
		            If TargetWindows Then
		              renameSh.Execute("move /y "+Chr(34)+DBLocals(I).ReplaceAll("/","\")+ ".partial"+Chr(34)+" "+Chr(34)+DBLocals(I).ReplaceAll("/","\")+Chr(34))
		            Else
		              renameSh.Execute("mv "+Chr(34)+DBLocals(I)+".partial"+Chr(34)+" "+Chr(34)+DBLocals(I)+Chr(34))
		            End If
		            While renameSh.IsRunning
		              App.DoEvents(5)
		            Wend
		          End If
		        Next
		        Deltree(DoneFlag)
		        
		      Else
		        ' === SEQUENTIAL FALLBACK: original one-at-a-time logic, untouched ===
		        For I = 0 To DBCount - 1
		          GetOnlineFile(DBURLs(I), DBLocals(I))
		          TimeOut = System.Microseconds + (15 *1000000) 'Set Timeout after 15 seconds
		          CancelDownloading = False
		          While Downloading
		            App.DoEvents(20)
		            If System.Microseconds >= TimeOut Then
		              CancelDownloading = True
		              Exit While 'Timeout after 15 seconds, incase net is slow, I give extra seconds to skip each of them
		            End If
		            If Exist(Slash(RepositoryPathLocal)+"FailedDownload") Then
		              Deltree(Slash(RepositoryPathLocal)+"FailedDownload")
		              Exit While
		            End If
		          Wend
		        Next
		      End If
		      
		    End If
		    
		    ' --- Pass 3: Load all DBs (runs regardless of download path or offline mode) ---
		    For I = 0 To DBCount - 1
		      CurrentDBURL = DBURLs(I).ReplaceAll(".lldb/lldb.ini", "") 'Always set before LoadDB - required for %URLPath% substitution to point to correct repo
		      LoadDB(Slash(RepositoryPathLocal)+DBUniqueNames(I), True) 'The true allows full DB path to be given, so can use Unique DB names
		    Next
		    
		  End If
		  
		  If ForceNoOnlineDBUpdates = True Then ForceNoOnlineDBUpdates = False ' Only block it the first run, not for refresh
		  
		  ''Get Remote WebLinks to use 'Disabled for now due to Google stopping API use with wget
		  GetOnlineFile ("https://raw.githubusercontent.com/LiveFreeDead/LLStore_v2/refs/heads/main/WebLinks.ini",Slash(RepositoryPathLocal)+"RemoteWebLinks.db")
		  TimeOut = System.Microseconds + (5 *1000000) 'Set Timeout after 5 seconds
		  While Downloading = True
		    App.DoEvents(20)
		    If System.Microseconds >= TimeOut Then Exit 'Timeout after 5 seconds
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetScanPaths()
		  App.DoEvents(1) 'This makes the Load Screen Update the Status Text, Needs to be in each Function and Sub call
		  
		  If Debugging Then Debug("--- Starting Scan Paths for Items ---")
		  
		  Dim IniFile As String
		  Dim ManIn As String
		  Dim Sp() As String
		  
		  'For Win
		  Dim Let As Integer
		  Dim I As Integer
		  Dim Item As FolderItem
		  Dim CheckDir As String
		  
		  Dim F, G As FolderItem
		  Dim DirToCheck As String
		  Dim D, E As Integer
		  Dim TestLocations As String
		  
		  ScannedRootFoldersCount = 0
		  
		  Data.ScanPaths.RemoveAllRows
		  
		  'Check the locations for items and Add them to the Data Form
		  If StoreMode = 0 Then 'Get Installable items
		    DirToCheck = NoSlash(AppPath)
		    
		    DirToCheck = Left(DirToCheck, InStrRev(DirToCheck, "/",-1)) ' Checks up one level from the LastOSLinux Store    
		    
		    If Settings.SetScanLocalItems.Value = True Then
		      If TargetWindows Then
		        F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeNative)
		      Else
		        F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		      End If
		      If F.IsFolder And F.IsReadable Then
		        GetItemsPaths(DirToCheck)
		        GetItemsPaths(Slash(DirToCheck) +"ssTek")
		        GetItemsPaths(Slash(DirToCheck) +"LLTek")
		      End If
		    End If
		    
		    If TargetLinux Then
		      If Settings.SetScanLocalItems.Value = True Then
		        DirToCheck = "/media/"
		        F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		        If F.IsFolder And F.IsReadable Then
		          If F.Count > 0 Then
		            For D = 1 To F.Count
		              If F.Item(D).Directory Then 'Look for folders only
		                G = F.Item(D)
		                If G.IsReadable Then
		                  If G.Count > 0 Then
		                    For E = 1 To G.Count
		                      If G.Item(E).Directory Then 'Look for sub folders only
		                        GetItemsPaths(FixPath(G.Item(E).NativePath))
		                        GetItemsPaths(Slash(FixPath(G.Item(E).NativePath) +"ssTek"))
		                        GetItemsPaths(Slash(FixPath(G.Item(E).NativePath) +"LLTek"))
		                      End If
		                    Next
		                  End If
		                End If
		              End If
		            Next
		          End If
		        End If
		      End If
		      
		      If Settings.SetScanLocalItems.Value = True Then
		        DirToCheck = "/run/media/"
		        F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		        If F.IsFolder And F.IsReadable Then
		          If F.Count > 0 Then
		            For D = 1 To F.Count
		              If F.Item(D).Directory Then 'Look for folders only
		                G = F.Item(D)
		                If G.IsReadable Then
		                  If G.Count > 0 Then
		                    For E = 1 To G.Count
		                      If G.Item(E).Directory Then 'Look for sub folders only
		                        GetItemsPaths(FixPath(G.Item(E).NativePath))
		                        GetItemsPaths(Slash(FixPath(G.Item(E).NativePath) +"ssTek"))
		                        GetItemsPaths(Slash(FixPath(G.Item(E).NativePath) +"LLTek"))
		                      End If
		                    Next
		                  End If
		                End If
		              End If
		            Next
		          End If
		        End If
		      End If
		      
		      If Settings.SetScanLocalItems.Value = True Then
		        DirToCheck = "/mnt/"
		        F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		        If F.IsFolder And F.IsReadable Then
		          If F.Count > 0 Then
		            For D = 1 To F.Count
		              If F.Item(D).Directory Then 'Look for folders only
		                GetItemsPaths(FixPath(F.Item(D).NativePath))
		                GetItemsPaths(Slash(FixPath(F.Item(D).NativePath) +"ssTek"))
		                GetItemsPaths(Slash(FixPath(F.Item(D).NativePath) +"LLTek"))
		              End If
		            Next
		          End If
		        End If
		      End If
		      
		    ElseIf TargetWindows Then 'Get Items in Windows, check C to Z drives
		      If Settings.SetScanLocalItems.Value = True Then
		        Let = Asc("C")
		        For I = 0 To 23
		          Let = Asc("C") + I
		          DirToCheck = Chr(Let)+":/" 'Linux Path
		          F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeNative) 'This fixes the issue, yes whenever windows does folder stuff, convert it back until it returns, or it will add a backslash after the forward slash
		          
		          If F.IsFolder And F.IsReadable Then
		            If F.Count > 0 Then
		              For D = 1 To F.Count
		                item = F.trueItem(D) 'This is the issue, it returns "D:/\Path/" instead when using "D:/" in path
		                
		                If Right(FixPath(Item.NativePath),4) <> ".lnk" Then 'Do NOT use .lnk to folders, if missing it will throw an error, plus why would you?
		                  
		                  If F.Item(D).Directory Then 'Look for folders only
		                    CheckDir = FixPath(NoSlash(F.Item(D).NativePath))
		                    CheckDir = Right(CheckDir,Len(CheckDir)-InStrRev(CheckDir,"/")) ' Always Backslash in Windows but you can use Forward slash too
		                    
		                    'Ignores all other folders (to speed up loading and keep to proper paths) ' May need to make a new one for Manual Added Paths to check the root folders
		                    If CheckDir = "LLAppsInstalls" Or CheckDir = "ssAppsInstalls" Or CheckDir = "ppAppsInstalls" Or CheckDir = "LLGamesInstalls" Or CheckDir = "ppGamesInstalls" Or CheckDir = "ppAppsLive" Or CheckDir = "ssTek" Or CheckDir = "LLTek" Then
		                      GetItemsPaths(FixPath(F.Item(D).NativePath), True) 'True to Do Root folder as it'll only have proper items in at this stage
		                    End If
		                  End If
		                End If
		              Next
		            End If
		          End If
		        Next
		      End If
		    End If
		    
		    
		    'Check the Repo Cache if Enabled to do so
		    If Settings.SetIgnoreCache.Value = True Or Exist(Slash(AppPath)+"RepoBuilderNoCache") Then 'So if you have it set to ignore the cache or the file exists it does nothing (wont scan for it)
		    Else
		      If Settings.SetScanLocalItems.Value = True Then
		        DirToCheck = RepositoryPathLocal
		        If TargetWindows Then
		          F = GetFolderItem(DirToCheck.ReplaceAll("/","\"), FolderItem.PathTypeNative)
		        Else
		          F = GetFolderItem(DirToCheck, FolderItem.PathTypeNative)
		        End If
		        If F.IsFolder And F.IsReadable Then
		          GetItemsPaths(DirToCheck, True)
		        End If
		      End If
		    End If
		    
		    'Get LLStoreParent
		    If LLStoreParent <> "" Then GetItemsPaths(LLStoreParent, True) 'Get root folder locations if they exist - Glenn 26
		    
		    'Get Manual Locations
		    If Settings.SetUseManualLocations.Value = True Then 'Only use them if set to use them
		      If Debugging Then Debug("--- Get Manual Locations: ---")
		      TestLocations = Settings.SetManualLocations.Text
		      TestLocations = TestLocations.ReplaceAll(Chr(10), Chr(13))
		      Sp() = TestLocations.Split(Chr(13))
		      'If Debugging Then Debug("ManualLocs")
		      If Sp.Count >= 1 Then
		        For I = 0 To Sp.Count - 1
		          DirToCheck = Sp(I).Trim
		          If TargetWindows Then DirToCheck = DirToCheck.ReplaceAll("%USBDrive%", Left(AppPath,2)) 'Convert Current USB drive to variable so when you load it back in it points to right location
		          GetItemsPaths(DirToCheck, True)
		        Next
		      End If
		    End If
		    
		    
		  ElseIf StoreMode = 1 Then 'Launcher Mode
		    If TargetLinux Then
		      GetItemsPaths(Slash(HomePath)+"LLGames/", True)
		      GetItemsPaths(Slash(HomePath)+".wine/drive_c/ppGames/", True)
		      If LLStoreParent <> "" Then GetItemsPaths(LLStoreParent, True) 'Get root folder locations if they exist - Glenn 26
		      
		      'Make it check the root folder to LLStore, so can carry on USB stick with installed items to play - This may cause issues, needs Testing Glenn
		      Dim GamePath As String
		      GamePath = AppPath
		      GamePath = Slash(Left(GamePath, Len(GamePath)-InStrRev(GamePath,"/")))
		      If GamePath <> "/LastOS/" And GamePath <> "/" Then
		        GetItemsPaths(Slash(GamePath)+"LLGames/", True)
		      End If
		      GamePath = Slash(Left(GamePath, Len(GamePath)-InStrRev(GamePath,"/"))) ' I check up to folders
		      If GamePath <> "/LastOS/" And GamePath <> "/" Then
		        GetItemsPaths(Slash(GamePath)+"LLGames/", True)
		      End If
		      
		    ElseIf TargetWindows Then 'Only get Windows Games on Windows, can't run Linux games
		      Let = Asc("C")
		      For I = 0 To 23
		        Let = Asc("C") + I
		        GetItemsPaths(Chr(Let)+":/ppGames/", True)
		      Next I
		    End If
		    
		    
		    'Get Manual Locations for Windows
		    If Settings.SetUseManualLocations.Value = True Then 'Only use them if set to use them
		      If TargetWindows Then
		        IniFile = Slash(AppPath)+"LLL_Launcher_Win_Manual_Locations.ini"
		      Else
		        IniFile = Slash(AppPath)+"LLL_Launcher_Linux_Manual_Locations.ini"
		      End If
		      If Exist(IniFile) Then
		        ManIn = LoadDataFromFile(IniFile)
		        Sp() = ManIn.Split(Chr(10))
		        If Sp.Count >=1 Then
		          For I = 0 To Sp.Count -1
		            DirToCheck = Sp(I).Trim
		            GetItemsPaths(DirToCheck, True)
		          Next
		        End If
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetTheme()
		  Dim F As FolderItem
		  Dim RL As String
		  
		  #Pragma BreakOnExceptions Off
		  Try
		    If StoreMode = 0 Then
		      ThemePath = AppPath+"Themes/Theme.ini"
		      F = GetFolderItem(ThemePath,FolderItem.PathTypeNative)
		      InputStream = TextInputStream.Open(F)
		      RL = InputStream.ReadLine.Trim
		      inputStream.Close
		      ThemePath = AppPath+"Themes/"+RL+"/"
		      LoadTheme (RL)
		    ElseIf StoreMode = 1 Then
		      ThemePath = AppPath+"Themes/ThemeLauncher.ini"
		      F = GetFolderItem(ThemePath,FolderItem.PathTypeNative)
		      InputStream = TextInputStream.Open(F)
		      RL = InputStream.ReadLine.Trim
		      inputStream.Close
		      ThemePath = AppPath+"Themes/"+RL+"/"
		      LoadTheme (RL)
		    End If
		  Catch
		    'No Theme files found
		    If Debugging Then Debug("* Error: Theme Not Found: "+ThemePath)
		    
		    If StoreMode = 0 Then RL = "LastLinux"
		    If StoreMode = 1 Then RL = "LastLinuxLauncher"
		    ThemePath = AppPath+"Themes/"+RL+"/"
		    LoadTheme (RL)
		    
		  End Try
		  #Pragma BreakOnExceptions On
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetWebLinks()
		  Dim I As Integer
		  Dim RL As String
		  Dim Sp() As String
		  Dim TemStrSp() As String
		  Dim FileIn As String
		  
		  FileIn = Slash(RepositoryPathLocal)+"RemoteWebLinks.db"
		  If TargetWindows Then
		    FileIn = FileIn.ReplaceAll("/","\")
		  Else
		    FileIn = FileIn.ReplaceAll("\","/")
		  End If
		  
		  RL = LoadDataFromFile(FileIn)
		  RL = RL.ReplaceAll(Chr(13),Chr(10))
		  
		  Sp = RL.Split(Chr(10))
		  If Sp.Count >= 1 Then
		    WebLinksCount = 0
		    For I = 0 To Sp.Count - 1
		      TemStrSp = Sp(I).Split("|")
		      If TemStrSp.Count = 2 Then
		        WebLinksName(WebLinksCount) = TemStrSp(0).Trim
		        WebLinksLink(WebLinksCount) = TemStrSp(1).Trim            
		        'MsgBox WebLinksName(WebLinksCount) + " = " + WebLinksLink(WebLinksCount)
		        WebLinksCount = WebLinksCount + 1
		        If WebLinksCount >= 4096 Then
		          Debug("WebLinks array is full")
		          WebLinksCount = 4095 'Limit it
		        End If
		      End If
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideOldVersions()
		  If Debugging Then Debug("- Starting Hide Old Versions -")
		  App.DoEvents(1) 'This makes the Load Screen Update the Status Text, Needs to be in each Function and Sub call
		  
		  Dim I, J As Integer
		  Dim ItemToAdd(16000) As String
		  Dim BuildType(16000) As String
		  Dim ItemHidden(16000) As Boolean
		  Dim V(16000) As String
		  Dim IsLocalFile(16000) As Boolean 'True if the item's source file exists locally (scanned-in items), False for download-only DB entries
		  Dim ColsHidden, ColsBuildType, ColsTitleName, ColsVersion, ColsFileINI As Integer
		  
		  ColsHidden    = Data.GetDBHeader("Hidden")
		  ColsBuildType = Data.GetDBHeader("BuildType")
		  ColsTitleName = Data.GetDBHeader("TitleName")
		  ColsVersion   = Data.GetDBHeader("Version")
		  ColsFileINI   = Data.GetDBHeader("FileINI")
		  
		  'Pre-load all data and check whether each item's source file is present locally.
		  'This lets us prefer a scanned-in local item over a remote/download-only DB entry
		  'when both have the same title, build type, and version.
		  For I = 0 To Data.Items.RowCount - 1
		    If Data.Items.CellTextAt(I, ColsHidden) = "T" Then ItemHidden(I) = True
		    BuildType(I) = Data.Items.CellTextAt(I, ColsBuildType)
		    ItemToAdd(I) = Data.Items.CellTextAt(I, ColsTitleName)
		    V(I) = Data.Items.CellTextAt(I, ColsVersion)
		    
		    'Check if source file exists locally (distinguishes scanned items from download-only DB entries)
		    If ColsFileINI >= 0 Then
		      Dim FI As String = Data.Items.CellTextAt(I, ColsFileINI)
		      If FI <> "" And Left(FI, 4).Lowercase <> "http" Then
		        IsLocalFile(I) = Exist(FI)
		      End If
		    End If
		    
		    'Clean version string for component-wise comparison.
		    'We keep dots as separators (e.g. "1.10.2" stays as-is so each part
		    'can be compared numerically, fixing "1.10" > "1.9" which the old
		    'strip-all-dots approach got wrong).
		    If V(I) <> "" Then
		      If Left(V(I), 1).Lowercase = "v" Then V(I) = Right(V(I), V(I).Length - 1)
		      V(I) = V(I).ReplaceAll("R", ".") 'Convert R-notation (e.g. 1R2) to dot separator
		      V(I) = V(I).ReplaceAll(" ", "")
		      V(I) = V(I).ReplaceAll("-", "")
		      V(I) = V(I).ReplaceAll("_", "")
		      V(I) = V(I).ReplaceAll("beta", "")
		      While V(I).InStr("..") > 0 'Collapse any double dots left by the replacements above
		        V(I) = V(I).ReplaceAll("..", ".")
		      Wend
		      If Left(V(I), 1) = "." Then V(I) = Right(V(I), V(I).Length - 1)
		      If Right(V(I), 1) = "." Then V(I) = Left(V(I), V(I).Length - 1)
		    End If
		  Next
		  
		  '--- O(n) Dictionary grouping replaces the O(n²) nested loop ---
		  'Group item indices by (titlename+buildtype) key, then elect one winner per group.
		  Dim GroupDict As New Dictionary  'key → pipe-delimited index list
		  Dim N As Integer = Data.Items.RowCount
		  
		  For I = 0 To N - 1
		    If ItemHidden(I) Then Continue
		    Dim GKey As String = ItemToAdd(I) + "|" + BuildType(I)  'Exact match, same as original = comparison
		    If GroupDict.HasKey(GKey) Then
		      GroupDict.Value(GKey) = CStr(GroupDict.Value(GKey)) + "|" + CStr(I)
		    Else
		      GroupDict.Value(GKey) = CStr(I)
		    End If
		  Next I
		  
		  Dim GKeys() As Variant = GroupDict.Keys
		  For Each GK As Variant In GKeys
		    Dim Members() As String = CStr(GroupDict.Value(GK)).Split("|")
		    If Members.Count <= 1 Then Continue  'Only one item in group — nothing to hide
		    
		    'Elect winner: highest version; prefer local file on version tie.
		    Dim WinIdx As Integer = Val(Members(0))
		    For J = 1 To Members.Count - 1
		      Dim Cand As Integer = Val(Members(J))
		      Dim VCmp As Integer = CompareVersionStrings(V(WinIdx), V(Cand))
		      If VCmp < 0 Then
		        WinIdx = Cand  'Candidate is newer
		      ElseIf VCmp = 0 Then
		        If IsLocalFile(Cand) And Not IsLocalFile(WinIdx) Then
		          WinIdx = Cand  'Same version, prefer locally-scanned file
		        End If
		      End If
		    Next J
		    
		    'Hide all non-winners.
		    For J = 0 To Members.Count - 1
		      Dim Idx As Integer = Val(Members(J))
		      If Idx <> WinIdx Then
		        ItemHidden(Idx) = True
		        Data.Items.CellTextAt(Idx, ColsHidden) = "T"
		      End If
		    Next J
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadDB(DBRootIn As String, FullPathGiven As Boolean = False)
		  Dim F As FolderItem
		  If FullPathGiven = True Then
		    F = GetFolderItem(DBRootIn, FolderItem.PathTypeNative)
		    DBRootIn = Left(DBRootIn,DBRootIn.IndexOf("00-")) 'Drop back to the Folder
		  Else
		    F = GetFolderItem(DBRootIn+".lldb/lldb.ini",FolderItem.PathTypeNative)
		  End If
		  
		  If Not F.Exists Then
		    If Debugging Then Debug("Atempted to load Database From: "+ F.NativePath)
		    Return 'Dud file, get out of here
		  End If
		  
		  If Debugging Then Debug("Loading Database From: "+ F.NativePath)
		  
		  Dim I, J, K As Integer
		  Dim RL As String
		  Dim Sp() As String
		  Dim HeadSp() As String
		  Dim ItemSp() As String
		  Dim DataHeadID As Integer
		  
		  Dim FlagsIn As String
		  Dim FadeFile As String
		  #Pragma BreakOnExceptions Off
		  Try
		    'Load in whole file at once (Fastest Method)
		    inputStream = TextInputStream.Open(F)
		    
		    While Not inputStream.EndOfFile 'If Empty file this skips it
		      RL = inputStream.ReadAll 
		    Wend
		    inputStream.Close
		  Catch
		    Return 'The DB Load failed, Return to calling Sub and try the next one instead
		  End Try
		  
		  #Pragma BreakOnExceptions On
		  
		  If FullPathGiven = True Then 'Only Online DB's use this
		    RL = RL .ReplaceAll("%URLPath%", NoSlash(CurrentDBURL)) 'This is to point to the Online DB rather than the local cache, I'll have to convert them to RepositoryLocalDB 'Do All at once, must be faster than doing one at a time
		    RL = RL .ReplaceAll("%DBPath%", NoSlash(DBRootIn)) 'Do All at once, must be faster than doing one at a time
		  Else
		    RL = RL .ReplaceAll("%URLPath%", NoSlash(DBRootIn))
		    RL = RL .ReplaceAll("%DBPath%", NoSlash(DBRootIn)) 'Do All at once, must be faster than doing one at a time
		  End If
		  Sp()=RL.Split(Chr(10))
		  
		  If Sp.Count >= 1 Then
		    HeadSp= Sp(0).Split("|")
		    
		    If HeadSp.Count >= 1 Then
		      ' Pre-build a column-index map from HeadSp positions to Data.Items column indices.
		      ' This replaces the O(columns) linear-scan K loop that previously ran for every
		      ' field of every row — now it is done ONCE and looked up as O(1) array access.
		      Dim ColMap() As Integer
		      ReDim ColMap(HeadSp.Count - 1)
		      Dim MapJ As Integer
		      For MapJ = 0 To HeadSp.Count - 1
		        ColMap(MapJ) = Data.GetDBHeader(HeadSp(MapJ))
		      Next
		      
		      ' Cache Categories/Catalog columns for the per-row fallback check below
		      Dim CatColDB     As Integer = Data.GetDBHeader("Categories")
		      Dim CatalogColDB As Integer = Data.GetDBHeader("Catalog")
		      
		      For I = 1 To Sp.Count - 1 'Items in DB
		        ItemSP = Sp(I).Split(",|,")
		        If ItemSp.Count >= 1 Then
		          For J = 0 To HeadSp.Count - 1
		            
		            DataHeadID = ColMap(J) ' O(1) array lookup — replaces O(columns) linear scan
		            
		            Select Case HeadSp(J)
		            Case "RefID"
		              ItemCount =  Data.Items.RowCount
		              Data.Items.AddRow(Data.Items.RowCount.ToString("000000")) 'This adds the Leading 0's or prefixes it to 6 digits as it sort Alphabettical, fixed 1,10,100,2 to 001,002,010,100 for example
		            Case "IconRef" 'As the icon file is listed before this we can add it here
		              If Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon")) <> "" Then 'If it has a file listed then it should exist
		                IconCount = Data.Icons.RowCount
		                Data.Icons.AddRow
		                FadeFile = Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("FileIcon"))
		                F = GetFolderItem(FadeFile, FolderItem.PathTypeNative)
		                If F.Exists Then
		                  ItemIcon = Picture.Open(F)
		                  Data.Icons.RowImageAt(IconCount) = ItemIcon
		                  Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("IconRef")) = Str(IconCount)
		                Else
		                  Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("IconRef")) = Str(0) 'Can't find file
		                End If
		              Else 'Icon not found - Use Defaults
		                Data.Items.CellTextAt(ItemCount,Data.GetDBHeader("IconRef")) = Str(0)
		              End If
		            Case "PathApp" ' Convert these back ASAP, Less issues if it's already converted and it gets converted back when saving to DB's
		              If DataHeadID >= 1 Then
		                #Pragma BreakOnExceptions False
		                Try
		                  If J <  ItemSP.Count Then
		                    Data.Items.CellTextAt(ItemCount,DataHeadID) = ExpPath(ItemSP(J))
		                  Else
		                    'Data.Items.CellTextAt(ItemCount,DataHeadID) = ExpPath(ItemSP(ItemSP.Count))
		                  End If
		                Catch
		                End Try
		                #Pragma BreakOnExceptions True
		              End If
		            Case "PathINI"
		              If DataHeadID >= 1 Then
		                #Pragma BreakOnExceptions False
		                Try
		                  If J < ItemSP.Count Then
		                    Data.Items.CellTextAt(ItemCount,DataHeadID) = ExpPath(ItemSP(J))
		                  End If
		                Catch
		                End Try
		                #Pragma BreakOnExceptions True
		              End If
		            Case "FileINI"
		              If DataHeadID >= 1 Then
		                #Pragma BreakOnExceptions False
		                Try
		                  If J < ItemSP.Count Then
		                    Data.Items.CellTextAt(ItemCount,DataHeadID) = ExpPath(ItemSP(J))
		                  End If
		                Catch
		                End Try
		                #Pragma BreakOnExceptions True
		              End If
		              
		            Case Else
		              If DataHeadID >= 1 Then 'Glenn 2027
		                #Pragma BreakOnExceptions Off
		                Try
		                  If J < ItemSP.Count Then 'This is the main fix for if the DB gets corrupted
		                    Data.Items.CellTextAt(ItemCount,DataHeadID) = ItemSP(J)
		                  End If
		                Catch
		                End Try
		                #Pragma BreakOnExceptions On
		              End If
		            End Select
		            
		          Next J ' End column loop
		          
		          ' Categories fallback — moved OUTSIDE the column loop so it runs once per row
		          ' instead of once per column×row (was calling GetDBHeader 3-4× per column before)
		          #Pragma BreakOnExceptions Off
		          Try
		            If CatColDB >= 0 And CatalogColDB >= 0 Then
		              If Data.Items.CellTextAt(ItemCount, CatColDB) = "" Then
		                If Data.Items.CellTextAt(ItemCount, CatalogColDB) <> "" Then
		                  Data.Items.CellTextAt(ItemCount, CatColDB) = Data.Items.CellTextAt(ItemCount, CatalogColDB)
		                End If
		              End If
		            End If
		          Catch
		          End Try
		          #Pragma BreakOnExceptions On
		          
		        End If
		      Next I
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadFavorites()
		  Dim I As Integer
		  'Load in Favorites if exists
		  FavCount = 0
		  Dim InFavs As String
		  Dim InFavSp() As String
		  If StoreMode = 1 Then
		    If Exist(Slash(AppPath)+"Favorites.ini") Then
		      InFavs = LoadDataFromFile(Slash(AppPath)+"Favorites.ini")
		      InFavs = InFavs.ReplaceAll (Chr(13), Chr(10))
		      InFavSp() = InFavs.Split(Chr(10))
		      If InFavSp.Count >= 1 Then
		        For I = 0 To InFavSp.Count - 1
		          If InFavSp(I).Trim <> "" Then
		            Favorites(FavCount) = InFavSp(I).Trim
		            FavCount = FavCount + 1
		          End If
		        Next
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadPosition()
		  Dim FileIn As String
		  Dim DataIn As String
		  Dim DataSp() As String
		  Dim I As Integer
		  
		  FileIn = ""
		  If StoreMode = 0 Then 
		    FileIn = Slash(SpecialFolder.ApplicationData.NativePath)+".LLStore.ini"
		  ElseIf StoreMode = 1 Then
		    FileIn = Slash(SpecialFolder.ApplicationData.NativePath)+".LLLauncher.ini"
		  End If
		  
		  If FileIn <> "" Then
		    If Exist(FileIn) Then
		      If Debugging Then Debug ("- Load Windows Position From File: " + FileIn)
		      
		      DataIn = LoadDataFromFile(FileIn)
		      If DataIn.Trim <> "" Then
		        DataSp = DataIn.Split(Chr(10))
		        For I = 0 To DataSp.Count - 1
		          If DataSp(I).IndexOf("MainLeft=") >=0 Then
		            LoadedPosition = True
		            Main.Left = DataSp(I).ReplaceAll("MainLeft=", "").Trim.ToInteger
		          End If
		          If DataSp(I).IndexOf("MainTop=") >=0 Then
		            Main.Top = DataSp(I).ReplaceAll("MainTop=", "").Trim.ToInteger
		          End If
		          If DataSp(I).IndexOf("MainWidth=") >=0 Then
		            Main.Width = DataSp(I).ReplaceAll("MainWidth=", "").Trim.ToInteger
		          End If
		          If DataSp(I).IndexOf("MainHeight=") >=0 Then
		            Main.Height = DataSp(I).ReplaceAll("MainHeight=", "").Trim.ToInteger
		          End If
		          
		          If DataSp(I).IndexOf("CatFont=") >=0 Then
		            Main.Categories.FontSize = DataSp(I).ReplaceAll("CatFont=", "").Trim.ToInteger
		          End If
		          If DataSp(I).IndexOf("ItemFont=") >=0 Then
		            Main.Items.FontSize = DataSp(I).ReplaceAll("ItemFont=", "").Trim.ToInteger
		          End If
		          If DataSp(I).IndexOf("DescriptionFont=") >=0 Then
		            Main.Description.FontSize = DataSp(I).ReplaceAll("DescriptionFont=", "").Trim.ToInteger
		          End If
		          If DataSp(I).IndexOf("MetaFont=") >=0 Then
		            Main.MetaData.FontSize = DataSp(I).ReplaceAll("MetaFont=", "").Trim.ToInteger
		          End If
		        Next
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadSettings()
		  If Debugging Then Debug("--- Starting Load Settings ---")
		  Dim RL As String
		  Dim F As FolderItem
		  Dim EnableDebugging As Boolean
		  
		  SettingsLoaded = True
		  
		  SettingsFile = AppPath+"LLL_Settings.ini"
		  F = GetFolderItem(SettingsFile,FolderItem.PathTypeNative)
		  If Not F.Exists Then Return 'No Settings file found
		  Try
		    InputStream = TextInputStream.Open(F)
		    While Not inputStream.EndOfFile 'If Empty file this skips it
		      RL = inputStream.ReadAll
		    Wend
		    inputStream.Close
		  Catch
		  End Try
		  
		  Dim I As Integer
		  Dim Sp() As String
		  Dim Lin, LineID, LineData As String
		  Dim EqPos As Integer
		  Dim IniFile As String
		  
		  RL = RL.ReplaceAll(Chr(13), Chr(10))
		  SP()=RL.Split(Chr(10))
		  If Sp.Count <= 0 Then Return ' Empty File
		  For I = 0 To Sp().Count -1
		    Lin = Sp(I).Trim
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
		    Case "LastUsedCategory"
		      LastUsedCategory = LineData
		    Case"SudoAsNeeded"
		      If LineData <> "" Then Settings.SetSudoAsNeeded.Value = IsTrue(LineData)
		      SudoAsNeeded = Settings.SetSudoAsNeeded.Value
		    Case"hideinstallergamecats"
		      If LineData <> "" Then Settings.SetHideGameCats.Value = IsTrue(LineData) 'HideInstallerGameCats = IsTrue(LineData)
		    Case"fontsizedescription"
		      If LineData <> "" Then Main.Description.FontSize = Val(LineData)
		    Case"fontsizecategories"
		      If LineData <> "" Then Main.Categories.FontSize = Val(LineData)
		    Case"fontsizeitems"
		      If LineData <> "" Then Main.Items.FontSize = Val(LineData)
		    Case"fontsizemetadata"
		      If LineData <> "" Then Main.MetaData.FontSize = Val(LineData)
		    Case "checkforupdates"
		      If LineData <> "" Then Settings.SetCheckForUpdates.Value = IsTrue(LineData)
		    Case "quitoncomplete"
		      If LineData <> "" Then Settings.SetQuitOnComplete.Value = IsTrue(LineData)
		    Case "videoplayback"
		      If LineData <> "" Then Settings.SetVideoPlayback.Value = IsTrue(LineData)
		    Case "videovolume"
		      If LineData <> "" Then Settings.SetVideoVolume.Text = LineData.Trim
		      If Val(Settings.SetVideoVolume.Text) > 100 Then Settings.SetVideoVolume.Text  = "100"
		      If Val(Settings.SetVideoVolume.Text) < 0 Then Settings.SetVideoVolume.Text  = "0"
		      MovieVolume = Val(Settings.SetVideoVolume.Text)
		      
		    Case "refreshafter"
		      If LineData <> "" Then Settings.SetRefreshAfter.Text = LineData.Trim
		      If Val(Settings.SetRefreshAfter.Text) > 999 Then Settings.SetRefreshAfter.Text  = "999"
		      If Val(Settings.SetRefreshAfter.Text) < 0 Then Settings.SetRefreshAfter.Text  = "0"
		      RefreshAfter = Val(Settings.SetRefreshAfter.Text)
		      
		      
		    Case "uselocaldbs"
		      If LineData <> "" Then Settings.SetUseLocalDBFiles.Value = IsTrue(LineData)
		    Case "copyitemstobuiltrepo"
		      If LineData <> "" Then Settings.SetCopyToRepoBuild.Value = IsTrue(LineData)
		    Case "ignorecachedrepoitems"
		      If LineData <> "" Then Settings.SetIgnoreCache.Value = IsTrue(LineData)
		    Case "hideinstalledonstartup"
		      If LineData <> "" Then
		        Settings.SetHideInstalled.Value = IsTrue(LineData)
		        Main.HideInstalled = IsTrue(LineData) 'Apply it to current settings
		      End If
		    Case "hideunsetflagsonstartup"
		      If LineData <> "" Then
		        Settings.SetHideUnsetFlags.Value = IsTrue(LineData)
		        Main.HideUnsetFlags= IsTrue(LineData) 'Apply it to current settings
		      End If
		    Case "scanlocalitems"
		      If LineData <> "" Then  Settings.SetScanLocalItems.Value = IsTrue(LineData)
		    Case "usemanuallocations"
		      If LineData <> "" Then Settings.SetUseManualLocations.Value = IsTrue(LineData)
		    Case "flatpaklocation"
		      If LineData = "User" Then
		        Settings.SetFlatpakAsUser.Value = True
		        Settings.SetFlatpakAsSystem.Value = False
		        FlatpakAsUser = Settings.SetFlatpakAsUser.Value
		      Else
		        Settings.SetFlatpakAsUser.Value = False
		        Settings.SetFlatpakAsSystem.Value =  True
		        FlatpakAsUser = Settings.SetFlatpakAsUser.Value
		      End If
		    Case "useonlinerepositiories"
		      If LineData <> "" Then Settings.SetUseOnlineRepos.Value = IsTrue(LineData)
		      If ForceOffline Then Settings.SetUseOnlineRepos.Value = False 'Force not to use Online Repo's
		    Case "debugenabled"
		      If LineData <> "" Then Settings.SetDebugEnabled.Value = IsTrue(LineData)
		      If DebugFileOk = True Then
		        EnableDebugging = Settings.SetDebugEnabled.Value
		      Else
		        Debugging = False 'If the file isn't writable then no point in enabling the debugger
		        EnableDebugging = False
		      End If
		    Case "alwaysshowres"
		      If LineData <> "" Then Settings.SetAlwaysShowRes.Value = IsTrue(LineData)
		    Case "recoverscreenres"
		      If LineData <> "" Then Settings.SetRecoverScreenRes.Value = IsTrue(LineData)
		    Case "noupdateonlinedbonstart"
		      ForceNoOnlineDBUpdates = IsTrue(LineData)
		      Settings.SetNoUpdateDBOnStart.Value = IsTrue(LineData)
		    End Select
		  Next
		  App.DoEvents(1)' Update the Settings Form with the new Check values before we do anything, might fix it, else I'll need to use Variables
		  
		  
		  'Get Manual Locations
		  Settings.SetManualLocations.Text = "" 'Clear it, will load again if one is available for Store Mode
		  If Settings.SetUseManualLocations.Value = True Then 'Only use them if set to use them
		    If StoreMode = 0 Then
		      If TargetWindows Then
		        IniFile = Slash(AppPath)+"LLL_Store_Win_Manual_Locations.ini"
		      Else
		        IniFile = Slash(AppPath)+"LLL_Store_Linux_Manual_Locations.ini"
		      End If
		    Else
		      If TargetWindows Then
		        IniFile = Slash(AppPath)+"LLL_Launcher_Win_Manual_Locations.ini"
		      Else
		        IniFile = Slash(AppPath)+"LLL_Launcher_Linux_Manual_Locations.ini"
		      End If
		    End If
		    ManualLocationsFile = IniFile
		    If Exist(IniFile) Then
		      Settings.SetManualLocations.Text = LoadDataFromFile(IniFile)
		    End If
		  End If
		  
		  If EnableDebugging Then Debugging = True 'Do this after the above settings or it shows them before the first line later on
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadTheme(ThemeName As String)
		  If Debugging Then Debug("--- Starting Load Theme ---")
		  
		  'Load Wallpaper for main theme
		  Dim F As FolderItem
		  Dim ImgPath As String
		  Dim I As Integer
		  
		  Main.Description.FontSize = 12
		  Main.Items.FontSize = 12
		  Main.Categories.FontSize = 12
		  Main.MetaData.FontSize = 12
		  
		  ThemePath = AppPath+"Themes/"+ThemeName+"/"
		  LastTheme = ThemeName
		  
		  ImgPath = ThemePath+"Loading.png"
		  F=GetFolderItem(ImgPath, FolderItem.PathTypeNative)
		  DefaultLoadingWallpaper = Picture.Open(F)
		  
		  If Loading.Backdrop = Nil Then
		    Loading.Backdrop = New Picture(Loading.Width+1,Loading.Height, 32)
		  End If
		  
		  #Pragma BreakOnExceptions Off
		  
		  App.DoEvents(1)
		  Try
		    Loading.Backdrop.Graphics.DrawPicture(DefaultLoadingWallpaper,0,0,Loading.Width+1, Loading.Height,0,0,DefaultLoadingWallpaper.Width, DefaultLoadingWallpaper.Height)
		  Catch
		    Loading.Backdrop.Graphics.DrawingColor = &C000000
		    Loading.Backdrop.Graphics.FillRectangle(0,0,Loading.Width,Loading.Height)
		  End Try
		  
		  #Pragma BreakOnExceptions On
		  'Below stops the first draw issue in Linux (It's ugly)
		  If FirstRun = False Then Loading.Show 'Show as soon as it's Themed, then it draws right :)
		  
		  ImgPath = ThemePath+"Wallpaper.jpg"
		  F=GetFolderItem(ImgPath, FolderItem.PathTypeNative)
		  If Exist(ImgPath) Then
		    DefaultMainWallpaper = Picture.Open(F)
		  Else
		    DefaultMainWallpaper = New Picture(Screen(0).AvailableWidth,Screen(0).AvailableHeight, 32)
		    DefaultMainWallpaper.Graphics.DrawingColor = &C000000
		    DefaultMainWallpaper.Graphics.FillRectangle(0,0,DefaultMainWallpaper.Width,DefaultMainWallpaper.Height)
		  End If
		  
		  If Exist(ThemePath+"Screenshot.jpg") Then
		    F=GetFolderItem(ThemePath+"Screenshot.jpg", FolderItem.PathTypeNative)
		    ScreenShotCurrent = Picture.Open(F)
		  Else
		    'No Need to make black if always transparent
		    ScreenShotCurrent = New Picture(Screen(0).AvailableWidth,Screen(0).AvailableHeight, 32)
		    ScreenShotCurrent.Graphics.DrawingColor = &C000000
		    ScreenShotCurrent.Graphics.FillRectangle(0,0,ScreenShotCurrent.Width,ScreenShotCurrent.Height)
		  End If
		  
		  Main.Backdrop = DefaultMainWallpaper
		  
		  F=GetFolderItem(ThemePath+"Icon.png", FolderItem.PathTypeNative)
		  DefaultFader = Picture.Open(F)
		  
		  F=GetFolderItem(ThemePath+"StartButton.png", FolderItem.PathTypeNative)
		  DefaultStartButton = Picture.Open(F)
		  
		  F=GetFolderItem(ThemePath+"StartButtonHover.png", FolderItem.PathTypeNative)
		  DefaultStartButtonHover = Picture.Open(F)
		  
		  If Main.StartButton.Backdrop = Nil Then
		    Main.StartButton.Backdrop = New Picture(Main.StartButton.Width,Main.StartButton.Height, 32)
		  End If
		  
		  #Pragma BreakOnExceptions Off
		  Try
		    Main.StartButton.Backdrop.Graphics.DrawPicture(DefaultFader,0,0,Main.StartButton.Width, Main.StartButton.Height,0,0,DefaultStartButton.Width, DefaultStartButton.Height)
		  Catch
		  End Try
		  
		  #Pragma BreakOnExceptions On
		  
		  Data.Icons.AddRow
		  Data.Icons.RowImageAt(0) = DefaultFader
		  Data.Icons.DefaultRowHeight = 256
		  
		  'Load in whole file at once (Fastest Method)
		  F = GetFolderItem(ThemePath+"Style.ini",FolderItem.PathTypeNative)
		  
		  Dim RL As String
		  Dim Sp() As String
		  Dim Lin, LineID, LineData As String
		  Dim EqPos As Integer
		  If  F.Exists Then 
		    Try
		      inputStream = TextInputStream.Open(F)
		      While Not inputStream.EndOfFile 'If Empty file this skips it
		        RL = inputStream.ReadAll
		      Wend
		      inputStream.Close
		    Catch
		    End Try
		  End If
		  RL = RL.ReplaceAll(Chr(13), Chr(10))
		  SP()=RL.Split(Chr(10))
		  If Sp.Count >= 1 Then  'Not Empty Theme File
		    For I = 0 To Sp().Count -1
		      Lin = Sp(I).Trim
		      EqPos = Lin.IndexOf(1,"=")
		      LineID = ""
		      LineData = ""
		      If  EqPos >= 1 Then
		        LineID = Left(Lin,EqPos)
		        LineData = Right(Lin,Len(Lin)-Len(LineID)-1)
		        LineID=LineID.Trim.Lowercase
		        LineData=LineData.Trim
		      Else 'No Equals, Broken?
		        LineID = Lin.Trim
		      End If
		      Select Case LineID
		      Case "coltitle"
		        If LineData <> "" Then ColTitle = Color.FromString(LineData)
		        'MsgBox ColTitle.ToString
		      Case"colcategory"
		        If LineData <> "" Then ColCategory = Color.FromString(LineData)
		      Case"coldescription"
		        If LineData <> "" Then ColDescription = Color.FromString(LineData)
		      Case"collist"
		        If LineData <> "" Then ColList = Color.FromString(LineData)
		      Case"colssapp"
		        If LineData <> "" Then ColssApp = Color.FromString(LineData)
		      Case"colppapp"
		        If LineData <> "" Then ColppApp = Color.FromString(LineData)
		      Case"colppgame"
		        If LineData <> "" Then ColppGame = Color.FromString(LineData)
		      Case"colllapp"
		        If LineData <> "" Then ColLLApp = Color.FromString(LineData)
		      Case"colllgame"
		        If LineData <> "" Then ColLLGame = Color.FromString(LineData)
		      Case"colmeta"
		        If LineData <> "" Then ColMeta = Color.FromString(LineData)
		      Case"colstats"
		        If LineData <> "" Then ColStats = Color.FromString(LineData)
		      Case"colbg"
		        If LineData <> "" Then ColBG = Color.FromString(LineData)
		      Case"colfg"
		        If LineData <> "" Then ColFG = Color.FromString(LineData)
		      Case"colselect"
		        If LineData <> "" Then ColSelect = Color.FromString(LineData)
		      Case "colhilite"
		        If LineData <> "" Then ColHiLite = Color.FromString(LineData)
		      Case"colloading"
		        If LineData <> "" Then ColLoading = Color.FromString(LineData)
		      Case"fontloading"
		        If LineData <> "" Then FontLoading = LineData
		      Case"fonttitle"
		        If LineData <> "" Then FontTitle = LineData
		      Case"fontlist"
		        If LineData <> "" Then FontList = LineData
		      Case"fontdescription"
		        If LineData <> "" Then FontDescription = LineData
		      Case"fontstats"
		        If LineData <> "" Then FontStats = LineData
		      Case"fontmeta"
		        If LineData <> "" Then FontMeta = LineData
		      Case"boldtitles"
		        If LineData <> "" Then BoldTitle = IsTrue(LineData)
		      Case"boldlist"
		        If LineData <> "" Then BoldList = IsTrue(LineData)
		      Case"bolddescription"
		        If LineData <> "" Then BoldDescription = IsTrue(LineData)
		      End Select
		    Next
		  End If
		  
		  'Apply Settings
		  'Labels
		  Main.TitleLabel.TextColor = ColTitle
		  Main.CategoriesLabel.TextColor = ColTitle
		  Main.ItemsLabel.TextColor = ColTitle
		  
		  Main.TitleLabel.FontName = FontTitle
		  Main.CategoriesLabel.FontName = FontTitle
		  Main.ItemsLabel.FontName = FontTitle
		  
		  Main.TitleLabel.Bold = BoldTitle
		  Main.CategoriesLabel.Bold = BoldTitle
		  Main.ItemsLabel.Bold = BoldTitle
		  
		  'Stats
		  Main.Stats.TextColor = ColStats
		  Main.Stats.FontName = FontStats
		  
		  Main.CheckSortMenus.FontName = FontStats
		  
		  'Meta 'Cols are in the PaintEvents
		  Main.MetaData.FontName = FontMeta
		  
		  'Description, This also gets applied before changing the description in FirstRun Timer event and ChangeItem method
		  Main.Description.TextColor = ColDescription
		  Main.Description.BackgroundColor = ColBG
		  Main.Description.FontName = FontDescription
		  Main.Description.Bold = BoldDescription
		  
		  'Categories
		  'Main.Categories.TextColor = ColCategory 'Done in CellPaint Events
		  Main.Categories.FontName = FontList
		  Main.Categories.Bold = BoldList
		  
		  'Items
		  'Main.Items.TextColor = ColList 'Done in CellPaint Events
		  Main.Items.FontName = FontList
		  Main.Items.Bold = BoldList
		  
		  Loading.Status.TextColor = ColLoading
		  Loading.Status.FontName = FontLoading
		  
		  Notification.Status.FontName = FontLoading
		  
		  ColDual = Color.RGB(((ColHiLite.Blue + ColSelect.Blue) /2),((ColHiLite.Green + ColSelect.Green)/2),((ColHiLite.Red + ColSelect.Red) /2)) 'Inversed
		  'ColDual = Color.RGB(((ColHiLite.Red + ColSelect.Red) /2),((ColHiLite.Green + ColSelect.Green)/2),((ColHiLite.Blue + ColSelect.Blue) /2)) 'Average
		  
		  If Debugging Then Debug("- Loaded Theme: "+ThemeName)
		  
		  #Pragma BreakOnExceptions On
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshDBs()
		  ForceRefreshDBs = True
		  Loading.Visible = True
		  'Store Windows Position to restore after window returns
		  PosLeft = Main.Left
		  PosTop = Main.Top
		  PosWidth = Main.Width
		  PosHeight = Main.Height
		  
		  Main.Visible = False 'Hide main form
		  App.DoEvents(4) 'Wait .004 of a second
		  Loading.FirstRunTime.RunMode = Timer.RunModes.Single
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveAllDBs()
		  If Debugging Then Debug("--- Starting Save All DBs ---")
		  App.DoEvents(1) 'This makes the Load Screen Update the Status Text, Needs to be in each Function and Sub call
		  
		  Dim H, G, F As FolderItem
		  Dim I, J, K As Integer
		  Dim DBHeader As String
		  Dim DBOutPath As String
		  Dim DBOutText As String
		  Dim DataOut As String
		  Dim PatIni As String
		  Dim UniqueName As String
		  Dim IsCompressed As Boolean
		  
		  'Cache frequently-used column indices (pre-optimised in previous pass)
		  Dim SDBColCompressed As Integer = Data.GetDBHeader("Compressed")
		  Dim SDBColPathINI    As Integer = Data.GetDBHeader("PathINI")
		  Dim SDBColUnique     As Integer = Data.GetDBHeader("UniqueName")
		  Dim SDBColLnkMulti  As Integer = Data.GetDBHeader("LnkMultiple")
		  Dim SDBColTitleName As Integer = Data.GetDBHeader("TitleName")
		  
		  '=== OPTIMISATION 1: Pre-classify every column write-type once, outside all loops.
		  '    The inner K loop previously called HeaderAt(K) + Select Case string compare
		  '    for every column of every item.  Now it just reads an Integer.
		  '    Write-type codes:
		  '      0 = Write as-is           1 = FixEOL
		  '      2 = FileINI (%DBPath%)    3 = PathINI (%URLPath%)
		  '      4 = FileIcon/Fader/Shot   5 = CompPath (Else)
		  Dim ColCount As Integer = Data.Items.ColumnCount - 2 '-2 to exclude Sorting column
		  Dim ColWriteType(256) As Integer
		  
		  DBHeader = ""
		  For K = 0 To ColCount
		    Dim ColName As String = Data.Items.HeaderAt(K)
		    DBHeader = DBHeader + ColName + "|"
		    Select Case ColName
		    Case "URL","BuildType","Compressed","Hidden","HiddenAlways","ShowAlways","ShowSetupOnly", _
		      "Installed","Arch","OS","TitleName","Version","Categories","Catalog","Priority","IconRef", _
		      "Flags","Tags","Publisher","Language","Rating","Additional","Players","License", _
		      "ReleaseVersion","ReleaseDate","RequiredRuntimes","Builder","InstalledSize","LnkTitle", _
		      "LnkCategories","LnkFlags","LnkAssociations","LnkTerminal","LnkMultiple","LnkParentRef", _
		      "LnkIcon","LnkOSCompatible","LnkDECompatible","LnkPMCompatible","LnkArchCompatible", _
		      "NoInstall","OSCompatible","DECompatible","PMCompatible","ArchCompatible","UniqueName", _
		      "Dependencies","Sorting"
		      ColWriteType(K) = 0
		    Case "Description","LnkComment","LnkDescription"
		      ColWriteType(K) = 1
		    Case "FileINI"
		      ColWriteType(K) = 2
		    Case "PathINI"
		      ColWriteType(K) = 3
		    Case "FileIcon","FileFader","FileScreenshot"
		      ColWriteType(K) = 4
		    Case Else
		      ColWriteType(K) = 5 'CompPath
		    End Select
		  Next K
		  DBHeader = DBHeader + Chr(10) 'Newline to separate the header — built ONCE for all paths
		  
		  '=== OPTIMISATION 2: Pre-build ScanPath → J-index list once.
		  '    The original code scanned ALL ScanItems for every scan path (O(paths × items)).
		  '    The Dictionary reduces this to O(items) to build + O(items_per_path) per path.
		  Dim PathIndex As New Dictionary  'ScanPath string → pipe-delimited J-index list
		  For J = 0 To Data.ScanItems.RowCount - 1
		    Dim SpKey As String = Data.ScanItems.CellTextAt(J, 2)
		    If PathIndex.HasKey(SpKey) Then
		      PathIndex.Value(SpKey) = CStr(PathIndex.Value(SpKey)) + "|" + CStr(J)
		    Else
		      PathIndex.Value(SpKey) = CStr(J)
		    End If
		  Next J
		  
		  For I = 0 To Data.ScanPaths.RowCount - 1
		    DBOutPath = Data.ScanPaths.CellTextAt(I, 0) + ".lldb/"
		    
		    If Slash(Data.ScanPaths.CellTextAt(I,0)) = Slash(RepositoryPathLocal) Then Continue 'Do NOT do local repository path databases, it uses the online one for that
		    
		    If Data.ScanPaths.CellTextAt(I,1) = "T" Then Continue 'It loaded from an existing DB so no need to save it
		    
		    Deltree(DBOutPath) 'Kill Previous Database if writable media.
		    MakeFolder(DBOutPath) 'Make sure it exist again
		    
		    If IsWritable(DBOutPath) = False Then Continue 'No point in Generating the new Database file as it can't be saved to a path that isn't writable
		    
		    '=== OPTIMISATION 3: Row strings collected into array, joined once at the end.
		    '    Original appended to a single DBOutText string for every field of every item,
		    '    creating O(items × cols) intermediate string copies.
		    Dim DBLines() As String
		    
		    '--- Primary scan items loop (items belonging to this scan path) ---
		    Dim CurPathStr As String = Data.ScanPaths.CellTextAt(I, 0)
		    If PathIndex.HasKey(CurPathStr) Then
		      Dim JIndexList() As String = CStr(PathIndex.Value(CurPathStr)).Split("|")
		      For Each JStr As String In JIndexList
		        J = Val(JStr)
		        If Data.ScanItems.CellTagAt(J,0) < 0 Then Continue 'Only add valid items
		        
		        '=== OPTIMISATION 4: Cache item row once per J — original called CellTagAt 6+ times per item
		        Dim ItemRow As Integer = Data.ScanItems.CellTagAt(J, 0)
		        
		        IsCompressed = IsTrue(Data.Items.CellTextAt(ItemRow, SDBColCompressed))
		        If IsCompressed Then
		          PatINI = Data.Items.CellTextAt(ItemRow, SDBColPathINI)
		          PatINI = Left(PatIni, InStrRev(PatIni,"/")-1)
		        Else
		          PatINI = Data.Items.CellTextAt(ItemRow, SDBColPathINI)
		          PatINI = Left(PatIni, InStrRev(PatIni,"/")-1)
		          PatINI = Left(PatIni, InStrRev(PatIni,"/")-1)
		        End If
		        
		        UniqueName = Data.Items.CellTextAt(ItemRow, SDBColUnique)
		        
		        Dim RowParts() As String
		        For K = 0 To ColCount
		          Select Case ColWriteType(K)
		          Case 0 'As-is
		            RowParts.Append(Data.Items.CellTextAt(ItemRow, K))
		          Case 1 'FixEOL
		            RowParts.Append(FixEOL(Data.Items.CellTextAt(ItemRow, K)))
		          Case 2 'FileINI → %DBPath%
		            DataOut = Data.Items.CellTextAt(ItemRow, K)
		            DataOut = DataOut.ReplaceAll(PatINI, "%DBPath%")
		            DataOut = DataOut.ReplaceAll("\", "/")
		            RowParts.Append(DataOut)
		          Case 3 'PathINI → %URLPath%
		            DataOut = Data.Items.CellTextAt(ItemRow, K)
		            DataOut = DataOut.ReplaceAll(PatINI, "%URLPath%")
		            DataOut = DataOut.ReplaceAll("\", "/")
		            RowParts.Append(DataOut)
		          Case 4 'FileIcon/FileFader/FileScreenshot
		            DataOut = Data.Items.CellTextAt(ItemRow, K)
		            DataOut = DataOut.ReplaceAll("\", "/")
		            If IsCompressed Then
		              If DataOut <> "" Then
		                H = GetFolderItem(DataOut, FolderItem.PathTypeNative)
		                G = GetFolderItem(DBOutPath+UniqueName+Right(DataOut,4), FolderItem.PathTypeNative)
		                If G.Exists Then
		                  Try
		                    If FixPath(H.NativePath) <> FixPath(G.NativePath) Then G.Delete
		                  Catch
		                  End Try
		                End If
		                If FixPath(H.NativePath) <> FixPath(G.NativePath) Then
		                  If G.IsWriteable Then
		                    If H.Exists Then
		                      #Pragma BreakOnExceptions Off
		                      Try
		                        If G.Exists Then G.Remove
		                        H.CopyTo(G)
		                        DataOut = "%DBPath%/.lldb/"+UniqueName+Right(DataOut,4)
		                      Catch
		                      End Try
		                      #Pragma BreakOnExceptions On
		                    End If
		                  End If
		                End If
		              End If
		            Else
		              DataOut = DataOut.ReplaceAll(PatINI, "%DBPath%")
		              DataOut = DataOut.ReplaceAll("\", "/")
		            End If
		            RowParts.Append(DataOut)
		          Case 5 'CompPath (Else)
		            RowParts.Append(CompPath(Data.Items.CellTextAt(ItemRow, K)))
		          End Select
		        Next K
		        DBLines.Append(Join(RowParts, ",|,") + ",|,")
		      Next
		    End If
		    
		    'If Launcher mode just add all the MultiLinks to the DB's
		    If StoreMode = 1 Then
		      For J = 0 To Data.Items.RowCount - 1
		        If IsTrue(Data.Items.CellTextAt(J, SDBColLnkMulti)) Then
		          If Data.Items.CellTagAt(J, SDBColLnkMulti) = Data.ScanPaths.CellTextAt(I, 0) Then
		            
		            IsCompressed = IsTrue(Data.Items.CellTextAt(J, SDBColCompressed))
		            If IsCompressed Then
		              PatINI = Data.Items.CellTextAt(J, SDBColPathINI)
		              PatINI = Left(PatIni, InStrRev(PatIni,"/")-1)
		            Else
		              PatINI = Data.Items.CellTextAt(J, SDBColPathINI)
		              PatINI = Left(PatIni, InStrRev(PatIni,"/")-1)
		              PatINI = Left(PatIni, InStrRev(PatIni,"/")-1)
		            End If
		            
		            UniqueName = Data.Items.CellTextAt(J, SDBColUnique)
		            
		            Dim RowParts2() As String
		            For K = 0 To ColCount
		              Select Case ColWriteType(K)
		              Case 0, 5  'Loop 2 original has no as-is case — all non-special columns use CompPath
		                RowParts2.Append(CompPath(Data.Items.CellTextAt(J, K)))
		              Case 1
		                RowParts2.Append(CompPath(FixEOL(Data.Items.CellTextAt(J, K))))
		              Case 2 'FileINI → %DBPath%
		                DataOut = Data.Items.CellTextAt(J, K)
		                DataOut = DataOut.ReplaceAll(PatINI, "%DBPath%")
		                DataOut = DataOut.ReplaceAll("\", "/")
		                RowParts2.Append(DataOut)
		              Case 3 'PathINI → %URLPath%
		                DataOut = Data.Items.CellTextAt(J, K)
		                DataOut = DataOut.ReplaceAll(PatINI, "%URLPath%")
		                DataOut = DataOut.ReplaceAll("\", "/")
		                RowParts2.Append(DataOut)
		              Case 4 'FileIcon/FileFader/FileScreenshot
		                DataOut = Data.Items.CellTextAt(J, K)
		                DataOut = DataOut.ReplaceAll("\", "/")
		                If IsCompressed Then
		                  If DataOut <> "" Then
		                    H = GetFolderItem(DataOut, FolderItem.PathTypeNative)
		                    G = GetFolderItem(DBOutPath+UniqueName+Right(DataOut,4), FolderItem.PathTypeNative)
		                    If G.Exists Then
		                      Try
		                        If FixPath(H.NativePath) <> FixPath(G.NativePath) Then G.Delete
		                      Catch
		                      End Try
		                    End If
		                    If FixPath(H.NativePath) <> FixPath(G.NativePath) Then
		                      If G.IsWriteable Then
		                        If H.Exists Then
		                          #Pragma BreakOnExceptions Off
		                          Try
		                            If G.Exists Then G.Remove
		                            H.CopyTo(G)
		                            DataOut = "%DBPath%/.lldb/"+UniqueName+Right(DataOut,4)
		                          Catch
		                          End Try
		                          #Pragma BreakOnExceptions On
		                        End If
		                      End If
		                    End If
		                  End If
		                  DataOut = FixEOL(Data.Items.CellTextAt(Data.ScanItems.CellTagAt(J,0),K)) 'Preserved from original
		                Else
		                  DataOut = DataOut.ReplaceAll(PatINI, "%DBPath%")
		                  DataOut = DataOut.ReplaceAll("\", "/")
		                End If
		                RowParts2.Append(DataOut)
		              End Select
		            Next K
		            DBLines.Append(Join(RowParts2, ",|,") + ",|,")
		          End If
		        End If
		      Next
		    End If
		    
		    'Save File
		    DBOutText = Join(DBLines, Chr(10))
		    If DBOutText <> "" Then
		      If Right(DBOutText, 1) <> Chr(10) Then DBOutText = DBOutText + Chr(10) 'Ensure trailing newline matches original
		      SaveDataToFile(DBHeader+DBOutText, DBOutPath+"lldb.ini")
		    Else
		      Deltree(DBOutPath)
		    End If
		    'Change Permissions
		    If TargetLinux Then ChMod(DBOutPath,"-R 777")
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveFavorites()
		  If FavCount <= 0 Then Return
		  Dim I As Integer
		  Dim FavOut As String
		  'Save Favorites if some are set
		  For I = 0 To FavCount - 1
		    If Favorites(I) <> "" Then FavOut = FavOut + Favorites(I) + Chr(10)
		  Next I
		  
		  If FavOut <> "" Then
		    SaveDataToFile (FavOut, Slash(AppPath)+"Favorites.ini")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePosition()
		  Dim FileOut As String
		  Dim DataOut As String
		  
		  FileOut = ""
		  If StoreMode = 0 Then 
		    FileOut = Slash(SpecialFolder.ApplicationData.NativePath)+".LLStore.ini"
		  ElseIf StoreMode = 1 Then
		    FileOut = Slash(SpecialFolder.ApplicationData.NativePath)+".LLLauncher.ini"
		  End If
		  
		  If TargetWindows Then
		    FileOut = FileOut.ReplaceAll("/","\")
		  Else
		    FileOut = FileOut.ReplaceAll("\","/")
		  End If
		  
		  If Debugging Then Debug ("- Saving Position To File: " + FileOut)
		  
		  If FileOut <> "" Then
		    If Main.Visible = True Then
		      If Main.Left >=0 And Main.Top >=0 Then
		        If Main.Left+Main.Width <= Screen(0).AvailableWidth And Main.Top+Main.Height <= Screen(0).AvailableHeight Then
		          'Only save if visible
		          DataOut = DataOut + "MainLeft=" + Main.Left.ToString+Chr(10)
		          DataOut = DataOut + "MainTop=" + Main.Top.ToString+Chr(10)
		          DataOut = DataOut + "MainWidth=" + Main.Width.ToString+Chr(10)
		          DataOut = DataOut + "MainHeight=" + Main.Height.ToString+Chr(10)
		          
		          DataOut = DataOut + "CatFont=" + Main.Categories.FontSize.ToString+Chr(10)
		          DataOut = DataOut + "ItemFont=" + Main.Items.FontSize.ToString+Chr(10)
		          DataOut = DataOut + "DescriptionFont=" + Main.Description.FontSize.ToString+Chr(10)
		          DataOut = DataOut + "MetaFont=" + Main.MetaData.FontSize.ToString+Chr(10)
		          
		          SaveDataToFile (DataOut, FileOut)
		        End If
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveSettings()
		  If Debugging Then Debug("--- Starting Save Settings ---")
		  
		  If SettingsLoaded = False Then Return
		  If SettingsChanged = False Then Return 'Don't save if not edited them (so Switches don't get saved)
		  
		  Dim RL As String
		  
		  SettingsFile = Slash(AppPath)+"LLL_Settings.ini"
		  RL = "[LLStore]" + Chr(10) 'Using a header so I can sort below without having to shufffle the first item, gets ignored
		  
		  RL = RL + "FontSizeCategories=" + Str(Main.Categories.FontSize)+Chr(10)
		  RL = RL + "FontSizeDescription=" + Str(Main.Description.FontSize)+Chr(10)
		  RL = RL + "FontSizeItems=" + Str(Main.Items.FontSize)+Chr(10)
		  RL = RL + "FontSizeMetaData=" + Str(Main.MetaData.FontSize)+Chr(10)
		  RL = RL + "HideInstallerGameCats=" + Str(Settings.SetHideGameCats.Value) + Chr(10)
		  
		  RL = RL + "SudoAsNeeded=" + Str(Settings.SetSudoAsNeeded.Value) + Chr(10)
		  RL = RL + "CheckForUpdates=" + Str(Settings.SetCheckForUpdates.Value) + Chr(10)
		  RL = RL + "QuitOnComplete=" + Str(Settings.SetQuitOnComplete.Value) + Chr(10)
		  RL = RL + "VideoPlayback=" + Str(Settings.SetVideoPlayback.Value) + Chr(10)
		  RL = RL + "VideoVolume=" + Str(Settings.SetVideoVolume.Text) + Chr(10)
		  
		  RL = RL + "RefreshAfter=" + Str(Settings.SetRefreshAfter.Text) + Chr(10)
		  
		  RL = RL + "UseLocalDBs=" + Str(Settings.SetUseLocalDBFiles.Value) + Chr(10)
		  RL = RL + "CopyItemsToBuiltRepo=" + Str(Settings.SetCopyToRepoBuild.Value) + Chr(10)
		  RL = RL + "IgnoreCachedRepoItems=" + Str(Settings.SetIgnoreCache.Value) + Chr(10)
		  RL = RL + "LastUsedCategory=" + LastUsedCategory + Chr(10)
		  If Settings.SetFlatpakAsUser.Value = True Then
		    RL = RL + "FlatpakLocation=User" + Chr(10)
		  Else
		    RL = RL + "FlatpakLocation=System" + Chr(10)
		  End If
		  
		  RL = RL + "HideInstalledOnStartup=" + Str(Settings.SetHideInstalled.Value) + Chr(10)
		  RL = RL + "HideUnsetFlagsOnStartup=" + Str(Settings.SetHideUnsetFlags.Value) + Chr(10)
		  
		  RL = RL + "ScanLocalItems=" + Str(Settings.SetScanLocalItems.Value) + Chr(10)
		  
		  RL = RL + "UseManualLocations=" + Str(Settings.SetUseManualLocations.Value) + Chr(10)
		  RL = RL + "UseOnlineRepositiories=" + Str(Settings.SetUseOnlineRepos.Value) + Chr(10)
		  
		  RL = RL + "NoUpdateOnlineDBOnStart=" + Str(Settings.SetNoUpdateDBOnStart.Value) + Chr(10)
		  
		  
		  RL = RL + "DebugEnabled=" + Str(Settings.SetDebugEnabled.Value) + Chr(10)
		  
		  RL = RL + "AlwaysShowRes=" + Str(Settings.SetAlwaysShowRes.Value) + Chr(10)
		  
		  RL = RL + "RecoverScreenRes=" + Str(Settings.SetRecoverScreenRes.Value) + Chr(10)
		  
		  'Save to actual Settings File
		  SaveDataToFile(RL, SettingsFile)
		  
		  'Save Manual Locations
		  Dim IniFile As String
		  If StoreMode = 0 Then
		    If TargetWindows Then
		      IniFile = Slash(AppPath)+"LLL_Store_Win_Manual_Locations.ini"
		    Else
		      IniFile = Slash(AppPath)+"LLL_Store_Linux_Manual_Locations.ini"
		    End If
		  Else
		    If TargetWindows Then
		      IniFile = Slash(AppPath)+"LLL_Launcher_Win_Manual_Locations.ini"
		    Else
		      IniFile = Slash(AppPath)+"LLL_Launcher_Linux_Manual_Locations.ini"
		    End If
		  End If
		  If Settings.SetManualLocations.Text.Trim <> "" Or Exist (IniFile) Then  'Only update if not empty or empty it if already exist and nothing to save
		    SaveDataToFile(Settings.SetManualLocations.Text, IniFile)
		  End If
		  
		  'Save Repo's
		  SaveDataToFile(Settings.SetOnlineRepos.Text.ReplaceAll(Chr(13), Chr(10)),Slash(AppPath)+"LLL_Repos.ini")
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowDownloadImages()
		  Dim F As FolderItem
		  Dim WebWall As String
		  Dim UN As String
		  
		  Try
		    'Get UN Name (Universal Name)
		    UN = UniversalName(Data.Items.CellTextAt(CurrentItemID, Data.GetDBHeader("TitleName"))+Data.Items.CellTextAt(CurrentItemID, Data.GetDBHeader("BuildType")))
		    
		    If  Exist(Slash(RepositoryPathLocal)+".lldb/"+UN+".jpg") Then 'Screenshot
		      WebWall = Slash(RepositoryPathLocal)+".lldb/"+UN+".jpg" 'Data.Items.CellTextAt(CurrentItemIn, Data.GetDBHeader("FileScreenshot"))
		      If WebWall = "" Or Not Exist(WebWall) Then
		        WebWall = Slash(ThemePath) + "Screenshot.jpg" 'Default Theme Wallpaper used if no other given (could do Category Screenshots here if wanted)
		      End If
		      
		      F = GetFolderItem(WebWall, FolderItem.PathTypeNative)
		      ScreenShotCurrent = Picture.Open(F)
		      Main.ScaleScreenShot
		    End If
		  Catch
		  End Try
		  Try
		    If Exist(Slash(RepositoryPathLocal)+".lldb/"+UN+".png") Then 'Fader
		      WebWall = Slash(RepositoryPathLocal)+".lldb/"+UN+".png" 'Data.Items.CellTextAt(CurrentItemID, Data.GetDBHeader("FileFader"))
		      If WebWall = "" Or Not Exist(WebWall) Then
		        WebWall = Slash(ThemePath) + "Icon.png" 'Default Theme Icon  used if no other given (could do Category Icons here if wanted)
		      End If
		      F = GetFolderItem(WebWall, FolderItem.PathTypeNative)
		      CurrentFader = Picture.Open(F)
		      
		      'Clone From Wallpaper to Icon BG
		      If CurrentFader <> Nil Then
		        If Main.ItemFaderPic.Backdrop <> Nil And Main.Backdrop <> Nil Then ' Only do if Valid
		          Main.ItemFaderPic.Backdrop.Graphics.DrawPicture(Main.Backdrop,0,0,Main.ItemFaderPic.Width, Main.ItemFaderPic.Height, Main.ItemFaderPic.Left, Main.ItemFaderPic.Top, Main.ItemFaderPic.Width, Main.ItemFaderPic.Height)
		          'Draw Fader Icon on BG
		          Main.ItemFaderPic.Backdrop.Graphics.DrawPicture(CurrentFader,0,0,Main.ItemFaderPic.Width, Main.ItemFaderPic.Height,0,0,CurrentFader.Width, CurrentFader.Height)
		          Main.ItemFaderPic.Refresh
		        End If
		        
		        ' --- Update the listbox row icon with the newly downloaded image ---
		        ' Add the downloaded fader into the shared icon cache and point this
		        ' item's IconRef at the new slot.  Then repaint just the visible rows
		        ' via Items.Refresh — this preserves ScrollPosition and SelectedRowIndex
		        ' automatically, so the list position is never lost.
		        If CurrentItemID >= 0 Then
		          Dim NewIconIdx As Integer = Data.Icons.RowCount
		          Data.Icons.AddRow
		          Data.Icons.RowImageAt(NewIconIdx) = CurrentFader
		          Data.Items.CellTextAt(CurrentItemID, Data.GetDBHeader("IconRef")) = Str(NewIconIdx)
		          Main.Items.Refresh ' Repaint rows — does NOT reset scroll or selection
		        End If
		        
		      End If
		    End If
		  Catch
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartIconDownload(URL As String, LocalPath As String)
		  ' Downloads a .png icon/fader using an async curl shell.
		  ' DownloadScreenAndIcon timer polls IsRunning and calls ShowDownloadImages on completion.
		  Try
		    If ShellIcon <> Nil And ShellIcon.IsRunning Then ShellIcon.Close
		    ShellIcon = New Shell
		    ShellIcon.TimeOut = -1
		    ShellIcon.ExecuteMode = Shell.ExecuteModes.Asynchronous
		    Dim CurlBin As String = LinuxCurl
		    If TargetWindows Then CurlBin = WinCurl
		    ShellIcon.Execute(CurlBin + " -L -s --connect-timeout 15 -o " + Chr(34) + LocalPath + Chr(34) + " " + Chr(34) + URL + Chr(34))
		    DownloadScreenAndIcon.RunMode = Timer.RunModes.Multiple
		  Catch
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartScreenshotDownload(URL As String, LocalPath As String)
		  ' Downloads a .jpg screenshot using an async curl shell.
		  ' DownloadScreenAndIcon timer polls IsRunning and calls ShowDownloadImages on completion.
		  Try
		    If ShellScreenshot <> Nil And ShellScreenshot.IsRunning Then ShellScreenshot.Close
		    ShellScreenshot = New Shell
		    ShellScreenshot.TimeOut = -1
		    ShellScreenshot.ExecuteMode = Shell.ExecuteModes.Asynchronous
		    Dim CurlBin As String = LinuxCurl
		    If TargetWindows Then CurlBin = WinCurl
		    ShellScreenshot.Execute(CurlBin + " -L -s --connect-timeout 15 -o " + Chr(34) + LocalPath + Chr(34) + " " + Chr(34) + URL + Chr(34))
		    DownloadScreenAndIcon.RunMode = Timer.RunModes.Multiple
		  Catch
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateLoading(status As String)
		  Loading.Status.Text = status
		  Loading.Refresh
		  App.DoEvents(1)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Regenerate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ShellIcon As Shell
	#tag EndProperty

	#tag Property, Flags = &h0
		ShellScreenshot As Shell
	#tag EndProperty

	#tag Property, Flags = &h0
		SortMenuStyle As Boolean
	#tag EndProperty


#tag EndWindowCode

#tag Events FirstRunTime
	#tag Event
		Sub Action()
		  'This disables errors from breaking/debugging in the IDE, disable to debug
		  '# Pragma BreakOnExceptions False
		  If Debugging Then Debug("--- Starting LLStore FirstRunTimer ---")
		  
		  Dim I As Integer
		  Dim F As FolderItem
		  Dim Success As Boolean
		  Dim Test As String
		  
		  'Center Form
		  self.Left = (screen(0).AvailableWidth - self.Width) / 2
		  self.top = (screen(0).AvailableHeight - self.Height) / 2
		  
		  'Clear Data, always start with fresh fields etc (Do before theme so first icon is loaded
		  Data.ClearData
		  
		  'Clear Temp Paths here?
		  
		  'Make sure paths exist (But only once per execution)
		  TmpPathItems = Slash(TmpPath)+"items/" 'Use Linux Paths for both OS's
		  MakeFolder(TmpPathItems)
		  
		  If StoreMode <=1 Then 'Only load items if not (Mode 3 Editor or Mode 4 Installer) - Mode 2 is For silent mode stuff, not used yet
		    
		    Loading.Visible = True 'Don't show this if Arguments and mode is set Different
		    Loading.Show
		    Loading.Refresh
		    App.DoEvents
		    
		    'Check For Updates
		    'Msgbox RunningInIDE.ToString
		    
		    'Delete previous Sudo Attempt file:
		    Deltree(BaseDir+"/LLSudo") 'Remove it
		    
		    'Check if DB RefreshAfter Time has passed
		    TimePassed = False
		    If  GetFileAgeInSeconds(Slash(RepositoryPathLocal)+"00-rawgithubusercontentcomLiveFreeDeadLastOSLinux_Repositorymain.lldbini") >= RefreshAfter Then
		      TimePassed = True
		    End If
		    
		    If StoreMode = 0 Then 'Only update the installer NOT the launcher
		      
		      WritableAppPath = IsWritable(AppPath) 'This checks to see if the current user can write to the path, if not it skips updating it
		      If Not RunningInIDE And Settings.SetCheckForUpdates.Value And WritableAppPath Then
		        CheckingForUpdates = True
		        UpdateLoading("Check For Store Updates: ")
		        CheckForLLStoreUpdates
		        CheckingForUpdates = False
		      End IF
		      If Debugging Then Debug ("Writable AppPath: " + WritableAppPath.ToString)
		    End If
		    
		    'Get Scan Paths Here
		    UpdateLoading("Scanning Drives...")
		    GetScanPaths
		    
		    'Get items from in Scan Paths (Don't add yet)
		    UpdateLoading("Scanning for Items...")
		    
		    If Data.ScanPaths.RowCount >=1 Then
		      For I = 0 To Data.ScanPaths.RowCount - 1
		        If Settings.SetUseLocalDBFiles.Value = True Then
		          F = GetFolderItem(Data.ScanPaths.CellTextAt(I,0)+".lldb/lldb.ini",FolderItem.PathTypeNative)
		          If F.Exists And ForceRefreshDBs = False Then
		            LoadDB(Data.ScanPaths.CellTextAt(I,0))
		            Data.ScanPaths.CellTextAt(I,1) = "T"
		          Else 'Scan Items and Save DB Below
		            GetItems(Data.ScanPaths.CellTextAt(I,0))
		            Data.ScanPaths.CellTextAt(I,1) = "F"
		          End If
		        Else 'Not using LocalDB's
		          GetItems(Data.ScanPaths.CellTextAt(I,0))
		          Data.ScanPaths.CellTextAt(I,1) = "F"
		        End If
		      Next
		    End If
		    
		    'Extract Compressed items in one script
		    If StoreMode = 0 Then 'Only need to extract when install mode as games are already installed
		      UpdateLoading("Extract Items Data...")
		      ExtractAll
		    End If
		    
		    '------------------------------------------------------------------------- Optimise the Loading of items --------------------------------------------------------------
		    'Load Item Data, Need to Do DB stuff here also
		    UpdateLoading("Adding Items...")
		    Dim ScanItemCount As Integer = Data.ScanItems.RowCount
		    If ScanItemCount >= 1 Then
		      Dim ScanItemLast As Integer = ScanItemCount - 1
		      For I = 0 To ScanItemLast
		        ' Throttle the status text update — refreshing the label every item is expensive
		        ' for large catalogs. Update every 10 items; always show the last item.
		        If (I Mod 10) = 0 Or I = ScanItemLast Then
		          Loading.Status.Text = "Adding Items: "+ Str(I)+"/"+Str(ScanItemLast)
		        End If
		        '************************************************************************************
		        'Item ,2 is the ScanPath
		        CurrentScanPath = Data.ScanItems.CellTextAt(I,2) 'This is used to Identify Multiple Links so can save Launcher DB's with them
		        Data.ScanItems.CellTagAt(I,0) = GetItem(Data.ScanItems.CellTextAt(I,0), Data.ScanItems.CellTextAt(I,1)) 'The 2nd Part is the TmpFolder stored in the DB if it has Data
		      Next
		    End If
		    
		    'Save DBFiles
		    If Settings.SetUseLocalDBFiles.Value = True Then
		      UpdateLoading("Writing to DB Files...")
		      SaveAllDBs
		    End If
		    
		    If ForceRefreshDBs = True Then TimePassed = True 'If forced a refresh, do the online ones also
		    ForceRefreshDBs = False
		    
		    'Get online Databases
		    If StoreMode = 0 Then ' And TimePassed = True  '<- This is used below, so it uses the local downloaded DB's if they exist.
		      OnlineDBs = LoadDataFromFile(Slash(AppPath)+"LLL_Repos.ini").ReplaceAll(Chr(10), Chr(13)) ' Convert to standard format so it works in Windows and Linux
		      If OnlineDBs.Trim <> "" Then Settings.SetOnlineRepos.Text = OnlineDBs.Trim
		      'MsgBox "Here 1"
		      If Settings.SetUseOnlineRepos.Value = True Then
		        'MsgBox "Here 2"
		        CheckingForDatabases = True
		        If TimePassed = False Then ForceNoOnlineDBUpdates = True
		        If ForceNoOnlineDBUpdates = True Then
		          UpdateLoading("Using Offline Databases...")
		        Else
		          UpdateLoading("Downloading Online Databases...")
		        End If
		        GetOnlineDBs() 'Only do this when in Installation mode
		        CheckingForDatabases = False
		        UpdateLoading("Databases Loaded...")
		      End If
		    End If
		    'Disabled Weblinks for now while I find an alternative as google API is blocked by wget for non logged in users.
		    If StoreMode = 0 Then
		      'Get Weblinks to use Google etcx to host large files
		      UpdateLoading("Get Weblinks for large items...")
		      GetWebLinks()
		    End If
		    
		    DownloadPercentage = ""
		    
		    
		    'Hide Old Version (Only need to do this once as you load in Items)
		    UpdateLoading("Hiding Old Versions...")
		    HideOldVersions
		    
		    'Check If Items Are Installed
		    UpdateLoading("Checking For Installed Items...")
		    CheckInstalled
		    
		    'Check If Items Are Installed
		    UpdateLoading("Checking For Compatible Items...")
		    CheckCompatible
		    
		    'Make the Category list in Data Sections
		    UpdateLoading("Generating Lists...")
		    GenerateDataCategories()
		    Main.GenerateCategories()
		    
		    'Change Categories to All (This Generates the items too)
		    If LastUsedCategory = "" Then
		      Main.ChangeCat("All")
		    Else
		      Dim DidIt As Boolean = False
		      'Select Last Used Category - If Exist
		      For I = 0 To Data.Categories.RowCount - 1
		        If Main.Categories.CellTextAt(I, 0) = LastUsedCategory Then
		          'MsgBox LastUsedCategory
		          Main.ChangeCat(LastUsedCategory)
		          DidIt = True
		          Exit
		        End If
		      Next
		      'If not set then set to All
		      If DidIt = False Then  Main.ChangeCat("All")
		    End If
		    
		    'Load Favorites
		    LoadFavorites()
		    
		    'Last Status 
		    UpdateLoading("Generating GUI...")
		    
		    'Save Debug Of The Scanned Items:
		    If Debugging Then
		      Debug ("--- ITEMS IN DB ---")
		      If Data.Items.RowCount >=1 Then
		        For I = 0 To Data.Items.RowCount - 1
		          Debug("Item "+Str(I)+": "+ Data.Items.CellTextAt(I, Data.GetDBHeader("TitleName"))+" "+Data.Items.CellTextAt(I, Data.GetDBHeader("BuildType")))
		        Next
		        Debug("") 'Adds Blank Line
		      Else
		        Debug("No Items Added To Known Items")
		      End If
		    End If
		    
		    'Load position of main windows or Centre if not set
		    If StoreMode = 0 Or StoreMode = 1 Then Loading.LoadPosition 'Only Load if Store or Launcher
		    
		    If LoadedPosition = False Then 'Only resize to default position if none loaded
		      Main.width=screen(0).AvailableWidth-(screen(0).AvailableWidth/6)
		      Main.height=screen(0).AvailableHeight-(screen(0).AvailableHeight/12)
		      
		      Main.Left = (screen(0).AvailableWidth - Main.Width) / 2
		      Main.top = (screen(0).AvailableHeight - Main.Height) / 2
		    End If
		    
		    'Enable Resize Now, uses timer on main form to draw it properly
		    Main.ResizeMainForm
		    App.DoEvents(1)
		    LoadedMain = True
		    
		    'Do Default Description
		    '-------------
		    #Pragma BreakOnExceptions False
		    AssignedColors = Array( &C80B0FF, &Cff55ff, &CFFFFFF, &CFFFF50, &CAAFF40)
		    
		    Main.Description.Bold = BoldDescription
		    Main.Description.FontName = FontDescription
		    Main.Description.TextColor = ColDescription
		    Main.Description.StyledText.TextColor(0, Len(Main.Description.Text)) = ColDescription 'Make sure it's the right colour in Linux
		    
		    If StoreMode = 1 Then
		      Main.Title = "LL Launcher"
		      Main.CheckSortMenus.Visible = False
		      
		      Main.Description.Text = "Select a Game and press Start to Play it, if no games are shown the Launcher only shows items installed with LLStore." +chr(13) +chr(13) _
		      +"If you hold in Shift you can set the Screen Resolution of the game." + chr(13) _
		      + "You can also double click or press Enter to start the selected Game." _
		      + chr(13) +chr(13) + "Press Ctrl + Shift + F4 or Ctrl + Break during game play to exit from most games instantly in LastOSLinux"
		      
		      'Add extras so it shows Scrllbar always
		      If TargetLinux Then Main.Description.Text = Main.Description.Text + Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)
		    Else
		      
		      Main.Title = "LL Store"
		      If TargetWindows Then Main.CheckSortMenus.Visible = True 'Only show menu sorting in Windows as that is all that needs it
		      
		      Dim TriggerWords() As String
		      Dim EndCount As Integer
		      
		      TriggerWords = Array("LLApps","LLGames","ssApps", "ppApps", "ppGames")
		      
		      Main.Description.Text = "Select the Items you wish to install by marking your selection with spacebar, double clicking or using the context menu Selection options." +chr(13) +chr(13) _
		      + "Each Item you click will show its details in this description box." + chr(13)_
		      + "LLApps, LLGames, are Linux items determined by their Location and/or .lla/.llg file, and they are color-coded in the Items list." + chr(13)_
		      + "ssApps, ppApps, and ppGames are Windows/WINE items determined by their Location and/or .app/.ppg file, and they are color-coded in the Items list." _
		      + chr(13) + chr(13) + "Right-click the Items list for a menu that allows you to change Item selection and/or load/save a Preset." _
		      + "  Other options are available." + chr(13) + chr(13) _ 
		      + "LLStore cannot always detect previously installed applications and therefore may not hide these applications from the Items list. Especially when they are tweaks, themes and do not use an installation path" + chr(13) + chr(13) _ 
		      + "LLStore requires an internet connection to show online repositories, only local items will be shown otherwise."
		      
		      'Add extras so it shows Scrllbar always
		      If TargetLinux Then Main.Description.Text = Main.Description.Text + Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)+ Chr(13)
		      
		      EndCount = UBound(TriggerWords)
		      
		      Main.Description.Bold = BoldDescription
		      Main.Description.FontName = FontDescription
		      Main.Description.TextColor = ColDescription
		      Main.Description.StyledText.TextColor(0, Len(Main.Description.Text)) = ColDescription 'Make sure it's the right colour in Linux
		      
		      Try
		        For I = 0 To EndCount 'Looks complicated, but I got tired of counting characters by hand every time the text was edited :)
		          'Main.Description.StyledText.TextColor (Instr (Main.Description.Text, TriggerWords(I)) - 1, Len(TriggerWords(I))) = AssignedColors(I)
		          Var p As Integer = Instr(Main.Description.Text, TriggerWords(I))
		          If p > 0 Then
		            Main.Description.StyledText.TextColor(p - 1, Len(TriggerWords(I))) = AssignedColors(I)
		          End If
		        Next
		      Catch
		      End Try
		      
		    End If
		    #Pragma BreakOnExceptions True
		    '--------------
		    
		    'Check if UpTo Exists and load that in to continue if found
		    Dim Ret As Integer
		    If Exist(Slash(RepositoryPathLocal)+"UpTo.ini") Then
		      If ContinueSelf = False Then
		        Ret = MsgBox ("Found Previous Installation Queue, Continue Installing?", 52)
		      Else
		        Ret = 69
		        ContinueSelf = False
		      End If
		      
		      If Ret = 7 Then
		        'MsgBox ("No Ret "+ Ret.ToString)
		        Deltree(Slash(RepositoryPathLocal)+"UpTo.ini") ' Delete previous install queue
		      Else 'Not closed or pressed no (So YES)
		        'MsgBox ("Yes Ret "+ Ret.ToString)
		        CommandLineFile = Slash(RepositoryPathLocal)+"UpTo.ini"
		        LoadPresetFile = True
		        InstallArg = True  ' Auto Install continue
		        'MsgBox ("Loading: "+ CommandLineFile)
		      End If
		    End if
		    
		    'Load The Preset specified
		    If LoadPresetFile = True Then
		      If CommandLineFile <> "" Then
		        If Not Exist(CommandLineFile) Then
		          Test = Slash(Slash(AppPath)+"Presets")+CommandLineFile
		          If Exist(Test) Then CommandLineFile = Test 'Look in the Presets folder for it
		        End If
		        Success = Main.LoadFromPreset(CommandLineFile)
		        If Success Then
		          If InstallArg = True Then
		            'Hide Loading now it's done
		            If Loading.Visible Then
		              Loading.Visible = False
		              Loading.Refresh
		              App.DoEvents(1)
		            End If
		            
		            FirstRun = True 'Set this once everything is done and it's ready to go, used by ChangeItem so the intro isn't erased
		            
		            'Start Installer
		            MiniInstallerShowing = True
		            MiniInstaller.StartInstaller()
		            
		            'Clean up Main so it's ready
		            Main.ResizeMainForm 'Just check again as sometimes it's wrong
		            App.DoEvents(1)'Make sure it draws before doing other stuff that would make it draw ugly
		            
		            Return 'Quit Routine
		          End If
		        End If
		      End If
		    End If
		    
		    'Hide Loading now it's done
		    Loading.Visible = False
		    
		    App.DoEvents(1)'Make it hide before showing the main form (Less redraw)
		    
		    'Show main form
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
		    App.DoEvents(1)'Make sure it draws before doing other stuff that would make it draw ugly
		    Main.ResizeMainForm 'Just check again as sometimes it's wrong
		    App.DoEvents(1)'Make sure it draws before doing other stuff that would make it draw ugly
		    
		    FirstRun = True 'Set this once everything is done and it's ready to go, used by ChangeItem so the intro isn't erased
		    
		  Else
		    ForceQuit = True
		    Try
		      Main.Close  'Just quit for now, will do editor and installer stuff here
		    Finally
		      ForceQuit = False
		    End Try
		    
		  End If
		  
		  ForceQuit = False 'Makes everything not close and just hide again, but if you close the loading screen it's forced to quit now
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DownloadTimer
	#tag Event
		Sub Action()
		  ' ============================================================
		  ' Non-blocking download state machine.
		  ' Each timer fire does ONE step and returns immediately,
		  ' keeping the UI fully responsive for Skip/Pause/Cancel.
		  ' ============================================================
		  Const ST_IDLE        = 0  ' Waiting for queue to have items
		  Const ST_PREPARE     = 1  ' Set up current queue item
		  Const ST_VALIDATING  = 2  ' Async validation shell running
		  Const ST_DOWNLOADING = 3  ' Async wget shell running
		  Const ST_FINALIZE    = 4  ' Rename .partial to final
		  Const ST_ADVANCE     = 5  ' Move to next queue item
		  Const ST_DONE        = 6  ' Post-queue cleanup
		  
		  Static DLState As Integer           ' Current state
		  Static DLShell As Shell             ' Wget download shell
		  Static ValShell As Shell            ' Validation shell
		  Static ValBuffer As String          ' Accumulated validation output
		  Static MoveShell As Shell           ' Rename .partial shell
		  Static KillShell As Shell           ' Kill wget shell
		  Static GetURL As String             ' URL being processed (after WebLinks sub)
		  Static IsArchive As Boolean         ' Current URL is an archive type
		  Static UseGrep As Boolean           ' Grep is available on this system
		  Static GrepChecked As Boolean       ' Grep availability has been checked
		  Static GrepPath As String           ' Path to grep binary
		  Static ValidationFallback As Boolean ' True = running HEAD fallback after magic-byte failed
		  
		  Select Case DLState
		    
		    ' --------------------------------------------------------
		    ' IDLE: Wait for work. Timer set to Multiple by GetOnlineFile.
		    ' --------------------------------------------------------
		  Case ST_IDLE
		    If Not Downloading Or QueueCount <= 0 Then Return
		    If Debugging Then Debug("--- Download State Machine: Start ---")
		    If Exist(Slash(RepositoryPathLocal) + "DownloadDone") Then Deltree(Slash(RepositoryPathLocal) + "DownloadDone")
		    If Exist(Slash(RepositoryPathLocal) + "FailedDownload") Then Deltree(Slash(RepositoryPathLocal) + "FailedDownload")
		    QueueUpTo = 0
		    GrepChecked = False
		    DLState = ST_PREPARE
		    ' Fall through to PREPARE in the same tick
		    
		    ' --------------------------------------------------------
		    ' PREPARE: Set up the current queue item.
		    ' Handles image routing, WebLinks sub, kicks off validation.
		    ' --------------------------------------------------------
		  Case ST_PREPARE
		    If QueueUpTo >= QueueCount Then
		      DLState = ST_DONE
		      Return
		    End If
		    
		    ' Cancel/quit check - skip is responsive even before a download starts
		    If ForceQuit Then
		      DLState = ST_DONE 
		      Return
		    End If
		    If CancelDownloading Then
		      CancelDownloading = False
		      DLState = ST_ADVANCE
		      Return
		    End If
		    
		    ' Clean any leftover .partial from a previous failed attempt
		    If Exist(QueueLocal(QueueUpTo) + ".partial") Then Deltree(QueueLocal(QueueUpTo) + ".partial")
		    
		    GetURL = QueueURL(QueueUpTo)
		    
		    ' Route images to parallel async curl downloaders.
		    ' .jpg and .png each get their own Shell so they download simultaneously.
		    Select Case Right(GetURL, 4).Lowercase
		    Case ".jpg"
		      StartScreenshotDownload(GetURL, QueueLocal(QueueUpTo))
		      DLState = ST_ADVANCE
		      Return
		    Case ".png"
		      StartIconDownload(GetURL, QueueLocal(QueueUpTo))
		      DLState = ST_ADVANCE
		      Return
		    End Select
		    
		    ' WebLinks URL substitution (e.g. mirror overrides)
		    If WebLinksCount >= 1 Then
		      Dim LocalName As String = Replace(QueueLocal(QueueUpTo), Slash(RepositoryPathLocal), "")
		      Dim I As Integer
		      For I = 0 To WebLinksCount - 1
		        If WebLinksName(I) = LocalName Then
		          GetURL = WebLinksLink(I)
		          Exit For
		        End If
		      Next
		    End If
		    
		    ' Detect archive type for magic-byte validation
		    IsArchive = (GetURL.Lowercase.IndexOf(".apz") >= 0 Or _
		    GetURL.Lowercase.IndexOf(".pgz") >= 0 Or _
		    GetURL.Lowercase.IndexOf(".tar") >= 0)
		    
		    ' Check grep availability once per queue run
		    If Not GrepChecked Then
		      GrepChecked = True
		      If TargetWindows Then
		        GrepPath = Chr(34) + Slash(ToolPath) + "grep.exe" + Chr(34)
		        UseGrep = Exist(Slash(ToolPath) + "grep.exe")
		      Else
		        GrepPath = "grep"
		        Dim chk As New Shell
		        chk.Execute("which grep 2>/dev/null")
		        UseGrep = (chk.Result.Trim <> "")
		      End If
		    End If
		    
		    ' Kick off async validation shell
		    ValidationFallback = False
		    ValBuffer = ""
		    If ValShell Is Nil Then ValShell = New Shell
		    ValShell.TimeOut = -1
		    ValShell.ExecuteMode = Shell.ExecuteModes.Asynchronous
		    
		    If IsArchive And UseGrep Then
		      ' Path A: Magic-byte check (first 512 bytes)
		      ValShell.Execute("curl -sL -r 0-511 --connect-timeout 9 " + Chr(34) + GetURL + Chr(34) + _
		      " | LC_ALL=C " + GrepPath + " -aqP " + Chr(34) + "\x37\x7a\xbc\xaf|\x1f\x8b|ustar" + Chr(34))
		    Else
		      ' Path C: Standard HEAD check for .ini, .bat, non-archives etc.
		      ValShell.Execute("curl --head --silent --connect-timeout 9 " + Chr(34) + GetURL + Chr(34))
		    End If
		    
		    DLState = ST_VALIDATING
		    Return
		    
		    ' --------------------------------------------------------
		    ' VALIDATING: Poll async validation shell each tick.
		    ' Handles magic-byte, HEAD check, and HEAD fallback (Path B).
		    ' --------------------------------------------------------
		  Case ST_VALIDATING
		    ' Cancel/quit check - kill validation shell immediately
		    If ForceQuit Or CancelDownloading Then
		      If ValShell <> Nil And ValShell.IsRunning Then ValShell.Close
		      CancelDownloading = False
		      If ForceQuit Then 
		        DLState = ST_DONE
		        Return
		      End If
		      DLState = ST_ADVANCE 
		      Return
		    End If
		    
		    ' Drain output buffer each tick to prevent pipe deadlock
		    If ValShell <> Nil Then ValBuffer = ValBuffer + ValShell.ReadAll
		    
		    ' Not finished yet - come back next tick
		    If ValShell <> Nil And ValShell.IsRunning Then Return
		    
		    ' Shell finished - capture any final output
		    If ValShell <> Nil Then ValBuffer = ValBuffer + ValShell.ReadAll
		    
		    Dim Validated As Boolean = False
		    
		    If IsArchive And Not ValidationFallback Then
		      ' Magic-byte result: grep exit code 0 = correct bytes found
		      If ValShell <> Nil And ValShell.ExitCode = 0 Then
		        Validated = True
		      Else
		        ' Path B: Range request may have been rejected - try a HEAD fallback
		        If Debugging Then Debug("! Magic-byte check failed, trying HEAD fallback: " + GetURL)
		        ValidationFallback = True
		        ValBuffer = ""
		        ValShell = New Shell
		        ValShell.TimeOut = -1
		        ValShell.ExecuteMode = Shell.ExecuteModes.Asynchronous
		        ValShell.Execute("curl --head --silent --connect-timeout 9 " + Chr(34) + GetURL + Chr(34))
		        Return  ' Stay in ST_VALIDATING for the fallback
		      End If
		    Else
		      ' HEAD check result: non-empty, non-404 response = valid
		      Dim HeadResult As String = ValBuffer.Trim
		      If HeadResult <> "" And HeadResult.Left(18).IndexOf("404") = -1 And HeadResult.Left(18).IndexOf("000") = -1 Then
		        Validated = True
		        If ValidationFallback And Debugging Then Debug("! HEAD fallback passed: " + GetURL)
		      End If
		    End If
		    
		    If Not Validated Then
		      If Debugging Then Debug("* Validation Failed (404 or no response): " + GetURL)
		      SaveDataToFile("Failed Validation: " + GetURL, Slash(RepositoryPathLocal) + "FailedDownload")
		      DLState = ST_ADVANCE
		      Return
		    End If
		    
		    ' Validated - kick off the actual wget download
		    If Debugging Then Debug("Validated! Starting download: " + GetURL)
		    If Exist(Slash(RepositoryPathLocal) + "DownloadDone") Then Deltree(Slash(RepositoryPathLocal) + "DownloadDone")
		    
		    Dim Commands As String
		    If TargetWindows Then
		      Commands = WinWget + " --tries=6 --timeout=9 --progress=bar:force -O " + Chr(34) + QueueLocal(QueueUpTo) + ".partial" + Chr(34) + _
		      " " + Chr(34) + GetURL + Chr(34) + _
		      " 2>&1 && echo done > " + Chr(34) + Slash(RepositoryPathLocal) + "DownloadDone" + Chr(34)
		    Else
		      Commands = LinuxWget + " --tries=6 --timeout=9 --progress=bar:force -O " + _
		      Chr(34) + QueueLocal(QueueUpTo) + ".partial" + Chr(34) + " " + _
		      Chr(34) + GetURL + Chr(34) + " 2>&1 ; echo done > " + _
		      Chr(34) + Slash(RepositoryPathLocal) + "DownloadDone" + Chr(34)
		    End If
		    
		    If DLShell Is Nil Then DLShell = New Shell
		    DLShell.TimeOut = -1
		    DLShell.ExecuteMode = Shell.ExecuteModes.Asynchronous
		    DLShell.Execute(Commands)
		    DLState = ST_DOWNLOADING
		    Return
		    
		    ' --------------------------------------------------------
		    ' DOWNLOADING: Monitor wget progress, handle skip/cancel.
		    ' UI is fully responsive - Skip button works at any point.
		    ' --------------------------------------------------------
		  Case ST_DOWNLOADING
		    ' Skip/cancel: kill wget immediately and move on
		    If ForceQuit Or CancelDownloading Then
		      If DLShell <> Nil And DLShell.IsRunning Then DLShell.Close
		      If TargetWindows Then
		        If KillShell Is Nil Then KillShell = New Shell
		        KillShell.Execute("TaskKill /IM wget.exe /F")
		      End If
		      If Exist(QueueLocal(QueueUpTo) + ".partial") Then Deltree(QueueLocal(QueueUpTo) + ".partial")
		      If Exist(QueueLocal(QueueUpTo)) Then Deltree(QueueLocal(QueueUpTo))
		      CancelDownloading = False
		      DownloadPercentage = ""
		      If ForceQuit Then
		        DLState = ST_DONE 
		        Return
		      End If
		      DLState = ST_ADVANCE
		      Return
		    End If
		    
		    ' Drain wget output and extract progress percentage
		    If DLShell <> Nil Then
		      Dim theResults As String = DLShell.ReadAll
		      If theResults.Trim <> "" Then
		        theResults = theResults.ReplaceAll(Chr(13), Chr(10))
		        Dim lastPerc As Integer = InStrRev(theResults, "%")
		        If lastPerc > 3 Then
		          Dim pStart As Integer = lastPerc
		          While pStart > 1 And IsNumeric(Mid(theResults, pStart - 1, 1))
		            pStart = pStart - 1
		          Wend
		          Dim ProgPerc As String = Mid(theResults, pStart, lastPerc - pStart).Trim
		          ' Only accept the value if it looks like a genuine wget bar percentage.
		          ' wget --progress=bar:force always emits "NN%[" — the "[" immediately
		          ' follows the "%" and opens the bar graphic.  Any "%" from the verbose
		          ' connection/header output (Content-Type, URLs, etc.) will NOT have "["
		          ' right after it, so those false readings are safely ignored while real
		          ' values like 32% or 64% now show correctly again.
		          If IsNumeric(ProgPerc) And Mid(theResults, lastPerc + 1, 1) = "[" Then
		            DownloadPercentage = ProgPerc + "%"
		          End If
		        End If
		      End If
		    End If
		    
		    ' Update MiniInstaller / startup status text
		    If MiniInstallerShowing Then MiniInstaller.Stats.Text = "Downloading " + DownloadPercentage
		    If CheckingForUpdates Then UpdateLoading("Update: " + DownloadPercentage)
		    If CheckingForDatabases Then UpdateLoading("Database: " + DownloadPercentage)
		    
		    ' Check for done file (normal completion) or shell exited (error)
		    If Exist(Slash(RepositoryPathLocal) + "DownloadDone") Then
		      DLState = ST_FINALIZE
		      Return
		    End If
		    If DLShell <> Nil And Not DLShell.IsRunning Then
		      Dim trailing As String = DLShell.ReadAll  ' drain remaining buffer
		      DLState = ST_FINALIZE 
		      Return
		    End If
		    Return  ' Still running - come back next tick
		    
		    ' --------------------------------------------------------
		    ' FINALIZE: Rename .partial -> final filename.
		    ' --------------------------------------------------------
		  Case ST_FINALIZE
		    DownloadPercentage = ""
		    If Exist(QueueLocal(QueueUpTo) + ".partial") Then
		      If Exist(QueueLocal(QueueUpTo)) Then Deltree(QueueLocal(QueueUpTo))
		      If MoveShell Is Nil Then MoveShell = New Shell
		      If TargetWindows Then
		        Dim winSrc As String = QueueLocal(QueueUpTo).ReplaceAll("/", "\") + ".partial"
		        Dim winDest As String = QueueLocal(QueueUpTo).ReplaceAll("/", "\")
		        MoveShell.Execute("move /y " + Chr(34) + winSrc + Chr(34) + " " + Chr(34) + winDest + Chr(34))
		      Else
		        MoveShell.Execute("mv -f " + Chr(34) + QueueLocal(QueueUpTo) + ".partial" + Chr(34) + _
		        " " + Chr(34) + QueueLocal(QueueUpTo) + Chr(34))
		      End If
		      If Debugging Then Debug("Download successful: " + GetURL)
		      Deltree(Slash(RepositoryPathLocal) + "DownloadDone")
		    Else
		      ' .partial missing - wget exited without writing anything
		      If Debugging Then Debug("* Download error: .partial not found: " + GetURL)
		      SaveDataToFile("Failed Finding Local: " + QueueLocal(QueueUpTo) + ".partial", Slash(RepositoryPathLocal) + "FailedDownload")
		      If Not TargetWindows Then
		        Dim LocalName As String = Replace(QueueLocal(QueueUpTo), Slash(RepositoryPathLocal), "")
		        RunCommand("notify-send " + Chr(34) + "Failed Download: " + LocalName + Chr(34))
		      End If
		    End If
		    DLState = ST_ADVANCE
		    Return
		    
		    ' --------------------------------------------------------
		    ' ADVANCE: Step to the next queue item or finish.
		    ' --------------------------------------------------------
		  Case ST_ADVANCE
		    QueueUpTo = QueueUpTo + 1
		    If QueueUpTo < QueueCount Then
		      DLState = ST_PREPARE
		    Else
		      DLState = ST_DONE
		    End If
		    Return
		    
		    ' --------------------------------------------------------
		    ' DONE: Reset all state, turn off the timer.
		    ' --------------------------------------------------------
		  Case ST_DONE
		    QueueUpTo = 0
		    QueueCount = 0
		    Downloading = False
		    DownloadPercentage = ""
		    GrepChecked = False
		    DLState = ST_IDLE
		    DownloadTimer.RunMode = Timer.RunModes.Off  ' Stop polling until next GetOnlineFile call
		    If Exist(Slash(RepositoryPathLocal) + "DownloadDone") Then Deltree(Slash(RepositoryPathLocal) + "DownloadDone")
		    If ForceQuit Then
		      CleanTemp
		      DebugOutput.Flush
		      DebugOutput.Close
		      Quit
		      Return
		    End If
		    If Debugging Then Debug("--- Download State Machine: Done ---")
		    If Main.Visible = True And InstallingItem = False Then
		      ShowDownloadImages
		    End If
		    Return
		    
		  End Select
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events VeryFirstRunTimer
	#tag Event
		Sub Action()
		  Dim QuitNow As Boolean = False 'This allows multiple jobs to be done before it quits (useful for the command line arguments)
		  Dim OriginalStoreMode As Integer
		  Dim I As Integer
		  
		  App.AllowAutoQuit = True 'Makes it close if no windows are open
		  
		  If ForceQuit = True Then Return 'Don't bother even opening if set to quit
		  
		  If Keyboard.AsyncShiftKey Then ForceRefreshDBsShift = True
		  
		  If Keyboard.AsyncControlKey Then ForceNoOnlineDBUpdates = True
		  
		  VeryFirstRunTimer.RunMode = Timer.RunModes.Off ' Disable this timer again
		  
		  'Get Consts
		  If TargetLinux Then
		    SysDesktopEnvironment = System.EnvironmentVariable("XDG_SESSION_DESKTOP").Lowercase
		    If System.EnvironmentVariable("XDG_SESSION_TYPE").Lowercase.Trim = "wayland" Then Wayland = True
		    SysPackageManager = ""
		    SysTerminal = ""
		    ManualLocationsFile = "Linux"
		    
		    SaveDesktopEnvironment()
		    
		  Else
		    SysDesktopEnvironment = "explorer" 'Windows only uses Explorer
		    SysPackageManager = ""
		    SysTerminal = "cmd "
		    ManualLocationsFile = "Win"
		  End If
		  
		  SysAvailableDesktops = Array("All","All-Linux","Cinnamon","Explorer","Gnome","KDE","LXDE","Mate","Unity","XFCE","cosmic", "ubuntu","LXQt","budgie")
		  SysAvailablePackageManagers = Array("All","apt","apk","dnf","emerge","eopkg","pacman","pamac","winget","zypper")
		  SysAvailableArchitectures = Array("All","x86 + x64","x86","x64","ARM")
		  
		  Dim F, G As FolderItem
		  Dim TI As TextInputStream
		  Dim S, Path As String
		  Dim Success As Boolean
		  Dim Build As Boolean = False
		  Dim Compress As Boolean = False
		  
		  Randomiser = New Random 'This Randomizes the timer, to make it truely random
		  
		  'Some of my Shell calls use this for speed and less code, it waits for the command to complete before code continues though, so will tie up the main thread.
		  ShellFast = New Shell ' Just do this once to see if it speeds up loading using the one shell for 7z each time
		  ShellFast.TimeOut = -1 'Give it All the time it needs
		  
		  'Test Code here
		  
		  'If Exist ("C:\Budda Bing") Then Msgbox "Found 1"
		  'If Exist ("C:/Budda Bing") Then Msgbox "Found 2"
		  'If Exist ("C:\Budda Bing\") Then Msgbox "Found 3"
		  'If Exist ("C:/Budda Bing/") Then Msgbox "Found 4"
		  'If Exist ("C:\Budda Bing\Test.lnk") Then Msgbox "Found 5"
		  'If Exist ("C:/Budda Bing/Test.lnk") Then Msgbox "Found 6"
		  
		  'Quit
		  
		  'MakeFolderIcon("D:\Documents\Desktop\New folder","D:\Documents\Desktop\New folder\ppApp.ico")
		  '
		  'CreateShortcut ("Notepad",Chr(34)+"C:\windows\notepad.exe"+Chr(34),"C:\windows","D:\Documents\Desktop")
		  '
		  'Dim MyLink As Shortcut
		  '
		  'MyLink = GetShortcut("C:\Users\Public\Desktop\LL Store.lnk")
		  'MsgBox MyLink.TargetPath
		  
		  'Quit
		  
		  'Sudo Shell Loop waits forever to run Sudo Tasks without needing to type password constantly
		  SudoShellLoop = New Shell 'Keep the admin shell running /looping until you quit LLStore
		  SudoShellLoop.TimeOut = -1 'Give it All the time it needs
		  SudoShellLoop.ExecuteMode = Shell.ExecuteModes.Asynchronous ' Runs in background
		  
		  'Get App Paths
		  If TargetLinux Then
		    HomePath = Slash(FixPath(SpecialFolder.UserHome.NativePath))
		  Else
		    HomePath = Slash(FixPath(SpecialFolder.UserHome.NativePath))
		  End If
		  
		  CurrentPath =  FixPath(SpecialFolder.CurrentWorkingDirectory.NativePath)
		  
		  'Msgbox (App.ExecutableFile.Parent.NativePath)
		  
		  F = App.ExecutableFile.Parent
		  Do
		    If Exist(Slash(F.NativePath) + "Tools") Then
		      AppPath  = F.NativePath
		      LLStoreParent = NoSlash(F.Parent.NativePath)
		      If LLStoreParent = "/LastOS" Then LLStoreParent = "" 'Don't bother if it's the installed LLStore
		      If LLStoreParent = "C:\Program Files" Then LLStoreParent = "" 'Don't bother if it's the installed LLStore
		      'MsgBox LLStoreParent
		      Exit Do
		    End If
		    F = F.Parent
		    If F = Nil Then
		      If TargetWindows Then
		        G = GetFolderItem("C:\Windows\LLStore\LLStore.exe",FolderItem.PathTypeNative) 'Pretend path for now, might move it to be system wide tool in System32
		      Else
		        G = GetFolderItem("/bin/llfile",FolderItem.PathTypeNative) 'Hardcoded path, will exist on LastOS's
		      End If
		      If G.Exists Then 'Use LLFile path
		        AppPath = Slash(G.Parent.NativePath)
		        Exit Do 'Exit Loop
		      End If
		    End If
		  Loop
		  
		  If Exist (AppPath+"Tools") Then
		  Else
		    If TargetLinux Then
		      If Exist("/LastOS/LLStore/Tools") Then
		        AppPath = "/LastOS/LLStore/" 'Fall back to this version/path if I can't get the real path (due to using /bin/llfile etc)
		      Else
		        MsgBox "Can't find Tools path, Exiting"
		        Quit
		        Exit
		      End If
		    Else 'Windows
		      If Exist("C:\Program Files\LLStore\Tools") Then
		        AppPath = "C:\Program Files\LLStore\" 'Fall back to this version/path if I can't get the real path
		      Else
		        MsgBox "Can't find Tools path, Exiting"
		        Quit
		        Exit
		      End If
		    End If
		  End If
		  
		  If TargetLinux Then
		    'ShellFast.Execute("echo "+Chr(34)+AppPath+Chr(34) + " > "+Slash(HomePath)+"Desktop/Debugger2.txt")
		    MakeAllExec(AppPath)
		  End If
		  
		  BaseDir = HomePath+".llstore_secure"
		  'Make secure folder
		  if TargetWindows then
		    Path = Path.ReplaceAll("/","\")
		    S = "mkdir " + chr(34) + BaseDir + chr(34)
		    ShellFast.Execute (S)
		  Else
		    MakeFolder (BaseDir)
		    S = "chmod 700 "+BaseDir
		    ShellFast.Execute (S)
		  End If
		  
		  If TargetWindows Then 'Need to add Windows ppGames and Apps drives here
		    HomePath = Slash(FixPath(SpecialFolder.UserHome.NativePath))
		    RepositoryPathLocal = Slash(HomePath) + "zLastOSRepository/"
		    TmpPathBase = Slash(HomePath) + "LLTemp/"
		    RunUUID = Randomiser.InRange(100000000, 999999999).ToString + Randomiser.InRange(100000000, 999999999).ToString
		    TmpPath = TmpPathBase + RunUUID + "/"
		    
		    'C: for Defaults, only changes if one found to replace with
		    ppGames = "C:/ppGames/"
		    ppApps = "C:/ppApps/"
		    
		    'Get Default Paths
		    LLStoreDrive = Left (AppPath, 2)
		    SysProgramFiles = ReplaceAll(GetLongPath(System.EnvironmentVariable("PROGRAMFILES")), " (x86)", "")
		    SysDrive = Lowercase(System.EnvironmentVariable("SYSTEMDRIVE"))
		    SysRoot = GetLongPath(System.EnvironmentVariable("SYSTEMROOT"))
		    ToolPath = Slash(Slash(AppPath) +"Tools")
		  Else
		    HasLinuxSudo = True 'Default to true so it can call it
		    
		    HomePath = Slash(FixPath(SpecialFolder.UserHome.NativePath))
		    RepositoryPathLocal = Slash(HomePath) + "zLastOSRepository/"
		    TmpPathBase = Slash(HomePath) + ".lltemp/"
		    RunUUID = Randomiser.InRange(100000000, 999999999).ToString + Randomiser.InRange(100000000, 999999999).ToString
		    TmpPath = TmpPathBase + RunUUID + "/"
		    ppGames = Slash(HomePath)+".wine/drive_c/ppGames/"
		    ppApps = Slash(HomePath)+".wine/drive_c/ppApps/"
		    
		    'Get Default Paths
		    LLStoreDrive = "" 'Drive not used by linux
		    SysProgramFiles = "C:/Program Files/"
		    SysDrive = "C:"
		    SysRoot = "C:/Windows/"
		    ToolPath = Slash(Slash(AppPath) +"Tools")
		    
		    MakeAllExec(ToolPath)
		    
		    ShellFast.Execute(Chr(34)+Slash(AppPath)+"Tools/DefaultTerminal.sh"+Chr(34))
		    SysTerminal = ShellFast.Result
		    SysTerminal = SysTerminal.ReplaceAll(Chr(10),"")
		    SysTerminal = SysTerminal.ReplaceAll(Chr(13),"")
		    SysTerminal = SysTerminal.ReplaceAll(EndOfLine,"")
		  End If
		  
		  ' Clean up orphaned UUID temp folders from any crashed previous instances
		  If CleanTempFolders Then CleanOrphanTemps()
		  CleanTempFolders = False
		  
		  If TargetWindows Then
		    StartPathAll = Slash(FixPath(SpecialFolder.SharedApplicationData.NativePath)) + "Microsoft/Windows/Start Menu/Programs/" 'All Users
		    StartPathUser = Slash(FixPath(SpecialFolder.ApplicationData.NativePath)) + "Microsoft/Windows/Start Menu/Programs/" 'Current User
		  End If
		  
		  'Get MenuStyle and ppDrives
		  ControlPanel.PopulateControlPanel()
		  
		  'Get Startmenu Paths
		  BuildStartMenuLocations()
		  
		  
		  'Make All paths Linux, because they work in Linux and Windows (Except for Move, Copy and Deltree etc)
		  AppPath = AppPath.ReplaceAll("\","/")
		  ToolPath = ToolPath.ReplaceAll("\","/")
		  HomePath = HomePath.ReplaceAll("\","/")
		  RepositoryPathLocal = Slash(RepositoryPathLocal.ReplaceAll("\","/"))
		  TmpPath = TmpPath.ReplaceAll("\","/")
		  TmpPathBase = TmpPathBase.ReplaceAll("\","/")
		  ppGames = ppGames.ReplaceAll("\","/")
		  ppApps = ppApps.ReplaceAll("\","/")
		  SysProgramFiles = SysProgramFiles.ReplaceAll("\","/")
		  
		  ppAppsDrive = ppAppsDrive.ReplaceAll("\","/")
		  ppGamesDrive = ppGamesDrive.ReplaceAll("\","/")
		  
		  ppAppsFolder = ppAppsFolder.ReplaceAll("\","/")
		  ppGamesFolder = ppGamesFolder.ReplaceAll("\","/")
		  
		  LLStoreParent = LLStoreParent.ReplaceAll("\","/")
		  
		  'Set the folders
		  ppApps = ppAppsFolder
		  ppGames = ppGamesFolder
		  
		  Linux7z = Chr(34)+ToolPath + "7zzs"+Chr(34)
		  LinuxWget = Chr(34)+ToolPath + "wget"+Chr(34)
		  LinuxCurl = "curl" 'System curl is always in PATH on Linux
		  Win7z = Chr(34)+ToolPath + "7z.exe"+Chr(34) 'Added " to make it work in paths with spaces?
		  WinWget = Chr(34)+ToolPath + "wget.exe"+Chr(34) 'Added " to make it work in paths with spaces?
		  ' Windows 10+ ships curl.exe in System32 (in PATH). Prefer that so we don't need
		  ' to bundle it. Only fall back to our ToolPath copy if the system one is missing.
		  Dim curlCheckSh As New Shell
		  curlCheckSh.Execute("curl --version")
		  If curlCheckSh.ExitCode = 0 Then
		    WinCurl = "curl" 'System curl found (Windows 10+ built-in)
		  Else
		    WinCurl = Chr(34)+ToolPath + "curl.exe"+Chr(34) 'Fallback to bundled copy
		  End If
		  
		  'Clean Temp folders
		  CleanTemp 'Clearing LLTemp folder entirly
		  If Exist(Slash(RepositoryPathLocal) + "DownloadDone") Then Deltree (Slash(RepositoryPathLocal) + "DownloadDone")
		  
		  'Make Temp Folders (Can NOT use the one to make the temp path it uses to run as a script instead of using a shell. so manual here and below ones (they happen first and should fix the issue using it elsewhere)
		  if TargetWindows then
		    Path = Path.ReplaceAll("/","\")
		    S = "mkdir " + chr(34) + TmpPath + chr(34)
		    ShellFast.Execute (S)
		  Else
		    MakeFolder (TmpPath)
		  End If
		  
		  'Make sure paths exist (But only once per execution)
		  TmpPathItems = Slash(TmpPath)+"items/" 'Use Linux Paths for both OS's
		  if TargetWindows then
		    Path = Path.ReplaceAll("/","\")
		    S = "mkdir " + chr(34) + TmpPathItems + chr(34)
		    ShellFast.Execute (S)
		  Else
		    MakeFolder(TmpPathItems)
		  End If
		  
		  'Make Local paths and Debug File
		  #Pragma BreakOnExceptions Off
		  F = GetFolderItem(Slash(RepositoryPathLocal)+".lldb", FolderItem.PathTypeNative)
		  If Not F.Exists Then
		    Try 
		      MakeFolder(F.NativePath)
		    Catch
		    End Try
		  End If
		  
		  'Make sure temp paths and debug log is accessiable to all
		  if TargetLinux then
		    ChMod(Slash(RepositoryPathLocal), "-R 777")
		    ChMod(TmpPath, "-R 777")
		  End If
		  
		  'Enable Debugger
		  Try
		    DebugFileName = Slash(TmpPath)+"DebugLog"+Randomiser.InRange(10000, 20000).ToString+".txt"
		    DebugFile = GetFolderItem(DebugFileName, FolderItem.PathTypeNative)
		    If Exist(DebugFileName) Then
		      Deltree(DebugFileName)
		      DebugOutput = TextOutputStream.open(DebugFile)
		    Else
		      DebugOutput = TextOutputStream.Create(DebugFile)
		    end if
		    DebugFileOk = True
		  Catch
		    Debugging = False
		    DebugFileOk = False
		  End Try
		  
		  #Pragma BreakOnExceptions On
		  
		  'Set Default Settings, these get replaced by the loading of Settings, but we need defaults when there isn't one
		  Settings.SetFlatpakAsUser.Value = True
		  
		  'Centre Form
		  self.Left = (screen(0).AvailableWidth - self.Width) / 2
		  self.top = (screen(0).AvailableHeight - self.Height) / 2
		  
		  '========================================
		  ' Clean, simple and robust command line parsing
		  '========================================
		  
		  Var args() As String = System.CommandLine.Trim.Split(" ")
		  
		  'Reset defaults
		  StoreMode = 0
		  InstallArg = False
		  EditorOnly = False
		  Build = False
		  Compress = False
		  LoadPresetFile = False
		  InstallStore = False
		  KeepSudo = False
		  ForcePostQuit = False
		  Debugging = False
		  ForceOffline = False
		  SortMenuStyle = False
		  Regenerate = False
		  ContinueSelf = False
		  GetSize = False
		  EditingItem = False
		  
		  CommandLineFile = ""
		  
		  '----------------------------------------
		  ' Detect mode from executable name
		  '----------------------------------------
		  Var exeName As String = App.ExecutableFile.Name.Lowercase
		  
		  Select Case True
		  Case exeName.Contains("lllauncher")
		    StoreMode = 1
		    
		  Case exeName.Contains("llfile") Or exeName.Contains("llapp") Or exeName.Contains("llgame") Or exeName.Contains("llinstall")
		    StoreMode = 2
		    InstallArg = True
		    
		  Case exeName.Contains("lledit")
		    StoreMode = 3
		    EditorOnly = True
		  End Select
		  
		  '----------------------------------------
		  ' Parse command line arguments
		  '----------------------------------------
		  
		  CommandLineFile = ""
		  For I = 1 To args.LastIndex   ' <--- Skip element 0 (the calling app)
		    Var a As String = args(I).Trim
		    If a.Length = 1 And a.Asc <= 32 Then a = "" // Kill single-character junk
		    If a = "" Then Continue
		    
		    'If a.Trim = "Files\LLStore\llstore.exe"+Chr(34) Then a = ""
		    'If a.Trim = "Files\LLStore\llstore.exe" Then a = ""
		    
		    If a.trim.IndexOf("Files\LLStore\llstore.exe") >=0 Then a = ""
		    If a.trim.IndexOf("C:\Program") >=0 Then a = ""
		    If a.trim.IndexOf("C:\Program Files\LLStore\llstore.exe") >=0 Then a = ""
		    
		    If a = "" Then Continue
		    
		    If a.Left(1) = "-" Then
		      Select Case a.Lowercase
		        
		      Case "-launcher", "-l"
		        StoreMode = 1
		        
		      Case "-install", "-i"
		        StoreMode = 2
		        InstallArg = True
		        
		      Case "-continue"
		        ContinueSelf = True
		        
		      Case "-getsize"
		        GetSize = True
		        
		      Case "-edit", "-e"
		        StoreMode = 3
		        EditorOnly = True
		        
		      Case "-build", "-b"
		        StoreMode = 3
		        EditorOnly = True
		        Build = True
		        
		      Case "-compress", "-c"
		        StoreMode = 3
		        EditorOnly = True
		        Build = True
		        Compress = True
		        
		      Case "-preset", "-p"
		        StoreMode = 0
		        LoadPresetFile = True
		        
		      Case "-setup", "-s"
		        StoreMode = 4
		        InstallStore = True
		        
		      Case "-keepsudo", "-ks"
		        KeepSudo = True
		        
		      Case "-quit", "-q"
		        ForcePostQuit = True
		        
		      Case "-debug"
		        Debugging = True
		        
		      Case "-offline"
		        ForceOffline = True
		        
		      Case "-menustyle"
		        SortMenuStyle = True
		        StoreMode = 0
		        
		      Case "-regen"
		        Regenerate = True
		        StoreMode = 0
		      Case Else
		        If a <> "" Then CommandLineFile = CommandLineFile + " " + a
		        
		      End Select
		      
		    Else
		      'Anything that is not a flag is treated as a file/path
		      'If CommandLineFile = "" Then
		      'CommandLineFile = a 'Only do the first file, we can only do 1 at a time
		      If a <> "" Then CommandLineFile = CommandLineFile + " " + a
		      'End If
		    End If
		  Next
		  
		  '----------------------------------------
		  ' Final tidy-up
		  '----------------------------------------
		  If EditorOnly Then EditingItem = True
		  
		  'CommandLineFile = CommandLineFile.Trim
		  CommandLineFile = CleanCommandLineFile(CommandLineFile)
		  
		  If TargetWindows Then
		    CommandLineFile = CommandLineFile.ReplaceAll("/", "\")
		  Else
		    CommandLineFile = CommandLineFile.ReplaceAll("\", "/")
		  End If
		  
		  If LoadPresetFile Then
		    StoreMode = 0
		  End If
		  
		  
		  'Not Needed move out of GetTheme to here
		  ''Check if CommandLineFile is an actual file and switch to install mode by default, Need to do this here to reduce the occurance of Loading form being shown before it's time
		  'Select Case Right(CommandLineFile, 4)
		  'Case ".apz", ".pgz", ".app",".ppg",".tar",".lla",".llg"
		  'StoreMode = 2 ' This forces it to install ANY viable file regardless of how it's called' I was sick of Nemo etc removing the -i from the command.
		  'End Select
		  
		  Dim RL As String
		  
		  'Get theme
		  GetTheme
		  
		  'Nofications can not be called before here - The theme needs to be loaded in to show Graphics, else it'll just show text
		  'Notify ("This is a long test to see how it goes when you type a really really long status.")
		  
		  'Load Settings - (This is Where the Debugger is activated, else it's not writing until after here)
		  LoadSettings
		  
		  
		  'Get Shortcut Redirects - This has to be done except when in Launcher mode, so the installer has access to them!
		  GetCatalogRedirects 'May as well always do this, not needed for Storemode 1 - but what if you change modes? - wont hurt
		  
		  'See if BaseDir/stopLLStore exists and delete it if so
		  If TargetLinux Then
		    Try
		      If Exist(BaseDir+"/stopLLStore") Then Deltree(BaseDir+"/stopLLStore")
		    Catch
		    End Try
		  End If
		  
		  'Get Actual CommandLineFile File if only a Folder is given
		  If CommandLineFile <> "" Then
		    'Remove Quotes that get put on my Nemo etc (Not needed as I do it in CLeanCommandLineFile Function now)
		    'If Left(CommandLineFile,1) = Chr(34) Then CommandLineFile = CommandLineFile.ReplaceAll(Chr(34),"") 'Remove Quotes from given path entirly
		    
		    'Do I Need to convert ./ to $PWD etc - Yes, So if not / then it will use curent path
		    If TargetLinux Then
		      'If Not Exist (CommandLineFile) Then CommandLineFile = Slash(CurrentPath)+CommandLineFile
		      If Left (CommandLineFile,1) <> "/" Then CommandLineFile = Slash(CurrentPath)+CommandLineFile 'Make sure path is given
		    End If
		    
		    If IsFolder(CommandLineFile) Then
		      CommandLineFile = FixPath(Slash(CommandLineFile))
		      'Check for app files here, if only given the path to an item
		      If Exist (CommandLineFile+"LLApp.lla") Then CommandLineFile = CommandLineFile + "LLApp.lla"
		      If Exist (CommandLineFile+"LLGame.llg") Then CommandLineFile = CommandLineFile + "LLGame.llg"
		      If Exist (CommandLineFile+"ssApp.app") Then CommandLineFile = CommandLineFile + "ssApp.app"
		      If Exist (CommandLineFile+"ppApp.app") Then CommandLineFile = CommandLineFile + "ppApp.app"
		      If Exist (CommandLineFile+"ppGame.ppg") Then CommandLineFile = CommandLineFile + "ppGame.ppg"
		    End If
		  End If
		  
		  ''Clean CommandLineFile of EOL and spaces trailing and starting the file
		  '// This removes spaces, tabs, and all standard Line Endings (CR, LF, CRLF)
		  'CommandLineFile = CommandLineFile.Trim(" " + Chr(9) + Chr(20) + EndOfLine.Windows + EndOfLine.Unix + EndOfLine.Macintosh)
		  
		  CommandLineFile = CleanCommandLineFile(CommandLineFile)
		  
		  'Check if CommandLineFile is an actual file and switch to install mode by default
		  If Build = True Or Compress = True Or EditorOnly = True Then 'This fixes the issue of not compressing etc, installed them instead.
		  Else
		    If CommandLineFile <> "" Then
		      Select Case Right(CommandLineFile, 4)
		      Case ".apz", ".pgz", ".app",".ppg",".tar",".lla",".llg"
		        StoreMode = 2 ' This forces it to install ANY viable file regardless of how it's called' I was sick of Nemo etc removing the -i from the command.
		      End Select
		    End If
		  End If
		  
		  'If EditorOnly = True Then StoreMode = 3 ' Editor mode, even though the file above is a file, I never want the store or launcher to start
		  
		  'Get Package Manager
		  If TargetWindows Then
		    SysPackageManager = "winget"
		  Else
		    For I = 0 To SysAvailablePackageManagers.Count -1
		      ShellFast.Execute("type -P "+SysAvailablePackageManagers(I))
		      If ShellFast.Result <> "" Then
		        SysPackageManager = SysAvailablePackageManagers(I)
		        Exit ' Found It
		      End If
		    Next
		  End If
		  
		  'Get Systems Arch
		  SysArchitecture = "x64" 'Default
		  If TargetWindows Then
		    '%PROCESSOR_ARCHITEW6432% <- If I have issues change to this and if it's empty it's x86, not sure how it works on ARM yet though.
		    ShellFast.Execute("echo %PROCESSOR_ARCHITECTURE%")
		    If ShellFast.Result = "x86" Then SysArchitecture = "x86"
		    If ShellFast.Result.IndexOf("64") >= 0 Then SysArchitecture = "x64"
		    If Left(ShellFast.Result,3) = "arm" Then SysArchitecture = "ARM"
		  Else
		    ShellFast.Execute("uname -m")
		    If ShellFast.Result = "x86_64" Then SysArchitecture = "x64"
		    If Right(ShellFast.Result,2) = "86" Then SysArchitecture = "x86"
		    If Left(ShellFast.Result,3) = "arm" Then SysArchitecture = "ARM"
		  End If
		  
		  'Check if Online
		  AreWeOnline()
		  
		  If Debugging Then
		    Debug("--- Debugging Starts Here ---")
		    Debug("Store Version: v" + App.MajorVersion.ToString + "." + App.MinorVersion.ToString)
		    Debug("Store Mode: " + StoreMode.ToString)
		    Debug("Online Status: " + IsOnline.ToString)
		    Debug("AppPath: " + AppPath)
		    Debug("ToolPath: " + ToolPath)
		    Debug("TmpPath: " + TmpPath)
		    Debug("CurrentPath: " + CurrentPath)
		    Debug("RepositoryPathLocal: " + RepositoryPathLocal)
		    Debug("WinWget: " + WinWget)
		    Debug("LinuxWget: " + LinuxWget)
		    Debug("WinCurl: " + WinCurl)
		    Debug("LinuxCurl: " + LinuxCurl)
		    Debug("System Drive: " + SysDrive)
		    Debug("ppApps Drive: " + ppAppsDrive)
		    Debug("ppGames Drive: " + ppGamesDrive)
		    Debug("ppApps Path: " + ppApps)
		    Debug("ppGames Path: " + ppGames + Chr(10))
		    
		    Debug("MenuStyle: " + MenuStyle)
		    Debug("Architecture: " + SysArchitecture)
		    Debug("Desktop Environment: " + SysDesktopEnvironment)
		    Debug("Wayland: " + Wayland.ToString)
		    Debug("Package Manager: " + SysPackageManager)
		    Debug("Terminal: " + SysTerminal + Chr(10))
		    
		    Debug("Args: " + System.CommandLine)
		    Debug("CommandLineFile: >" + CommandLineFile + "<")
		    
		    // --- Fixed Hex Debugger Section ---
		    Var hexVersion As String = ""
		    Try
		      // Using MemoryBlock to see the raw bytes behind the string
		      Var mb As MemoryBlock = CommandLineFile
		      If mb <> Nil Then
		        For i  = 0 To mb.Size - 1
		          Var h As String = Hex(mb.Byte(i))
		          If h.Length = 1 Then h = "0" + h // Manual PadLeft
		          hexVersion = hexVersion + h.Uppercase + " "
		        Next
		      End If
		    Catch
		      hexVersion = "[Error generating Hex]"
		    End Try
		    Debug("CommandLineFile Hex: " + hexVersion.Trim)
		    // ----------------------------
		    
		    Debug("EditorOnly: " + EditorOnly.ToString + " Build: " + Build.ToString + " Compress: " + Compress.ToString)
		    Debug("LLStoreParent: " + LLStoreParent)
		  End If
		  
		  OriginalStoreMode = StoreMode ' Because I set it to hide main with 99, I use a backup of it
		  
		  'Move from FirstRunTimer to here
		  GetAdminMode
		  
		  If Debugging Then Debug("Admin Enabled: " + AdminEnabled.ToString)
		  
		  'Install Store Mode
		  If OriginalStoreMode = 4 Or InstallStore = True Then
		    Loading.Hide
		    InstallLLStore
		    'PreQuitApp ' Save Debug etc
		    'QuitApp 'Done installing, exit app, no need to continue
		    'Return ' Just get out of here once set to show editor
		    QuitNow = True
		  End If
		  
		  'Install Item Mode
		  If OriginalStoreMode = 2 Then
		    Loading.Hide
		    SudoAsNeeded = True 'As your only installing one item, there is no benefit to asking for SUDO if it isn't needed, so don't
		    InstallOnly = True
		    If Debugging Then Debug("--- Install From Commandline (PrepareToInstall phase) ---")
		    #Pragma BreakOnExceptions Off
		    If CommandLineFile <> "" Then
		      If Exist(CommandLineFile) Then
		        ' Phase 1: show notification with filename immediately so the Notification window
		        ' has a chance to draw BEFORE any archive extraction happens.
		        ' PrepareToInstall() fires several DoEvents cycles then returns True if file is valid.
		        If PrepareToInstall(CommandLineFile) Then
		          ' Phase 2 is kicked off by a one-shot timer (InstallTimer).
		          ' Returning here yields control back to the Xojo message loop so the OS
		          ' can composite and paint the Notification window before Installing() runs.
		          InstallTimer.RunMode = Timer.RunModes.Single
		          #Pragma BreakOnExceptions On
		          Return ' InstallTimer.Action handles the rest (install + quit)
		        End If
		      End If
		    End If
		    #Pragma BreakOnExceptions On
		    ' Only reached if file is missing or PrepareToInstall returned False — quit cleanly
		    QuitNow = True
		  End If
		  
		  'Editor Mode
		  If OriginalStoreMode = 3 Then
		    Loading.Hide
		    'MsgBox "Loading: " + CommandLineFile
		    #Pragma BreakOnExceptions Off
		    If CommandLineFile = "" Then
		      Editor.Left = (Screen(0).AvailableWidth/2) - (Editor.Width /2) 'Centered
		      Editor.Top = (Screen(0).AvailableHeight/2) - (Editor.Height /2)
		      Editor.PopulateData
		      Editor.Show
		    Else
		      Success = LoadLLFile(CommandLineFile) ', "", True) 'The true means it extracts all the file contents, we'll just update existing ones if open then saving instead of Extracting the big ones
		      If Success Then 
		        If Build = False Then
		          Editor.Left = (Screen(0).AvailableWidth/2) - (Editor.Width /2) 'Centered
		          Editor.Top = (Screen(0).AvailableHeight/2) - (Editor.Height /2)
		          Editor.PopulateData
		          Editor.Show
		        Else ' Just Build It
		          AutoBuild = True 'Set it to Auto Build and not show a message when complete
		          Editor.PopulateData
		          If GetSize = True Then 'Calculate Sizes
		            Editor.GetSizeOfItem
		          End If
		          If Compress = True Then Editor.CheckCompress.Value = True 'Set to Compress if it's in the Arguments
		          
		          ' Two-phase build — same pattern as PrepareToInstall/InstallTimer.
		          ' PrepareToBuild() shows the Notification and pumps the event loop
		          ' so Linux has time to composite the window before heavy work starts.
		          ' BuildTimer.Action() does the actual build after the message loop gets a turn.
		          PrepareToBuild()
		          BuildTimer.RunMode = Timer.RunModes.Single
		          Return ' Yield to message loop — BuildTimer.Action handles the rest
		        End If
		      Else 'Failed to load item, Show Editor
		        Editor.Left = (Screen(0).AvailableWidth/2) - (Editor.Width /2) 'Centered
		        Editor.Top = (Screen(0).AvailableHeight/2) - (Editor.Height /2)
		        Editor.PopulateData
		        Editor.Show
		      End If
		    End If
		    #Pragma BreakOnExceptions On
		    Return ' Just get out of here once set to show editor
		  End If
		  
		  'Set Flag if held shift on Startup o it will rescan for items
		  If ForceRefreshDBsShift = True Then
		    ForceRefreshDBs = True
		    ForceRefreshDBsShift = False ' Only do it the once
		  End If
		  
		  'Show Loading Screen here if the Store Mode is 0
		  If OriginalStoreMode = 0 Then 
		    If SortMenuStyle = False Then
		      Loading.Visible = True 'Show the loading form here
		    End If
		  End If
		  
		  'Check if Send To and Associations are applied (if store is installed)
		  If TargetWindows And OriginalStoreMode = 0 And AdminEnabled = True Then 'Only do as Admin so the File Associations work
		    Dim OutPath As String
		    Dim Target, TargetPath As String
		    'Make Shortcuts to SendTo and Start Menu
		    TargetPath = "C:\Program Files\LLStore"
		    Target = TargetPath +"\llstore.exe"
		    If Exist(Target) Then
		      OutPath = Slash(SpecialFolder.ApplicationData.NativePath).ReplaceAll("/","\") + "Microsoft\Windows\SendTo\"
		      If Not Exist(OutPath+"LL Install.lnk") Then 'Only make it if not already made as the Associate Filetypes can be slow
		        If Debugging Then Debug("Adding to Send To and Associating file types")
		        
		        'Send To
		        CreateShortcut("LL Install", Target, TargetPath, OutPath, "-i")
		        CreateShortcut("LL Edit", Target, TargetPath, OutPath, "-e", TargetPath +"\Themes\LLEdit.ico")
		        CreateShortcut("LL Edit (AutoBuild Archive)", Target, TargetPath, OutPath, "-c", TargetPath +"\Themes\LLEdit.ico")
		        CreateShortcut("LL Edit (AutoBuild Folder)", Target, TargetPath, OutPath, "-b", TargetPath +"\Themes\LLEdit.ico")
		        
		        'Make .apz, .pgz, .app and .ppg associations. Only works as Admin
		        MakeFileType("LLStore", "apz pgz app ppg", "LLStore File", Target, TargetPath, Target, "-i ") '2nd Target is the icon, The -i allows it to install default
		      Else
		        If Debugging Then Debug("Send To and Associated file types already applied")
		      End If
		    End If
		  End If
		  
		  'SortMenuStyle - Just sort menu and Exit
		  If SortMenuStyle = True Then
		    If TargetWindows Then
		      If ControlPanel.ComboMenuStyle.RowCount >= 1 Then
		        For I = 0 To ControlPanel.ComboMenuStyle.RowCount -1
		          If ControlPanel.ComboMenuStyle.RowTextAt(I) = CommandLineFile Then
		            Loading.Hide
		            Notify ("LLStore Installing Menu Style", "Installing Menu Style: "+CommandLineFile, "", -1) 'Mini Installer can't call this and wouldn't want to.
		            ControlPanel.ComboMenuStyle.Text = CommandLineFile
		            If ControlPanel.SetPressed() Then' Do the Task
		            End If
		            Exit
		          End If
		        Next
		        PreQuitApp ' Save Debug etc
		        QuitApp 'Done installing, exit app, no need to continue
		        Return ' Just get out of here once set to show editor
		      End If
		    Else ' Linux
		      Loading.Hide
		      Notify ("LLStore Installing Menu Style", "Installing Menu Style: Linux", "", -1) 'Mini Installer can't call this and wouldn't want to.
		      InstallLinuxMenuSorting(False)
		      QuitNow = True
		    End If
		  End If
		  
		  'Regenerate pp Items
		  If Regenerate = True Then
		    Loading.Hide
		    Notify ("LLStore Regenerating Items", "Regenerating LL/pp Apps/Games", "", -1) 'Mini Installer can't call this and wouldn't want to.
		    App.DoEvents(1)'Refresh Things
		    ControlPanel.RegenerateItems()
		    QuitNow = True
		  End If
		  
		  
		  
		  '--------------- Quit if done jobs above ---------------
		  
		  If QuitNow = True Then
		    PreQuitApp ' Save Debug etc
		    QuitApp 'Done installing, exit app, no need to continue
		    Return ' Just get out of here once set to show editor
		  End If
		  'Using a timer at the end of Form open allows it to display, many events hold off other processes until the complete
		  If StoreMode <=1 Then FirstRunTime.RunMode = Timer.RunModes.Single ' Only show the store in Installer or Launcher modes, else just quit?
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events QuitCheckTimer
	#tag Event
		Sub Action()
		  If ForceQuit = True Then
		    If EditorOnly Then 
		      PreQuitApp
		      QuitApp
		    End If
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DownloadScreenAndIcon
	#tag Event
		Sub Action()
		  ' Poll both curl shells independently.
		  ' Each calls ShowDownloadImages the moment its shell finishes - no fixed wait.
		  ' Timer shuts itself off once both shells are done (or were never started).
		  Var AnyRunning As Boolean = False
		  
		  If ShellScreenshot <> Nil Then
		    If ShellScreenshot.IsRunning Then
		      AnyRunning = True
		    Else
		      ShellScreenshot = Nil
		      If Main.Visible And Not InstallingItem Then ShowDownloadImages
		    End If
		  End If
		  
		  If ShellIcon <> Nil Then
		    If ShellIcon.IsRunning Then
		      AnyRunning = True
		    Else
		      ShellIcon = Nil
		      If Main.Visible And Not InstallingItem Then ShowDownloadImages
		    End If
		  End If
		  
		  If Not AnyRunning Then
		    DownloadScreenAndIcon.RunMode = Timer.RunModes.Off
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events InstallTimer
	#tag Event
		Sub Action()
		  ' Phase 2 of the two-phase CommandLine install (StoreMode=2).
		  ' PrepareToInstall() already showed the notification and returned.
		  ' The message loop had a full 120ms to draw before we got here.
		  
		  InstallTimer.RunMode = Timer.RunModes.Off ' Fire once only
		  
		  If CommandLineFile = "" Then
		    PreQuitApp
		    QuitApp
		    Return
		  End If
		  
		  If Debugging Then Debug("--- InstallTimer fired — calling Installing() ---")
		  
		  Dim Success As Boolean
		  #Pragma BreakOnExceptions Off
		  If Exist(CommandLineFile) Then
		    Success = Installing(CommandLineFile)
		    If Success Then
		      If Debugging Then Debug("Installing() success: " + CommandLineFile)
		    Else
		      If Debugging Then Debug("* Installing() failed: " + CommandLineFile)
		    End If
		  End If
		  #Pragma BreakOnExceptions On
		  
		  ' Post-install housekeeping (mirrors what VeryFirstRunTimer.Action used to do)
		  If Not TargetWindows Then
		    If SudoEnabled = True Then
		      SudoEnabled = False
		      If KeepSudo = False Then ShellFast.Execute("echo " + Chr(34) + "Unlock" + Chr(34) + " > "+BaseDir+"/LLSudoDone")
		    End If
		    
		    If RunRefreshScript = True Or ForceDERefresh = True Then RunRefresh("cinnamon -r&")
		    
		    If SysDesktopEnvironment = "kde" Or SysDesktopEnvironment = "KDE" Then
		      If RunRefreshScript = True Or ForceDERefresh = True Then
		        ForceDERefresh = False
		        RunRefresh("kquitapp plasmashell && plasmashell&")
		      End If
		    End If
		  End If
		  
		  PreQuitApp
		  QuitApp
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BuildTimer
	#tag Event
		Sub Action()
		  ' Phase 2 of the two-phase build.
		  ' PrepareToBuild() already showed the Notification and returned.
		  ' The message loop had a full 120ms to draw before we got here.
		  
		  BuildTimer.RunMode = Timer.RunModes.Off ' Fire once only
		  
		  If Debugging Then Debug("--- BuildTimer fired — calling BuildLLFile() ---")
		  
		  #Pragma BreakOnExceptions Off
		  Editor.BuildLLFile()
		  #Pragma BreakOnExceptions On
		  
		  ' Post-build: quit (CLI/AutoBuild), re-show Editor (context-menu build), or restore Main (normal build)
		  If AutoBuild Then
		    ' CLI / command-line build — quit when done
		    PreQuitApp
		    QuitApp
		  ElseIf EditorOnly Then
		    ' Opened via context menu — keep app running, put the Editor back
		    Editor.Show
		  Else
		    ' Normal GUI flow — Editor and Main were hidden for the build; restore Main
		    Editor.Hide
		    Editor.Close
		    If StoreMode <> 99 Then Main.Show
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
	#tag ViewProperty
		Name="Regenerate"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="SortMenuStyle"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
