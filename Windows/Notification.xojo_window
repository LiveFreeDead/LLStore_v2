#tag DesktopWindow
Begin DesktopWindow Notification
   Backdrop        =   0
   BackgroundColor =   &c00000000
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   False
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   HasTitleBar     =   True
   Height          =   96
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   96
   MaximumWidth    =   400
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   96
   MinimumWidth    =   400
   Resizeable      =   False
   Title           =   "LLStore"
   Type            =   4
   Visible         =   False
   Width           =   400
   Begin DesktopLabel Status
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "Arial"
      FontSize        =   12.0
      FontUnit        =   0
      Height          =   42
      Index           =   -2147483648
      Italic          =   False
      Left            =   2
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   True
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "LLStore"
      TextAlignment   =   2
      TextColor       =   &cFFFFFF00
      Tooltip         =   ""
      Top             =   27
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   298
   End
   Begin DesktopCanvas Icon
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   False
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   96
      Index           =   -2147483648
      Left            =   300
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Visible         =   True
      Width           =   96
   End
   Begin Timer NotifyTimeOut
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   4000
      RunMode         =   0
      Scope           =   0
      TabPanelIndex   =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  If Not Notification.BuildMode Then
		    Notification.Hide
		  End If
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub UpdateBuildStatus(StepMsg As String)
		  ' Updates the status text during a build, keeping the header line and refreshing the UI immediately.
		  ' Call this instead of touching Status.Text directly during BuildLLFile.
		  If BuildHeader <> "" Then
		    Notification.Status.Text = BuildHeader + Chr(10) + StepMsg
		  Else
		    Notification.Status.Text = StepMsg
		  End If
		  Notification.Refresh(True)
		  App.DoEvents(15)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartBuild(Title As String, Version As String, BuildType As String, IconFile As String)
		  ' Call once at the start of a build to lock the notification open and display identity.
		  Dim VerPart As String = ""
		  If Version.Trim <> "" Then VerPart = " " + Version.Trim
		  BuildHeader = Title + VerPart + " - " + BuildType
		  BuildMode = True
		  
		  ' Resolve icon: prefer BuildType.png in icon file path, fall back to default
		  Dim UseIcon As String = IconFile
		  
		  Notify("LLStore Building", BuildHeader + Chr(10) + "Starting Build...", UseIcon, -1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FinishBuild(Success As Boolean, IconFile As String)
		  ' Call at the end of a build to release the lock and auto-dismiss.
		  If Success Then
		    UpdateBuildStatus("Built Successfully!")
		  Else
		    UpdateBuildStatus("Build Failed!")
		  End If
		  BuildMode = False
		  ' Auto-dismiss after 4s (success) or 6s (failure)
		  If Success Then
		    Notification.NotifyTimeOut.Period = 4000
		  Else
		    Notification.NotifyTimeOut.Period = 6000
		  End If
		  Notification.NotifyTimeOut.RunMode = Timer.RunModes.Single
		  Notification.NotifyTimeOut.Reset
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BuildHeader As String
	#tag EndProperty

	#tag Property, Flags = &h0
		BuildMode As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		NotificationTime As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events Status
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  If Not Notification.BuildMode Then
		    Notification.Hide
		  End If
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events Icon
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  If Not Notification.BuildMode Then
		    Notification.Hide
		  End If
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events NotifyTimeOut
	#tag Event
		Sub Action()
		  If Not Notification.BuildMode Then
		    Notification.Hide
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
		Name="NotificationTime"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BuildMode"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BuildHeader"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
