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
		  
		  Dim errorMsg As String
		  errorMsg = "Unhandled Exception: " + error.Message + EndOfLine
		  errorMsg = errorMsg + "Error Number: " + Str(error.ErrorNumber) + EndOfLine
		  errorMsg = errorMsg + "Stack: " + Join(error.Stack, EndOfLine)
		  
		  ' Log to file
		  If Debugging Then Debug(errorMsg)
		  
		  ' Optionally show user-friendly message
		  'MessageBox("An unexpected error occurred. Please check the log file.")
		  
		End Function
	#tag EndEvent


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
