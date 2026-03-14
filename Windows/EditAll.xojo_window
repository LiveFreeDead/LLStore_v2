#tag DesktopWindow
Begin DesktopWindow EditAll
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   550
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   450
   MinimumWidth    =   640
   Resizeable      =   True
   Title           =   "Edit All Items"
   Type            =   0
   Visible         =   False
   Width           =   700
   Begin DesktopListBox AllItemsListBox
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   False
      AllowExpandableRows=   False
      AllowFocusRing  =   True
      AllowResizableColumns=   True
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   1
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   3
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   True
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   220
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   700
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopCanvas Separator1
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   False
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   8
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Drag to resize"
      Top             =   220
      Transparent     =   False
      Visible         =   True
      Width           =   700
   End
   Begin DesktopLabel DescriptionLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   18
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   4
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "Description:"
      TextAlignment   =   0
      TextColor       =   &c888888
      Tooltip         =   ""
      Top             =   230
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   700
   End
   Begin DesktopTextArea DescriptionArea
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   70
      HideSelection   =   True
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   "Edit description for the selected item. Line breaks are preserved."
      Top             =   250
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   700
   End
   Begin DesktopTextArea Script1TextArea
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowStyledText =   False
      AllowTabs       =   True
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "Courier New"
      FontSize        =   11.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   True
      HasVerticalScrollbar=   True
      Height          =   160
      HideSelection   =   True
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   346
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   347
   End
   Begin DesktopTextArea Script1TextArea1
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowStyledText =   False
      AllowTabs       =   True
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "Courier New"
      FontSize        =   11.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   True
      HasVerticalScrollbar=   True
      Height          =   160
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   353
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   346
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   347
   End
   Begin DesktopButton SaveButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Save Edits"
      Default         =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   26
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   607
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Save all rows that have been edited"
      Top             =   518
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   86
   End
   Begin DesktopLabel Script1Label
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "LLScript.sh"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   324
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   347
   End
   Begin DesktopLabel Script2Label
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   353
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "LLScript_Sudo.sh"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   324
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   347
   End
   Begin DesktopLabel StatusLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   22
      Index           =   -2147483648
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   False
      Text            =   "Ready."
      TextAlignment   =   0
      TextColor       =   &c444444
      Tooltip         =   ""
      Top             =   522
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   600
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
		  ' FIX BUG 4: When the app is quitting, allow the window to close.
		  ' Returning True unconditionally caused a hang on exit because the
		  ' quit process waited forever for this window to close.
		  If appQuitting Then
		    If EACurrentRow >= 0 Then EAFlushCurrentScripts
		    Return False
		  End If
		  If EACurrentRow >= 0 Then EAFlushCurrentScripts
		  Me.Visible = False
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  If Data.Items.RowCount = 0 Then
		    MsgBox "No items loaded in LLStore. Please load items first."
		    Me.Visible = False
		    Return
		  End If
		  Me.Title = "Edit All Items"
		  EACurrentRow = -1
		  EAIgnoreChange = False
		  EASepY = 220
		  EASetupGrid
		  EAPopulate
		  LayoutControls()
		  EASetStatus("Loaded " + AllItemsListBox.RowCount.ToString + " items. Click a row to view scripts.")
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  ' FIX BUG 3: Recalculate all positions so scripts split 50/50 at every width
		  LayoutControls()
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function EABuildIniText(row As Integer) As String
		  Dim BT      As String = AllItemsListBox.CellTextAt(row, EAColBT)
		  Dim TF      As String = AllItemsListBox.CellTextAt(row, EAColTF)
		  Dim IniFile As String = EAGetIniFilename(BT)
		  If IniFile = "" Then Return ""
		  Dim OrigIni As String = ""
		  If TF <> "" And Exist(Slash(TF) + IniFile) Then
		    OrigIni = LoadDataFromFile(Slash(TF) + IniFile)
		  End If
		  OrigIni = OrigIni.ReplaceAll(Chr(13), "")
		  Dim OrigFields As New Dictionary
		  Dim ShortcutRaw As String = ""
		  Dim InShortcut As Boolean = False
		  Dim OrigLines() As String = OrigIni.Split(Chr(10))
		  Dim OL As Integer
		  For OL = 0 To OrigLines.Count - 1
		    Dim Lin As String = OrigLines(OL).Trim
		    If Lin = "" Then
		      If InShortcut Then ShortcutRaw = ShortcutRaw + Chr(10)
		      Continue
		    End If
		    If Left(Lin,1) = "[" And (Lin.IndexOf(".desktop]") > 0 Or Lin.IndexOf(".lnk]") > 0) Then
		      InShortcut = True
		    End If
		    If InShortcut Then
		      ShortcutRaw = ShortcutRaw + Lin + Chr(10)
		    Else
		      If Left(Lin,1) <> "[" Then
		        Dim EqPos As Integer = Lin.IndexOf(1, "=")
		        If EqPos >= 1 Then
		          Dim OrigKey As String = Left(Lin, EqPos).Trim.Lowercase
		          OrigFields.Value(OrigKey) = Lin
		        End If
		      End If
		    End If
		  Next
		  Dim IsLL As Boolean = (BT = "LLApp" Or BT = "LLGame")
		  Dim IsSS As Boolean = Not IsLL
		  Dim Title   As String = AllItemsListBox.CellTextAt(row, EAColTitle).Trim
		  Dim Version As String = AllItemsListBox.CellTextAt(row, EAColVer).Trim
		  ' DescRaw is stored with Chr(30) separators — pass straight through to file
		  Dim DescRaw  As String = AllItemsListBox.CellTextAt(row, EAColDesc).Trim
		  Dim URLVal   As String = AllItemsListBox.CellTextAt(row, EAColURL).Trim
		  Dim CatsVal  As String = AllItemsListBox.CellTextAt(row, EAColCats).Trim
		  Dim CatVal   As String = AllItemsListBox.CellTextAt(row, EAColCat).Trim
		  Dim PriVal   As String = AllItemsListBox.CellTextAt(row, EAColPri).Trim
		  Dim DEVal    As String = AllItemsListBox.CellTextAt(row, EAColDE).Trim
		  Dim PMVal    As String = AllItemsListBox.CellTextAt(row, EAColPM).Trim
		  Dim ACVal    As String = AllItemsListBox.CellTextAt(row, EAColAC).Trim
		  Dim FlagsV   As String = AllItemsListBox.CellTextAt(row, EAColFlags).Trim
		  Dim PathVal  As String = AllItemsListBox.CellTextAt(row, EAColPath).Trim
		  Dim TagsVal  As String = AllItemsListBox.CellTextAt(row, EAColTags).Trim
		  Dim PubVal   As String = AllItemsListBox.CellTextAt(row, EAColPub).Trim
		  Dim LangVal  As String = AllItemsListBox.CellTextAt(row, EAColLang).Trim
		  Dim RateVal  As String = AllItemsListBox.CellTextAt(row, EAColRate).Trim
		  Dim PlayVal  As String = AllItemsListBox.CellTextAt(row, EAColPlay).Trim
		  Dim LicVal   As String = AllItemsListBox.CellTextAt(row, EAColLic).Trim
		  Dim DateVal  As String = AllItemsListBox.CellTextAt(row, EAColDate).Trim
		  Dim RVerVal  As String = AllItemsListBox.CellTextAt(row, EAColRVer).Trim
		  Dim BldVal   As String = AllItemsListBox.CellTextAt(row, EAColBuild).Trim
		  Dim SzVal    As String = AllItemsListBox.CellTextAt(row, EAColSz).Trim
		  Dim DepsVal  As String = AllItemsListBox.CellTextAt(row, EAColDeps).Trim
		  Dim DataOut As String
		  If IsLL Then
		    DataOut = "[LLFile]" + Chr(10)
		  Else
		    DataOut = "[SetupS]" + Chr(10)
		  End If
		  DataOut = DataOut + "Title=" + Title + Chr(10)
		  If Version <> "" Then DataOut = DataOut + "Version=" + Version + Chr(10)
		  If DescRaw <> "" Then DataOut = DataOut + "Description=" + DescRaw + Chr(10)
		  If URLVal <> "" Then DataOut = DataOut + "URL=" + URLVal + Chr(10)
		  If CatsVal <> "" Then
		    Dim CatOut As String = CatsVal
		    If IsLL Then
		      If Right(CatOut,1) <> ";" Then CatOut = CatOut + ";"
		    Else
		      CatOut = CatOut.ReplaceAll(";","|").Trim
		      If Right(CatOut,1) = "|" Then CatOut = Left(CatOut, Len(CatOut)-1)
		    End If
		    DataOut = DataOut + "Category=" + CatOut + Chr(10)
		  End If
		  DataOut = DataOut + "BuildType=" + BT + Chr(10)
		  If IsSS Then
		    DataOut = DataOut + "App-File Version=v9.24.05.22.0" + Chr(10)
		    DataOut = DataOut + "App-File Style=2 (INI)" + Chr(10)
		  End If
		  If PathVal <> "" Then DataOut = DataOut + "AppPath=" + PathVal + Chr(10)
		  If CatVal <> "" Then
		    Dim CatalogOut As String = CatVal
		    If IsLL Then
		      If Right(CatalogOut,1) <> ";" Then CatalogOut = CatalogOut + ";"
		    Else
		      CatalogOut = CatalogOut.ReplaceAll(";","|").Trim
		      If Right(CatalogOut,1) = "|" Then CatalogOut = Left(CatalogOut, Len(CatalogOut)-1).Trim
		    End If
		    DataOut = DataOut + "Catalog=" + CatalogOut + Chr(10)
		  End If
		  If OrigFields.HasKey("startmenusourcepath")     Then DataOut = DataOut + OrigFields.Value("startmenusourcepath")     + Chr(10)
		  If OrigFields.HasKey("startmenulegacyprimary")  Then DataOut = DataOut + OrigFields.Value("startmenulegacyprimary")  + Chr(10)
		  If OrigFields.HasKey("startmenulegacysecondary")Then DataOut = DataOut + OrigFields.Value("startmenulegacysecondary")+ Chr(10)
		  If OrigFields.HasKey("shortcutnameskeep")       Then DataOut = DataOut + OrigFields.Value("shortcutnameskeep")       + Chr(10)
		  If PriVal <> ""  Then DataOut = DataOut + "Priority="       + PriVal  + Chr(10)
		  If DEVal  <> ""  Then DataOut = DataOut + "DECompatible="   + DEVal   + Chr(10)
		  If PMVal  <> ""  Then DataOut = DataOut + "PMCompatible="   + PMVal   + Chr(10)
		  If ACVal  <> ""  Then DataOut = DataOut + "ArchCompatible=" + ACVal   + Chr(10)
		  If OrigFields.HasKey("assembly")    Then DataOut = DataOut + OrigFields.Value("assembly")    + Chr(10)
		  If FlagsV <> ""  Then DataOut = DataOut + "Flags="          + FlagsV  + Chr(10)
		  If OrigFields.HasKey("architecture")Then DataOut = DataOut + OrigFields.Value("architecture")+ Chr(10)
		  If OrigFields.HasKey("os")          Then DataOut = DataOut + OrigFields.Value("os")          + Chr(10)
		  DataOut = DataOut + "[Meta]" + Chr(10)
		  If SzVal   <> "" And SzVal   <> "0" Then DataOut = DataOut + "InstalledSize="  + SzVal   + Chr(10)
		  If TagsVal <> ""                     Then DataOut = DataOut + "Tags="           + TagsVal + Chr(10)
		  If PubVal  <> ""                     Then DataOut = DataOut + "Publisher="      + PubVal  + Chr(10)
		  If LangVal <> ""                     Then DataOut = DataOut + "Language="       + LangVal + Chr(10)
		  If BldVal  <> ""                     Then DataOut = DataOut + "Releaser="       + BldVal  + Chr(10)
		  If RateVal <> "" And RateVal <> "0"  Then DataOut = DataOut + "Rating="         + RateVal + Chr(10)
		  If PlayVal <> "" And PlayVal <> "0"  Then DataOut = DataOut + "Players="        + PlayVal + Chr(10)
		  If DateVal <> ""                     Then DataOut = DataOut + "ReleaseDate="    + DateVal + Chr(10)
		  If LicVal  <> "" And LicVal  <> "0" Then
		    If IsSS Then
		      DataOut = DataOut + "LicenseType=" + LicVal + Chr(10)
		    Else
		      DataOut = DataOut + "License=" + LicVal + Chr(10)
		    End If
		  End If
		  If RVerVal <> "" Then DataOut = DataOut + "ReleaseVersion=" + RVerVal + Chr(10)
		  If DepsVal <> "" Then DataOut = DataOut + "Dependencies="   + DepsVal + Chr(10)
		  If OrigFields.HasKey("additional")       Then DataOut = DataOut + OrigFields.Value("additional")       + Chr(10)
		  If OrigFields.HasKey("requiredruntimes") Then DataOut = DataOut + OrigFields.Value("requiredruntimes") + Chr(10)
		  If ShortcutRaw.Trim <> "" Then DataOut = DataOut + ShortcutRaw
		  Return DataOut
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EAExtractScripts(row As Integer)
		  If AllItemsListBox.CellTextAt(row, EAColTF) <> "" Then Return
		  Dim ArchivePath As String = AllItemsListBox.CellTextAt(row, EAColAP)
		  If ArchivePath = "" Then Return
		  If Not Exist(ArchivePath) Then Return
		  Dim BT    As String = AllItemsListBox.CellTextAt(row, EAColBT)
		  Dim Title As String = AllItemsListBox.CellTextAt(row, EAColTitle)
		  Dim Slug As String = ""
		  Dim Combined As String = Title.Lowercase + BT.Lowercase
		  Dim I As Integer
		  For I = 1 To Len(Combined)
		    Dim C As String = Mid(Combined, I, 1)
		    If (C >= "a" And C <= "z") Or (C >= "0" And C <= "9") Then Slug = Slug + C
		  Next
		  If Len(Slug) > 30 Then Slug = Left(Slug, 30)
		  Dim TempFolder As String = Slash(TmpPath) + "editall/" + Slug + "_" + Randomiser.InRange(1000, 9999).ToString + "/"
		  MakeFolder(TempFolder)
		  Dim IniFile As String = EAGetIniFilename(BT)
		  Dim SF1 As String = ""
		  Dim SF2 As String = ""
		  EAGetScriptFilenames(BT, SF1, SF2)
		  Dim Targets As String = IniFile
		  If SF1 <> "" Then Targets = Targets + " " + SF1
		  If SF2 <> "" Then Targets = Targets + " " + SF2
		  Dim Q As String = Chr(34)
		  Dim Cmd As String = Linux7z + " -mtc -aoa x " + Q + ArchivePath + Q + " -o" + Q + TempFolder + Q + " " + Targets
		  Dim Sh As New Shell
		  Sh.TimeOut = -1
		  Sh.Execute(Cmd)
		  Dim Buf As String = ""
		  Do
		    App.DoEvents(20)
		    Buf = Buf + Sh.ReadAll
		  Loop Until Sh.IsRunning = False
		  Buf = Buf + Sh.ReadAll
		  If Debugging Then Debug("EAExtractScripts: " + Buf)
		  AllItemsListBox.CellTextAt(row, EAColTF) = TempFolder
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EAFlushCurrentScripts()
		  If EACurrentRow < 0 Then Return
		  
		  ' FIX BUG 1: Flush Description TextArea back to grid cell with Chr(30) line encoding
		  Dim DescText As String = DescriptionArea.Text
		  DescText = DescText.ReplaceAll(Chr(13) + Chr(10), Chr(30))  ' Windows CRLF
		  DescText = DescText.ReplaceAll(Chr(13), Chr(30))             ' lone CR (Xojo TextArea uses CR)
		  DescText = DescText.ReplaceAll(Chr(10), Chr(30))             ' lone LF
		  If DescText <> AllItemsListBox.CellTextAt(EACurrentRow, EAColDesc) Then
		    EAIgnoreChange = True
		    AllItemsListBox.CellTextAt(EACurrentRow, EAColDesc) = DescText
		    AllItemsListBox.CellTextAt(EACurrentRow, EAColDI) = "T"
		    EAIgnoreChange = False
		  End If
		  
		  If AllItemsListBox.CellTextAt(EACurrentRow, EAColDS) <> "T" Then Return
		  Dim TF As String = AllItemsListBox.CellTextAt(EACurrentRow, EAColTF)
		  If TF = "" Then Return
		  Dim BT As String = AllItemsListBox.CellTextAt(EACurrentRow, EAColBT)
		  Dim SF1 As String = ""
		  Dim SF2 As String = ""
		  EAGetScriptFilenames(BT, SF1, SF2)
		  If SF1 <> "" And Script1TextArea.Text.Trim <> "" Then
		    SaveDataToFile(Script1TextArea.Text, Slash(TF) + SF1)
		  End If
		  If SF2 <> "" And Script1TextArea1.Text.Trim <> "" Then
		    SaveDataToFile(Script1TextArea1.Text, Slash(TF) + SF2)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EAGetIniFilename(BT As String) As String
		  Select Case BT
		  Case "LLApp" 
		    Return "LLApp.lla"
		  Case "LLGame" 
		    Return "LLGame.llg"
		  Case "ssApp"  
		    Return "ssApp.app"
		  Case "ppApp"  
		     Return "ppApp.app"
		  Case "ppGame" 
		     Return "ppGame.ppg"
		  Case Else    
		     Return ""
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EAGetScriptFilenames(BT As String, ByRef SF1 As String, ByRef SF2 As String)
		  Select Case BT
		  Case "LLApp", "LLGame"
		    SF1 = "LLScript.sh"
		    SF2 = "LLScript_Sudo.sh"
		  Case "ssApp", "ppApp", "ppGame"
		    SF1 = BT + ".cmd"
		    SF2 = BT + ".reg"
		  Case Else
		    SF1 = ""
		    SF2 = ""
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EAPopulate()
		  EAIgnoreChange = True
		  AllItemsListBox.RemoveAllRows
		  Dim dBT    As Integer = Data.GetDBHeader("BuildType")
		  Dim dTitle As Integer = Data.GetDBHeader("TitleName")
		  Dim dVer   As Integer = Data.GetDBHeader("Version")
		  Dim dDesc  As Integer = Data.GetDBHeader("Description")
		  Dim dURL   As Integer = Data.GetDBHeader("URL")
		  Dim dCats  As Integer = Data.GetDBHeader("Categories")
		  Dim dCat   As Integer = Data.GetDBHeader("Catalog")
		  Dim dPri   As Integer = Data.GetDBHeader("Priority")
		  Dim dDE    As Integer = Data.GetDBHeader("DECompatible")
		  Dim dPM    As Integer = Data.GetDBHeader("PMCompatible")
		  Dim dAC    As Integer = Data.GetDBHeader("ArchCompatible")
		  Dim dFlags As Integer = Data.GetDBHeader("Flags")
		  Dim dPath  As Integer = Data.GetDBHeader("PathApp")
		  Dim dTags  As Integer = Data.GetDBHeader("Tags")
		  Dim dPub   As Integer = Data.GetDBHeader("Publisher")
		  Dim dLang  As Integer = Data.GetDBHeader("Language")
		  Dim dRate  As Integer = Data.GetDBHeader("Rating")
		  Dim dPlay  As Integer = Data.GetDBHeader("Players")
		  Dim dLic   As Integer = Data.GetDBHeader("License")
		  Dim dDate  As Integer = Data.GetDBHeader("ReleaseDate")
		  Dim dRVer  As Integer = Data.GetDBHeader("ReleaseVersion")
		  Dim dBuild As Integer = Data.GetDBHeader("Builder")
		  Dim dSz    As Integer = Data.GetDBHeader("InstalledSize")
		  Dim dDeps  As Integer = Data.GetDBHeader("Dependencies")
		  Dim dFINI  As Integer = Data.GetDBHeader("FileINI")
		  Dim I As Integer
		  Dim R As Integer
		  For I = 0 To Data.Items.RowCount - 1
		    Dim ArchPath As String = ""
		    If dFINI >= 0 Then ArchPath = Data.Items.CellTextAt(I, dFINI)
		    If ArchPath = "" Then Continue
		    AllItemsListBox.AddRow("")
		    R = AllItemsListBox.LastAddedRowIndex
		    If dBT    >= 0 Then AllItemsListBox.CellTextAt(R, EAColBT)    = Data.Items.CellTextAt(I, dBT)
		    If dTitle >= 0 Then AllItemsListBox.CellTextAt(R, EAColTitle) = Data.Items.CellTextAt(I, dTitle)
		    If dVer   >= 0 Then AllItemsListBox.CellTextAt(R, EAColVer)   = Data.Items.CellTextAt(I, dVer)
		    If dDesc  >= 0 Then AllItemsListBox.CellTextAt(R, EAColDesc)  = Data.Items.CellTextAt(I, dDesc)
		    If dURL   >= 0 Then AllItemsListBox.CellTextAt(R, EAColURL)   = Data.Items.CellTextAt(I, dURL)
		    If dCats  >= 0 Then AllItemsListBox.CellTextAt(R, EAColCats)  = Data.Items.CellTextAt(I, dCats)
		    If dCat   >= 0 Then AllItemsListBox.CellTextAt(R, EAColCat)   = Data.Items.CellTextAt(I, dCat)
		    If dPri   >= 0 Then AllItemsListBox.CellTextAt(R, EAColPri)   = Data.Items.CellTextAt(I, dPri)
		    If dDE    >= 0 Then AllItemsListBox.CellTextAt(R, EAColDE)    = Data.Items.CellTextAt(I, dDE)
		    If dPM    >= 0 Then AllItemsListBox.CellTextAt(R, EAColPM)    = Data.Items.CellTextAt(I, dPM)
		    If dAC    >= 0 Then AllItemsListBox.CellTextAt(R, EAColAC)    = Data.Items.CellTextAt(I, dAC)
		    If dFlags >= 0 Then AllItemsListBox.CellTextAt(R, EAColFlags) = Data.Items.CellTextAt(I, dFlags)
		    If dPath  >= 0 Then AllItemsListBox.CellTextAt(R, EAColPath)  = Data.Items.CellTextAt(I, dPath)
		    If dTags  >= 0 Then AllItemsListBox.CellTextAt(R, EAColTags)  = Data.Items.CellTextAt(I, dTags)
		    If dPub   >= 0 Then AllItemsListBox.CellTextAt(R, EAColPub)   = Data.Items.CellTextAt(I, dPub)
		    If dLang  >= 0 Then AllItemsListBox.CellTextAt(R, EAColLang)  = Data.Items.CellTextAt(I, dLang)
		    If dRate  >= 0 Then AllItemsListBox.CellTextAt(R, EAColRate)  = Data.Items.CellTextAt(I, dRate)
		    If dPlay  >= 0 Then AllItemsListBox.CellTextAt(R, EAColPlay)  = Data.Items.CellTextAt(I, dPlay)
		    If dLic   >= 0 Then AllItemsListBox.CellTextAt(R, EAColLic)   = Data.Items.CellTextAt(I, dLic)
		    If dDate  >= 0 Then AllItemsListBox.CellTextAt(R, EAColDate)  = Data.Items.CellTextAt(I, dDate)
		    If dRVer  >= 0 Then AllItemsListBox.CellTextAt(R, EAColRVer)  = Data.Items.CellTextAt(I, dRVer)
		    If dBuild >= 0 Then AllItemsListBox.CellTextAt(R, EAColBuild) = Data.Items.CellTextAt(I, dBuild)
		    If dSz    >= 0 Then AllItemsListBox.CellTextAt(R, EAColSz)    = Data.Items.CellTextAt(I, dSz)
		    If dDeps  >= 0 Then AllItemsListBox.CellTextAt(R, EAColDeps)  = Data.Items.CellTextAt(I, dDeps)
		    AllItemsListBox.CellTextAt(R, EAColAP) = ArchPath
		    AllItemsListBox.CellTextAt(R, EAColTF) = ""
		    AllItemsListBox.CellTextAt(R, EAColDI) = ""
		    AllItemsListBox.CellTextAt(R, EAColDS) = ""
		  Next
		  EAIgnoreChange = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EASaveAll()
		  If EACurrentRow >= 0 Then EAFlushCurrentScripts
		  Dim TotalDirty As Integer = 0
		  Dim I As Integer
		  For I = 0 To AllItemsListBox.RowCount - 1
		    If AllItemsListBox.CellTextAt(I, EAColDI) = "T" Or AllItemsListBox.CellTextAt(I, EAColDS) = "T" Then
		      TotalDirty = TotalDirty + 1
		    End If
		  Next
		  If TotalDirty = 0 Then
		    EASetStatus("Nothing to save.")
		    MsgBox "No edited rows to save."
		    Return
		  End If
		  Dim Saved   As Integer = 0
		  Dim Failed  As Integer = 0
		  Dim FailLog As String  = ""
		  For I = 0 To AllItemsListBox.RowCount - 1
		    If AllItemsListBox.CellTextAt(I, EAColDI) = "T" Or AllItemsListBox.CellTextAt(I, EAColDS) = "T" Then
		      Dim Title As String = AllItemsListBox.CellTextAt(I, EAColTitle)
		      EASetStatus("Saving (" + Str(Saved + Failed + 1) + "/" + Str(TotalDirty) + "): " + Title + "...")
		      App.DoEvents(2)
		      If EASaveRow(I) Then
		        Saved = Saved + 1
		      Else
		        Failed  = Failed + 1
		        FailLog = FailLog + "  - " + Title + Chr(10)
		      End If
		    End If
		  Next
		  Dim Summary As String
		  If Failed = 0 Then
		    Summary = "Saved " + Saved.ToString + " item(s) successfully."
		  Else
		    Summary = "Saved " + Saved.ToString + ", FAILED " + Failed.ToString + ":" + Chr(10) + FailLog
		  End If
		  EASetStatus(Summary)
		  MsgBox Summary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EASaveRow(row As Integer) As Boolean
		  Dim BT          As String = AllItemsListBox.CellTextAt(row, EAColBT)
		  Dim ArchivePath As String = AllItemsListBox.CellTextAt(row, EAColAP)
		  Dim DirtyINI    As String = AllItemsListBox.CellTextAt(row, EAColDI)
		  Dim DirtyScript As String = AllItemsListBox.CellTextAt(row, EAColDS)
		  Dim IniFile     As String = EAGetIniFilename(BT)
		  If BT = "" Or ArchivePath = "" Or IniFile = "" Then Return False
		  If Not Exist(ArchivePath) Then
		    EASetStatus("ERROR: Archive not found: " + ArchivePath)
		    Return False
		  End If
		  EAExtractScripts(row)
		  Dim TF As String = Slash(AllItemsListBox.CellTextAt(row, EAColTF))
		  Dim SF1 As String = ""
		  Dim SF2 As String = ""
		  EAGetScriptFilenames(BT, SF1, SF2)
		  If DirtyINI = "T" Then
		    Dim IniText As String = EABuildIniText(row)
		    If IniText = "" Then
		      EASetStatus("ERROR: Failed to build ini for row " + Str(row+1))
		      Return False
		    End If
		    SaveDataToFile(IniText, TF + IniFile)
		  End If
		  If DirtyScript = "T" And row = EACurrentRow Then
		    If SF1 <> "" And Script1TextArea.Text.Trim <> "" Then
		      SaveDataToFile(Script1TextArea.Text, TF + SF1)
		    End If
		    If SF2 <> "" And Script1TextArea1.Text.Trim <> "" Then
		      SaveDataToFile(Script1TextArea1.Text, TF + SF2)
		    End If
		  End If
		  Dim Q As String = Chr(34)
		  Dim ScriptPath As String = Slash(TmpPath) + "ea_save_" + Randomiser.InRange(10000,20000).ToString + ".sh"
		  Dim ShScript As String = "#!/usr/bin/env bash" + Chr(10)
		  Dim Exten As String = Right(ArchivePath, 4).Lowercase
		  If Exten = ".tar" Then
		    ShScript = ShScript + "tar --delete -f " + Q + ArchivePath + Q + " " + Q + IniFile + Q + " 2>/dev/null" + Chr(10)
		    If SF1 <> "" Then ShScript = ShScript + "tar --delete -f " + Q + ArchivePath + Q + " " + Q + SF1 + Q + " 2>/dev/null" + Chr(10)
		    If SF2 <> "" Then ShScript = ShScript + "tar --delete -f " + Q + ArchivePath + Q + " " + Q + SF2 + Q + " 2>/dev/null" + Chr(10)
		    ShScript = ShScript + "cd " + Q + TF + Q + Chr(10)
		    ShScript = ShScript + "[ -f " + Q + IniFile + Q + " ] && tar -uf " + Q + ArchivePath + Q + " " + Q + IniFile + Q + Chr(10)
		    If SF1 <> "" Then ShScript = ShScript + "[ -f " + Q + SF1 + Q + " ] && tar -uf " + Q + ArchivePath + Q + " " + Q + SF1 + Q + Chr(10)
		    If SF2 <> "" Then ShScript = ShScript + "[ -f " + Q + SF2 + Q + " ] && tar -uf " + Q + ArchivePath + Q + " " + Q + SF2 + Q + Chr(10)
		  Else
		    ShScript = ShScript + "cd " + Q + TF + Q + Chr(10)
		    ShScript = ShScript + "[ -f " + Q + IniFile + Q + " ] && " + Linux7z + " u " + Q + ArchivePath + Q + " " + Q + IniFile + Q + Chr(10)
		    If SF1 <> "" Then ShScript = ShScript + "[ -f " + Q + SF1 + Q + " ] && " + Linux7z + " u " + Q + ArchivePath + Q + " " + Q + SF1 + Q + Chr(10)
		    If SF2 <> "" Then ShScript = ShScript + "[ -f " + Q + SF2 + Q + " ] && " + Linux7z + " u " + Q + ArchivePath + Q + " " + Q + SF2 + Q + Chr(10)
		  End If
		  ShScript = ShScript + "rm -f " + Q + ScriptPath + Q + Chr(10)
		  SaveDataToFile(ShScript, ScriptPath)
		  Dim SaveSh As New Shell
		  SaveSh.TimeOut = -1
		  SaveSh.Execute("bash " + Q + ScriptPath + Q)
		  Dim Buf As String = ""
		  Do
		    App.DoEvents(20)
		    Buf = Buf + SaveSh.ReadAll
		  Loop Until SaveSh.IsRunning = False
		  Buf = Buf + SaveSh.ReadAll
		  If Debugging Then Debug("EASaveRow [" + BT + "] " + AllItemsListBox.CellTextAt(row, EAColTitle) + ": " + Buf)
		  EAIgnoreChange = True
		  AllItemsListBox.CellTextAt(row, EAColDI) = ""
		  AllItemsListBox.CellTextAt(row, EAColDS) = ""
		  EAIgnoreChange = False
		  AllItemsListBox.Refresh
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EASelectRow(row As Integer)
		  If row < 0 Or row >= AllItemsListBox.RowCount Then Return
		  If EACurrentRow >= 0 And EACurrentRow <> row Then EAFlushCurrentScripts
		  EACurrentRow = row
		  Dim BT As String = AllItemsListBox.CellTextAt(row, EAColBT)
		  EAUpdateScriptLabels(BT)
		  EAExtractScripts(row)
		  EAIgnoreChange = True
		  
		  ' FIX BUG 1: Load description converting Chr(30) -> newlines for multiline editing
		  Dim DescRaw As String = AllItemsListBox.CellTextAt(row, EAColDesc)
		  DescriptionArea.Text = DescRaw.ReplaceAll(Chr(30), Chr(13))
		  
		  Dim TF As String = AllItemsListBox.CellTextAt(row, EAColTF)
		  Dim SF1 As String = ""
		  Dim SF2 As String = ""
		  EAGetScriptFilenames(BT, SF1, SF2)
		  If TF <> "" Then
		    Dim P1 As String = Slash(TF) + SF1
		    Dim P2 As String = Slash(TF) + SF2
		    Script1TextArea.Text  = If(SF1 <> "" And Exist(P1), LoadDataFromFile(P1), "")
		    Script1TextArea1.Text = If(SF2 <> "" And Exist(P2), LoadDataFromFile(P2), "")
		  Else
		    Script1TextArea.Text  = ""
		    Script1TextArea1.Text = ""
		  End If
		  EAIgnoreChange = False
		  EASetStatus("Row " + Str(row + 1) + ": " + AllItemsListBox.CellTextAt(row, EAColTitle) + " [" + BT + "]")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EASetStatus(msg As String)
		  StatusLabel.Text = msg
		  App.DoEvents(1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EASetupGrid()
		  EAColBT = 0
		  EAColTitle = 1
		  EAColVer = 2
		  EAColDesc = 3
		  EAColURL = 4
		  EAColCats = 5
		  EAColCat = 6
		  EAColPri = 7
		  EAColDE = 8
		  EAColPM = 9
		  EAColAC = 10
		  EAColFlags = 11
		  EAColPath = 12
		  EAColTags = 13
		  EAColPub = 14
		  EAColLang = 15
		  EAColRate = 16
		  EAColPlay = 17
		  EAColLic = 18
		  EAColDate = 19
		  EAColRVer = 20
		  EAColBuild = 21
		  EAColSz = 22
		  EAColDeps = 23
		  EAColAP = 24
		  EAColTF = 25
		  EAColDI = 26
		  EAColDS = 27
		  AllItemsListBox.RemoveAllRows
		  AllItemsListBox.ColumnCount = 28
		  AllItemsListBox.HeaderAt(EAColBT)    = "BuildType"
		  AllItemsListBox.HeaderAt(EAColTitle) = "TitleName"
		  AllItemsListBox.HeaderAt(EAColVer)   = "Version"
		  AllItemsListBox.HeaderAt(EAColDesc)  = "Description"
		  AllItemsListBox.HeaderAt(EAColURL)   = "URL"
		  AllItemsListBox.HeaderAt(EAColCats)  = "Categories"
		  AllItemsListBox.HeaderAt(EAColCat)   = "Catalog"
		  AllItemsListBox.HeaderAt(EAColPri)   = "Priority"
		  AllItemsListBox.HeaderAt(EAColDE)    = "DECompatible"
		  AllItemsListBox.HeaderAt(EAColPM)    = "PMCompatible"
		  AllItemsListBox.HeaderAt(EAColAC)    = "ArchCompatible"
		  AllItemsListBox.HeaderAt(EAColFlags) = "Flags"
		  AllItemsListBox.HeaderAt(EAColPath)  = "PathApp"
		  AllItemsListBox.HeaderAt(EAColTags)  = "Tags"
		  AllItemsListBox.HeaderAt(EAColPub)   = "Publisher"
		  AllItemsListBox.HeaderAt(EAColLang)  = "Language"
		  AllItemsListBox.HeaderAt(EAColRate)  = "Rating"
		  AllItemsListBox.HeaderAt(EAColPlay)  = "Players"
		  AllItemsListBox.HeaderAt(EAColLic)   = "License"
		  AllItemsListBox.HeaderAt(EAColDate)  = "ReleaseDate"
		  AllItemsListBox.HeaderAt(EAColRVer)  = "ReleaseVersion"
		  AllItemsListBox.HeaderAt(EAColBuild) = "Builder"
		  AllItemsListBox.HeaderAt(EAColSz)    = "InstalledSize"
		  AllItemsListBox.HeaderAt(EAColDeps)  = "Dependencies"
		  AllItemsListBox.HeaderAt(EAColAP)    = "ArchivePath"
		  AllItemsListBox.HeaderAt(EAColTF)    = "TempFolder"
		  AllItemsListBox.HeaderAt(EAColDI)    = "DirtyINI"
		  AllItemsListBox.HeaderAt(EAColDS)    = "DirtyScript"
		  ' FIX BUG 5: All columns at least wide enough to show full header text
		  ' Rule: header_chars * 8 + 16px padding (conservative for system font ~12pt)
		  AllItemsListBox.ColumnAttributesAt(EAColBT).WidthExpression    = "90"   ' "BuildType"      9ch
		  AllItemsListBox.ColumnAttributesAt(EAColTitle).WidthExpression = "200"  ' wide data column
		  AllItemsListBox.ColumnAttributesAt(EAColVer).WidthExpression   = "75"   ' "Version"        7ch
		  AllItemsListBox.ColumnAttributesAt(EAColDesc).WidthExpression  = "130"  ' "Description"    11ch
		  AllItemsListBox.ColumnAttributesAt(EAColURL).WidthExpression   = "80"   ' "URL"            3ch
		  AllItemsListBox.ColumnAttributesAt(EAColCats).WidthExpression  = "100"  ' "Categories"     10ch
		  AllItemsListBox.ColumnAttributesAt(EAColCat).WidthExpression   = "90"   ' "Catalog"        7ch
		  AllItemsListBox.ColumnAttributesAt(EAColPri).WidthExpression   = "80"   ' "Priority"       8ch  was 45
		  AllItemsListBox.ColumnAttributesAt(EAColDE).WidthExpression    = "115"  ' "DECompatible"   12ch was 75
		  AllItemsListBox.ColumnAttributesAt(EAColPM).WidthExpression    = "115"  ' "PMCompatible"   12ch was 75
		  AllItemsListBox.ColumnAttributesAt(EAColAC).WidthExpression    = "130"  ' "ArchCompatible" 14ch was 90
		  AllItemsListBox.ColumnAttributesAt(EAColFlags).WidthExpression = "90"   ' "Flags"          5ch
		  AllItemsListBox.ColumnAttributesAt(EAColPath).WidthExpression  = "100"  ' "PathApp"        7ch
		  AllItemsListBox.ColumnAttributesAt(EAColTags).WidthExpression  = "80"   ' "Tags"           4ch
		  AllItemsListBox.ColumnAttributesAt(EAColPub).WidthExpression   = "90"   ' "Publisher"      9ch  was 80
		  AllItemsListBox.ColumnAttributesAt(EAColLang).WidthExpression  = "80"   ' "Language"       8ch  was 50
		  AllItemsListBox.ColumnAttributesAt(EAColRate).WidthExpression  = "65"   ' "Rating"         6ch  was 40
		  AllItemsListBox.ColumnAttributesAt(EAColPlay).WidthExpression  = "75"   ' "Players"        7ch  was 40
		  AllItemsListBox.ColumnAttributesAt(EAColLic).WidthExpression   = "75"   ' "License"        7ch  was 40
		  AllItemsListBox.ColumnAttributesAt(EAColDate).WidthExpression  = "105"  ' "ReleaseDate"    11ch was 80
		  AllItemsListBox.ColumnAttributesAt(EAColRVer).WidthExpression  = "130"  ' "ReleaseVersion" 14ch was 60
		  AllItemsListBox.ColumnAttributesAt(EAColBuild).WidthExpression = "75"   ' "Builder"        7ch  was 65
		  AllItemsListBox.ColumnAttributesAt(EAColSz).WidthExpression    = "120"  ' "InstalledSize"  13ch was 65
		  AllItemsListBox.ColumnAttributesAt(EAColDeps).WidthExpression  = "115"  ' "Dependencies"   12ch was 80
		  AllItemsListBox.ColumnAttributesAt(EAColAP).WidthExpression    = "0"
		  AllItemsListBox.ColumnAttributesAt(EAColTF).WidthExpression    = "0"
		  AllItemsListBox.ColumnAttributesAt(EAColDI).WidthExpression    = "0"
		  AllItemsListBox.ColumnAttributesAt(EAColDS).WidthExpression    = "0"
		  Dim I As Integer
		  For I = 0 To 27
		    If I = EAColBT Or I >= EAColAP Then
		      AllItemsListBox.ColumnTypeAt(I) = DesktopListBox.CellTypes.Normal
		    Else
		      AllItemsListBox.ColumnTypeAt(I) = DesktopListBox.CellTypes.TextField
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EAUpdateScriptLabels(BT As String)
		  Select Case BT
		  Case "LLApp", "LLGame"
		    Script1Label.Text = "LLScript.sh"
		    Script2Label.Text = "LLScript_Sudo.sh"
		  Case "ssApp"
		    Script1Label.Text = "ssApp.cmd"
		    Script2Label.Text = "ssApp.reg"
		  Case "ppApp"
		    Script1Label.Text = "ppApp.cmd"
		    Script2Label.Text = "ppApp.reg"
		  Case "ppGame"
		    Script1Label.Text = "ppGame.cmd"
		    Script2Label.Text = "ppGame.reg"
		  Case Else
		    Script1Label.Text = "Script"
		    Script2Label.Text = "Sudo / Registry"
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LayoutControls()
		  ' Single method owns ALL positioning. Called from Opening, Resized, and separator drag.
		  ' This ensures the two script panels always split the width 50/50 with padding,
		  ' and that everything repositions correctly after a separator drag or window resize.
		  Const SepH       As Integer = 8
		  Const DescLblH   As Integer = 20
		  Const DescAreaH  As Integer = 70
		  Const ScriptLblH As Integer = 20
		  Const BtnH       As Integer = 26
		  Const StatusH    As Integer = 22
		  Const BottomPad  As Integer = 4
		  Const Gap        As Integer = 4  ' gap between the two script panels
		  
		  Dim W As Integer = Me.Width
		  Dim H As Integer = Me.Height
		  
		  ' Clamp separator so neither region becomes unusable
		  Dim MinSep As Integer = 60
		  Dim MaxSep As Integer = H - (SepH + DescLblH + DescAreaH + ScriptLblH + 60 + BtnH + StatusH + BottomPad)
		  If MaxSep < MinSep + 40 Then MaxSep = MinSep + 40
		  If EASepY < MinSep Then EASepY = MinSep
		  If EASepY > MaxSep Then EASepY = MaxSep
		  
		  ' --- Grid ---
		  AllItemsListBox.Left   = 0
		  AllItemsListBox.Top    = 0
		  AllItemsListBox.Width  = W
		  AllItemsListBox.Height = EASepY
		  
		  ' --- Separator bar ---
		  Separator1.Left  = 0
		  Separator1.Top   = EASepY
		  Separator1.Width = W
		  
		  ' --- Description area ---
		  Dim DescLblTop As Integer = EASepY + SepH
		  DescriptionLabel.Left  = 4
		  DescriptionLabel.Top   = DescLblTop
		  DescriptionLabel.Width = W - 8
		  
		  DescriptionArea.Left   = 0
		  DescriptionArea.Top    = DescLblTop + DescLblH
		  DescriptionArea.Width  = W
		  DescriptionArea.Height = DescAreaH
		  
		  ' --- Script labels and panels (FIX BUG 3: always 50/50 split) ---
		  Dim ScriptLblTop  As Integer = DescriptionArea.Top + DescAreaH + Gap
		  Dim HalfW         As Integer = (W - Gap) \ 2
		  
		  Script1Label.Left  = 0
		  Script1Label.Top   = ScriptLblTop
		  Script1Label.Width = HalfW
		  
		  Script2Label.Left  = HalfW + Gap
		  Script2Label.Top   = ScriptLblTop
		  Script2Label.Width = W - HalfW - Gap
		  
		  Dim ScriptTop    As Integer = ScriptLblTop + ScriptLblH
		  Dim ScriptBottom As Integer = H - BtnH - StatusH - BottomPad - Gap
		  Dim ScriptH      As Integer = ScriptBottom - ScriptTop
		  If ScriptH < 40 Then ScriptH = 40
		  
		  Script1TextArea.Left   = 0
		  Script1TextArea.Top    = ScriptTop
		  Script1TextArea.Width  = HalfW
		  Script1TextArea.Height = ScriptH
		  
		  Script1TextArea1.Left   = HalfW + Gap
		  Script1TextArea1.Top    = ScriptTop
		  Script1TextArea1.Width  = W - HalfW - Gap
		  Script1TextArea1.Height = ScriptH
		  
		  ' --- Bottom bar ---
		  Dim BtnTop As Integer = H - BtnH - BottomPad
		  SaveButton.Top  = BtnTop
		  SaveButton.Left = W - SaveButton.Width - Gap
		  
		  StatusLabel.Top   = BtnTop
		  StatusLabel.Left  = 0
		  StatusLabel.Width = W - SaveButton.Width - Gap * 2 - 4
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		EAColAC As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColAP As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColBT As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColBuild As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColCat As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColCats As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColDate As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColDE As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColDeps As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColDesc As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColDI As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColDS As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColFlags As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColLang As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColLic As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColPath As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColPlay As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColPM As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColPri As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColPub As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColRate As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColRVer As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColSz As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColTags As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColTF As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColTitle As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColURL As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAColVer As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EACurrentRow As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		EADragY As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EAIgnoreChange As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		EASepY As Integer = 220
	#tag EndProperty


#tag EndWindowCode

#tag Events AllItemsListBox
	#tag Event
		Function CellPressed(row As Integer, column As Integer, x As Integer, y As Integer) As Boolean
		  #PRAGMA unused column
		  #PRAGMA unused x
		  #PRAGMA unused y
		  EASelectRow(row)
		  Return False
		End Function
	#tag EndEvent
	#tag Event
		Sub CellTextChanged(row As Integer, column As Integer)
		  If EAIgnoreChange Then Return
		  If column >= EAColAP Then Return
		  If column = EAColBT Then Return
		  If column = EAColDesc Then Return  ' DescriptionArea.TextChanged handles this column
		  EAIgnoreChange = True
		  AllItemsListBox.CellTextAt(row, EAColDI) = "T"
		  EAIgnoreChange = False
		  AllItemsListBox.Refresh
		  Dim DirtyCount As Integer = 0
		  Dim I As Integer
		  For I = 0 To AllItemsListBox.RowCount - 1
		    If AllItemsListBox.CellTextAt(I, EAColDI) = "T" Or AllItemsListBox.CellTextAt(I, EAColDS) = "T" Then DirtyCount = DirtyCount + 1
		  Next
		  EASetStatus(DirtyCount.ToString + " row(s) edited.")
		End Sub
	#tag EndEvent
	#tag Event
		Function PaintCellBackground(g As Graphics, row As Integer, column As Integer) As Boolean
		  #PRAGMA unused column
		  If AllItemsListBox.RowCount = 0 Then Return False
		  If row >= AllItemsListBox.RowCount Then Return False
		  Dim IsDirtyINI    As Boolean = False
		  Dim IsDirtyScript As Boolean = False
		  Try
		    IsDirtyINI    = (AllItemsListBox.CellTextAt(row, EAColDI) = "T")
		    IsDirtyScript = (AllItemsListBox.CellTextAt(row, EAColDS) = "T")
		  Catch
		    Return False
		  End Try
		  Dim IsSelected As Boolean = AllItemsListBox.RowSelectedAt(row)
		  Dim IsAlt      As Boolean = (row Mod 2 = 0)
		  If IsDirtyINI And IsDirtyScript Then
		    g.DrawingColor = If(IsSelected, &cB05000, If(IsAlt, &c5A3000, &c3A2000))
		  ElseIf IsDirtyINI Then
		    g.DrawingColor = If(IsSelected, &cB08000, If(IsAlt, &c504000, &c363000))
		  ElseIf IsDirtyScript Then
		    g.DrawingColor = If(IsSelected, &c206020, If(IsAlt, &c1A3A1A, &c112411))
		  ElseIf IsSelected Then
		    g.DrawingColor = &c1E3A5F
		  Else
		    g.DrawingColor = If(IsAlt, &c1A1A1A, &c111111)
		  End If
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function PaintCellText(g as Graphics, row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  #PRAGMA unused x
		  #PRAGMA unused y
		  If AllItemsListBox.RowCount = 0 Then Return False
		  If row >= AllItemsListBox.RowCount Then Return False
		  If column >= EAColAP Then Return True
		  Dim IsDirty    As Boolean = False
		  Dim IsSelected As Boolean = AllItemsListBox.RowSelectedAt(row)
		  Try
		    IsDirty = (AllItemsListBox.CellTextAt(row, EAColDI) = "T" Or AllItemsListBox.CellTextAt(row, EAColDS) = "T")
		  Catch
		  End Try
		  If IsDirty Then
		    g.DrawingColor = If(IsSelected, &cFFEE88, &cFFDD44)
		    g.Bold = True
		  Else
		    g.DrawingColor = If(IsSelected, &cFFFFFF, &cCCCCCC)
		    g.Bold = False
		  End If
		  Dim CellText As String = AllItemsListBox.CellTextAt(row, column)
		  ' For Description column, show Chr(30) separators as " | " so content is readable inline
		  If column = EAColDesc Then CellText = CellText.ReplaceAll(Chr(30), " | ")
		  If Len(CellText) > 80 Then CellText = Left(CellText, 77) + "..."
		  g.DrawText(CellText, 3, g.Height - 2 - (g.Height / 6))
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events Separator1
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #PRAGMA unused x
		  ' Record where within the canvas bar the user clicked.
		  ' EADragY holds this fixed offset for the entire drag.
		  EADragY = y
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  #PRAGMA unused x
		  ' Convert to window-Y: Separator1.Top is updated by LayoutControls each frame,
		  ' so (Separator1.Top + y) is always the true mouse position in window coordinates.
		  ' Subtracting the fixed click offset gives the correct new canvas top — no feedback loop.
		  EASepY = Separator1.Top + y - EADragY
		  LayoutControls()
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  Me.MouseCursor = System.Cursors.SplitterNorthSouth
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  Me.MouseCursor = System.Cursors.StandardPointer
		End Sub
	#tag EndEvent
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #PRAGMA unused areas
		  ' Draw drag handle bar: dark background with lighter grip dots in the centre
		  g.DrawingColor = Color.RGB(68, 68, 68)
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  g.DrawingColor = Color.RGB(100, 100, 100)
		  g.DrawLine(0, 0, g.Width, 0)
		  g.DrawingColor = Color.RGB(140, 140, 140)
		  Dim cx As Integer = g.Width \ 2
		  Dim cy As Integer = g.Height \ 2
		  Dim i As Integer
		  For i = -56 To 56 Step 10
		    g.FillOval(cx + i, cy - 1, 4, 3)
		  Next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DescriptionArea
	#tag Event
		Sub TextChanged()
		  ' FIX BUG 1: Encode newlines back to Chr(30) and store in grid cell, mark row dirty
		  If EAIgnoreChange Then Return
		  If EACurrentRow < 0 Then Return
		  Dim DescText As String = DescriptionArea.Text
		  DescText = DescText.ReplaceAll(Chr(13) + Chr(10), Chr(30))  ' Windows CRLF
		  DescText = DescText.ReplaceAll(Chr(13), Chr(30))             ' lone CR (Xojo TextArea line sep)
		  DescText = DescText.ReplaceAll(Chr(10), Chr(30))             ' lone LF
		  EAIgnoreChange = True
		  AllItemsListBox.CellTextAt(EACurrentRow, EAColDesc) = DescText
		  AllItemsListBox.CellTextAt(EACurrentRow, EAColDI)   = "T"
		  EAIgnoreChange = False
		  AllItemsListBox.Refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Script1TextArea
	#tag Event
		Sub TextChanged()
		  If EAIgnoreChange Then Return
		  If EACurrentRow < 0 Then Return
		  EAIgnoreChange = True
		  AllItemsListBox.CellTextAt(EACurrentRow, EAColDS) = "T"
		  EAIgnoreChange = False
		  AllItemsListBox.Refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Script1TextArea1
	#tag Event
		Sub TextChanged()
		  If EAIgnoreChange Then Return
		  If EACurrentRow < 0 Then Return
		  EAIgnoreChange = True
		  AllItemsListBox.CellTextAt(EACurrentRow, EAColDS) = "T"
		  EAIgnoreChange = False
		  AllItemsListBox.Refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SaveButton
	#tag Event
		Sub Pressed()
		  EASaveAll
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
		InitialValue="700"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="550"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="640"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="450"
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
		InitialValue="Edit All Items"
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
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="False"
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
		Name="EACurrentRow"
		Visible=false
		Group="Behavior"
		InitialValue="-1"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAIgnoreChange"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EASepY"
		Visible=false
		Group="Behavior"
		InitialValue="220"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EADragY"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColBT"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColTitle"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColVer"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColDesc"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColURL"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColCats"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColCat"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColPri"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColDE"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColPM"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColAC"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColFlags"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColPath"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColTags"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColPub"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColLang"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColRate"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColPlay"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColLic"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColDate"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColRVer"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColBuild"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColSz"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColDeps"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColAP"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColTF"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColDI"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EAColDS"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
