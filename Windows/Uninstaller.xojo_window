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
   Height          =   530
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
   Begin DesktopListBox UninstallItems
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   False
      AllowExpandableRows=   False
      AllowFocusRing  =   False
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   3
      ColumnWidths    =   "*,0,0"
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
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  ' Centre the window on screen
		  Uninstaller.Left = (Screen(0).AvailableWidth / 2) - (Uninstaller.Width / 2)
		  Uninstaller.Top  = (Screen(0).AvailableHeight / 2) - (Uninstaller.Height / 2)
		  
		  UninstallItems.AddRow("Getting Installed Items...")
		  
		  Timer1.Period = 100
		  Timer1.RunMode = Timer.RunModes.Single
		  
		End Sub
	#tag EndEvent


	#tag Event
		Sub Closing()
		  Debug("-- Uninstaller Closed")
		  If Not ForceQuit Then Main.Items.SetFocus
		End Sub
	#tag EndEvent


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
		    
		    UninstallItems.AddRow(ItemName, "F", DesktopFile)
		  Next I
		  
		  UninstallItems.Refresh
		End Sub
	#tag EndMethod


#tag EndWindowCode

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
		  
		  ' Confirm with the user — MessageDialog gives us full control over button
		  ' labels and which is the default (Enter) action
		  Dim ItemWord As String = "Items"
		  If CheckedCount = 1 Then ItemWord = "Item"
		  
		  Dim Dlg As New MessageDialog
		  Dlg.IconType = MessageDialog.IconTypes.Caution
		  Dlg.Message = "Are you sure you want to uninstall " + CheckedCount.ToString + " " + ItemWord + "?"
		  Dlg.ActionButton.Caption = "No"
		  Dlg.AlternateActionButton.Caption = "Yes"
		  Dlg.AlternateActionButton.Visible = True
		  
		  Dim DlgResult As MessageDialogButton = Dlg.ShowModal(Self)
		  
		  If DlgResult <> Dlg.AlternateActionButton Then
		    Return  ' User clicked No or closed the dialog
		  End If
		  
		  ' Ensure the uninstall scripts exist in /LastOS/Tools/.
		  ' If they are missing, try to build them now via SetupUninstallTools.
		  ' If they still don't exist after that (e.g. immutable/read-only root on
		  ' distros like Bazzite, Silverblue, etc.) warn the user and abort.
		  If Not Exist("/LastOS/Tools/UninstallLauncher.sh") Then
		    Loading.SetupUninstallTools()
		  End If
		  
		  If Not Exist("/LastOS/Tools/UninstallLauncher.sh") Then
		    MsgBox "The uninstall tools could not be written to /LastOS/Tools/." + Chr(10) + Chr(10) + _
		    "This usually means your operating system has a read-only root filesystem " + _
		    "(common on immutable distros such as Bazzite, Silverblue, or SteamOS)." + Chr(10) + Chr(10) + _
		    "Uninstall cannot continue."
		    Return
		  End If
		  
		  ' Save both the selected row and the current scroll position before we touch anything
		  Dim SavedRow    As Integer = UninstallItems.SelectedRowIndex
		  Dim SavedScroll As Integer = UninstallItems.ScrollPosition
		  
		  ' Run UninstallLauncher.sh --silent for each checked item
		  Dim Sh As New Shell
		  Sh.TimeOut = -1
		  
		  For I = 0 To UninstallItems.RowCount - 1
		    If UninstallItems.CellTextAt(I, 1) = "T" Then
		      Dim DesktopFile As String = UninstallItems.CellTextAt(I, 2)
		      If DesktopFile <> "" Then
		        Sh.Execute("bash /LastOS/Tools/UninstallLauncher.sh " + Chr(34) + DesktopFile + Chr(34) + " --silent")
		      End If
		    End If
		  Next I
		  
		  ' Walk backwards removing rows whose .desktop file is gone.
		  ' Keep SavedRow and SavedScroll in sync as rows vanish above them.
		  Dim Row As Integer
		  For Row = UninstallItems.RowCount - 1 DownTo 0
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
		  
		  If UninstallItems.RowCount > 0 Then
		    If SavedRow    >= UninstallItems.RowCount Then SavedRow    = UninstallItems.RowCount - 1
		    If SavedRow    < 0 Then SavedRow    = 0
		    If SavedScroll < 0 Then SavedScroll = 0
		    
		    ' Find the next unchecked item from SavedRow downwards
		    Dim TargetRow As Integer = SavedRow
		    Dim R As Integer
		    For R = SavedRow To UninstallItems.RowCount - 1
		      If UninstallItems.CellTextAt(R, 1) <> "T" Then
		        TargetRow = R
		        Exit
		      End If
		    Next R
		    
		    ' Estimate visible row count from pixel height
		    Dim RowH As Integer = UninstallItems.RowHeight
		    If RowH <= 0 Then RowH = 22
		    Dim VisibleRows As Integer = UninstallItems.Height \ RowH
		    
		    ' Restore the viewport to where it was — items just disappear in place
		    UninstallItems.ScrollPosition = SavedScroll
		    
		    ' Only nudge if TargetRow drifted outside the now-restored visible window
		    If TargetRow < SavedScroll Then
		      UninstallItems.ScrollPosition = TargetRow
		    ElseIf TargetRow >= SavedScroll + VisibleRows Then
		      UninstallItems.ScrollPosition = TargetRow - VisibleRows + 1
		    End If
		    
		    UninstallItems.SelectedRowIndex = TargetRow
		  End If
		  
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
		  If UninstallItems.RowSelectedAt(row) Then
		    g.DrawingColor = &c1E3A5F  ' Dark blue for selected row
		  Else
		    If (row Mod 2) = 0 Then
		      g.DrawingColor = &c1A1A1A  ' Slightly lighter alternate row
		    Else
		      g.DrawingColor = &c111111  ' Near-black base row
		    End If
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
		  
		  If UninstallItems.RowCount <> 0 Then
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
		  ' Populate list from installed .desktop files
		  PopulateInstalledItems
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
