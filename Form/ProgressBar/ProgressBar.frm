VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ProgressBar 
   Caption         =   "Progress"
   ClientHeight    =   2250
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   6405
   OleObjectBlob   =   "ProgressBar.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "ProgressBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Type Bar
    BarMin As Long
    BarMax As Long
    BarVal As Long
    StartTime As Long
    ShowTime As Boolean
    ShowTimeLeft As Boolean
    Cancelled As Boolean
End Type

Dim tBar As Bar

#If Win64 Then
    Private Declare PtrSafe Function GetTickCount Lib "Kernel32" () As Long
#Else
    Private Declare Function GetTickCount Lib "Kernel32" () As Long
#End If

Public Sub BarSetting(ByVal Title As String, ByVal Status As String, _
                      ByVal Min As Long, ByVal Max As Long, _
                      Optional ByVal CancelButtonText As String = "CANCEL", _
                      Optional ByVal ShowTimeElapsed As Boolean = True, _
                      Optional ByVal ShowTimeRemaining As Boolean = True)
                      
    Me.Caption = Title
    Me.lbStatus.Caption = Status
    Me.btnCancle.Visible = (Not CancelButtonText = vbNullString)
    Me.btnCancle.Caption = CancelButtonText
    Me.lbRunTime.Caption = ""
    Me.lbRemainingTime.Caption = ""
    tBar.BarMin = Min
    tBar.BarMax = Max
    tBar.BarVal = Min
    tBar.StartTime = GetTickCount()
    tBar.ShowTime = ShowTimeElapsed
    tBar.ShowTimeLeft = ShowTimeRemaining
    tBar.Cancelled = False
    
End Sub
       
Public Sub SetStatus(ByVal Status As String)

    ' Set the label text above the status bar
    Me.lbStatus.Caption = Status
    DoEvents

End Sub

Public Sub SetValue(ByVal NewValue As Long)
    
    ' Set the value of the status bar, a long which is snapped to a value between Min and Max
    If NewValue < tBar.BarMin Then
        NewValue = tBar.BarMin
    End If
    
    If NewValue > tBar.BarMax Then
        NewValue = tBar.BarMax
    End If
    tBar.BarVal = NewValue
    
    Dim dProgress As Double
    Dim lRunTime As Long
    
    dProgress = (tBar.BarVal - tBar.BarMin) / (tBar.BarMax - tBar.BarMin)
    Me.lbProgressBar.Width = 292 * dProgress
    Me.lbPercent = Int(dProgress * 10000) / 100 & "%"
    lRunTime = GetRunTime()
    
    If tBar.ShowTime Then
        Me.lbRunTime.Caption = "Time Elapsed: " & GetRunTimeString(lRunTime, True)
    End If
    
    If tBar.ShowTimeLeft And dProgress > 0 Then
        Me.lbRemainingTime.Caption = "Est. Time Left: " & GetRunTimeString(lRunTime * (1 - dProgress) / dProgress, False)
    End If
    'DoEvents
    
End Sub

Public Function GetRunTime() As Long
    
    ' Get the time (in milliseconds) since the progress bar "Configure" routine was last called
    GetRunTime = GetTickCount() - tBar.StartTime
    
End Function

Public Function GetFormattedRunTime() As String
    
    ' Get the time (in hours, minutes, seconds) since "Configure" was last called
    GetFormattedRunTime = GetRunTimeString(GetTickCount() - tBar.StartTime)
    
End Function

Private Function GetRunTimeString(ByVal RunTime As Long, Optional ByVal ShowMsecs As Boolean = True) As String
    
    ' Formats a time in milliseconds as hours, minutes, seconds.milliseconds
    ' Milliseconds are excluded if showMsecs is set to false
    Dim msecs As Long, h As Long, m As Long, s As Double
    msecs = RunTime
    h = Int(msecs / 3600000)
    m = Int(msecs / 60000) - 60 * h
    s = msecs / 1000 - 60 * (m + 60 * h)
    GetRunTimeString = IIf(h > 0, h & " hours ", "") _
                     & IIf(m > 0, m & " minutes ", "") _
                     & IIf(s > 0, IIf(ShowMsecs, s, Int(s + 0.5)) & " seconds", "")
    
End Function

Public Function GetValue() As Long

    ' Returns the current value of the progress bar
    GetValue = tBar.BarVal
    
End Function

Public Function IsCancelPressed() As Boolean

    ' Returns whether or not the cancel button has been pressed.
    ' The ProgressDialogue must be polled regularily to detect whether cancel was pressed.
    IsCancelPressed = tBar.Cancelled
    
End Function

Private Sub btnCancle_Click()

    ' Recalls that cancel was pressed so that they calling routine can be notified next time it asks.
    tBar.Cancelled = True
    Me.lbStatus.Caption = "Cancelled by user, please wait."
    'Unload ProgressBar
    
End Sub

Private Sub Userform_QueryClose(Cancel As Integer, CloseMode As Integer)

    If CloseMode = vbFormControlMenu Then
        Unload ProgressBar
        Exit Sub
    End If

End Sub
