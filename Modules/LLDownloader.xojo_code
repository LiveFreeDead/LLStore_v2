#tag Module
Protected Module LLDownloader
	#tag Method, Flags = &h0
		Sub GetOnlineFile(URL As String, OutPutFile As String)
		  Dim I As Integer
		  
		  'Nothing to fetch or nowhere to put it, don't queue a job that can only fail
		  If URL.Trim = "" Or OutPutFile.Trim = "" Then Return
		  
		  ' Check if queue is full
		  If QueueCount >= 1024 Then
		    Debug("Download queue is full. Cannot add: " + URL)
		    Return
		  End If
		  
		  If QueueCount >= 1 Then
		    'Only skip a URL that is still waiting or being downloaded right now. One that has already been processed in this run
		    'must be queueable again, or a retry of a failed download would be ignored while other jobs keep the queue alive.
		    Dim FirstPending As Integer = QueueUpTo
		    If FirstPending < 0 Then FirstPending = 0
		    If FirstPending <= QueueCount - 1 Then
		      For I = FirstPending To QueueCount - 1
		        If QueueURL(I) = URL Then Return 'Skip existing URL download already queued up
		      Next
		    End If
		  End If
		  QueueURL(QueueCount) = URL
		  QueueLocal(QueueCount) = OutPutFile
		  QueueCount = QueueCount + 1
		  If Downloading = False Then
		    Downloading = True 'Do this ASAP, so the check is in place as soon as it's sent (as most wont have a wait at the end of the shell calls)  
		    Loading.DownloadTimer.RunMode = Timer.RunModes.Multiple  'Use Multiple so the state machine keeps ticking until the queue is empty
		  End If
		End Sub
	#tag EndMethod


	#tag Method, Flags = &h0
		Function ArchiveLooksValid(PartialPath As String) As Boolean
		  ' True when the file starts like a real 7z, gzip or tar archive, the same test the normal downloader does with its magic-byte check.
		  Dim Valid As Boolean = False
		  #Pragma BreakOnExceptions False
		  Try
		    Dim F As FolderItem = GetFolderItem(PartialPath, FolderItem.PathTypeNative)
		    If F <> Nil Then
		      If F.Exists And F.Length > 2 Then
		        Dim ReadLen As Integer = 512
		        If F.Length < ReadLen Then ReadLen = F.Length
		        Dim BS As BinaryStream = BinaryStream.Open(F, False)
		        Dim Head As String = BS.Read(ReadLen)
		        BS.Close
		        Dim B1 As Integer = AscB(MidB(Head, 1, 1))
		        Dim B2 As Integer = AscB(MidB(Head, 2, 1))
		        If B1 = &h37 And B2 = &h7A Then Valid = True '7z
		        If B1 = &h1F And B2 = &h8B Then Valid = True 'gzip
		        If InStrB(Head, "ustar") > 0 Then Valid = True 'tar
		      End If
		    End If
		  Catch
		    Valid = False
		  End Try
		  #Pragma BreakOnExceptions True
		  Return Valid
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CancelPrefetch()
		  ' Stops every look-ahead download (installer closed, finished or starting a new run) and removes what they left behind. Never raises.
		  Dim S As Integer
		  For S = 0 To PrefetchActive.LastIndex
		    CancelPrefetchSlot(S)
		  Next
		  PrefetchTried = Nil 'Every installer run starts with a clean sheet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CancelPrefetchSlot(S As Integer)
		  ' Stops ONE look-ahead download and removes what it left behind (its item was skipped, or the installer is closing). Never raises.
		  If S < 0 Or S > PrefetchActive.LastIndex Then Return
		  If Not PrefetchActive(S) Then Return
		  If PrefetchPolling Then Return 'That slot is in the middle of being finished off (see PollPrefetch), it frees itself in a moment
		  Dim LocalFile As String = PrefetchLocal(S)
		  #Pragma BreakOnExceptions False
		  Try
		    StopCurl(PrefetchShell(S), LocalFile + ".prefetch") 'Also removes the .prefetch file
		  Catch
		  End Try
		  #Pragma BreakOnExceptions True
		  RemovePrefetchFiles(LocalFile)
		  PrefetchActive(S) = False
		  PrefetchLocal(S) = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePrefetchFiles(LocalFile As String)
		  ' Removes the temp files a look-ahead download leaves next to its target file. Never raises.
		  Dim Ext(2) As String
		  Ext(0) = ".prefetch"
		  Ext(1) = ".prefetchflag"
		  Ext(2) = ".prefetchhdr"
		  Dim E As Integer
		  #Pragma BreakOnExceptions False
		  For E = 0 To 2
		    Try
		      RemoveFileQuick(LocalFile + Ext(E))
		    Catch
		    End Try
		  Next
		  #Pragma BreakOnExceptions True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveFileQuick(Path As String)
		  ' Deletes ONE file straight away with FolderItem.Remove (no shell is started, so it is instant and can't re-enter the timers through App.DoEvents).
		  ' Only if that fails (file held open for a moment, odd permissions) does it fall back to Deltree. Never raises.
		  If Path.Trim = "" Then Return
		  #Pragma BreakOnExceptions False
		  Try
		    Dim F As FolderItem = GetFolderItem(Path, FolderItem.PathTypeNative)
		    If F <> Nil Then
		      If F.Exists Then
		        If Not F.IsFolder Then F.Remove
		      End If
		    End If
		  Catch
		  End Try
		  Try
		    If Exist(Path) Then Deltree(Path)
		  Catch
		  End Try
		  #Pragma BreakOnExceptions True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrefetchSlotFor(LocalFile As String) As Integer
		  ' Which look-ahead slot is fetching this file right now, -1 if none.
		  Dim S As Integer
		  Dim Want As String = LocalFile.ReplaceAll("\", "/").Lowercase
		  For S = 0 To PrefetchActive.LastIndex
		    If PrefetchActive(S) Then
		      If PrefetchLocal(S).ReplaceAll("\", "/").Lowercase = Want Then Return S
		    End If
		  Next
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrefetchBusyFor(LocalFile As String) As Boolean
		  ' True while a look-ahead download is still fetching this file, so the normal downloader must wait for it instead of fetching it a second time.
		  Return (PrefetchSlotFor(LocalFile) >= 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrefetchActiveCount() As Integer
		  ' How many look-ahead downloads are running right now.
		  Dim S, N As Integer
		  For S = 0 To PrefetchActive.LastIndex
		    If PrefetchActive(S) Then N = N + 1
		  Next
		  Return N
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrefetchWasTried(LocalFile As String) As Boolean
		  ' A file only gets ONE look-ahead attempt per installer run. If it failed, the installer downloads it the normal way (with its own retries) when it gets there.
		  If PrefetchTried Is Nil Then Return False
		  Return PrefetchTried.HasKey(LocalFile)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrefetchProgressFor(LocalFile As String) As String
		  ' Progress text for the look-ahead download that is fetching this file, in the same form the normal downloader shows it: "45%", or "1200 KB" when the size isn't known.
		  ' "" until the first data has arrived. It only reads files and never writes any GUI, so the Mini Installer's timer can call it and show the text itself.
		  Dim S As Integer = PrefetchSlotFor(LocalFile)
		  If S < 0 Then Return ""
		  
		  Dim CurrentBytes As Int64 = 0
		  #Pragma BreakOnExceptions False
		  Try
		    Dim PartialPath As String = PrefetchLocal(S) + ".prefetch"
		    If Exist(PartialPath) Then
		      Dim PF As FolderItem = GetFolderItem(PartialPath, FolderItem.PathTypeNative)
		      If PF <> Nil Then CurrentBytes = PF.Length
		    End If
		    
		    'The size comes from the response headers curl dumped into .prefetchhdr. The LAST response in that file is the real file (earlier ones are redirects),
		    'and only a 200/206 one counts, so a redirect's tiny Content-Length is never mistaken for the file size.
		    If PrefetchTotal(S) <= 0 And Not PrefetchHdrDone(S) Then
		      Dim HdrPath As String = PrefetchLocal(S) + ".prefetchhdr"
		      If Exist(HdrPath) Then
		        Dim Hdr As String = LoadDataFromFile(HdrPath)
		        'Walk to the LAST status line (a line starting with HTTP/). Earlier ones are redirects. Uses only IndexOf/Mid, no Split.
		        Dim HdrSep As String = Chr(10) + "HTTP/"
		        Dim LastResp As String = Chr(10) + Hdr
		        Dim HdrFound As Boolean = False
		        Dim HdrPos As Integer = LastResp.IndexOf(HdrSep)
		        While HdrPos >= 0
		          LastResp = Mid(LastResp, HdrPos + Len(HdrSep) + 1)
		          HdrFound = True
		          HdrPos = LastResp.IndexOf(HdrSep)
		        Wend
		        If HdrFound Then
		          Dim StatusStart As String = Left(LastResp, 20)
		          If StatusStart.IndexOf(" 200") >= 0 Or StatusStart.IndexOf(" 206") >= 0 Then
		            PrefetchHdrDone(S) = True 'The real response has arrived, no need to read the file again even if it had no Content-Length
		            Dim CLPos As Integer = LastResp.Lowercase.IndexOf("content-length:")
		            If CLPos >= 0 Then
		              Dim CLRest As String = Mid(LastResp, CLPos + 16)
		              Dim CLEnd As Integer = CLRest.IndexOf(Chr(10))
		              If CLEnd >= 0 Then CLRest = Left(CLRest, CLEnd)
		              PrefetchTotal(S) = CLRest.Trim.Val
		            End If
		          End If
		        End If
		      End If
		    End If
		  Catch
		  End Try
		  #Pragma BreakOnExceptions True
		  
		  If CurrentBytes <= 0 Then Return ""
		  If PrefetchTotal(S) > 0 Then
		    Dim Pct As Integer = CType(CurrentBytes / PrefetchTotal(S) * 100, Integer)
		    If Pct > 100 Then Pct = 100
		    Return Str(Pct) + "%"
		  End If
		  Return Str(CurrentBytes \ 1024) + " KB"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PollPrefetch()
		  ' Checks on the look-ahead downloads. A finished one with a good file is moved into place and marked as fetched, exactly like a normal download.
		  ' A failed or broken one is thrown away and nothing else is affected, the installer just downloads that item the normal way when it gets to it.
		  'Re-entrancy guard. Finishing a download runs shell commands (move, Deltree) that call App.DoEvents while they wait, which lets the installer timer fire PrefetchNext
		  'and so PollPrefetch again, in the middle of this one. In Windows (cmd is slow to start) that nested call saw the same half-finished slot, freed it, started a NEW
		  'download in it, and then the outer call carried on and wiped that new download's slot, leaving it orphaned (.prefetch/.prefetchflag/.prefetchhdr never moved or removed).
		  If PrefetchPolling Then Return
		  PrefetchPolling = True
		  Dim S As Integer
		  #Pragma BreakOnExceptions False
		  Try
		    For S = 0 To PrefetchActive.LastIndex
		      If PrefetchActive(S) Then PollPrefetchSlot(S)
		    Next
		  Catch
		  End Try
		  #Pragma BreakOnExceptions True
		  PrefetchPolling = False 'Always released, even if something above failed, or look-ahead would stay stuck for the rest of the run
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PollPrefetchSlot(S As Integer)
		  ' Checks on ONE look-ahead download, see PollPrefetch.
		  If PrefetchShell(S) Is Nil Then
		    PrefetchActive(S) = False
		    PrefetchLocal(S) = ""
		    Return
		  End If
		  
		  Dim LocalFile As String = PrefetchLocal(S)
		  Dim Discard As String = PrefetchShell(S).ReadAll 'Keep the pipe empty
		  Dim PartialPath As String = LocalFile + ".prefetch"
		  Dim FlagPath As String = LocalFile + ".prefetchflag"
		  Dim Finished As Boolean = False
		  Dim DownloadOK As Boolean = False
		  Dim FlagTxt As String = ""
		  
		  If Exist(FlagPath) Then
		    #Pragma BreakOnExceptions False
		    Try
		      FlagTxt = LoadDataFromFile(FlagPath).Trim
		    Catch
		      FlagTxt = "" 'Still being written, look again next tick
		    End Try
		    #Pragma BreakOnExceptions True
		    If FlagTxt <> "" Then
		      Finished = True
		      DownloadOK = (FlagTxt.IndexOf("done") >= 0)
		    End If
		  End If
		  
		  If Not Finished Then
		    If Not PrefetchShell(S).IsRunning Then 'Ended without a flag (killed), only trust a clean exit
		      Finished = True
		      DownloadOK = (PrefetchShell(S).ExitCode = 0)
		    End If
		  End If
		  
		  If Not Finished Then Return 'Still downloading
		  
		  Dim Good As Boolean = False
		  If DownloadOK And Exist(PartialPath) Then
		    If DownloadLooksValid(PartialPath) Then
		      If PrefetchArchive(S) Then
		        Good = ArchiveLooksValid(PartialPath)
		      Else
		        Good = True
		      End If
		    End If
		  End If
		  
		  If Good Then
		    'Rename it into place the instant it has finished, so anyone watching the folder can take the file straight away. It is in the same folder, so this is only a name
		    'change (no copying, no shell). The target is cleared first, same as the normal downloader: a small leftover/stub of the file there would otherwise make the
		    'Exist() check below say "moved" when it was not.
		    Dim Moved As Boolean = False
		    RemoveFileQuick(LocalFile)
		    #Pragma BreakOnExceptions False
		    Try
		      Dim RenSrc As FolderItem = GetFolderItem(PartialPath, FolderItem.PathTypeNative)
		      Dim RenDst As FolderItem = GetFolderItem(LocalFile, FolderItem.PathTypeNative)
		      If RenSrc <> Nil And RenDst <> Nil Then
		        If RenSrc.Exists And Not RenDst.Exists Then RenSrc.Name = RenDst.Name
		      End If
		    Catch
		    End Try
		    #Pragma BreakOnExceptions True
		    Moved = (Exist(LocalFile) And Not Exist(PartialPath))
		    
		    'Last resort, the old shell move (only after several tries, it is slow and re-enters the timers while it waits)
		    If Not Moved And PrefetchMoveTries(S) >= 10 Then
		      Dim Q As String = Chr(34)
		      Dim Mv As New Shell
		      Mv.TimeOut = -1
		      Mv.ExecuteMode = Shell.ExecuteModes.Synchronous
		      If TargetWindows Then
		        Mv.Execute("move /y " + Q + PartialPath.ReplaceAll("/", "\") + Q + " " + Q + LocalFile.ReplaceAll("/", "\") + Q)
		      Else
		        Mv.Execute("mv -f " + Q + PartialPath + Q + " " + Q + LocalFile + Q)
		      End If
		      Moved = (Exist(LocalFile) And Not Exist(PartialPath))
		    End If
		    
		    If Moved Then
		      MarkFetched(LocalFile)
		      If Debugging Then Debug("Prefetch successful: " + PrefetchURL(S))
		    Else
		      'Something (a virus scanner looking at the new file, usually) may be holding it for a moment. Keep the slot and look again on the next tick instead of throwing away a good download.
		      PrefetchMoveTries(S) = PrefetchMoveTries(S) + 1
		      If PrefetchMoveTries(S) < 20 Then Return
		      Good = False 'Still can't, so it is not there for the installer
		    End If
		  End If
		  
		  If Not Good Then
		    If Debugging Then Debug("* Prefetch failed or not a good file, it will be downloaded normally: " + PrefetchURL(S))
		  End If
		  RemovePrefetchFiles(LocalFile) 'Whatever is left of the .prefetch (a failed one), the flag and the header dump
		  
		  PrefetchActive(S) = False
		  PrefetchLocal(S) = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartPrefetch(URL As String, LocalFile As String, ItemRow As Integer)
		  ' Starts a download beside the normal downloader for an item the installer will need soon, so it is already on disk when its turn comes.
		  ' There are two slots. Each has its own curl shell and its own .prefetch/.prefetchflag/.prefetchhdr files, so they can't collide with the normal download state machine.
		  ' The CALLER keeps the total at two downloads (the normal downloader counts as one while it is busy), and a file only ever gets one attempt per installer run.
		  If Not PrefetchEnabled Then Return
		  If URL.Trim = "" Or LocalFile.Trim = "" Then Return
		  If PrefetchSlotFor(LocalFile) >= 0 Then Return 'Already being fetched
		  
		  Dim S, Slot As Integer
		  Slot = -1
		  For S = 0 To PrefetchActive.LastIndex
		    If Not PrefetchActive(S) Then
		      Slot = S
		      Exit
		    End If
		  Next
		  If Slot < 0 Then Return 'Both slots busy
		  
		  Dim GetURL As String = URL
		  Dim I As Integer
		  
		  'Same mirror override (WebLinks) the normal downloader uses
		  If WebLinksCount >= 1 Then
		    Dim LocalName As String = Replace(LocalFile, Slash(RepositoryPathLocal), "")
		    For I = 0 To WebLinksCount - 1
		      If WebLinksName(I) = LocalName Then
		        GetURL = WebLinksLink(I)
		        Exit For
		      End If
		    Next
		  End If
		  
		  'The folder it goes into has to exist, curl can't make it
		  Dim OutDir As String = SafeParentPath(LocalFile)
		  If OutDir <> "" And OutDir <> "/" Then
		    If Not Exist(OutDir) Then MakeFolder(OutDir)
		  End If
		  
		  RemovePrefetchFiles(LocalFile) 'Anything left over from an earlier crashed run
		  
		  If PrefetchTried Is Nil Then PrefetchTried = New Dictionary
		  PrefetchTried.Value(LocalFile) = True
		  
		  PrefetchArchive(Slot) = (GetURL.Lowercase.IndexOf(".apz") >= 0 Or GetURL.Lowercase.IndexOf(".pgz") >= 0 Or GetURL.Lowercase.IndexOf(".tar") >= 0)
		  PrefetchURL(Slot) = GetURL
		  PrefetchLocal(Slot) = LocalFile
		  PrefetchRow(Slot) = ItemRow
		  PrefetchTotal(Slot) = 0
		  PrefetchHdrDone(Slot) = False
		  PrefetchMoveTries(Slot) = 0
		  
		  PrefetchShell(Slot) = New Shell
		  PrefetchShell(Slot).TimeOut = -1
		  PrefetchShell(Slot).ExecuteMode = Shell.ExecuteModes.Asynchronous
		  PrefetchActive(Slot) = True
		  If Debugging Then Debug("Prefetch starting: " + GetURL)
		  PrefetchShell(Slot).Execute(BuildDownloadCommand(GetURL, LocalFile + ".prefetch", LocalFile + ".prefetchflag", 0, LocalFile + ".prefetchhdr"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BuildDownloadCommand(URL As String, PartialPath As String, FlagPath As String, MaxTimeSecs As Integer = 0, HeaderPath As String = "") As String
		  ' One shared command for every queued download, same syntax in Windows (cmd) and Linux (sh).
		  '  --fail            a 404/500 is an error, the error page is NOT saved as if it were the file
		  '  --retry 3         transient errors are retried by curl itself
		  '  --speed-limit/time give up on a connection that is dead (under 500 bytes/s for 90 seconds) so it can never hang forever
		  ' The flag file holds "done" only when curl succeeded and "fail" when it did not, so a broken download is never treated as good.
		  Dim CurlBin As String = LinuxCurl
		  If TargetWindows Then CurlBin = WinCurl
		  If CurlBin.Trim = "" Then CurlBin = "curl"
		  
		  Dim MaxTimePart As String = ""
		  If MaxTimeSecs > 0 Then MaxTimePart = " --max-time " + MaxTimeSecs.ToString 'Optional hard limit for small files such as the databases
		  Dim HeaderPart As String = ""
		  If HeaderPath <> "" Then HeaderPart = " -D " + Chr(34) + HeaderPath + Chr(34) 'Optional dump of the response headers, the look-ahead download reads the file size from it for its progress
		  
		  Dim Cmd As String
		  Cmd = CurlBin + " -L -s --fail --retry 3 --connect-timeout 9 --speed-limit 500 --speed-time 90" + MaxTimePart + HeaderPart + " -o " + Chr(34) + PartialPath + Chr(34) + _
		  " " + Chr(34) + URL + Chr(34) + _
		  " && echo done > " + Chr(34) + FlagPath + Chr(34) + _
		  " || echo fail > " + Chr(34) + FlagPath + Chr(34)
		  Return Cmd
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MarkFetched(LocalFile As String)
		  ' Remember that this file was downloaded successfully during this session
		  If FetchedFiles Is Nil Then FetchedFiles = New Dictionary
		  FetchedFiles.Value(LocalFile) = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WasFetched(LocalFile As String) As Boolean
		  If FetchedFiles Is Nil Then Return False
		  Return FetchedFiles.HasKey(LocalFile)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DownloadLooksValid(PartialPath As String) As Boolean
		  ' False for an empty file, and for a web page (error page, quota page, login page) that a host sent with a 200 OK
		  ' instead of the real file. Nothing we download is ever an HTML page, so this never rejects a real file.
		  Dim Valid As Boolean = False
		  #Pragma BreakOnExceptions False
		  Try
		    Dim F As FolderItem = GetFolderItem(PartialPath, FolderItem.PathTypeNative)
		    If F <> Nil Then
		      If F.Exists Then
		        If F.Length > 0 Then
		          Valid = True
		          Dim ReadLen As Integer = 512
		          If F.Length < ReadLen Then ReadLen = F.Length
		          Dim BS As BinaryStream = BinaryStream.Open(F, False)
		          Dim Head As String = BS.Read(ReadLen)
		          BS.Close
		          If InStrB(Head, "<html") > 0 Or InStrB(Head, "<HTML") > 0 Or InStrB(Head, "<Html") > 0 Then Valid = False
		          If InStrB(Head, "<!doctype") > 0 Or InStrB(Head, "<!DOCTYPE") > 0 Or InStrB(Head, "<!Doctype") > 0 Then Valid = False
		        End If
		      End If
		    End If
		  Catch
		    Valid = False
		  End Try
		  #Pragma BreakOnExceptions True
		  Return Valid
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopCurl(Sh As Shell, PartialPath As String)
		  ' Stops a running download and removes what it left behind. Never raises, it is used on cancel, stall and error paths.
		  #Pragma BreakOnExceptions False
		  Try
		    If Sh <> Nil Then
		      If Sh.IsRunning Then Sh.Close
		    End If
		  Catch
		  End Try
		  
		  Try
		    Dim K As New Shell
		    K.TimeOut = 5000
		    If TargetWindows Then
		      K.Execute("TaskKill /IM curl.exe /F")
		    Else
		      'Closing the shell only ends the sh wrapper, curl itself can keep running. Stop the curl that is writing THIS file only.
		      Dim Pat As String = PartialPath
		      Dim Specials As String = "\.[](){}*+?^$|"
		      Dim Esc As String = ""
		      Dim C As Integer
		      For C = 1 To Pat.Length
		        Dim Ch As String = Pat.Middle(C - 1, 1)
		        If Specials.IndexOf(Ch) >= 0 Then Esc = Esc + "\"
		        Esc = Esc + Ch
		      Next
		      Esc = Esc.ReplaceAll("'", "'\''")
		      K.Execute("pkill -f '[c]url .*" + Esc + "'")
		    End If
		  Catch
		  End Try
		  
		  Try
		    If PartialPath <> "" Then
		      If Exist(PartialPath) Then Deltree(PartialPath)
		    End If
		  Catch
		  End Try
		  #Pragma BreakOnExceptions True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartParallelDownload(URLs() As String, Locals() As String, Count As Integer, DoneFlag As String, ByRef ParallelShell As Shell)
		  ' Fires all downloads simultaneously using a single curl --parallel command.
		  ' Each file downloads to LocalPath.partial - caller renames on completion.
		  ' Writes DoneFlag when finished so the caller can poll without a busy-wait.
		  ' Falls back gracefully: if Count <= 1 just use the normal queue via GetOnlineFile.
		  
		  Dim I As Integer
		  Dim Pairs As String = ""
		  Dim Cmd As String
		  
		  ' Nothing to do – return early so DoneFlag is never left un-written.
		  If Count <= 0 Then Return
		  
		  For I = 0 To Count - 1
		    If URLs(I).Trim = "" Then Continue
		    Pairs = Pairs + " -o " + Chr(34) + Locals(I) + ".partial" + Chr(34) + " " + Chr(34) + URLs(I) + Chr(34)
		  Next
		  
		  If Pairs.Trim = "" Then Return
		  
		  ' -L: follow redirects (matches wget default - required for some hosts)
		  ' --parallel-immediate: start all transfers simultaneously rather than in batches
		  ' --retry 3: retry failed downloads up to 3 times
		  ' --connect-timeout 9: don't hang on unresponsive servers
		  ' Use the resolved curl path set at startup (WinCurl/LinuxCurl) - not bare "curl"
		  Dim CurlBin As String = LinuxCurl
		  If TargetWindows Then CurlBin = WinCurl
		  Dim CurlBase As String = CurlBin + " -L --parallel --parallel-immediate --retry 3 --connect-timeout 9 --fail --max-time 180 -s"
		  
		  If TargetWindows Then
		    Cmd = CurlBase + Pairs + " && echo done > " + Chr(34) + DoneFlag + Chr(34)
		  Else
		    Cmd = CurlBase + Pairs + " ; echo done > " + Chr(34) + DoneFlag + Chr(34)
		  End If
		  
		  ParallelShell.Execute(Cmd)
		End Sub
	#tag EndMethod

	#tag Property, Flags = &h0
		CurrentDBURL As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FetchedFiles As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Downloading As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DownloadPercentage As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FailedDownload As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		QueueCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		QueueLocal(1024) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		QueueUpTo As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		QueueURL(1024) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		' Look-ahead download slots (two). A slot is in use while PrefetchActive(S) is True, see StartPrefetch and PollPrefetch
		PrefetchActive(1) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		PrefetchArchive(1) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		' Set to False to switch the look-ahead downloads off completely, everything then downloads one at a time like before
		PrefetchEnabled As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		' True once the real (200/206) response headers of what each slot is fetching have been read
		PrefetchHdrDone(1) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		PrefetchLocal(1) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		' How many times each slot has tried to rename its finished download into place (see PollPrefetchSlot)
		PrefetchMoveTries(1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		' True while PollPrefetch is running, so it can't be re-entered through App.DoEvents (see PollPrefetch)
		PrefetchPolling As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		' Mini Installer queue row each slot is fetching for
		PrefetchRow(1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PrefetchShell(1) As Shell
	#tag EndProperty

	#tag Property, Flags = &h0
		' File size of what each slot is fetching (0 = not known yet), for the progress percentage
		PrefetchTotal(1) As Int64
	#tag EndProperty

	#tag Property, Flags = &h0
		' Files that already had their one look-ahead attempt in this installer run
		PrefetchTried As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		PrefetchURL(1) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WebLinksCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		WebLinksLink(4096) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WebLinksName(4096) As String
	#tag EndProperty


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
			Name="FailedDownload"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Downloading"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DownloadPercentage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueUpTo"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentDBURL"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WebLinksCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
