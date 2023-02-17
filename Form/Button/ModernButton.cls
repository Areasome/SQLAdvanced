VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ModernButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public WithEvents mForm As MSForms.UserForm
Attribute mForm.VB_VarHelpID = -1
Public WithEvents mFrame As MSForms.Frame
Attribute mFrame.VB_VarHelpID = -1
Public WithEvents mPage As MSForms.MultiPage
Attribute mPage.VB_VarHelpID = -1
Public WithEvents btn As MSForms.Label
Attribute btn.VB_VarHelpID = -1
Public WithEvents btnHover As MSForms.Label
Attribute btnHover.VB_VarHelpID = -1

Public ctBtn As New Collection
Private cButton As New ModernButton

Public Sub InitModernButton(ByVal form As MSForms.UserForm, Optional mPage As MSForms.MultiPage, Optional mFrame As MSForms.Frame)

    Set mForm = form
    Dim item As Control
    For Each item In mForm.Controls

        If TypeName(item) = "Label" And item.Tag = "btn" Then
            Call ButtonDesign(item)
            
            Set cButton = New ModernButton
            Set cButton.btn = item
            Set cButton.mPage = mPage
            Set cButton.mFrame = mFrame
            Set cButton.mForm = mForm
            ctBtn.Add cButton
        End If
        If TypeName(item) = "Label" And item.Tag = "btnHover" Then
            Call ButtonDesign(item)
            item.Visible = False
            Set cButton = New ModernButton
            Set cButton.btnHover = item
            Set cButton.mPage = mPage
            Set cButton.mFrame = mFrame
            Set cButton.mForm = mForm
            ctBtn.Add cButton
        End If
    Next

End Sub

Private Sub ButtonDesign(ByVal ctrl As Object)

    With ctrl
        .Font.Size = 11
        .Font.Name = "Microsoft YaHei"
        .BackStyle = fmBackStyleTransparent
        .PicturePosition = 12
        .MousePointer = 99
        '.MouseIcon = LoadPicture(ThisWorkbook.Path & "\img\Hand+Cursor.ico")
    End With

End Sub

Private Sub btn_MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    
    Call btnMouseOut
    With mForm.Controls(btn.Name & "bg")
        .Top = btn.Top
        .Left = btn.Left
        .Visible = True
    End With

End Sub

Private Sub mForm_MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)

    Call btnMouseOut
    
End Sub

Private Sub btnMouseOut()

    Dim ctrl As Control
    For Each ctrl In mForm.Controls
        If ctrl.Tag = "btnHover" Then
            ctrl.Visible = False
        End If
    Next ctrl
    
End Sub

Private Sub mFrame_MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    
    Call btnMouseOut
    
End Sub

Private Sub mPage_MouseMove(ByVal Index As Long, ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    
    Call btnMouseOut
    
End Sub
