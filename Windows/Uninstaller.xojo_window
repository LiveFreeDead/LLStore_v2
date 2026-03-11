#tag DesktopWindow
Begin DesktopWindow Uninstaller
   Backdrop        =   0
   BackgroundColor =   &c00000000
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   True
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   560
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   200
   MinimumWidth    =   300
   Resizeable      =   True
   Title           =   "Uninstaller"
   Type            =   0
   Visible         =   False
   Width           =   420
   Begin DesktopButton UninstallButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Uninstall Selected"
      Default         =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   283
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   495
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin DesktopButton SelectAllButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Select All"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   495
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin DesktopButton SelectNoneButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Select None"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   133
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   495
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin DesktopButton RefreshButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Refresh List"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Re-scan installed LLStore and Wine items"
      Top             =   527
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin DesktopButton DeleteDesktopButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Delete .desktop"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      Italic          =   False
      Left            =   133
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Removes the .desktop file"
      Top             =   527
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin DesktopListBox UninstallItems
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   False
      AllowExpandableRows=   False
      AllowFocusRing  =   False
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   4
      ColumnWidths    =   "*,0,0,0"
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   False
      HasHeader       =   False
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   490
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   1
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   420
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin Timer Timer1
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   10
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin Timer Timer2
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   100
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
		  #PRAGMA unused appQuitting
		  If ForceQuit Then Return False  ' App already quitting — allow close
		  If IsUninstalling Then
		    ' Signal loop to stop after current item; keep window open until clean exit
		    AbortRequested = True
		    Return True
		  End If
		  If Not UninstallerOnly Then
		    Me.Hide
		    Main.Visible = True
		    If Not ForceQuit Then Main.Items.SetFocus
		    Return True
		  End If
		  Return False
		End Function
	#tag EndEvent

	#tag Event
		Sub Closing()
		  Debug("-- Uninstaller Closed")
		  If ForceQuit Then Return
		  If UninstallerOnly Then
		    ForceQuit = True
		    PreQuitApp
		    QuitApp
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  ' Centre the window on screen
		  Uninstaller.Left = (Screen(0).AvailableWidth / 2) - (Uninstaller.Width / 2)
		  Uninstaller.Top  = (Screen(0).AvailableHeight / 2) - (Uninstaller.Height / 2)
		  
		  ' Hide main so the uninstaller is the only window
		  If Not UninstallerOnly Then Main.Visible = False
		  
		  UninstallItems.AddRow("Getting Installed Items...")
		  
		  Timer1.Period = 100
		  Timer1.RunMode = Timer.RunModes.Single
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub HighlightUninstallRow(RowIdx As Integer)
		  CurrentUninstallRow = RowIdx
		  If RowIdx >= 0 And RowIdx < UninstallItems.RowCount Then
		    UninstallItems.ScrollPosition = RowIdx
		  End If
		  ' Refresh the listbox then yield 50 ms so the OS can actually
		  ' composite and paint the row highlight before we block on a shell.
		  UninstallItems.Refresh
		  App.DoEvents(50)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValidWinUninstallPath(PathIn As String) As Boolean
		  ' === Windows only — do not call on Linux ===
		  If Not TargetWindows Then Return False
		  If PathIn.Trim = "" Then Return False
		  
		  ' Normalise: trim trailing separators, convert slashes to backslash
		  Dim P As String = PathIn.Trim.ReplaceAll("/", "\")
		  P = P.TrimRight("\")
		  
		  ' Minimum length: "C:\ppApps\X" = 11 chars
		  If P.Length < 11 Then Return False
		  
		  ' Must start with a drive root:  X:\
		  If Mid(P, 2, 2) <> ":\" Then Return False
		  
		  ' Split into path components: ["C:", "ppApps", "ItemName"]
		  Dim Parts() As String = P.Split("\")
		  
		  ' Must be exactly three components — drive, pp-root, item name.
		  ' More would mean a nested subfolder (wrong); fewer means the root itself (wrong).
		  If Parts.Count <> 3 Then Return False
		  
		  ' Second component must be one of the three managed roots (case-insensitive)
		  Dim FolderRoot As String = Parts(1).Lowercase
		  If FolderRoot <> "ppgames" And FolderRoot <> "ppapps" And FolderRoot <> "ppappslive" Then Return False
		  
		  ' Item name must not be empty or whitespace
		  If Parts(2).Trim = "" Then Return False
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValidWinssAppPath(PathIn As String) As Boolean
		  ' Validates that a path is a direct or nested subfolder of
		  '   X:\Program Files\...   or   X:\Program Files (x86)\...
		  ' Works on any drive letter and does NOT rely on SysProgramFiles
		  ' (which may not be populated when the window first opens).
		  ' === Windows only — do not call on Linux ===
		  If Not TargetWindows Then Return False
		  If PathIn.Trim = "" Then Return False
		  
		  ' Normalise: trim whitespace and trailing backslashes, unify separators
		  Dim P As String = PathIn.Trim.ReplaceAll("/", "\").TrimRight("\")
		  
		  ' Must look like a rooted Windows path:  X:\...
		  If Mid(P, 2, 2) <> ":\" Then Return False
		  
		  ' Split into components: ["C:", "Program Files", "MyApp", ...]
		  Dim Parts() As String = P.Split("\")
		  
		  ' Need at least drive + root folder + one subfolder name
		  If Parts.Count < 3 Then Return False
		  
		  ' Second component (index 1) must be one of the two allowed roots
		  ' — case-insensitive, drive-letter agnostic
		  Dim FolderRoot As String = Parts(1).Lowercase
		  If FolderRoot <> "program files" And FolderRoot <> "program files (x86)" Then Return False
		  
		  ' Immediate subfolder name must not be blank
		  If Parts(2).Trim = "" Then Return False
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopulateWinRegistryssApps()
		  ' Reads HKLM + HKCU Uninstall registry hives (64-bit and WOW6432Node)
		  ' via PowerShell. Only entries whose InstallLocation is under
		  ' C:\Program Files\... or C:\Program Files (x86)\... AND that have
		  ' an ssApp.app file present in the install folder are listed.
		  '
		  ' Diagnostic log written to: TmpPath + Uninstaller_Windows.log
		  ' === Windows only — do not call on Linux ===
		  If Not TargetWindows Then Return
		  
		  Dim Q   As String = Chr(34)
		  Dim NL  As String = Chr(10)
		  Dim LNL As String = EndOfLine  ' CRLF on Windows — correct for log file
		  
		  ' ── Diagnostic log setup ────────────────────────────────────────────
		  Dim LogPath As String = Slash(TmpPath) + "Uninstaller_Windows.log"
		  LogPath = LogPath.ReplaceAll("/", "\")
		  Dim LogLines As String = ""
		  LogLines = LogLines + "══════════════════════════════════════════════════" + LNL
		  LogLines = LogLines + " PopulateWinRegistryssApps  ·  " + DateTime.Now.SQLDateTime + LNL
		  LogLines = LogLines + "══════════════════════════════════════════════════" + LNL
		  
		  ' ── Build PowerShell scan script ─────────────────────────────────────
		  Dim PS As String
		  ' Resolve Program Files at runtime — handles non-C: drives and localised Windows
		  PS = "$pf64 = [System.Environment]::GetFolderPath('ProgramFiles')" + NL
		  PS = PS + "$pf32 = [System.Environment]::GetFolderPath('ProgramFilesX86')" + NL
		  PS = PS + "if (-not $pf32 -or $pf32 -eq '') { $pf32 = $pf64 }" + NL
		  ' Echo resolved paths so they appear in the log output
		  PS = PS + "Write-Output ('LOG:PF64=' + $pf64)" + NL
		  PS = PS + "Write-Output ('LOG:PF32=' + $pf32)" + NL
		  PS = PS + "$roots = @(" + NL
		  PS = PS + "  'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'," + NL
		  PS = PS + "  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'," + NL
		  PS = PS + "  'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'" + NL
		  PS = PS + ")" + NL
		  PS = PS + "$seen = @{}" + NL
		  PS = PS + "foreach ($root in $roots) {" + NL
		  PS = PS + "  Write-Output ('LOG:HIVE=' + $root)" + NL
		  PS = PS + "  if (-not (Test-Path $root)) {" + NL
		  PS = PS + "    Write-Output 'LOG:HIVE_MISSING'" + NL
		  PS = PS + "    continue" + NL
		  PS = PS + "  }" + NL
		  PS = PS + "  Get-ChildItem -Path $root -ErrorAction SilentlyContinue | ForEach-Object {" + NL
		  PS = PS + "    $k   = $_" + NL
		  PS = PS + "    $dn  = ($k.GetValue('DisplayName')    -as [string]).Trim()" + NL
		  PS = PS + "    $us  = ($k.GetValue('UninstallString') -as [string]).Trim()" + NL
		  PS = PS + "    $loc = ($k.GetValue('InstallLocation') -as [string]).Trim().TrimEnd('\')" + NL
		  PS = PS + "    if ($dn -eq '' -or $us -eq '') { return }" + NL
		  PS = PS + "    $sysMark = $k.GetValue('SystemComponent')" + NL
		  PS = PS + "    if ($sysMark -eq 1) { return }" + NL
		  ' Derive InstallLocation from the uninstall exe path when not explicitly set
		  PS = PS + "    if ($loc -eq '') {" + NL
		  PS = PS + "      $exe = $us" + NL
		  PS = PS + "      if ($exe -match '^" + Q + "([^" + Q + "]+)" + Q + "') { $exe = $matches[1] }" + NL
		  PS = PS + "      elseif ($exe -match '^(\S+)') { $exe = $matches[1] }" + NL
		  PS = PS + "      $loc = [System.IO.Path]::GetDirectoryName($exe)" + NL
		  PS = PS + "      if (-not $loc) {" + NL
		  PS = PS + "        Write-Output ('LOG:NOLOC_SKIP=' + $dn)" + NL
		  PS = PS + "        return" + NL
		  PS = PS + "      }" + NL
		  PS = PS + "      $loc = $loc.TrimEnd('\')" + NL
		  PS = PS + "    }" + NL
		  ' Path filter — must be under a Program Files root
		  PS = PS + "    $under = ($loc.StartsWith($pf64, [System.StringComparison]::OrdinalIgnoreCase) -or" + NL
		  PS = PS + "              $loc.StartsWith($pf32, [System.StringComparison]::OrdinalIgnoreCase))" + NL
		  PS = PS + "    if (-not $under) {" + NL
		  PS = PS + "      Write-Output ('LOG:NOT_PF_SKIP=' + $dn + ' | ' + $loc)" + NL
		  PS = PS + "      return" + NL
		  PS = PS + "    }" + NL
		  PS = PS + "    if (($loc -ieq $pf64) -or ($loc -ieq $pf32)) {" + NL
		  PS = PS + "      Write-Output ('LOG:IS_ROOT_SKIP=' + $dn)" + NL
		  PS = PS + "      return" + NL
		  PS = PS + "    }" + NL
		  ' Check whether ssApp.app exists in the install folder
		  PS = PS + "    $ssAppFile = Join-Path $loc 'ssApp.app'" + NL
		  PS = PS + "    $hasSsApp  = Test-Path $ssAppFile" + NL
		  PS = PS + "    Write-Output ('LOG:CHECK=' + $dn + ' | LOC=' + $loc + ' | ssApp.app=' + $hasSsApp + ' | US=' + $us)" + NL
		  ' Dedup check
		  PS = PS + "    $dedup = $dn + '||' + $loc" + NL
		  PS = PS + "    if ($seen.ContainsKey($dedup)) {" + NL
		  PS = PS + "      Write-Output ('LOG:DEDUP_SKIP=' + $dn)" + NL
		  PS = PS + "      return" + NL
		  PS = PS + "    }" + NL
		  PS = PS + "    $seen[$dedup] = 1" + NL
		  ' Only emit a data line if ssApp.app is present
		  PS = PS + "    if ($hasSsApp) {" + NL
		  PS = PS + "      Write-Output ($dn + '|||' + $loc + '|||' + $us)" + NL
		  PS = PS + "    }" + NL
		  PS = PS + "  }" + NL
		  PS = PS + "}" + NL
		  
		  Dim ScriptPath As String = SpecialFolder.Temporary.NativePath + "llstore_regssapp_scan.ps1"
		  SaveDataToFile(PS, ScriptPath)
		  
		  LogLines = LogLines + "--- Script: " + ScriptPath + LNL
		  LogLines = LogLines + "--- PS Content ---" + LNL + PS + LNL
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = 15000
		  Sh.Execute("powershell.exe -ExecutionPolicy Bypass -NoProfile -File " + Q + ScriptPath + Q)
		  
		  Dim RawOutput As String = Sh.Result
		  LogLines = LogLines + "--- Raw PS Output ---" + LNL + RawOutput + LNL
		  LogLines = LogLines + "─────────────────────────────────────────────────" + LNL
		  
		  Dim DelSh As New Shell
		  DelSh.Execute("cmd /c del /f /q " + Q + ScriptPath + Q)
		  
		  ' Parse data lines — skip LOG: diagnostic prefix lines
		  Dim RawLines() As String = RawOutput.Split(Chr(10))
		  Dim I As Integer
		  Dim AddedCount As Integer = 0
		  For I = 0 To RawLines.Count - 1
		    Dim Line As String = RawLines(I).Trim.ReplaceAll(Chr(13), "")
		    If Line = "" Then Continue
		    If Left(Line, 4) = "LOG:" Then Continue  ' diagnostic lines — not data
		    
		    ' InStr is 1-based — subtract 1 to get 0-based offset for Left/Mid
		    Dim Pos1 As Integer = InStr(Line, "|||") - 1
		    If Pos1 < 1 Then
		      LogLines = LogLines + "PARSE_SKIP(no 1st |||): " + Line + LNL
		      Continue
		    End If
		    Dim Pos2 As Integer = InStr(Pos1 + 4, Line, "|||") - 1  ' InStr start is 1-based
		    If Pos2 < 1 Then
		      LogLines = LogLines + "PARSE_SKIP(no 2nd |||): " + Line + LNL
		      Continue
		    End If
		    
		    Dim ItemName   As String = Left(Line, Pos1).Trim
		    Dim InstallLoc As String = Mid(Line, Pos1 + 4, Pos2 - Pos1 - 3).Trim.TrimRight("\")
		    Dim UninstStr  As String = Mid(Line, Pos2 + 4).Trim
		    
		    If ItemName = "" Or InstallLoc = "" Or UninstStr = "" Then
		      LogLines = LogLines + "PARSE_SKIP(empty field): " + Line + LNL
		      Continue
		    End If
		    
		    ' Xojo-side path safety gate
		    If Not IsValidWinssAppPath(InstallLoc) Then
		      LogLines = LogLines + "PATH_GATE_FAIL: " + InstallLoc + LNL
		      Continue
		    End If
		    
		    ' Belt-and-braces: confirm ssApp.app from the Xojo side as well
		    Dim ssAppCheck As String = NoSlash(InstallLoc) + "\ssApp.app"
		    Dim ssAppFI As FolderItem = GetFolderItem(ssAppCheck, FolderItem.PathTypeNative)
		    If ssAppFI = Nil Or Not ssAppFI.Exists Then
		      LogLines = LogLines + "SSAPP_MISSING(Xojo): " + ssAppCheck + LNL
		      Continue
		    End If
		    
		    LogLines = LogLines + "ADDED: " + ItemName + " | " + InstallLoc + LNL
		    UninstallItems.AddRow(ItemName + " [ssApp]", "F", InstallLoc + "|||" + UninstStr, "ssApp")
		    AddedCount = AddedCount + 1
		  Next I
		  
		  LogLines = LogLines + "─────────────────────────────────────────────────" + LNL
		  LogLines = LogLines + "Total added: " + AddedCount.ToString + LNL
		  LogLines = LogLines + "══════════════════════════════════════════════════" + LNL
		  
		  ' Flush diagnostic log to disk
		  Try
		    Dim LogFI As FolderItem = GetFolderItem(LogPath, FolderItem.PathTypeNative)
		    Dim BS As BinaryStream
		    If LogFI <> Nil And LogFI.Exists Then
		      BS = BinaryStream.Open(LogFI, True)
		      BS.Position = BS.Length
		    Else
		      BS = BinaryStream.Create(LogFI, True)
		    End If
		    If BS <> Nil Then
		      BS.Write(LogLines)
		      BS.Close
		    End If
		  Catch
		  End Try
		  
		  UninstallItems.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopulateInstalledItems()
		  ' Clear existing rows
		  UninstallItems.RemoveAllRows
		  
		  ' Use the global HomePath — strip any trailing slash for the regex pattern
		  Dim H As String = NoSlash(HomePath)
		  If H = "" Then Return
		  
		  ' Build a bash script that:
		  '   1. Uses find to locate all .desktop files in ~/.local/share/applications
		  '   2. Scans ANY line (covers both Exec= and Path=) for one of the four managed
		  '      install paths followed by a subfolder name — bare root paths are excluded
		  '      because [^/ \t\r\n]+ requires at least one non-slash character after /
		  '   3. Outputs: Name|/path/to/file.desktop  (one line per match)
		  ' Col 0 = display name, Col 1 = checked "T"/"F", Col 2 = .desktop file path
		  
		  Dim Script As String
		  Script = "#!/bin/bash" + Chr(10)
		  Script = Script + "find " + Chr(34) + H + "/.local/share/applications" + Chr(34) + " -maxdepth 1 -name " + Chr(34) + "*.desktop" + Chr(34) + " 2>/dev/null | sort | while IFS= read -r DESK; do" + Chr(10)
		  ' grep checks ALL lines in the file (not just Exec=) so Path= entries like
		  '   Path=/home/user/.wine/drive_c/ppApps/AIMP  are caught too.
		  ' The pattern requires the base path + at least one subfolder character,
		  ' so bare paths ending in just /LLApps/ or /ppApps/ are excluded.
		  Script = Script + "  if grep -qE " + Chr(34)
		  Script = Script + "(" + H + "/LLApps/[^/ ]+" + "|" + H + "/LLGames/[^/ ]+" + "|" + H + "/.wine/drive_c/ppApps/[^/ ]+" + "|" + H + "/.wine/drive_c/ppGames/[^/ ]+)"
		  Script = Script + Chr(34) + " " + Chr(34) + "$DESK" + Chr(34) + " 2>/dev/null; then" + Chr(10)
		  Script = Script + "    NAME=$(grep -m1 " + Chr(34) + "^Name=" + Chr(34) + " " + Chr(34) + "$DESK" + Chr(34) + " | cut -d= -f2-)" + Chr(10)
		  Script = Script + "    [ -n " + Chr(34) + "$NAME" + Chr(34) + " ] && echo " + Chr(34) + "${NAME}|${DESK}" + Chr(34) + Chr(10)
		  Script = Script + "  fi" + Chr(10)
		  Script = Script + "done" + Chr(10)
		  
		  ' Write script to temp file and run it
		  Dim ScriptPath As String = "/tmp/llstore_uninstall_scan.sh"
		  SaveDataToFile(Script, ScriptPath)
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = 15000
		  Sh.Execute("bash " + Chr(34) + ScriptPath + Chr(34))
		  Dim DelSh1 As New Shell
		  DelSh1.Execute("rm -f " + Chr(34) + ScriptPath + Chr(34))
		  
		  ' Parse each output line:  Name|/path/to/file.desktop
		  Dim RawLines() As String = Sh.Result.Split(Chr(10))
		  Dim I As Integer
		  For I = 0 To RawLines.Count - 1
		    Dim Line As String = RawLines(I).Trim
		    If Line = "" Then Continue
		    
		    Dim PipePos As Integer = Line.IndexOf("|")
		    If PipePos < 1 Then Continue
		    
		    Dim ItemName    As String = Left(Line, PipePos).Trim
		    Dim DesktopFile As String = Mid(Line, PipePos + 2).Trim  ' Mid is 1-based; PipePos+2 skips the |
		    
		    If ItemName = "" Or DesktopFile = "" Then Continue
		    
		    UninstallItems.AddRow(ItemName, "F", DesktopFile, "llstore")
		  Next I
		  
		  UninstallItems.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopulateInstalledItemsWin()
		  ' === Windows only — do not call on Linux ===
		  If Not TargetWindows Then Return
		  
		  Dim Q  As String = Chr(34)
		  Dim NL As String = Chr(10)
		  
		  ' Resolve the three managed Windows install roots.
		  ' ppApps / ppGames are global strings set by ControlPanel / Loading (e.g. "C:\ppApps\").
		  ' ppAppsLive lives on the same drive as ppApps.
		  Dim PpGPath  As String = ""
		  Dim PpAPath  As String = ""
		  Dim PpALPath As String = ""
		  
		  If ppGames <> "" Then
		    PpGPath = NoSlash(ppGames.ReplaceAll("/", "\"))
		  End If
		  If ppApps <> "" Then
		    PpAPath = NoSlash(ppApps.ReplaceAll("/", "\"))
		    ' Derive the drive letter (first 2 chars, e.g. "C:") then append \ppAppsLive
		    Dim DrivePart As String = Left(ppApps.ReplaceAll("\", "/"), 2)  ' e.g. "C:"
		    PpALPath = DrivePart + "\ppAppsLive"
		  End If
		  
		  ' Build a PowerShell script that enumerates direct subfolders (= installed items)
		  ' from each root that exists, outputting:  Name|FullPath|TypeTag
		  Dim PS As String
		  PS = "function ScanDir($root, $tag) {" + NL
		  PS = PS + "  if (-not (Test-Path $root)) { return }" + NL
		  PS = PS + "  Get-ChildItem -Path $root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike '.*' } | Sort-Object Name | ForEach-Object {" + NL
		  PS = PS + "    Write-Output ($_.Name + '|' + $_.FullName + '|' + $tag)" + NL
		  PS = PS + "  }" + NL
		  PS = PS + "}" + NL
		  If PpGPath <> "" Then
		    PS = PS + "ScanDir " + Q + PpGPath + Q + " ppGame" + NL
		  End If
		  If PpAPath <> "" Then
		    PS = PS + "ScanDir " + Q + PpAPath + Q + " ppApp" + NL
		  End If
		  If PpALPath <> "" Then
		    PS = PS + "ScanDir " + Q + PpALPath + Q + " ppAppsLive" + NL
		  End If
		  
		  Dim ScriptPath As String = SpecialFolder.Temporary.NativePath + "llstore_winscan.ps1"
		  SaveDataToFile(PS, ScriptPath)
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = 10000
		  Sh.Execute("powershell.exe -ExecutionPolicy Bypass -NoProfile -File " + Q + ScriptPath + Q)
		  
		  Dim DelSh As New Shell
		  DelSh.Execute("cmd /c del /f /q " + Q + ScriptPath + Q)
		  
		  ' Parse output lines:  Name|FullPath|TypeTag
		  Dim RawLines() As String = Sh.Result.Split(Chr(10))
		  Dim I As Integer
		  For I = 0 To RawLines.Count - 1
		    Dim Line As String = RawLines(I).Trim.ReplaceAll(Chr(13), "")
		    If Line = "" Then Continue
		    Dim Parts() As String = Line.Split("|")
		    If Parts.Count < 3 Then Continue
		    Dim ItemName As String = Parts(0).Trim
		    Dim ItemPath As String = Parts(1).Trim
		    Dim ItemType As String = Parts(2).Trim
		    If ItemName = "" Or ItemPath = "" Then Continue
		    ' Add a [Live] suffix for ppAppsLive items to distinguish them at a glance
		    Dim DisplayName As String = ItemName
		    If ItemType = "ppAppsLive" Then DisplayName = ItemName + " [Live]"
		    UninstallItems.AddRow(DisplayName, "F", ItemPath, ItemType)
		  Next I
		  
		  UninstallItems.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopulateWineItems()
		  'Read Wine registry files directly using iconv + awk. No Python, no wine process spawn.
		  'iconv is part of glibc and present on every distro that runs Wine.
		  'Parses HKLM (system.reg) and HKCU (user.reg) from the default Wine prefix.
		  'Col 0 = display name + " [Wine]", Col 1 = "F", Col 2 = UninstallString, Col 3 = "wine"
		  If Not TargetLinux Then Return
		  Dim H As String = NoSlash(HomePath)
		  If H = "" Then Return
		  
		  Dim ScriptPath As String = "/tmp/llstore_wine_uninst_scan.sh"
		  Dim Q As String = Chr(34)
		  Dim S As String
		  
		  S = "#!/bin/bash" + Chr(10)
		  S = S + "parse_reg() {" + Chr(10)
		  S = S + "  local f=" + Q + "$1" + Q + Chr(10)
		  S = S + "  [ -f " + Q + "$f" + Q + " ] || return" + Chr(10)
		  S = S + "  { if od -A n -N 2 -t x1 " + Q + "$f" + Q + " 2>/dev/null | grep -qi 'ff fe'; then iconv -f UTF-16LE -t UTF-8 " + Q + "$f" + Q + " 2>/dev/null; else cat " + Q + "$f" + Q + "; fi; } | awk '" + Chr(10)
		  S = S + "    BEGIN { name=" + Q + Q + "; uninst=" + Q + Q + "; icon=" + Q + Q + "; loc=" + Q + Q + " }" + Chr(10)
		  S = S + "    /^\[/ { if (name != " + Q + Q + ") { if (uninst == " + Q + Q + ") { if (icon != " + Q + Q + ") uninst=icon; else if (loc != " + Q + Q + ") { if (loc !~ /\\$/) loc=loc " + Q + "\\" + Q + "; uninst=" + Q + "INSTDIR:" + Q + " loc } }; if (uninst != " + Q + Q + ") print name " + Q + "|" + Q + " uninst }; name=" + Q + Q + "; uninst=" + Q + Q + "; icon=" + Q + Q + "; loc=" + Q + Q + " }" + Chr(10)
		  S = S + "    /^" + Q + "DisplayName" + Q + "=/ { val=substr($0,15); gsub(/^" + Q + "|" + Q + "$/, " + Q + Q + ", val); name=val }" + Chr(10)
		  S = S + "    /^" + Q + "UninstallString" + Q + "=/ { val=substr($0,19); gsub(/^" + Q + "|" + Q + "$/, " + Q + Q + ", val); uninst=val }" + Chr(10)
		  S = S + "    /^" + Q + "DisplayIcon" + Q + "=/ { val=substr($0,15); gsub(/^" + Q + "|" + Q + "$/, " + Q + Q + ", val); sub(/,[0-9]+$/, " + Q + Q + ", val); if (tolower(val) ~ /uninst[^\\]*\.exe$/) icon=val }" + Chr(10)
		  S = S + "    /^" + Q + "InstallLocation" + Q + "=/ { val=substr($0,19); gsub(/^" + Q + "|" + Q + "$/, " + Q + Q + ", val); loc=val }" + Chr(10)
		  S = S + "    /^" + Q + "InstallPath" + Q + "=/ { if (loc == " + Q + Q + ") { val=substr($0,15); gsub(/^" + Q + "|" + Q + "$/, " + Q + Q + ", val); loc=val } }" + Chr(10)
		  S = S + "    END { if (name != " + Q + Q + ") { if (uninst == " + Q + Q + ") { if (icon != " + Q + Q + ") uninst=icon; else if (loc != " + Q + Q + ") { if (loc !~ /\\$/) loc=loc " + Q + "\\" + Q + "; uninst=" + Q + "INSTDIR:" + Q + " loc } }; if (uninst != " + Q + Q + ") print name " + Q + "|" + Q + " uninst } }" + Chr(10)
		  S = S + "  '" + Chr(10)
		  S = S + "}" + Chr(10)
		  S = S + "find_uninst_in_windir() {" + Chr(10)
		  S = S + "  local windir=" + Q + "$1" + Q + " lindir" + Chr(10)
		  S = S + "  lindir=$(printf '%s' " + Q + "$windir" + Q + " | sed 's|\\|/|g;s|^[Cc]:|" + H + "/.wine/drive_c|')" + Chr(10)
		  S = S + "  lindir=" + Q + "${lindir%/}" + Q + Chr(10)
		  S = S + "  [ -d " + Q + "$lindir" + Q + " ] || return" + Chr(10)
		  S = S + "  local f" + Chr(10)
		  S = S + "  for f in " + Q + "$lindir" + Q + "/[Uu]nins*.exe " + Q + "$lindir" + Q + "/[Uu]ninstall*.exe " + Q + "$lindir" + Q + "/*[Uu]ninst*.exe; do" + Chr(10)
		  S = S + "    [ -f " + Q + "$f" + Q + " ] && printf '%s\\%s\n' " + Q + "${windir%\\}" + Q + " " + Q + "$(basename " + Q + "$f" + Q + ")" + Q + " && return" + Chr(10)
		  S = S + "  done" + Chr(10)
		  S = S + "}" + Chr(10)
		  S = S + "{ parse_reg " + Q + H + "/.wine/system.reg" + Q + "; parse_reg " + Q + H + "/.wine/user.reg" + Q + "; } | sort -u | while IFS='|' read -r _n _u; do" + Chr(10)
		  S = S + "  if [[ " + Q + "$_u" + Q + " == INSTDIR:* ]]; then" + Chr(10)
		  S = S + "    _r=$(find_uninst_in_windir " + Q + "${_u#INSTDIR:}" + Q + ")" + Chr(10)
		  S = S + "    [ -n " + Q + "$_r" + Q + " ] && printf '%s|%s\n' " + Q + "$_n" + Q + " " + Q + "$_r" + Q + Chr(10)
		  S = S + "  else" + Chr(10)
		  S = S + "    printf '%s|%s\n' " + Q + "$_n" + Q + " " + Q + "$_u" + Q + Chr(10)
		  S = S + "  fi" + Chr(10)
		  S = S + "done" + Chr(10)
		  
		  SaveDataToFile(S, ScriptPath)
		  Dim Sh As New Shell
		  Sh.TimeOut = 10000
		  Sh.Execute("bash " + Chr(34) + ScriptPath + Chr(34))
		  Dim DelSh2 As New Shell
		  DelSh2.Execute("rm -f " + Chr(34) + ScriptPath + Chr(34))
		  
		  Dim RawLines() As String = Sh.Result.Split(Chr(10))
		  Dim I As Integer
		  For I = 0 To RawLines.Count - 1
		    Dim Line As String = RawLines(I).Trim
		    If Line = "" Then Continue
		    Dim PipePos As Integer = Line.IndexOf("|")
		    If PipePos < 1 Then Continue
		    Dim ItemName     As String = Left(Line, PipePos).Trim
		    Dim UninstString As String = Mid(Line, PipePos + 2).Trim
		    ' Strip leading/trailing backslash-escaped quotes left by Wine registry parser (e.g. \"C:\...\" -> C:\...)
		    If UninstString.Left(2) = Chr(92) + Chr(34) Then UninstString = UninstString.Mid(3)
		    If UninstString.Right(2) = Chr(92) + Chr(34) Then UninstString = UninstString.Left(UninstString.Length - 2)
		    If ItemName = "" Or UninstString = "" Then Continue
		    UninstallItems.AddRow(ItemName + " [Wine]", "F", UninstString, "wine")
		  Next I
		  
		  UninstallItems.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveWinShortcutsFor(ItemPath As String)
		  ' Scans both the current-user and All-Users Start Menu Programs trees for any
		  ' .lnk shortcuts whose TargetPath or WorkingDirectory points into ItemPath,
		  ' then deletes them.  Uses an in-process PowerShell + WScript.Shell COM call.
		  ' === Windows only — do not call on Linux ===
		  If Not TargetWindows Then Return
		  If ItemPath.Trim = "" Then Return
		  
		  Dim Q  As String = Chr(34)
		  Dim NL As String = Chr(10)
		  
		  ' Normalise the target folder path (no trailing backslash)
		  Dim NormPath As String = ItemPath.Trim.ReplaceAll("/", "\")
		  NormPath = NormPath.TrimRight("\")
		  
		  ' Current-user Start Menu Programs
		  Dim UserPrograms As String = NoSlash(SpecialFolder.ApplicationData.NativePath) + "\Microsoft\Windows\Start Menu\Programs"
		  ' All-Users / Public Start Menu Programs
		  Dim AllPrograms  As String = NoSlash(SpecialFolder.SharedApplicationData.NativePath) + "\Microsoft\Windows\Start Menu\Programs"
		  
		  Dim PS As String
		  PS = "$targetBase = " + Q + NormPath + Q + NL
		  PS = PS + "$shell = New-Object -ComObject WScript.Shell" + NL
		  PS = PS + "$dirs  = @(" + Q + UserPrograms + Q + ", " + Q + AllPrograms + Q + ")" + NL
		  PS = PS + "foreach ($dir in $dirs) {" + NL
		  PS = PS + "  if (-not (Test-Path $dir)) { continue }" + NL
		  PS = PS + "  Get-ChildItem -Path $dir -Recurse -Filter '*.lnk' -ErrorAction SilentlyContinue | ForEach-Object {" + NL
		  PS = PS + "    try {" + NL
		  PS = PS + "      $lnk = $shell.CreateShortcut($_.FullName)" + NL
		  PS = PS + "      $t   = $lnk.TargetPath" + NL
		  PS = PS + "      $w   = $lnk.WorkingDirectory" + NL
		  PS = PS + "      if (($t -like ($targetBase + '\*')) -or ($t -eq $targetBase) -or" + NL
		  PS = PS + "          ($w -like ($targetBase + '\*')) -or ($w -eq $targetBase)) {" + NL
		  PS = PS + "        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue" + NL
		  PS = PS + "      }" + NL
		  PS = PS + "    } catch {}" + NL
		  PS = PS + "  }" + NL
		  PS = PS + "}" + NL
		  
		  Dim ScriptPath As String = SpecialFolder.Temporary.NativePath + "llstore_rmlinks.ps1"
		  SaveDataToFile(PS, ScriptPath)
		  
		  Dim Sh As New Shell
		  Sh.TimeOut = 20000
		  Sh.Execute("powershell.exe -ExecutionPolicy Bypass -NoProfile -File " + Q + ScriptPath + Q)
		  
		  Dim DelSh As New Shell
		  DelSh.Execute("cmd /c del /f /q " + Q + ScriptPath + Q)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetUninstallingMode(Active As Boolean)
		  IsUninstalling = Active
		  UninstallButton.Enabled  = Not Active
		  SelectAllButton.Enabled  = Not Active
		  SelectNoneButton.Enabled = Not Active
		  RefreshButton.Enabled    = Not Active
		  DeleteDesktopButton.Enabled = Not Active
		  UninstallItems.Enabled   = Not Active
		  If Active Then
		    Uninstaller.Title = "Uninstaller  —  Working..."
		    CurrentUninstallRow = -1
		  Else
		    Uninstaller.Title = "Uninstaller"
		    CurrentUninstallRow = -1
		    UninstallItems.Refresh
		  End If
		  ' Let the title bar, buttons and listbox all repaint before
		  ' the caller proceeds — without this the UI looks frozen.
		  App.DoEvents(50)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UninstallWinItems()
		  ' Processes all checked Windows items (ppGame / ppApp / ppAppsLive).
		  ' For each item:
		  '   1. Validates the folder path is a legitimate direct child of ppGames, ppApps, or ppAppsLive.
		  '   2. Removes Start Menu shortcuts (current user + All Users) targeting the folder.
		  '   3. Deletes the folder recursively via  cmd /c rmdir /q /s
		  '   4. Appends a log entry to LLStore.log in the user's home folder.
		  ' === Windows only — do not call on Linux ===
		  If Not TargetWindows Then Return
		  
		  Dim Q  As String = Chr(34)
		  Dim NL As String = EndOfLine
		  Var UninstStartDT As DateTime = DateTime.Now
		  
		  ' Snapshot the checked rows before we start modifying the list
		  Dim UninstNames() As String
		  Dim UninstPaths() As String
		  Dim UninstTypes() As String
		  Dim UninstROWs()  As Integer
		  Dim I, J As Integer
		  For I = 0 To UninstallItems.RowCount - 1
		    If UninstallItems.CellTextAt(I, 1) = "T" Then
		      Dim IType As String = UninstallItems.CellTextAt(I, 3)
		      ' Only snapshot Windows-type rows
		      If IType = "ppGame" Or IType = "ppApp" Or IType = "ppAppsLive" Or IType = "ssApp" Then
		        UninstNames.Add(UninstallItems.CellTextAt(I, 0))
		        UninstPaths.Add(UninstallItems.CellTextAt(I, 2))
		        UninstTypes.Add(IType)
		        UninstROWs.Add(I)
		      End If
		    End If
		  Next I
		  
		  Dim LogPath As String = NoSlash(HomePath) + "\LLStore.log"
		  
		  For I = 0 To UninstNames.Count - 1
		    If AbortRequested Then Exit
		    HighlightUninstallRow(UninstROWs(I))
		    Dim ItemPath As String = UninstPaths(I)
		    Dim ItemType As String = UninstTypes(I)
		    
		    ' ── ssApp (registry) items — run their own uninstaller silently ──────────
		    If ItemType = "ssApp" Then
		      ' Col 2 is encoded as: InstallLocation|||UninstallString
		      Dim ssPos As Integer = InStr(ItemPath, "|||") - 1  ' 0-based position
		      If ssPos < 1 Then Continue  ' Malformed — skip
		      Dim ssInstallLoc As String = Left(ItemPath, ssPos).Trim.TrimRight("\")
		      Dim ssUninstStr  As String = Mid(ItemPath, ssPos + 4).Trim
		      If ssInstallLoc = "" Or ssUninstStr = "" Then Continue
		      
		      ' Path safety gate — must be under Program Files (64 or 32)
		      If Not IsValidWinssAppPath(ssInstallLoc) Then
		        MsgBox "Skipped " + Q + UninstNames(I) + Q + " — install path is not under Program Files:" + Chr(10) + ssInstallLoc
		        Continue
		      End If
		      
		      ' Build a silent uninstall command
		      ' MSI: swap /I for /X and add quiet flags; NSIS/InnoSetup/etc: append /S
		      Dim ssRunCmd As String
		      If ssUninstStr.Lowercase.IndexOf("msiexec") >= 0 Then
		        ssRunCmd = ssUninstStr.ReplaceAll("/I{", "/X{").ReplaceAll("/i{", "/X{") + " /qn /norestart"
		      Else
		        ssRunCmd = ssUninstStr + " /S"
		      End If
		      
		      ' Run the uninstaller and wait for it to finish
		      Dim ssShRun As New Shell
		      ssShRun.TimeOut = 120000   ' Allow up to 2 minutes for the uninstaller
		      ssShRun.Execute(ssRunCmd)
		      App.DoEvents(50)  ' Let the row highlight repaint after the uninstaller returns
		      
		      ' Clean up Start Menu .lnk shortcuts that point into the install folder
		      RemoveWinShortcutsFor(ssInstallLoc)
		      
		      ' Remove any leftover ssApp.* files in the install folder
		      ' (These are LLStore metadata files — the real app files should already be
		      '  gone if the uninstaller completed cleanly.)
		      Dim ssCleanPS As String
		      Dim ssClNL As String = Chr(10)
		      ssCleanPS = "$dir = " + Q + ssInstallLoc + Q + ssClNL
		      ssCleanPS = ssCleanPS + "if (Test-Path $dir) {" + ssClNL
		      ssCleanPS = ssCleanPS + "  Get-ChildItem -Path $dir -Filter 'ssApp.*' -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue" + ssClNL
		      ssCleanPS = ssCleanPS + "}" + ssClNL
		      Dim ssClScriptPath As String = SpecialFolder.Temporary.NativePath + "llstore_ssapp_clean.ps1"
		      SaveDataToFile(ssCleanPS, ssClScriptPath)
		      Dim ssClSh As New Shell
		      ssClSh.TimeOut = 10000
		      ssClSh.Execute("powershell.exe -ExecutionPolicy Bypass -NoProfile -File " + Q + ssClScriptPath + Q)
		      Dim ssClDelSh As New Shell
		      ssClDelSh.Execute("cmd /c del /f /q " + Q + ssClScriptPath + Q)
		      
		      ' Log the ssApp uninstall
		      Dim J2 As Integer
		      Var char1ss As String = Chr(205)
		      Dim Border1ss As String = ""
		      For J2 = 1 To 62
		        Border1ss = Border1ss + char1ss
		      Next
		      Var char2ss As String = Chr(196)
		      Dim Border2ss As String = ""
		      For J2 = 1 To 62
		        Border2ss = Border2ss + char2ss
		      Next
		      Dim ssLogBlock As String = NL
		      ssLogBlock = ssLogBlock + Border1ss + NL
		      ssLogBlock = ssLogBlock + " SSAPP UNINSTALL  ·  " + DateTime.Now.SQLDateTime + NL
		      ssLogBlock = ssLogBlock + Border2ss + NL
		      ssLogBlock = ssLogBlock + "   Item          :  " + UninstNames(I) + NL
		      ssLogBlock = ssLogBlock + "   InstallPath   :  " + ssInstallLoc + NL
		      ssLogBlock = ssLogBlock + "   Command       :  " + ssRunCmd + NL
		      ssLogBlock = ssLogBlock + Border1ss + NL
		      Try
		        Dim ssLogFI As FolderItem = GetFolderItem(LogPath, FolderItem.PathTypeNative)
		        Dim ssBS As BinaryStream
		        If ssLogFI.Exists Then
		          ssBS = BinaryStream.Open(ssLogFI, True)
		          ssBS.Position = ssBS.Length
		        Else
		          ssBS = BinaryStream.Create(ssLogFI, True)
		        End If
		        If ssBS <> Nil Then
		          ssBS.Write(ssLogBlock)
		          ssBS.Close
		        End If
		      Catch
		      End Try
		      
		      Continue  ' Done with this ssApp row — skip the ppXxx folder-delete logic below
		    End If
		    
		    ' ── Safety gate: only delete a path that is a valid ppXxx child ──
		    If Not IsValidWinUninstallPath(ItemPath) Then
		      MsgBox "Skipped " + Q + UninstNames(I) + Q + " — path is not a valid ppGames / ppApps / ppAppsLive subfolder:" + Chr(10) + ItemPath
		      Continue
		    End If
		    
		    ' Normalise path (no trailing backslash)
		    Dim NormPath As String = ItemPath.Trim.ReplaceAll("/", "\")
		    NormPath = NormPath.TrimRight("\")
		    
		    
		    ' ── 1. Remove shortcuts from both Start Menu locations ──
		    RemoveWinShortcutsFor(NormPath)
		    
		    ' ── 2. Delete the install folder ──
		    Dim ShDel As New Shell
		    ShDel.TimeOut = 60000
		    ShDel.Execute("cmd /c rmdir /q /s " + Q + NormPath + Q)
		    App.DoEvents(50)  ' Let the row highlight repaint after the delete returns
		    
		    ' ── 3. Log the uninstall ──
		    
		    Var char1 As String = Chr(205)
		    Dim Border1 As String = ""
		    For J = 1 To 62
		      Border1 = Border1 + char1
		    Next' ═══ (double horizontal bar)
		    
		    char1 = Chr(196)
		    Dim Border2 As String = ""
		    For J = 1 To 62
		      Border2 = Border2 + char1
		    Next ' ─── (single horizontal bar)
		    
		    Dim LogBlock As String = NL
		    LogBlock = LogBlock + Border1 + NL
		    LogBlock = LogBlock + " WIN UNINSTALL  ·  " + DateTime.Now.SQLDateTime + NL
		    LogBlock = LogBlock + Border2 + NL
		    LogBlock = LogBlock + "   Item          :  " + UninstNames(I) + NL
		    LogBlock = LogBlock + "   Type          :  " + ItemType + NL
		    LogBlock = LogBlock + "   Path          :  " + NormPath + NL
		    LogBlock = LogBlock + Border1 + NL
		    Try
		      Dim LogFI As FolderItem = GetFolderItem(LogPath, FolderItem.PathTypeNative)
		      Dim BS As BinaryStream
		      If LogFI.Exists Then
		        BS = BinaryStream.Open(LogFI, True)
		        BS.Position = BS.Length
		      Else
		        BS = BinaryStream.Create(LogFI, True)
		      End If
		      If BS <> Nil Then
		        BS.Write(LogBlock)
		        BS.Close
		      End If
		    Catch
		    End Try
		    
		  Next I
		  
		  SetUninstallingMode(False)
		  If AbortRequested Then
		    AbortRequested = False
		    If UninstallerOnly Then
		      ForceQuit = True
		      PreQuitApp
		      QuitApp
		    Else
		      Me.Hide
		      Main.Visible = True
		      If Not ForceQuit Then Main.Items.SetFocus
		    End If
		    Return
		  End If
		  UninstallItems.RemoveAllRows
		  PopulateInstalledItemsWin
		  PopulateWinRegistryssApps
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private AbortRequested As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CurrentUninstallRow As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IsUninstalling As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PendingUninstLeft As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PendingUninstTop As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events UninstallButton
	#tag Event
		Sub Pressed()
		  ' Count how many items are checked
		  Dim CheckedCount As Integer = 0
		  Dim I As Integer
		  For I = 0 To UninstallItems.RowCount - 1
		    If UninstallItems.CellTextAt(I, 1) = "T" Then CheckedCount = CheckedCount + 1
		  Next I
		  
		  ' Nothing checked — nothing to do
		  If CheckedCount = 0 Then
		    MsgBox "No items are selected for uninstall."
		    Return
		  End If
		  
		  ' Confirm with the user
		  Dim ItemWord As String = "Items"
		  If CheckedCount = 1 Then ItemWord = "Item"
		  
		  Dim Dlg As New MessageDialog
		  Dlg.IconType = MessageDialog.IconTypes.Caution
		  Dlg.Message = "Are you sure you want to uninstall " + CheckedCount.ToString + " " + ItemWord + "?"
		  Dlg.ActionButton.Caption = "No"
		  Dlg.AlternateActionButton.Caption = "Yes"
		  Dlg.AlternateActionButton.Visible = True
		  
		  Dim DlgResult As MessageDialogButton = Dlg.ShowModal(Self)
		  If DlgResult <> Dlg.AlternateActionButton Then Return
		  
		  ' Lock the UI and fire the uninstall timer.
		  ' 250 ms gives the window a full repaint cycle before work begins.
		  SetUninstallingMode(True)
		  Timer2.Period  = 250
		  Timer2.RunMode = Timer.RunModes.Single
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SelectAllButton
	#tag Event
		Sub Pressed()
		  Dim I As Integer
		  For I = 0 To UninstallItems.RowCount - 1
		    UninstallItems.CellTextAt(I, 1) = "T"
		  Next I
		  UninstallItems.Refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SelectNoneButton
	#tag Event
		Sub Pressed()
		  Dim I As Integer
		  For I = 0 To UninstallItems.RowCount - 1
		    UninstallItems.CellTextAt(I, 1) = "F"
		  Next I
		  UninstallItems.Refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events RefreshButton
	#tag Event
		Sub Pressed()
		  UninstallItems.RemoveAllRows
		  If TargetLinux Then
		    PopulateInstalledItems
		    PopulateWineItems
		  End If
		  If TargetWindows Then
		    PopulateInstalledItemsWin
		    PopulateWinRegistryssApps
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DeleteDesktopButton
	#tag Event
		Sub Pressed()
		  ' Delete the .desktop file(s) for checked llstore-type rows without running the full uninstaller.
		  ' Tooltip / tip text: "Removes the .desktop file"
		  If Not TargetLinux Then Return
		  
		  Dim CheckedCount As Integer = 0
		  Dim I As Integer
		  For I = 0 To UninstallItems.RowCount - 1
		    If UninstallItems.CellTextAt(I, 1) = "T" And UninstallItems.CellTextAt(I, 3) = "llstore" Then
		      CheckedCount = CheckedCount + 1
		    End If
		  Next I
		  
		  If CheckedCount = 0 Then
		    MsgBox "No LLStore items are selected. Select one or more items to delete their .desktop file."
		    Return
		  End If
		  
		  Dim ItemWord As String = "items"
		  If CheckedCount = 1 Then ItemWord = "item"
		  
		  Dim Dlg As New MessageDialog
		  Dlg.IconType = MessageDialog.IconTypes.Caution
		  Dlg.Message = "Delete the .desktop file for " + CheckedCount.ToString + " selected " + ItemWord + "?" + Chr(10) + Chr(10) + "This removes the launcher entry only — the installed app files are NOT deleted."
		  Dlg.ActionButton.Caption = "Cancel"
		  Dlg.AlternateActionButton.Caption = "Delete .desktop"
		  Dlg.AlternateActionButton.Visible = True
		  
		  Dim DlgResult As MessageDialogButton = Dlg.ShowModal(Self)
		  If DlgResult <> Dlg.AlternateActionButton Then Return
		  
		  ' Walk backwards so row removal doesn't shift indices
		  For I = UninstallItems.RowCount - 1 DownTo 0
		    If UninstallItems.CellTextAt(I, 1) = "T" And UninstallItems.CellTextAt(I, 3) = "llstore" Then
		      Dim DF As String = UninstallItems.CellTextAt(I, 2)
		      If DF <> "" Then
		        Dim F As FolderItem = GetFolderItem(DF, FolderItem.PathTypeNative)
		        If F <> Nil And F.Exists Then
		          F.Delete
		        End If
		      End If
		      UninstallItems.RemoveRowAt(I)
		    End If
		  Next I
		  
		  ' Refresh user desktop database after deletions
		  Dim DbSh As New Shell
		  DbSh.Execute("bash -c 'update-desktop-database ~/.local/share/applications > /dev/null 2>&1 &'")
		  
		  UninstallItems.Refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events UninstallItems
	#tag Event
		Function PaintCellBackground(g As Graphics, row As Integer, column As Integer) As Boolean
		  ' Guard: nothing to paint if list is empty or row is past the end
		  If UninstallItems.RowCount = 0 Then Return True
		  If row >= UninstallItems.RowCount Then Return True
		  
		  ' --- Row background (dark theme) ---
		  ' Determine the item type for this row (Col 3 tag)
		  Dim RowType As String = ""
		  If UninstallItems.RowCount > 0 And row < UninstallItems.RowCount Then
		    RowType = UninstallItems.CellTextAt(row, 3)
		  End If
		  
		  Dim IsWineRow     As Boolean = (RowType = "wine")
		  Dim IsPpGameRow   As Boolean = (RowType = "ppGame")
		  Dim IsPpAppsLive  As Boolean = (RowType = "ppAppsLive")
		  ' ppApp rows use the default dark theme (same as llstore)
		  
		  ' Active uninstall highlight — amber, overrides all other row colours
		  If IsUninstalling And row = CurrentUninstallRow Then
		    g.DrawingColor = &c7A4F00
		  ElseIf UninstallItems.RowSelectedAt(row) Then
		    Select Case RowType
		    Case "wine"
		      g.DrawingColor = &c5A1E2F  ' Dark wine-red selected
		    Case "ppGame"
		      g.DrawingColor = &c1A4A1A  ' Dark green selected
		    Case "ppAppsLive"
		      g.DrawingColor = &c1A3A4A  ' Dark teal selected
		    Case "ssApp"
		      g.DrawingColor = &c3A1A5A  ' Dark purple selected
		    Else
		      g.DrawingColor = &c1E3A5F  ' Dark blue selected (llstore / ppApp)
		    End Select
		  Else
		    Select Case RowType
		    Case "wine"
		      If (row Mod 2) = 0 Then
		        g.DrawingColor = &c2A1018  ' Lighter wine-red alternate
		      Else
		        g.DrawingColor = &c1E0A10  ' Dark wine-red base
		      End If
		    Case "ppGame"
		      If (row Mod 2) = 0 Then
		        g.DrawingColor = &c162016  ' Lighter dark-green alternate
		      Else
		        g.DrawingColor = &c0E160E  ' Dark green base
		      End If
		    Case "ppAppsLive"
		      If (row Mod 2) = 0 Then
		        g.DrawingColor = &c121E22  ' Lighter dark-teal alternate
		      Else
		        g.DrawingColor = &c0A1418  ' Dark teal base
		      End If
		    Case "ssApp"
		      If (row Mod 2) = 0 Then
		        g.DrawingColor = &c1E1230  ' Lighter dark-purple alternate
		      Else
		        g.DrawingColor = &c140C20  ' Dark purple base
		      End If
		    Else
		      If (row Mod 2) = 0 Then
		        g.DrawingColor = &c1A1A1A  ' Slightly lighter alternate row
		      Else
		        g.DrawingColor = &c111111  ' Near-black base row
		      End If
		    End Select
		  End If
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  ' --- Checkbox ---
		  Dim BoxSize As Integer = g.Height - 6
		  Dim BoxX    As Integer = 4
		  Dim BoxY    As Integer = 3
		  
		  ' Unchecked: light-gray fill + border
		  g.DrawingColor = &cAAAAAA  ' Gray border
		  g.DrawRectangle(BoxX, BoxY, BoxSize, BoxSize)
		  g.DrawingColor = &cCCCCCC  ' Light gray fill
		  g.FillRectangle(BoxX + 1, BoxY + 1, BoxSize - 1, BoxSize - 1)
		  
		  ' Checked: medium-blue fill + white tick
		  If UninstallItems.RowCount <> 0 Then
		    If UninstallItems.CellTextAt(row, 1) = "T" Then
		      g.DrawingColor = &c3377BB  ' Medium blue
		      g.FillRectangle(BoxX + 1, BoxY + 1, BoxSize - 1, BoxSize - 1)
		      ' White tick mark
		      Dim MidX As Integer = BoxX + (BoxSize / 3)
		      Dim BotY As Integer = BoxY + BoxSize - 3
		      g.DrawingColor = &cFFFFFF
		      g.DrawLine(BoxX + 2, BoxY + (BoxSize / 2), MidX, BotY)
		      g.DrawLine(MidX, BotY, BoxX + BoxSize - 2, BoxY + 2)
		    End If
		  End If
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function PaintCellText(g as Graphics, row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  #PRAGMA unused x
		  #PRAGMA unused y
		  
		  ' Guard: nothing to paint if list is empty or row is past the end
		  If UninstallItems.RowCount = 0 Then Return True
		  If row >= UninstallItems.RowCount Then Return True
		  
		  Dim CheckWidth As Integer = g.Height + 6
		  Dim Pos        As Integer = g.Height - 2 - (g.Height / 6)
		  
		  If IsUninstalling And row = CurrentUninstallRow Then
		    g.DrawingColor = &cFFDD44  ' Bright amber text for active uninstall row
		    g.Bold = True
		  ElseIf UninstallItems.RowCount <> 0 Then
		    If UninstallItems.CellTextAt(row, 1) = "T" Then
		      g.DrawingColor = &cFFFFFF  ' Bright white when checked
		      g.Bold = True
		    Else
		      g.DrawingColor = &cCCCCCC  ' Soft white when unchecked
		      g.Bold = False
		    End If
		  End If
		  
		  g.DrawText(UninstallItems.CellTextAt(row, 0), CheckWidth, Pos)
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function CellPressed(row As Integer, column As Integer, x As Integer, y As Integer) As Boolean
		  #PRAGMA unused column
		  #PRAGMA unused y
		  
		  ' Guard: ignore presses if list is empty or row is past the end
		  If UninstallItems.RowCount = 0 Then Return False
		  If row >= UninstallItems.RowCount Then Return False
		  If IsUninstalling Then Return True  ' Locked during uninstall
		  
		  ' Toggle the checkbox state for this row
		  If UninstallItems.CellTextAt(row, 1) = "T" Then
		    UninstallItems.CellTextAt(row, 1) = "F"
		  Else
		    UninstallItems.CellTextAt(row, 1) = "T"
		  End If
		  
		  UninstallItems.Refresh
		  Return False
		End Function
	#tag EndEvent
	#tag Event
		Function KeyDown(key As String) As Boolean
		  If IsUninstalling Then Return True  ' Locked during uninstall
		  ' Space bar toggles the checkbox on the currently highlighted row
		  If Asc(key) = 32 Then
		    Dim Row As Integer = UninstallItems.SelectedRowIndex
		    If Row >= 0 And UninstallItems.RowCount > 0 And Row < UninstallItems.RowCount Then
		      If UninstallItems.CellTextAt(Row, 1) = "T" Then
		        UninstallItems.CellTextAt(Row, 1) = "F"
		      Else
		        UninstallItems.CellTextAt(Row, 1) = "T"
		      End If
		      UninstallItems.Refresh
		    End If
		    Return True  ' Consume the keypress so it doesn't scroll the list
		  End If
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events Timer1
	#tag Event
		Sub Action()
		  ' Gate: each OS only runs its own populate routines
		  If TargetLinux Then
		    ' Populate LLStore items then Wine registry items
		    PopulateInstalledItems
		    PopulateWineItems
		  End If
		  If TargetWindows Then
		    PopulateInstalledItemsWin
		    PopulateWinRegistryssApps
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Timer2
	#tag Event
		Sub Action()
		  ' On Windows: delegate entirely to the Windows uninstall routine and return.
		  ' All code below this gate is Linux-only and must never run on Windows.
		  If TargetWindows Then
		    UninstallWinItems
		    Return
		  End If
		  
		  Var UninstStartDT As DateTime = DateTime.Now
		  Dim SavedRow    As Integer = UninstallItems.SelectedRowIndex
		  Dim SavedScroll As Integer = UninstallItems.ScrollPosition
		  
		  ' Snapshot checked items
		  Dim UninstNames()    As String
		  Dim UninstDesktops() As String
		  Dim UninstTypes()    As String
		  Dim I As Integer
		  For I = 0 To UninstallItems.RowCount - 1
		    If UninstallItems.CellTextAt(I, 1) = "T" Then
		      UninstNames.Add(UninstallItems.CellTextAt(I, 0))
		      UninstDesktops.Add(UninstallItems.CellTextAt(I, 2))
		      UninstTypes.Add(UninstallItems.CellTextAt(I, 3))
		    End If
		  Next I
		  
		  ' === Wine items ===
		  Dim WineUninstCount As Integer = 0
		  Dim WineLogPath As String = Slash(HomePath) + "LLStore.log"
		  For I = 0 To UninstallItems.RowCount - 1
		    If UninstallItems.CellTextAt(I, 1) = "T" And UninstallItems.CellTextAt(I, 3) = "wine" Then
		      If AbortRequested Then Exit
		      HighlightUninstallRow(I)
		      Dim US As String = UninstallItems.CellTextAt(I, 2)
		      If US <> "" Then
		        Dim WineExeCmd As String
		        If US.Lowercase.IndexOf("msiexec") >= 0 Then
		          WineExeCmd = "wine " + US.ReplaceAll("/I{", "/X{").ReplaceAll("/i{", "/X{") + " /qn /norestart"
		        Else
		          If US.Left(1) = Chr(34) Then
		            WineExeCmd = "wine " + US
		          Else
		            WineExeCmd = "wine " + Chr(34) + US + Chr(34)
		          End If
		        End If
		        
		        Dim WineScriptPath As String = "/tmp/llstore_wine_uninst_" + I.ToString + ".sh"
		        Dim WS As String
		        WS = "#!/bin/bash" + Chr(10)
		        WS = WS + "[ -f /etc/profile ] && source /etc/profile" + Chr(10)
		        WS = WS + "[ -f " + Chr(34) + "$HOME/.profile" + Chr(34) + " ] && source " + Chr(34) + "$HOME/.profile" + Chr(34) + Chr(10)
		        WS = WS + "export WINEPREFIX=" + Chr(34) + NoSlash(HomePath) + "/.wine" + Chr(34) + Chr(10)
		        WS = WS + "setsid " + WineExeCmd + " &" + Chr(10)
		        WS = WS + "disown" + Chr(10)
		        SaveDataToFile(WS, WineScriptPath)
		        Dim ChmodSh As New Shell
		        ChmodSh.Execute("chmod +x " + Chr(34) + WineScriptPath + Chr(34))
		        
		        Dim NL As String = EndOfLine
		        Dim WineLogBlock As String = NL
		        WineLogBlock = WineLogBlock + "══════════════════════════════════════════════════════════════" + NL
		        WineLogBlock = WineLogBlock + " WINE UNINSTALL  ·  " + DateTime.Now.SQLDateTime + NL
		        WineLogBlock = WineLogBlock + "──────────────────────────────────────────────────────────────" + NL
		        WineLogBlock = WineLogBlock + "   Item          :  " + UninstallItems.CellTextAt(I, 0) + NL
		        WineLogBlock = WineLogBlock + "   Command       :  " + WineExeCmd + NL
		        WineLogBlock = WineLogBlock + "   Script        :  " + WineScriptPath + NL
		        WineLogBlock = WineLogBlock + "   WINEPREFIX    :  " + NoSlash(HomePath) + "/.wine" + NL
		        WineLogBlock = WineLogBlock + "══════════════════════════════════════════════════════════════" + NL
		        Try
		          Dim WineLogFI As FolderItem = GetFolderItem(WineLogPath, FolderItem.PathTypeNative)
		          Dim WineBS As BinaryStream
		          If WineLogFI.Exists Then
		            WineBS = BinaryStream.Open(WineLogFI, True)
		            WineBS.Position = WineBS.Length
		          Else
		            WineBS = BinaryStream.Create(WineLogFI, True)
		          End If
		          If WineBS <> Nil Then
		            WineBS.Write(WineLogBlock)
		            WineBS.Close
		          End If
		        Catch
		        End Try
		        
		        Dim ShWait As New Shell
		        ShWait.TimeOut = -1
		        ShWait.Execute(WineScriptPath)
		        Dim Success As String = ShWait.Result
		        App.DoEvents(50)  ' Let the row highlight repaint after the shell returns
		        Dim DelSh3 As New Shell
		        DelSh3.Execute("rm -f " + Chr(34) + WineScriptPath + Chr(34))
		        WineUninstCount = WineUninstCount + 1
		      End If
		    End If
		  Next I
		  
		  ' === LLStore items ===
		  Dim Sh As New Shell
		  Sh.TimeOut = -1
		  For I = 0 To UninstallItems.RowCount - 1
		    If UninstallItems.CellTextAt(I, 1) = "T" And UninstallItems.CellTextAt(I, 3) <> "wine" Then
		      If AbortRequested Then Exit
		      HighlightUninstallRow(I)
		      Dim DesktopFile As String = UninstallItems.CellTextAt(I, 2)
		      If DesktopFile <> "" Then
		        Sh.Execute("bash /opt/LastOS/Tools/UninstallLauncher.sh " + Chr(34) + DesktopFile + Chr(34) + " --silent")
		        App.DoEvents(50)  ' Let the row highlight repaint after the shell returns
		      End If
		    End If
		  Next I
		  
		  ' Walk backwards: wine rows get desktop cleanup, LLStore rows check .desktop gone
		  Dim Row As Integer
		  For Row = UninstallItems.RowCount - 1 DownTo 0
		    If UninstallItems.CellTextAt(Row, 3) = "wine" Then
		      ' Delete the .desktop file Wine leaves in ~/.local/share/applications/wine/
		      Dim WineName As String = UninstallItems.CellTextAt(Row, 0)
		      If WineName.Right(7) = " [Wine]" Then WineName = WineName.Left(WineName.Length - 7)
		      Dim WineAppsDir As String = Slash(HomePath) + ".local/share/applications/wine/Programs/"
		      Dim DesktopGlob As New Shell
		      DesktopGlob.Execute("find " + Chr(34) + WineAppsDir + Chr(34) + " -iname " + Chr(34) + WineName + ".desktop" + Chr(34) + " 2>/dev/null")
		      Dim FoundDesktop As String = DesktopGlob.Result.Trim
		      If FoundDesktop <> "" Then
		        Dim WineDF As FolderItem = GetFolderItem(FoundDesktop, FolderItem.PathTypeNative)
		        If WineDF <> Nil And WineDF.Exists Then
		          WineDF.Delete
		          LogUninstallEntry(UninstallItems.CellTextAt(Row, 0), FoundDesktop, UninstStartDT)
		        End If
		      End If
		      UninstallItems.RemoveRowAt(Row)
		      Continue
		    End If
		    Dim DF As String = UninstallItems.CellTextAt(Row, 2)
		    If DF <> "" Then
		      Dim F As FolderItem = GetFolderItem(DF, FolderItem.PathTypeNative)
		      If F = Nil Or Not F.Exists Then
		        UninstallItems.RemoveRowAt(Row)
		        If Row < SavedRow    Then SavedRow    = SavedRow    - 1
		        If Row < SavedScroll Then SavedScroll = SavedScroll - 1
		      End If
		    End If
		  Next Row
		  
		  ' Log LLStore removals
		  Dim UI As Integer
		  For UI = 0 To UninstNames.Count - 1
		    If UI < UninstTypes.Count And UninstTypes(UI) = "wine" Then Continue
		    Dim CheckDF As FolderItem = GetFolderItem(UninstDesktops(UI), FolderItem.PathTypeNative)
		    If CheckDF = Nil Or Not CheckDF.Exists Then
		      LogUninstallEntry(UninstNames(UI), UninstDesktops(UI), UninstStartDT)
		    End If
		  Next UI
		  
		  SetUninstallingMode(False)
		  If AbortRequested Then
		    AbortRequested = False
		    If UninstallerOnly Then
		      ForceQuit = True
		      PreQuitApp
		      QuitApp
		    Else
		      Uninstaller.Hide
		      Main.Visible = True
		      If Not ForceQuit Then Main.Items.SetFocus
		    End If
		    Return
		  End If
		  ' Repopulate the list
		  UninstallItems.RemoveAllRows
		  PopulateInstalledItems
		  PopulateWineItems
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
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
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
