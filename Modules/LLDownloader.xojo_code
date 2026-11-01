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
		Function BuildDownloadCommand(URL As String, PartialPath As String, FlagPath As String, MaxTimeSecs As Integer = 0) As String
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
		  
		  Dim Cmd As String
		  Cmd = CurlBin + " -L -s --fail --retry 3 --connect-timeout 9 --speed-limit 500 --speed-time 90" + MaxTimePart + " -o " + Chr(34) + PartialPath + Chr(34) + _
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
