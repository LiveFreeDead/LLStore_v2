#tag Module
Protected Module LLMod
	#tag Method, Flags = &h0
		Sub BuildMenuStyleFolder()
		  '-------------- New Method uses BuildStartMenuLocations ------------------
		  
		  Dim I As Integer
		  Dim MenuPath As String = "C:\Windows\ssTek\Menu\"
		  Dim MakeFolderBatch As String
		  Dim DesktopIni As String
		  
		  Dim DataOut As String
		  
		  If StartMenuLocationsCount(StartMenuUsed) <=0 Then Return 'Failed, just exit or assume no menu sorting
		  
		  'MsgBox "Starting Menu Folders"
		  
		  'Clear Old one
		  Deltree (MenuPath)
		  
		  MakeFolderBatch = ""
		  For I = 0 To StartMenuLocationsCount(StartMenuUsed)
		    If Not Exist(MenuPath+StartMenuLocations(I,StartMenuUsed).Path) Then
		      MakeFolderBatch = MakeFolderBatch + "mkdir "+Chr(34)+MenuPath+StartMenuLocations(I,StartMenuUsed).Path+Chr(34)+Chr(10)
		    End If
		  Next
		  
		  RunCommand(MakeFolderBatch) 'Make all folders at once - much faster
		  
		  'MsgBox "Start Desktop.ini"
		  
		  'Reusing the same Variable to store the attrib Commands
		  MakeFolderBatch = ""
		  
		  For I = 0 To StartMenuLocationsCount(StartMenuUsed) 'Now go thorugh and make sure desktop.ini files are made
		    If MenuPath+StartMenuLocations(I,StartMenuUsed).IconFile <> "" And MenuPath+StartMenuLocations(I,StartMenuUsed).IconIndex <> "" Then
		      'Generate desktop.ini for the folders
		      MakePathIcon (MenuPath+StartMenuLocations(I,StartMenuUsed).Path, StartMenuLocations(I,StartMenuUsed).IconFile, StartMenuLocations(I,StartMenuUsed).IconIndex, True) 'The True is Make Command to Return Only
		      
		      If StartMenuLocations(I,StartMenuUsed).Path.IndexOf("Startup") >=0 Then 'Make Startup folder have it's Icon always, it doesn't get new items added very often
		        MakePathIcon (StartPathAll+StartMenuLocations(I,StartMenuUsed).Path, StartMenuLocations(I,StartMenuUsed).IconFile, StartMenuLocations(I,StartMenuUsed).IconIndex, True) 'The True is Make Command to Return Only
		        MakePathIcon (StartPathUser+StartMenuLocations(I,StartMenuUsed).Path, StartMenuLocations(I,StartMenuUsed).IconFile, StartMenuLocations(I,StartMenuUsed).IconIndex, True)
		        ShellFast.Execute("attrib "+Chr(34)+StartPathAll+"Startup\desktop.ini"+Chr(34)+" +h +s") 'Ini is hidden and system so doesn't open the ini on startup 'enforced
		        ShellFast.Execute("attrib "+Chr(34)+StartPathUser+"Startup\desktop.ini"+Chr(34)+" +h +s") 'Ini is hidden and system so doesn't open the ini on startup 'enforced
		      End If
		      
		      
		      MakeFolderBatch = MakeFolderBatch + CommandReturned + Chr(10)
		      
		      'MsgBox CommandReturned
		      
		      'DataOut = DataOut + MenuPath+StartMenuLocations(I).Path+" > "+StartMenuLocations(I).IconFile+" > "+StartMenuLocations(I).IconIndex+Chr(10)
		    End If
		  Next
		  
		  RunCommand(MakeFolderBatch) 'Attrib all folders and desktop.ini files at once - much faster
		  
		  'MsgBox MakeFolderBatch
		  
		  'SaveDataToFile (DataOut, SpecialFolder.Desktop.NativePath+"\TestOutputs.txt")
		  
		  'MsgBox "Done Desktop.ini"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BuildStartMenuLocations()
		  'This will Populate a Menu Style Array of Catalogs, Paths and Icons
		  
		  Dim MenuPath As String
		  Dim DefinitionsFile As String
		  
		  'If Exist("C:\Windows\ssTek\Definitions.ini") Then 'If one provided, then parse it, else use the LL Store Tools path ones
		  'DefinitionsFile = "C:\Windows\ssTek\Definitions.ini"
		  'Else
		  'MenuPath = Slash(Slash(ToolPath)+ Slash("Menus")+MenuStyle+"Menu")
		  'DefinitionsFile = MenuPath+"Definitions.ini"
		  'End If
		  
		  ''Clear Existing Count
		  'StartMenuStylesCount = 0
		  
		  Dim I, J, K, L As Integer
		  Dim DataIn As String
		  Dim CatMode As Boolean = False
		  Dim CatModeDone As Boolean = False
		  Dim DesktopMode As Boolean = False
		  Dim Sp() As String
		  Dim SpLine() As String
		  Dim StartMenuPath As String
		  Dim DetectedItem As Integer
		  Dim IconFile As String
		  Dim IconIndex As String
		  Dim LoadMenuStyleName As String
		  
		  'Get Menu Styles Count and Current Menu Style Number
		  'For L = 0 To ControlPanel.ComboMenuStyle.RowCount - 1
		  'LoadMenuStyleName = ControlPanel.ComboMenuStyle.RowTextAt(L)
		  '
		  'MenuPath = Slash(Slash(ToolPath)+ Slash("Menus")+LoadMenuStyleName+"Menu")
		  'DefinitionsFile = MenuPath+"Definitions.ini"
		  
		  For K = 0 To StartMenuStylesCount 'Styles Count is done in Populate Control Panel
		    
		    LoadMenuStyleName = StartMenuStyles(K)
		    MenuPath = Slash(Slash(ToolPath)+ Slash("Menus")+LoadMenuStyleName+"Menu")
		    DefinitionsFile = MenuPath+"Definitions.ini"
		    
		    'StartMenuLocations(StartMenuLocationsCount(K),K).MenuName = LoadMenuStyleName 'Store name of Menu
		    StartMenuStyles(K) = LoadMenuStyleName 'Store name of Menu
		    'If StartMenuLocations(StartMenuLocationsCount(K),K).MenuName = MenuStyle Then StartMenuUsed = K 'Gets the current Menu Style Number
		    If LoadMenuStyleName = MenuStyle Then StartMenuUsed = K 'Gets the current Menu Style Number
		    
		    'Clear Existing Count
		    StartMenuLocationsCount(K) = 0
		    CatMode = False
		    CatModeDone = False
		    DesktopMode = False
		    
		    'MsgBox DefinitionsFile
		    If Exist(DefinitionsFile) Then 'If one provided, then parse it
		      'MsgBox "Loading"
		      DataIn = LoadDataFromFile(DefinitionsFile)
		      DataIn = DataIn.ReplaceAll(Chr(13), Chr(10))
		      DataIn = DataIn.ReplaceAll(Chr(10)+Chr(10),Chr(10))
		      Sp() = DataIn.Split(Chr(10))
		      
		      If Sp.Count >=1 Then 'If Valid, do it
		        For I = 0 To Sp.Count -1
		          Sp(I) = Sp(I).Trim
		          If Sp(I).IndexOf("=") >=0 Then 'Only do Valid converstions for all lines - regardless of mode
		            SpLine() = Sp(I).Split("=") 'Split to 0 as Catalog and 1 as Start Path Used, or IconFile/IconIndex and values
		            ' Ensure we have at least 2 elements
		            If SpLine.Count >= 2 Then
		              SpLine(0)=SpLine(0).Trim 'Catalog, IconFile/IconIndex
		              SpLine(1)=SpLine(1).Trim 'Start Path, Value
		              
		              If CatMode = True Then 'Only process when it's below the right Header
		                If Left(SpLine(0),1)="!" Then ' Skip It because it's only a redirect, not used here
		                  Continue
		                End If
		                
		                StartMenuLocations(StartMenuLocationsCount(K),K).Catalog = SpLine(0)
		                StartMenuLocations(StartMenuLocationsCount(K),K).Path = SpLine(1)
		                StartMenuLocationsCount(K) = StartMenuLocationsCount(K) + 1
		                
		              End If
		            End If
		          End If
		          
		          If DesktopMode = True Then 'Get Icon file and index's
		            If DetectedItem >= 1 Then 'Only do Valid items
		              
		              If SpLine(0) = "IconFile" Then IconFile = SpLine(1) 'Set Icon File to go through the list of known paths to attach it to (Duplicate paths but different Categories)
		              
		              If SpLine(0) = "IconIndex" Then 'Once the Index is read in we can apply it to the matched location.
		                IconIndex = SpLine(1) 'Set IconIndex
		                'DetectedItem already holds the exact index of the matching entry — use it directly
		                'rather than scanning all entries again. If multiple catalog entries share the same
		                'path (which would need the loop), add a comment here explaining that case.
		                StartMenuLocations(DetectedItem, K).IconFile = IconFile
		                StartMenuLocations(DetectedItem, K).IconIndex = IconIndex
		              End If
		            End If
		            
		          End If
		          
		          If Left(Sp(I).Trim,1) = "[" Then
		            If CatMode = True Then
		              DesktopMode = True ' Can only process once cats and header is passed
		              CatModeDone = True
		            End If
		            CatMode = False 'Revert to not CatMode if detected new header
		            
		            StartMenuPath = Sp(I).Trim.Replace("[","")
		            StartMenuPath = StartMenuPath.Replace("]","")
		            
		            'Seek the Matching StartPath to attach the icon to
		            DetectedItem = -1
		            If CatModeDone = True Then 'Only Add New items once past Header and Catalog setions
		              For J = 1 To StartMenuLocationsCount(K)
		                If StartMenuLocations(J, K).Path = StartMenuPath Then
		                  DetectedItem = J
		                  Exit 'Found item, no need to re add it or keep looking
		                End If
		              Next J
		              If DetectedItem <=0 Then 'Add new Item as root folder option
		                StartMenuLocationsCount(K) = StartMenuLocationsCount(K) + 1 'Don't make it 0 Based, Start at 1
		                StartMenuLocations(StartMenuLocationsCount(K), K).Catalog = StartMenuPath
		                StartMenuLocations(StartMenuLocationsCount(K), K).Path = StartMenuPath
		                DetectedItem = StartMenuLocationsCount(K) 'Newly added item
		              End If
		              
		            End If
		          End If
		          If Sp(I).Trim = "[Catalog]" Then CatMode = True
		        Next
		        
		        'Redo loop to get redirects
		        For I = 0 To Sp.Count -1
		          
		          If Left(Sp(I),1)="!" Then
		            
		            If Sp(I).IndexOf("=") >=0 Then 'Only do Valid converstions for all lines - regardless of mode
		              SpLine() = Sp(I).Split("=") 'Split to 0 as Catalog and 1 as Start Path Used, or IconFile/IconIndex and values
		              ' Ensure we have at least 2 elements
		              If SpLine.Count >= 2 Then
		                SpLine(0)=Right(SpLine(0).Trim, Len(SpLine(0).Trim)-1) 'Catalog, IconFile/IconIndex, remove ! from start
		                SpLine(1)=SpLine(1).Trim 'Start Path, Value
		              End If
		            End If
		            If SpLine.Count <= 1 Then Continue 'If only one or less, skip this as otherwise it's a dud entry
		            
		            'MsgBox SpLine(0)+"="+SpLine(1)
		            
		            'Redirect Category to existing path/icon
		            DetectedItem = -1
		            For J = 1 To StartMenuLocationsCount(K)
		              If SpLine(1) = StartMenuLocations(J, K).Catalog Then 'SpLine(1) Is the Corrected Category, so if that matches then it should be the right one to use
		                'If StartMenuLocations(I, K).Catalog = StartMenuLocations(J, K).Catalog Then
		                DetectedItem = J
		                Exit 'Found item, no need to re add it or keep looking
		              End If
		            Next J
		            If DetectedItem >=1 Then 'Add new Item as root folder option
		              
		              StartMenuLocations(StartMenuLocationsCount(K),K).Catalog = SpLine(0)'StartMenuLocations(DetectedItem, K).Catalog
		              StartMenuLocations(StartMenuLocationsCount(K),K).Path = StartMenuLocations(DetectedItem, K).Path
		              StartMenuLocations(StartMenuLocationsCount(K),K).IconFile = StartMenuLocations(DetectedItem, K).IconFile
		              StartMenuLocations(StartMenuLocationsCount(K),K).IconIndex = StartMenuLocations(DetectedItem, K).IconIndex
		              StartMenuLocationsCount(K) = StartMenuLocationsCount(K) + 1
		              
		            End If
		            
		          End If
		        Next I
		        
		        StartMenuLocationsCount(K) = StartMenuLocationsCount(K) - 1 'One Less as it's empty for last item
		      End If
		    End If
		  Next K
		  
		  'Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChDirSet(myPath As String) As Boolean
		  Dim err As Integer
		  Dim Success As Boolean
		  
		  MyPath = NoSlash(MyPath) 'Remove trailing Slash
		  
		  #If TargetMachO
		    Const chdirLib = "System.framework"
		    Soft Declare Function chdir Lib chdirLib (path As CString) As Integer
		    
		    Dim myPath As String = "/tmp/"
		    
		    err = chdir(myPath)
		    Success = True
		    If Not err = 0 Then
		      System.DebugLog("ERROR " + Str(err))
		      Success = False
		    End
		    
		  #ElseIf TargetLinux
		    Const chdirLib = "libc"
		    Soft Declare Function chdir Lib chdirLib (path As CString) As Integer
		    
		    err = chdir(myPath)
		    Success = True
		    If Not err = 0 Then
		      Success = False
		      System.DebugLog("ERROR " + Str(err))
		    End
		    
		  #ElseIf TargetWin32
		    Soft Declare Function SetCurrentDirectoryA Lib "Kernel32" ( dir As CString ) As Boolean 'x86
		    Soft Declare Function SetCurrentDirectoryW Lib "Kernel32" ( dir As WString ) As Boolean 'x64
		    
		    'Set the directory
		    If System.IsFunctionAvailable( "SetCurrentDirectoryW", "Kernel32" ) Then
		      Success = SetCurrentDirectoryW( myPath ) 'Use Unicode variant when available
		    Else
		      Success = SetCurrentDirectoryA( myPath ) 'Fallback to ANSI on older systems
		    End If
		  #EndIf
		  
		  If Debugging Then Debug("ChDirSet: "+myPath)
		  
		  Return Success
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChMod(FileIn As String, Codes As String)
		  ShellFast.Execute("chmod "+Codes+" "+Chr(34)+FileIn+Chr(34))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChModSudo(FileIn As String, Codes As String)
		  RunSudo ("chmod "+Codes+" "+Chr(34)+FileIn+Chr(34))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CleanCommandLineFile(f As String) As String
		  If f = "" Then Return ""
		  
		  // 1. Force UTF8
		  Var clean As String = DefineEncoding(f, Encodings.UTF8)
		  
		  // 2. Peel Quotes first
		  clean = clean.ReplaceAll(Chr(34), "")
		  
		  // 3. Manual "Peel" Loop 
		  // This looks at the Byte value of the first and last characters.
		  // It removes anything ASCII 32 or below, plus the common invisible Chr(160)
		  Var changed As Boolean
		  Do
		    changed = False
		    If clean.Length > 0 Then
		      Var first As Integer = clean.Left(1).Asc
		      Var last As Integer = clean.Right(1).Asc
		      
		      // Remove if it's a Control Char, Space (32), or NBSP (160)
		      If first <= 32 Or first = 160 Or first = 20 Then
		        clean = clean.Middle(1)
		        changed = True
		      End If
		      
		      If clean.Length > 0 And (last <= 32 Or last = 160 Or last = 20) Then
		        clean = clean.Left(clean.Length - 1)
		        changed = True
		      End If
		    End If
		  Loop Until Not changed Or clean.Length = 0
		  
		  Return clean
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CleanTemp()
		  If Debugging Then Debug("--- Starting Clean Temp ---")
		  
		  If TmpPath <> "" Then
		    If Exist(TmpPath) Then
		      
		      Deltree(Slash(TmpPath)+"items")
		      Deltree(DebugFileName) 'Delete the Log file from Temp, will be copied out by now
		      Deltree(TmpPath) 'Remove this instance's UUID temp folder on exit
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CompPath(PathIn As String, SkipAppPath As Boolean = False) As String
		  'If Debugging Then Debug("CompPath: " + PathIn) 'This gets called a lot, don't need to debug it for now, may adjust when it gets called depending on the Column Header
		  
		  If SkipAppPath =False Then
		    PathIn = PathIn.ReplaceAll(ItemLLItem.PathApp.ReplaceAll("\","/"),"%AppPath%") ' Convert Windows paths to Linux paths, makes the DB cross platform compatible
		    PathIn = PathIn.ReplaceAll(ItemLLItem.PathINI.ReplaceAll("\","/"),"%INIPath%")
		  End If
		  
		  PathIn = PathIn.ReplaceAll(Slash(HomePath)+"LLGames", "%LLGames%")
		  PathIn = PathIn.ReplaceAll(Slash(HomePath)+"LLApps", "%LLApps%")
		  
		  PathIn = PathIn.ReplaceAll(NoSlash(ppGames.ReplaceAll("\","/")),"%ppGames%") 'This should fix the path not working right for ppGames and Apps
		  PathIn = PathIn.ReplaceAll(NoSlash(ppApps.ReplaceAll("\","/")), "%ppApps%")
		  
		  If TargetWindows Then
		    
		    PathIn = PathIn.ReplaceAll("C:\Program File (x86)","%ProgramFiles(x86)%")
		    PathIn = PathIn.ReplaceAll("C:\Program File", "%ProgramFiles%")
		    
		    PathIn = PathIn.ReplaceAll("C:/Program File (x86)","%ProgramFiles(x86)%")
		    PathIn = PathIn.ReplaceAll("C:/Program File", "%ProgramFiles%")
		    
		    PathIn = PathIn.ReplaceAll(Left(ppGames,2),"%ppGamesDrive%")
		    PathIn = PathIn.ReplaceAll(Left(ppApps,2),"%ppAppsDrive%")
		    PathIn = PathIn.ReplaceAll(Win7z,"%Extract%")
		  Else
		    
		    PathIn = PathIn.ReplaceAll(HomePath +  "/.wine/drive_c/Program Files (x86)","%ProgramFiles(x86)%")
		    PathIn = PathIn.ReplaceAll(HomePath +  "/.wine/drive_c/Program Files", "%ProgramFiles%")
		    
		    PathIn = PathIn.ReplaceAll(HomePath +  "/.wine/drive_c","%ppGamesDrive%")
		    PathIn = PathIn.ReplaceAll(HomePath +  "/.wine/drive_c", "%ppAppsDrive%")
		    PathIn = PathIn.ReplaceAll(Win7z,"%Extract%") 'This is only used by Wine Scripts, I'll make another method for Linux
		  End If
		  
		  'Do This Last so can conver subpaths above first
		  PathIn = PathIn.ReplaceAll(NoSlash(HomePath), "$HOME")
		  
		  Return PathIn
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Copy(FileIn As String, FileOut As String) As Boolean
		  If Debugging Then Debug("Copy "+ FileIn +" To " + FileOut)
		  If FileIn = FileOut Then Return True 'Do not run if it's the same as it will delete it below and we don't want that
		  'I may update this routune to new methods, but works for now using Xojo method - Glenn
		  
		  Dim F, G As FolderItem
		  
		  If Exist(FileIn) Then
		    #Pragma BreakOnExceptions Off
		    Try
		      F=GetFolderItem(FileIn, FolderItem.PathTypeNative)
		      'If Not F.Parent.Exists Then MakeFolder(F.Parent.NativePath) ' Make sure folder exists before copying to it??? To it or from it 'The folder should already exist
		      
		      G=GetFolderItem(FileOut, FolderItem.PathTypeNative)
		      'MakeFolder(G.Parent.NativePath) 'Makes sure the output path parent exists before trying to copy to it. 'leaving this out for now, causes issues with Try Catch, if access denied
		      If G.Exists And G.IsWriteable Then G.Remove
		      
		      'If Debugging Then Debug("Attempting copy: "+ F.NativePath +" To " + G.NativePath)
		      
		      F.CopyTo(G)
		      
		    Catch
		      If Debugging Then Debug("Failed to copy: "+F.NativePath+" to "+G.NativePath)
		      Return False
		    End Try
		    #Pragma BreakOnExceptions On
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyWild(FilesIn As String, FolderOut As String)
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = -1 'Give it All the time it needs
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim Command As String
		  Dim FolderIn As String
		  
		  If TargetWindows Then
		    '''Command = "xcopy "+Chr(34)+FilesIn+Chr(34)+" "+Chr(34)+FolderOut+Chr(34)
		    'xcopy requires backslashes, not forward slashes
		    XCopyFile(FilesIn.ReplaceAll("/","\"), FolderOut.ReplaceAll("/","\"))
		  Else
		    'Command = "cp -r "+Chr(34)+FilesIn+Chr(34)+" "+Chr(34)+FolderOut+Chr(34)
		    FolderIn = Left(FilesIn, InStrRev(FilesIn,"/")-1)    'Len(FilesIn) - 
		    FilesIn = Right(FilesIn,Len(FilesIn)-Len(FolderIn)-1)
		    Command = "for i in "+Chr(34)+FolderIn+Chr(34)+"/"+ FilesIn+"; do cp "+Chr(34)+"$i"+Chr(34)+" "+Chr(34)+FolderOut+Chr(34)+"; done"
		    If Debugging Then Debug("CopyWild: "+ Command)
		    Sh.Execute (Command)
		    While Sh.IsRunning
		      App.DoEvents(20)
		    Wend
		    If Debugging Then Debug(Sh.ReadAll)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateShortcut(TitleName As String, Target As String, WorkingDir As String, LinkFolder As String, Args As String = "", IconFile As String = "", HotKeys As String = "", Comment As String = "")
		  If Debugging Then Debug("--- Starting Create Shortcut ---")
		  
		  Target = Target.ReplaceAll("/","\")
		  WorkingDir = Slash(WorkingDir).ReplaceAll("/","\")
		  LinkFolder = Slash(LinkFolder).ReplaceAll("/","\")
		  IconFile = IconFile.ReplaceAll("/","\")
		  
		  'If Debugging Then Debug("TitleName: "+TitleName+Chr(10)+"Target:- "+Chr(10)+Target+Chr(10)+"Working:- "+Chr(10)+WorkingDir+Chr(10)+"LinkFolder:- "+Chr(10)+LinkFolder +Chr(10)+"IconLocation: "+ IconFile)
		  
		  Dim scWorkingDir As FolderItem
		  
		  'Dim scTarget As FolderItem
		  'scTarget = GetFolderItem(Target, FolderItem.PathTypeNative)
		  scWorkingDir = GetFolderItem(WorkingDir, FolderItem.PathTypeNative)
		  
		  'If Not Exist(LinkFolder) Then
		  'MakeFolder (LinkFolder) 'Make 100% Sure it's there
		  
		  'Making Links fails if no folder made for it, we don't want it to crash a store when a shortcut fails.
		  #Pragma BreakOnExceptions Off
		  Try
		    If TargetWindows Then
		      If Debugging Then Debug("Making Link: "+LinkFolder  + TitleName + ".lnk")
		      If Debugging Then Debug("Target: "+Target)
		      If Debugging Then Debug("Args: "+Args)
		      If Debugging Then Debug("IconFile: "+IconFile)
		      If Debugging Then Debug("Hotkey: "+HotKeys)
		      Dim lnkObj As OLEObject
		      Dim scriptShell As New OLEObject("{F935DC22-1CF0-11D0-ADB9-00C04FD58A0B}")
		      
		      If scriptShell <> Nil then
		        lnkObj = scriptShell.CreateShortcut(LinkFolder  + TitleName + ".lnk")
		        If lnkObj <> Nil then
		          'lnkObj.Description = TitleName
		          lnkObj.Description = Comment
		          'lnkObj.TargetPath = scTarget.NativePath
		          lnkObj.TargetPath = Target 'Target may also have some Arguments, so use text not folder item.
		          If Args <> "" Then lnkObj.Arguments = Args 'Target may also have some Arguments, so use text not folder item.
		          lnkObj.WorkingDirectory = Slash(FixPath(scWorkingDir.NativePath))
		          'IconFile = "D:\Documents\Desktop\ppGame.ico"
		          If IconFile.IndexOf(".png") >=1 Then
		            If Exist(IconFile.ReplaceAll(".png",".ico")) Then
		              IconFile = IconFile.ReplaceAll(".png",".ico") ' Use the .ico version if it exists, instead of the png
		            Else
		              IconFile = "" 'Don't use Provided Icon File unless suitable
		            End If
		          Else
		          End If
		          If IconFile <> "" Then lnkObj.IconLocation = IconFile 'If Icon (.ico) Provided it can be used/set, +","+IconIndex.ToString - Added Index to IconFile as it's used this way
		          '.Hotkey = "ALT+CTRL+F"
		          If HotKeys <> "" Then lnkObj.Hotkey = HotKeys
		          'Save Lnk file
		          lnkObj.Save
		        Else
		        End If
		      End If
		    End If
		  Catch
		    If Debugging Then Debug("* Failed Making Link: "+LinkFolder  + TitleName + ".lnk")
		  End Try
		  
		  #Pragma BreakOnExceptions On
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Debug(Debugger As String)
		  #Pragma BreakOnExceptions Off
		  Try
		    Var d As DateTime = DateTime.Now
		    If Left(Debugger,3) = "---" Then 'Don't time stamp new sections
		      DebugOutput.WriteLine (Chr(10)+Debugger)
		      DebugOutput.WriteLine ("--------------------------------------------------------------------------------")
		    Else
		      If Left (Debugger,1) = "*" Then 'Make Errors Stand Out
		        DebugOutput.WriteLine (Chr(10)+Debugger)
		        DebugOutput.WriteLine ("********************************************************************************")
		      Else 
		        If Left(Debugger,3) = ">>>" Then
		          DebugOutput.WriteLine (Chr(10)+Debugger)
		          DebugOutput.WriteLine ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		        Else
		          If Left(Debugger,4) = "Item" Then 'Remove time stamps from this list
		            DebugOutput.WriteLine (Debugger)
		          Else
		            'Standard Debug
		            If Debugger.Trim = "" Then
		              DebugOutput.WriteLine (Debugger) 'Just add empty line
		            Else
		              DebugOutput.WriteLine (d.Hour.ToString("00")+":"+d.Minute.ToString("00")+":"+d.Second.ToString("00")+Chr(9)+Debugger)
		            End If
		          End If
		        End If
		      End If
		    End If
		    DebugOutput.Flush ' Actually Write to file after each thing
		  Catch
		  End Try
		  #Pragma BreakOnExceptions On
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Deltree(S As String)
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = -1
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  If S = "" Or S.Length <= 4 Then Return 'Don't remove short paths, it's dangerous to do them as mistakes happen
		  
		  If TargetWindows Then S = S.ReplaceAll("/","\") 'rmdir needs backslash in Windows
		  
		  S = S.Trim
		  'QueueDeltree = False ' Enable this line to test if Queue is causing issues
		  
		  If QueueDeltree Then
		    'Delete Folders
		    Dim I As Integer
		    Dim NewJob As String
		    Dim Found As Boolean
		    '
		    NewJob = S
		    If DelJobsList.Count >= 1 Then
		      Found = False
		      For I = 0 To DelJobsList.Count - 1
		        If S = DelJobsList(I) Then
		          Found = True
		          Exit
		        End If
		      Next I
		    End If
		    If Found = False Then 'Only Add New Jobs
		      DelJobsList.Add(S) 'Add to Queue List so Only happens once
		      If TargetWindows Then
		        QueueDeltreeJobs = QueueDeltreeJobs + ("rmdir /q /s " + Chr(34)+S+Chr(34)) +Chr(10) 'Don't use RunCommand or it becomes recursive as it uses this routine to clean up
		      Else
		        QueueDeltreeJobs = QueueDeltreeJobs + ("rm -rf " + Chr(34)+S+Chr(34)) +Chr(10)
		      End If
		      
		      'Delete File
		      If TargetWindows Then
		        QueueDeltreeJobs = QueueDeltreeJobs + ("del /f /q " + Chr(34)+S+Chr(34)) +Chr(10) 'Don't use RunCommand or it becomes recursive as it uses this routine to clean up
		      Else
		        QueueDeltreeJobs = QueueDeltreeJobs + ("rm -f " + Chr(34)+S+Chr(34)) +Chr(10)
		      End If
		    End If
		  Else
		    If Debugging Then Debug("- Deltree: " + S)
		    
		    'Delete Folders
		    If TargetWindows Then
		      Sh.Execute ("rmdir /q /s " + Chr(34)+S+Chr(34)) 'Don't use RunCommand or it becomes recursive as it uses this routine to clean up
		    Else
		      Sh.Execute ("rm -rf " + Chr(34)+S+Chr(34))
		    End If
		    
		    While Sh.IsRunning
		      App.DoEvents(20)
		    Wend
		    
		    'Delete File
		    If TargetWindows Then
		      Sh.Execute ("del /f /q " + Chr(34)+S+Chr(34)) 'Don't use RunCommand or it becomes recursive as it uses this routine to clean up
		    Else
		      Sh.Execute ("rm -f " + Chr(34)+S+Chr(34))
		    End If
		    While Sh.IsRunning
		      App.DoEvents(20)
		    Wend
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableSudoScript()
		  If Debugging Then Debug("--- Starting Enable Sudo Script ---")
		  
		  If TargetWindows Then Return 'No Need to be here, shouldn't be
		  
		  Dim F As FolderItem
		  Dim Test As Boolean
		  
		  ShellFast.Execute ("echo "+Chr(34)+"HandShake"+Chr(34)+" > "+BaseDir+"/LLSudoHandShake")
		  
		  'Disable it for now, need to check it's running remotely
		  SudoEnabled = False
		  
		  If SudoShellLoop.IsRunning Then 'Can check here if the current sessions one is running, no need to handshake if True
		    SudoEnabled = True
		    Return
		  End If
		  
		  TimeOut = System.Microseconds + (6 *100000) 'Set Timeout after .6 seconds
		  While SudoEnabled = False
		    App.DoEvents(20)
		    If Not Exist(BaseDir+"/LLSudoHandShake") Then 'If deleted by Sudo script it must be running
		      SudoEnabled = True
		      If Debugging Then Debug ("# Sudo Script Already Active")
		      Exit 'Quit loop
		    End If
		    If System.Microseconds >= TimeOut Then Exit 'Timeout after set seconds
		  Wend
		  Deltree(BaseDir+"/LLSudoHandShake") 'Confirm it's gone after timeout
		  
		  If SudoEnabled = True Then Return ' It's ready to go
		  
		  'Below can't be used remotely, so use above method to check instead
		  'If Not SudoShellLoop.IsRunning Then 'Just a check
		  'SudoEnabled = False
		  'Else 'Already running just get out of here
		  'Return
		  'End If
		  
		  If HasLinuxSudo = True Then ' Don't do this unless it's needed
		    If Not TargetWindows Then 'Only make Sudo in Linux
		      If SudoEnabled = False Then
		        ShellFast.Execute ("rm -f "+BaseDir+"/LLSudoDone") ' Remove it so will only quit once recreated
		        'If KeepSudo = False Then 'Not needed as it's probablly not running by here
		        If Not Exist(BaseDir+"/LLSudo") Then
		          ShellFast.Execute ("echo "+Chr(34)+"Unlock"+Chr(34)+" > "+BaseDir+"/LLSudo")
		          SaveDataToFile("Unlock", BaseDir+"/LLSudo") 'Do 2 methods to make 100% sure it's made and waits
		          
		          'Don't do below line, if the Sudo Script needs a file, it'll have to use the full path, else it's changes out of the Installers Path to run Sudo script.
		          'Test = ChDirSet(ToolPath) 'Make sure in the right folder to run script etc
		          
		          'Added -E to the following to pass Env Variables to the Sudo scripts.
		          
		          If SysTerminal.Trim = "gnome-terminal" Then
		            SudoShellLoop.Execute(SysTerminal.Trim+" --wait -e "+"'"+ToolPath+"sudo_script.sh "+Chr(34)+ToolPath+"LLStore_Sudo.sh"+Chr(34)+"'") 'A fix for the Folder Item not working as expected is to make it trimmed, it's having problems with Extra Spaces etc?
		          ElseIf SysTerminal.Trim = "kde-ptyxis" Then
		            SudoShellLoop.Execute(SysTerminal.Trim+" -x "+"'"+ToolPath+"sudo_script.sh "+Chr(34)+ToolPath+"LLStore_Sudo.sh"+Chr(34)+"'") 'A fix for the Folder Item not working as expected is to make it trimmed, it's having problems with Extra Spaces etc?
		          Else
		            SudoShellLoop.Execute(SysTerminal.Trim+" -e "+"'"+ToolPath+"sudo_script.sh "+Chr(34)+ToolPath+"LLStore_Sudo.sh"+Chr(34)+"'") 
		          End If
		          
		          TimeOut = System.Microseconds + (5 *1000000) 'Set Timeout after 5 seconds
		          While  Exist(BaseDir+"/LLSudo") 'First thing Sudo script does is delete this file, so we know it's ran ok
		            'if SudoShellLoop.IsRunning = False Then Exit 'MsgBox "Closed Shell?" 'Disabled Line to FORCE it to wait
		            App.DoEvents(20)
		            If System.Microseconds >= TimeOut Then Exit 'Timeout after set seconds, Give up after 6 seconds? Testing Glenn
		          Wend
		          
		          if SudoShellLoop.IsRunning = True Then
		            SudoEnabled = True
		            
		            If Exist(Slash(ToolPath)+"run-1080p") Then
		              'If Not Exist("/usr/bin/run-1080p") Then 'Disabled check, just do it every time so I can easily update it.
		              RunSudo("cp -f "+chr(34)+Slash(ToolPath)+"run-1080p"+chr(34)+"  /usr/bin/run-1080p&& chmod +x /usr/bin/run-1080p") 'Make run-1080p available if it's not already
		              'End If
		            End If
		            
		            If Debugging Then Debug("Sudo Enabled: " +SudoEnabled.ToString)
		          Else
		            SudoEnabled = False
		            
		            If Debugging Then Debug("Sudo Enabled: " +SudoEnabled.ToString)
		          End If
		        Else 'File Exist, wait for a set time and continue
		          TimeOut = System.Microseconds + (5 *1000000) 'Set Timeout after 5 seconds
		          While  Exist(BaseDir+"/LLSudo") 'First thing Sudo script does is delete this file, so we know it's ran ok
		            if SudoShellLoop.IsRunning = False Then Exit 'MsgBox "Closed Shell?"
		            App.DoEvents(20)
		            If System.Microseconds >= TimeOut Then Exit 'Timeout after set seconds, Give up after 6 seconds? Testing Glenn
		          Wend
		          Deltree(BaseDir+"/LLSudo") 'Remove it, it's obviously not gonna work without user input
		        End If
		      End If
		    End If
		  Else
		    SudoEnabled = False
		    Deltree(BaseDir+"/LLSudo") 'Remove it, it's obviously not gonna work without user input
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Exist(FileIn As String) As Boolean
		  Dim F As FolderItem
		  FileIn = NoSlash(FileIn) ' Just so path with slashes return correctly
		  FileIn = FileIn.Trim
		  If FileIn = "" Then Return False
		  #Pragma BreakOnExceptions Off
		  Try
		    F = GetFolderItem(FileIn, FolderItem.PathTypeNative)
		    If F <> Nil Then
		      'If Debugging Then Debug("Exist: "+FileIn +" = True")  'Too many calls to log it really
		      If F.Exists = True Then Return True
		    End If
		    'If Debugging Then Debug("Exist: "+FileIn +" = False") 'Too many calls to log it really
		    Return False
		  Catch
		    'If Debugging Then Debug("Exist: "+FileIn +" = False") 'Too many calls to log it really
		    Return False
		  End Try
		  
		  #Pragma BreakOnExceptions On
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpPath(PathIn As String, WinPaths As Boolean = False) As String
		  'If Debugging Then Debug("ExpPath = " +PathIn) 'Too Many calls to bother logging
		  
		  'Use module-level CachedUserName to avoid recomputing on every Exp call.
		  'Populate lazily here in case HomePath was set before CachedUserName was assigned.
		  If TargetLinux And CachedUserName = "" Then
		    CachedUserName = Right( NoSlash(HomePath), Len( NoSlash(HomePath)) - InStrRev( NoSlash(HomePath), "/"))
		  End If
		  Dim UserName As String = CachedUserName
		  
		  PathIn = PathIn.ReplaceAll("\", "/")
		  
		  
		  'Convert x-terminal-emulator to SysTerminal
		  'If SysTerminal.Trim = "gnome-terminal" Then
		  'PathIn = PathIn.ReplaceAll("x-terminal-emulator", SysTerminal.Trim  + " --wait ") 'Makes scripts wait for Gnome Terminal to finish before moving to next commands (such as installing flatpaks etc)
		  'Else
		  PathIn = PathIn.ReplaceAll("x-terminal-emulator", SysTerminal.Trim )
		  'End If
		  
		  PathIn = PathIn.ReplaceAll("%LLGames%", Slash(HomePath)+"LLGames")
		  PathIn = PathIn.ReplaceAll("%LLApps%", Slash(HomePath)+"LLApps")
		  
		  'Below will only be used in Windows and Wine, so can use Disk Letters
		  If TargetWindows Then
		    PathIn = PathIn.ReplaceAll("%USBDrive%", Left(AppPath,2)) 'Convert USB/DVD your running off  to correct Path
		    PathIn = PathIn.ReplaceAll("%AppPath%", ItemLLItem.PathApp)
		    
		    'ToDo: - The %ppApps% and %ppGames% Converter needs to be moved to be changed by the LoadLLFile, so it points to the correct paths, if no path given then assume installing to Set path.
		    
		    If Regenerating = False Then 'If not installing then the path will be the AppPath/drive for links etc
		      PathIn = PathIn.ReplaceAll("%ppGames%", NoSlash(ppGames))
		      PathIn = PathIn.ReplaceAll("%ppApps%", NoSlash(ppApps))
		    Else
		      
		      'PathIn = PathIn.ReplaceAll("%ppGames%", NoSlash(RegenPathIn)) 'The returned path has the internal path of the item included, due to not knowing depth use below path to get it out
		      'PathIn = PathIn.ReplaceAll("%ppApps%", NoSlash(RegenPathIn))
		      PathIn = PathIn.ReplaceAll("%ppGames%", Left(RegenPathIn,10)) 'As we are only regenning we can use absolute paths "c:\ppGames" 10 Characters
		      PathIn = PathIn.ReplaceAll("%ppApps%", Left(RegenPathIn,9))
		    End If
		    
		    PathIn = PathIn.ReplaceAll("%INIPath%", ItemLLItem.PathINI)
		    PathIn = PathIn.ReplaceAll("%ProgramFiles%", NoSlash(SysProgramFiles))
		    PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", NoSlash(SysProgramFiles)+" (x86)")
		    PathIn = PathIn.ReplaceAll("%ProgramData%", NoSlash(SysDrive)+"/ProgramData")
		    PathIn = PathIn.ReplaceAll("%SystemDrive%", NoSlash(SysDrive))
		    PathIn = PathIn.ReplaceAll("%SystemRoot%", NoSlash(SysRoot))
		    PathIn = PathIn.ReplaceAll("%WinDir%", NoSlash(SysRoot))
		    
		    PathIn = PathIn.ReplaceAll("%SourcePath%", ItemLLItem.PathINI) '%SourcePath% is an alias for %INIPath% - kept together for clarity
		    PathIn = PathIn.ReplaceAll("%SourceDrive%", Left(ItemLLItem.PathINI,2))
		    PathIn = PathIn.ReplaceAll("%SystemDir%", Slash(SysRoot)+"System32")
		    PathIn = PathIn.ReplaceAll("%CommonProgramFiles%", Slash(SysProgramFiles)+"Common Files")
		    PathIn = PathIn.ReplaceAll("%CommonProgramFiles(x86)%", Slash(NoSlash(SysProgramFiles)+" (x86)")+"Common Files")
		    PathIn = PathIn.ReplaceAll("%HomeDrive%", NoSlash(SysDrive))
		    PathIn = PathIn.ReplaceAll("%MyDocuments%", Slash(HomePath)+"My Documents")
		    PathIn = PathIn.ReplaceAll("%StartMenu%", NoSlash(StartPathUser))
		    PathIn = PathIn.ReplaceAll("%Programs%", Slash(StartPathUser)+"Programs")
		    PathIn = PathIn.ReplaceAll("%Startup%", Slash(Slash(StartPathUser)+"Programs")+"Startup")
		    PathIn = PathIn.ReplaceAll("%SendtoPath%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Windows/SendTo")
		    PathIn = PathIn.ReplaceAll("%QuickLaunch%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Internet Explorer/Quick Launch")
		    PathIn = PathIn.ReplaceAll("%UserProfile%", NoSlash(HomePath))
		    PathIn = PathIn.ReplaceAll("%Tmp%", NoSlash(TmpPath))
		    PathIn = PathIn.ReplaceAll("%Temp%", NoSlash(TmpPath))
		    PathIn = PathIn.ReplaceAll("%AllUsersProfile%", "C:/Users/Public")
		    PathIn = PathIn.ReplaceAll("%AppDataCommon%", SpecialFolder.SharedApplicationData.NativePath)
		    PathIn = PathIn.ReplaceAll("%DesktopCommon%", SpecialFolder.SharedDesktop.NativePath)
		    PathIn = PathIn.ReplaceAll("%DocumentsCommon%", SpecialFolder.SharedDocuments.NativePath)
		    PathIn = PathIn.ReplaceAll("%StartMenuCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu")
		    PathIn = PathIn.ReplaceAll("%ProgramsCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs")
		    PathIn = PathIn.ReplaceAll("%StartupCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup")
		    PathIn = PathIn.ReplaceAll("%InstalledPath%", ItemLLItem.PathApp)
		    PathIn = PathIn.ReplaceAll("%AppDrive%", Left(ItemLLItem.PathApp,2))
		    
		    
		    PathIn = PathIn.ReplaceAll("%LocalAppData%", FixPath(NoSlash(SpecialFolder.ApplicationData.Parent.NativePath)+"/Local"))
		    
		    If Regenerating = False Then 'If not installing then the path will be the AppPath/drive for links etc
		      PathIn = PathIn.ReplaceAll("%ppGamesDrive%", Left(ppGames,2))
		      PathIn = PathIn.ReplaceAll("%ppAppsDrive%", Left(ppApps,2))
		    Else
		      PathIn = PathIn.ReplaceAll("%ppGamesDrive%", Left(RegenPathIn,2))
		      PathIn = PathIn.ReplaceAll("%ppAppsDrive%", Left(RegenPathIn,2))
		    End If
		    PathIn = PathIn.ReplaceAll("%Extract%", Win7z+" -mtc -aoa x ")
		    
		    PathIn = PathIn.ReplaceAll("%Desktop%",  FixPath(NoSlash(SpecialFolder.Desktop.NativePath)))
		    PathIn = PathIn.ReplaceAll("%AppData%",  FixPath(NoSlash(SpecialFolder.ApplicationData.NativePath)))
		    
		  Else 'Use Linux full paths instead (So can detect if installed etc first).
		    If WinPaths Then
		      PathIn = PathIn.ReplaceAll("%AppPath%", "z:"+ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%ppGames%", "C:/ppGames")
		      PathIn = PathIn.ReplaceAll("%ppApps%", "C:/ppApps")
		      
		      PathIn = PathIn.ReplaceAll("%INIPath%", "z:"+ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%ProgramFiles%", "C:/Program Files")
		      PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", "C:/Program Files (x86)")
		      PathIn = PathIn.ReplaceAll("%ProgramData%", "C:/ProgramData")
		      PathIn = PathIn.ReplaceAll("%SystemDrive%", "C:")
		      PathIn = PathIn.ReplaceAll("%SystemRoot%", "C:/windows")
		      PathIn = PathIn.ReplaceAll("%WinDir%", "C:/windows")
		      
		      
		      PathIn = PathIn.ReplaceAll("%SourcePath%", ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%SourceDrive%", "z:")
		      PathIn = PathIn.ReplaceAll("%SystemDir%", HomePath + ".wine/drive_c/Windows/System32")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles%", HomePath + ".wine/drive_c/Program Files/Common Files")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles(x86)%", HomePath + ".wine/drive_c/Program Files (x86)/Common Files")
		      PathIn = PathIn.ReplaceAll("%HomeDrive%", HomePath + ".wine/drive_c")
		      PathIn = PathIn.ReplaceAll("%MyDocuments%", Slash(HomePath)+"Documents")
		      'PathIn = PathIn.ReplaceAll("%StartMenu%", NoSlash(StartPathUser))
		      'PathIn = PathIn.ReplaceAll("%Programs%", Slash(StartPathUser)+"Programs")
		      'PathIn = PathIn.ReplaceAll("%Startup%", Slash(Slash(StartPathUser)+"Programs")+"Startup")
		      'PathIn = PathIn.ReplaceAll("%SendtoPath%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Windows/SendTo")
		      'PathIn = PathIn.ReplaceAll("%QuickLaunch%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Internet Explorer/Quick Launch")
		      PathIn = PathIn.ReplaceAll("%UserProfile%", HomePath + ".wine/drive_c/Users/"+UserName)
		      PathIn = PathIn.ReplaceAll("%Tmp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%Temp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%AllUsersProfile%", HomePath + ".wine/drive_c/Users/Public")
		      PathIn = PathIn.ReplaceAll("%AppDataCommon%", HomePath + ".wine/drive_c/ProgramData")
		      'PathIn = PathIn.ReplaceAll("%DesktopCommon%", SpecialFolder.SharedDesktop.NativePath)
		      'PathIn = PathIn.ReplaceAll("%DocumentsCommon%", SpecialFolder.SharedDocuments.NativePath)
		      'PathIn = PathIn.ReplaceAll("%StartMenuCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu")
		      'PathIn = PathIn.ReplaceAll("%ProgramsCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs")
		      'PathIn = PathIn.ReplaceAll("%StartupCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup")
		      PathIn = PathIn.ReplaceAll("%InstalledPath%", ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%AppDrive%", "z:")
		      
		      
		      PathIn = PathIn.ReplaceAll("%LocalAppData%", "C:/users/"+UserName+"/AppData/Local")
		      
		      PathIn = PathIn.ReplaceAll("%ppGamesDrive%", "C:")
		      PathIn = PathIn.ReplaceAll("%ppAppsDrive%", "C:")
		      
		      PathIn = PathIn.ReplaceAll("%Extract%", "z:"+Win7z+" -mtc -aoa x ") 'This is only used by Wine Scripts, I'll make another method for Linux as needed for Bash Scripts
		      
		      PathIn = PathIn.ReplaceAll("%Desktop%",  FixPath("z:"+NoSlash(SpecialFolder.Desktop.NativePath)))
		      PathIn = PathIn.ReplaceAll("%AppData%",  "C:/users/"+UserName+"/AppData/Roaming")
		    Else
		      PathIn = PathIn.ReplaceAll("%AppPath%", ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%ppGames%", NoSlash(ppGames))
		      PathIn = PathIn.ReplaceAll("%ppApps%", NoSlash(ppApps))
		      
		      PathIn = PathIn.ReplaceAll("%INIPath%", ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%ProgramFiles%", HomePath +  ".wine/drive_c/Program Files")
		      
		      PathIn = PathIn.ReplaceAll("C:/Program Files", HomePath +  ".wine/drive_c/Program Files") 'Added to fix up a few issues in older apz
		      PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", HomePath +  ".wine/drive_c/Program Files (x86)")
		      PathIn = PathIn.ReplaceAll("%ProgramData%", HomePath +  ".wine/drive_c/ProgramData")
		      PathIn = PathIn.ReplaceAll("%SystemDrive%", HomePath +  ".wine/drive_c")
		      PathIn = PathIn.ReplaceAll("%SystemRoot%", HomePath +  ".wine/drive_c/windows")
		      PathIn = PathIn.ReplaceAll("%WinDir%", HomePath +  ".wine/drive_c/windows")
		      
		      
		      PathIn = PathIn.ReplaceAll("%SourcePath%", ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%SourceDrive%", "z:")
		      PathIn = PathIn.ReplaceAll("%SystemDir%", HomePath +  ".wine/drive_c/windows/System32")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles%", HomePath + ".wine/drive_c/Program Files/Common Files")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles(x86)%", HomePath + ".wine/drive_c/Program Files (x86)/Common Files")
		      PathIn = PathIn.ReplaceAll("%HomeDrive%", HomePath + ".wine/drive_c")
		      PathIn = PathIn.ReplaceAll("%MyDocuments%", Slash(HomePath)+"Documents")
		      'PathIn = PathIn.ReplaceAll("%StartMenu%", NoSlash(StartPathUser))
		      'PathIn = PathIn.ReplaceAll("%Programs%", Slash(StartPathUser)+"Programs")
		      'PathIn = PathIn.ReplaceAll("%Startup%", Slash(Slash(StartPathUser)+"Programs")+"Startup")
		      'PathIn = PathIn.ReplaceAll("%SendtoPath%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Windows/SendTo")
		      'PathIn = PathIn.ReplaceAll("%QuickLaunch%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Internet Explorer/Quick Launch")
		      'PathIn = PathIn.ReplaceAll("%UserProfile%", NoSlash(HomePath))
		      PathIn = PathIn.ReplaceAll("%Tmp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%Temp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%AllUsersProfile%", HomePath + ".wine/drive_c/ProgramData")
		      'PathIn = PathIn.ReplaceAll("%AppDataCommon%", FixPath(NoSlash(SpecialFolder.SharedApplicationData.NativePath)))
		      'PathIn = PathIn.ReplaceAll("%DesktopCommon%", SpecialFolder.SharedDesktop.NativePath)
		      'PathIn = PathIn.ReplaceAll("%DocumentsCommon%", SpecialFolder.SharedDocuments.NativePath)
		      'PathIn = PathIn.ReplaceAll("%StartMenuCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu")
		      'PathIn = PathIn.ReplaceAll("%ProgramsCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs")
		      'PathIn = PathIn.ReplaceAll("%StartupCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup")
		      PathIn = PathIn.ReplaceAll("%InstalledPath%", ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%AppDrive%", "c:")
		      
		      
		      PathIn = PathIn.ReplaceAll("%LocalAppData%", HomePath +  ".wine/drive_c/users/"+UserName+"/AppData/Local")
		      
		      PathIn = PathIn.ReplaceAll("%ppGamesDrive%", HomePath +  ".wine/drive_c")
		      PathIn = PathIn.ReplaceAll("%ppAppsDrive%", HomePath +  ".wine/drive_c")
		      
		      PathIn = PathIn.ReplaceAll("%Extract%", Linux7z+" -mtc -aoa x ") 'This is only used by Wine Scripts, I'll make another method for Linux as needed for Bash Scripts
		      
		      PathIn = PathIn.ReplaceAll("%Desktop%", FixPath(NoSlash(SpecialFolder.Desktop.NativePath)))
		      PathIn = PathIn.ReplaceAll("%AppData%", FixPath(NoSlash(SpecialFolder.ApplicationData.NativePath)))
		      
		    End If
		  End If
		  
		  'Do This Last so can conver subpaths above first
		  PathIn = PathIn.ReplaceAll("$HOME", NoSlash(HomePath))
		  
		  'Change Flatpak --user to --system Or Vice Versa as set (Defaults to User)
		  If FlatpakAsUser = True Then
		    PathIn = PathIn.ReplaceAll("--system", "--user")
		  Else 'Must be System Wide
		    PathIn = PathIn.ReplaceAll("--user", "--system")
		  End If
		  
		  Return PathIn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpPathReg(PathIn As String, WinPaths As Boolean = False) As String
		  If Debugging Then Debug("ExpReg = " +PathIn)
		  
		  'Use module-level CachedUserName to avoid recomputing on every Exp call.
		  'Populate lazily here in case HomePath was set before CachedUserName was assigned.
		  If TargetLinux And CachedUserName = "" Then
		    CachedUserName = Right( NoSlash(HomePath), Len( NoSlash(HomePath)) - InStrRev( NoSlash(HomePath), "/"))
		  End If
		  Dim UserName As String = CachedUserName
		  
		  
		  'MsgBox UserName
		  Dim Dat As String
		  Dat = Slash(HomePath)+"LLGames"
		  Dat = Dat.ReplaceAll("/","\")
		  Dat = Dat.ReplaceAll("\","\\")
		  PathIn = PathIn.ReplaceAll("%LLGames%", Dat)
		  Dat = Slash(HomePath)+"LLApps"
		  Dat = Dat.ReplaceAll("/","\")
		  Dat = Dat.ReplaceAll("\","\\")
		  PathIn = PathIn.ReplaceAll("%LLApps%", Dat)
		  
		  'Below will only be used in Windows and Wine, so can use Disk Letters
		  If TargetWindows Then
		    Dat = ItemLLItem.PathApp
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%AppPath%", Dat)
		    Dat = NoSlash(ppGames)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%ppGames%", Dat)
		    Dat = NoSlash(ppApps)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%ppApps%", Dat)
		    Dat = ItemLLItem.PathINI
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%INIPath%", Dat)
		    
		    Dat = ItemLLItem.PathINI
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%SourcePath%", Dat)
		    
		    Dat = NoSlash(SysProgramFiles)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%ProgramFiles%", Dat)
		    Dat = NoSlash(SysProgramFiles)+" (x86)"
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", Dat)
		    Dat = NoSlash(SysDrive)+"\ProgramData"
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%ProgramData%", Dat)
		    Dat = NoSlash(SysDrive)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%SystemDrive%", Dat)
		    Dat = NoSlash(SysRoot)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%SystemRoot%", Dat)
		    Dat = NoSlash(SysRoot)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%WinDir%", Dat)
		    
		    Dat = NoSlash(SpecialFolder.ApplicationData.Parent.NativePath)+"\Local"
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%LocalAppData%", Dat)
		    
		    Dat = NoSlash(SpecialFolder.ApplicationData.NativePath)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%AppData%", Dat)
		    Dat = "z:"+NoSlash(SpecialFolder.Desktop.NativePath)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%Desktop%",  Dat)
		    
		    Dat = Left(ppGames,2)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%ppGamesDrive%", Dat)
		    Dat = Left(ppApps,2)
		    Dat = Dat.ReplaceAll("/","\")
		    Dat = Dat.ReplaceAll("\","\\")
		    PathIn = PathIn.ReplaceAll("%ppAppsDrive%", Dat)
		    
		    PathIn = PathIn.ReplaceAll("%USBDrive%", Left(AppPath,2)) 'Convert USB/DVD your running off  to correct Path
		    
		    'Use one from ssWPI for this path
		    'Dat = "C:\Users\"+UserName+"\Desktop"
		    'Dat = 
		    'Dat = Dat.ReplaceAll("\","\\")
		    'PathIn = PathIn.ReplaceAll("%Desktop%", Dat)
		    
		  Else 'Use Linux full paths instead (So can detect if installed etc first).
		    If WinPaths Then
		      Dat = "z:"+ItemLLItem.PathApp
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%AppPath%", Dat)
		      Dat = "C:\ppGames"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%ppGames%", Dat)
		      Dat = "C:\ppApps"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%ppApps%", Dat)
		      Dat = "z:"+ItemLLItem.PathINI
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%INIPath%", Dat)
		      Dat = "C:\Program Files"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%ProgramFiles%", Dat)
		      Dat = "C:\Program Files (x86)"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", Dat)
		      Dat = "C:\ProgramData"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%ProgramData%", Dat)
		      Dat = "C:"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%SystemDrive%", Dat)
		      Dat = "C:\windows"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%SystemRoot%", Dat)
		      Dat = "C:\windows"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%WinDir%", Dat)
		      
		      Dat = "C:\users\"+UserName+"\AppData\Roaming"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%AppData%", Dat)
		      Dat = "C:\users\"+UserName+"\AppData\Local"
		      Dat = Dat.ReplaceAll("/","\")
		      Dat = Dat.ReplaceAll("\","\\")
		      PathIn = PathIn.ReplaceAll("%LocalAppData%", Dat)
		      Dat = "C:"
		      PathIn = PathIn.ReplaceAll("%ppGamesDrive%", Dat)
		      Dat = "C:"
		      PathIn = PathIn.ReplaceAll("%ppAppsDrive%", Dat)
		      
		      PathIn = PathIn.ReplaceAll("%USBDrive%", "z:") 'Convert USB/DVD your running off  to correct Path
		      
		      'Dat = "z:/home/"+UserName+"/Desktop"
		      'Dat = Dat.ReplaceAll("/","\")
		      'Dat = Dat.ReplaceAll("/","//")
		      'PathIn = PathIn.ReplaceAll("%Desktop%", Dat)
		      
		    Else
		      'Unused
		    End If
		  End If
		  
		  Return PathIn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpPathScript(PathIn As String, WinPaths As Boolean = False) As String
		  'Make sure I convert ALL the Variables I need in all these expanders
		  
		  If Debugging Then Debug("ExpPathScript = " +PathIn)
		  'Use module-level CachedUserName to avoid recomputing on every Exp call.
		  'Populate lazily here in case HomePath was set before CachedUserName was assigned.
		  If TargetLinux And CachedUserName = "" Then
		    CachedUserName = Right( NoSlash(HomePath), Len( NoSlash(HomePath)) - InStrRev( NoSlash(HomePath), "/"))
		  End If
		  Dim UserName As String = CachedUserName
		  
		  'Convert x-terminal-emulator to SysTerminal
		  'If SysTerminal.Trim = "gnome-terminal" Then
		  'PathIn = PathIn.ReplaceAll("x-terminal-emulator", SysTerminal.Trim  + " --wait ") 'Makes scripts wait for Gnome Terminal to finish before moving to next commands (such as installing flatpaks etc)
		  'Else
		  PathIn = PathIn.ReplaceAll("x-terminal-emulator", SysTerminal.Trim )
		  'End If
		  
		  PathIn = PathIn.ReplaceAll("%LLGames%", Slash(HomePath)+"LLGames")
		  PathIn = PathIn.ReplaceAll("%LLApps%", Slash(HomePath)+"LLApps")
		  
		  
		  PathIn = PathIn.ReplaceAll("%~DP0", Slash(InstallToPath)) ' The InstallToPath needs to be used here else when you run expanded scripts it'll run from the temp folder and not the temp extracted app folder or pre extracted folder.
		  PathIn = PathIn.ReplaceAll("%~D0", Left(InstallToPath,2)) ' The InstallToPath needs to be used here else when you run expanded scripts it'll run from the temp folder and not the temp extracted app folder or pre extracted folder.
		  
		  'Below will only be used in Windows and Wine, so can use Disk Letters
		  If TargetWindows Then
		    PathIn = PathIn.ReplaceAll("%USBDrive%", Left(AppPath,2)) 'Convert USB/DVD your running off  to correct Path
		    
		    PathIn = PathIn.ReplaceAll("%AppPath%", ItemLLItem.PathApp)
		    PathIn = PathIn.ReplaceAll("%ppGames%", NoSlash(ppGames))
		    PathIn = PathIn.ReplaceAll("%ppApps%", NoSlash(ppApps))
		    
		    PathIn = PathIn.ReplaceAll("%INIPath%", ItemLLItem.PathINI)
		    PathIn = PathIn.ReplaceAll("%ProgramFiles%", NoSlash(SysProgramFiles))
		    PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", NoSlash(SysProgramFiles)+" (x86)")
		    PathIn = PathIn.ReplaceAll("%ProgramData%", NoSlash(SysDrive)+"/ProgramData")
		    PathIn = PathIn.ReplaceAll("%SystemDrive%", NoSlash(SysDrive))
		    PathIn = PathIn.ReplaceAll("%SystemRoot%", NoSlash(SysRoot))
		    PathIn = PathIn.ReplaceAll("%WinDir%", NoSlash(SysRoot))
		    
		    PathIn = PathIn.ReplaceAll("%SourcePath%", ItemLLItem.PathINI)
		    PathIn = PathIn.ReplaceAll("%SourceDrive%", Left(ItemLLItem.PathINI,2))
		    PathIn = PathIn.ReplaceAll("%SystemDir%", Slash(SysRoot)+"System32")
		    PathIn = PathIn.ReplaceAll("%CommonProgramFiles%", Slash(SysProgramFiles)+"Common Files")
		    PathIn = PathIn.ReplaceAll("%CommonProgramFiles(x86)%", Slash(NoSlash(SysProgramFiles)+" (x86)")+"Common Files")
		    PathIn = PathIn.ReplaceAll("%HomeDrive%", NoSlash(SysDrive))
		    PathIn = PathIn.ReplaceAll("%MyDocuments%", Slash(HomePath)+"My Documents")
		    PathIn = PathIn.ReplaceAll("%StartMenu%", NoSlash(StartPathUser))
		    PathIn = PathIn.ReplaceAll("%Programs%", Slash(StartPathUser)+"Programs")
		    PathIn = PathIn.ReplaceAll("%Startup%", Slash(Slash(StartPathUser)+"Programs")+"Startup")
		    PathIn = PathIn.ReplaceAll("%SendtoPath%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Windows/SendTo")
		    PathIn = PathIn.ReplaceAll("%QuickLaunch%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Internet Explorer/Quick Launch")
		    PathIn = PathIn.ReplaceAll("%UserProfile%", NoSlash(HomePath))
		    PathIn = PathIn.ReplaceAll("%Tmp%", NoSlash(TmpPath))
		    PathIn = PathIn.ReplaceAll("%Temp%", NoSlash(TmpPath))
		    PathIn = PathIn.ReplaceAll("%AllUsersProfile%", "C:/Users/Public")
		    PathIn = PathIn.ReplaceAll("%AppDataCommon%", SpecialFolder.SharedApplicationData.NativePath)
		    PathIn = PathIn.ReplaceAll("%DesktopCommon%", SpecialFolder.SharedDesktop.NativePath)
		    PathIn = PathIn.ReplaceAll("%DocumentsCommon%", SpecialFolder.SharedDocuments.NativePath)
		    PathIn = PathIn.ReplaceAll("%StartMenuCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu")
		    PathIn = PathIn.ReplaceAll("%ProgramsCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs")
		    PathIn = PathIn.ReplaceAll("%StartupCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup")
		    PathIn = PathIn.ReplaceAll("%InstalledPath%", ItemLLItem.PathApp)
		    PathIn = PathIn.ReplaceAll("%AppDrive%", Left(ItemLLItem.PathApp,2))
		    
		    
		    PathIn = PathIn.ReplaceAll("%LocalAppData%", FixPath(NoSlash(SpecialFolder.ApplicationData.Parent.NativePath)+"/Local"))
		    
		    PathIn = PathIn.ReplaceAll("%ppGamesDrive%", Left(ppGames,2))
		    PathIn = PathIn.ReplaceAll("%ppAppsDrive%", Left(ppApps,2))
		    PathIn = PathIn.ReplaceAll("%Extract%", Win7z+" -mtc -aoa x ")
		    
		    PathIn = PathIn.ReplaceAll("%Desktop%",  FixPath(NoSlash(SpecialFolder.Desktop.NativePath)))
		    PathIn = PathIn.ReplaceAll("%AppData%",  FixPath(NoSlash(SpecialFolder.ApplicationData.NativePath)))
		    
		  Else 'Use Linux full paths instead (So can detect if installed etc first).
		    If WinPaths Then
		      PathIn = PathIn.ReplaceAll("%USBDrive%", "z:") 'Convert USB/DVD your running off  to correct Path
		      'I changed all these to backslash as it only affects ssTek and I found having both forward and back slashes seems to break scripts a bit - will see if this fixes GlennGlennGlenn
		      PathIn = PathIn.ReplaceAll("%AppPath%", "z:"+ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%ppGames%", "C:\ppGames")
		      PathIn = PathIn.ReplaceAll("%ppApps%", "C:\ppApps")
		      
		      PathIn = PathIn.ReplaceAll("%INIPath%", "z:"+ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%ProgramFiles%", "C:\Program Files")
		      PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", "C:\Program Files (x86)")
		      PathIn = PathIn.ReplaceAll("%ProgramData%", "C:\ProgramData")
		      PathIn = PathIn.ReplaceAll("%SystemDrive%", "C:")
		      PathIn = PathIn.ReplaceAll("%SystemRoot%", "C:\windows")
		      PathIn = PathIn.ReplaceAll("%WinDir%", "C:\windows")
		      
		      PathIn = PathIn.ReplaceAll("%SourcePath%", ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%SourceDrive%", "z:")
		      PathIn = PathIn.ReplaceAll("%SystemDir%", "C:/Windows/System32")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles%", "C:/Program Files/Common Files")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles(x86)%", "C:/Program Files (x86)/Common Files")
		      PathIn = PathIn.ReplaceAll("%HomeDrive%", "C:")
		      PathIn = PathIn.ReplaceAll("%MyDocuments%", "C:/Users/"+UserName+"/Documents")
		      
		      'PathIn = PathIn.ReplaceAll("%StartMenu%", NoSlash(StartPathUser))
		      'PathIn = PathIn.ReplaceAll("%Programs%", Slash(StartPathUser)+"Programs")
		      'PathIn = PathIn.ReplaceAll("%Startup%", Slash(Slash(StartPathUser)+"Programs")+"Startup")
		      'PathIn = PathIn.ReplaceAll("%SendtoPath%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Windows/SendTo")
		      'PathIn = PathIn.ReplaceAll("%QuickLaunch%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Internet Explorer/Quick Launch")
		      PathIn = PathIn.ReplaceAll("%UserProfile%", "C:/Users/"+UserName)
		      PathIn = PathIn.ReplaceAll("%Tmp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%Temp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%AllUsersProfile%", "C:/Users/Public")
		      PathIn = PathIn.ReplaceAll("%AppDataCommon%", "C:/ProgramData")
		      'PathIn = PathIn.ReplaceAll("%DesktopCommon%", SpecialFolder.SharedDesktop.NativePath)
		      'PathIn = PathIn.ReplaceAll("%DocumentsCommon%", SpecialFolder.SharedDocuments.NativePath)
		      'PathIn = PathIn.ReplaceAll("%StartMenuCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu")
		      'PathIn = PathIn.ReplaceAll("%ProgramsCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs")
		      'PathIn = PathIn.ReplaceAll("%StartupCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup")
		      PathIn = PathIn.ReplaceAll("%InstalledPath%", ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%AppDrive%", "z:")
		      
		      PathIn = PathIn.ReplaceAll("%LocalAppData%", "C:/users/"+UserName+"/AppData/Local")
		      
		      PathIn = PathIn.ReplaceAll("%ppGamesDrive%", "C:")
		      PathIn = PathIn.ReplaceAll("%ppAppsDrive%", "C:")
		      
		      PathIn = PathIn.ReplaceAll("%Extract%", "z:"+Win7z+" -mtc -aoa x ") 'This is only used by Wine Scripts, I'll make another method for Linux as needed for Bash Scripts
		      
		      PathIn = PathIn.ReplaceAll("%Desktop%", FixPath("z:"+NoSlash(SpecialFolder.Desktop.NativePath)))
		      PathIn = PathIn.ReplaceAll("%AppData%", "C:/users/"+UserName+"/AppData/Roaming")
		      
		    Else 'Linux Path, not windows paths for scripts to use
		      PathIn = PathIn.ReplaceAll("%ToolPath%", NoSlash(ToolPath)) 'LLStore Tools folder - resolves to wherever LLStore is running from (USB or installed)
		      PathIn = PathIn.ReplaceAll("%AppPath%", ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%ppGames%", NoSlash(ppGames))
		      PathIn = PathIn.ReplaceAll("%ppApps%", NoSlash(ppApps))
		      
		      PathIn = PathIn.ReplaceAll("%INIPath%", ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%ProgramFiles%", HomePath + ".wine/drive_c/Program Files")
		      PathIn = PathIn.ReplaceAll("%ProgramFiles(x86)%", HomePath + ".wine/drive_c/Program Files (x86)")
		      PathIn = PathIn.ReplaceAll("%ProgramData%", HomePath + ".wine/drive_c/ProgramData")
		      PathIn = PathIn.ReplaceAll("%SystemDrive%", HomePath + ".wine/drive_c")
		      PathIn = PathIn.ReplaceAll("%SystemRoot%", HomePath + ".wine/drive_c/windows")
		      PathIn = PathIn.ReplaceAll("%WinDir%", HomePath + ".wine/drive_c/windows")
		      
		      
		      PathIn = PathIn.ReplaceAll("%SourcePath%", ItemLLItem.PathINI)
		      PathIn = PathIn.ReplaceAll("%SourceDrive%", "z:")
		      PathIn = PathIn.ReplaceAll("%SystemDir%", HomePath +  ".wine/drive_c/windows/System32")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles%", HomePath + ".wine/drive_c/Program Files/Common Files")
		      PathIn = PathIn.ReplaceAll("%CommonProgramFiles(x86)%", HomePath + ".wine/drive_c/Program Files (x86)/Common Files")
		      PathIn = PathIn.ReplaceAll("%HomeDrive%", HomePath + ".wine/drive_c")
		      PathIn = PathIn.ReplaceAll("%MyDocuments%", Slash(HomePath)+"Documents")
		      'PathIn = PathIn.ReplaceAll("%StartMenu%", NoSlash(StartPathUser))
		      'PathIn = PathIn.ReplaceAll("%Programs%", Slash(StartPathUser)+"Programs")
		      'PathIn = PathIn.ReplaceAll("%Startup%", Slash(Slash(StartPathUser)+"Programs")+"Startup")
		      'PathIn = PathIn.ReplaceAll("%SendtoPath%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Windows/SendTo")
		      'PathIn = PathIn.ReplaceAll("%QuickLaunch%", Slash(SpecialFolder.ApplicationData.NativePath) + "Microsoft/Internet Explorer/Quick Launch")
		      'PathIn = PathIn.ReplaceAll("%UserProfile%", NoSlash(HomePath))
		      PathIn = PathIn.ReplaceAll("%Tmp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%Temp%", NoSlash(TmpPath))
		      PathIn = PathIn.ReplaceAll("%AllUsersProfile%", HomePath + ".wine/drive_c/ProgramData")
		      PathIn = PathIn.ReplaceAll("%AppDataCommon%", FixPath(NoSlash(SpecialFolder.SharedApplicationData.NativePath)))
		      PathIn = PathIn.ReplaceAll("%DesktopCommon%", SpecialFolder.SharedDesktop.NativePath)
		      'PathIn = PathIn.ReplaceAll("%DocumentsCommon%", SpecialFolder.SharedDocuments.NativePath)
		      'PathIn = PathIn.ReplaceAll("%StartMenuCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu")
		      'PathIn = PathIn.ReplaceAll("%ProgramsCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs")
		      'PathIn = PathIn.ReplaceAll("%StartupCommon%", "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup")
		      PathIn = PathIn.ReplaceAll("%InstalledPath%", ItemLLItem.PathApp)
		      PathIn = PathIn.ReplaceAll("%AppDrive%", "c:")
		      
		      
		      
		      PathIn = PathIn.ReplaceAll("%LocalAppData%", HomePath +  ".wine/drive_c/users/"+UserName+"/AppData/Local")
		      
		      PathIn = PathIn.ReplaceAll("%ppGamesDrive%", HomePath +  ".wine/drive_c")
		      PathIn = PathIn.ReplaceAll("%ppAppsDrive%", HomePath +  ".wine/drive_c")
		      
		      PathIn = PathIn.ReplaceAll("%Extract%", Win7z) 'This is only used by Wine Scripts, I'll make another method for Linux as needed for Bash Scripts
		      
		      PathIn = PathIn.ReplaceAll("%Desktop%",  FixPath(NoSlash(SpecialFolder.Desktop.NativePath)))
		      PathIn = PathIn.ReplaceAll("%AppData%",  FixPath(NoSlash(SpecialFolder.ApplicationData.NativePath)))
		    End If
		  End If
		  
		  'Do This Last so can convert subpaths above first
		  PathIn = PathIn.ReplaceAll("$HOME", NoSlash(HomePath))
		  
		  
		  'Add MSI installer to lines that have a .msi in them
		  If Left(PathIn.Lowercase,3) = "rem" Then 'skip rem lines, incase it's not suposed to run.
		  Else
		    'If Left(PathIn.Trim,4) = "wine" And PathIn.IndexOf(".msi") >=1 Then ' make sure it's only changing lines that install msi's 'This method doesn't work on windows ones
		    If TargetWindows Then
		      If Left(PathIn.Trim,3) <> "del" And Left(PathIn.Trim,3) <> "ren" And Left(PathIn.Trim,4) <> "copy" And Left(PathIn.Trim,4) <> "move" And Left(PathIn.Trim,5) <> "xcopy" And PathIn.IndexOf(".msi") >=1 Then ' make sure it's only changing lines that install msi's, that don't have del at start (eg incase NitroPDF tries to delete a msi file)
		        If Left(PathIn,7) <> "msiexec" Then
		          'If Left(PathIn,1)<>Chr(34) Then 'Need to check for end of .msi and remove /qb if it's an issue
		          PathIn = "msiexec /quiet /norestart /i "+PathIn
		        Else
		        End If
		        
		      End If
		    Else 'Linux, only change ones that specifically set as WINE as I use wget and move them about too and it changes all the lines with .msi in them
		      If Left(PathIn.Trim,4) = "wine" And PathIn.IndexOf(".msi") >=1 Then ' make sure it's only changing lines that install msi's 'This method doesn't work on windows ones
		        If Left(PathIn,7) <> "msiexec" Then 
		          'If Left(PathIn,1)<>Chr(34) Then 'Need to check for end of .msi and remove /qb if it's an issue
		          PathIn = "msiexec /quiet /norestart /i "+PathIn
		        Else
		        End If
		      End If
		      If PathIn.IndexOf(".msi /qb") >= 1 Or PathIn.IndexOf(".msi /qn") >= 1 Then 'If it detects as /qb or /qn then it's obviously an installer and should be treated as such
		        If Left(PathIn,7) <> "msiexec" Then 'ignore if already added
		          PathIn = "msiexec /quiet /norestart /i "+PathIn
		        End If
		      End If
		    End If
		  End If
		  
		  'Change Flatpak --user to --system Or Vice Versa as set (Defaults to User)
		  If FlatpakAsUser = True Then
		    PathIn = PathIn.ReplaceAll("--system", "--user")
		  Else 'Must be System Wide
		    PathIn = PathIn.ReplaceAll("--user", "--system")
		  End If
		  
		  
		  Return PathIn
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpReg(OrigScript As String) As String
		  Dim F As FolderItem
		  Dim RL As String
		  Dim I As Integer
		  
		  Dim ScriptContent As String
		  Dim ScriptFile As String
		  Dim SP() As String
		  
		  F = GetFolderItem(OrigScript, FolderItem.PathTypeNative)
		  
		  'ScriptFile = Slash(FixPath(F.Parent.NativePath)+"Expanded_Registry.reg") 'Use InstallFrom Drive, not Temp
		  ScriptFile = Slash(FixPath(TmpPath))+"Expanded_Registry.reg"
		  
		  'Load in whole file at once (Fastest Method)
		  Try
		    inputStream = TextInputStream.Open(F)
		    
		    While Not inputStream.EndOfFile 'If Empty file this skips it
		      RL = inputStream.ReadAll
		    Wend
		    inputStream.Close
		  Catch
		  End Try
		  RL = RL.ReplaceAll(Chr(13), Chr(10))
		  Sp()=RL.Split(Chr(10))
		  If Sp.Count <= 0 Then Return OrigScript ' Empty File or no header
		  For I = 0 To Sp().Count -1
		    
		    'Filter out lines with Wrong Arch
		    If Sp(I).IndexOf(0, "#Is_x86#") >= 0 Then
		      If SysArchitecture = "x86" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        Continue 'Skip lines with wrong Arch
		      End If
		    End If
		    
		    If Sp(I).IndexOf(0, "#Is_x64#") >= 0 Then
		      If SysArchitecture = "x64" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        Continue 'Skip lines with wrong Arch
		      End If
		    End If
		    
		    If Sp(I).IndexOf(0, "#Is_ARM#") >= 0 Then
		      If SysArchitecture = "ARM" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        Continue 'Skip lines with wrong Arch
		      End If
		    End If
		    
		    'Filter Gateways and Directives
		    Sp(I) = Sp(I).ReplaceAll("#Is_x86#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_x64#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_ARM#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_NT5#","") 'Clean unrequired text 'NT check not yet added to this method so will just use all by default, may cause issues?
		    Sp(I) = Sp(I).ReplaceAll("#Is_NT6#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_NT10#","") 'Clean unrequired text
		    
		    
		    ScriptContent = ScriptContent + ExpPathReg(Sp(I), True) + Chr(10)
		  Next I
		  
		  SaveDataToFile (ScriptContent, ScriptFile)
		  
		  Return ScriptFile
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpScript(OrigScript As String, MakeSudo As Boolean = False) As String
		  Dim F As FolderItem
		  Dim RL As String
		  Dim I As Integer
		  
		  Dim ScriptContent As String
		  Dim ScriptFile As String
		  Dim SP() As String
		  
		  Dim ScriptPath As String
		  ScriptPath = Slash(FixPath(TmpPath+"scripts" + Randomiser.InRange(10000, 20000).ToString))
		  MkDir(ScriptPath)
		  
		  F = GetFolderItem(OrigScript, FolderItem.PathTypeNative)
		  
		  If Right(OrigScript,3) = ".sh" Then
		    ScriptFile = ScriptPath+"Expanded_Script.sh"
		  Else
		    'ScriptFile = Slash(FixPath(F.Parent.NativePath)+"Expanded_Script.cmd") 'Use InstallFrom folder, not Temp
		    ScriptFile = ScriptPath+"Expanded_Script.cmd"
		  End If
		  
		  If MakeSudo Then 'Make it ready to run from Sudo directly
		    ScriptFile = BaseDir+"/Expanded_Script.sh"
		  End If
		  
		  'Load in whole file at once (Fastest Method)
		  Try
		    inputStream = TextInputStream.Open(F)
		    
		    While Not inputStream.EndOfFile 'If Empty file this skips it
		      RL = inputStream.ReadAll
		    Wend
		    inputStream.Close
		  Catch
		  End Try
		  RL = RL.ReplaceAll(Chr(13), Chr(10))
		  Sp()=RL.Split(Chr(10))
		  If Sp.Count <= 0 Then Return OrigScript ' Empty File or no header
		  
		  'Inject LLScript_Core source into .sh scripts that don't already have it.
		  'This gives old LLApp/LLGame scripts updated DE detection (reads LLDesktopEnv.ini)
		  'and exports XDG_SESSION_DESKTOP so old case statements work correctly under sudo.
		  'Note: old scripts that define inst() inline will still override the core inst()
		  'below the injection point - this is expected and safe, their inst() still works.
		  If Right(OrigScript, 3) = ".sh" And Not TargetWindows Then
		    If InStr(RL, "LLScript_Core") = 0 Then 'Only inject if not already sourcing the core
		      '%ToolPath% is resolved by ExpPathScript (called per-line below) to wherever LLStore
		      'is currently running from - USB or installed. The /LastOS/LLStore/ path is the
		      'fallback for when LLStore is installed and ToolPath matches it anyway, but it also
		      'covers edge cases where the core file exists installed but ToolPath pointed elsewhere.
		      Dim CoreName As String
		      If MakeSudo Then
		        CoreName = "LLScript_Sudo_Core.sh"
		      Else
		        CoreName = "LLScript_Core.sh"
		      End If
		      Dim Q As String = Chr(34)
		      'Try /LastOS/LLStore/Tools/ first - stable installed path, works when user runs script manually.
		      'Fall back to %ToolPath%/ (USB/portable path resolved at install time) if not installed.
		      Dim CoreSourceLine As String = "if [ -f "+Q+"%ToolPath%/"+CoreName+Q+" ]; then source "+Q+"%ToolPath%/"+CoreName+Q+"; elif [ -f "+Q+"/LastOS/LLStore/Tools/"+CoreName+Q+" ]; then source "+Q+"/LastOS/LLStore/Tools/"+CoreName+Q+"; fi #LLCore"
		      'Insert at index 1 (after shebang) so it runs before any other script content.
		      'The cd injection at I=1 means the actual execution order is: shebang, cd, source.
		      Dim NewSp() As String
		      NewSp.Add(Sp(0)) 'Keep shebang as first line
		      NewSp.Add(CoreSourceLine) 'Source the core immediately after shebang
		      For Idx As Integer = 1 To Sp.Count - 1
		        NewSp.Add(Sp(Idx))
		      Next Idx
		      Sp = NewSp
		    End If
		  End If
		  
		  For I = 0 To Sp().Count -1
		    If InstallToPath <> "" Then 'Only add CD if it's a valid path given ' We use InstallToPath even on NoInstalls as I set that path to be InstallFromPath.
		      If I = 1 Then
		        If Sp(I) <> "" Then
		          ScriptContent = ScriptContent + Chr(10) 'Adds space Line
		          If ItemLLItem.BuildType = "ssApp"Then
		            ScriptContent = ScriptContent + "cd "+Chr(34)+InstallFromPath+Chr(34)+Chr(10) 'Add cd to top of scripts so it runs from the right locations
		          Else
		            ScriptContent = ScriptContent + "cd "+Chr(34)+InstallToPath+Chr(34)+Chr(10) 'Add cd to top of scripts so it runs from the right locations
		          End If
		        Else
		          ScriptContent = ScriptContent + Chr(10) 'Adds space Line
		          If ItemLLItem.BuildType = "ssApp"Then
		            ScriptContent = ScriptContent + "cd "+Chr(34)+InstallFromPath+Chr(34)+Chr(10) 'Add cd to top of scripts so it runs from the right locations
		          Else
		            ScriptContent = ScriptContent + "cd "+Chr(34)+InstallToPath+Chr(34)+Chr(10) 'Add cd to top of scripts so it runs from the right locations
		          End If
		          Continue 'No Need to add a 2nd space line below
		        End If
		      End If
		    End If
		    
		    'Filter wrong arch lines out
		    If Sp(I).IndexOf(0, "#Is_x86#") >= 0 Then
		      If SysArchitecture = "x86" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        Continue 'Skip lines with wrong Arch
		      End If
		    End If
		    
		    If Sp(I).IndexOf(0, "#Is_x64#") >= 0 Then
		      If SysArchitecture = "x64" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        Continue 'Skip lines with wrong Arch
		      End If
		    End If
		    
		    If Sp(I).IndexOf(0, "#Is_ARM#") >= 0 Then
		      If SysArchitecture = "ARM" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        Continue 'Skip lines with wrong Arch
		      End If
		    End If
		    
		    'Filter Gateways and Directives
		    Sp(I) = Sp(I).ReplaceAll("#Is_x86#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_x64#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_ARM#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_NT5#","") 'Clean unrequired text 'NT check not yet added to this method so will just use all by default, may cause issues?
		    Sp(I) = Sp(I).ReplaceAll("#Is_NT6#","") 'Clean unrequired text
		    Sp(I) = Sp(I).ReplaceAll("#Is_NT10#","") 'Clean unrequired text
		    
		    ScriptContent = ScriptContent + ExpPathScript(Sp(I), True) + Chr(10)
		  Next I
		  
		  SaveDataToFile (ScriptContent, ScriptFile)
		  
		  MakeAllExec(ScriptFile)
		  
		  Return ScriptFile
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Extract(Archive As String, OutPath As String, ExcludesIncludes As String) As Boolean
		  If Debugging Then Debug("--- Starting Extract ---")
		  Dim Commands As String
		  Dim F As FolderItem
		  Dim AssemblyFile, AssemblyContent As String
		  
		  If Not Exist(Archive) Then Return False 'Failed, not found
		  If OutPath = "" Then Return False 'No Dest set
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = -1 'Give it All the time it needs
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim Zip As String
		  Zip = Linux7z
		  if TargetWindows Then Zip = Win7z
		  
		  'Make sure there is a space in the excludes/includes
		  If ExcludesIncludes <> "" Then
		    If Left(ExcludesIncludes,1) <>" " Then ExcludesIncludes = " "+ ExcludesIncludes
		  End If
		  
		  'Make the OutPath so it has somewhere to extract in to
		  If Not Exist(OutPath) Then MakeFolder(OutPath)
		  If Exist(OutPath) Then 'Only do it if somewhere to go
		    If Right(Archive,4) = ".tar" Then
		      Sh.Execute (Zip + " -mtc -aoa x "+Chr(34)+Archive+Chr(34)+ " -o"+Chr(34) + OutPath+Chr(34)+ExcludesIncludes)
		      Dim ExBuf1 As String = ""
		      Do
		        App.DoEvents(20)
		        ExBuf1 = ExBuf1 + Sh.ReadAll 'Drain stdout to prevent pipe buffer deadlock (7z prints every filename)
		      Loop Until Sh.IsRunning = False
		      ExBuf1 = ExBuf1 + Sh.ReadAll 'Capture any remaining output
		      If Debugging Then Debug(ExBuf1)
		    Else
		      If Right(Archive,3) = ".gz" Then
		        Sh.Execute ("tar -xf " + Chr(34) + Archive + Chr(34) + " -C " + Chr(34) + OutPath + Chr(34) + ExcludesIncludes)
		        Dim ExBuf2 As String = ""
		        Do
		          App.DoEvents(20)
		          ExBuf2 = ExBuf2 + Sh.ReadAll 'Drain stdout to prevent pipe buffer deadlock
		        Loop Until Sh.IsRunning = False
		        ExBuf2 = ExBuf2 + Sh.ReadAll 'Capture any remaining output
		        If Debugging Then Debug(ExBuf2)
		      Else 'Just treat it as a standard non Linux zip, 7z etc works fine for this as it doesn't need to handle symlinks (7z can't extract tar.gz files)
		        Commands = Zip + " -mtc -aoa x "+Chr(34)+Archive+Chr(34)+ " -o"+Chr(34) + OutPath+Chr(34)+ExcludesIncludes
		        If TargetWindows Then
		          RunCommand (Commands)
		        Else'Linux
		          Sh.Execute (Commands)
		          Dim ExBuf3 As String = ""
		          Do
		            App.DoEvents(20)
		            ExBuf3 = ExBuf3 + Sh.ReadAll 'Drain stdout to prevent pipe buffer deadlock
		          Loop Until Sh.IsRunning = False
		          ExBuf3 = ExBuf3 + Sh.ReadAll 'Capture any remaining output
		          If Debugging Then Debug(ExBuf3)
		        End If
		      End If
		    End If
		    MakeAllExec(OutPath)
		    Return True 'Succeeded maybe?
		  End If
		  
		  Return False 'Failed <- For now to save trying to load dead items, return True to load them
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FileExistsDUD(InTXT As String) As Boolean
		  'Returns a True or False of if a File or Folder exists
		  If TargetWindows Then
		    If InTXT <> "" Then
		      Declare Function GetFileAttributes Lib "kernel32" Alias "GetFileAttributesA" (lpFileName As CString) As Integer
		      
		      If GetFileAttributes (InTXT) <> -1 Then
		        Return True
		      End If
		    End If
		  End If
		  Return False 'Return False if Empty file given or Not found
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FixCatalog(CatIn As String) As String
		  Dim Game As Boolean
		  If CatIn.IndexOf("Game") >=0 Then Game = True
		  
		  CatIn = CatIn.ReplaceAll("Games"+Chr(92), "")
		  CatIn = CatIn.ReplaceAll("Gamess", "Games")
		  CatIn = CatIn.ReplaceAll("|", "; ")
		  CatIn = CatIn.Trim
		  If Right (CatIn,1) <>";" Then CatIn=CatIn+";"
		  CatIn = CatIn.ReplaceAll("Games;", "Game;")
		  If Left(CatIn, 6) = "Game; " Then CatIn = Right (CatIn, Len(CatIn) -6) 'Remove Game; from the start so looks nicer in the MetaData fields, Gets Added to end below too
		  If Left(CatIn, 5) = "Game " Then CatIn = Right (CatIn, Len(CatIn) -5) 'Remove Game  from the start of some cats (Not sure what adds them, but take them out)
		  CatIn = CatIn.ReplaceAll("  ", " ") 'Remove Double Spaces
		  
		  CatIn = CatIn.ReplaceAll("First-Person Shooter", "FirstPersonShooter")
		  CatIn = CatIn.ReplaceAll("Third-Person Shooter", "ThirdPersonShooter")
		  CatIn = CatIn.ReplaceAll("Hidden Object", "HiddenObject")
		  CatIn = CatIn.ReplaceAll("Role Playing", "RolePlaying")
		  CatIn = CatIn.ReplaceAll("RollPlaying", "RolePlaying")
		  CatIn = CatIn.ReplaceAll("Racing-Driving", "Racing; Driving")
		  CatIn = CatIn.ReplaceAll("Tower Defense", "TowerDefense")
		  CatIn = CatIn.ReplaceAll("Farming & Crafting", "Farming; Crafting")
		  
		  
		  CatIn = CatIn.ReplaceAll("Mini Game", "Game")
		  CatIn = CatIn.ReplaceAll("MiniGame", "Game")
		  CatIn = CatIn.ReplaceAll("ppGame", "Game")
		  
		  If CatIn = "" Then ' If Empty then it's a game, just say so
		    if Game = True Then CatIn = "Game; "
		  End If
		  Return CatIn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FixEOL(StrIn As String) As String
		  StrIn = StrIn.ReplaceAll(Chr(10), Chr(30))
		  StrIn = StrIn.ReplaceAll(Chr(13), Chr(30))
		  StrIn = StrIn.ReplaceAll(EndOfLine, Chr(30))
		  Return StrIn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FixGameCats(CatIn As String) As String
		  CatIn = CatIn.ReplaceAll("Games"+Chr(92), "")
		  CatIn = CatIn.ReplaceAll("Gamess", "Games")
		  CatIn = CatIn.ReplaceAll("|", "; ")
		  CatIn = CatIn.Trim
		  If Right (CatIn,1) <>";" Then CatIn=CatIn+";"
		  
		  CatIn = CatIn.ReplaceAll("Games;", "Game;")
		  If Left(CatIn, 6) = "Game; " Then CatIn = Right (CatIn, Len(CatIn) -6) 'Remove Game; from the start so looks nicer in the MetaData fields, Gets Added to end below too
		  If Left(CatIn, 5) = "Game " Then CatIn = Right (CatIn, Len(CatIn) -5) 'Remove Game  from the start of some cats (Not sure what adds them, but take them out)
		  CatIn = CatIn.ReplaceAll("  ", " ") 'Remove Double Spaces
		  
		  CatIn = CatIn.ReplaceAll("First-Person Shooter", "FirstPersonShooter")
		  CatIn = CatIn.ReplaceAll("Third-Person Shooter", "ThirdPersonShooter")
		  CatIn = CatIn.ReplaceAll("Hidden Object", "HiddenObject")
		  CatIn = CatIn.ReplaceAll("Role Playing", "RolePlaying")
		  CatIn = CatIn.ReplaceAll("RollPlaying", "RolePlaying")
		  CatIn = CatIn.ReplaceAll("Racing-Driving", "Racing; Driving")
		  CatIn = CatIn.ReplaceAll("Tower Defense", "TowerDefense")
		  CatIn = CatIn.ReplaceAll("Farming & Crafting", "Farming; Crafting")
		  
		  Return CatIn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FixPath(InnPath As String) As String
		  InnPath = InnPath.ReplaceAll("\","/")
		  Return InnPath
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetCatalogRedirects()
		  Dim F As FolderItem
		  Dim Sp() As String
		  Dim RL As String
		  Dim I, J As Integer
		  Dim LineID, LineData As String
		  Dim LDSplit() As String
		  
		  Dim Test As String
		  
		  RedirectAppCount = 0
		  
		  F = GetFolderItem (Slash(ToolPath)+"MenuCatalogApps_Redirects.ini", FolderItem.PathTypeNative)
		  
		  'Load in whole file at once (Fastest Method)
		  If F.Exists Then
		    Try
		      inputStream = TextInputStream.Open(F)
		      While Not inputStream.EndOfFile 'If Empty file this skips it
		        RL = inputStream.ReadAll
		      Wend
		      inputStream.Close
		    Catch
		    End Try
		    RL = RL.ReplaceAll(Chr(13), Chr(10))
		    RL = RL.ReplaceAll(Chr(10)+Chr(10), Chr(10)) ' Remove Duplicate Chr(10)'s
		    Sp()=RL.Split(Chr(10))
		    If Sp.Count >= 1 Then 
		      For I = 0 To Sp.Count - 1
		        Sp(I) = Sp(I).Trim
		        If Sp(I)<>"" Then 'Don't do Empty Lines
		          If InStrRev(Sp(I),"=") >=1 Then
		            LineID = Left(Sp(I),InStrRev(Sp(I),"="))
		            LineData = Right(Sp(I),Len(Sp(I))-InStrRev(Sp(I),"="))
		            LineData=LineData.Trim
		            LineID = Left(LineID, Len(LineID)-1) 'Remove Equals
		            LDSplit() =LineData.Split("|") 
		            If LDSplit.Count >= 1 Then
		              For J = 0 To LDSplit.Count - 1
		                ' Check bounds before adding
		                If RedirectAppCount >= 1024 Then
		                  Debug("RedirectsApp array is full. Skipping: " + LDSplit(J))
		                  Exit For  ' Stop adding more items
		                End If
		                
		                RedirectsApp(RedirectAppCount,0) = LDSplit(J)
		                RedirectsApp(RedirectAppCount,1) = LineID
		                RedirectAppCount = RedirectAppCount + 1
		              Next J
		              
		            Else 'Only one item
		              RedirectsApp(RedirectAppCount,0) = LineData
		              RedirectsApp(RedirectAppCount,1) = LineID
		              RedirectAppCount = RedirectAppCount + 1
		            End If
		            
		          Else 'No Equals, just add itself and make it = Itself
		            RedirectsApp(RedirectAppCount,0) = Sp(I)
		            RedirectsApp(RedirectAppCount,1) = Sp(I)
		            RedirectAppCount = RedirectAppCount + 1
		          End If
		        End If
		      Next I
		    End If
		  End If
		  
		  F = GetFolderItem (Slash(ToolPath)+"MenuCatalogGames_Redirects.ini", FolderItem.PathTypeNative)
		  
		  RedirectGameCount = 0
		  
		  'Load in whole file at once (Fastest Method)
		  If F.Exists Then
		    Try
		      inputStream = TextInputStream.Open(F)
		      While Not inputStream.EndOfFile 'If Empty file this skips it
		        RL = inputStream.ReadAll
		      Wend
		      inputStream.Close
		    Catch
		    End Try
		    RL = RL.ReplaceAll(Chr(13), Chr(10))
		    RL = RL.ReplaceAll(Chr(10)+Chr(10), Chr(10)) ' Remove Duplicate Chr(10)'s
		    Sp()=RL.Split(Chr(10))
		    If Sp.Count >= 1 Then 
		      For I = 0 To Sp.Count - 1
		        Sp(I) = Sp(I).Trim
		        If Sp(I)<>"" Then 'Don't do Empty Lines
		          If InStrRev(Sp(I),"=") >=1 Then
		            LineID = Left(Sp(I),InStrRev(Sp(I),"="))
		            LineData = Right(Sp(I),Len(Sp(I))-InStrRev(Sp(I),"="))
		            LineData=LineData.Trim
		            LineID = Left(LineID, Len(LineID)-1) 'Remove Equals
		            LDSplit() =LineData.Split("|") 
		            If LDSplit.Count >= 1 Then
		              For J = 0 To LDSplit.Count - 1
		                RedirectsGame(RedirectGameCount,0) = LDSplit(J)
		                RedirectsGame(RedirectGameCount,1) = LineID
		                RedirectGameCount = RedirectGameCount + 1
		              Next J
		              
		            Else 'Only one item
		              RedirectsGame(RedirectGameCount,0) = LineData
		              RedirectsGame(RedirectGameCount,1) = LineID
		              RedirectGameCount = RedirectGameCount + 1
		            End If
		            
		          Else 'No Equals, just add itself and make it = Itself
		            RedirectsGame(RedirectGameCount,0) = Sp(I)
		            RedirectsGame(RedirectGameCount,1) = Sp(I)
		            RedirectGameCount = RedirectGameCount + 1
		          End If
		        End If
		      Next I
		    End If
		  End If
		  
		  
		  
		  MenuWindowsCount = 0
		  F = GetFolderItem (Slash(ToolPath)+"MenuWindows.ini", FolderItem.PathTypeNative)
		  
		  'Load in whole file at once (Fastest Method)
		  If F.Exists Then
		    Try
		      inputStream = TextInputStream.Open(F)
		      While Not inputStream.EndOfFile 'If Empty file this skips it
		        RL = inputStream.ReadAll
		      Wend
		      inputStream.Close
		    Catch
		    End Try
		    RL = RL.ReplaceAll(Chr(13), Chr(10))
		    RL = RL.ReplaceAll(Chr(10)+Chr(10), Chr(10)) ' Remove Duplicate Chr(10)'s
		    Sp()=RL.Split(Chr(10))
		    If Sp.Count >= 1 Then 
		      For I = 0 To Sp.Count - 1
		        Sp(I) = Sp(I).Trim
		        If Sp(I)<>"" Then 'Don't do Empty Lines
		          If InStrRev(Sp(I),"=") >=1 Then
		            LineID = Left(Sp(I),InStrRev(Sp(I),"="))
		            LineData = Right(Sp(I),Len(Sp(I))-InStrRev(Sp(I),"="))
		            LineData=LineData.Trim
		            LineID = Left(LineID, Len(LineID)-1) 'Remove Equals
		            LDSplit() =LineData.Split("|") 
		            If LDSplit.Count >= 1 Then
		              For J = 0 To LDSplit.Count - 1
		                MenuWindows(MenuWindowsCount,0) = LineID
		                MenuWindows(MenuWindowsCount,1) = LDSplit(J)
		                MenuWindowsCount = MenuWindowsCount + 1
		              Next J
		              
		            Else 'Only one item
		              MenuWindows(MenuWindowsCount,0) = LineID
		              MenuWindows(MenuWindowsCount,1) = LineData
		              MenuWindowsCount = MenuWindowsCount + 1
		            End If
		            
		          Else 'No Equals, just add itself and make it = Itself
		            MenuWindows(MenuWindowsCount,0) = Sp(I)
		            MenuWindows(MenuWindowsCount,1) = Sp(I)
		            MenuWindowsCount = MenuWindowsCount + 1
		          End If
		        End If
		      Next I
		    End If
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetExistingppFolder(GetType As String) As String
		  Declare Function SetErrorMode Lib "Kernel32" (mode As Integer) As Integer
		  Dim oldMode As Integer 
		  If TargetWindows Then
		    Const SEM_FAILCRITICALERRORS = &h1
		    oldMode = SetErrorMode( SEM_FAILCRITICALERRORS )
		  Else
		    oldMode = 0
		  End If
		  Dim reg As registryItem
		  Dim Ret As String
		  Dim I, A As Integer
		  Dim F As FolderItem
		  
		  #Pragma BreakOnExceptions Off
		  Try
		    reg = new registryItem(RegKeyHKLMccsWin) 'RegKeyHKLMccsWin = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows"
		    reg.Value("ErrorMode") = 2
		  Catch
		  End Try
		  
		  Ret = ""
		  A = Asc("Z")
		  
		  Dim Test, Drive As String
		  
		  Try
		    For I = 0 To 23
		      Drive = Chr(A-I)+":"
		      Test = Drive+"\"+GetType
		      'MsgBox(Test)
		      
		      If Exist (Test) Then
		        F = GetFolderItem(Drive+"\ppWritable.ini", FolderItem.PathTypeNative)
		        If F.IsWriteable And WritableLocation(F) Then
		          Ret = Drive
		          'MsgBox(Ret)
		          Exit For I
		        End If
		      End If
		    Next I
		  Catch
		  End Try
		  
		  If Ret = "" Then Ret = SysDrive ' Default to SysDrive ' so works with LivePE's etc
		  If Ret = "" Then Ret = "C:" ' Default to C: 'If SysDrive is blank, set it to C:
		  
		  If TargetWindows Then Call SetErrorMode( oldMode )
		  #Pragma BreakOnExceptions Off
		  Try
		    reg = new registryItem(RegKeyHKLMccsWin) 'RegKeyHKLMccsWin = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows"
		    reg.Value("ErrorMode") = 0
		  Catch
		  End Try
		  #Pragma BreakOnExceptions Default
		  Return Ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFileAgeInSeconds(filePath As String) As Double
		  // Get the file as a FolderItem
		  'Dim f As FolderItem = New FolderItem(filePath)
		  Dim F As FolderItem
		  F = GetFolderItem(filePath,FolderItem.PathTypeNative)
		  
		  // Check if file exists
		  If Not f.Exists Then
		    'Return -1 // File doesn't exist
		    Return 999 'Force Download DB's
		  End If
		  
		  // Get current date/time
		  Dim currentDate As DateTime = DateTime.Now
		  
		  // Calculate the difference in seconds
		  'Dim timeDiff As Double = currentDate.SecondsFrom1970 - creationDate.SecondsFrom1970
		  
		  Dim timeDiff As Double
		  
		  timeDiff = currentDate.Day - f.ModificationDateTime.Day
		  
		  If timeDiff >= 1 Then Return 999 'Force Refresh if it's over a day, ANY day.
		  
		  timeDiff = currentDate.Hour - f.ModificationDateTime.Hour
		  
		  timeDiff = timeDiff * 60
		  
		  timeDiff = timeDiff + currentDate.Minute - f.ModificationDateTime.Minute
		  
		  'MsgBox timeDiff.ToString
		  
		  Return timeDiff
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFolderSize(FolderIn As String) As Integer
		  Var folder As FolderItem = GetFolderItem(FolderIn,FolderItem.PathTypeNative)
		  
		  If folder <> Nil Then
		    Var sizeKB As UInt64 = GetFolderSizeKB(folder)
		    'MessageBox("Total size: " + sizeKB.ToString + " KB")
		    Return sizeKB
		  End If
		  
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFolderSizeBytes(f As FolderItem) As UInt64
		  Var total As UInt64 = 0
		  
		  If f = Nil Or Not f.Exists Then Return 0
		  
		  If f.IsFolder Then
		    Try
		      For Each child As FolderItem In f.Children
		        total = total + GetFolderSizeBytes(child)
		      Next
		    Catch e As RuntimeException
		      // Ignore permission errors
		    End Try
		  Else
		    total = f.Length
		  End If
		  
		  Return total
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFolderSizeKB(f As FolderItem) As UInt64
		  Var totalBytes As UInt64 = 0
		  
		  If f = Nil Or Not f.Exists Then Return 0
		  
		  If f.IsFolder Then
		    Try
		      For Each item As FolderItem In f.Children
		        totalBytes = totalBytes + GetFolderSizeBytes(item)
		      Next
		    Catch e As RuntimeException
		      // Skip folders we can't access
		    End Try
		  Else
		    totalBytes = f.Length
		  End If
		  
		  Return totalBytes \ 1024
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFullParent(PatIn As String) As String
		  PatIn = PatIn.ReplaceAll("\","/") 'If using Linux paths, use linux paths
		  PatIn = Left(PatIn,InStrRev(PatIn,"/")) 'Gets Parent Path
		  
		  Return PatIn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLongPath(InPath As String) As String
		  'Returns a Long Path from a Short path
		  
		  Declare Function GetLongPathNameA Lib "Kernel32" ( lpShortPath As CString, lpLongPath As Ptr, bufferLength As Integer ) As Integer
		  Dim Buff As New MemoryBlock (4096)
		  Dim BuffLen As Integer
		  Dim Ret As String
		  
		  BuffLen = GetLongPathNameA (InPath, Buff, 4096)
		  Ret = Buff
		  
		  Ret = Left(Ret, BuffLen)
		  If  Ret = "" Then Ret = InPath 'if it already was a long path, just return the in path
		  
		  Return Ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetParent(InFile As String) As String
		  InFile = InFile.ReplaceAll("/","\")
		  InFile = Left(InFile,InStrRev(InFile,"\")-1)
		  
		  If TargetWindows Then
		  Else
		    InFile = InFile.ReplaceAll("\","/") 'Linux needs the other Slash
		  End If
		  
		  Return InFile
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShortcut(LnkFile As String) As Shortcut
		  If Debugging Then Debug("--- Starting Get Shortcut ---")
		  
		  Dim Link As Shortcut
		  
		  'Get Link Details to return
		  #Pragma BreakOnExceptions Off
		  Try
		    If TargetWindows Then
		      
		      
		      Dim lnkObj As OLEObject
		      Dim scriptShell As New OLEObject("{F935DC22-1CF0-11D0-ADB9-00C04FD58A0B}")
		      
		      If scriptShell <> Nil then
		        lnkObj = scriptShell.CreateShortcut(LnkFile)
		        If lnkObj <> Nil then
		          Link.Description = lnkObj.Description
		          Link.TargetPath = lnkObj.TargetPath
		          Link.Arguments = lnkObj.Arguments
		          Link.WorkingDirectory = lnkObj.WorkingDirectory
		          Link.IconLocation = lnkObj.IconLocation
		          Link.Hotkey = lnkObj.Hotkey
		          Link.WindowStyle = lnkObj.WindowStyle
		          '''''DONT Save Lnk file - we are only reading it
		          '''''lnkObj.Save
		        Else
		        End If
		      End If
		    End If
		    Return Link
		  Catch
		  End Try
		  Return Link
		  #Pragma BreakOnExceptions On
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Installing(FileIn As String) As Boolean
		  ' Step 2 of the two-phase install for CommandLine (StoreMode=2).
		  ' Called by Loading.InstallTimer.Action after PrepareToInstall() returned True.
		  ' Does the full install: LoadLLFile (extraction), updates notification with real
		  ' title+icon, then performs all the actual installation steps.
		  
		  If Debugging Then Debug("--- Starting Installing() [PrepareToInstall flow] ---")
		  
		  If TargetWindows Then
		    FileIn = FileIn.ReplaceAll("/", "\")
		  End If
		  If FileIn.Trim = "" Then Return False
		  
		  Dim TempScriptData As String
		  Dim Suc As Boolean
		  Dim Success As Boolean
		  Dim Shelly As New Shell
		  
		  Dim FileToExtract, MainFileToExtract As String
		  
		  Shelly.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  Shelly.TimeOut = -1
		  
		  ' Clear temp path in case it fails to load
		  ItemTempPath = ""
		  
		  ' Load/extract the LLFile — this is the slow step
		  Success = LoadLLFile(FileIn, "", True)
		  If Debugging Then Debug("Installing - Loaded File: " + FileIn + " ItemTempPath: " + ItemTempPath + " Good: " + Success.ToString)
		  
		  If Success = False Then
		    LogInstall("FAIL", "LoadLLFile failed for file: " + FileIn)
		    Return False
		  End If
		  
		  MakeFolder(Slash(HomePath) + ".local/share/applications")
		  
		  ' Now that we have the real title and icon, update the notification
		  Notify("LLStore Installing", "Installing " + ItemLLItem.BuildType + ":-" + Chr(10) + ItemLLItem.TitleName, ItemLLItem.FileIcon, -1)
		  Notification.Refresh(True)
		  App.DoEvents(50)
		  If Not TargetWindows Then
		    RunCommand("notify-send --hint=int:transient:1 " + Chr(34) + "Installing " + ItemLLItem.BuildType + ":-" + Chr(10) + ItemLLItem.TitleName + Chr(34))
		  End If
		  Notification.Refresh(True)
		  App.DoEvents(30)
		  
		  ' No PathApp or Nonething = NoInstall (scripts only, nothing to extract/copy)
		  If ItemLLItem.PathApp.Trim = "" Or ItemLLItem.PathApp.IndexOf("Nonething") >= 0 Then ItemLLItem.NoInstall = True
		  
		  ' Make sure Sudo is available during install
		  Select Case ItemLLItem.BuildType
		  Case "ssApp", "ppApp", "ppGame"
		  Case Else
		    If SudoAsNeeded = False Then EnableSudoScript
		  End Select
		  
		  If TempInstall = "" Then
		    InstallFromPath = GetFullParent(FileIn)
		  Else
		    InstallFromPath = ItemTempPath
		  End If
		  
		  If Debugging Then Debug("Installing From Path: " + InstallFromPath)
		  
		  Dim TempString As String
		  TempString = ItemLLItem.PathINI
		  ItemLLItem.PathINI = InstallFromPath
		  
		  If Debugging Then Debug("No Install: " + ItemLLItem.NoInstall.ToString)
		  
		  If ItemLLItem.NoInstall = False Then
		    
		    'On Linux, if this SS item has a Linux .desktop link, install to LLGames/LLApps instead of Wine paths
		    'PathApp is already expanded by LoadLLFile (e.g. /home/user/.wine/drive_c/ppGames/Title)
		    'so we remap the expanded Wine paths to native LLGames/LLApps paths directly
		    Dim AppPathToInstall As String = ItemLLItem.PathApp
		    If TargetLinux And (ItemLLItem.BuildType = "ppGame" Or ItemLLItem.BuildType = "ppApp" Or ItemLLItem.BuildType = "ssApp") And HasLinuxDesktopLink() Then
		      AppPathToInstall = AppPathToInstall.ReplaceAll(NoSlash(ppGames), NoSlash(Slash(HomePath)+"LLGames"))
		      AppPathToInstall = AppPathToInstall.ReplaceAll(NoSlash(ppApps), NoSlash(Slash(HomePath)+"LLApps"))
		    End If
		    InstallToPath = Slash(AppPathToInstall) 'Already expanded; no need to call ExpPath again
		    If Debugging Then Debug("Installing To Path: " + InstallToPath)
		    
		    If ChDirSet(InstallFromPath) = True Then
		    End If
		    
		    If SkippedInstalling = True Then
		      LogInstall("Skipped", "Install skipped before assembly: " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    RunAssembly
		    
		    If SkippedInstalling = True Then
		      LogInstall("Skipped", "Install skipped after assembly: " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    Dim Inst2 As String
		    If Not Exist(InstallToPath) Then
		      Inst2 = InstallToPath.ReplaceAll("Program Files", "Program Files (x86)")
		      If Exist(Inst2) Then InstallToPath = Inst2
		    End If
		    
		    MakeFolder(InstallToPath)
		    
		    If ItemLLItem.BuildType = "LLApp" Then FileToExtract = Slash(InstallFromPath) + "LLApp.tar.gz"
		    If ItemLLItem.BuildType = "LLGame" Then FileToExtract = Slash(InstallFromPath) + "LLGame.tar.gz"
		    If ItemLLItem.BuildType = "ppApp" Then FileToExtract = Slash(InstallFromPath) + "ppApp.7z"
		    If ItemLLItem.BuildType = "ppGame" Then FileToExtract = Slash(InstallFromPath) + "ppGame.7z"
		    
		    If FileToExtract <> "" Then
		      If Exist(FileToExtract) Then
		        MainFileToExtract = FileToExtract
		        Success = Extract(FileToExtract, InstallToPath, "")
		        If Not Success Then
		          LogInstall("FAIL", "Archive extraction failed for " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "] File: " + FileToExtract)
		          Return False
		        End If
		      End If
		    End If
		    
		    If SkippedInstalling = True Then Return False
		    
		    FileToExtract = Slash(InstallFromPath) + "Patch.7z"
		    If FileToExtract <> "" Then
		      If Exist(FileToExtract) Then
		        Success = Extract(FileToExtract, InstallToPath, "")
		      End If
		    End If
		    
		    If SkippedInstalling = True Then Return False
		    
		    If ItemLLItem.BuildType = "ssApp" Then MainFileToExtract = "NO"
		    If ItemLLItem.NoInstall = True Then MainFileToExtract = "NO"
		    
		    If TargetWindows Then
		      If InstallFromPath.IndexOf("ppAppsLive") >= 1 Or MainFileToExtract = "" Then
		        XCopy(InstallFromPath.ReplaceAll("/", "\"), InstallToPath.ReplaceAll("/", "\"))
		      Else
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".app", Slash(InstallToPath) + ItemLLItem.BuildType + ".app")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".ppg", Slash(InstallToPath) + ItemLLItem.BuildType + ".ppg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".reg", Slash(InstallToPath) + ItemLLItem.BuildType + ".reg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".cmd", Slash(InstallToPath) + ItemLLItem.BuildType + ".cmd")
		        CopyWild(Slash(InstallFromPath) + "*.jpg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.png", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.ico", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.svg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.mp4", Slash(InstallToPath))
		      End If
		      If Exist(Slash(InstallToPath) + ItemLLItem.BuildType + ".ico") Then
		        MakeFolderIcon(InstallToPath, Slash(InstallToPath) + ItemLLItem.BuildType + ".ico")
		      End If
		    Else
		      If InstallFromPath.IndexOf("ppAppsLive") >= 1 Or MainFileToExtract = "" Then
		        Shelly.Execute("cp -rf " + Chr(34) + Slash(InstallFromPath) + "." + Chr(34) + " " + Chr(34) + InstallToPath + Chr(34))
		        Do
		          App.DoEvents(20)
		        Loop Until Shelly.IsRunning = False
		      Else
		        Suc = Copy(Slash(InstallFromPath) + "LLScript.sh", Slash(InstallToPath) + "LLScript.sh")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".app", Slash(InstallToPath) + ItemLLItem.BuildType + ".app")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".ppg", Slash(InstallToPath) + ItemLLItem.BuildType + ".ppg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".reg", Slash(InstallToPath) + ItemLLItem.BuildType + ".reg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".cmd", Slash(InstallToPath) + ItemLLItem.BuildType + ".cmd")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".lla", Slash(InstallToPath) + ItemLLItem.BuildType + ".lla")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType + ".llg", Slash(InstallToPath) + ItemLLItem.BuildType + ".llg")
		        CopyWild(Slash(InstallFromPath) + "*.jpg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.png", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.ico", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.svg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.mp4", Slash(InstallToPath))
		        
		        If ItemLLItem.BuildType = "LLGame" Then
		          Do
		            App.DoEvents(20)
		          Loop Until Shelly.IsRunning = False
		        End If
		        If ItemLLItem.BuildType = "ppGame" Then
		          Do
		            App.DoEvents(20) 
		          Loop Until Shelly.IsRunning = False
		        End If
		        If ItemLLItem.BuildType = "ppApp" Then
		          Do 
		            App.DoEvents(20) 
		          Loop Until Shelly.IsRunning = False
		        End If
		        If ItemLLItem.BuildType = "ssApp" Then
		          If Not TargetWindows Then
		            ShellFast.Execute("chmod 775 " + Chr(34) + Slash(InstallToPath) + "*.cmd" + Chr(34))
		            If Debugging Then Debug("Shell Fast Execute: chmod 775 " + Chr(34) + Slash(InstallToPath) + "*.cmd" + Chr(34) + Chr(10) + "Results: " + ShellFast.ReadAll)
		            ShellFast.Execute("chmod 775 " + Chr(34) + Slash(InstallToPath) + "*.sh" + Chr(34))
		            If Debugging Then Debug("Shell Fast Execute: chmod 775 " + Chr(34) + Slash(InstallToPath) + "*.sh" + Chr(34) + Chr(10) + "Results: " + ShellFast.ReadAll)
		          End If
		        End If
		      End If
		    End If
		    
		    If SkippedInstalling = True Then Return False
		    
		    If ItemLLItem.BuildType = "ssApp" Then
		      CurrentssAppFile = Slash(InstallToPath) + "ssApp.app"
		      If ChDirSet(InstallFromPath) = True Then
		      End If
		    Else
		      If ChDirSet(InstallToPath) = True Then
		      End If
		    End If
		    
		    RunSudoScripts
		    If SkippedInstalling = True Then Return False
		    
		    ' Combined Wine bat optimization — runs script and registry in one Wine/cmd.exe launch
		    If (TargetLinux Or TargetWindows) Then
		      CombinedWineBat = "@echo off" + Chr(13) + Chr(10)
		      BuildingCombinedBat = True
		      CombinedWineRegIdx = 0
		      
		      RunScripts
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      RunRegistry
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      BuildingCombinedBat = False
		      If CombinedWineBat <> "@echo off" + Chr(13) + Chr(10) Then
		        Dim CombinedBatPath As String = TmpPath + "install_combined_" + ItemLLItem.BuildType + ".bat"
		        SaveDataToFile(CombinedWineBat, CombinedBatPath)
		        If Debugging Then Debug("Running combined bat: " + CombinedBatPath)
		        
		        Dim CombinedSh As New Shell
		        CombinedSh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		        CombinedSh.TimeOut = -1
		        
		        If TargetWindows Then
		          Dim WinBatPath As String = CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("cmd.exe /c " + Chr(34) + WinBatPath + Chr(34))
		        Else
		          Dim WineBatWinePath As String = "z:" + CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("wine cmd.exe /c " + Chr(34) + WineBatWinePath + Chr(34))
		        End If
		        
		        Dim CombBuf As String = ""
		        While CombinedSh.IsRunning
		          App.DoEvents(20)
		          CombBuf = CombBuf + CombinedSh.ReadAll 'Drain to prevent pipe deadlock if bat echoes heavily
		        Wend
		        CombBuf = CombBuf + CombinedSh.ReadAll
		        If Debugging Then Debug("Combined bat result: " + CombBuf)
		        
		        If TargetWindows Then
		          Try
		            Deltree(CombinedBatPath)
		          Catch
		          End Try
		        Else
		          ShellFast.Execute("bash -c 'rm -f " + Chr(34) + TmpPath + "bat_reg_*.reg" + Chr(34) + " " + Chr(34) + CombinedBatPath + Chr(34) + "'"  )
		        End If
		      End If
		    Else
		      ' Fallback for other platforms
		      RunScripts
		      If SkippedInstalling = True Then Return False
		      RunRegistry
		      If SkippedInstalling = True Then Return False
		    End If
		    
		    If ItemLLItem.BuildType = "ssApp" Then MoveLinks
		    MakeLinks
		    
		    If TargetLinux Then ShellFast.Execute("bash -c 'update-desktop-database ~/.local/share/applications > /dev/null 2>&1 &'") 'Backgrounded: cache refresh only, does not need to block install
		    
		    If ItemLLItem.BuildType = "LLGame" Then
		      If ItemLLItem.InternetRequired = False Then
		        CopyWild(Slash(ToolPath) + "uninstall.sh", InstallToPath)
		      End If
		      If TargetLinux Then
		        ShellFast.Execute("type -P run-1080p")
		        If ShellFast.Result = "" Then
		          If Exist(Slash(InstallToPath) + "start.sh") Then
		            TempScriptData = LoadDataFromFile(Slash(InstallToPath) + "start.sh")
		            TempScriptData = TempScriptData.ReplaceAll("run-1080p ", "")
		            SaveDataToFile(TempScriptData, Slash(InstallToPath) + "start.sh")
		          End If
		          If Exist(Slash(InstallToPath) + "run.sh") Then
		            TempScriptData = LoadDataFromFile(Slash(InstallToPath) + "run.sh")
		            TempScriptData = TempScriptData.ReplaceAll("run-1080p ", "")
		            SaveDataToFile(TempScriptData, Slash(InstallToPath) + "run.sh")
		          End If
		        End If
		      End If
		    End If
		    
		  Else ' NoInstall — run scripts from source
		    
		    InstallToPath = InstallFromPath
		    If Debugging Then Debug("Installing From / No Output To Path: " + InstallFromPath)
		    
		    If ChDirSet(InstallFromPath) = True Then
		      If Debugging Then Debug("Change Directory: " + InstallFromPath + " Successfully")
		    Else
		      If Debugging Then Debug("Failed to Change Directory: " + InstallFromPath + " Error")
		    End If
		    
		    If SkippedInstalling = True Then
		      LogInstall("Skipped", "Install skipped (no-install mode): " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    RunAssembly
		    If SkippedInstalling = True Then
		      LogInstall("Skipped", "Install skipped after assembly (no-install mode): " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    RunSudoScripts
		    If SkippedInstalling = True Then Return False
		    
		    ' Combined Wine bat optimization for NoInstall mode
		    If (TargetLinux Or TargetWindows) Then
		      CombinedWineBat = "@echo off" + Chr(13) + Chr(10)
		      BuildingCombinedBat = True
		      CombinedWineRegIdx = 0
		      
		      RunRegistry
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      RunScripts
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      BuildingCombinedBat = False
		      If CombinedWineBat <> "@echo off" + Chr(13) + Chr(10) Then
		        Dim CombinedBatPath As String = TmpPath + "install_noinstall_combined_" + ItemLLItem.BuildType + ".bat"
		        SaveDataToFile(CombinedWineBat, CombinedBatPath)
		        If Debugging Then Debug("Running combined bat (NoInstall): " + CombinedBatPath)
		        
		        Dim CombinedSh As New Shell
		        CombinedSh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		        CombinedSh.TimeOut = -1
		        
		        If TargetWindows Then
		          Dim WinBatPath As String = CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("cmd.exe /c " + Chr(34) + WinBatPath + Chr(34))
		        Else
		          Dim WineBatWinePath As String = "z:" + CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("wine cmd.exe /c " + Chr(34) + WineBatWinePath + Chr(34))
		        End If
		        
		        Dim CombBufNI As String = ""
		        While CombinedSh.IsRunning
		          App.DoEvents(20)
		          CombBufNI = CombBufNI + CombinedSh.ReadAll 'Drain to prevent pipe deadlock
		        Wend
		        CombBufNI = CombBufNI + CombinedSh.ReadAll
		        If Debugging Then Debug("Combined bat result (NoInstall): " + CombBufNI)
		        
		        If TargetWindows Then
		          Try
		            Deltree(CombinedBatPath)
		          Catch
		          End Try
		        Else
		          ShellFast.Execute("bash -c 'rm -f " + Chr(34) + TmpPath + "bat_reg_*.reg" + Chr(34) + " " + Chr(34) + CombinedBatPath + Chr(34) + "'"  )
		        End If
		      End If
		    Else
		      ' Fallback for other platforms
		      RunRegistry
		      If SkippedInstalling = True Then Return False
		      RunScripts
		      If SkippedInstalling = True Then Return False
		    End If
		    
		    MakeLinks
		    If SkippedInstalling = True Then Return False
		    
		    If TargetLinux Then ShellFast.Execute("bash -c 'update-desktop-database ~/.local/share/applications > /dev/null 2>&1 &'") 'Backgrounded: cache refresh only
		    
		  End If
		  
		  If TargetWindows Then
		    If ItemLLItem.BuildType = "ppGame" Then Deltree(ppGames + "\.lldb")
		  Else
		    If ItemLLItem.BuildType = "LLGame" Then Deltree(Slash(HomePath) + "LLGames/.lldb")
		    If ItemLLItem.BuildType = "ppGame" Then Deltree(ppGames + "/.lldb")
		  End If
		  
		  ' Close the notification (NoteTimeOut=100 closes it shortly after)
		  Notify("LLStore Installing", "Installing " + ItemLLItem.BuildType + ":-" + Chr(10) + ItemLLItem.TitleName, ItemLLItem.FileIcon, 100)
		  
		  ItemLLItem.PathINI = TempString
		  
		  If InstallFromPath.IndexOf(TmpPath + "install") >= 0 Then
		    If Debugging Then Debug("Delete Temp Path: " + InstallFromPath)
		    Deltree(InstallFromPath)
		  End If
		  
		  Deltree(Slash(TmpPath) + "LLShorts")
		  Deltree(Slash(TmpPath) + "Expanded_Script.cmd")
		  Deltree(Slash(TmpPath) + "Expanded_Script.sh")
		  Deltree(Slash(TmpPath) + "Expanded_Reg.reg")
		  
		  If CleanUpIsle2 <> "" Then Deltree(CleanUpIsle2)
		  CleanUpIsle2 = ""
		  
		  LogInstall("Success", "Installed: " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "] To: " + InstallToPath)
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InstallLinuxContextMenus()
		  ' -----------------------------------------------------------------------
		  ' Installs LLFile context-menu entries into every detectable Linux file
		  ' manager using only user-writable paths. No sudo required.
		  '
		  ' WITH SUBMENU (all 4 items grouped under "LLFile"):
		  '   Nautilus  — ~/.local/share/nautilus/scripts/LLFile/
		  '   Caja      — ~/.config/caja/scripts/LLFile/
		  '   Dolphin   — ~/.local/share/kio/servicemenus/llfile.desktop
		  '   PCManFM   — ~/.local/share/file-manager/actions/  (menu container)
		  '
		  ' FLAT / NO SUBMENU (Install + Edit, filtered to LLFile types + folders):
		  '   Nemo      — ~/.local/share/nemo/actions/
		  '   Thunar    — ~/.config/Thunar/uca.xml  (merged, not replaced)
		  '   Files     — ~/.local/share/contractor/  (elementary OS / Pantheon)
		  ' -----------------------------------------------------------------------
		  
		  If Debugging Then Debug("--- InstallLinuxContextMenus ---")
		  
		  Dim DE As String  = SysDesktopEnvironment.Trim.Lowercase
		  Dim Icon As String = "/LastOS/LLStore/llstore Resources/appicon_256.png"
		  Dim LL As String   = "env GDK_BACKEND=x11 llfile"
		  Dim NL As String   = Chr(10)
		  Dim Q As String    = Chr(34)
		  Dim S As String
		  
		  ' =====================================================================
		  ' NAUTILUS — GNOME / Ubuntu / Pop!_OS / Zorin / Budgie
		  ' A subfolder inside nautilus/scripts/ becomes a "Scripts > LLFile"
		  ' submenu automatically. Nautilus passes paths via env variable.
		  ' =====================================================================
		  If RunCommandResults("which nautilus 2>/dev/null").Trim <> "" _
		    Or DE = "gnome" Or DE = "ubuntu" Or DE = "budgie-desktop" Or DE = "zorin" Then
		    If Debugging Then Debug("  Context menus: Nautilus")
		    Dim NauDir As String = Slash(HomePath)+".local/share/nautilus/scripts/LLFile/"
		    ShellFast.Execute("mkdir -p "+Q+NauDir+Q)
		    
		    Dim NauBase As String = "#!/bin/bash"+NL+"IFS=$'\n'"+NL
		    NauBase = NauBase + "for f in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do"+NL
		    
		    S = NauBase+"  "+LL+" -i "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, NauDir+"Install with LLFile")
		    S = NauBase+"  "+LL+" -e "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, NauDir+"Edit in LLFile Editor")
		    S = NauBase+"  "+LL+" -c "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, NauDir+"Compress as LLFile")
		    S = NauBase+"  "+LL+" -b "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, NauDir+"Build as LLFile")
		    
		    ShellFast.Execute("chmod +x " _
		    +Q+NauDir+"Install with LLFile"+Q+" " _
		    +Q+NauDir+"Edit in LLFile Editor"+Q+" " _
		    +Q+NauDir+"Compress as LLFile"+Q+" " _
		    +Q+NauDir+"Build as LLFile"+Q)
		  End If
		  
		  ' =====================================================================
		  ' CAJA — MATE Desktop
		  ' Identical subfolder mechanism to Nautilus; Caja passes paths as $@.
		  ' =====================================================================
		  If RunCommandResults("which caja 2>/dev/null").Trim <> "" Or DE = "mate" Then
		    If Debugging Then Debug("  Context menus: Caja")
		    Dim CajaDir As String = Slash(HomePath)+".config/caja/scripts/LLFile/"
		    ShellFast.Execute("mkdir -p "+Q+CajaDir+Q)
		    
		    Dim CajaBase As String = "#!/bin/bash"+NL+"for f in "+Q+"$@"+Q+"; do"+NL
		    
		    S = CajaBase+"  "+LL+" -i "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, CajaDir+"Install with LLFile")
		    S = CajaBase+"  "+LL+" -e "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, CajaDir+"Edit in LLFile Editor")
		    S = CajaBase+"  "+LL+" -c "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, CajaDir+"Compress as LLFile")
		    S = CajaBase+"  "+LL+" -b "+Q+"$f"+Q+" &"+NL+"done"+NL
		    SaveDataToFile(S, CajaDir+"Build as LLFile")
		    
		    ShellFast.Execute("chmod +x " _
		    +Q+CajaDir+"Install with LLFile"+Q+" " _
		    +Q+CajaDir+"Edit in LLFile Editor"+Q+" " _
		    +Q+CajaDir+"Compress as LLFile"+Q+" " _
		    +Q+CajaDir+"Build as LLFile"+Q)
		  End If
		  
		  ' =====================================================================
		  ' DOLPHIN — KDE Plasma
		  ' X-KDE-Submenu groups all Desktop Actions under one "LLFile" submenu.
		  ' MimeType list controls which right-clicks show the menu.
		  ' kbuildsycoca rebuilds the KDE service cache without requiring logout.
		  ' =====================================================================
		  If RunCommandResults("which dolphin 2>/dev/null").Trim <> "" _
		    Or DE = "kde" Or DE = "plasma" Then
		    If Debugging Then Debug("  Context menus: Dolphin/KDE")
		    Dim DolDir As String = Slash(HomePath)+".local/share/kio/servicemenus/"
		    ShellFast.Execute("mkdir -p "+Q+DolDir+Q)
		    
		    Dim KDE As String
		    KDE = "[Desktop Entry]"+NL
		    KDE = KDE+"Type=Service"+NL
		    KDE = KDE+"ServiceTypes=KonqPopupMenu/Plugin"+NL
		    KDE = KDE+"MimeType=application/x-llfile;application/x-tar;inode/directory;application/octet-stream;"+NL
		    KDE = KDE+"X-KDE-Submenu=LLFile"+NL
		    KDE = KDE+"Actions=llf_install;llf_edit;llf_compress;llf_build"+NL+NL
		    KDE = KDE+"[Desktop Action llf_install]"+NL
		    KDE = KDE+"Name=Install with LLFile"+NL
		    KDE = KDE+"Icon="+Icon+NL
		    KDE = KDE+"Exec="+LL+" -i %F"+NL+NL
		    KDE = KDE+"[Desktop Action llf_edit]"+NL
		    KDE = KDE+"Name=Edit in LLFile Editor"+NL
		    KDE = KDE+"Icon="+Icon+NL
		    KDE = KDE+"Exec="+LL+" -e %F"+NL+NL
		    KDE = KDE+"[Desktop Action llf_compress]"+NL
		    KDE = KDE+"Name=Compress as LLFile"+NL
		    KDE = KDE+"Icon="+Icon+NL
		    KDE = KDE+"Exec="+LL+" -c %F"+NL+NL
		    KDE = KDE+"[Desktop Action llf_build]"+NL
		    KDE = KDE+"Name=Build as LLFile"+NL
		    KDE = KDE+"Icon="+Icon+NL
		    KDE = KDE+"Exec="+LL+" -b %F"+NL
		    
		    SaveDataToFile(KDE, DolDir+"llfile.desktop")
		    ShellFast.Execute("chmod +x "+Q+DolDir+"llfile.desktop"+Q)
		    'Rebuild KDE sycoca so the service menu is active without a logout
		    ShellFast.Execute("kbuildsycoca6 --noincremental 2>/dev/null || kbuildsycoca5 --noincremental 2>/dev/null || true")
		  End If
		  
		  ' =====================================================================
		  ' NEMO — Cinnamon / Linux Mint
		  ' .nemo_action files sit flat in the context menu (no submenu support).
		  ' Filtered to LLFile types + folders.
		  ' =====================================================================
		  If RunCommandResults("which nemo 2>/dev/null").Trim <> "" _
		    Or DE = "cinnamon" Or DE = "x-cinnamon" Then
		    If Debugging Then Debug("  Context menus: Nemo")
		    Dim NemoDir As String = Slash(HomePath)+".local/share/nemo/actions/"
		    ShellFast.Execute("mkdir -p "+Q+NemoDir+Q)
		    
		    Dim NemoTypes As String = "apz;pgz;app;ppg;lla;llg;tar;dir;"
		    Dim NemoMimes As String = "application/x-llfile;application/x-tar;inode/directory;"
		    
		    Dim NemoInst As String
		    NemoInst = "[Nemo Action]"+NL
		    NemoInst = NemoInst+"Name=Install with LLFile"+NL
		    NemoInst = NemoInst+"Comment=Install with LLStore"+NL
		    NemoInst = NemoInst+"Exec="+LL+" -i %F"+NL
		    NemoInst = NemoInst+"Icon-Name="+Icon+NL
		    NemoInst = NemoInst+"Selection=Any"+NL
		    NemoInst = NemoInst+"Extensions="+NemoTypes+NL
		    NemoInst = NemoInst+"Mimetypes="+NemoMimes+NL
		    SaveDataToFile(NemoInst, NemoDir+"llfile_install.nemo_action")
		    
		    Dim NemoEdit As String
		    NemoEdit = "[Nemo Action]"+NL
		    NemoEdit = NemoEdit+"Name=Edit in LLFile Editor"+NL
		    NemoEdit = NemoEdit+"Comment=Open in LLFile Editor"+NL
		    NemoEdit = NemoEdit+"Exec="+LL+" -e %F"+NL
		    NemoEdit = NemoEdit+"Icon-Name="+Icon+NL
		    NemoEdit = NemoEdit+"Selection=Any"+NL
		    NemoEdit = NemoEdit+"Extensions="+NemoTypes+NL
		    NemoEdit = NemoEdit+"Mimetypes="+NemoMimes+NL
		    SaveDataToFile(NemoEdit, NemoDir+"llfile_edit.nemo_action")
		  End If
		  
		  ' =====================================================================
		  ' THUNAR — XFCE (and standalone installs on any DE)
		  ' Custom Actions live in ~/.config/Thunar/uca.xml.
		  ' We MERGE into an existing file (never replace it) so the user's own
		  ' actions survive. Idempotent — checks unique-id before injecting.
		  ' NOTE: Runs after the cp -R scripts/Thunar block above, so any
		  '       existing uca.xml copied from scripts/ is safely extended.
		  ' =====================================================================
		  If RunCommandResults("which thunar 2>/dev/null").Trim <> "" Or DE = "xfce" Then
		    If Debugging Then Debug("  Context menus: Thunar")
		    Dim ThunarDir As String = Slash(HomePath)+".config/Thunar/"
		    ShellFast.Execute("mkdir -p "+Q+ThunarDir+Q)
		    Dim UcaFile As String = ThunarDir+"uca.xml"
		    
		    Dim Existing As String = ""
		    If Exist(UcaFile) Then Existing = LoadDataFromFile(UcaFile)
		    
		    'Skip if we already installed (idempotent on reinstall)
		    If InStr(Existing, "llfile_install_uca") = 0 Then
		      Dim ThunarPat As String = "*.apz;*.pgz;*.app;*.ppg;*.lla;*.llg;*.tar"
		      Dim TB As String = ""
		      
		      TB = TB+"  <action>"+NL
		      TB = TB+"    <icon>"+Icon+"</icon>"+NL
		      TB = TB+"    <n>Install with LLFile</n>"+NL
		      TB = TB+"    <unique-id>llfile_install_uca</unique-id>"+NL
		      TB = TB+"    <command>"+LL+" -i %f</command>"+NL
		      TB = TB+"    <description>Install with LLStore</description>"+NL
		      TB = TB+"    <patterns>"+ThunarPat+"</patterns>"+NL
		      TB = TB+"    <directories/>"+NL
		      TB = TB+"  </action>"+NL
		      
		      TB = TB+"  <action>"+NL
		      TB = TB+"    <icon>"+Icon+"</icon>"+NL
		      TB = TB+"    <n>Edit in LLFile Editor</n>"+NL
		      TB = TB+"    <unique-id>llfile_edit_uca</unique-id>"+NL
		      TB = TB+"    <command>"+LL+" -e %f</command>"+NL
		      TB = TB+"    <description>Open in LLFile Editor</description>"+NL
		      TB = TB+"    <patterns>"+ThunarPat+"</patterns>"+NL
		      TB = TB+"    <directories/>"+NL
		      TB = TB+"  </action>"+NL
		      
		      If Existing <> "" And InStr(Existing, "</actions>") > 0 Then
		        'Inject our entries just before the closing tag
		        Existing = Existing.ReplaceAll("</actions>", TB+"</actions>")
		        SaveDataToFile(Existing, UcaFile)
		      Else
		        'No existing file (or malformed) — write a fresh one
		        Dim NewUca As String
		        NewUca = "<?xml version="+Q+"1.0"+Q+" encoding="+Q+"UTF-8"+Q+"?>"+NL
		        NewUca = NewUca+"<actions>"+NL+TB+"</actions>"+NL
		        SaveDataToFile(NewUca, UcaFile)
		      End If
		    End If
		  End If
		  
		  ' =====================================================================
		  ' FILES — elementary OS / Pantheon
		  ' Contractor .contract files appear individually in the context menu.
		  ' Filtered to LLFile types + folders (no submenu support).
		  ' =====================================================================
		  If RunCommandResults("which io.elementary.files 2>/dev/null || which pantheon-files 2>/dev/null").Trim <> "" _
		    Or DE = "pantheon" Or DE = "elementary" Then
		    If Debugging Then Debug("  Context menus: Files (elementary/Pantheon)")
		    Dim ConDir As String = Slash(HomePath)+".local/share/contractor/"
		    ShellFast.Execute("mkdir -p "+Q+ConDir+Q)
		    
		    Dim ConMimes As String = "application/x-llfile;application/x-tar;inode/directory;"
		    
		    Dim ConInst As String
		    ConInst = "[Contractor Entry]"+NL
		    ConInst = ConInst+"Name=Install with LLFile"+NL
		    ConInst = ConInst+"Description=Install with LLStore"+NL
		    ConInst = ConInst+"MimeType="+ConMimes+NL
		    ConInst = ConInst+"Exec="+LL+" -i %f"+NL
		    ConInst = ConInst+"Icon="+Icon+NL
		    SaveDataToFile(ConInst, ConDir+"llfile_install.contract")
		    
		    Dim ConEdit As String
		    ConEdit = "[Contractor Entry]"+NL
		    ConEdit = ConEdit+"Name=Edit in LLFile Editor"+NL
		    ConEdit = ConEdit+"Description=Open in LLFile Editor"+NL
		    ConEdit = ConEdit+"MimeType="+ConMimes+NL
		    ConEdit = ConEdit+"Exec="+LL+" -e %f"+NL
		    ConEdit = ConEdit+"Icon="+Icon+NL
		    SaveDataToFile(ConEdit, ConDir+"llfile_edit.contract")
		  End If
		  
		  ' =====================================================================
		  ' PCMANFM / PCMANFM-QT — LXDE / LXQt
		  ' freedesktop.org file-manager-actions format.
		  ' Type=Menu container creates a submenu in supporting builds; older
		  ' builds that ignore it will still show the individual action items.
		  ' =====================================================================
		  If RunCommandResults("which pcmanfm 2>/dev/null || which pcmanfm-qt 2>/dev/null").Trim <> "" _
		    Or DE = "lxde" Or DE = "lxqt" Then
		    If Debugging Then Debug("  Context menus: PCManFM/PCManFM-Qt")
		    Dim FmaDir As String = Slash(HomePath)+".local/share/file-manager/actions/"
		    ShellFast.Execute("mkdir -p "+Q+FmaDir+Q)
		    
		    'Menu container — groups items under "LLFile" in capable versions
		    Dim FmaMenu As String
		    FmaMenu = "[Desktop Entry]"+NL+"Type=Menu"+NL+"Name=LLFile"+NL
		    FmaMenu = FmaMenu+"Icon="+Icon+NL
		    FmaMenu = FmaMenu+"ItemsList=llfile_fma_install;llfile_fma_edit;llfile_fma_compress;llfile_fma_build;"+NL
		    SaveDataToFile(FmaMenu, FmaDir+"llfile_menu.desktop")
		    
		    Dim FI As String
		    FI = "[Desktop Entry]"+NL+"Type=Action"+NL+"Name=Install with LLFile"+NL
		    FI = FI+"Icon="+Icon+NL+"Profiles=p;"+NL+NL
		    FI = FI+"[X-Action-Profile p]"+NL+"Name=Default"+NL
		    FI = FI+"Exec="+LL+" -i %f"+NL
		    FI = FI+"MimeTypes=application/x-llfile;application/x-tar;inode/directory;"+NL
		    SaveDataToFile(FI, FmaDir+"llfile_fma_install.desktop")
		    
		    Dim FE As String
		    FE = "[Desktop Entry]"+NL+"Type=Action"+NL+"Name=Edit in LLFile Editor"+NL
		    FE = FE+"Icon="+Icon+NL+"Profiles=p;"+NL+NL
		    FE = FE+"[X-Action-Profile p]"+NL+"Name=Default"+NL
		    FE = FE+"Exec="+LL+" -e %f"+NL
		    FE = FE+"MimeTypes=application/x-llfile;application/x-tar;inode/directory;"+NL
		    SaveDataToFile(FE, FmaDir+"llfile_fma_edit.desktop")
		    
		    Dim FC As String
		    FC = "[Desktop Entry]"+NL+"Type=Action"+NL+"Name=Compress as LLFile"+NL
		    FC = FC+"Icon="+Icon+NL+"Profiles=p;"+NL+NL
		    FC = FC+"[X-Action-Profile p]"+NL+"Name=Default"+NL
		    FC = FC+"Exec="+LL+" -c %f"+NL
		    FC = FC+"MimeTypes=all/allfiles;inode/directory;"+NL
		    SaveDataToFile(FC, FmaDir+"llfile_fma_compress.desktop")
		    
		    Dim FB As String
		    FB = "[Desktop Entry]"+NL+"Type=Action"+NL+"Name=Build as LLFile"+NL
		    FB = FB+"Icon="+Icon+NL+"Profiles=p;"+NL+NL
		    FB = FB+"[X-Action-Profile p]"+NL+"Name=Default"+NL
		    FB = FB+"Exec="+LL+" -b %f"+NL
		    FB = FB+"MimeTypes=inode/directory;"+NL
		    SaveDataToFile(FB, FmaDir+"llfile_fma_build.desktop")
		    
		    ShellFast.Execute("chmod +x " _
		    +Q+FmaDir+"llfile_menu.desktop"+Q+" " _
		    +Q+FmaDir+"llfile_fma_install.desktop"+Q+" " _
		    +Q+FmaDir+"llfile_fma_edit.desktop"+Q+" " _
		    +Q+FmaDir+"llfile_fma_compress.desktop"+Q+" " _
		    +Q+FmaDir+"llfile_fma_build.desktop"+Q)
		  End If
		  
		  If Debugging Then Debug("--- InstallLinuxContextMenus Done ---")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InstallLinuxMenuSorting(KeepSudo2 As Boolean = True)
		  Dim MainPath As String = Slash(AppPath)
		  
		  EnableSudoScript
		  
		  '
		  
		  RunSudo("cp  -R "+Chr(34)+MainPath+"Tools/LinuxMenuSorting/xdg/menus/applications-merged"+Chr(34)+" "+Chr(34)+"/etc/xdg/menus/"+Chr(34))
		  RunSudo("cp  -R "+Chr(34)+MainPath+"Tools/LinuxMenuSorting/desktop-directories"+Chr(34)+" "+Chr(34)+"/usr/share/"+Chr(34))
		  
		  RunSudo("chmod 644 "+Chr(34)+"/etc/xdg/menus/applications-merged/LastOSLinux_Sorting.menu"+Chr(34)) 'Secure: system config file, root-owned, readable by all
		  RunSudo("chmod 644 "+Chr(34)+"/usr/share/desktop-directories/cinnamon-disk.directory"+Chr(34)) 'Secure: system config file, root-owned, readable by all
		  
		  
		  'Close Sudo Terminal
		  If KeepSudo2 = False Then ShellFast.Execute ("echo "+Chr(34)+"Unlock"+Chr(34)+" > "+BaseDir+"/LLSudoDone") 'Quits Terminal after All items have been installed.
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InstallLLFile(FileIn As String) As Boolean
		  App.DoEvents(7) 'Putting this here to hopefully redraw the Notification window, it only partly draws otherwise
		  
		  If Debugging Then Debug("--- Starting Install LLFile ---")
		  If TargetWindows Then
		    FileIn = FileIn.ReplaceAll("/","\") 'Make it more windowsy so it works better when installing from windows
		  End If
		  If FileIn.Trim = "" Then
		    If Debugging Then Debug("~ Warning - No file given, skipping item") 'Need to check the call just incase it's an empty call
		    Return False
		  End If
		  
		  'App.DoEvents(1) 'Redraw Forms
		  
		  Dim TempScriptData As String
		  
		  Dim Suc As Boolean
		  Dim Success As Boolean
		  Dim Shelly As New Shell
		  
		  'Dim TmpNumber As Integer = Randomiser.InRange(10000, 20000)
		  Dim FileToExtract, MainFileToExtract As String
		  
		  Shelly.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  Shelly.TimeOut = -1
		  
		  'Clear Temp Path incase it fails to load
		  ItemTempPath = ""
		  
		  'Load in the LLFile ----------------------------------- Loads file here -----------------------------------------
		  Success = LoadLLFile(FileIn, "", True) '"" Means it will generate a new Temp folder and return it as TempInstall Globally and the True means Install Item, will extract whole archive, not just LLFile resources
		  If Debugging Then Debug("Install Loading in File: "+FileIn + " ItemTempPath: " + ItemTempPath +" Good: "+Success.ToString)
		  
		  If Success = False Then
		    LogInstall("FAIL", "LoadLLFile failed for file: " + FileIn)
		    Return False ' Couldn't Load Item
		  End If
		  
		  MakeFolder(Slash(HomePath)+".local/share/applications")
		  
		  'Check for Nonething or empty PathApp and set NoInstall: no destination path means scripts-only run.
		  If ItemLLItem.PathApp.Trim = "" Or ItemLLItem.PathApp.IndexOf("Nonething") >= 0 Then ItemLLItem.NoInstall = True 'This will not use a folder on the computer to install the item to.
		  
		  
		  'Make sure Sudo is available during ANY install (if not required for instaling one item then can skip it)
		  If InstallOnly Then
		    Select Case ItemLLItem.BuildType 
		    Case "ssApp", "ppApp", "ppGame"
		    Case Else 'Linux Item, may need script so always run it
		      If SudoAsNeeded = False Then EnableSudoScript
		    End Select
		  Else 'MiniInstaller method should always run the script in Linux
		    If SudoAsNeeded = False Then EnableSudoScript
		  End If
		  
		  
		  If TempInstall = "" Then 'Uncompressed item, no temp folder used
		    InstallFromPath = GetFullParent(FileIn) 'Removes .lla .app etc file ' just keep path
		  Else
		    InstallFromPath = ItemTempPath 'Use the Temp Path from extracting the Item for everything it needs
		  End If
		  
		  If Debugging Then Debug("Installing From Path: "+ InstallFromPath)
		  
		  'Change INIPath to TempPath if required ------------------------------------------------------- Change PathINI to Temp path
		  Dim TempString As String
		  TempString = ItemLLItem.PathINI
		  'Make ItemLLItem.PathINI = InstallFromPath so that any expanded paths are the correct temp path etc
		  ItemLLItem.PathINI = InstallFromPath
		  
		  
		  If InstallOnly = True Then
		    If Not TargetWindows Then
		      'Show mine (Dual notifications should be ok?), Hey calling the system one makes it draw my notification window too, nice.
		      Notify ("LLStore Installing", "Installing "+ItemLLItem.BuildType+":-"+Chr(10)+ItemLLItem.TitleName, ItemLLItem.FileIcon, -1) 'Mini Installer can't call this and wouldn't want to.
		      App.DoEvents(7) 'Putting this here to hopefully redraw the Notification window, it only partly draws otherwise
		      'Show system one
		      RunCommand ("notify-send --hint=int:transient:1 " + Chr(34) +"Installing "+ItemLLItem.BuildType+":-"+Chr(10)+ItemLLItem.TitleName + Chr(34))
		    Else
		      Notify ("LLStore Installing", "Installing "+ItemLLItem.BuildType+":-"+Chr(10)+ItemLLItem.TitleName, ItemLLItem.FileIcon, -1) 'Mini Installer can't call this and wouldn't want to.
		      App.DoEvents(7) 'Putting this here to hopefully redraw the Notification window, it only partly draws otherwise
		    End If
		  End If
		  
		  If Debugging Then Debug("No Install: "+ ItemLLItem.NoInstall.ToString) 'This is for debugging items trying to install to a folder instead of running in place
		  
		  If ItemLLItem.NoInstall = False Then 'Has a Destination Path
		    
		    
		    'On Linux, if this SS item has a Linux .desktop link, install to LLGames/LLApps instead of Wine paths
		    'PathApp is already expanded by LoadLLFile (e.g. /home/user/.wine/drive_c/ppGames/Title)
		    'so we remap the expanded Wine paths to native LLGames/LLApps paths directly
		    Dim AppPathToInstall As String = ItemLLItem.PathApp
		    If TargetLinux And (ItemLLItem.BuildType = "ppGame" Or ItemLLItem.BuildType = "ppApp" Or ItemLLItem.BuildType = "ssApp") And HasLinuxDesktopLink() Then
		      AppPathToInstall = AppPathToInstall.ReplaceAll(NoSlash(ppGames), NoSlash(Slash(HomePath)+"LLGames"))
		      AppPathToInstall = AppPathToInstall.ReplaceAll(NoSlash(ppApps), NoSlash(Slash(HomePath)+"LLApps"))
		    End If
		    InstallToPath = Slash(AppPathToInstall) 'Already expanded; no need to call ExpPath again
		    
		    If Debugging Then Debug("Installing To Path: "+ InstallToPath)
		    
		    'Change to App/Games INI Path to run Assemblys from
		    If ChDirSet(InstallFromPath) = True Then ' Was successful
		    End If
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      LogInstall("Skipped", "Install skipped before assembly: " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    'Run Assemblies from ssApps, ppApps and ppGames etc
		    RunAssembly
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      LogInstall("Skipped", "Install skipped after assembly: " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    
		    'Check InstallToPath Is correct or change if available
		    Dim Inst2 As String
		    If Not Exist(InstallToPath) Then
		      Inst2 = InstallToPath.ReplaceAll("Program Files", "Program Files (x86)")
		      If  Exist(Inst2) Then
		        InstallToPath = Inst2 'Change Program Files to (x86) if it does exist, that way it'll be in one place
		      End If
		    End If
		    
		    'Extract Files from Archives (Where applicable)
		    MakeFolder (InstallToPath) 'Make sure the folder exists or it can't copy files to it.
		    
		    If ItemLLItem.BuildType = "LLApp" Then FileToExtract = Slash(InstallFromPath)+ "LLApp.tar.gz"
		    If ItemLLItem.BuildType = "LLGame" Then FileToExtract = Slash(InstallFromPath)+ "LLGame.tar.gz"
		    
		    If ItemLLItem.BuildType = "ppApp" Then FileToExtract = Slash(InstallFromPath) + "ppApp.7z"
		    If ItemLLItem.BuildType = "ppGame" Then FileToExtract = Slash(InstallFromPath) + "ppGame.7z"
		    
		    If FileToExtract <> "" Then
		      If Exist(FileToExtract) Then
		        MainFileToExtract = FileToExtract
		        Success = Extract(FileToExtract, InstallToPath, "")
		        If Not Success Then 'Clean Up And Return (This is required, else it'll not work anyway, so abort)
		          LogInstall("FAIL", "Archive extraction failed for " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "] File: " + FileToExtract)
		          Return False ' Failed to extract
		        End If
		        'Else 'No Archives, check if extracted file and copy it all if so
		        'If ItemLLItem.NoInstall = False Then 'Only do items set for installing
		        'End If
		      End If
		    End If
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      
		      Return False
		    End If
		    
		    
		    
		    'Extract Patch Files
		    FileToExtract = Slash(InstallFromPath) + "Patch.7z"
		    If FileToExtract <> "" Then
		      If Exist(FileToExtract) Then
		        Success = Extract(FileToExtract, InstallToPath, "")
		        If Not Success Then 'Clean Up And Return
		          'Return False ' Failed to extract 'Disabled for now, if the patch fails, it'll still run, just not pre configured
		        End If
		      End If
		    End If
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      
		      Return False
		    End If
		    
		    
		    If ItemLLItem.BuildType  = "ssApp" Then MainFileToExtract = "NO" 'Do NOT copy the files when they are a ssApp
		    If ItemLLItem.NoInstall = True Then MainFileToExtract = "NO" 'Do NOT copy the files when they are not installed anywhere (They are a LLApp that tweaks or installs with package manager)
		    
		    'Copy all .jpg .png .svg .ico .mp4 from InstallFrom to InstallTo so screenshots for multi shortcut items work
		    'Copy LLFiles to the Install folder (So Games Launcher has the Link Info and Screenshots/Fader etc 'This will copy all but archives, Need to manually copy the ssApp and ppApp files after this
		    If TargetWindows Then
		      If InstallFromPath.IndexOf("ppAppsLive")>=1 Or MainFileToExtract = "" Then ' If MainFilesToExtract was never done then copy the whole extracted item
		        XCopy(InstallFromPath.ReplaceAll("/","\"), InstallToPath.ReplaceAll("/","\"))
		      Else
		        'Find another way to copy in Windows? (RoboCopy)
		        'https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
		        
		        Suc = Copy(Slash(InstallFromPath) +ItemLLItem.BuildType+".app", Slash(InstallToPath) +ItemLLItem.BuildType+ ".app")
		        Suc = Copy(Slash(InstallFromPath) +ItemLLItem.BuildType+".ppg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".ppg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".reg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".reg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".cmd", Slash(InstallToPath) + ItemLLItem.BuildType+".cmd")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".jpg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".jpg")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".png", Slash(InstallToPath) +ItemLLItem.BuildType+ ".png")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".ico", Slash(InstallToPath) +ItemLLItem.BuildType+ ".ico")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".mp4", Slash(InstallToPath) +ItemLLItem.BuildType+ ".mp4")
		        
		        CopyWild(Slash(InstallFromPath) + "*.jpg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.png", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.ico", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.svg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.mp4", Slash(InstallToPath))
		      End If
		      If Exist(Slash(InstallToPath)+ItemLLItem.BuildType+".ico") Then 'Try to set the folder icon
		        MakeFolderIcon(InstallToPath, Slash(InstallToPath)+ItemLLItem.BuildType+".ico")
		      End If
		      
		    Else 'Linux Mode
		      'rsync doesn't work in Debian by default, needs installing, so just copy the essentials in that case
		      If InstallFromPath.IndexOf("ppAppsLive")>=1 Or MainFileToExtract = "" Then 'Can check here if was an extracted/installed LLFile your installing and do the lot - MainFileToExtract is set above if so
		        Shelly.Execute ("cp -rf " + Chr(34) + Slash(InstallFromPath) + "." + Chr(34) + " " + Chr(34) + InstallToPath + Chr(34))
		        Do
		          App.DoEvents(20)
		        Loop Until Shelly.IsRunning = False
		      Else
		        Suc = Copy(Slash(InstallFromPath) + "LLScript.sh", Slash(InstallToPath) + "LLScript.sh")
		        Suc = Copy(Slash(InstallFromPath) +ItemLLItem.BuildType+".app", Slash(InstallToPath) +ItemLLItem.BuildType+ ".app")
		        Suc = Copy(Slash(InstallFromPath) +ItemLLItem.BuildType+".ppg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".ppg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".reg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".reg")
		        Suc = Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".cmd", Slash(InstallToPath) + ItemLLItem.BuildType+".cmd")
		        Suc = Copy(Slash(InstallFromPath) +ItemLLItem.BuildType+".lla", Slash(InstallToPath) +ItemLLItem.BuildType+ ".lla")
		        Suc = Copy(Slash(InstallFromPath) +ItemLLItem.BuildType+".llg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".llg")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".jpg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".jpg")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".png", Slash(InstallToPath) +ItemLLItem.BuildType+ ".png")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".ico", Slash(InstallToPath) +ItemLLItem.BuildType+ ".ico")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".svg", Slash(InstallToPath) +ItemLLItem.BuildType+ ".svg")
		        'Copy(Slash(InstallFromPath) + ItemLLItem.BuildType+".mp4", Slash(InstallToPath) +ItemLLItem.BuildType+ ".mp4")
		        
		        CopyWild(Slash(InstallFromPath) + "*.jpg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.png", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.ico", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.svg", Slash(InstallToPath))
		        CopyWild(Slash(InstallFromPath) + "*.mp4", Slash(InstallToPath))
		        
		        
		        If ItemLLItem.BuildType = "LLGame"  Then
		          'Shelly.Execute ("rsync -a " + Chr(34) + Slash(InstallFromPath) + "." + Chr(34) + " " + Chr(34) + InstallToPath + Chr(34) + " --exclude=LLApp.tar.gz"+" --exclude=LLGame.tar.gz" +" --exclude=*.7z")
		          Do
		            App.DoEvents(20)
		          Loop Until Shelly.IsRunning = False
		        End If
		        If ItemLLItem.BuildType = "ppGame"  Then
		          'Shelly.Execute ("rsync -a " + Chr(34) + Slash(InstallFromPath) + "." + Chr(34) + " " + Chr(34) + InstallToPath + Chr(34) + " --exclude=LLApp.tar.gz"+" --exclude=LLGame.tar.gz" +" --exclude=*.7z")
		          Do
		            App.DoEvents(20)
		          Loop Until Shelly.IsRunning = False
		        End If
		        If ItemLLItem.BuildType = "ppApp"  Then
		          'Shelly.Execute ("rsync -a " + Chr(34) + Slash(InstallFromPath) + "." + Chr(34) + " " + Chr(34) + InstallToPath + Chr(34) + " --exclude=LLApp.tar.gz"+" --exclude=LLGame.tar.gz" +" --exclude=*.7z")
		          Do
		            App.DoEvents(20)
		          Loop Until Shelly.IsRunning = False
		        End If
		        If ItemLLItem.BuildType = "ssApp" Then
		          'Copy(Slash(InstallFromPath) + "ssApp.app", Slash(InstallToPath) + "ssApp.app")
		          'Copy(Slash(InstallFromPath) + "ssApp.reg", Slash(InstallToPath) + "ssApp.reg")
		          'Copy(Slash(InstallFromPath) + "ssApp.cmd", Slash(InstallToPath) + "ssApp.cmd")
		          'Copy(Slash(InstallFromPath) + "ssApp.jpg", Slash(InstallToPath) + "ssApp.jpg")
		          'Copy(Slash(InstallFromPath) + "ssApp.png", Slash(InstallToPath) + "ssApp.png")
		          'Copy(Slash(InstallFromPath) + "ssApp.ico", Slash(InstallToPath) + "ssApp.ico")
		          'CopyWild(Slash(InstallFromPath) + "*.jpg", Slash(InstallToPath))
		          
		          if Not TargetWindows Then 'Only Linux needs this, Win doesn't
		            ShellFast.Execute ("chmod 775 "+Chr(34)+Slash(InstallToPath) + "*.cmd"+Chr(34)) 'Change Read/Write/Execute to defaults
		            If Debugging Then Debug("Shell Fast Execute: "+"chmod 775 "+Chr(34)+Slash(InstallToPath) + "*.cmd"+Chr(34)+Chr(10)+"Results: " + ShellFast.ReadAll )
		            ShellFast.Execute ("chmod 775 "+Chr(34)+Slash(InstallToPath) + "*.sh"+Chr(34)) 'Change Read/Write/Execute to defaults
		            If Debugging Then Debug("Shell Fast Execute: "+"chmod 775 "+Chr(34)+Slash(InstallToPath) + "*.sh"+Chr(34)+Chr(10)+"Results: " + ShellFast.ReadAll )
		          End If
		        End If
		      End If
		    End If
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      
		      Return False
		    End If
		    
		    
		    'Change to App/Games Path to run scripts from
		    If ItemLLItem.BuildType = "ssApp" Then
		      
		      CurrentssAppFile = Slash(InstallToPath) + "ssApp.app" ' Used by MoveLinks to output links
		      
		      If ChDirSet(InstallFromPath) = True Then ' Was successful - ssApp path set
		      End If
		    Else
		      If ChDirSet(InstallToPath) = True Then ' Was successful - ppApp/Game path set
		      End If
		    End If
		    
		    'Run Sudo Scripts
		    RunSudoScripts
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      
		      Return False
		    End If
		    
		    
		    'Run Scripts and Registry — combined into one Wine/cmd.exe launch
		    If (TargetLinux Or TargetWindows) Then
		      CombinedWineBat = "@echo off" + Chr(13) + Chr(10)
		      BuildingCombinedBat = True
		      CombinedWineRegIdx = 0
		      
		      RunScripts
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      RunRegistry
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      BuildingCombinedBat = False
		      If CombinedWineBat <> "@echo off" + Chr(13) + Chr(10) Then
		        Dim CombinedBatPath As String = TmpPath + "install_combined_" + ItemLLItem.BuildType + ".bat"
		        SaveDataToFile(CombinedWineBat, CombinedBatPath)
		        If Debugging Then Debug("Running combined bat: " + CombinedBatPath)
		        
		        Dim CombinedSh As New Shell
		        CombinedSh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		        CombinedSh.TimeOut = -1
		        
		        If TargetWindows Then
		          Dim WinBatPath As String = CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("cmd.exe /c " + Chr(34) + WinBatPath + Chr(34))
		        Else
		          Dim WineBatWinePath As String = "z:" + CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("wine cmd.exe /c " + Chr(34) + WineBatWinePath + Chr(34))
		        End If
		        
		        Dim CombBuf As String = ""
		        While CombinedSh.IsRunning
		          App.DoEvents(20)
		          CombBuf = CombBuf + CombinedSh.ReadAll 'Drain to prevent pipe deadlock if bat echoes heavily
		        Wend
		        CombBuf = CombBuf + CombinedSh.ReadAll
		        If Debugging Then Debug("Combined bat result: " + CombBuf)
		        
		        If TargetWindows Then
		          Try
		            Deltree(CombinedBatPath)
		          Catch
		          End Try
		        Else
		          ShellFast.Execute("bash -c 'rm -f " + Chr(34) + TmpPath + "bat_reg_*.reg" + Chr(34) + " " + Chr(34) + CombinedBatPath + Chr(34) + "'"  )
		        End If
		      End If
		    Else
		      ' Fallback for other platforms
		      RunScripts
		      If SkippedInstalling = True Then 'Allows aborting a installation part way through
		        Return False
		      End If
		      RunRegistry
		      If SkippedInstalling = True Then 'Allows aborting a installation part way through
		        Return False
		      End If
		    End If
		    
		    
		    '------------------------------- Do ssApp Links ----------------------------------
		    'Move ssApp Shortcuts to their sorted locations (Need to try in Linux to see if they get moved in there or I'll have to edit the .desktop files as well) Do this first so MakeLinks can use LLShorts to source the links
		    If ItemLLItem.BuildType = "ssApp" Then MoveLinks
		    
		    'Make Links
		    MakeLinks
		    
		    'Update Linux Links Database
		    If TargetLinux Then ShellFast.Execute ("bash -c 'update-desktop-database ~/.local/share/applications > /dev/null 2>&1 &'") 'Backgrounded: cache refresh only, does not need to block install
		    
		    'If it's a LLGame copy the uninstall.sh script to the root folder
		    If ItemLLItem.BuildType = "LLGame"  Then
		      If ItemLLItem.InternetRequired = False Then 'Only add this script to Offline installed items as the online ones will be tracked by the package manager used.
		        CopyWild(Slash(ToolPath)+"uninstall.sh", InstallToPath)
		      End If
		      
		      'Check for start.sh and if it contains run-1080p then remove that from the script file if it's unavailable on the OS your using
		      'If in Linux check if run-1080p is available and if not remove it from the Exe being called.
		      If TargetLinux Then
		        ShellFast.Execute("type -P run-1080p")
		        If  ShellFast.Result = "" Then
		          'ItemLnk(I).Link.TargetPath= ItemLnk(I).Link.TargetPath.Replace("run-1080p ","")
		          If Exist(Slash(InstallToPath)+"start.sh") Then
		            TempScriptData = LoadDataFromFile(Slash(InstallToPath)+"start.sh")
		            TempScriptData = TempScriptData.ReplaceAll("run-1080p ","") 'This removes it if the system doesn't have it
		            SaveDataToFile(TempScriptData, Slash(InstallToPath)+"start.sh")
		          End If
		          If Exist(Slash(InstallToPath)+"run.sh") Then
		            TempScriptData = LoadDataFromFile(Slash(InstallToPath)+"start.sh")
		            TempScriptData = TempScriptData.ReplaceAll("run-1080p ","") 'This removes it if the system doesn't have it
		            SaveDataToFile(TempScriptData, Slash(InstallToPath)+"start.sh")
		          End If
		        End If
		      End If
		      
		    End If
		    
		    'Do Delete Temp Path here? if TempInstall has a path (Make sure it's in .lltemp
		    
		    
		  Else' NoInstall -  Just Run Scripts etc from Source folder (or Temp if Extracts it to one)
		    
		    'InstallToPath = InstallFromPath when a NoInstall item
		    InstallToPath = InstallFromPath
		    If Debugging Then Debug("Installing From/ No Output To Path: "+ InstallFromPath)
		    
		    'Change to App/Games INI Path to run Assemblys from
		    If ChDirSet(InstallFromPath) = True Then ' Was successful
		      
		      If Debugging Then Debug ("Change Directory: "+InstallFromPath +" Successfully")
		      'MsgBox "InstallTo Path: " + InstallToPath + " InstallFrom Path: " + InstallFromPath
		    Else
		      If Debugging Then Debug ("Failed to Change Directory: "+InstallFromPath +" Error")
		    End If
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      LogInstall("Skipped", "Install skipped (no-install mode): " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    
		    'Run Assemblys
		    RunAssembly
		    
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      LogInstall("Skipped", "Install skipped after assembly (no-install mode): " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "]")
		      Return False
		    End If
		    
		    
		    'Run Sudo Scripts
		    '*** Make sure to add CD to the top of the script so it does it from the correct folder
		    RunSudoScripts
		    
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      
		      Return False
		    End If
		    
		    
		    'Combined Wine bat optimization for NoInstall mode — registry first, then scripts
		    If (TargetLinux Or TargetWindows) Then
		      CombinedWineBat = "@echo off" + Chr(13) + Chr(10)
		      BuildingCombinedBat = True
		      CombinedWineRegIdx = 0
		      
		      RunRegistry
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      RunScripts
		      If SkippedInstalling = True Then
		        BuildingCombinedBat = False
		        Return False
		      End If
		      
		      BuildingCombinedBat = False
		      If CombinedWineBat <> "@echo off" + Chr(13) + Chr(10) Then
		        Dim CombinedBatPath As String = TmpPath + "install_noinstall_combined_" + ItemLLItem.BuildType + ".bat"
		        SaveDataToFile(CombinedWineBat, CombinedBatPath)
		        If Debugging Then Debug("Running combined bat (NoInstall): " + CombinedBatPath)
		        
		        Dim CombinedSh As New Shell
		        CombinedSh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		        CombinedSh.TimeOut = -1
		        
		        If TargetWindows Then
		          Dim WinBatPath As String = CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("cmd.exe /c " + Chr(34) + WinBatPath + Chr(34))
		        Else
		          Dim WineBatWinePath As String = "z:" + CombinedBatPath.ReplaceAll("/", "\")
		          CombinedSh.Execute("wine cmd.exe /c " + Chr(34) + WineBatWinePath + Chr(34))
		        End If
		        
		        Dim CombBufNI As String = ""
		        While CombinedSh.IsRunning
		          App.DoEvents(20)
		          CombBufNI = CombBufNI + CombinedSh.ReadAll 'Drain to prevent pipe deadlock
		        Wend
		        CombBufNI = CombBufNI + CombinedSh.ReadAll
		        If Debugging Then Debug("Combined bat result (NoInstall): " + CombBufNI)
		        
		        If TargetWindows Then
		          Try
		            Deltree(CombinedBatPath)
		          Catch
		          End Try
		        Else
		          ShellFast.Execute("bash -c 'rm -f " + Chr(34) + TmpPath + "bat_reg_*.reg" + Chr(34) + " " + Chr(34) + CombinedBatPath + Chr(34) + "'"  )
		        End If
		      End If
		    Else
		      ' Fallback for other platforms
		      RunRegistry
		      If SkippedInstalling = True Then 'Allows aborting a installation part way through
		        Return False
		      End If
		      RunScripts
		      If SkippedInstalling = True Then 'Allows aborting a installation part way through
		        Return False
		      End If
		    End If
		    
		    
		    'Make Links
		    MakeLinks
		    
		    
		    If SkippedInstalling = True Then 'Allows aborting a installation part way through
		      
		      Return False
		    End If
		    
		    
		    'Update Linux .desktop Links Database
		    If TargetLinux Then ShellFast.Execute ("bash -c 'update-desktop-database ~/.local/share/applications > /dev/null 2>&1 &'") 'Backgrounded: cache refresh only
		    
		  End If
		  
		  If TargetWindows Then 'Remove the outdated DB's if install any new items.
		    If ItemLLItem.BuildType = "ppGame" Then Deltree (ppGames+"\.lldb")
		  Else
		    If ItemLLItem.BuildType = "LLGame" Then Deltree (Slash(HomePath)+"LLGames/.lldb")
		    If ItemLLItem.BuildType = "ppGame" Then Deltree (ppGames+"/.lldb")
		  End If
		  
		  If InstallOnly = True Then Notify ("LLStore Installing", "Installing "+ItemLLItem.BuildType+":-"+Chr(10)+ItemLLItem.TitleName, ItemLLItem.FileIcon, 100) 'This closes the Notification Window
		  
		  'Put INIPath back to what it was
		  ItemLLItem.PathINI = TempString
		  
		  'Check if Install From is the temp folder and delete it if so
		  If InstallFromPath.IndexOf(TmpPath+"install") >=0 Then
		    If Debugging Then Debug("Delete Temp Path: "+ InstallFromPath)
		    Deltree(InstallFromPath) 'This cleans up after itself so you can have multiple installs running at once, unless the package manager is currently used as it locks it
		  End If
		  
		  'Cleanup Temp items after installed (UUID-per-launch keeps each app run's scripts isolated)
		  Deltree(Slash(TmpPath)+"LLShorts")
		  Deltree(Slash(TmpPath)+"Expanded_Script.cmd")
		  Deltree(Slash(TmpPath)+"Expanded_Script.sh")
		  Deltree(Slash(TmpPath)+"Expanded_Reg.reg")
		  
		  If CleanUpIsle2 <> "" Then Deltree(CleanUpIsle2) 'If used temp
		  CleanUpIsle2 = ""
		  
		  LogInstall("Success", "Installed: " + ItemLLItem.TitleName + " [" + ItemLLItem.BuildType + "] To: " + InstallToPath)
		  Return True ' Successfully Installed
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InstallLLStore()
		  Dim InstallPath As String
		  Dim MainPath As String = Slash(AppPath)
		  Dim Res As String
		  Dim TargetPath As String
		  Dim Target As String
		  Dim OutPath As String
		  
		  Notify ("LLStore Installing", "Installing LL Store:-"+Chr(10)+"LL Store v"+App.MajorVersion.ToString+"."+App.MinorVersion.ToString, ThemePath+"Icon.png", -1) 'Show it's installing LL Store
		  
		  
		  If TargetWindows Then
		    If Debugging Then Debug ("--- Installing LLStore in Windows ---")
		    MainPath = MainPath.ReplaceAll("/","\")
		    InstallPath = Slash(SpecialFolder.Applications.NativePath) + "\LLStore\"
		    InstallPath = InstallPath.ReplaceAll("/","\")
		    MakeFolder(InstallPath+"llstore Libs")
		    XCopy(MainPath+"llstore Libs", InstallPath+"llstore Libs\")
		    MakeFolder(InstallPath+"llstore Resources")
		    XCopy(MainPath+"llstore Resources", InstallPath+"llstore Resources\")
		    MakeFolder(InstallPath+"Presets")
		    XCopy(MainPath+"Presets", InstallPath+"Presets\")
		    MakeFolder(InstallPath+"Templates")
		    XCopy(MainPath+"Templates", InstallPath+"Templates\")
		    MakeFolder(InstallPath+"Themes")
		    XCopy(MainPath+"Themes", InstallPath+"Themes\")
		    MakeFolder(InstallPath+"Tools")
		    XCopy(MainPath+"Tools", InstallPath+"Tools\")
		    MakeFolder(InstallPath+"scripts")
		    XCopy(MainPath+"scripts", InstallPath+"scripts\")
		    XCopyFile(MainPath+"*.dll", InstallPath)
		    XCopyFile(MainPath+"version.ini", InstallPath)
		    XCopyFile(MainPath+"LLL_Settings.ini", InstallPath)
		    XCopyFile(MainPath+"LLL_Repos.ini", InstallPath)
		    ' Copy llstore.exe with lock detection — on Windows a running exe cannot be overwritten.
		    ' Snapshot src and dst dates before copying. If src=dst date it's a reinstall of the
		    ' same version, so an unchanged dst date after the copy is not treated as a failure.
		    Dim SrcExe As FolderItem = GetFolderItem(MainPath+"llstore.exe", FolderItem.PathTypeNative)
		    Dim DstExePath As String = InstallPath + "llstore.exe"
		    Dim DstExe As FolderItem = GetFolderItem(DstExePath, FolderItem.PathTypeNative)
		    Dim PreCopyDate As DateTime
		    Dim SrcDate As DateTime
		    If DstExe <> Nil And DstExe.Exists Then
		      Try
		        PreCopyDate = DstExe.ModificationDate
		      Catch
		        PreCopyDate = Nil
		      End Try
		    End If
		    If SrcExe <> Nil And SrcExe.Exists Then
		      Try
		        SrcDate = SrcExe.ModificationDate
		      Catch
		        SrcDate = Nil
		      End Try
		    End If
		    ' If src and dst already share the same modified date, this is a reinstall of the same version.
		    ' An unchanged dst date after the copy is then expected — skip the error in that case.
		    Dim SameVersionAlready As Boolean = False
		    If SrcDate <> Nil And PreCopyDate <> Nil Then
		      If SrcDate.SecondsFrom1970 = PreCopyDate.SecondsFrom1970 Then SameVersionAlready = True
		    End If
		    If SrcExe <> Nil And SrcExe.Exists Then
		      XCopyFile(MainPath+"llstore.exe", InstallPath)
		      DstExe = GetFolderItem(DstExePath, FolderItem.PathTypeNative) ' Re-fetch after copy
		      Dim PostCopyDate As DateTime
		      If DstExe <> Nil And DstExe.Exists Then
		        Try
		          PostCopyDate = DstExe.ModificationDate
		        Catch
		          PostCopyDate = Nil
		        End Try
		      End If
		      Dim CopyFailed As Boolean = False
		      If DstExe = Nil Or Not DstExe.Exists Then
		        CopyFailed = True
		      ElseIf PreCopyDate <> Nil And PostCopyDate <> Nil Then
		        If PostCopyDate.SecondsFrom1970 = PreCopyDate.SecondsFrom1970 Then CopyFailed = True
		      ElseIf PreCopyDate <> Nil And PostCopyDate = Nil Then
		        CopyFailed = True
		      End If
		      If CopyFailed And Not SameVersionAlready Then
		        MsgBox("Error: LLStore.exe could not be updated." + Chr(10) + Chr(10) + _
		        "LLStore.exe is still running in the background." + Chr(10) + _
		        "Please close all instances of LLStore and run the installer again.")
		      End If
		    End If
		    XCopyFile(MainPath+"llstore", InstallPath)
		    
		    
		    XCopyFile(MainPath+"LLLauncher.cmd", InstallPath)
		    XCopyFile(MainPath+"LLLauncher.sh", InstallPath)
		    XCopyFile(MainPath+"LLStore.sh", InstallPath)
		    XCopyFile(MainPath+"setup.cmd", InstallPath)
		    XCopyFile(MainPath+"setup.sh", InstallPath)
		    
		    Res = RunCommandResults ("icacls "+Chr(34)+ NoSlash(InstallPath)+Chr(34)+ " /grant "+ "Users:F /t /c /q") 'Using Chr(10) instead of ; as scripts don't allow them, only the prompt does
		    
		    'Make Shortcuts to SendTo and Start Menu
		    TargetPath = "C:\Program Files\LLStore"
		    Target = TargetPath +"\llstore.exe"
		    OutPath = Slash(SpecialFolder.ApplicationData.NativePath).ReplaceAll("/","\") + "Microsoft\Windows\SendTo\"
		    
		    'Send To
		    CreateShortcut("LL Install", Target, TargetPath, OutPath, "-i")
		    CreateShortcut("LL Edit", Target, TargetPath, OutPath, "-e", TargetPath +"\Themes\LLEdit.ico")
		    CreateShortcut("LL Edit (AutoBuild Archive)", Target, TargetPath, OutPath, "-c", TargetPath +"\Themes\LLEdit.ico")
		    CreateShortcut("LL Edit (AutoBuild Folder)", Target, TargetPath, OutPath, "-b", TargetPath +"\Themes\LLEdit.ico")
		    
		    'Start Menu
		    'OutPath = Slash(SpecialFolder.ApplicationData.NativePath).ReplaceAll("/","\") + "Microsoft\Windows\Start Menu\Programs\" 'Current User
		    OutPath = Slash(SpecialFolder.SharedApplicationData.NativePath).ReplaceAll("/","\") + "Microsoft\Windows\Start Menu\Programs\"
		    CreateShortcut("LL Edit", Target, TargetPath, OutPath, "-e", TargetPath +"\Themes\LLEdit.ico")
		    CreateShortcut("LL Store", Target, TargetPath, OutPath, "")
		    CreateShortcut("LL Launcher", Target, TargetPath, OutPath, "-l", TargetPath +"\Themes\LLLauncher.ico") 'Specifying the Icon is required for making the Launcher Blue
		    
		    'Desktop
		    'OutPath = Slash(SpecialFolder.Desktop.NativePath).ReplaceAll("/","\") 'Current User
		    OutPath = Slash(SpecialFolder.SharedDesktop.NativePath).ReplaceAll("/","\")
		    CreateShortcut("LL Store", Target, TargetPath, OutPath, "")
		    CreateShortcut("LL Launcher", Target, TargetPath, OutPath, "-l", TargetPath +"\Themes\LLLauncher.ico") 'Specifying the Icon is required for making the Launcher Blue
		    
		    
		    'Make .apz, .pgz, .app and .ppg associations.
		    MakeFileType("LLStore", "apz pgz app ppg", "LLStore File", Target, TargetPath, Target, "-i ") '2nd Target is the icon, The -i allows it to install default
		    
		    Tools.Hide
		  Else
		    If Debugging Then Debug ("--- Installing LLStore in Linux ---")
		    MainPath = MainPath.ReplaceAll("\","/")
		    InstallPath = "/LastOS/LLStore/"
		    Target = InstallPath+"llstore"
		    App.DoEvents(7)
		    EnableSudoScript
		    
		    MakeFolder(Slash(HomePath)+".local/share/applications")
		    
		    'Build a comprehensive install script to run with sudo once
		    Dim InstallScript As String
		    InstallScript = "#!/bin/bash" + Chr(10)
		    InstallScript = InstallScript + "set -e" + Chr(10) + Chr(10) 'Exit on any error
		    
		    'Create install directory and set initial permissions
		    InstallScript = InstallScript + "mkdir -p "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "if [ -f "+Chr(34)+MainPath+"Tools/setup_lastos_group.sh"+Chr(34)+" ]; then" + Chr(10)
		    InstallScript = InstallScript + "  bash "+Chr(34)+MainPath+"Tools/setup_lastos_group.sh"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "else" + Chr(10)
		    InstallScript = InstallScript + "  chmod -R 777 "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "fi" + Chr(10) + Chr(10)
		    
		    'Copy all directories and files to InstallPath
		    InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"llstore Libs"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"llstore Resources"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"Presets"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"Templates"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"Themes"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"Tools"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"scripts"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10) + Chr(10)
		    
		    'Copy individual files
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+Chr(34)+"*.dll "+Chr(34)+InstallPath+Chr(34)+" 2>/dev/null || true" + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"version.ini"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"LLL_Settings.ini"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"LLL_Repos.ini"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"llstore.exe"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34)+" 2>/dev/null || true" + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"llstore"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"LLLauncher.cmd"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"LLLauncher.sh"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"LLStore.sh"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"setup.cmd"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"setup.sh"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"libgthread-2.0.so.0"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34)+" 2>/dev/null || true" + Chr(10)
		    InstallScript = InstallScript + "cp "+Chr(34)+MainPath+"libgthread-2.0.so.0.txt"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34)+" 2>/dev/null || true" + Chr(10) + Chr(10)
		    
		    'Copy Icons for file types
		    If Exist(MainPath+"Tools/hicolor") Then
		      InstallScript = InstallScript + "cp -R "+Chr(34)+MainPath+"Tools/hicolor"+Chr(34)+" "+Chr(34)+"/usr/share/icons/"+Chr(34) + Chr(10)
		    End If
		    
		    'Apply final permissions
		    InstallScript = InstallScript + Chr(10) + "if [ -f "+Chr(34)+MainPath+"Tools/setup_lastos_group.sh"+Chr(34)+" ]; then" + Chr(10)
		    InstallScript = InstallScript + "  bash "+Chr(34)+MainPath+"Tools/setup_lastos_group.sh"+Chr(34)+" "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "else" + Chr(10)
		    InstallScript = InstallScript + "  chmod -R 777 "+Chr(34)+InstallPath+Chr(34) + Chr(10)
		    InstallScript = InstallScript + "fi" + Chr(10)
		    
		    'Execute the install script with sudo once
		    RunSudo(InstallScript)
		    
		    'Copy user-specific items without sudo (to user's home directory)
		    ShellFast.Execute("cp -R "+Chr(34)+MainPath+"Templates"+Chr(34)+" "+Chr(34)+Slash(HomePath)+Chr(34))
		    
		    If Exist(MainPath+"Tools/hicolor") Then ShellFast.Execute ("cp -R "+Chr(34)+MainPath+"Tools/hicolor"+Chr(34)+" "+Chr(34)+Slash(HomePath)+".local/share/icons/"+Chr(34))
		    
		    If SysDesktopEnvironment.Trim.Lowercase = "cinnamon" Then 'Add $HOME/.local/share/nemo/actions
		      ShellFast.Execute("cp -R "+Chr(34)+MainPath+"scripts/actions"+Chr(34)+" "+Chr(34)+Slash(HomePath)+".local/share/nemo/"+Chr(34))
		      ShellFast.Execute("cp -R "+Chr(34)+MainPath+"scripts/nautilus/scripts/LastOS"+Chr(34)+" "+Chr(34)+Slash(HomePath)+".local/share/nemo/scripts/"+Chr(34))
		    End If
		    
		    If SysDesktopEnvironment.Trim.Lowercase = "kde" Then 'Add $HOME/.local/share/kio/servicemenus
		      ShellFast.Execute("cp -R "+Chr(34)+MainPath+"scripts/share/kio"+Chr(34)+" "+Chr(34)+Slash(HomePath)+".local/share/"+Chr(34))
		    End If
		    
		    If SysDesktopEnvironment.Trim.Lowercase = "xfce" Then 'Add $HOME/.config/Thunar
		      ShellFast.Execute("cp -R "+Chr(34)+MainPath+"scripts/Thunar"+Chr(34)+" "+Chr(34)+Slash(HomePath)+".config/"+Chr(34))
		    End If
		    
		    If SysDesktopEnvironment.Trim.Lowercase = "gnome" Then 'Add $HOME/.local/share/nautilus/scripts
		      ShellFast.Execute("cp -R "+Chr(34)+MainPath+"scripts/nautilus"+Chr(34)+" "+Chr(34)+Slash(HomePath)+".local/share/"+Chr(34))
		    End If
		    
		    InstallLinuxContextMenus 'Install context menus for all detected Linux file managers
		    
		    InstallLinuxMenuSorting(True) 'This adds my own menu sorting style
		    
		    Dim Bin As String = " /usr/bin/" 'Make sure to include the space at the start of this as it's used.
		    
		    'Make SymLinks to Store
		    RunSudo("ln -sf "+Target+Bin+"llapp ; ln -sf "+Target+Bin+"lledit ; ln -sf "+Target+Bin+"llfile ; ln -sf "+Target+Bin+"llinstall ; ln -sf "+Target+Bin+"lllauncher ; ln -sf "+Target+Bin+"llstore" ) 'Sym Links do not need to be set to Exec
		    
		    'Make Associations - I changed it from Target to "llfile"
		    'MakeFileType("LLFile", "apz pgz tar app ppg lla llg", "Install LLFiles", Target, InstallPath, InstallPath+"llstore Resources/appicon_256.png", "", True) 'True is for SystemWide
		    MakeFileType("LLFile", "apz pgz tar app ppg lla llg", "Install LLFiles", "llfile", InstallPath, InstallPath+"llstore Resources/appicon_256.png", "", True) 'True is for SystemWide
		    
		    'Make LLStore as default for all supported types
		    'application/x-llfile
		    ShellFast.Execute ("xdg-mime default llfile_filetype.desktop application/x-llfile")
		    RunSudo ("xdg-mime default llfile_filetype.desktop application/x-llfile")
		    
		    
		    'Make Shortcuts
		    Dim DesktopContent As String
		    Dim DesktopFile As String
		    Dim DesktopOutPath As String
		    
		    'Store
		    DesktopContent = "[Desktop Entry]" + Chr(10)
		    DesktopContent = DesktopContent + "Type=Application" + Chr(10)
		    DesktopContent = DesktopContent + "Version=1.0" + Chr(10)
		    DesktopContent = DesktopContent + "Name=LL Store" + Chr(10)
		    DesktopContent = DesktopContent + "Exec=env GDK_BACKEND=x11 llstore" + Chr(10)
		    DesktopContent = DesktopContent + "Comment=Install LLFiles" + Chr(10)
		    DesktopContent = DesktopContent + "Icon=" + InstallPath+"llstore Resources/appicon_256.png" + Chr(10)
		    DesktopContent = DesktopContent + "Categories=Application;System;Settings;XFCE;X-XFCE-SettingsDialog;X-XFCE-SystemSettings;" + Chr(10)
		    DesktopContent = DesktopContent + "Terminal=No" + Chr(10)
		    
		    DesktopFile = "llstore.desktop"
		    DesktopOutPath = Slash(HomePath)+".local/share/applications/"
		    
		    ShellFast.Execute ("cp -f "+Chr(34)+Slash(AppPath)+"Tools/llstore.desktop"+Chr(34)+" "+Chr(34)+DesktopOutPath+Chr(34))
		    ShellFast.Execute ("cp -f "+Chr(34)+Slash(AppPath)+"Tools/lllauncher.desktop"+Chr(34)+" "+Chr(34)+DesktopOutPath+Chr(34))
		    
		    SaveDataToFile(DesktopContent, DesktopOutPath+DesktopFile)
		    ShellFast.Execute ("chmod 775 "+Chr(34)+DesktopOutPath+DesktopFile+Chr(34)) 'Change Read/Write/Execute to defaults
		    
		    'System Wide
		    RunSudo("cp -f "+DesktopOutPath+DesktopFile+" /usr/share/applications/")
		    
		    
		    DesktopOutPath = Slash(HomePath)+"Desktop/"
		    SaveDataToFile(DesktopContent, DesktopOutPath+DesktopFile)
		    ShellFast.Execute ("chmod 775 "+Chr(34)+DesktopOutPath+DesktopFile+Chr(34)) 'Change Read/Write/Execute to defaults
		    
		    'Editor
		    DesktopContent = "[Desktop Entry]" + Chr(10)
		    DesktopContent = DesktopContent + "Type=Application" + Chr(10)
		    DesktopContent = DesktopContent + "Version=1.0" + Chr(10)
		    DesktopContent = DesktopContent + "Name=LL Editor" + Chr(10)
		    DesktopContent = DesktopContent + "Exec=env GDK_BACKEND=x11 llstore -e" + Chr(10)
		    DesktopContent = DesktopContent + "Comment=Edit LLFiles" + Chr(10)
		    DesktopContent = DesktopContent + "Icon=" + InstallPath+"Themes/LLEditor.png" + Chr(10)
		    DesktopContent = DesktopContent + "Categories=Application;System;Settings;XFCE;X-XFCE-SettingsDialog;X-XFCE-SystemSettings;" + Chr(10)
		    DesktopContent = DesktopContent + "Terminal=No" + Chr(10)
		    
		    DesktopFile = "lledit.desktop"
		    DesktopOutPath = Slash(HomePath)+".local/share/applications/"
		    SaveDataToFile(DesktopContent, DesktopOutPath+DesktopFile)
		    ShellFast.Execute ("chmod 775 "+Chr(34)+DesktopOutPath+DesktopFile+Chr(34)) 'Change Read/Write/Execute to defaults
		    
		    'System Wide
		    RunSudo("cp -f "+DesktopOutPath+DesktopFile+" /usr/share/applications/")
		    
		    
		    'Launcher
		    DesktopContent = "[Desktop Entry]" + Chr(10)
		    DesktopContent = DesktopContent + "Type=Application" + Chr(10)
		    DesktopContent = DesktopContent + "Version=1.0" + Chr(10)
		    DesktopContent = DesktopContent + "Name=LL Launcher" + Chr(10)
		    DesktopContent = DesktopContent + "Exec=env GDK_BACKEND=x11 llstore -l" + Chr(10)
		    DesktopContent = DesktopContent + "Comment=Launch LLStore games" + Chr(10)
		    DesktopContent = DesktopContent + "Icon=" + InstallPath+"Themes/LLLauncher.png" + Chr(10)
		    DesktopContent = DesktopContent + "Categories=Game;" + Chr(10)
		    DesktopContent = DesktopContent + "Terminal=No" + Chr(10)
		    
		    DesktopFile = "lllauncher.desktop"
		    DesktopOutPath = Slash(HomePath)+".local/share/applications/"
		    SaveDataToFile(DesktopContent, DesktopOutPath+DesktopFile)
		    ShellFast.Execute ("chmod 775 "+Chr(34)+DesktopOutPath+DesktopFile+Chr(34)) 'Change Read/Write/Execute to defaults
		    
		    'System Wide
		    RunSudo("cp -f "+DesktopOutPath+DesktopFile+" /usr/share/applications/")
		    
		    DesktopOutPath = Slash(HomePath)+"Desktop/"
		    SaveDataToFile(DesktopContent, DesktopOutPath+DesktopFile)
		    ShellFast.Execute ("chmod 775 "+Chr(34)+DesktopOutPath+DesktopFile+Chr(34)) 'Change Read/Write/Execute to defaults
		    
		    'Run Fixes
		    If Wayland = True Then 
		      If Exist(Slash(ToolPath)+"WaylandFixes.sh") Then
		        ShellFast.Execute(Slash(ToolPath)+"WaylandFixes.sh")
		      End If
		    End If
		    '
		    'Refresh desktop database — must happen before Unlock closes the sudo terminal.
		    'User path: backgrounded via ShellFast, no privileges needed.
		    '/usr/share/applications: root-owned, sent through the still-open sudo terminal with & so it doesn't block.
		    If TargetLinux Then ShellFast.Execute ("bash -c 'update-desktop-database ~/.local/share/applications > /dev/null 2>&1 &'")
		    If TargetLinux Then RunSudo ("update-desktop-database /usr/share/applications &")
		    '
		    'Close Sudo Terminal
		    If KeepSudo = False Then ShellFast.Execute ("echo "+Chr(34)+"Unlock"+Chr(34)+" > "+BaseDir+"/LLSudoDone") 'Quits Terminal after All items have been installed.
		  End If
		  
		  Notify ("LLStore Installed", "Installed LL Store:-"+Chr(10)+"LL Store v"+App.MajorVersion.ToString+"."+App.MinorVersion.ToString, ThemePath+"Icon.png", 3000) 'Show its finished installing LL Store
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InStrRev(SourceString As String, FindString As String, Start As Integer = -1) As Integer
		  Dim k, LastFound, Length As Integer
		  
		  If SourceString = "" Then Return 0
		  If FindString = "" Then Return Start
		  k = Instr(SourceString, FindString)
		  LastFound = k
		  Length = Len(SourceString)
		  If Start = -1 Then Start = Length
		  If k > Start Or Start > Length Then Return 0
		  
		  While k > 0
		    LastFound = k
		    If k < Start Then k = Instr(LastFound+1, SourceString, FindString) Else Exit While
		  Wend
		  Return LastFound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAdmin() As Boolean
		  'Checks if running as admin by accessing a folder/file only admins can access.
		  
		  If TargetWindows Then
		    
		    Dim TMPShell As New Shell
		    'TMPShell.TimeOut = -1
		    TMPShell.Execute "echo Hi > "+Chr(34)+"%windir%\system32\AdminMode_LLStore.ini"+Chr(34) '+" >nul"
		    
		    If TMPShell.ErrorCode = 1 Then Return False 'No it's not Admin
		    
		    TMPShell.Execute "del /q /f "+Chr(34)+"%windir%\system32\AdminMode_LLStore.ini"+Chr(34) '+" >nul"
		    Return True 'Yes it is Admin
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsFolder(TestPath As String) As Boolean
		  Dim F As FolderItem
		  #Pragma BreakOnExceptions Off
		  Try
		    F = GetFolderItem(TestPath, FolderItem.PathTypeNative)
		    If F <> Nil Then
		      If F.Exists Then
		        If F.IsFolder Then Return True
		      End If
		    End If
		  Catch
		  End Try
		  #Pragma BreakOnExceptions On
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsTrue(Inn As String) As Boolean
		  Dim IsTrue As Boolean
		  IsTrue = False
		  Select Case Inn.Lowercase
		  Case "y", "yes",  "t", "true","1","on"
		    IsTrue = True
		  End Select
		  
		  Return IsTrue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsWritable(PathIn As String) As Boolean
		  Dim F As FolderItem
		  Dim Writable As Boolean
		  #Pragma BreakOnExceptions Off
		  Try
		    F = GetFolderItem(PathIn)
		    Writable = F.IsWriteable
		  Catch
		    Writable = False
		  End Try
		  #Pragma BreakOnExceptions On
		  Return Writable
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoadDataFromFile(FileIn As String) As String
		  If TargetWindows Then
		    FileIn = FileIn.ReplaceAll("/","\")
		  Else
		    FileIn = FileIn.ReplaceAll("\","/")
		  End If
		  
		  If FileIn <> "" Then
		    
		    If Debugging Then Debug("- Load Data From File: "+ FileIn)
		    
		    Dim F As FolderItem
		    Dim T As TextInputStream
		    
		    #Pragma BreakOnExceptions Off
		    
		    Try
		      F = GetFolderItem(FileIn, FolderItem.PathTypeNative)
		      If F <> Nil Then
		        If F.Exists And F.IsReadable Then
		          T = TextInputStream.Open(F)
		          While Not T.EndOfFile 'If Empty file this skips it
		            Return T.ReadAll
		          Wend
		          T.Close
		        End If
		      End If
		    Catch
		    End Try
		    Return ""
		    #Pragma BreakOnExceptions On
		  End If
		  
		  Return ""
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoadLLFile(ItemInn As String, InnTmp As String = "", InstallItem As Boolean = False, RegenOnly As Boolean = False) As Boolean
		  'App.DoEvents(1)
		  
		  CurrentssAppFile = ""
		  
		  EditingLnk = 0
		  
		  ItemLLItem = BlankItem 'Clear All Data
		  InstallFromIni = ""
		  
		  If ItemInn = "" Then Return False 'Nothing given
		  
		  'Fix ItemInn to forward slashes, Hasn't caused a problem yet
		  ItemInn = ItemInn.ReplaceAll("\","/")
		  
		  If Debugging Then Debug("Load LLFile: "+ ItemInn)
		  
		  Dim I As Integer
		  Dim F As FolderItem
		  Dim SP() As String
		  Dim Exten As String
		  Dim Lin As String
		  Dim LineID, OrigLine As String
		  Dim LineData As String
		  Dim EqPos As Integer
		  Dim ReadMode As Integer
		  Dim Compressed As Boolean = False
		  Dim ActualIni As String
		  
		  Dim UniqueName As String = ""
		  
		  Dim Success As Boolean
		  
		  Dim TmpItem As String
		  
		  'Make installer path more random and only do extracts in order as this is only to grab icons and details of items.
		  If InstallItem = False Then
		    TmpItemCount = TmpItemCount + 1
		    TmpItem = Slash(TmpPathItems+"tmp" + TmpItemCount.ToString) 'I think 30k Items will do, just in case
		  Else
		    TmpItem = Slash(TmpPath+"install" + Randomiser.InRange(10000, 20000).ToString) 'I think 10k Items will do, just in case
		    CleanUpIsle2 = TmpItem
		  End If
		  
		  'Don't make folder,7z makes it MUCH faster than a Shell call
		  'MakeFolder(TmpItem) 'Make items temp path
		  
		  For I = 0 To LnkCount + 1 'Clear all Links for items - Uses old LnkCount just to add a little speed up
		    ItemLnk(I) = BlankItemLnk
		  Next I
		  LnkCount = 0
		  
		  ItemIcon = Nil
		  ItemFader = Nil
		  ItemScreenshot = Nil
		  
		  TempInstall = ""
		  
		  'Removed Exist (If it's made it this far then assume it's really there
		  Exten = Right(ItemInn,4).Lowercase
		  
		  Select Case Exten
		  Case ".lla"
		    ItemLLItem.PathINI = Left(ItemInn,InStrRev(ItemInn,"/"))
		    ItemLLItem.BuildType = "LLApp"
		    Success = True
		  Case ".llg"
		    ItemLLItem.PathINI = Left(ItemInn,InStrRev(ItemInn,"/"))
		    ItemLLItem.BuildType = "LLGame"
		    Success = True
		  Case ".app"
		    ItemLLItem.PathINI = Left(ItemInn,InStrRev(ItemInn,"/"))
		    Success = True
		  Case ".ppg"
		    ItemLLItem.PathINI = Left(ItemInn,InStrRev(ItemInn,"/"))
		    ItemLLItem.BuildType = "ppGame"
		    Success = True
		  Case ".tar"
		    ItemLLItem.PathINI = ItemInn
		    If InnTmp <>"" Then
		      TmpItem = InnTmp
		      Success = True
		    Else
		      If InstallItem = False Then
		        Success = Extract(ItemInn, TmpItem, " LLApp.lla LLGame.llg LLScript.sh LLScript_Sudo.sh LLFile.sh LLApp.jpg LLApp.png LLApp.ico LLApp.svg LLGame.jpg LLGame.png LLGame.ico LLGame.svg LLApp1.jpg LLGame1.jpg LLApp2.jpg LLGame2.jpg LLApp3.jpg LLGame3.jpg LLApp4.jpg LLGame4.jpg LLApp5.jpg LLGame5.jpg LLApp6.jpg LLGame6.jpg")
		        If Debugging Then Debug ("Extracting Partial tar: "+ ItemInn+" TempInstallPath: "+ TmpItem + " Success: "+ Success.ToString)
		      Else ' Extract Everything
		        Success = Extract(ItemInn, TmpItem, "")
		        If Debugging Then Debug ("Extracting tar: "+ ItemInn+" TempInstallPath: "+ TmpItem + " Success: "+ Success.ToString)
		      End If
		    End If
		    TempInstall = TmpItem
		    Compressed = True
		  Case".apz"
		    ItemLLItem.PathINI = ItemInn
		    If InnTmp <>"" Then
		      TmpItem = InnTmp
		      Success = True
		    Else
		      If InstallItem = False Then
		        Success = Extract(ItemInn, TmpItem, " ssApp.app ppApp.app ssApp.jpg ppApp.jpg ssApp.png ppApp.png ssApp.ico ppApp.ico ppApp1.jpg ppApp2.jpg ppApp3.jpg ppApp4.jpg ppApp5.jpg ppApp6.jpg ssApp1.jpg ssApp2.jpg ssApp3.jpg ssApp4.jpg ssApp5.jpg ssApp6.jpg") ', True) '<- True means Fast, not using Execute, just Shell (trying without to see if it locks up the GUI in Xojo First).
		        If Debugging Then Debug ("Extracting Partial apz: "+ ItemInn+" TempInstallPath: "+ TmpItem + " Success: "+ Success.ToString)
		      Else ' Extract Everything
		        Success = Extract(ItemInn, TmpItem, "")
		        If Debugging Then Debug ("Extracting apz: "+ ItemInn+" TempInstallPath: "+ TmpItem + " Success: "+ Success.ToString)
		      End If
		    End If
		    TempInstall = TmpItem
		    Compressed = True
		  Case ".pgz"
		    ItemLLItem.PathINI = ItemInn
		    ItemLLItem.BuildType = "ppGame"
		    If InnTmp <>"" Then
		      TmpItem = InnTmp
		      Success = True
		    Else
		      If InstallItem = False Then
		        Success = Extract(ItemInn, TmpItem, " ppGame.ppg ppGame.jpg ppGame.png ppGame.ico ppGame1.jpg ppGame2.jpg ppGame3.jpg ppGame4.jpg ppGame5.jpg ppGame6.jpg") ', True) '<- True means Fast, not using Execute, just Shell (trying without to see if it locks up the GUI in Xojo First).
		        If Debugging Then Debug ("Extracting Partial pgz: "+ ItemInn+" TempInstallPath: "+ TmpItem + " Success: "+ Success.ToString)
		      Else ' Extract Everything
		        Success = Extract(ItemInn, TmpItem, "")
		        If Debugging Then Debug ("Extracting pgz: "+ ItemInn+" TempInstallPath: "+ TmpItem + " Success: "+ Success.ToString)
		      End If
		    End If
		    TempInstall = TmpItem
		    Compressed = True
		  End Select
		  
		  If Success = False Then
		    If Debugging Then Debug ("* Error: Failed to load LLFile Aborting.")
		    Return False 'Abort, Don't load dud Items
		  Else
		    'If Debugging Then Debug ("Set File next")
		  End If
		  ItemLLItem.FileINI = ItemInn 'Set FileINI for item, has full path, also includes compressed file if is one
		  
		  If Compressed = False Then
		    If Debugging Then Debug ("Un-Compressed LLFile")
		    ActualIni = ItemInn ' Sets to this as Default, Compressed below will change it
		    If ActualIni = "" Then Return False 'Failed to set the item
		    #Pragma BreakOnExceptions Off
		    Try
		      F = GetFolderItem(ActualIni,FolderItem.PathTypeNative)
		    Catch
		      If Debugging Then Debug ("* Error: Failed to load LLFile, Skip: "+ActualIni)
		      Return False'Failed to set the item
		    End Try
		    #Pragma BreakOnExceptions On
		    If Not F.Exists Then
		      If Debugging Then Debug ("* Error: Failed to Set LLFile, Skip: "+ActualIni)
		      Return False'Failed to set the item
		    End If
		  Else
		    'Grab the uncompressed temp folder to load from
		    If Debugging Then Debug ("Compressed LLFile")
		    ActualIni = ""
		    If Exist(TmpItem + "LLApp.lla") Then
		      ActualIni = TmpItem + "LLApp.lla"
		    ElseIf Exist(TmpItem + "LLGame.llg") Then
		      ActualIni = TmpItem + "LLGame.llg"
		    ElseIf Exist(TmpItem + "ssApp.app") Then
		      ActualIni = TmpItem + "ssApp.app"
		    ElseIf Exist(TmpItem + "ppApp.app") Then
		      ActualIni = TmpItem + "ppApp.app"
		    ElseIf Exist(TmpItem + "ppGame.ppg") Then
		      ActualIni = TmpItem + "ppGame.ppg"
		    End If
		    
		    If ActualIni = "" Then Return False 'Failed to set the item
		    F = GetFolderItem(ActualIni,FolderItem.PathTypeNative)
		    If Not F.Exists Then Return False'Failed to set the item, did it fail to extract
		  End If
		  
		  InstallFromIni = ActualIni
		  '''''If Right(ActualIni,9) = "ssApp.app" Then CurrentssAppFile = ActualIni 'This is used by the MoveLinks to generate the new ssApp.app file for installed items
		  
		  If Debugging Then Debug("Load LLFile: "+ ActualIni)
		  
		  'Load in whole file at once (Fastest Method)
		  Try
		    inputStream = TextInputStream.Open(F)
		  Catch
		    Return False 'Failed, just skip item
		  End Try
		  
		  Dim RL As String
		  While Not inputStream.EndOfFile 'If Empty file this skips it
		    RL = inputStream.ReadAll
		  Wend
		  inputStream.Close
		  
		  RL = RL.ReplaceAll(Chr(13), Chr(10))
		  Sp()=RL.Split(Chr(10))
		  If Sp.Count <= 0 Then Return False ' Empty File or no header
		  
		  If Debugging Then Debug("LLFile Not Empty")
		  
		  Lin = Sp(0).Trim.Lowercase
		  If Lin = "[llfile]" Or Lin = "[setups]" Then 'Only work with files that are really our files
		    ItemLLItem.BuildType = "LLApp" 'Default to LLApps
		    If ItemInn.EndsWith("LLGame.llg") Then
		      ItemLLItem.BuildType = "LLGame" 'Switch to Game if not an App
		    End If
		    ItemLLItem.Priority = 5 'Default Priority
		    LnkEditing = 0
		    ReadMode = 0
		    ItemLLItem.Hidden = False
		    ItemLLItem.HiddenAlways = False
		    ItemLLItem.ShowSetupOnly = False
		    ItemLLItem.NoInstall = False
		    ItemLLItem.KeepAll = False
		    ItemLLItem.KeepInFolder = False
		    ItemLLItem.SendTo = False
		    ItemLLItem.InternetRequired = False
		    ItemLLItem.ForceDERefresh = False
		    For I = 1 To Sp().Count -1
		      Lin = Sp(I).Trim
		      OrigLine = Lin
		      EqPos = Lin.IndexOf(1,"=")
		      LineID = ""
		      LineData = ""
		      If  EqPos >= 1 Then
		        LineID = Left(Lin,EqPos)
		        LineData = Right(Lin,Len(Lin)-Len(LineID)-1)
		        LineID=LineID.Trim.Lowercase
		        LineData=LineData.Trim
		      Else 'No Equals, probably a shortcut
		        LineID = Lin.Trim
		      End If
		      
		      If ReadMode = 0 Then  'Only if ReadMode = 0
		        Select Case LineID
		        Case "title"
		          If LineData = "" Then Return False
		          ItemLLItem.TitleName = LineData
		          If Debugging Then Debug("Title To Install: "+LineData)
		          Continue 'Once used Data no need to process the rest
		        Case "version"
		          ItemLLItem.Version = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "description"
		          ItemLLItem.Descriptions = LineData '.ReplaceAll(Chr(30),Chr(13)) 'Disabled converting the Data to CRLF to speed up loading and to make writing the DB files easier
		          Continue 'Once used Data no need to process the rest
		        Case "apppath"
		          If EditingItem Then
		            ItemLLItem.PathApp = LineData
		          Else
		            ItemLLItem.PathApp = ExpPath(LineData)
		          End If
		          If TargetWindows Then
		            ItemLLItem.PathApp = ItemLLItem.PathApp.ReplaceAll("/","\")
		            If StoreMode = 1 And Not Exist(ItemLLItem.PathApp) Then ItemLLItem.PathApp = ItemLLItem.PathINI ' make sure it's valid
		          Else
		            ItemLLItem.PathApp = ItemLLItem.PathApp.ReplaceAll("\","/")
		          End If
		          Continue 'Once used Data no need to process the rest
		        Case "url"
		          ItemLLItem.URL = LineData '.ReplaceAll("|",Chr(13)) 'Leep condensed for now
		          Continue 'Once used Data no need to process the rest
		        Case "category"
		          ItemLLItem.Categories = FixGameCats(LineData)
		          
		          'Fix Categories
		          If ItemLLItem.BuildType = "ppGame" Or ItemLLItem.BuildType = "LLGame" Then
		            If Left(ItemLLItem.Categories, 5) <>"Game;" And ItemLLItem.Categories.IndexOf(" Game;") <= 0 Then  ItemLLItem.Categories=ItemLLItem.Categories+" Game;"
		          End If
		          ItemLLItem.Categories = ItemLLItem.Categories.Trim
		          
		          Continue 'Once used Data no need to process the rest
		        Case "buildtype"
		          If LineData <> "" Then ItemLLItem.BuildType = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "assembly"
		          ItemLLItem.Assembly = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "shortcutnameskeep"
		          ItemLLItem.ShortCutNamesKeep = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "catalog"
		          ItemLLItem.Catalog = FixCatalog(LineData)
		          'Fix Catalog
		          If ItemLLItem.BuildType = "ppGame" Or ItemLLItem.BuildType = "LLGame" Then
		            If Left(ItemLLItem.Catalog, 5) <>"Game;" And ItemLLItem.Catalog.IndexOf(" Game;") <= 0 Then  ItemLLItem.Catalog=ItemLLItem.Catalog+" Game;"
		          End If
		          ItemLLItem.Catalog = ItemLLItem.Catalog.Trim
		          Continue 'Only need to process this line and then move to the next
		        Case "startmenulegacyprimary"
		          ItemLLItem.StartMenuLegacyPrimary = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "startmenulegacysecondary"
		          ItemLLItem.StartMenuLegacySecondary = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "startmenusourcepath"
		          ItemLLItem.StartMenuSourcePath = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "flags"
		          ItemLLItem.Flags = LineData.Lowercase
		          If ItemLLItem.Flags.IndexOf("alwayshide") >= 0 Then
		            ItemLLItem.Hidden = True
		            ItemLLItem.HiddenAlways = True
		          End If
		          If ItemLLItem.Flags.IndexOf("hidden") >= 0 Then ItemLLItem.Hidden = True
		          If ItemLLItem.Flags.IndexOf("showsetuponly") >= 0 Then
		            ItemLLItem.ShowSetupOnly = True
		            If StoreMode <> 0 Then ItemLLItem.Hidden = True
		          End If
		          If ItemLLItem.Flags.IndexOf("internetrequired") >= 0 Then ItemLLItem.InternetRequired = True
		          If ItemLLItem.Flags.IndexOf("noinstall") >= 0 Then ItemLLItem.NoInstall = True
		          If ItemLLItem.Flags.IndexOf("keepall") >= 0 Then ItemLLItem.KeepAll = True
		          If ItemLLItem.Flags.IndexOf("keepinfolder") >= 0 Then ItemLLItem.KeepInFolder = True
		          If ItemLLItem.Flags.IndexOf("sendto") >= 0 Then ItemLLItem.SendTo = True
		          If ItemLLItem.Flags.IndexOf("forcederefresh") >= 0 Then
		            ItemLLItem.ForceDERefresh = True
		            ForceDERefresh = True
		          End If
		          Continue 'Once used Data no need to process the rest, The other lines will cause the lower things to be tested per line
		        Case "priority"
		          ItemLLItem.Priority = Val(LineData)
		          Continue 'Once used Data no need to process the rest
		        Case "priorityorder"
		          ItemLLItem.Priority = Val(LineData)
		          Continue 'Once used Data no need to process the rest
		        Case "tags"
		          ItemLLItem.Tags = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "publisher"
		          ItemLLItem.Publisher = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "language"
		          ItemLLItem.Language = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "arch","architecture"
		          ItemLLItem.Arch = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "os"
		          ItemLLItem.OS = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "rating"
		          ItemLLItem.Rating = Val(LineData)
		          Continue 'Once used Data no need to process the rest
		        Case "players"
		          ItemLLItem.Players = Val(LineData)
		          Continue 'Once used Data no need to process the rest
		        Case "license"
		          ItemLLItem.License = Val(Left(LineData,1)) '0-Unknown, 1-Paid, 2-Free, 3-Open
		          Continue 'Once used Data no need to process the rest
		        Case "licensetype"
		          ItemLLItem.License = Val(LineData)
		          Continue 'Once used Data no need to process the rest
		        Case "releaseversion"
		          ItemLLItem.ReleaseVersion = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "releasedate"
		          ItemLLItem.ReleaseDate = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "releaser"
		          ItemLLItem.Builder = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "installedsize"
		          ItemLLItem.InstallSize = Val(LineData)
		          Continue 'Once used Data no need to process the rest
		        Case "oscompatible"
		          ItemLLItem.OSCompatible = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "decompatible"
		          ItemLLItem.DECompatible = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "pmcompatible"
		          ItemLLItem.PMCompatible = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "archcompatible"
		          ItemLLItem.ArchCompatible = LineData
		          Continue 'Once used Data no need to process the rest
		        Case "dependencies"
		          ItemLLItem.Dependencies = LineData
		          Continue 'Once used Data no need to process the rest
		        End Select
		        
		      End If 'Only if ReadMode = 0
		      
		      If Right(LineID, 9) = ".desktop]" Then 'Found Shortcut
		        LnkCount = LnkCount + 1
		        LnkEditing = LnkCount
		        ItemLnk(LnkEditing).Title = Left(LineID, Len(LineID)-9)
		        ItemLnk(LnkEditing).Title = Right(ItemLnk(LnkEditing).Title, Len(ItemLnk(LnkEditing).Title) - 1)
		        
		        ItemLnk(LnkEditing).Active = True
		        ItemLnk(LnkEditing).LinuxLink = True 'Mark as Linux .desktop link
		        ReadMode = 1
		      End If
		      
		      If Right(LineID, 5) = ".lnk]" Then 'Found Shortcut
		        LnkCount = LnkCount + 1
		        LnkEditing = LnkCount
		        ItemLnk(LnkEditing).Title = Left(LineID, Len(LineID)-5)
		        ItemLnk(LnkEditing).Title = Right(ItemLnk(LnkEditing).Title, Len(ItemLnk(LnkEditing).Title) - 1)
		        'Don't use Description, I'll make it fall back to the original Items Description
		        'ItemLnk(LnkEditing).Description = ItemLLItem.Descriptions 'Use main Items description, gets replaced if another is given
		        ItemLnk(LnkEditing).Active = True
		        ItemLnk(LnkEditing).LinuxLink = False 'Mark as Windows .lnk link
		        ReadMode = 1
		      End If
		      
		      If ReadMode = 1 Then 'Fix the exp paths (they are in the AddItem now)
		        'If ItemLnk(LnkEditing).Categories = "" Then ItemLnk(LnkEditing).Categories = ItemLLItem.Categories
		        If ItemLnk(LnkEditing).Categories = "" Then ItemLnk(LnkEditing).Categories = ItemLLItem.Catalog 'Try using Catalog , may break Sorting in LLStore, so might need to add a new field
		        
		        Select Case LineID
		        Case "exec"
		          ItemLnk(LnkEditing).Link.TargetPath = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "target"
		          ItemLnk(LnkEditing).Link.TargetPath = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "arguments"
		          ItemLnk(LnkEditing).Link.Arguments = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "comment"
		          ItemLnk(LnkEditing).Link.Description = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "description"
		          If LineData <> "" Then ItemLnk(LnkEditing).Description = LineData.ReplaceAll(Chr(30), Chr(10)) 'Replace RS lines ASAP to avoid issues, save will make sure to put them back
		          Continue 'Only need to process this line and then move to the next
		        Case "path"
		          ItemLnk(LnkEditing).Link.WorkingDirectory = Trim(LineData)
		          If ItemLnk(LnkEditing).Link.WorkingDirectory = "" Then ItemLnk(LnkEditing).Link.WorkingDirectory= Slash(ItemLLItem.PathApp)
		          Continue 'Only need to process this line and then move to the next
		        Case "icon"
		          ItemLnk(LnkEditing).Link.IconLocation = Trim(LineData)
		          '''''''If ItemLnk(LnkEditing).Link.IconLocation = "" Then ItemLnk(LnkEditing).Link.IconLocation = Slash(ItemLLItem.PathApp) + ItemLLItem.BuildType + ".png" ' No If empty it uses the .exe one which is correct
		          Continue 'Only need to process this line and then move to the next
		        Case "categories"
		          ItemLnk(LnkEditing).Categories = FixGameCats(LineData)
		          'Fix Categories, Can do here because the type is set above
		          If ItemLLItem.BuildType = "ppGame" Or ItemLLItem.BuildType = "LLGame" Then
		            If Left(ItemLnk(LnkEditing).Categories, 5) <>"Game;" And ItemLnk(LnkEditing).Categories.IndexOf(" Game;") <= 0 Then  ItemLnk(LnkEditing).Categories=ItemLnk(LnkEditing).Categories+" Game;"
		          End If
		          Continue 'Only need to process this line and then move to the next
		        Case "extensions"
		          ItemLnk(LnkEditing).Associations = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "flags"
		          ItemLnk(LnkEditing).Flags = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "terminal"
		          If LineData = "True" Then ItemLnk(LnkEditing).Terminal= True Else ItemLnk(LnkEditing).Terminal= False
		          Continue 'Only need to process this line and then move to the next
		        Case "showon"
		          If OrigLine.IndexOf("desktop") >= 1 Then ItemLnk(LnkEditing).Desktop = True Else ItemLnk(LnkEditing).Desktop = False
		          If OrigLine.IndexOf("panel") >= 1  Then ItemLnk(LnkEditing).Panel = True Else ItemLnk(LnkEditing).Panel = False
		          If OrigLine.IndexOf("favorite") >= 1 Then ItemLnk(LnkEditing).Favorite = True Else ItemLnk(LnkEditing).Favorite = False
		          If OrigLine.IndexOf("sendto") >= 1 Then ItemLnk(LnkEditing).LnkSendTo = True Else ItemLnk(LnkEditing).LnkSendTo = False
		          Continue 'Only need to process this line and then move to the next
		        Case "lnkoscompatible"
		          ItemLnk(LnkEditing).LnkOSCompatible = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "lnkdecompatible"
		          ItemLnk(LnkEditing).LnkDECompatible = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "lnkpmcompatible"
		          ItemLnk(LnkEditing).LnkPMCompatible = LineData
		          Continue 'Only need to process this line and then move to the next
		        Case "lnkarchcompatible"
		          ItemLnk(LnkEditing).LnkArchCompatible = LineData
		          Continue 'Only need to process this line and then move to the next
		        End Select
		      End If 'End ReadMode 1
		    Next
		    
		    ItemLLItem.LnkCount = LnkCount
		  End If
		  
		  'Check if Category is set, else revert to Catalog, we need it sorted somehow
		  If ItemLLItem.Categories = "" Then 
		    If ItemLLItem.Catalog <> "" Then ItemLLItem.Categories = ItemLLItem.Catalog
		  End If
		  
		  
		  
		  'Get Screenshots, Faders and Icons ***********************
		  
		  Dim MediaPath As String
		  MediaPath = Slash(ExpPath(ItemLLItem.PathINI)) 
		  If Compressed = True Then
		    ItemLLItem.Compressed = True
		    MediaPath = TmpItem
		  End If
		  
		  'Set Unique Name to check for alternative screenshots and icons
		  UniqueName = ItemLLItem.TitleName.Lowercase + ItemLLItem.BuildType.Lowercase
		  UniqueName= UniqueName.ReplaceAll(" ","")
		  
		  
		  If RegenOnly = True Then Return True 'No need to load graphics in
		  
		  'Load Items Screenshot and Fader
		  'Screenshot
		  ItemLLItem.FileScreenshot =  MediaPath+UniqueName+".jpg"
		  F = GetFolderItem(ItemLLItem.FileScreenshot, FolderItem.PathTypeNative)
		  If Not F.Exists Then
		    ItemLLItem.FileScreenshot =  MediaPath+ItemLLItem.BuildType+".jpg"
		    F = GetFolderItem(ItemLLItem.FileScreenshot, FolderItem.PathTypeNative)
		    If Not F.Exists Then ItemLLItem.FileScreenshot =  "" 'None
		  End If
		  NewFileScreenshot = ItemLLItem.FileScreenshot
		  
		  'Fader
		  ItemLLItem.FileFader =  MediaPath+UniqueName+".png"
		  'MsgBox ItemLLItem.FileFader
		  F = GetFolderItem(ItemLLItem.FileFader, FolderItem.PathTypeNative)
		  If Not F.Exists Then
		    ItemLLItem.FileFader =  MediaPath+UniqueName+".svg"
		    F = GetFolderItem(ItemLLItem.FileFader, FolderItem.PathTypeNative)
		    If Not F.Exists Then
		      ItemLLItem.FileFader =  MediaPath +ItemLLItem.BuildType+".png"
		      F = GetFolderItem(ItemLLItem.FileFader, FolderItem.PathTypeNative)
		      If Not F.Exists Then
		        ItemLLItem.FileFader =  MediaPath+ItemLLItem.BuildType+".svg"
		        F = GetFolderItem(ItemLLItem.FileIcon, FolderItem.PathTypeNative)
		        If Not F.Exists Then 
		          ItemLLItem.FileFader =  MediaPath +ItemLLItem.BuildType+".ico"
		          F = GetFolderItem(ItemLLItem.FileFader, FolderItem.PathTypeNative)
		          If Not F.Exists Then
		            ItemLLItem.FileFader =  "" 'None
		            ItemIcon = Nil
		          End If
		        End If
		      End If
		    End If
		  End If
		  NewFileFader = ItemLLItem.FileFader
		  
		  'Icon
		  ItemLLItem.FileIcon =  MediaPath+UniqueName+".svg"
		  F = GetFolderItem(ItemLLItem.FileIcon, FolderItem.PathTypeNative)
		  If Not F.Exists Then
		    ItemLLItem.FileIcon =  MediaPath+UniqueName+".png"
		    F = GetFolderItem(ItemLLItem.FileIcon, FolderItem.PathTypeNative)
		    If Not F.Exists Then
		      
		      ItemLLItem.FileIcon =  MediaPath +ItemLLItem.BuildType+".svg"
		      F = GetFolderItem(ItemLLItem.FileIcon, FolderItem.PathTypeNative)
		      If Not F.Exists Then
		        ItemLLItem.FileIcon =  MediaPath +ItemLLItem.BuildType+".png"
		        F = GetFolderItem(ItemLLItem.FileIcon, FolderItem.PathTypeNative)
		        If Not F.Exists Then
		          'Disabled .ico because Linux doesn't always display them right, Re-enabled as you can build on Windows
		          ItemLLItem.FileIcon =  MediaPath +ItemLLItem.BuildType+".ico"
		          F = GetFolderItem(ItemLLItem.FileIcon, FolderItem.PathTypeNative)
		          If Not F.Exists Then 
		            
		            ItemLLItem.FileIcon =  "" 'None
		            ItemIcon = Nil
		          End If
		        End If
		      End If
		    End If
		  End If
		  NewFileIcon = ""
		  If Right(ItemLLItem.FileIcon,4) = ".ico" Then 'Don't allow png or svg Icons, they dont work with windows purposes and Linux doesn't need the Icon
		    NewFileIcon = ItemLLItem.FileIcon
		  End If
		  
		  'Add Item to Cache if found
		  If  ItemLLItem.FileIcon <>  "" Then
		    Try
		      ItemIcon = Picture.Open(F)
		    Catch
		    End Try
		  End If
		  
		  'Movie
		  ItemLLItem.FileMovie =  MediaPath+UniqueName+".mp4"
		  F = GetFolderItem(ItemLLItem.FileMovie, FolderItem.PathTypeNative)
		  If Not F.Exists Then
		    ItemLLItem.FileMovie =  MediaPath +ItemLLItem.BuildType+".mp4"
		    F = GetFolderItem(ItemLLItem.FileMovie, FolderItem.PathTypeNative)
		    If Not F.Exists Then
		      ItemLLItem.FileMovie =  "" 'None
		    End If
		  End If
		  ItemTempPath = MediaPath ' Media Path is inipath if not compressed and temp path if is compressed
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LogInstall(EntryType As String, Message As String)
		  ' Logs installer events to $HOME/zLastOSRepository/zzLLStore_Installs.log
		  ' EntryType should be "Success", "Skipped", or "FAIL"
		  ' FAIL entries automatically include a timestamp for cross-reference with the Debug log
		  #Pragma BreakOnExceptions Off
		  Try
		    ' Build log directory and file path from HomePath global
		    Dim LogDir As String = Slash(HomePath) + "zLastOSRepository"
		    MakeFolder(LogDir) ' Create directory if it doesn't exist (safe, no crash)
		    Dim LogPath As String = Slash(LogDir) + "zzLLStore_Installs.log"
		    
		    ' Validate and build the prefix
		    Dim Prefix As String
		    If EntryType = "Success" Then
		      Prefix = "Success: "
		    ElseIf EntryType = "Skipped" Then
		      Prefix = "Skipped: "
		    Else
		      Prefix = "FAIL: "
		    End If
		    
		    ' Build the log line - add timestamp to FAIL entries for debug log cross-reference
		    Dim LogLine As String
		    If EntryType = "FAIL" Then
		      Var d As DateTime = DateTime.Now
		      LogLine = Prefix + d.Hour.ToString("00") + ":" + d.Minute.ToString("00") + ":" + d.Second.ToString("00") + Chr(9) + Message + Chr(10)
		    Else
		      LogLine = Prefix + Message + Chr(10)
		    End If
		    
		    ' Append to file using BinaryStream (supports true append without overwriting)
		    Dim LogFI As FolderItem = GetFolderItem(LogPath, FolderItem.PathTypeNative)
		    Dim BS As BinaryStream
		    If LogFI.Exists Then
		      BS = BinaryStream.Open(LogFI, True) ' Open existing for writing
		      BS.Position = BS.Length ' Seek to end for append
		    Else
		      BS = BinaryStream.Create(LogFI, True) ' Create new log file
		    End If
		    If BS <> Nil Then
		      BS.Write(LogLine)
		      BS.Close
		    End If
		  Catch
		    ' Silently swallow all errors - never crash the app over logging
		  End Try
		  #Pragma BreakOnExceptions On
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeAllExec(PathIn As String)
		  If Debugging Then Debug("Make All Exec: "+ PathIn)
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = -1 'Give it All the time it needs
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  if TargetLinux Then 'Only Linux needs this, Win doesn't
		    Sh.Execute ("chmod -R 775 "+Chr(34)+PathIn+Chr(34) +" ; "+ "chmod 775 "+Chr(34)+PathIn+Chr(34)) 'Change Read/Write/Execute to defaults 'The 2nd time is for single file only, not a recursive folder
		    While Sh.IsRunning
		      App.DoEvents(20)  ' used to be 50, trying 7 to see if more responsive. - It is
		    Wend
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeFileType(APP As String, EXT As String, COMMENT As String, EXECU As String, PathIn As String, LOGO As String, Args As String = "", SystemWide As Boolean = False)
		  If Debugging Then Debug("--- Starting Make Associations ---")
		  Dim OrigAppName As String
		  Dim FileOut As String
		  Dim FileContent As String
		  Dim Typs() As  String
		  Dim J As Integer
		  Dim CurrentIconTheme As String
		  Dim Shelly As New Shell
		  Dim Res As String
		  Dim TypeName As String
		  
		  If TargetWindows Then
		    Typs = Split(EXT, " ")
		    If Typs.Count >= 1 Then
		      For J = 0 To Typs.Count - 1
		        EXECU = EXECU.ReplaceAll("/","\") 'I think Assoc requires windows paths and not linux slashes
		        TypeName = APP.ReplaceAll ("(", "") 'Remove Brackets
		        TypeName = TypeName.Trim.ReplaceAll (")", "") 'Remove Brackets
		        TypeName = TypeName.ReplaceAll (" ", ".") 'Remove Spaces
		        Res = RunCommandResults("assoc "+"." + Typs(J)+"="+Chr(34)+TypeName+Chr(34)+Chr(10)+"ftype "+TypeName+"="+Chr(34)+EXECU+Chr(34)+" "+Args+Chr(34)+"%%1 %%*" + Chr(34))
		        If Debugging Then Debug("Win Assoc: ." + Typs(J)+"="+Chr(34)+TypeName+Chr(34)+"|"+"ftype "+TypeName+"="+Chr(34)+EXECU+Chr(34)+" "+Args+Chr(34)+"%%1 %%*" + Chr(34)+ Chr(10)+ Res)
		      Next
		    End If
		    
		  Else 'Linux
		    OrigAppName = APP
		    APP = Replace(APP, " (Linux)", "") 'Remove Bracketed Linux, will only be once, so can use Replace
		    APP = APP.ReplaceAll ("(", "") 'Remove Brackets
		    APP = APP.Lowercase.Trim.ReplaceAll (")", "") 'Remove Brackets
		    APP = APP.ReplaceAll (" ", ".") 'Remove Spaces
		    
		    If Debugging Then Debug ("Making Linux Association for: " + APP)
		    
		    If Not Exist(TmpPath) Then Shelly.Execute ("mkdir -p " + Chr(34) + TmpPath + Chr(34))
		    
		    MakeFolder(Slash(HomePath)+".local/share/applications")
		    
		    'MIME Type
		    Shelly.Execute ("gsettings get org.gnome.desktop.interface icon-theme")
		    CurrentIconTheme = Shelly.Result
		    CurrentIconTheme = CurrentIconTheme.ReplaceAll ("'", "") 
		    'ShellFast.Execute ("cp "+Chr(34)+LOGO+Chr(34)+" "+BaseDir+"/icon.png") 
		    ShellFast.Execute ("bash -c 'xdg-icon-resource install --context mimetypes --size 256 --theme " + CurrentIconTheme + " " + Chr(34) +LOGO + Chr(34) + " application-x-" + APP + " > /dev/null 2>&1 &'") 'Backgrounded: rebuilds icon cache, does not need to block
		    ShellFast.Execute ("bash -c 'xdg-icon-resource install --context mimetypes --size 256 " + Chr(34) +LOGO + Chr(34) + " application-x-" + APP + " > /dev/null 2>&1 &'") 'Backgrounded: rebuilds icon cache, does not need to block
		    
		    If  SystemWide = True Then
		      'System wide doesn't need per theme, it's system wide
		      RunSudo ("xdg-icon-resource install --context mimetypes --size 256 " + Chr(34) +LOGO + Chr(34) + " application-x-" + APP)
		    End If
		    
		    'Shelly.Execute ("rm "+BaseDir+"/icon.png") 'I used this before I fixed the chr(34)
		    
		    FileOut = Slash(TmpPath) + APP + "-mime.xml"
		    FileContent = "<?xml version=" + Chr(34) + "1.0" + Chr(34) + " encoding=" + Chr(34) + "UTF-8" + Chr(34) + "?>" + Chr(10)
		    FileContent = FileContent + "<mime-info xmlns=" + Chr(34) + "http://www.freedesktop.org/standards/shared-mime-info" + Chr(34) + ">" + Chr(10)
		    FileContent = FileContent + "    <mime-type type=" + Chr(34) + "application/x-" + APP + Chr(34) + ">" + Chr(10)
		    FileContent = FileContent + "        <comment>" + COMMENT + "</comment>" + Chr(10)
		    FileContent = FileContent + "        <icon name=" + Chr(34) + "application-x-" + APP + Chr(34) + "/>" + Chr(10)
		    Typs = Split(EXT, " ")
		    If Typs.Count >= 1 Then
		      For J = 0 To Typs.Count - 1
		        FileContent = FileContent + "        <glob pattern=" + Chr(34) + "*." + Typs(J) + Chr(34) + "/>" + Chr(10)
		        If Debugging Then Debug ("Making Linux Association for: " + APP +" as "+"        <glob pattern=" + Chr(34) + "*." + Typs(J) + Chr(34) + "/>" )
		      Next
		    Else
		      FileContent = FileContent + "        <glob pattern=" + Chr(34) + "*.nonegiven" + Chr(34) + "/>" + Chr(10)
		    End If
		    'FileContent = FileContent + "        <glob pattern=" + Chr(34) + "*." + EXT + Chr(34) + "/>" + Chr(10)  
		    FileContent = FileContent + "    </mime-type>" + Chr(10)
		    FileContent = FileContent + "</mime-info>" + Chr(10)
		    SaveDataToFile(FileContent, FileOut)
		    Shelly.Execute ("xdg-mime install " + FileOut)
		    
		    ShellFast.Execute ("bash -c 'update-mime-database $HOME/.local/share/mime > /dev/null 2>&1 &'") 'Backgrounded: cache refresh only
		    
		    'I could add sudo above to install system wide then update mime database below with update-mime-database /usr/share/mime/ 'But not sure I want this yet
		    If  SystemWide = True Then
		      RunSudo ("xdg-mime install " + FileOut)
		      RunSudo ("update-mime-database /usr/share/mime/ &") 'Backgrounded: very slow, cache refresh only
		    End If
		    Shelly.Execute ("rm " + FileOut)
		    
		    'I can make each added type the default, but that seems extreme
		    'ShellFast.Execute ("xdg-mime default "+APP+"_filetype.desktop application/x-"+APP)
		    'RunSudo ("sudo xdg-mime default "+APP+"_filetype.desktop application/x-"+APP)
		    
		    
		    
		    If EXECU.Left(5) = "wine " Then
		      'I use the 2nd one below to make it more system compatible, but may change to installing the python requirements and script to make it perfect on every OS?
		      ''EXECU = "python3 "+Slash(ToolPath)+"wine-launcher.py " + Chr(34) + Right(EXECU, Len(EXECU) - 5) + Chr(34) + " %f" 'Works Perfect But requirtes external and Pythos on the OS, will test more
		      EXECU = "wine " + Chr(34) + Right(EXECU, Len(EXECU) - 5) + Chr(34) 'Works ok
		    Else 'Linux one
		      EXECU = EXECU + " %U"
		    End If
		    
		    PathIn = NoSlash(PathIn) 'Remove Slash
		    
		    'Desktop Association
		    FileOut = Slash(TmpPath) + APP + "_filetype.desktop"
		    FileContent = "[Desktop Entry]" + Chr(10)
		    FileContent = FileContent + "Name=" + OrigAppName + Chr(10)
		    FileContent = FileContent + "Exec=" + EXECU + Chr(10)
		    FileContent = FileContent + "Path=" + PathIn + Chr(10)
		    FileContent = FileContent + "MimeType=application/x-" + APP + Chr(10)
		    FileContent = FileContent + "Icon=application-x-" + APP + Chr(10)
		    FileContent = FileContent + "Terminal=false" + Chr(10)
		    FileContent = FileContent + "NoDisplay=true" + Chr(10)
		    FileContent = FileContent + "Type=Application" + Chr(10)
		    FileContent = FileContent + "Categories=" + Chr(10)
		    FileContent = FileContent + "Comment=" + COMMENT + Chr(10)
		    SaveDataToFile(FileContent, FileOut)
		    ShellFast.Execute ("chmod 775 "+Chr(34)+FileOut+Chr(34)) 'Change Read/Write/Execute to defaults
		    
		    'Msgbox (FileOut)
		    
		    'Can move this to end of Mini Installer and run once (for speed increase), just set a Task Flag
		    If  SystemWide = True Then
		      RunSudo ("desktop-file-install --dir=/usr/share/applications " + FileOut)
		      'MsgBox ("sudo desktop-file-install --dir=/usr/share/applications " + FileOut)
		      RunSudo ("update-desktop-database /usr/share/applications &") 'Backgrounded: cache refresh only
		      RunSudo ("xdg-mime default " + APP + ".desktop application/x-" + APP)
		      'RunSudo ("sudo update-icon-caches /usr/share/icons/*") 'This is WAY too slow to do all the time, disabled!!!!
		    End If
		    
		    Shelly.Execute ("desktop-file-install --dir=$HOME/.local/share/applications " + FileOut)
		    Shelly.Execute (" rm " + FileOut)
		    ShellFast.Execute ("bash -c 'update-desktop-database $HOME/.local/share/applications > /dev/null 2>&1 &'") 'Backgrounded: cache refresh only
		    Shelly.Execute ("xdg-mime default " + APP + ".desktop application/x-" + APP)
		    ShellFast.Execute ("bash -c 'update-icon-caches $HOME/.local/share/icons/* > /dev/null 2>&1 &'") 'Backgrounded: cache refresh only
		    
		    ShellFast.Execute ("chmod 775 "+Chr(34)+"$HOME/.local/share/applications/"+ APP + "_filetype.desktop"+Chr(34)) 'Change Read/Write/Execute to defaults
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeFolder(Txt as String)
		  Dim F As FolderItem
		  Dim Path As String
		  Dim Sh As New Shell
		  Dim Res As String
		  Sh.TimeOut = -1 'Give it All the time it needs
		  Dim S As string
		  Path = FixPath(Txt)
		  Try
		    if TargetMacOS then
		      s = "mkdir -p " + chr(34) + "/Volumes/" + replaceall(Txt,":","/") + chr(34)
		    elseif TargetWindows then
		      Path = Path.ReplaceAll("/","\")
		      S = "mkdir " + chr(34) + Path + chr(34)
		    elseif TargetLinux then
		      Path = Path.ReplaceAll("\","/")
		      S = "mkdir -p " + chr(34) + Path + chr(34)
		    end if
		    
		    If TargetWindows Then 'Only windows has the stupid shell bug, so only it needs an external script called instead
		      Res = RunCommandResults (S + Chr(10) + "icacls "+Chr(34)+ NoSlash(Path)+Chr(34)+ " /grant "+ "Users:F /t /c /q") 'Using Chr(10) instead of ; as scripts don't allow them, only the prompt does
		      If Debugging Then Debug ("- Make Folder: "+Path+" = " + Res)
		    Else
		      Sh.Execute(S)
		      If Debugging Then Debug ("- Make Folder: "+Path+" = " + Sh.ReadAll)
		      Sh.Execute("chmod 775 "+Chr(34)+Path+Chr(34)) 'Change Read/Write/Execute to defaults, -R would do all files and folders, but we might not want this here
		    End If
		  Catch
		    If Debugging Then Debug ("~ Failed to Make Folder: " + Path)
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeFolderIcon(FolderIn As String, IconPathFile As String)
		  Dim Data As String
		  Dim DesktopINI As String
		  
		  Dim IconFile As String
		  
		  FolderIn = NoSlash(FolderIn)
		  FolderIn = FolderIn.ReplaceAll("/","\")
		  
		  DesktopINI = Slash(FolderIn)+"desktop.ini"
		  DesktopINI = DesktopINI.ReplaceAll("/","\")
		  
		  IconPathFile = IconPathFile.ReplaceAll("/","\")
		  
		  IconFile = Right(IconPathFile, Len(IconPathFile)-InStrRev(IconPathFile,"\"))
		  
		  If Not Exist(IconPathFile) Then
		    IconPathFile = IconPathFile.Replace(IconFile, "folder.ico")
		    IconFile = "folder.ico"
		  End If
		  
		  'As this isn't important to the functioning, I'll capture any errors and ignore doing it.
		  #Pragma BreakOnExceptions Off
		  Try
		    If Exist(FolderIn) Then
		      Data = "[.ShellClassInfo]"+ Chr(13)
		      Data = Data + "ConfirmFileOp=0"+ Chr(13)
		      Data = Data + "IconFile=.\"+IconFile+ Chr(13)
		      Data = Data + "IconIndex=0"+ Chr(13)
		      SaveDataToFile(Data, DesktopINI)
		      ShellFast.Execute("attrib "+Chr(34)+DesktopINI+Chr(34)+" +h +s") 'Ini is hidden and system
		      ShellFast.Execute("attrib "+Chr(34)+FolderIn+Chr(34)+" +s") 'Folder is system, else no icons shown, can't give it a trailing slash or it fails
		    End If
		  Catch
		  End Try
		  
		  #Pragma BreakOnExceptions On
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeLinks(QueueAttribs As Boolean = False)
		  If Debugging Then Debug("--- Starting Make Links ---")
		  
		  If QueueDeltreeMajor = False Then 'If configured to delete all of them, don't clear the existing list
		    QueueDeltree = True
		    QueueDeltreeJobs = ""
		    DelJobsList.RemoveAll
		  End If
		  
		  
		  Dim SkipCleanup As Boolean = False
		  
		  If ItemLLItem.StartMenuSourcePath = "" And ItemLLItem.KeepInFolder = True Then ' If Broken file then don't go deleting random stuff
		    SkipCleanup = True ' If Broken file then don't go deleting random stuff
		    If Debugging Then Debug ("* Error: No StartMenuSourcePath set and KeepInFolder given")
		  End If
		  
		  Dim I, J, K, L, M, N, O As Integer
		  Dim Target As String
		  Dim DesktopFile, DesktopContent, DesktopOutPath As String
		  Dim ParentPath As String
		  Dim Catalog() As String
		  Dim CatalogCount As Integer
		  Dim TestLen As Integer
		  Dim LinkOutPath, LinkOutPathSet As String
		  Dim DaBugs As String
		  Dim DeTest As String
		  Dim StartPath As String
		  Dim StartPathAlt As String = ""
		  Dim ExecName As String
		  Dim BT As String
		  Dim GameCatFound As Boolean
		  Dim GameCat As String
		  
		  Dim FoundNewCat As Boolean
		  
		  Dim FixedCat As String
		  
		  Dim Sh As New Shell
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim StartDestTemp As String
		  
		  Dim SendTo As Boolean
		  Dim Startup As Boolean
		  Dim Root As Boolean
		  
		  
		  BT = ItemLLItem.BuildType
		  
		  If TargetWindows Then 'Do Flagged here
		    If ItemLLItem.Flags.IndexOf("sendto") >=0 Then SendTo = True'Do SendTo (Not done yet)
		    If ItemLLItem.Flags.IndexOf("root") >=0 Then Root = True
		    If ItemLLItem.Flags.IndexOf("programs") >=0 Then Root = True
		    If ItemLLItem.Flags.IndexOf("startup") >=0 Then Startup = True
		    
		    'Clean up Done in MoveLinks
		  End If
		  
		  '***********************************************************************************************************************************************************
		  'This line below stops the redirected Categories from happening, so the new sort method below should work???
		  If TargetWindows Then RedirectAppCount = 0 '**************************************************************************************************************************************
		  '***********************************************************************************************************************************************************
		  
		  If ItemLLItem.Catalog <> "" Then
		    Catalog = ItemLLItem.Catalog.Split("|")
		    CatalogCount = Catalog.Count - 1
		    If Not TargetWindows Then 'MainItem, Only Redirect Linux, Windows uses the Menu Databases to redirect the menu style
		      For I = 0 To CatalogCount
		        Catalog(I) = Catalog(I).Trim
		        IF RedirectAppCount >= 1 Then
		          'I've disabled exiting the loops incase duplicates are found and I do apps and games incase something is in wrong category
		          'Select Case ItemLLItem.BuildType 
		          'Case "ssApp","ppApp"
		          For J = 0 To RedirectAppCount -1
		            If Catalog(I)  = RedirectsApp (J,0) Then
		              ItemLLItem.Catalog = ItemLLItem.Catalog.ReplaceAll(RedirectsApp (J,0),RedirectsApp (J,1))'Replace with new App Catalog
		              'Exit 'Found item to replace, get out of here
		            End If
		          Next J
		          'Case Else 'Game
		          For J = 0 To RedirectGameCount -1
		            If Catalog(I)  = RedirectsGame (J,0) Then
		              ItemLLItem.Catalog = ItemLLItem.Catalog.ReplaceAll(RedirectsGame (J,0),RedirectsGame (J,1))'Replace with new Game Catalog
		              'Exit 'Found item to replace, get out of here
		            End If
		          Next J
		          'End Select
		        End If
		      Next I
		    End If
		  End If
		  'End If
		  
		  'Do Link Catalog
		  If LnkCount > 0 Then
		    If Not TargetWindows Then 'LnkItems, Only Redirect Linux, Windows uses the Menu Databases to redirect the menu style
		      For L = 1 To LnkCount
		        If  ItemLnk(L).Categories <> "" Then
		          Catalog = ItemLnk(L).Categories.Split(";")
		          CatalogCount = Catalog.Count - 1
		          IF RedirectGameCount >= 1 Then
		            For I = 0 To CatalogCount
		              Catalog(I) = Catalog(I).Trim
		              'Select Case ItemLLItem.BuildType
		              'Case "ssApp","ppApp"
		              For J = 0 To RedirectAppCount -1
		                If Catalog(I)  = RedirectsApp (J,0) Then
		                  ItemLnk(L).Categories = ItemLnk(L).Categories.ReplaceAll(RedirectsApp (J,0),RedirectsApp (J,1)) 'Replace with new App Catalog
		                  'Exit 'Found item to replace, get out of here
		                End If
		              Next J
		              'Case Else 'Game
		              For J = 0 To RedirectGameCount -1
		                If Catalog(I) = RedirectsGame (J,0) Then
		                  ItemLnk(L).Categories = ItemLnk(L).Categories.ReplaceAll(RedirectsGame (J,0),RedirectsGame (J,1)) 'Replace with new Game Catalog
		                  Exit 'Found item to replace, get out of here
		                End If
		              Next J
		              'End Select
		            Next I
		            'Replace Game to start of Catalog
		            If Len( ItemLnk(L).Categories) > Len( ItemLnk(L).Categories.ReplaceAll("; Game;",";")) Then ' Drop the Game back to start
		              ItemLnk(L).Categories = "Game; " + ItemLnk(L).Categories.ReplaceAll("; Game;",";")
		            End If
		          End If
		        End If
		      Next L
		    End If
		  End If
		  
		  
		  'For All
		  If LnkCount > 0 Then
		    If TargetLinux Then 'For Linux Only
		      For I = 1 To LnkCount
		        'Check if on Compatible OS before making the link to it:
		        ItemLnk(I).LnkOSCompatible = "T" 'Default it to enabled
		        
		        'Do Arch first as that will always be needed
		        DeTest = ItemLnk(I).LnkArchCompatible
		        If DeTest <> "" Then 'Only do Items with Values set
		          If  DeTest.IndexOf(SysArchitecture) >=0 Or DeTest = "All" Then
		            ItemLnk(I).LnkOSCompatible = "T"
		          Else 'Not Compatible
		            ItemLnk(I).LnkOSCompatible = "F"
		          End If
		        End If
		        
		        If ItemLnk(I).LnkOSCompatible = "T" Then 'Will only continue if Arch Passed and wont check it if empty
		          DeTest = ItemLnk(I).LnkDECompatible
		          If DeTest <> "" Then 'Only do Items with Values set
		            If DeTest = "All-Linux" And TargetLinux Then DeTest = "All" 'If it's Linux compatible and we are in Linux then just set it to All in Temp Variable
		            If  DeTest.IndexOf(SysDesktopEnvironment) >=0 Or DeTest = "All" Then
		              ItemLnk(I).LnkOSCompatible = "T"
		            Else 'Not Compatible
		              ItemLnk(I).LnkOSCompatible = "F"
		            End If
		          End If
		        End If
		        
		        If ItemLnk(I).LnkOSCompatible = "T" Then 'Will only continue if Arch Passed, DE Passed or abscent and wont check it if empty
		          DeTest =ItemLnk(I).LnkPMCompatible
		          If DeTest <> "" Then 'Only do Items with Values set
		            If  DeTest.IndexOf(SysPackageManager) >=0 Or DeTest = "All" Then
		              'If DeTest = "All-Linux" And TargetLinux Then DeTest = "All" 'If it's Linux compatible and we are in Linux then just set it to All in Temp Variable 'Not used yet (may not need)
		              ItemLnk(I).LnkOSCompatible = "T"
		            Else 'Not Compatible
		              ItemLnk(I).LnkOSCompatible = "F"
		            End If
		          End If
		        End If
		        'Below will only execute if set to F - it;s blank by default for unset items.
		        If Debugging Then Debug ("Make Linux Link: "+ItemLnk(I).Title)
		        If Debugging And ItemLnk(I).LnkArchCompatible <> "" Then Debug ("LnkArchCompatible: "+ItemLnk(I).LnkArchCompatible)
		        If Debugging And ItemLnk(I).LnkDECompatible <> "" Then Debug ("LnkDECompatible: "+ItemLnk(I).LnkDECompatible)
		        If Debugging And ItemLnk(I).LnkPMCompatible <> "" Then Debug ("LnkPMCompatible: "+ItemLnk(I).LnkPMCompatible)
		        If Debugging Then Debug ("LnkOSCompatible: "+ItemLnk(I).LnkOSCompatible)
		        
		        If ItemLnk(I).LnkOSCompatible = "F" Then Continue 'Doesn't process Non Compatible links, Need to add Arch Check also Glenn
		        
		        'For SS types: skip Windows .lnk links when a matching Linux .desktop link exists with the same Title
		        If Not ItemLnk(I).LinuxLink And (ItemLLItem.BuildType = "ppGame" Or ItemLLItem.BuildType = "ppApp" Or ItemLLItem.BuildType = "ssApp") Then
		          Dim HasMatchingDesktop As Boolean = False
		          Dim DM As Integer
		          For DM = 1 To LnkCount
		            If ItemLnk(DM).LinuxLink And ItemLnk(DM).Title.Trim = ItemLnk(I).Title.Trim Then
		              HasMatchingDesktop = True
		              Exit
		            End If
		          Next DM
		          If HasMatchingDesktop Then Continue 'Skip this .lnk; the Linux .desktop link handles it
		        End If
		        
		        'If ItemLnk(I).Title.IndexOf(1, "{#2}") >= 1 Then Continue 'Skip dual arch shortcuts, just keep 1st one, which is usually x64 anyway
		        If ItemLnk(I).Flags.IndexOf(0, "Is_x64") < 0 And ItemLnk(I).Title.IndexOf(1, "{#1}") >= 1 Then Continue ' Only skip replacing items if the items isn't the x64 one
		        If ItemLnk(I).Flags.IndexOf(0, "Is_x64") < 0 And ItemLnk(I).Title.IndexOf(1, "{#2}") >= 1 Then Continue ' Only skip replacing items if the 2nd items isn't the x64 one
		        
		        ItemLnk(I).Title = ItemLnk(I).Title.ReplaceAll("{#2}", "") 'Remove Dual Arch leftovers
		        ItemLnk(I).Title = ItemLnk(I).Title.ReplaceAll("{#1}", "") 'Remove Dual Arch leftovers
		        ItemLnk(I).Title = ItemLnk(I).Title.Trim ' Need to trim away the space so can use it for the Link Name
		        DesktopFile = ItemLnk(I).Title.ReplaceAll(" ", ".") + ".desktop" 'Remove Spaces and add .desktop back to file name
		        
		        'For Linux .desktop links inside SS files: remap %ppGames%/%ppApps% to %LLGames%/%LLApps%
		        'Also remap %AppPath% directly to InstallToPath (already fully resolved for both install and regen)
		        If ItemLnk(I).LinuxLink And (ItemLLItem.BuildType = "ppGame" Or ItemLLItem.BuildType = "ppApp" Or ItemLLItem.BuildType = "ssApp") Then
		          Dim LinuxInstallBase As String = NoSlash(InstallToPath)
		          ItemLnk(I).Link.TargetPath = ItemLnk(I).Link.TargetPath.ReplaceAll("%AppPath%", LinuxInstallBase).ReplaceAll("%ppGames%", "%LLGames%").ReplaceAll("%ppApps%", "%LLApps%")
		          ItemLnk(I).Link.WorkingDirectory = ItemLnk(I).Link.WorkingDirectory.ReplaceAll("%AppPath%", LinuxInstallBase).ReplaceAll("%ppGames%", "%LLGames%").ReplaceAll("%ppApps%", "%LLApps%")
		          ItemLnk(I).Link.IconLocation = ItemLnk(I).Link.IconLocation.ReplaceAll("%AppPath%", LinuxInstallBase).ReplaceAll("%ppGames%", "%LLGames%").ReplaceAll("%ppApps%", "%LLApps%")
		        End If
		        
		        ItemLnk(I).Link.IconLocation = ExpPath(ItemLnk(I).Link.IconLocation)
		        'If TargetLinux Then 'Only Linux .desktop files need the png, Windows MakeLinks works fine with no Icon File given :) - It's already checked for Linux, the Windows Section has it's own
		        If Not Exist(ItemLnk(I).Link.IconLocation) Then ItemLnk(I).Link.IconLocation = "" 'Remove Dodgy Icon and use something
		        If ItemLnk(I).Link.IconLocation = "" Then
		          If Exist(InstallToPath + "ppGame.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "ppGame.png"
		          If Exist(InstallToPath + "ppApp.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "ppApp.png"
		          If Exist(InstallToPath + "ssApp.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "ssApp.png"
		          If Exist(InstallToPath + "LLGame.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "LLGame.png"
		          If Exist(InstallToPath + "LLApp.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "LLApp.png"
		        End If
		        'End If
		        
		        'If in Linux check if run-1080p is available and if not remove it from the Exe being called.
		        If TargetLinux Then
		          ShellFast.Execute("type -P run-1080p")
		          If  ShellFast.Result = "" Then
		            ItemLnk(I).Link.TargetPath= ItemLnk(I).Link.TargetPath.Replace("run-1080p ","")
		          End If
		        End If
		        
		        
		        'Fix missing path if exec doesn't contain the path (for linux)
		        If Exist (Slash(ExpPath(ItemLnk(I).Link.WorkingDirectory))+ItemLnk(I).Link.TargetPath) Then
		          ItemLnk(I).Link.TargetPath = Slash(ExpPath(ItemLnk(I).Link.WorkingDirectory))+ItemLnk(I).Link.TargetPath ' <- Prefer to use the app path in .desktop files as it will fail without setting the path if the item isn't in the system wide Paths
		        End If
		        
		        'Process Exec path/name
		        ExecName = ExpPath(ItemLnk(I).Link.TargetPath) 'I added ExpPath back to this as it wasn't expanding the %LLGames% Variable etc
		        
		        'Correct Exec if missing Quotes (May need to test/disable if breaks things)
		        If Left(ExecName,1) <> Chr(34) And Right(ExecName,1) <> Chr(34) Then ExecName = Chr(34)+ExecName+Chr(34) 'Only quote them if none used at all
		        
		        If Debugging Then Debug("SHORTCUT EXEC: " + ExecName)
		        
		        DesktopContent = "[Desktop Entry]" + Chr(10)
		        DesktopContent = DesktopContent + "Type=Application" + Chr(10)
		        DesktopContent = DesktopContent + "Version=1.0" + Chr(10)
		        DesktopContent = DesktopContent + "Name=" + ItemLnk(I).Title + Chr(10)
		        'ExecName = ExpPath(ItemLnk(I).Link.TargetPath)
		        If ItemLLItem.BuildType = "LLApp" Or ItemLLItem.BuildType = "LLGame" Or ItemLnk(I).LinuxLink Then
		          DesktopContent = DesktopContent + "Exec=" + ExecName + Chr(10) 'LinuxLink .desktop items are native executables, no Wine prefix
		        Else
		          DesktopContent = DesktopContent + "Exec=" + "wine " + ExecName + Chr(10) 'Quotes are checked for above, so only added once
		        End If
		        
		        If ItemLLItem.BuildType = "ssApp" Then
		          If InstallToPath <> "" Then 'Only use it if good
		            ItemLnk(I).Link.WorkingDirectory = Slash(InstallToPath) 'This path would be better for 99% of ssApps, there may be some dodgy one that require the sub paths still though
		          Else
		            ItemLnk(I).Link.WorkingDirectory = ExpPath(ItemLnk(I).Link.WorkingDirectory)
		            If ItemLnk(I).Link.WorkingDirectory = "" Then
		              ItemLnk(I).Link.WorkingDirectory = ExpPath(ItemLLItem.PathApp) 'If not one set, use Apps install to path of Main Item (ppGames and apps don't usualy have a path set at all)
		            End If
		          End If
		        Else
		          ItemLnk(I).Link.WorkingDirectory = ExpPath(ItemLnk(I).Link.WorkingDirectory)
		          If ItemLnk(I).Link.WorkingDirectory = "" Then
		            ItemLnk(I).Link.WorkingDirectory = ExpPath(ItemLLItem.PathApp) 'If not one set, use Apps install to path of Main Item (ppGames and apps don't usualy have a path set at all)
		          End If
		        End If
		        
		        ItemLnk(I).Categories = ItemLnk(I).Categories.ReplaceAll("ppGame","Game") 'Fix invalid category to make sort correctly.
		        
		        DesktopContent = DesktopContent + "Path=" + ExpPath(ItemLnk(I).Link.WorkingDirectory) + Chr(10)
		        DesktopContent = DesktopContent + "Comment=" + ItemLnk(I).Link.Description + Chr(10)
		        DesktopContent = DesktopContent + "Icon=" + ItemLnk(I).Link.IconLocation + Chr(10)
		        DesktopContent = DesktopContent + "Categories=" + ItemLnk(I).Categories + Chr(10)
		        DesktopContent = DesktopContent + "Terminal=" + Str(ItemLnk(I).Terminal) + Chr(10)
		        
		        'Linux Associations
		        If ItemLnk(I).Associations.Trim <> "" Then
		          'System Wide (LLApps only)
		          If BT = "LLApp" Then
		            If ItemLnk(I).Link.WorkingDirectory.IndexOf(HomePath) = -1 Then 'If item isn't inside the users path then it is system wide
		              MakeFileType(ItemLnk(I).Title, ItemLnk(I).Associations, ItemLnk(I).Link.Description, ExecName, ExpPath(ItemLnk(I).Link.WorkingDirectory), ItemLnk(I).Link.IconLocation, "", True) '"" is Args and True makes it copy to System Wide Mime Types
		            Else
		              MakeFileType(ItemLnk(I).Title, ItemLnk(I).Associations, ItemLnk(I).Link.Description, ExecName, ExpPath(ItemLnk(I).Link.WorkingDirectory), ItemLnk(I).Link.IconLocation)
		            End If
		          End If
		        End If
		        
		        DesktopOutPath = Slash(HomePath)+".local/share/applications/"
		        MakeFolder(DesktopOutPath)
		        SaveDataToFile(DesktopContent, DesktopOutPath+DesktopFile)
		        ShellFast.Execute ("chmod 775 "+Chr(34)+DesktopOutPath+DesktopFile+Chr(34)) 'Change Read/Write/Execute to defaults
		        
		        'System Wide (LLApps only)
		        If BT = "LLApp" Then
		          If ItemLnk(I).Link.WorkingDirectory.IndexOf(HomePath) = -1 Then 'If item isn't inside the users path then it is system wide
		            RunSudo("mv -f "+Chr(34)+DesktopOutPath+DesktopFile+Chr(34)+" /usr/share/applications/")
		          End If
		        End If
		        
		        'Desktop Link
		        If ItemLnk(I).Desktop = True Then
		          SaveDataToFile(DesktopContent, Slash(HomePath)+"Desktop/"+DesktopFile) 'Also save to Desktop
		          ShellFast.Execute ("chmod 775 "+Chr(34)+Slash(HomePath)+"Desktop/"+DesktopFile+Chr(34)) 'Change Read/Write/Execute to defaults
		        End If
		        
		        'Panel Link
		        If ItemLnk(I).Panel = True Then
		          If Exist(Slash(HomePath)+".config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json") Then 'If it's not there, don't bother
		            ShellFast.Execute("type -P jq")
		            If ShellFast.Result <> "" Then 'Can only add to the panel if jq is installed to work with .json files
		              ShellFast.Execute("jq --arg order "+Chr(34)+DesktopFile+Chr(34)+" '."+Chr(34)+"pinned-apps"+Chr(34)+".value |= if index($order) then . else . + [$order] end' "+Slash(HomePath)+".config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json | tee "+Slash(HomePath)+".config/cinnamon/spices/grouped-window-list@cinnamon.org/2.new >/dev/null && mv "+Slash(HomePath)+".config/cinnamon/spices/grouped-window-list@cinnamon.org/2.new "+Slash(HomePath)+".config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json")
		              RunRefreshScript = True
		            End If
		          End If
		        End If
		        
		        'Favorites Menu
		        If ItemLnk(I).Favorite = True Then
		          ShellFast.Execute("gsettings set org.cinnamon favorite-apps "+Chr(34)+"$(gsettings get org.cinnamon favorite-apps | sed s/.$//), '"+DesktopFile+"']"+Chr(34))
		        End If
		      Next I
		    End If
		    
		    '------------------------------------------------------------------- Windows Links ------------------------------------------------------------------
		    Dim OrigStartSourceMenu As String
		    OrigStartSourceMenu = ItemLLItem.StartMenuSourcePath
		    
		    If TargetWindows Then 'Windows Only Shortcut Making section
		      
		      If AdminEnabled Then 'If Admin apply to All users, else only has access to current user
		        StartPath = StartPathAll 'All Users
		        StartPathAlt = StartPathUser ' Used to delete User Link if making System Wide Link
		      Else
		        StartPath = StartPathUser 'Current User
		      End If
		      
		      If Debugging Then Debug ("Start Output Path: " + StartPath)
		      If Debugging Then Debug ("Link Count: " + LnkCount.ToString)
		      
		      Dim FirstLinkDone As Boolean = False
		      
		      For I = 1 To LnkCount
		        
		        'If Debugging Then Debug("* HERE HERE HERE HERE")
		        'If Debugging Then Debug("Target: "+ ItemLnk(I).Link.TargetPath)
		        'If Debugging Then Debug("IconLocation: "+ ItemLnk(I).Link.IconLocation)
		        
		        'Skip Linux .desktop links on Windows - they cannot be used here
		        If ItemLnk(I).LinuxLink Then Continue
		        
		        If ItemLnk(I).StartSourceMenu <> "" Then ItemLLItem.StartMenuSourcePath = ItemLnk(I).StartSourceMenu ' This is currently only used by Default Links sorting
		        
		        
		        If ItemLnk(I).Flags.IndexOf(0, "Is_x64") < 0 And ItemLnk(I).Title.IndexOf(1, "{#1}") >= 1 Then Continue ' Only skip replacing items if the items isn't the x64 one
		        If ItemLnk(I).Flags.IndexOf(0, "Is_x64") < 0 And ItemLnk(I).Title.IndexOf(1, "{#2}") >= 1 Then Continue ' Only skip replacing items if the 2nd items isn't the x64 one
		        
		        ItemLnk(I).Title = ItemLnk(I).Title.ReplaceAll("{#2}", "") 'Remove Dual Arch leftovers
		        ItemLnk(I).Title = ItemLnk(I).Title.ReplaceAll("{#1}", "") 'Remove Dual Arch leftovers
		        ItemLnk(I).Title = ItemLnk(I).Title.Trim ' Need to trim away the space so can use it for the Link Name
		        
		        'Make sure it's part of Shortcut Names Keep if that is used, else just skip making that Link
		        
		        If ItemLLItem.ShortCutNamesKeep <> "" Then
		          If ItemLLItem.ShortCutNamesKeep.IndexOf(ItemLnk(I).Title) >=0 Then
		          Else
		            If ItemLLItem.Flags.IndexOf("keepall") < 0 Then 'If KeepAll is set then keep every single shortcut, the ShortcutsToKeep is more for removing them off the desktop :)
		              Continue 'If Keep Shortcuts is used and the title of the current shortcut isn't in the list, skip over it.
		            End If
		          End If
		        End If
		        
		        
		        ItemLnk(I).Link.IconLocation = ExpPath(ItemLnk(I).Link.IconLocation)
		        'Windows does NOT use .png's for icons at ALL, a blank one is prefered
		        ''''''If Not Exist(ItemLnk(I).Link.IconLocation) Then ItemLnk(I).Link.IconLocation = "" 'Remove Dodgy Icon and use something ' NO, Uses the default icon from the .exe pointed at if nothing supplied, all good
		        '''''If ItemLnk(I).Link.IconLocation = "" Then
		        '''''If Exist(InstallToPath + "ppGame.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "ppGame.png"
		        '''''If Exist(InstallToPath + "ppApp.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "ppApp.png"
		        '''''If Exist(InstallToPath + "ssApp.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "ssApp.png"
		        '''''If Exist(InstallToPath + "LLGame.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "LLGame.png"
		        '''''If Exist(InstallToPath + "LLApp.png") Then ItemLnk(I).Link.IconLocation = InstallToPath + "LLApp.png"
		        '''''End If
		        
		        ItemLnk(I).Link.WorkingDirectory = ExpPath(ItemLnk(I).Link.WorkingDirectory)
		        If ItemLnk(I).Link.WorkingDirectory = "" Then
		          ItemLnk(I).Link.WorkingDirectory = ExpPath(ItemLLItem.PathApp) 'If not one set, use Apps install to path of Main Item (ppGames and apps don't usualy have a path set at all)
		        End If
		        
		        Target = ExpPath(ItemLnk(I).Link.TargetPath)
		        
		        If Not Exist(Target) Then Target = ExpPath(Slash(ItemLnk(I).Link.WorkingDirectory) + ItemLnk(I).Link.TargetPath) 'Target needs to be full path, so if above isn't found it will use the RunPath, BUT if it has Arguments it may fail and still point to the wrong place.
		        
		        'If Still doesn't exist, just drop back to default input and try our luck
		        If Not Exist(Target) Then Target = ExpPath(ItemLnk(I).Link.TargetPath)
		        
		        'Do Link Catalog
		        StartDestTemp = ItemLnk(I).Categories
		        
		        If ItemLLItem.BuildType = "ppGame" Then 'Remove Game from Catalog if a ppGame and more than one catalog set
		          StartDestTemp = StartDestTemp.ReplaceAll("ppGame", "Game") ' Fix this here
		          If StartDestTemp.ReplaceAll("Game;", "").Trim = "" Then
		          Else
		            StartDestTemp = StartDestTemp.ReplaceAll("Game;", "").Trim 'If more Catalogs set
		          End If
		        End If
		        
		        If StartDestTemp = "" Then StartDestTemp = "Other"
		        
		        If Debugging Then Debug ("Item Link Categories: " + StartDestTemp)
		        
		        If  StartDestTemp <> "" Then
		          Catalog = StartDestTemp.Split(";")
		          CatalogCount = Catalog.Count - 1
		          
		          If Catalog(0) = "" Then 'Error Protection on Dud-ish items
		            Catalog(0) = "Other" 'No Catalog set, just put it in Other
		          End If
		          
		          
		          If Debugging Then Debug ("Catalog Count: " + Str(Catalog.Count))
		          If Debugging Then Debug ("Menu Windows Count: " + MenuWindowsCount.ToString)
		          
		          
		          For J = 0 To CatalogCount
		            'If Debugging Then Debug ("Checking Catalog: "+Catalog(J))
		            ' --- FIX: Use a local variable so we don't overwrite the array element ---
		            Dim CurrentCat As String = Catalog(J).Trim
		            GameCat = "Game " + CurrentCat 'This is how games get detected
		            If CurrentCat = "ppGame" Then CurrentCat = "Game" 'Some of my older items have ppGame instead of Game, this fixes that
		            
		            If CurrentCat <> "" Then ' Only do Valid Link Catalogs
		              
		              'Trying to use proper Catalog converted in Windows
		              If StartMenuUsed >=0 Then '*************************************************** StartMenu Used ************************************
		                FoundNewCat = False
		                For K = 0 To StartMenuLocationsCount(StartMenuUsed) ' Quickly rush through and make sure the category we are testing exist (only needs one), else set it to Other below
		                  FixedCat = ""
		                  If ItemLLItem.BuildType = "ppGame" Then
		                    FixedCat = ReFixGameCats(CurrentCat)
		                  End If
		                  If Debugging Then
		                    Debug ("Test New Catalog: "+ CurrentCat+ "=>"+ StartMenuLocations(K, StartMenuUsed).Catalog +"<="+FixedCat)
		                  End If
		                  If CurrentCat = StartMenuLocations(K, StartMenuUsed).Catalog Or GameCat = StartMenuLocations(K, StartMenuUsed).Catalog Or FixedCat = StartMenuLocations(K, StartMenuUsed).Catalog Then 'Or GameCatFound = True <-No longer needed
		                    If Debugging Then Debug ("Found New Catalog: "+ CurrentCat+ "=>"+ StartMenuLocations(K, StartMenuUsed).Path +"<="+FixedCat)
		                    FoundNewCat = True
		                    ' --- FIX: Don't modify the Catalog array, just use the local CurrentCat ---
		                    If FixedCat<>"" Then CurrentCat = FixedCat 'If the GameFixed Category is found, use it, else leave it as is
		                    Exit
		                  End If
		                Next
		                If FoundNewCat = False Then 'Put in Other Category
		                  If ItemLLItem.BuildType = "ppGame" Then 'The lines below fixed the Game Categories
		                    CurrentCat = "Game Other"
		                  Else ' App
		                    CurrentCat = "Other"
		                  End If
		                End If
		                
		                For K = 0 To StartMenuLocationsCount(StartMenuUsed)
		                  If ItemLLItem.BuildType = "ppGame" Then 'The lines below fixed the Game Categories
		                    If GameCat = StartMenuLocations(K, StartMenuUsed).Catalog Then CurrentCat = GameCat 'This will ensure the correct Category is used for ppGames
		                  End If
		                  
		                  If CurrentCat = StartMenuLocations(K, StartMenuUsed).Catalog Then 'Or GameCatFound = True <-No longer needed
		                    If Debugging Then Debug ("Found New Catalog: "+ CurrentCat+ "=>"+ StartMenuLocations(K, StartMenuUsed).Path)
		                    'If Debugging Then Debug ("Not First Item ~~~ Checkpoint")
		                    
		                    LinkOutPath = StartPath+StartMenuLocations(K, StartMenuUsed).Path 'StartPath is where Writable
		                    If ItemLLItem.Flags.IndexOf("keepinfolder") >=0 Then LinkOutPath=Slash(LinkOutPath)+ItemLLItem.StartMenuSourcePath 'Put in Subfolder if Chosen
		                    MakeFolder(LinkOutPath)
		                    MakeFolderAttribBatch = MakeFolderAttribBatch + CommandReturned 'Global Command to run Attribs all at once
		                    
		                    'Apply Start Menu Icon File if set;
		                    MakePathIcon(StartPath+StartMenuLocations(K, StartMenuUsed).Path,StartMenuLocations(K, StartMenuUsed).IconFile, StartMenuLocations(K, StartMenuUsed).IconIndex, QueueAttribs)
		                    MakeFolderAttribBatch = MakeFolderAttribBatch + CommandReturned 'Global Command to run Attribs all at once
		                    'Apply Parent folder icon if required
		                    If InStrRev(StartMenuLocations(K, StartMenuUsed).Path,"\") >= 1 Then
		                      ParentPath = Left(StartMenuLocations(K, StartMenuUsed).Path, InStrRev(StartMenuLocations(K, StartMenuUsed).Path,"\")-1)
		                      If Debugging Then Debug ("Start Parent Path: "+ ParentPath)
		                      For M = 0 To StartMenuLocationsCount(StartMenuUsed)
		                        If StartMenuLocations(M, StartMenuUsed).Path = ParentPath Then
		                          MakePathIcon(StartPath+StartMenuLocations(M, StartMenuUsed).Path,StartMenuLocations(M, StartMenuUsed).IconFile, StartMenuLocations(M, StartMenuUsed).IconIndex, QueueAttribs)
		                          MakeFolderAttribBatch = MakeFolderAttribBatch + CommandReturned 'Global Command to run Attribs all at once
		                          Exit 'Jump out of this M loop it's done
		                        End If
		                      Next
		                    End If
		                    
		                    LinkOutPathSet = LinkOutPath
		                    ' Cleanup Other Sort menu Styles
		                    If Not SkipCleanup Then MakeLinksCleanOtherStyles(CurrentCat, StartPath, LinkOutPath, I, StartPathAlt)
		                    
		                    'Now Make Shortcut
		                    CreateShortcut(ItemLnk(I).Title, Target, Slash(FixPath(ItemLnk(I).Link.WorkingDirectory)), Slash(FixPath(LinkOutPathSet)),ItemLnk(I).Link.Arguments,ItemLnk(I).Link.IconLocation, ItemLnk(I).Link.Hotkey, ItemLnk(I).Link.Description)
		                    
		                    If StartPathAlt <> "" Then
		                      If Exist(Slash(FixPath(LinkOutPathSet)).ReplaceAll(StartPath, StartPathAlt)+ItemLnk(I).Title+".lnk") Then Deltree(Slash(FixPath(LinkOutPathSet)).ReplaceAll(StartPath, StartPathAlt)+ItemLnk(I).Title+".lnk") 'This should remove the User Link
		                    End If
		                    Exit For ' --- FIX: Changed Continue to Exit For so it moves to next Catalog(J) ---
		                  End If
		                  
		                Next K
		              Else '*************************************************** No StartMenu Style used ************************************************
		                If Debugging Then Debug ("No Menu Sorting Set ~~~ Doing Unsorted")
		                If ItemLLItem.BuildType = "ppGame" Then 'Games are still sorted
		                  LinkOutPath = StartPath + "Games" ' StartPath is where Writable
		                Else
		                  If ItemLLItem.StartMenuSourcePath <> "" Then
		                    LinkOutPath = StartPath + ItemLLItem.StartMenuSourcePath ' Use SourcePath
		                  Else
		                    LinkOutPath = StartPath + ItemLLItem.TitleName ' No SorcePath use Title Name as a backup
		                  End If
		                End If
		                MakeFolder(LinkOutPath)
		                
		                LinkOutPathSet = LinkOutPath
		                
		                ' Cleanup Other Sort menu Styles
		                If Not SkipCleanup Then MakeLinksCleanOtherStyles(CurrentCat, StartPath, LinkOutPath, I, StartPathAlt)
		                
		                'Now Make Shortcut
		                CreateShortcut(ItemLnk(I).Title, Target, Slash(FixPath(ItemLnk(I).Link.WorkingDirectory)), Slash(FixPath(LinkOutPathSet)),ItemLnk(I).Link.Arguments,ItemLnk(I).Link.IconLocation, ItemLnk(I).Link.Hotkey, ItemLnk(I).Link.Description)
		                
		              End If
		              
		            End If
		          Next J
		        End If
		        
		        'Do Associations?  'Linux is done above in it's section as it only requires adding it to the .desktop file
		        'Windows (Not Wine) Associations
		        If ItemLnk(I).Associations.Trim <> "" Then
		          MakeFileType(ItemLnk(I).Title, ItemLnk(I).Associations, ItemLnk(I).Link.Description, Target, ExpPath(ItemLnk(I).Link.WorkingDirectory), ItemLnk(I).Link.IconLocation)
		        End If
		        
		        'Do Individual links desktop if set
		        If ItemLnk(I).Desktop = True Then
		          If AdminEnabled Then
		            CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.SharedDesktop.NativePath)))
		          Else 'User only
		            CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.Desktop.NativePath)))
		          End If
		        End If
		        
		        '**** Make Extra Shortcuts on Desktop, SendTo, Root, Startup and Quicklaunch
		        If FirstLinkDone = False Then
		          MakeLinksExtra(I, Target, StartPath)
		          FirstLinkDone = True
		        End If
		        
		      Next
		      ItemLLItem.StartMenuSourcePath = OrigStartSourceMenu
		    End If 'End of Windows Section
		  End If
		  
		  'Delete all items at once, MUCH faster
		  If QueueDeltreeMajor = False Then
		    QueueDeltree = False
		    If Debugging Then Debug("--- Make Links Minor Delete Job ---")
		    RunCommand (QueueDeltreeJobs)
		    QueueDeltreeJobs = ""
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeLinksCleanOtherStyles(Catalog As String, StartPath As String, LinkOutPath As String, I As Integer, StartPathAlt As String)
		  If Debugging Then Debug ("--- Clean Other Menu Styles ---")
		  
		  'Dim LinkOutPathAlt As String
		  
		  
		  StartPath = Slash(StartPath).ReplaceAll("/","\")
		  LinkOutPath = LinkOutPath.ReplaceAll("/","\")
		  StartPathAlt = Slash(StartPathAlt).ReplaceAll("/","\")
		  
		  
		  If Debugging Then Debug ("Catalog: "+Catalog+" StartPath: "+StartPath+" LinkOutPath: "+LinkOutPath+" I: "+ I.ToString )
		  If Debugging Then Debug ("StartMenuStylesCount: "+StartMenuStylesCount.ToString)
		  
		  Dim N, O As Integer
		  
		  Dim LinkOutPathSet As String = LinkOutPath
		  
		  For N = 0 To StartMenuStylesCount
		    For O = 0 To StartMenuLocationsCount(N)
		      If Catalog = StartMenuLocations(O, N).Catalog Then Exit ' O will be the match
		    Next
		    
		    LinkOutPath = StartPath + StartMenuLocations(O, N).Path ' StartPath is where Writable
		    
		    If ItemLLItem.Flags.IndexOf("keepinfolder") >= 0 Then
		      If ItemLLItem.StartMenuSourcePath <> "" Then 
		        If MenuStyle = "UnSorted" Then
		          If ItemLLItem.StartMenuSourcePath <> ItemLLItem.TitleName Then LinkOutPath = LinkOutPath+"\"+ItemLLItem.StartMenuSourcePath 'Remove sorted Keep Folder if not the same as unsorted will be
		        Else
		          LinkOutPath = LinkOutPath+"\"+ItemLLItem.StartMenuSourcePath 'Remove sorted Keep Folder
		        End If
		      Else
		        If MenuStyle <> "UnSorted" Then
		          LinkOutPath = Slash(StartPath) + ItemLLItem.TitleName ' Remove Unsorted Keep Folder if not menustyle unsorted ' else it removes the items shortcuts and folder
		        Else
		        End If
		      End If
		    End If
		    
		    If N = StartMenuUsed Then LinkOutPath = "" ' Don't remove current sorting style
		    
		    If LinkOutPath <> "" Then
		      If ItemLLItem.Flags.IndexOf("keepinfolder") < 0 Then
		        LinkOutPath = LinkOutPath + "\" + ItemLnk(I).Title + ".lnk" ' One Item
		      End If
		      
		      LinkOutPath = LinkOutPath.ReplaceAll("/","\")
		      
		      'If Debugging Then Debug("Delete Start Menu: " + LinkOutPath)
		      
		      ' Don't delete if part of the main tree
		      If Not Exist("C:\windows\ssTek\Menu\" + LinkOutPath.ReplaceAll(StartPath, "")) Then 
		        ''If Exist(LinkOutPath) Then Deltree(LinkOutPath) ' Delete Old Link Sorting
		        'If Exist(LinkOutPath) = True Then 
		        Deltree(LinkOutPath)
		      End If
		      
		      If StartPathAlt <> "" Then 
		        'If Exist(LinkOutPath.Replace(StartPath, StartPathUser)) = True Then 
		        Deltree(LinkOutPath.Replace(StartPath, StartPathUser))
		      End If
		      If MenuStyle <> "UnSorted" Then
		        ''If Exist(StartPath + "Games\"+ItemLnk(I).Title +".lnk") Then Deltree (StartPath + "Games\"+ItemLnk(I).Title +".lnk")'Delete Unsorted Game Link
		        'If Exist(StartPath + "Games\"+ItemLnk(I).Title +".lnk") = True Then 
		        Deltree(StartPath + "Games\"+ItemLnk(I).Title +".lnk")
		        If StartPathAlt <> "" Then Deltree(StartPathAlt + "Games\"+ItemLnk(I).Title +".lnk")
		        
		        ''If Exist (StartPath + ItemLLItem.TitleName) Then Deltree (StartPath + ItemLLItem.TitleName) 'Delete Unsorted Apps (They use Title Name to make the folder)
		        'If Exist(StartPath + ItemLLItem.TitleName) = True Then 
		        Deltree(StartPath + ItemLLItem.TitleName)
		        If StartPathAlt <> "" Then  Deltree(StartPathAlt + ItemLLItem.TitleName)
		        
		        If ItemLLItem.StartMenuSourcePath <> "" Then
		          ''If Exist (StartPath + ItemLLItem.StartMenuSourcePath) Then Deltree (StartPath + ItemLLItem.StartMenuSourcePath) 'Delete Unsorted Apps Folders
		          'If Exist(StartPath + ItemLLItem.StartMenuSourcePath) = True Then 
		          Deltree(StartPath + ItemLLItem.StartMenuSourcePath)
		          If StartPathAlt <> "" Then
		            Deltree(StartPathAlt + ItemLLItem.StartMenuSourcePath+"\"+ItemLnk(I).Title +".lnk") ' This is only the Alt Path, meaning just the User one gets removed
		            Deltree(StartPathAlt + ItemLLItem.StartMenuSourcePath)
		          End If
		        End If
		      End If
		    End If
		    
		    If StartPathAlt <> "" Then
		      ''Deltree(Slash(FixPath(LinkOutPathSet)).ReplaceAll(StartPath, StartPathAlt)+ItemLnk(I).Title+".lnk") 'This should remove the User Link if in Admin Mode to remake it
		      'If Exist(Slash(FixPath(LinkOutPathSet)).ReplaceAll(StartPath, StartPathAlt)+ItemLnk(I).Title+".lnk") = True Then 
		      Deltree(Slash(LinkOutPath).ReplaceAll(StartPath, StartPathAlt)+ItemLnk(I).Title+".lnk")
		    End If
		    
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeLinksExtra(I As Integer, Target As String, StartPath As String)
		  'Make Desktop Shortcut also if picked
		  If ItemLnk(I).Desktop = True Then
		    If AdminEnabled Then
		      CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.SharedDesktop.NativePath)))
		    Else 'User only
		      CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.Desktop.NativePath)))
		    End If
		  End If
		  
		  'If ItemLLItem.Flags.IndexOf ("desktop") >=0 Then ' This will do all links, not just the first one
		  'If AdminEnabled Then
		  'CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.SharedDesktop.NativePath)))
		  'Else 'User only
		  'CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.Desktop.NativePath)))
		  'End If
		  'End If
		  
		  
		  'SendTo
		  If ItemLLItem.Flags.IndexOf ("sendto") >=0 Then 'Trying to do it for all of the Windows items, if it's set, then assume there is only one shortcut
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.ApplicationData.NativePath))+"Microsoft/Windows/SendTo/")
		  End If
		  'Make SendTo Shortcut also if picked in LNK
		  If ItemLnk(I).Flags.IndexOf ("sendto") >=0 Then 'Per Item
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.ApplicationData.NativePath))+"Microsoft/Windows/SendTo/")
		  End If
		  
		  'Programs
		  If ItemLLItem.Flags.IndexOf ("programs") >=0 Then 'Trying to do it for all of the Windows items, if it's set, then assume there is only one shortcut
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(StartPath)))
		  End If
		  If ItemLnk(I).Flags.IndexOf ("programs") >=0 Then 'Per Item
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(StartPath)))
		  End If
		  
		  'Root
		  If ItemLLItem.Flags.IndexOf ("root") >=0 Then 'Trying to do it for all of the Windows items, if it's set, then assume there is only one shortcut
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(StartPath)))
		  End If
		  If ItemLnk(I).Flags.IndexOf ("root") >=0 Then 'per Item
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(StartPath)))
		  End If
		  
		  'Startup
		  If ItemLLItem.Flags.IndexOf ("startup") >=0 Then 'Trying to do it for all of the Windows items, if it's set, then assume there is only one shortcut
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(Slash(FixPath(StartPath))+"Startup"))
		  End If
		  If ItemLnk(I).Flags.IndexOf ("startup") >=0 Then 'Per Item
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(Slash(FixPath(StartPath))+"Startup"))
		  End If
		  
		  'QuickLaunch
		  If ItemLLItem.Flags.IndexOf ("quicklaunch") >=0 Then 'Trying to do it for all of the Windows items, if it's set, then assume there is only one shortcut
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.ApplicationData.NativePath))+"Microsoft/Internet Explorer/Quick Launch/")
		  End If
		  If ItemLnk(I).Flags.IndexOf ("quicklaunch") >=0 Then 'Per Item
		    CreateShortcut(ItemLnk(I).Title, Target, Slash(ItemLnk(I).Link.WorkingDirectory), Slash(FixPath(SpecialFolder.ApplicationData.NativePath))+"Microsoft/Internet Explorer/Quick Launch/")
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeLinuxLink(TitleName As String, Exec As String, RunPath As String, LinkOutLocation As String, Args As String = "", Icon As String = "")
		  Dim DesktopFile As String
		  Dim DesktopContent As String
		  
		  DesktopFile = LinkOutLocation+TitleName.ReplaceAll(" ", ".") + ".desktop" 'Remove Spaces and add .desktop back to file name
		  
		  DesktopContent = "[Desktop Entry]" + Chr(10)
		  DesktopContent = DesktopContent + "Type=Application" + Chr(10)
		  DesktopContent = DesktopContent + "Version=1.0" + Chr(10)
		  DesktopContent = DesktopContent + "Name=" + TitleName + Chr(10)
		  DesktopContent = DesktopContent + "Exec=" + Exec + Chr(10)
		  DesktopContent = DesktopContent + "Path=" + RunPath + Chr(10)
		  'DesktopContent = DesktopContent + "Comment=" + ItemLnk(I).Link.Description + Chr(10)
		  DesktopContent = DesktopContent + "Icon=" + Icon + Chr(10)
		  DesktopContent = DesktopContent + "Categories=Game" + Chr(10)
		  DesktopContent = DesktopContent + "Terminal=No" + Chr(10)
		  
		  SaveDataToFile (DesktopContent, DesktopFile)
		  ShellFast.Execute("chmod 775 "+Chr(34)+DesktopFile+Chr(34))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakePathIcon(FolderIn As String, IconPathFile As String, IconIndex As String, QueueUp As Boolean = False)
		  If IconPathFile = "" Then Return 'No Icon Found, Skip 
		  If IconIndex = "" Then IconIndex = "0" 'Set to 0 if none specified
		  
		  Dim Data As String
		  Dim DesktopINI As String
		  
		  FolderIn = NoSlash(FolderIn).ReplaceAll("/", "\")
		  DesktopINI = Slash(FolderIn) + "desktop.ini"
		  DesktopINI = DesktopINI.ReplaceAll("/", "\")
		  
		  'As this isn't important to the functioning, I'll capture any errors and ignore doing it.
		  #Pragma BreakOnExceptions Off
		  Try
		    If Exist(FolderIn) Then
		      Data = "[.ShellClassInfo]" + Chr(13) + "ConfirmFileOp=0" + Chr(13) + "IconFile=" + IconPathFile + Chr(13) + "IconIndex=" + IconIndex + Chr(13)
		      SaveDataToFile(Data, DesktopINI)
		      
		      If QueueUp Then
		        CommandReturned = "attrib " + Chr(34) + DesktopINI + Chr(34) + " +h +s" + Chr(10)
		        CommandReturned = CommandReturned + "attrib " + Chr(34) + FolderIn + Chr(34) + " +s" + Chr(10)
		      Else
		        ShellFast.Execute("attrib " + Chr(34) + DesktopINI + Chr(34) + " +h +s") 'Ini is hidden and system
		        ShellFast.Execute("attrib " + Chr(34) + FolderIn + Chr(34) + " +s") 'Folder is system, else no icons shown
		        If Debugging Then Debug("attrib " + Chr(34) + FolderIn + Chr(34) + " +s" + " = " + ShellFast.ReadAll)
		      End If
		    End If
		  Catch
		  End Try
		  
		  #Pragma BreakOnExceptions On
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MakeSFX(FileINI As String)
		  ' 
		  ' ' Builds a self-extracting .run package for a store item.
		  '
		  ' Pass FileINI directly from Data.Items — do NOT rely on ItemLLItem being populated,
		  ' and do NOT call LoadLLFile first (it has side-effects: resets ItemLLItem, loads
		  ' icons, may extract archives to temp).
		  '
		  ' FileINI is the full path to the descriptor file, e.g.:
		  '   /store/MyGame/LLGame.llg
		  '   /store/MyApp/LLApp.lla
		  '   /store/MyApp/ssApp.app
		  '
		  ' GetFullParent() strips the filename to give the source folder, which is exactly
		  ' what make_sfx.sh expects as its $1 argument — the same pattern Installing() uses.
		  '
		  ' Window handler usage:
		  '   MakeSFX(Data.Items(CurrentItemID).FileINI)
		  
		  If Debugging Then Debug("--- MakeSFX --- FileINI: " + FileINI)
		  
		  If FileINI.Trim = "" Then
		    MessageBox("Make SFX: No item path available. Is an item selected?")
		    Return
		  End If
		  
		  ' Derive the source folder from the descriptor file path — same as Installing() does.
		  Dim SourcePath As String = NoSlash(GetFullParent(FileINI))
		  
		  If SourcePath = "" Or Not Exist(SourcePath) Then
		    If Debugging Then Debug("MakeSFX: source folder not found: " + SourcePath)
		    MessageBox("Make SFX: Source folder not found:" + Chr(10) + SourcePath + Chr(10) + Chr(10) + "Derived from: " + FileINI)
		    Return
		  End If
		  
		  ' Confirm make_sfx.sh is present
		  Dim ScriptPath As String = Slash(ToolPath) + "make_sfx.sh"
		  If Not Exist(ScriptPath) Then
		    If Debugging Then Debug("MakeSFX: make_sfx.sh not found: " + ScriptPath)
		    MessageBox("Make SFX: make_sfx.sh not found at:" + Chr(10) + ScriptPath)
		    Return
		  End If
		  
		  ' Ensure the script is executable
		  Dim ChSh As New Shell
		  ChSh.Execute("chmod +x " + Chr(34) + ScriptPath + Chr(34))
		  While ChSh.IsRunning
		    App.DoEvents(20)
		  Wend
		  
		  ' Build the command — quote both paths to handle spaces
		  Dim Cmd As String = Chr(34) + ScriptPath + Chr(34) + " " + Chr(34) + FileINI + Chr(34) + " " + Chr(34) + Slash(SourcePath) + Chr(34)
		  If Debugging Then Debug("MakeSFX Cmd: " + Cmd)
		  
		  ' Launch in a visible terminal so the user can see the build log.
		  ' Uses the same SysTerminal branching as EnableSudoScript().
		  Dim TermSh As New Shell
		  TermSh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  TermSh.TimeOut = -1
		  
		  If SysTerminal.Trim = "gnome-terminal" Then
		    TermSh.Execute(SysTerminal.Trim + " --wait -e " + Chr(39) + Cmd + Chr(39))
		  ElseIf SysTerminal.Trim = "kde-ptyxis" Then
		    TermSh.Execute(SysTerminal.Trim + " -x " + Chr(39) + Cmd + Chr(39))
		  Else
		    TermSh.Execute(SysTerminal.Trim + " -e " + Chr(39) + Cmd + Chr(39))
		  End If
		  
		  If Debugging Then Debug("MakeSFX: launched for: " + FileINI)
		  
		  While TermSh.IsRunning
		    App.DoEvents(20)
		  Wend
		  
		  If Debugging Then Debug("MakeSFX script returned: " + TermSh.ReadAll)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MkDir(InPath As String)
		  MakeFolder (InPath) 'Forward it on to the good one
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(Source As String, Dest As String)
		  'Glenn - ReWrite this to use RunCommand if I have future issues
		  
		  If Debugging Then Debug("Move: "+Source + " To "+Dest)
		  If Source = "" Or Source.Length <= 4 Then Return 'Don't remove short paths, it's dangerous to do them as mistakes happen
		  If Dest = "" Or Dest.Length <= 4 Then Return 'Don't remove short paths, it's dangerous to do them as mistakes happen
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = -1
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim Parent As String
		  
		  Dim OutFile As String
		  
		  Dest = Slash(Dest) 'Must have Slash at the end or will fail (asking for is file or folder)
		  
		  If TargetWindows Then Source = Source.ReplaceAll("/","\") 'move needs backslash in Windows
		  If TargetWindows Then Dest = Dest.ReplaceAll("/","\") 'move needs backslash in Windows
		  
		  If TargetWindows Then Source = Source.ReplaceAll("\\","\") 'Remove double slashes caused by empty paths
		  If TargetWindows Then Dest = Dest.ReplaceAll("\\","\") 'Remove double slashes caused by empty paths
		  
		  
		  Source = Source.Trim
		  Dest = Dest.Trim
		  
		  If Right(Source,4) <> ".lnk" Then
		    Parent = NoSlash(Source).Trim
		    Parent = Right(Source,Len(Source)-InStrRev(Source,"\"))
		    MakeFolder (Slash(Dest)+Parent) 'Make Dest exist before copy/move to it
		  Else 'It IS a link
		    MakeFolder (Slash(Dest)) 'Make Dest exist before copy/move to it
		  End If
		  
		  'Move Files and Folders
		  If TargetWindows Then
		    'Method 1
		    'ShellFast.Execute ("move /y " + Chr(34)+Source+Chr(34)+" "+ Chr(34)+Dest+Chr(34))
		    
		    'Method 2 - Try copy and Deltree methods (Will work for now)
		    If Parent <> "" Then
		      ShellFast.Execute ("xcopy /e /c /q /h /r /y " + Chr(34)+Source+Chr(34)+" "+ Chr(34)+Dest+"\"+Parent+"\"+Chr(34)) 'Keep Parent Folder Name
		    Else
		      ShellFast.Execute ("xcopy /e /c /q /h /r /y " + Chr(34)+Source+Chr(34)+" "+ Chr(34)+Dest+"\"+Chr(34)) 'Drop Parent Folder Name
		    End If
		    
		    If Debugging Then Debug("Result: "+ ShellFast.ReadAll) 'Just output link jobs for now, it's messy in here
		    
		    'Need to test Parent isn't the same as the dest
		    Parent = NoSlash(Source).Trim
		    Parent = Left(Source,InStrRev(Source,"\"))
		    
		    If Debugging Then Debug("Parent Test: "+ NoSlash(Parent).Lowercase+ " Dest: " + NoSlash(Dest).Lowercase)
		    
		    If NoSlash(Parent).Lowercase <> NoSlash(Dest).Lowercase And NoSlash(Source).Trim.Lowercase <> NoSlash(Dest).Lowercase Then 'Only Delete if not the same folder - else we'll have NO folder left at all.
		      Deltree (Source) 'Remove once xcopied
		    Else
		      If Debugging Then Debug("Parent is Destination, not Deleted")
		    End If
		    
		  Else 'linux, no problems with running shell
		    ShellFast.Execute ("mv -f " + Chr(34)+Source+Chr(34)+" "+ Chr(34)+Dest+Chr(34))
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveLinks()
		  Dim M, I As Integer
		  Dim Sp() As String
		  Dim Link As Shortcut
		  Dim Found As Boolean
		  
		  Dim Data As String
		  
		  
		  'Split Shortcuts To Keep
		  Sp() = ItemLLItem.ShortCutNamesKeep.Split("|")
		  
		  'Clean up Temp LLShorts Folder
		  Deltree (Slash(TmpPath)+"LLShorts")
		  MakeFolder (Slash(TmpPath)+"LLShorts")
		  
		  If Not TargetWindows Then 'Linux and Mac
		    ' If not set to keep on Desktop in Linux, it'll remove the .desktop file
		    If ItemLLItem.Flags.IndexOf("desktop") < 0 Then 'Not found, so Move it to the destination folder or delete it if exist
		      If Sp.Count >= 1 Then
		        For M = 0 To Sp.Count-1
		          Move (Slash(FixPath(SpecialFolder.Desktop.NativePath)) + Sp(M).Trim +".desktop", Slash(TmpPath)+"LLShorts/")
		        Next M
		      End If
		    End If
		  End If
		  
		  If TargetWindows Then
		    
		    If ItemLLItem.StartMenuSourcePath = "" Then ItemLLItem.StartMenuSourcePath = ItemLLItem.TitleName 'Make sure a SourcePath is set
		    
		    If Exist(CurrentssAppFile) Then 'Has to exist to load and re-write it
		      If Debugging Then Debug ("--- Adding to update ssApp.app: "+ CurrentssAppFile)
		      Data = LoadDataFromFile (CurrentssAppFile)
		      Data = Data.Trim
		      Data = Data + Chr(10) 'Make sure it starts on a new line.
		    End If
		    
		    
		    For M = 0 To Sp.Count-1
		      Sp(M) = Sp(M).Trim
		      
		      'Check items default start menu too:
		      If Exist(Slash(Slash(FixPath(StartPathAll))+ItemLLItem.StartMenuSourcePath) + Sp(M)+".lnk") Then XCopyFile (Slash(Slash(FixPath(StartPathAll))+ItemLLItem.StartMenuSourcePath) + Sp(M)+".lnk", Slash(TmpPath)+"LLShorts/") 'All Users
		      If Exist(Slash(Slash(FixPath(StartPathUser))+ItemLLItem.StartMenuSourcePath) + Sp(M)+".lnk") Then XCopyFile (Slash(Slash(FixPath(StartPathUser))+ItemLLItem.StartMenuSourcePath) + Sp(M)+".lnk", Slash(TmpPath)+"LLShorts/") 'Current User
		      
		      'Check root of start menu too:
		      If Exist(Slash(FixPath(StartPathAll)) + Sp(M)+".lnk") Then XCopyFile (Slash(FixPath(StartPathAll)) + Sp(M)+".lnk", Slash(TmpPath)+"LLShorts/") 'All Users
		      If Exist(Slash(FixPath(StartPathUser)) + Sp(M)+".lnk") Then XCopyFile (Slash(FixPath(StartPathUser)) + Sp(M)+".lnk", Slash(TmpPath)+"LLShorts/") 'Current User
		      
		      'Check Desktop
		      If Exist(Slash(FixPath(SpecialFolder.Desktop.NativePath)) + Sp(M)+".lnk") Then XCopyFile (Slash(FixPath(SpecialFolder.Desktop.NativePath)) + Sp(M)+".lnk", Slash(TmpPath)+"LLShorts/") 'Current User
		      If Exist(Slash(FixPath(SpecialFolder.SharedDesktop.NativePath)) + Sp(M)+".lnk") Then XCopyFile (Slash(FixPath(SpecialFolder.SharedDesktop.NativePath)) + Sp(M)+".lnk", Slash(TmpPath)+"LLShorts/") 'All Users
		      
		      If ItemLLItem.Flags.IndexOf("desktop") < 0 Then 'Not set as flag so delete off desktop if it exist for cleanup
		        If Exist(Slash(FixPath(SpecialFolder.Desktop.NativePath)) + Sp(M)+".lnk") Then Deltree (Slash(FixPath(SpecialFolder.Desktop.NativePath)) + Sp(M)+".lnk")
		        If Exist(Slash(FixPath(SpecialFolder.SharedDesktop.NativePath)) + Sp(M)+".lnk") Then Deltree (Slash(FixPath(SpecialFolder.SharedDesktop.NativePath)) + Sp(M)+".lnk")
		      End If
		      
		      If Debugging Then Debug("* Trying MoveLink Job: " + Sp(M)+".lnk")
		      If Exist (Slash(TmpPath)+"LLShorts/"+Sp(M)+".lnk") Then
		        If Debugging Then Debug("Starting MoveLink Job: " + Sp(M)+".lnk")
		        
		        Found = False 'Scan if already in the Shortcuts in the .app .ppg file
		        If LnkCount >= 1 Then
		          For I = 0 To LnkCount
		            If ItemLnk(LnkCount).Title = Sp(M) Then
		              Found = True
		              Exit
		            End If
		          Next I
		        End If
		        
		        If Found = False Then 'Only add items that aren't already in the .app .ppg files
		          'Get all the Link File Details
		          Link = GetShortcut(Slash(TmpPath)+"LLShorts/"+Sp(M)+".lnk")
		          
		          'Add To ItemLnk - so can use the Proper sorting tools in MakeLinks
		          If Link.TargetPath <> "" Then
		            LnkCount = LnkCount + 1
		            ItemLnk(LnkCount).Title = Sp(M)
		            ItemLnk(LnkCount).Link.TargetPath = Link.TargetPath
		            ItemLnk(LnkCount).Link.Arguments = Link.Arguments
		            ItemLnk(LnkCount).Link.WorkingDirectory = Link.WorkingDirectory
		            ItemLnk(LnkCount).Link.Description = Link.Description
		            ItemLnk(LnkCount).Link.IconLocation = Link.IconLocation
		            ItemLnk(LnkCount).Link.Hotkey = Link.Hotkey
		            ItemLnk(LnkCount).Link.WindowStyle = Link.WindowStyle
		            ItemLnk(LnkCount).Categories = ItemLLItem.Catalog 'Use main item's catalog for sorting.
		            If LnkCount = 1 Then
		              If ItemLLItem.Flags.IndexOf("desktop")>=0 Then ItemLnk(LnkCount).Desktop = True 'Set this is first item in ssApps
		              '''If ItemLLItem.Flags.IndexOf("desktop")>=0 Then ItemLnk(LnkCount). = True 'Need to check for SendTo, not sure I've added support yet
		              ''ItemLnk(LnkCount).ShowOn  <- Maybe add this as option, then treat like flags?
		            End If
		            
		            If Debugging Then Debug ("Link Icon Details: "+ItemLnk(LnkCount).Link.IconLocation)
		          End If
		          
		          'Do The Link Rewrite seperate to evey kept Link that I find
		          CurrentssAppFile = CurrentssAppFile.ReplaceAll("/","\")
		          If Debugging Then Debug ("--- Attempting to update ssApp.app: "+ CurrentssAppFile)
		          If Link.TargetPath <> "" Then
		            If Data <> "" Then
		              Data = Data + "["+Sp(M).Trim+".lnk"+"]" + Chr(10)
		              Data = Data + "Target="+Link.TargetPath + Chr(10)
		              If Link.Arguments <> "" Then Data = Data + "Args="+Link.Arguments + Chr(10)
		              If Link.WorkingDirectory <> "" Then Data = Data + "WorkingDir="+Link.WorkingDirectory + Chr(10)
		              If Link.Description <> "" Then 
		                If Link.Description.ReplaceAll(EndOfLine,Chr(30)).Trim <> ItemLLItem.Descriptions.Trim Then ' Only if different
		                  Data = Data + "Comment="+Link.Description.ReplaceAll(EndOfLine,Chr(30)) + Chr(10) ' Make sure all EOL are Chr(30) to make it one line.
		                End If
		              End If
		              If LnkCount = 1 Then
		                If ItemLnk(LnkCount).Desktop = True Then Data = Data + "ShowOn=desktop"+ Chr(10)
		              End If
		            End If
		          End If
		        End If
		      End If
		    Next M
		    
		    'Finally Rewrite the ssApp.ini if Data changed so can resort menu styles
		    If Data <> "" Then
		      If Debugging Then Debug ("Saving Data to file: "+CurrentssAppFile)
		      SaveDataToFile (Data,CurrentssAppFile)
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NoSlash(Inn As String) As String
		  If Inn <> "" Then
		    If Right(Inn,1)="/" Or Right(Inn,1)="\" Then Inn = Left(Inn,Len(Inn)-1)
		  End If
		  Return Inn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Notify(Head As String, Msg As String, IconFile As String = "", NoteTimeOut As Integer = 4000)
		  If MiniInstallerShowing Then Return
		  
		  // 1. Show the window immediately so the OS knows it exists
		  Notification.Show
		  Notification.Top = Screen(0).AvailableHeight - Notification.Height - 10
		  Notification.Left = Screen(0).AvailableWidth - Notification.Width - 10
		  
		  // 2. Do a quick Refresh here so a blank window appears at least
		  Notification.Refresh
		  App.DoEvents(5)
		  
		  
		  Dim F As FolderItem
		  Dim IconPic As Picture
		  Notification.Status.Text = Msg
		  
		  IconPic = Nil
		  
		  If IconFile <> "" Then
		    Try
		      F = GetFolderItem(IconFile, FolderItem.PathTypeNative)
		      If F <> Nil And F.Exists Then
		        IconPic = Picture.Open(F)
		      End If
		    Catch
		    End Try
		  End If
		  
		  Try
		    If IconPic = Nil Then 'Set default Icon — try the in-memory DefaultFader first
		      IconPic = DefaultFader
		    End If
		    If IconPic = Nil And ThemePath <> "" Then 'ThemePath known — load Icon.png directly from the active theme folder
		      Dim ThemeIconF As FolderItem = GetFolderItem(ThemePath + "Icon.png", FolderItem.PathTypeNative)
		      If ThemeIconF <> Nil And ThemeIconF.Exists Then
		        IconPic = Picture.Open(ThemeIconF)
		      End If
		    End If
		    If IconPic = Nil Then 'ThemePath not set yet (e.g. -setup mode) — try the default theme folder
		      Dim DefaultIconF As FolderItem
		      If Exist (Slash(AppPath) + "Themes/LastLinux/Icon.png") = True Then
		        DefaultIconF = GetFolderItem(Slash(AppPath) + "Themes/LastLinux/Icon.png", FolderItem.PathTypeNative)
		      Else
		        DefaultIconF = GetFolderItem(Slash(AppPath) + "llstore Resources/appicon_256.png", FolderItem.PathTypeNative)
		      End If
		      If DefaultIconF <> Nil And DefaultIconF.Exists Then
		        IconPic = Picture.Open(DefaultIconF)
		      End If
		    End If
		  Catch
		  End Try
		  
		  Try
		    'Below is the only way to make the icon blend with the text status as it doesn't honer the Theme
		    Notification.Backdrop =  New Picture(Notification.Width,Notification.Height, 32)
		    Notification.Backdrop.Graphics.DrawingColor =  &C000000
		    Notification.Backdrop.Graphics.FillRectangle(0,0,Notification.Width,Notification.Height)
		    
		    
		    Notification.Icon.Backdrop = New Picture(Notification.Icon.Width,Notification.Icon.Height, 32)
		    Notification.Icon.Backdrop.Graphics.DrawingColor =  &C000000
		    Notification.Icon.Backdrop.Graphics.FillRectangle(0,0,Notification.Icon.Width,Notification.Icon.Height)
		    Notification.Icon.Backdrop.Graphics.DrawPicture(IconPic,0,0,Notification.Icon.Width, Notification.Icon.Height,0,0,IconPic.Width, IconPic.Height)
		    Notification.Icon.Refresh
		  Catch
		  End Try
		  
		  If MiniInstaller.Visible = True Then
		    Notification.Left = MiniInstaller.Left - Notification.Width ' Put to Left of the MiniInstaller (not Used)
		  Else
		    Notification.Left = Screen(0).AvailableWidth - Notification.Width - 10 ' (10 padding?)
		  End If
		  Notification.Top = Screen(0).AvailableHeight - Notification.Height -10
		  
		  Notification.NotificationTime = NoteTimeOut
		  
		  Notification.Title = Head
		  
		  
		  If Notification.NotificationTime = -1 Then
		    Notification.NotifyTimeOut.Period = 99999 'A long time
		  Else
		    Notification.NotifyTimeOut.Period = (Notification.NotificationTime)
		  End If
		  Notification.NotifyTimeOut.RunMode = Timer.RunModes.Single
		  Notification.NotifyTimeOut.Reset
		  
		  
		  Notification.Show
		  Notification.SetFocus
		  
		  // 3. Final push — Windows needs the SetForegroundWindow API because the OS
		  // blocks focus-stealing from background/shell-launched processes by default.
		  #If TargetWindows Then
		    Try
		      Declare Function AllowSetForegroundWindow Lib "User32" (dwProcessId As Integer) As Boolean
		      Declare Function SetForegroundWindow Lib "User32" (hwnd As Ptr) As Boolean
		      Dim b1 As Boolean = AllowSetForegroundWindow(-1)
		      Dim b2 As Boolean = SetForegroundWindow(Notification.Handle)
		    Catch
		    End Try
		    Notification.Refresh(True)
		    App.DoEvents(150)
		    Notification.Refresh(True)
		    App.DoEvents(100)
		  #Else
		    Notification.Refresh 
		    App.DoEvents(30)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpenDialog(FileTyp As FileType, Title As String, InitialPath As String) As String
		  Dim Init, F As FolderItem
		  Dim dlg As OpenDialog
		  
		  If InitialPath = "" Then InitialPath = SpecialFolder.Desktop.NativePath
		  
		  Init = GetFolderItem(InitialPath, FolderItem.PathTypeNative)
		  dlg = New OpenDialog
		  dlg.InitialDirectory = Init
		  dlg.Title = Title
		  dlg.Filter = FileTyp
		  F = dlg.ShowModal()
		  
		  If F = Nil Then Return "" Else Return F.NativePath
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpenFileDialog(FileTyp As FileType, Title As String, InitialPath As String) As String
		  Dim Init, F As FolderItem
		  Dim dlg As OpenFileDialog
		  
		  If InitialPath = "" Then InitialPath = SpecialFolder.Desktop.NativePath
		  
		  Init = GetFolderItem(InitialPath, FolderItem.PathTypeNative)
		  dlg = New OpenFileDialog
		  dlg.InitialDirectory = Init
		  dlg.Title = Title
		  dlg.Filter = FileTyp
		  F = dlg.ShowModal()
		  
		  If F <> Nil Then
		    For Each file As Folderitem In dlg.SelectedFiles(False)
		      Return file.NativePath
		    Next
		  End If
		  
		  If F = Nil Then Return "" Else Return F.NativePath
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrepareToBuild()
		  ' Step 1 of the two-phase build.
		  ' Structured identically to PrepareToInstall() which works on Windows:
		  ' sets BuildMode/BuildHeader directly then calls Notify() with no indirection
		  ' and no access to Editor controls (which causes focus interference on Windows).
		  
		  Dim BT As String = ItemLLItem.BuildType
		  Dim VerPart As String = ""
		  If ItemLLItem.Version.Trim <> "" Then VerPart = " " + ItemLLItem.Version.Trim
		  
		  ' Set up notification state directly — do NOT go through Notification.StartBuild()
		  ' and do NOT access Editor.TextIncludeFolder / TextBuildToFolder here.
		  ' The installer works because PrepareToInstall calls Notify() directly with no
		  ' window-object access before it — we do the same here.
		  Notification.BuildMode = True
		  Notification.BuildHeader = ItemLLItem.TitleName + VerPart + " - " + BT
		  
		  ' Call Notify() directly, exactly like PrepareToInstall() does
		  Notify("LLStore Building", Notification.BuildHeader + Chr(10) + "Starting Build...", ItemLLItem.FileIcon, -1)
		  
		  Notification.Refresh(True)
		  App.DoEvents(80)
		  Notification.Refresh(True)
		  App.DoEvents(80)
		  
		  ' Belt-and-braces system tray fallback on Linux
		  If Not TargetWindows Then
		    RunCommand("notify-send --hint=int:transient:1 " + Chr(34) + "LLStore - Building: " + ItemLLItem.TitleName + Chr(34))
		  End If
		  
		  Notification.Refresh(True)
		  App.DoEvents(50)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrepareToInstall(FileIn As String) As Boolean
		  ' Step 1 of the two-phase install for CommandLine (StoreMode=2).
		  ' Shows a notification immediately with just the filename so the UI draws
		  ' BEFORE the archive extraction happens in Installing().
		  
		  If FileIn.Trim = "" Then Return False
		  
		  If TargetWindows Then
		    FileIn = FileIn.ReplaceAll("/", "\")
		  End If
		  
		  If Not Exist(FileIn) Then Return False
		  
		  ' Get just the filename portion for the initial notification
		  Dim ShortName As String
		  Dim SlashPos As Integer
		  If TargetWindows Then
		    FileIn = FileIn.ReplaceAll("/", "\")
		    SlashPos = InStrRev(FileIn, "\")
		  Else
		    SlashPos = InStrRev(FileIn, "/")
		  End If
		  If SlashPos > 0 Then
		    ShortName = Mid(FileIn, SlashPos + 1)
		  Else
		    ShortName = FileIn
		  End If
		  
		  ' Show notification immediately with filename (before any extraction)
		  Notify("LLStore Installing", "Preparing:-" + Chr(10) + ShortName, "", -1)
		  Notification.Refresh(True)
		  App.DoEvents(80)
		  Notification.Refresh(True)
		  App.DoEvents(80)
		  
		  ' Fire the system notification so something always appears even before our window draws
		  If Not TargetWindows Then
		    RunCommand("notify-send --hint=int:transient:1 " + Chr(34) + "LLStore - Preparing: " + ShortName + Chr(34))
		  End If
		  
		  Notification.Refresh(True)
		  App.DoEvents(50)
		  
		  Return True ' File exists and UI has been kicked — InstallTimer will call Installing()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PreQuitApp()
		  If Debugging Then Debug("- Pre Quit LLStore -")
		  
		  Loading.SaveSettings
		  
		  DebugOutput.Flush ' Actually Write to file after each thing
		  DebugOutput.Close 'Close File when quiting
		  Dim today As DateTime = DateTime.Now
		  Dim FileNameOut As String
		  Dim Suc As Boolean
		  If Debugging Then
		    FileNameOut = "LLStore_Debug "+today.Year.ToString+"-"+today.Month.ToString+"-"+today.Day.ToString+" "+today.Hour.ToString+"-"+today.Minute.ToString+"-"+today.Second.ToString+".txt"
		    MakeFolder (Slash(SpecialFolder.Desktop.NativePath)+"LLStore Debug-Logs")
		    Suc = Copy(DebugFileName, Slash(SpecialFolder.Desktop.NativePath)+"LLStore Debug-Logs/"+FileNameOut) 'Copy Debug to Desktop
		  End If
		  
		  'Clean Up Temp
		  CleanTemp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ProtectFonts()
		  #If TargetLinux Then
		    // We point to the local Resources folder
		    Var fontDir As FolderItem = App.ExecutableFile.Parent.Child("Resources").Child("Fonts")
		    
		    If fontDir <> Nil And fontDir.Exists Then
		      // Use FontConfig to add the local directory to this process ONLY
		      // This prevents the app from crashing when global fc-cache rebuilds
		      Declare Function FcConfigAppFontAddDir Lib "libfontconfig.so.1" (config As Ptr, path As CString) As Boolean
		      
		      // Passing Nil to config uses the current process configuration
		      Call FcConfigAppFontAddDir(Nil, fontDir.NativePath)
		    End If
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QuitApp()
		  StoreMode = 99 'Forces it to NOT show Main again
		  
		  If Debugging Then Debug("--- Quitting LLStore ---")
		  ForceQuit = True
		  Quit
		  'was 24 r4 causing issues
		  
		  'I added the Quit timer to the Loading Form, it now seems to quit when it's called, I only make the Editor set it to ForceQuit and hide iteself and let the QuitApp routine do the rest.
		  
		  ''Should never get here
		  
		  ForceQuit = True
		  
		  //manually close all windows
		  while window(0) <> nil
		    window(0).close
		  wend
		  
		  Quit
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReFixGameCats(CatIn As String) As String
		  CatIn = CatIn.ReplaceAll("FirstPersonShooter", "Game First-Person Shooter")
		  CatIn = CatIn.ReplaceAll("ThirdPersonShooter", "Game Third-Person Shooter")
		  CatIn = CatIn.ReplaceAll("HiddenObject", "Game Hidden Object")
		  CatIn = CatIn.ReplaceAll("RolePlaying", "Game Role Playing")
		  CatIn = CatIn.ReplaceAll("RolePlaying", "Game RollPlaying")
		  CatIn = CatIn.ReplaceAll("Racing; Driving", "Game Racing-Driving")
		  CatIn = CatIn.ReplaceAll("Racing", "Game Racing-Driving")
		  CatIn = CatIn.ReplaceAll("Driving", "Game Racing-Driving")
		  CatIn = CatIn.ReplaceAll("TowerDefense", "Game Tower Defense")
		  CatIn = CatIn.ReplaceAll("Farming; Crafting", "Game Farming & Crafting")
		  CatIn = CatIn.ReplaceAll("Farming", "Game Farming & Crafting")
		  CatIn = CatIn.ReplaceAll("Crafting", "Game Farming & Crafting")
		  
		  Return CatIn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunAssembly()
		  If Debugging Then Debug("--- Starting Run Assembly ---")
		  
		  Dim Shelly As New Shell
		  Dim StillActive As Boolean = True
		  
		  Dim Sp() As String
		  Dim F As FolderItem
		  Dim I As Integer
		  
		  Dim AssemblyFile, AssemblyContent As String
		  
		  Shelly.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  Shelly.TimeOut = -1
		  
		  'Change to App/Games INI Path to run Assemblys from
		  If ChDirSet(InstallFromPath) = True Then ' Was successful
		  End If
		  
		  Sp = Split(ItemLLItem.Assembly, Chr(30))
		  If Sp.Count >=1 Then
		    For I = 0 To Sp.Count -1
		      
		      If Sp(I).IndexOf(0, "#Is_x86#") >= 0 Then
		        If SysArchitecture = "x86" Or SysArchitecture = "ALL" Then
		          'Do It
		        Else
		          Continue 'Skip lines with wrong Arch
		        End If
		      End If
		      
		      If Sp(I).IndexOf(0, "#Is_x64#") >= 0 Then
		        If SysArchitecture = "x64" Or SysArchitecture = "ALL" Then
		          'Do It
		        Else
		          Continue 'Skip lines with wrong Arch
		        End If
		      End If
		      
		      If Sp(I).IndexOf(0, "#Is_ARM#") >= 0 Then
		        If SysArchitecture = "ARM" Or SysArchitecture = "ALL" Then
		          'Do It
		        Else
		          Continue 'Skip lines with wrong Arch
		        End If
		      End If
		      
		      Sp(I) = Sp(I).ReplaceAll("#Is_x86#","") 'Clean unrequired text
		      Sp(I) = Sp(I).ReplaceAll("#Is_x64#","") 'Clean unrequired text
		      Sp(I) = Sp(I).ReplaceAll("#Is_ARM#","") 'Clean unrequired text
		      Sp(I) = Sp(I).ReplaceAll("#Is_NT5#","") 'Clean unrequired text 'NT check not yet added to this method so will just use all by default, may cause issues?
		      Sp(I) = Sp(I).ReplaceAll("#Is_NT6#","") 'Clean unrequired text
		      Sp(I) = Sp(I).ReplaceAll("#Is_NT10#","") 'Clean unrequired text
		      
		      If Sp(I) <> "" Then
		        
		        'Add MSI installer to lines that have a .msi in them - May Need to remove for Windows Target
		        If Sp(I).IndexOf(".msi") >=1 Then
		          If Left(Sp(I),7) <> "msiexec" Then
		            'If Left(Sp(I),1)<>Chr(34) Then 'Need to check for end of .msi and remove /qb if it's an issue
		            Sp(I) = "msiexec /quiet /norestart /i "+Sp(I)
		          Else
		          End If
		        End If
		        
		        'Below is no longer available as I use a single generated script to apply Assembly, so this must happen in the default order, use Scripts if you need a defined order
		        Sp(I) = Sp(I).ReplaceAll("#RunScripts#","") 'Clean unrequired text
		        Sp(I) = Sp(I).ReplaceAll("#ApplyRegistry#","") 'Clean unrequired text
		        Sp(I) = Sp(I).ReplaceAll("#RegisterDLL#","") 'Clean unrequired text
		        Sp(I) = Sp(I).ReplaceAll("#ApplyPatch#","") 'Clean unrequired text
		        Sp(I) = Sp(I).ReplaceAll("#ShortcutS#","") 'Clean unrequired text
		        
		        AssemblyContent = AssemblyContent + Sp(I)+ Chr(10)
		      End If
		    Next
		  Else ' Single Line?
		    If Debugging Then Debug("- Single Line Assembly Command -")
		    
		    If ItemLLItem.Assembly.IndexOf(0, "#Is_x86#") >= 0 Then
		      If SysArchitecture = "x86" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        AssemblyContent = ""  'Skip lines with wrong Arch
		      End If
		    End If
		    
		    If ItemLLItem.Assembly.IndexOf(0, "#Is_x64#") >= 0 Then
		      If SysArchitecture = "x64" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        AssemblyContent = ""  'Skip lines with wrong Arch
		      End If
		    End If
		    
		    If ItemLLItem.Assembly.IndexOf(0, "#Is_ARM#") >= 0 Then
		      If SysArchitecture = "ARM" Or SysArchitecture = "ALL" Then
		        'Do It
		      Else
		        AssemblyContent = ""  'Skip lines with wrong Arch
		      End If
		    End If
		    
		    ItemLLItem.Assembly  = ItemLLItem.Assembly.ReplaceAll("#Is_x86#","") 'Clean unrequired text
		    ItemLLItem.Assembly  = ItemLLItem.Assembly.ReplaceAll("#Is_x64#","") 'Clean unrequired text
		    ItemLLItem.Assembly  = ItemLLItem.Assembly.ReplaceAll("#Is_ARM#","") 'Clean unrequired text
		    ItemLLItem.Assembly  = ItemLLItem.Assembly.ReplaceAll("#Is_NT5#","") 'Clean unrequired text 'NT check not yet added to this method so will just use all by default, may cause issues?
		    ItemLLItem.Assembly  = ItemLLItem.Assembly.ReplaceAll("#Is_NT6#","") 'Clean unrequired text
		    ItemLLItem.Assembly  = ItemLLItem.Assembly.ReplaceAll("#Is_NT10#","") 'Clean unrequired text
		    
		    'Below is no longer available as I use a single generated script to apply Assembly, so this must happen in the default order, use Scripts if you need a defined order
		    ItemLLItem.Assembly = ItemLLItem.Assembly.ReplaceAll("#RunScripts#","") 'Clean unrequired text
		    ItemLLItem.Assembly = ItemLLItem.Assembly.ReplaceAll("#ApplyRegistry#","") 'Clean unrequired text
		    ItemLLItem.Assembly = ItemLLItem.Assembly.ReplaceAll("#RegisterDLL#","") 'Clean unrequired text
		    ItemLLItem.Assembly = ItemLLItem.Assembly.ReplaceAll("#ApplyPatch#","") 'Clean unrequired text
		    ItemLLItem.Assembly = ItemLLItem.Assembly.ReplaceAll("#ShortcutS#","") 'Clean unrequired text
		    
		    If ItemLLItem.Assembly <> "" Then
		      
		      'Add MSI installer to lines that have a .msi in them - May Need to remove for Windows Target
		      If ItemLLItem.Assembly.IndexOf(".msi") >=1 Then
		        If Left(ItemLLItem.Assembly,7) <> "msiexec" Then
		          'If Left(Sp(I),1)<>Chr(34) Then 'Need to check for end of .msi and remove /qb if it's an issue
		          ItemLLItem.Assembly = "msiexec /quiet /norestart /i "+ItemLLItem.Assembly
		        Else
		        End If
		      End If
		      
		      AssemblyContent = AssemblyContent + ItemLLItem.Assembly + Chr(10)
		    End If
		  End If
		  
		  If AssemblyContent <> "" Then 'Generate Script and Run it all from a .cmd
		    Dim ScriptPath As String
		    ScriptPath = Slash(FixPath(TmpPath+"scripts" + Randomiser.InRange(10000, 20000).ToString))
		    MkDir(ScriptPath)
		    
		    'MkDir(InstallToPath) ' 'Let the Setup install the folder so I can detect where it goes.
		    AssemblyFile = ScriptPath+"Assembly.cmd"
		    SaveDataToFile(AssemblyContent, AssemblyFile)
		    
		    F = GetFolderItem(AssemblyFile, FolderItem.PathTypeNative)
		    If TargetWindows Then
		      Shelly.Execute ("cd " + Chr(34) + InstallFromPath + Chr(34) + " && " + Chr(34) + FixPath(F.NativePath) + Chr(34)) ' Use && Here because if path fails, then script will anyway
		    Else
		      Shelly.Execute("cd " + Chr(34) + InstallFromPath + Chr(34) + " && wine " + Chr(34) + FixPath(F.NativePath) + Chr(34)) ' Use && Here because if path fails, then script will anyway
		    End If
		    Dim AssyBuf As String = ""
		    While Shelly.IsRunning 
		      App.DoEvents(20)
		      AssyBuf = AssyBuf + Shelly.ReadAll 'Drain to prevent pipe deadlock
		    Wend
		    AssyBuf = AssyBuf + Shelly.ReadAll
		    If Debugging Then Debug("Assembly Return: "+ AssyBuf)
		    
		    'Delete the temp script I run
		    #Pragma BreakOnExceptions Off
		    Try
		      F.Remove
		      Deltree(ScriptPath)
		    Catch
		    End Try
		    #Pragma BreakOnExceptions On
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunCommand(CmdIn As String, FoldIn As String = "")
		  If Debugging Then 
		    Debug("--- RunCommand ---")
		    Debug("Cmd: -"+Chr(10)+ CmdIn)
		    If FoldIn <> "" Then
		      Debug("From Folder: "+FoldIn)
		    End If
		  End If
		  
		  Dim Sh As New Shell
		  Dim Success As Boolean
		  
		  Sh.TimeOut = -1
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim F As FolderItem
		  Dim ScriptFile As String = Slash(TmpPath)+"LLRunner"+Randomiser.InRange(10000, 20000).ToString+".cmd"
		  If CmdIn <> "" Then
		    
		    If FoldIn <> "" Then Success = ChDirSet(FoldIn)
		    
		    If TargetWindows Then
		      SaveDataToFile(CmdIn, ScriptFile)
		      
		      F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		      If F.Exists Then
		        'Run Script
		        Sh.Execute (F.NativePath)
		        
		        'Wait For Completion
		        While Sh.IsRunning
		          App.DoEvents(20)
		        Wend
		        
		        'Delete Temp Script
		        F.Remove
		      End If
		      F = Nil
		      'Disabled Logging Results - They are too vast
		      'If Debugging Then Debug("Results: -"+Chr(10)+Sh.ReadAll.Trim+Chr(10))
		    Else ''Linux Command, doesn't need to go to script file to work (it just does)
		      'Run Script
		      Sh.Execute (CmdIn)
		      
		      'Wait For Completion
		      While Sh.IsRunning
		        App.DoEvents(20)
		      Wend
		      'Disabled Logging Results - They are too vast
		      'If Debugging Then Debug("Results: -"+Chr(10)+Sh.ReadAll.Trim+Chr(10))
		      
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RunCommandDownload(CmdIn As String, FoldIn As String = "") As String
		  If Debugging Then 
		    Debug("--- RunCommandResults ---")
		    Debug("Cmd: -"+Chr(10)+ CmdIn)
		    If FoldIn <> "" Then
		      Debug("From Folder: "+FoldIn)
		    End If
		  End If
		  Dim Sh As New Shell
		  Dim Success As Boolean
		  Dim Res As String
		  
		  Sh.TimeOut = -1
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim F As FolderItem
		  Dim ScriptFile As String = Slash(TmpPath)+"LLRunner"+Randomiser.InRange(10000, 20000).ToString+".cmd"
		  If CmdIn <> "" Then
		    
		    If FoldIn <> "" Then Success = ChDirSet(FoldIn)
		    
		    If TargetWindows Then
		      SaveDataToFile(CmdIn, ScriptFile)
		      
		      F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		      If F.Exists Then
		        'Run Script
		        Sh.Execute (F.NativePath)
		        
		        'Wait For Completion - drain buffer each tick to prevent pipe deadlock
		        While Sh.IsRunning
		          App.DoEvents(20)
		          Res = Res + Sh.ReadAll 'Drain output buffer to prevent pipe deadlock
		        Wend
		        Res = Res + Sh.ReadAll 'Capture any remaining output
		        If Debugging Then
		          Dim ResDbg As String = Res
		          If Left(CmdIn, 4) = "curl" Then ResDbg = Left(ResDbg, 12) 'Shrink curl output
		          Debug("RunCommandDownload: -"+Chr(10)+ResDbg+Chr(10))
		        End If
		        
		        'Delete Temp Script
		        F.Remove
		      End If
		      F = Nil
		      
		    Else 'Linux Command, doesn't need to go to script file to work (it just does)
		      'Run Script
		      Sh.Execute (CmdIn)
		      
		      'Wait For Completion - drain buffer each tick to prevent pipe deadlock
		      While Sh.IsRunning
		        App.DoEvents(20)
		        Res = Res + Sh.ReadAll 'Drain output buffer to prevent pipe deadlock
		      Wend
		      Res = Res + Sh.ReadAll 'Capture any remaining output
		      If Debugging Then
		        Dim ResDbg As String = Res
		        If Left (CmdIn,4) = "curl" Then ResDbg = Left(ResDbg,12) 'Shrink curl output
		        Debug("RunCommandDownload: -"+Chr(10)+ResDbg+Chr(10))
		      End If
		      
		    End If
		    
		    'For Both
		    Return Res
		    'Return Sh.ReadAll
		  End If
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RunCommandResults(CmdIn As String, FoldIn As String = "") As String
		  If Debugging Then 
		    Debug("--- RunCommandResults ---")
		    Debug("Cmd: -"+Chr(10)+ CmdIn)
		    If FoldIn <> "" Then
		      Debug("From Folder: "+FoldIn)
		    End If
		  End If
		  Dim Sh As New Shell
		  Dim Success As Boolean
		  Dim Res As String
		  
		  Sh.TimeOut = -1
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim F As FolderItem
		  Dim ScriptFile As String = Slash(TmpPath)+"LLRunner"+Randomiser.InRange(10000, 20000).ToString+".cmd"
		  If CmdIn <> "" Then
		    
		    If FoldIn <> "" Then Success = ChDirSet(FoldIn)
		    
		    If TargetWindows Then
		      SaveDataToFile(CmdIn, ScriptFile)
		      
		      F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		      If F.Exists Then
		        'Run Script
		        Sh.Execute (F.NativePath)
		        
		        'Wait For Completion
		        While Sh.IsRunning
		          App.DoEvents(20)
		        Wend
		        Res = Sh.ReadAll
		        If Debugging Then
		          'Res = Sh.Result.Trim
		          If Left (CmdIn,4) = "curl" Then Res = Left(Res,12) 'Shrink curl output
		          Debug("RunCommandResults: -"+Chr(10)+Res+Chr(10))
		        End If
		        
		        'Delete Temp Script
		        F.Remove
		      End If
		      F = Nil
		      
		    Else 'Linux Command, doesn't need to go to script file to work (it just does)
		      'Run Script
		      Sh.Execute (CmdIn)
		      
		      'Wait For Completion
		      ' IMPORTANT: Drain the shell output buffer on every DoEvents tick.
		      ' If we only call ReadAll after the loop, verbose commands (e.g. 7z listing
		      ' every file in a large game) fill the OS pipe buffer (~64KB). Once full,
		      ' the child process blocks waiting to write more output. IsRunning stays True
		      ' forever, 0% CPU - a complete silent hang. Draining here keeps the pipe clear.
		      While Sh.IsRunning
		        App.DoEvents(20)
		        Res = Res + Sh.ReadAll 'Drain output buffer to prevent pipe deadlock
		      Wend
		      Res = Res + Sh.ReadAll 'Read any remaining output after process exits
		      If Debugging Then
		        'Res = Sh.Result.Trim
		        If Left (CmdIn,4) = "curl" Then Res = Left(Res,12) 'Shrink curl output
		        Debug("RunCommandResults: -"+Chr(10)+Res+Chr(10))
		      End If
		      
		    End If
		    
		    'For Both
		    'Return Sh.Result
		    'Return Sh.ReadAll
		    Return Res
		  End If
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunRefresh(CmdIn As String, FoldIn As String = "")
		  If Debugging Then 
		    Debug("--- RunCommand ---")
		    Debug("Cmd: -"+Chr(10)+ CmdIn)
		    If FoldIn <> "" Then
		      Debug("From Folder: "+FoldIn)
		    End If
		  End If
		  
		  Dim Sh As New Shell
		  Dim Success As Boolean
		  
		  Sh.TimeOut = -1
		  Sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  
		  Dim F As FolderItem
		  Dim ScriptFile As String = Slash(TmpPath)+"Refresh.sh"
		  ShellFast.Execute("chmod +x "+ ScriptFile)
		  If CmdIn <> "" Then
		    
		    'If FoldIn <> "" Then Success = ChDirSet(FoldIn)
		    
		    SaveDataToFile(CmdIn, ScriptFile)
		    
		    F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		    If F.Exists Then
		      'Run Script
		      Sh.Execute (F.NativePath)
		      
		      'Wait For Completion
		      'While Sh.IsRunning
		      'App.DoEvents(20)
		      'Wend
		    End If
		    F = Nil
		    'If Debugging Then Debug("Results: -"+Chr(10)+Sh.ReadAll.Trim+Chr(10))
		    'Delete Temp Script
		    Deltree ScriptFile
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunRegistry()
		  If Debugging Then Debug("--- Starting Run Registry ---")
		  
		  Dim FileToUse As String
		  Dim ScriptFile As String
		  
		  Dim Shelly As New Shell
		  Shelly.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  Shelly.TimeOut = -1
		  
		  Dim F As FolderItem
		  
		  FileToUse = InstallToPath + ItemLLItem.BuildType+".reg"
		  If Exist(FileToUse) Then 
		    If TargetWindows Then
		      ScriptFile = ExpReg (InstallToPath + ItemLLItem.BuildType+".reg")
		      
		      F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		      
		      Shelly.Execute ("cmd.exe /c", "regedit.exe /s " + Chr(34) + FixPath(F.NativePath) + Chr(34)) 'Trying this way as it seem more compatible
		      While Shelly.IsRunning
		        App.DoEvents(20)
		      WEnd
		    Else
		      ScriptFile = ExpReg (InstallToPath + ItemLLItem.BuildType+".reg")
		      If BuildingCombinedBat Then
		        'Save expanded reg to a unique path so it persists until wine runs at end of regen
		        CombinedWineRegIdx = CombinedWineRegIdx + 1
		        Dim UniqueRegPath As String = TmpPath + "bat_reg_" + CombinedWineRegIdx.ToString + ".reg"
		        SaveDataToFile(LoadDataFromFile(ScriptFile), UniqueRegPath)
		        Dim WineRegPath As String = "z:" + UniqueRegPath.ReplaceAll("/", "\")
		        CombinedWineBat = CombinedWineBat + "regedit /s " + Chr(34) + WineRegPath + Chr(34) + Chr(13) + Chr(10)
		      Else
		        Shelly.Execute("wine regedit.exe /s " + Chr(34) + ScriptFile+ Chr(34))
		        While Shelly.IsRunning
		          App.DoEvents(20)
		        WEnd
		      End If
		    End If
		  Else 'Try the InstallFrom Path just in case (Like with 143 ppGames)
		    FileToUse = InstallFromPath + ItemLLItem.BuildType+".reg"
		    If Exist(FileToUse) Then 
		      If TargetWindows Then
		        ScriptFile = ExpReg (InstallFromPath + ItemLLItem.BuildType+".reg")
		        
		        F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		        
		        Shelly.Execute ("cmd.exe /c", "regedit.exe /s " + Chr(34) + FixPath(F.NativePath) + Chr(34)) 'Trying this way as it seem more compatible
		        While Shelly.IsRunning
		          App.DoEvents(20)
		        WEnd
		      Else
		        ScriptFile = ExpReg (InstallFromPath + ItemLLItem.BuildType+".reg")
		        If BuildingCombinedBat Then
		          'Save expanded reg to a unique path so it persists until wine runs at end of regen
		          CombinedWineRegIdx = CombinedWineRegIdx + 1
		          Dim UniqueRegPath As String = TmpPath + "bat_reg_" + CombinedWineRegIdx.ToString + ".reg"
		          SaveDataToFile(LoadDataFromFile(ScriptFile), UniqueRegPath)
		          Dim WineRegPath As String = "z:" + UniqueRegPath.ReplaceAll("/", "\")
		          CombinedWineBat = CombinedWineBat + "regedit /s " + Chr(34) + WineRegPath + Chr(34) + Chr(13) + Chr(10)
		        Else
		          Shelly.Execute("wine regedit.exe /s " + Chr(34) + ScriptFile+ Chr(34))
		          While Shelly.IsRunning
		            App.DoEvents(20)
		          WEnd
		        End If
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunScripts()
		  If Debugging Then Debug("--- Starting Run Scripts ---")
		  
		  Dim ScriptFile As String
		  
		  Dim Shelly As New Shell
		  Shelly.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  Shelly.TimeOut = -1
		  
		  Dim StillActive As Boolean = True
		  Dim F As FolderItem
		  
		  'Change to App/Games Install To path to run scripts from (NoInstall sets to InstallFrom)
		  If ItemLLItem.BuildType = "ssApp" Then 
		    If ChDirSet(InstallFromPath) = True Then ' Was successful - ssApp path set
		    End If
		  Else
		    If ChDirSet(InstallToPath) = True Then ' Was successful - ppApp/Game path set
		    End If
		  End If
		  
		  If TargetLinux Then
		    #Pragma BreakOnExceptions Off
		    Try
		      F = GetFolderItem(InstallToPath + "LLScript.sh")
		      If F.Exists Then  ' Run Linux Script
		        
		        ScriptFile = ExpScript (InstallToPath + "LLScript.sh")
		        F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		        Shelly.Execute("cd " + Chr(34) + InstallToPath + Chr(34) + " ; bash " + Chr(34) + FixPath(F.NativePath) + Chr(34)) 'Use bash over sh. I think it is better
		        Dim ShBuf As String = ""
		        While Shelly.IsRunning
		          App.DoEvents(20)
		          ShBuf = ShBuf + Shelly.ReadAll 'Drain to prevent pipe deadlock
		        Wend
		        ShBuf = ShBuf + Shelly.ReadAll
		        If Debugging Then Debug("Script Return (.sh): "+ ShBuf)
		      End If
		    Catch
		      If Debugging Then Debug("* Error: "+ InstallToPath + "LLScript.sh - Isn't found or invalid path")
		    End Try
		    #Pragma BreakOnExceptions On
		  End If
		  If  ItemLLItem.BuildType = "ssApp" Then 'Run the Scripts from the InstallFromPath
		    #Pragma BreakOnExceptions Off
		    Try
		      F = GetFolderItem(InstallFromPath + ItemLLItem.BuildType+".cmd")
		      If Exist(InstallFromPath + ItemLLItem.BuildType+".cmd") Then 
		        ScriptFile = ExpScript (InstallFromPath + ItemLLItem.BuildType+".cmd")
		        
		        F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		        If TargetWindows Then
		          Shelly.Execute ("cmd.exe /c",Chr(34)+FixPath(F.NativePath)+Chr(34))
		        Else
		          If BuildingCombinedBat Then
		            'Accumulate into combined bat — wine will be run once at end of regen
		            Dim BatCdPath As String = "z:" + InstallFromPath.ReplaceAll("/", "\")
		            Dim BatScriptContent As String = LoadDataFromFile(ScriptFile)
		            CombinedWineBat = CombinedWineBat + "cd " + Chr(34) + BatCdPath + Chr(34) + Chr(13) + Chr(10)
		            CombinedWineBat = CombinedWineBat + BatScriptContent + Chr(13) + Chr(10)
		          Else
		            Shelly.Execute("cd " + Chr(34) + InstallFromPath + Chr(34) + " ; wine " + Chr(34) + ScriptFile + Chr(34)) ' Use && Here because if path fails, then script will anyway
		          End If
		        End If
		        Dim SsBuf As String = ""
		        If Not BuildingCombinedBat Then
		          While Shelly.IsRunning
		            App.DoEvents(20)
		            SsBuf = SsBuf + Shelly.ReadAll 'Drain to prevent pipe deadlock
		          Wend
		          SsBuf = SsBuf + Shelly.ReadAll
		        End If
		        If Debugging Then Debug("Script Return (ssApp.cmd): "+ SsBuf)
		      End If
		    Catch
		      If Debugging Then Debug("* Error: "+ InstallToPath + "ssApp.cmd - Isn't found or invalid path")
		    End Try
		    #Pragma BreakOnExceptions On
		  Else ' ppApp or ppGame, runs script from the InstallTo Folder
		    If Debugging Then Debug("Checking for ppApp/Game Script to Run: " + InstallToPath + ItemLLItem.BuildType+".cmd")
		    #Pragma BreakOnExceptions Off
		    Try
		      F = GetFolderItem(InstallToPath + ItemLLItem.BuildType+".cmd")
		      If Exist(InstallToPath + ItemLLItem.BuildType+".cmd") Then 
		        ScriptFile = ExpScript (InstallToPath + ItemLLItem.BuildType+".cmd")
		        If Debugging Then Debug("Running: "+ ScriptFile)
		        F = GetFolderItem(ScriptFile, FolderItem.PathTypeNative)
		        If TargetWindows Then
		          Shelly.Execute ("cmd.exe /c",Chr(34)+FixPath(F.NativePath)+Chr(34))
		        Else
		          If BuildingCombinedBat Then
		            'Accumulate into combined bat — wine will be run once at end of regen
		            Dim BatCdPath As String = "z:" + InstallToPath.ReplaceAll("/", "\")
		            Dim BatScriptContent As String = LoadDataFromFile(ScriptFile)
		            CombinedWineBat = CombinedWineBat + "cd " + Chr(34) + BatCdPath + Chr(34) + Chr(13) + Chr(10)
		            CombinedWineBat = CombinedWineBat + BatScriptContent + Chr(13) + Chr(10)
		          Else
		            Shelly.Execute("cd " + Chr(34) + InstallToPath + Chr(34) + " ; wine " + Chr(34) + ScriptFile + Chr(34))
		          End If
		        End If
		        Dim PpBuf As String = ""
		        If Not BuildingCombinedBat Then
		          While Shelly.IsRunning
		            App.DoEvents(20)
		            PpBuf = PpBuf + Shelly.ReadAll 'Drain to prevent pipe deadlock
		          Wend
		          PpBuf = PpBuf + Shelly.ReadAll
		        End If
		        If Debugging Then Debug("Script Return ("+ItemLLItem.BuildType+".cmd): "+ PpBuf)
		      End If
		    Catch
		      If Debugging Then Debug("* Error: "+ InstallToPath + ItemLLItem.BuildType+".cmd - Isn't found or invalid path")
		    End Try
		    #Pragma BreakOnExceptions On
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunSudo(Command As String)
		  If Debugging Then Debug("--- Starting Run Sudo Command ---")
		  
		  Dim Sh As New Shell
		  
		  Sh.ExecuteMode = Shell.ExecuteModes.Synchronous
		  Sh.TimeOut = -1
		  
		  Dim ScriptFile As String
		  
		  If Not TargetWindows Then
		    
		    if SudoShellLoop.IsRunning = False Then 'Can only chekc if Local script is running, so will check sudo is enabled each time
		      EnableSudoScript 'if SudoShellLoop.IsRunning = True Then
		    End If
		    
		    'if SudoShellLoop.IsRunning = True Then ' Check still running
		    'SudoEnabled = True
		    'Else
		    'SudoEnabled = False
		    'End If
		    
		    If SudoEnabled = True Then ' Only bother if the script is running, else ignore it
		      
		      SaveDataToFile (Command, Slash(TmpPath)+"Expanded_Script.sh")
		      Sh.Execute ("chmod 775 "+Chr(34)+Slash(TmpPath)+"Expanded_Script.sh"+Chr(34)) 'Change Read/Write/Execute to Output script
		      
		      Sh.Execute("mv -f "+Slash(TmpPath)+"Expanded_Script.sh "+BaseDir+"/LLScript_Sudo.sh") 'Do it the solid way, not with Xojo
		      
		      While Exist (BaseDir+"/LLScript_Sudo.sh") 'This script gets removed after it completes, do not continue the processing until this happens
		        App.DoEvents(20)
		      Wend
		      
		    End If
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunSudoScripts()
		  If Debugging Then Debug("--- Starting Run Sudo Scripts ---")
		  
		  Dim Sh As New Shell
		  
		  Sh.ExecuteMode = Shell.ExecuteModes.Synchronous
		  Sh.TimeOut = -1
		  
		  Dim ScriptFile As String
		  
		  '*** Make sure to add CD to the top of the script so it does it from the correct folder (I have since swapped back to doing a single script at a time so I can keep progress better, so not needed).
		  'If the file exist then it copies to Temp and runs, else it skips over it
		  
		  'Trying below to see if that is enough - No seems to need to be put into the script so that the calling script shifts to the right path as it opens a new bash, easy fixed :)
		  'Change to App/Games Install To path to run scripts from (NoInstall sets to InstallFrom)
		  'MsgBox "Path: "+InstallToPath
		  'If ChDirSet(InstallToPath) = True Then ' Was successful
		  'End If
		  
		  If Not TargetWindows Then
		    If Exist(InstallToPath+"LLScript_Sudo.sh") Then
		      
		      'Bring it back if it shuts down
		      if SudoShellLoop.IsRunning = False Then 'Can only check local session, will do handshake each time called
		        EnableSudoScript 'if SudoShellLoop.IsRunning = True Then
		      End If
		      
		      'if SudoShellLoop.IsRunning = True Then ' Check still running - Not needed as Sudo Check above does this
		      'SudoEnabled = True
		      'Else
		      'SudoEnabled = False
		      'End If
		      If SudoEnabled = True Then ' Only bother if the script is running, else ignore it
		        
		        ScriptFile = ExpScript (InstallToPath + "LLScript_Sudo.sh", True)
		        
		        Sh.Execute("mv -f "+BaseDir+"/Expanded_Script.sh "+BaseDir+"/LLScript_Sudo.sh") 'Do it the solid way, not with Xojo
		        
		        While Exist (BaseDir+"/LLScript_Sudo.sh") 'This script gets removed after it completes, do not continue the processing until this happens
		          App.DoEvents(20)
		        Wend
		        
		        'Update Linux .desktop Links Database (usually occurs after sudo scripts as that installs system wide .desktop files)
		        If TargetLinux Then RunSudo ("update-desktop-database /usr/share/applications")
		        
		      End If
		    End If
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunWait(EXEName As String, PathIn As String = "", ArgsIn As String = "")
		  If Debugging Then Debug("---------- RunWait: "+ PathIn+">"+EXEName+" | "+ArgsIn+" ----------")
		  
		  Dim theShell As New Shell
		  theShell.Mode = 1 'Run and continue code
		  theShell.TimeOut = -1 'Give it All the time it needs
		  
		  If PathIn<>"" Then
		    If ChDirSet(PathIn) = True Then ' Was successful
		    End If
		  End If
		  
		  Running = True
		  theShell.Execute (EXEName)
		  
		  While theShell.IsRunning
		    App.DoEvents(20)
		  Wend
		  If Debugging Then Debug(theShell.ReadAll) ' Debug Print all of the Run Results
		  
		  If Debugging Then Debug("---------- End of RunWait ----------") ' Debug Print all of the Run Results
		  
		  Running = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveDataToFile(Data As String, FileIn As String)
		  If TargetWindows Then
		    FileIn = FileIn.ReplaceAll("/","\")
		  Else
		    FileIn = FileIn.ReplaceAll("\","/")
		  End If
		  
		  'MsgBox "HERE" +FileIn +" = " +Data
		  
		  If Debugging Then Debug("- Save Data To File: "+ FileIn)
		  
		  Dim F As FolderItem
		  Dim T As TextOutputStream
		  
		  #Pragma BreakOnExceptions Off
		  
		  Try
		    F = GetFolderItem(FileIn, FolderItem.PathTypeNative)
		    
		    If F <> Nil Then
		      If F.IsWriteable Then
		        If F.Exists Then F.Remove
		        T = TextOutputStream.Create(F)
		        T.Write(Data)
		        T.Close
		        If TargetLinux Then ChMod(FileIn, "664") 'Secure: group-writable for lastos-users members, not world-writable
		      End If
		    End If
		  Catch
		    If Debugging Then Debug("* Error - Saving Data To File: "+ FileIn)
		  End Try
		  
		  #Pragma BreakOnExceptions On
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveDesktopEnvironment()
		  If TargetWindows Then Return 'Not needed on Windows
		  
		  If Debugging Then Debug("--- Saving Desktop Environment Info ---")
		  
		  Dim EnvData As String
		  Dim Sh As New Shell
		  
		  Sh.ExecuteMode = Shell.ExecuteModes.Synchronous
		  Sh.TimeOut = 5000
		  
		  ' Capture all relevant desktop environment variables
		  Sh.Execute("mkdir -p "+Chr(34)+Slash(HomePath)+"zLastOSRepository"+Chr(34)+" && printenv | grep -E '^XDG_SESSION_DESKTOP=|^XDG_CURRENT_DESKTOP=|^DESKTOP_SESSION=|^GDMSESSION=' > "+Chr(34)+Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini"+Chr(34))
		  
		  ' Fallback: if file is empty or doesn't exist, try to get at least one variable
		  If Not Exist(Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini") Or LoadDataFromFile(Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini").Trim = "" Then
		    ' Build environment file with explicit variable expansion
		    Sh.Execute("echo ""XDG_SESSION_DESKTOP=$XDG_SESSION_DESKTOP"" > "+Chr(34)+Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini"+Chr(34))
		    Sh.Execute("echo ""XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP"" >> "+Chr(34)+Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini"+Chr(34))
		    Sh.Execute("echo ""DESKTOP_SESSION=$DESKTOP_SESSION"" >> "+Chr(34)+Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini"+Chr(34))
		    Sh.Execute("echo ""GDMSESSION=$GDMSESSION"" >> "+Chr(34)+Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini"+Chr(34))
		  End If
		  
		  'If Debugging Then
		  'If Exist(Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini") Then
		  'EnvData = LoadDataFromFile(Slash(HomePath)+"zLastOSRepository/LLDesktopEnv.ini")
		  'Debug("Saved Desktop Environment: " + Chr(10) + EnvData)
		  'Else
		  'Debug("Warning: Could not save desktop environment")
		  'End If
		  'End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SaveDialog(FileTyp As FileType, Title As String, InitialPath As String, DefaultName As String) As String
		  Dim F, Init As FolderItem
		  Dim dlg As SaveAsDialog
		  
		  Init = GetFolderItem(InitialPath, FolderItem.PathTypeNative)
		  
		  dlg = New SaveAsDialog
		  dlg.InitialDirectory=Init
		  dlg.Title = Title
		  dlg.SuggestedFileName = DefaultName
		  dlg.Filter = FileTyp
		  F = dlg.ShowModal()
		  
		  If F = Nil Then
		    Return ""
		  Else
		    If Lowercase(Right(F.NativePath,3)) = Lowercase(FileTyp.Extensions) Then Return F.NativePath
		    Return F.NativePath + "." + Lowercase(FileTyp.Extensions)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SaveLLFile(SaveToPath As String) As Boolean
		  If Debugging Then Debug("--- Save LLFile ---")
		  If Debugging Then Debug("Save To: "+ SaveToPath)
		  
		  If ItemLLItem.TitleName = "" Or ItemLLItem.BuildType = "" Then
		    MsgBox "Title or BuildType not set, Failed!"
		    Return False
		  End If
		  
		  If Not Exist(SaveToPath) Then
		    MsgBox "Path to Save to Not Found: " + SaveToPath
		  End If
		  
		  Dim DateBuilt As String
		  Var currentDate As DateTime = DateTime.Now
		  Dim I As Integer
		  Dim DataOut As String
		  Dim FlagsOut As String
		  Dim LLFileOut, OutFile As String
		  Dim BType As String
		  Dim PicInFile As String
		  Dim PicOutFile As String
		  Dim Suc As Boolean
		  Dim CatOut As String
		  
		  Select Case ItemLLItem.BuildType
		  Case "ppGame"
		    DataOut = "[SetupS]" + Chr(10)
		    BType = "SS"
		    OutFile = ItemLLItem.BuildType+".ppg"
		  Case "ssApp"
		    DataOut = "[SetupS]" + Chr(10)
		    BType = "SS"
		    OutFile = ItemLLItem.BuildType+".app"
		  Case  "ppApp"
		    DataOut = "[SetupS]" + Chr(10)
		    BType = "SS"
		    OutFile = ItemLLItem.BuildType+".app"
		  Case "LLApp"
		    DataOut = "[LLFile]" + Chr(10)
		    BType = "LL"
		    OutFile = ItemLLItem.BuildType+".lla"
		  Case "LLGame"
		    DataOut = "[LLFile]" + Chr(10)
		    BType = "LL"
		    OutFile = ItemLLItem.BuildType+".llg"
		  End Select
		  
		  'Copy Images from wherever they are set to the Build Path
		  PicInFile = FixPath(NewFileScreenshot) 'FixPath(Slash(SaveToPath)+ItemLLItem.BuildType+".jpg")
		  PicOutFile = FixPath(Slash(SaveToPath)+ItemLLItem.BuildType+".jpg")
		  If PicInFile <> PicOutFile Then
		    Suc = Copy(PicInFile,PicOutFile)
		  End If
		  
		  PicInFile = FixPath(NewFileFader) 'FixPath(Slash(SaveToPath)+ItemLLItem.BuildType+".png")
		  PicOutFile = FixPath(Slash(SaveToPath)+ItemLLItem.BuildType+".png")
		  If PicInFile <> PicOutFile Then
		    Suc = Copy(PicInFile,PicOutFile)
		  End If
		  
		  PicInFile = FixPath(NewFileIcon) 'FixPath(Slash(SaveToPath)+ItemLLItem.BuildType+".ico")
		  If Right(NewFileIcon,4) = ".svg" Then
		    PicOutFile = FixPath(Slash(SaveToPath)+ItemLLItem.BuildType+".svg")
		  Else
		    PicOutFile = FixPath(Slash(SaveToPath)+ItemLLItem.BuildType+".ico")
		  End If
		  If PicInFile <> PicOutFile Then
		    Suc = Copy(PicInFile,PicOutFile)
		  End If
		  
		  
		  'Prepare LLFile output
		  LLFileOut = FixPath(Slash(SaveToPath)+OutFile)
		  
		  'All Files General
		  DataOut = DataOut + "Title="+ ItemLLItem.TitleName+Chr(10)
		  If ItemLLItem.Version <> "" Then DataOut = DataOut + "Version="+ ItemLLItem.Version+Chr(10)
		  If ItemLLItem.Descriptions <> "" Then
		    ItemLLItem.Descriptions = FixEOL(ItemLLItem.Descriptions)
		    DataOut = DataOut + "Description=" + FixEOL(ItemLLItem.Descriptions)+Chr(10)
		  End If
		  If ItemLLItem.URL <> "" Then DataOut = DataOut + "URL=" + ItemLLItem.URL.ReplaceAll(Chr(13),"|")+Chr(10)
		  
		  If ItemLLItem.Categories <> "" And Len(ItemLLItem.Categories) >= 2 Then 
		    If BType = "LL" Then 'Linux Items only
		      If Right(ItemLLItem.Categories, 1) <> ";" Then ItemLLItem.Categories = ItemLLItem.Categories +";" 'Make Sure it's got the SemiColon
		    Else'Not Linux Item
		      If Right(ItemLLItem.Categories, 1) = ";" Then ItemLLItem.Categories = Left(ItemLLItem.Categories, Len(ItemLLItem.Categories)-1) 'Make Sure it's NOT  got the SemiColon
		      If Right(ItemLLItem.Categories, 1) = "|" Then ItemLLItem.Categories = Left(ItemLLItem.Categories, Len(ItemLLItem.Categories)-1) 'Make Sure it's NOT  got the Trailing One
		    End If
		  End If
		  
		  If BType = "SS" Then
		    CatOut = ItemLLItem.Categories
		    If Left(ItemLLItem.Categories, 1) =";" Or Left(ItemLLItem.Categories, 1) ="|" Then CatOut = Left(CatOut, Len(CatOut)-1)
		    CatOut = CatOut.ReplaceAll(";", "|").Trim
		    
		    If CatOut <> "" Then DataOut = DataOut + "Category=" + CatOut+Chr(10) 'SetupS uses Pipe not colon
		    DataOut = DataOut + "BuildType=" + ItemLLItem.BuildType+Chr(10)
		    DataOut = DataOut +"App-File Version=v9.24.05.22.0"+Chr(10) 'Also Requires these
		    DataOut = DataOut +"App-File Style=2 (INI)"+Chr(10) 'Also Requires these
		  Else
		    If ItemLLItem.Categories <> "" Then DataOut = DataOut + "Category=" + ItemLLItem.Categories+Chr(10)
		    DataOut = DataOut + "BuildType=" + ItemLLItem.BuildType+Chr(10)
		  End If
		  If ItemLLItem.PathApp <> "" Then DataOut = DataOut + "AppPath=" + CompPath(ItemLLItem.PathApp, True)+Chr(10)
		  If ItemLLItem.StartMenuSourcePath <> "" Then DataOut = DataOut + "StartMenuSourcePath=" + ItemLLItem.StartMenuSourcePath+Chr(10)
		  
		  If ItemLLItem.Catalog <> "" And Len(ItemLLItem.Catalog) >= 2 Then
		    'If Right(ItemLLItem.Catalog, 1) <> ";" Then ItemLLItem.Catalog = ItemLLItem.Catalog +";" 'Make Sure it's got the SemiColon
		    
		    If BType = "LL" Then 'Linux Items only
		      If Right(ItemLLItem.Catalog, 1) <> ";" Then ItemLLItem.Catalog = ItemLLItem.Catalog +";" 'Make Sure it's got the SemiColon
		    Else'Not Linux Item
		      ItemLLItem.Catalog = ItemLLItem.Catalog.ReplaceAll(";","|").Trim 'Use Windows Separators
		      If Right(ItemLLItem.Catalog, 1) = "|" Then ItemLLItem.Catalog = Left(ItemLLItem.Catalog, Len(ItemLLItem.Catalog)-1).Trim 'Make Sure it's NOT  got the Trailing One
		    End If
		    
		  End If
		  
		  If ItemLLItem.Catalog <> "" Then DataOut = DataOut + "Catalog="+ ItemLLItem.Catalog+Chr(10)
		  If ItemLLItem.StartMenuLegacyPrimary <> "" Then DataOut = DataOut + "StartMenuLegacyPrimary=" + ItemLLItem.StartMenuLegacyPrimary+Chr(10)
		  If ItemLLItem.StartMenuLegacySecondary <> "" Then DataOut = DataOut + "StartMenuLegacySecondary=" + ItemLLItem.StartMenuLegacySecondary+Chr(10)
		  If ItemLLItem.ShortCutNamesKeep <> "" Then DataOut = DataOut + "ShortCutNamesKeep=" + ItemLLItem.ShortCutNamesKeep.ReplaceAll(";","|")+Chr(10)
		  If ItemLLItem.Priority.ToString <> "" Then
		    DataOut = DataOut + "Priority=" + ItemLLItem.Priority.ToString+Chr(10)
		  Else
		    'DataOut = DataOut + "Priority=5"+Chr(10) 'Leave Data empty, sets itself to 5 on loading anyway, so no need to make files bigger
		  End If
		  If ItemLLItem.DECompatible <> "" Then
		    DataOut = DataOut + "DECompatible=" + ItemLLItem.DECompatible+Chr(10)
		  Else
		    'DataOut = DataOut + "DECompatible=All"+Chr(10) 'Leave data empty so can detect ones that need setting
		  End If
		  If ItemLLItem.PMCompatible <> "" Then
		    DataOut = DataOut + "PMCompatible=" + ItemLLItem.PMCompatible+Chr(10)
		  Else
		    'DataOut = DataOut + "PMCompatible=All"+Chr(10) 'Leave data empty so can detect ones that need setting
		  End If
		  If ItemLLItem.ArchCompatible <> "" Then
		    DataOut = DataOut + "ArchCompatible=" + ItemLLItem.ArchCompatible+Chr(10)
		  Else
		    'DataOut = DataOut + "ArchCompatible=x86 + x64"+Chr(10) 'Just leave it blank, so that if it's an ARM app it'll work for that too
		  End If
		  If ItemLLItem.Assembly <> "" Then DataOut = DataOut + "Assembly=" + FixEOL(ItemLLItem.Assembly)+Chr(10)
		  If ItemLLItem.Flags <> "" Then DataOut = DataOut + "Flags=" + ItemLLItem.Flags+Chr(10)
		  If ItemLLItem.Arch <> "" Then DataOut = DataOut + "Architecture=" + ItemLLItem.Arch+Chr(10) 'This will need to convert x86, x64, arm to numbered, 1 = x86, 2 = x64, will need to check the rest to make it match
		  
		  'Meta Here
		  DataOut = DataOut + "[Meta]" + Chr(10)
		  If ItemLLItem.InstallSize <> 0 Then DataOut = DataOut + "InstalledSize=" + ItemLLItem.InstallSize.ToString+Chr(10)
		  If ItemLLItem.Tags <> "" Then DataOut = DataOut + "Tags=" + ItemLLItem.Tags+Chr(10)
		  If ItemLLItem.Publisher <> "" Then DataOut = DataOut + "Publisher=" + ItemLLItem.Publisher+Chr(10)
		  If ItemLLItem.Language <> "" Then DataOut = DataOut + "Language=" + ItemLLItem.Language+Chr(10)
		  If ItemLLItem.Builder <> "" Then DataOut = DataOut + "Releaser=" + ItemLLItem.Builder+Chr(10)
		  If ItemLLItem.Rating <> 0 Then DataOut = DataOut + "Rating=" + ItemLLItem.Rating.ToString+Chr(10)
		  If ItemLLItem.Players <> 0 Then DataOut = DataOut + "Players=" + ItemLLItem.Players.ToString+Chr(10)
		  
		  
		  'Make Release Date the Built date so it means something:
		  DateBuilt = currentDate.Year.ToString+"-"+Right("0" + currentDate.Month.ToString, 2)+"-"+Right("0" + currentDate.Day.ToString, 2)
		  If DateBuilt <> "" Then ItemLLItem.ReleaseDate = DateBuilt
		  
		  If ItemLLItem.ReleaseDate <> "" Then DataOut = DataOut + "ReleaseDate=" + ItemLLItem.ReleaseDate+Chr(10)
		  If BType = "SS" Then
		    If ItemLLItem.License.ToString <> "" Then DataOut = DataOut + "LicenseType=" + ItemLLItem.License.ToString+Chr(10) 'SetupS needs LicenseType instead
		  Else
		    If ItemLLItem.License.ToString <> "" Then DataOut = DataOut + "License=" + ItemLLItem.License.ToString+Chr(10)
		  End If
		  If ItemLLItem.ReleaseVersion <> "" Then DataOut = DataOut + "ReleaseVersion=" + ItemLLItem.ReleaseVersion+Chr(10)
		  
		  'Shortcuts Here
		  If BType = "SS" Then
		    If LnkCount >= 1 Then
		      For I = 1 To LnkCount
		        If ItemLnk(I).Title = "" Then Continue 'Dud item, continue looping to next item
		        
		        If ItemLnk(I).LinuxLink Then
		          'Write as Linux .desktop section inside the SS file
		          DataOut = DataOut + "["+ItemLnk(I).Title+".desktop]"+Chr(10)
		          If ItemLnk(I).Link.TargetPath <> "" Then DataOut = DataOut + "Target="+ItemLnk(I).Link.TargetPath+Chr(10)
		          If ItemLnk(I).Link.Arguments <> "" Then DataOut = DataOut + "Args="+ItemLnk(I).Link.Arguments+Chr(10)
		          If ItemLnk(I).Link.WorkingDirectory <> "" Then DataOut = DataOut + "Path="+ItemLnk(I).Link.WorkingDirectory+Chr(10)
		          If ItemLnk(I).Link.IconLocation <> "" Then DataOut = DataOut + "Icon="+ItemLnk(I).Link.IconLocation+Chr(10)
		          If ItemLnk(I).Associations <> "" Then DataOut = DataOut + "Extensions="+ItemLnk(I).Associations+Chr(10)
		          If ItemLnk(I).Flags <> "" Then DataOut = DataOut + "Flags="+ItemLnk(I).Flags+Chr(10)
		          If ItemLnk(I).Link.Description <> "" Then DataOut = DataOut + "Comment="+FixEOL(ItemLnk(I).Link.Description)+Chr(10)
		          If ItemLnk(I).Description <> "" Then DataOut = DataOut + "Description="+FixEOL(ItemLnk(I).Description)+Chr(10)
		          DataOut = DataOut + "Terminal="+ItemLnk(I).Terminal.ToString+Chr(10)
		          CatOut = ItemLnk(I).Categories
		          If CatOut.ReplaceAll(";","").ReplaceAll(" ","").Trim = ItemLLItem.Catalog.ReplaceAll(";","").ReplaceAll(" ","").Trim Then CatOut = ""
		          If CatOut <> "" Then
		            CatOut = CatOut.ReplaceAll(";","|").Trim
		            If Right(CatOut, 1) = "|" Then CatOut = Left(CatOut, Len(CatOut)-1).Trim
		            If CatOut.Trim <> ItemLLItem.Catalog.Trim Then DataOut = DataOut + "Categories="+CatOut+Chr(10)
		          End If
		          FlagsOut = ""
		          If ItemLnk(I).Desktop = True Then  FlagsOut = FlagsOut + "desktop "
		          If ItemLnk(I).Panel = True Then  FlagsOut = FlagsOut + "panel "
		          If ItemLnk(I).Favorite = True Then  FlagsOut = FlagsOut + "favorite "
		          If ItemLnk(I).LnkSendTo = True Then  FlagsOut = FlagsOut + "sendto "
		          FlagsOut = FlagsOut.Trim
		          If FlagsOut <> "" Then DataOut = DataOut + "ShowOn="+FlagsOut+Chr(10)
		          If ItemLnk(I).LnkDECompatible <> "" Then DataOut = DataOut + "LnkDECompatible="+ItemLnk(I).LnkDECompatible+Chr(10)
		          If ItemLnk(I).LnkPMCompatible <> "" Then DataOut = DataOut + "LnkPMCompatible="+ItemLnk(I).LnkPMCompatible+Chr(10)
		          If ItemLnk(I).LnkArchCompatible <> "" Then DataOut = DataOut + "LnkArchCompatible="+ItemLnk(I).LnkArchCompatible+Chr(10)
		        Else
		          'Write as Windows .lnk section (original behaviour)
		          DataOut = DataOut + "["+ItemLnk(I).Title+".lnk]"+Chr(10)
		          If ItemLnk(I).Link.TargetPath <> "" Then DataOut = DataOut + "Target="+ItemLnk(I).Link.TargetPath+Chr(10)
		          If ItemLnk(I).Link.Arguments <> "" Then DataOut = DataOut + "Args="+ItemLnk(I).Link.Arguments+Chr(10)
		          If ItemLnk(I).Link.WorkingDirectory <> "" Then DataOut = DataOut + "Path="+ItemLnk(I).Link.WorkingDirectory+Chr(10)
		          If ItemLnk(I).Link.IconLocation <> "" Then DataOut = DataOut + "Icon="+ItemLnk(I).Link.IconLocation+Chr(10)
		          If ItemLnk(I).Associations <> "" Then DataOut = DataOut + "Extensions="+ItemLnk(I).Associations+Chr(10)
		          If ItemLnk(I).Flags <> "" Then DataOut = DataOut + "Flags="+ItemLnk(I).Flags+Chr(10)
		          'Glenn 26 - Fix EOL for Descriptions and Comments
		          If ItemLnk(I).Link.Description <> "" Then DataOut = DataOut + "Comment="+FixEOL(ItemLnk(I).Link.Description)+Chr(10)
		          If ItemLnk(I).Description <> "" Then DataOut = DataOut + "Description="+FixEOL(ItemLnk(I).Description)+Chr(10)
		          CatOut = ItemLnk(I).Categories
		          If CatOut.ReplaceAll(";","").ReplaceAll(" ","").Trim = ItemLLItem.Catalog.ReplaceAll(";","").ReplaceAll(" ","").Trim Then CatOut = "" 'Don't add if the same as the main items category
		          If CatOut<> "" Then
		            CatOut = CatOut.ReplaceAll(";","|").Trim 'Use Windows Separators
		            If Right(CatOut, 1) = "|" Then CatOut = Left(CatOut, Len(CatOut)-1).Trim ' Remove Trailing | in windows items
		            if CatOut.Trim <> ItemLLItem.Catalog.Trim Then DataOut = DataOut + "Categories="+CatOut+Chr(10) ' Only add if Different
		          End If
		          ''''If ItemLnk(I).Categories <> "" Then DataOut = DataOut + "Categories="+ItemLnk(I).Categories+Chr(10) 'Old Method
		          'Do ShowOn
		          FlagsOut = ""
		          If ItemLnk(I).Desktop = True Then  FlagsOut = FlagsOut + "desktop "
		          If ItemLnk(I).Panel = True Then  FlagsOut = FlagsOut + "panel "
		          If ItemLnk(I).Favorite = True Then  FlagsOut = FlagsOut + "favorite "
		          If ItemLnk(I).LnkSendTo = True Then  FlagsOut = FlagsOut + "sendto "
		          FlagsOut = FlagsOut.Trim
		          If FlagsOut <> "" Then DataOut = DataOut + "ShowOn="+FlagsOut+Chr(10)
		          If ItemLnk(I).LnkDECompatible <> "" Then DataOut = DataOut + "LnkDECompatible="+ItemLnk(I).LnkDECompatible+Chr(10)
		          If ItemLnk(I).LnkPMCompatible <> "" Then DataOut = DataOut + "LnkPMCompatible="+ItemLnk(I).LnkPMCompatible+Chr(10)
		          If ItemLnk(I).LnkArchCompatible <> "" Then DataOut = DataOut + "LnkArchCompatible="+ItemLnk(I).LnkArchCompatible+Chr(10)
		        End If
		        
		      Next
		    End If
		    
		  Else ' Linux Shortcut
		    If LnkCount >= 1 Then
		      For I = 1 To LnkCount
		        If ItemLnk(I).Title = "" Then Continue 'Dud item, continue looping to next item
		        DataOut = DataOut + "["+ItemLnk(I).Title+".desktop]"+Chr(10)
		        If ItemLnk(I).Link.TargetPath <> "" Then DataOut = DataOut + "Exec="+ItemLnk(I).Link.TargetPath+Chr(10)
		        'DataOut = DataOut + "Description=" + FixEOL(ItemLLItem.Descriptions))+Chr(10)
		        If ItemLnk(I).Link.Description <> "" Then DataOut = DataOut + "Comment="+FixEOL(ItemLnk(I).Link.Description)+Chr(10)
		        If ItemLnk(I).Link.WorkingDirectory <> "" Then DataOut = DataOut + "Path="+ItemLnk(I).Link.WorkingDirectory+Chr(10)
		        If ItemLnk(I).Link.IconLocation <> "" Then DataOut = DataOut + "Icon="+ItemLnk(I).Link.IconLocation+Chr(10)
		        If ItemLnk(I).Categories <> "" Then
		          
		          CatOut = ItemLnk(I).Categories
		          If CatOut.ReplaceAll(";","").ReplaceAll(" ","").Trim = ItemLLItem.Catalog.ReplaceAll(";","").ReplaceAll(" ","").Trim Then CatOut = "" 'Don't add if the same as the main items category
		          If CatOut<> "" Then
		            if CatOut.Trim <> ItemLLItem.Catalog.Trim Then DataOut = DataOut + "Categories="+CatOut+Chr(10) ' Only add if Different
		          End If
		        End If
		        If ItemLnk(I).Associations <> "" Then DataOut = DataOut + "Extensions="+ItemLnk(I).Associations+Chr(10)
		        If ItemLnk(I).Flags <> "" Then DataOut = DataOut + "Flags="+ItemLnk(I).Flags+Chr(10)
		        If ItemLnk(I).Description <> "" Then DataOut = DataOut + "Description="+FixEOL(ItemLnk(I).Description)+Chr(10)
		        DataOut = DataOut + "Terminal="+ItemLnk(I).Terminal.ToString+Chr(10)
		        
		        'Do ShowOn
		        FlagsOut = ""
		        If ItemLnk(I).Desktop = True Then  FlagsOut = FlagsOut + "desktop "
		        If ItemLnk(I).Panel = True Then  FlagsOut = FlagsOut + "panel "
		        If ItemLnk(I).Favorite = True Then  FlagsOut = FlagsOut + "favorite "
		        If ItemLnk(I).LnkSendTo = True Then  FlagsOut = FlagsOut + "sendto "
		        FlagsOut = FlagsOut.Trim
		        If FlagsOut <> "" Then DataOut = DataOut + "ShowOn="+FlagsOut+Chr(10)
		        
		        If ItemLnk(I).LnkDECompatible <> "" Then DataOut = DataOut + "LnkDECompatible="+ItemLnk(I).LnkDECompatible+Chr(10)
		        If ItemLnk(I).LnkPMCompatible <> "" Then DataOut = DataOut + "LnkPMCompatible="+ItemLnk(I).LnkPMCompatible+Chr(10)
		        If ItemLnk(I).LnkArchCompatible <> "" Then DataOut = DataOut + "LnkArchCompatible="+ItemLnk(I).LnkArchCompatible+Chr(10)
		        
		      Next
		    End If
		  End If
		  
		  If DataOut <> "" Then
		    SaveDataToFile(DataOut, LLFileOut) 'This should work, I may need to check here or somewhere (Editor) if I need to update a pre compressed item using the temp paths
		    Return True ' Success
		  Else
		    Return False 'Failed
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Slash(Inn As String) As String
		  Inn = Inn.Trim
		  If Right(Inn,1) = "\" Then Inn = Left(Inn,Len(Inn)-1) 'Remove Slash and put back below, so Windows ones work
		  If Right(Inn,1)<>"/" Then Inn = Inn + "/"
		  
		  Inn = Inn.ReplaceAll("\","/")
		  Inn = Inn.ReplaceAll("//","/")'Remove Doubles
		  
		  Return Inn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UniversalName(InFile As String) As String
		  Return InFile.Lowercase.ReplaceAll(" ","")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasLinuxDesktopLink() As Boolean
		  'Returns True if any link in ItemLnk() has LinuxLink = True (i.e. a .desktop link inside a SS file)
		  Dim J As Integer
		  For J = 1 To LnkCount
		    If ItemLnk(J).LinuxLink Then Return True
		  Next
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WritableLocation(F As FolderItem) As Boolean
		  #Pragma BreakOnExceptions Off
		  Try
		    Dim F2 As FolderItem
		    Dim TOut As TextOutputStream
		    F2 = GetFolderItem (F.NativePath +".Test", FolderItem.PathTypeNative)
		    TOut = TextOutputStream.Create(F2)
		    TOut.Close
		    F2.Delete
		    #Pragma BreakOnExceptions On
		    Return True ' Yep Writable
		  Catch
		  End Try
		  #Pragma BreakOnExceptions On
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XCopy(InPath As String, OutPath As String)
		  InPath = InPath.ReplaceAll("/","\")
		  OutPath = OutPath.ReplaceAll("/","\")
		  
		  If Debugging Then Debug("XCopy: "+ InPath +" To " + OutPath)
		  
		  ' /O <- Removed /O as it can give access denied errors
		  RunCommand("xcopy.exe /E /C /I /H /Q /R /J /Y " +Chr(34) + InPath +Chr(34) +" "+Chr(34)+ OutPath +Chr(34)) ' Don't use linux paths here, xcopy may be fussy
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XCopyFile(InPath As String, OutPath As String)
		  InPath = InPath.ReplaceAll("/","\")
		  OutPath = OutPath.ReplaceAll("/","\")
		  
		  If Debugging Then Debug("XCopy: "+ InPath +" To " + OutPath)
		  ' /O <- Removed /O as it can cause AccessDenied Errors
		  
		  RunCommand("xcopy.exe /C /I /H /Q /R /J /Y " +Chr(34) + InPath +Chr(34) +" "+Chr(34)+OutPath+Chr(34))
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AdminEnabled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		AppPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		AssignedColors(6) As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		AutoBuild As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		AvailableWidth As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		BaseDir As String
	#tag EndProperty

	#tag Property, Flags = &h0
		BoldDescription As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		BoldList As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		BoldTitle As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		BuildingCombinedBat As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CachedUserName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CancelDownloading As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CheckingForDatabases As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CheckingForUpdates As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CleanTempFolders As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CleanUpIsle2 As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ColBG As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColCategory As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColDescription As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColDual As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColFG As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColHiLite As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColList As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColLLApp As Color = &C80B0FF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColLLGame As Color = &Cff55ff
	#tag EndProperty

	#tag Property, Flags = &h0
		ColLoading As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColMeta As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColppApp As Color = &CFFFF50
	#tag EndProperty

	#tag Property, Flags = &h0
		ColppGame As Color = &CAAFF40
	#tag EndProperty

	#tag Property, Flags = &h0
		ColSelect As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColssApp As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColStats As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		ColTitle As Color = &CFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h0
		CombinedWineBat As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CombinedWineRegIdx As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		CommandLineFile As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CommandReturned As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ContinueSelf As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentDay As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentFader As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentItemDBID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentItemID As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentScanPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentssAppFile As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentTime As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		DebugFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		DebugFileName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		DebugFileOk As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Debugging As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		DebugOutput As TextOutputStream
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultFader As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultLoadingWallpaper As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultMainWallpaper As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultStartButton As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultStartButtonHover As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		DelJobsList() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		EditingItem As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		EditingLnk As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		EditorOnly As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		FavCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Favorites(2048) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstItem As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstRun As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		FlatpakAsUser As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		FontDescription As String = "Ubuntu"
	#tag EndProperty

	#tag Property, Flags = &h0
		FontList As String = "Ubuntu"
	#tag EndProperty

	#tag Property, Flags = &h0
		FontLoading As String = "Ubuntu"
	#tag EndProperty

	#tag Property, Flags = &h0
		FontMeta As String = "Ubuntu"
	#tag EndProperty

	#tag Property, Flags = &h0
		FontStats As String = "Ubuntu"
	#tag EndProperty

	#tag Property, Flags = &h0
		FontTitle As String = "Ubuntu"
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceDERefresh As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceExeUpdate As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceFullUpdate As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceNoOnlineDBUpdates As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceOffline As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ForcePostQuit As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceQuit As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceRefreshDBs As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ForceRefreshDBsShift As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		GetSize As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		GlobalCompressedFileOut As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HasLinuxSudo As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		HideInstallerGameCats As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		HideInternetInstaller As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		HomePath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		InputStream As TextInputStream
	#tag EndProperty

	#tag Property, Flags = &h0
		InstallArg As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		InstallFromIni As String
	#tag EndProperty

	#tag Property, Flags = &h0
		InstallFromPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		InstallingItem As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		InstallOnly As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		InstallStore As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		InstallToPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IsOnline As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ItemCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ItemTempPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepSudo As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		LastClickTicks As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LastMiniUpTo As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LastTheme As String
	#tag EndProperty

	#tag Property, Flags = &h0
		LastUsedCategory As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Linux7z As String
	#tag EndProperty

	#tag Property, Flags = &h0
		LinuxCurl As String
	#tag EndProperty

	#tag Property, Flags = &h0
		LinuxWget As String
	#tag EndProperty

	#tag Property, Flags = &h0
		LLStoreDrive As String
	#tag EndProperty

	#tag Property, Flags = &h0
		LLStoreParent As String
	#tag EndProperty

	#tag Property, Flags = &h0
		LnkCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LnkEditing As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LoadedDefaults As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		LoadedMain As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		LoadedPosition As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		LoadPresetFile As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		MakeFolderAttribBatch As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ManualLocationsFile As String
	#tag EndProperty

	#tag Property, Flags = &h0
		MenuStyle As String = "UnSorted"
	#tag EndProperty

	#tag Property, Flags = &h0
		MenuWindows(1024,2) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		MenuWindowsCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MiniInstallerShowing As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		MovieVolume As Integer = 20
	#tag EndProperty

	#tag Property, Flags = &h0
		NewFileFader As String
	#tag EndProperty

	#tag Property, Flags = &h0
		NewFileIcon As String
	#tag EndProperty

	#tag Property, Flags = &h0
		NewFileScreenshot As String
	#tag EndProperty

	#tag Property, Flags = &h0
		OldMiniUpTo As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		OnlineDBs As String
	#tag EndProperty

	#tag Property, Flags = &h0
		OutputStream As TextOutputStream
	#tag EndProperty

	#tag Property, Flags = &h0
		PosHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PosLeft As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PosTop As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PosWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ppApps As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ppAppsDrive As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ppAppsFolder As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ppGames As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ppGamesDrive As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ppGamesFolder As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PreviousPresetPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		QueueDeltree As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		QueueDeltreeJobs As String
	#tag EndProperty

	#tag Property, Flags = &h0
		QueueDeltreeMajor As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		QuitInstaller As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Quitting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Randomiser As Random
	#tag EndProperty

	#tag Property, Flags = &h0
		RedirectAppCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RedirectGameCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RedirectsApp(1024,2) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RedirectsGame(1024,2) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RefreshAfter As Integer = 20
	#tag EndProperty

	#tag Property, Flags = &h0
		Regenerating As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		RegenPathIn As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RegKeyHKLMccsWin As String = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows"
	#tag EndProperty

	#tag Property, Flags = &h0
		RepositoryPathLocal As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Running As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		RunningGame As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		RunningInIDE As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		RunRefreshScript As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		RunUUID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ScaledScreenShot As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		ScaledWallpaper As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		ScannedRootFolders(1024) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ScannedRootFoldersCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ScreenRes As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ScreenShotCounter As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		ScreenShotCurrent As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		SettingsChanged As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		SettingsFile As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SettingsLoaded As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ShellFast As Shell
	#tag EndProperty

	#tag Property, Flags = &h0
		SkippedInstalling As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		SortType As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuDefaults(512) As StartMenuDefaultsStruct
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuDefaultsCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuLocations(1024,5) As StartMenuLocation
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuLocationsCount(5) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuStyles(5) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuStylesCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StartMenuUsed As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		StartPathAll As String
	#tag EndProperty

	#tag Property, Flags = &h0
		StartPathUser As String
	#tag EndProperty

	#tag Property, Flags = &h0
		StartTimeStamp As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		StoreMode As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		SudoAsNeeded As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		SudoEnabled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		SudoShellLoop As Shell
	#tag EndProperty

	#tag Property, Flags = &h0
		SysArchitecture As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysAvailableArchitectures() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysAvailableDesktops() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysAvailablePackageManagers() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysDesktopEnvironment As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysDrive As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysPackageManager As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysProgramFiles As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysRoot As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SysTerminal As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TempInstall As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ThemePath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TimeOut As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		TimePassed As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		TmpItemCount As Integer = 30000
	#tag EndProperty

	#tag Property, Flags = &h0
		TmpPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TmpPathBase As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TmpPathItems As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ToolPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WasContext As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Wayland As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Win7z As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WinCurl As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WinWget As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WritableAppPath As Boolean = True
	#tag EndProperty


	#tag Structure, Name = Shortcut, Flags = &h0
		Arguments As String * 1024
		  Description As String * 256
		  Hotkey As String * 32
		  IconLocation As String * 1024
		  TargetPath As String * 2048
		  WindowStyle As String * 64
		WorkingDirectory As String * 2048
	#tag EndStructure

	#tag Structure, Name = StartMenuDefaultsStruct, Flags = &h0
		Name As String * 128
		  Target As String * 256
		  Arguments As String * 64
		  WorkingDir As String * 256
		  Description As String * 512
		  Icon As String * 256
		  Index As Integer
		  Default As String * 256
		  Catalog As String * 128
		  Shortcut As String * 128
		HotKey As String * 8
	#tag EndStructure

	#tag Structure, Name = StartMenuLocation, Flags = &h0
		Catalog As String * 128
		  Path As String * 512
		  IconFile As String * 512
		IconIndex As String * 8
	#tag EndStructure


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StoreMode"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AppPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceQuit"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Running"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultMainWallpaper"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AvailableWidth"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadedMain"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScaledScreenShot"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScaledWallpaper"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScreenShotCurrent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultFader"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultStartButton"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultStartButtonHover"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RepositoryPathLocal"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HomePath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ItemCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LnkCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LnkEditing"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ppApps"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ppGames"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TmpPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThemePath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemID"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Linux7z"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LinuxCurl"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LinuxWget"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Win7z"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WinCurl"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WinWget"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemDBID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TmpItemCount"
			Visible=false
			Group="Behavior"
			InitialValue="30000"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TmpPathItems"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScannedRootFoldersCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BoldDescription"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BoldList"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BoldTitle"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColBG"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColCategory"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColDescription"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColFG"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColList"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColLLApp"
			Visible=false
			Group="Behavior"
			InitialValue="&C80B0FF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColLLGame"
			Visible=false
			Group="Behavior"
			InitialValue="&Cff55ff"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColLoading"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColMeta"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColppApp"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFF50"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColppGame"
			Visible=false
			Group="Behavior"
			InitialValue="&CAAFF40"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColSelect"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColssApp"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColStats"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColTitle"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultLoadingWallpaper"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontDescription"
			Visible=false
			Group="Behavior"
			InitialValue="Ubuntu"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontList"
			Visible=false
			Group="Behavior"
			InitialValue="Ubuntu"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontLoading"
			Visible=false
			Group="Behavior"
			InitialValue="Ubuntu"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontMeta"
			Visible=false
			Group="Behavior"
			InitialValue="Ubuntu"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontStats"
			Visible=false
			Group="Behavior"
			InitialValue="Ubuntu"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontTitle"
			Visible=false
			Group="Behavior"
			InitialValue="Ubuntu"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColDual"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColHiLite"
			Visible=false
			Group="Behavior"
			InitialValue="&CFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentFader"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstItem"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceRefreshDBs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HideInstallerGameCats"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SettingsFile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WasContext"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstRun"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ToolPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScreenRes"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="QuitInstaller"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InstallFromIni"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InstallingItem"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TempInstall"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LLStoreDrive"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SysDrive"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SysProgramFiles"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SysRoot"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SudoEnabled"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Quitting"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ppAppsDrive"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ppAppsFolder"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ppGamesDrive"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ppGamesFolder"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RegKeyHKLMccsWin"
			Visible=false
			Group="Behavior"
			InitialValue="HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Windows"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ItemTempPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasLinuxSudo"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SysDesktopEnvironment"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SysPackageManager"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SysTerminal"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InstallFromPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InstallToPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MenuWindowsCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RedirectAppCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RedirectGameCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AdminEnabled"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPathAll"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPathUser"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Debugging"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EditorOnly"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CommandLineFile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunningInIDE"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SettingsLoaded"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InstallOnly"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoBuild"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ManualLocationsFile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InstallArg"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadPresetFile"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PreviousPresetPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FavCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadedPosition"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DebugFileOk"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MovieVolume"
			Visible=false
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunningGame"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FlatpakAsUser"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MiniInstallerShowing"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EditingLnk"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsOnline"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InstallStore"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NewFileFader"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NewFileIcon"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NewFileScreenshot"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SudoAsNeeded"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SysArchitecture"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HideInternetInstaller"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeOut"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnlineDBs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastUsedCategory"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DebugFileName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepSudo"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForcePostQuit"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CancelDownloading"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WritableAppPath"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EditingItem"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceRefreshDBsShift"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GlobalCompressedFileOut"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedInstalling"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CleanTempFolders"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CleanUpIsle2"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OldMiniUpTo"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunRefreshScript"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentScanPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CheckingForUpdates"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceFullUpdate"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceExeUpdate"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Wayland"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceDERefresh"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MenuStyle"
			Visible=false
			Group="Behavior"
			InitialValue="UnSorted"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CommandReturned"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartMenuName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartMenuStylesCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartMenuUsed"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Regenerating"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RegenPathIn"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueDeltree"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueDeltreeJobs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueDeltreeMajor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartTimeStamp"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentssAppFile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceOffline"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadedDefaults"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MakeFolderAttribBatch"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SettingsChanged"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartMenuDefaultsCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CheckingForDatabases"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PosHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PosLeft"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PosTop"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PosWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScreenShotCounter"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceNoOnlineDBUpdates"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastMiniUpTo"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastTheme"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentDay"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentTime"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RefreshAfter"
			Visible=false
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimePassed"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContinueSelf"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastClickTicks"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LLStoreParent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SortType"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GetSize"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TmpPathBase"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunUUID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BaseDir"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CachedUserName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CombinedWineBat"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BuildingCombinedBat"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CombinedWineRegIdx"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
