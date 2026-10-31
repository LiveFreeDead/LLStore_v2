#tag Class
Protected Class LLStore
Inherits DesktopApplication
	#tag Event
		Sub Closing()
		  #Pragma BreakOnExceptions Off
		  Try
		    If mMutex <> Nil Then
		      mMutex.Leave
		      mMutex = Nil  ' Clean up reference
		    End If
		  Catch err As RuntimeException
		    Debug("Error releasing mutex: " + err.Message)
		  End Try
		  #Pragma BreakOnExceptions On
		  Debug("-- LLStore Closed")
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  ProtectFonts()
		  mMutex = New Mutex(App.ExecutableFile.Name) 
		  If Not mMutex.TryEnter Then 
		    'MessageBox("Application already running")
		    'Quit
		  Else 'Clean Temp if it's the only instance
		    CleanTempFolders = True
		  End  If
		  
		  
		  Debug("-- LLStore Opening")
		  Loading.VeryFirstRunTimer.RunMode = Timer.RunModes.Single ' Do it this way instead, might fix quit bug
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  'Log it and keep running, rather than closing the app on the first stray error.
		  'If errors pour out in a loop (more than 25 in 5 seconds) let the app close normally instead of freezing in an endless loop.
		  Dim ErrorMsg As String
		  #Pragma BreakOnExceptions Off
		  Try
		    ErrorMsg = "Unhandled Exception: " + error.Message + EndOfLine
		    ErrorMsg = ErrorMsg + "Type: " + Introspection.GetType(error).Name + "  Error Number: " + Str(error.ErrorNumber) + EndOfLine
		    ErrorMsg = ErrorMsg + "Stack: " + Join(error.Stack, EndOfLine)
		  Catch
		    ErrorMsg = "Unhandled Exception (details unavailable)"
		  End Try
		  #Pragma BreakOnExceptions On
		  
		  LogErrorEntry(ErrorMsg)
		  If Debugging Then Debug(ErrorMsg)
		  
		  If Ticks - ErrWindowStart > 300 Then 'Ticks are 1/60 of a second
		    ErrWindowStart = Ticks
		    ErrWindowCount = 0
		  End If
		  ErrWindowCount = ErrWindowCount + 1
		  If ErrWindowCount > 25 Then Return False
		  
		  Return True 'Handled, carry on running
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub LogErrorEntry(Msg As String)
		  'Always writes unhandled errors to LLStore_Errors.log in the temp folder (kept under 512KB), even when Debugging is off.
		  #Pragma BreakOnExceptions Off
		  Try
		    Dim F As FolderItem = SpecialFolder.Temporary.Child("LLStore_Errors.log")
		    Dim T As TextOutputStream
		    If F.Exists And F.Length < 524288 Then
		      T = TextOutputStream.Append(F)
		    Else
		      T = TextOutputStream.Create(F)
		    End If
		    T.Write(DateTime.Now.SQLDateTime + "  " + Msg + EndOfLine + EndOfLine)
		    T.Close
		  Catch
		    'Never raise from the error logger
		  End Try
		  #Pragma BreakOnExceptions On
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ErrWindowCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ErrWindowStart As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		mMutex As Mutex
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ProcessID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=false
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=false
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=false
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=false
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=false
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoQuit"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowHiDPI"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BugVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Copyright"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastWindowIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MajorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NonReleaseVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RegionCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StageCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Version"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="_CurrentEventTime"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
