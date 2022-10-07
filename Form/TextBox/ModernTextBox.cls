VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ModernTextBox"
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
Public WithEvents Textbox As MSForms.Textbox
Attribute Textbox.VB_VarHelpID = -1
Public WithEvents ComboBox As MSForms.ComboBox
Attribute ComboBox.VB_VarHelpID = -1
Public WithEvents BarBottom As MSForms.Label
Attribute BarBottom.VB_VarHelpID = -1
Public WithEvents BarTitle As MSForms.Label
Attribute BarTitle.VB_VarHelpID = -1
Public WithEvents BackGround As MSForms.Label
Attribute BackGround.VB_VarHelpID = -1
Public WithEvents BarIcon As MSForms.Label
Attribute BarIcon.VB_VarHelpID = -1
Public WithEvents DropArrow As MSForms.Label
Attribute DropArrow.VB_VarHelpID = -1

Public ctBox As New Collection

Public Sub InitModernTextBox(ByVal form As MSForms.UserForm)

    Dim ctrl As control
    Set mForm = form
    Dim tb As ModernTextBox
    
    For Each ctrl In mForm.Controls
        If TypeName(ctrl) = "TextBox" Then
            With ctrl
                Call TextBoxStyle(ctrl)
                Set BarBottom = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BarBottom")
                Call AddBarBottom(ctrl)
                Set BarTitle = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BarTitle")
                Call AddBarTitle(ctrl)
                Set BarIcon = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BarIcon")
                Call AddBarIcon(ctrl)
                Set BackGround = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BackGround")
                Call AddBackGround(ctrl)
                .ControlTipText = .Tag
                .ZOrder (0)
            End With
            Set tb = New ModernTextBox
            Set tb.Textbox = ctrl
            Set tb.mForm = mForm
            ctBox.Add tb

        ElseIf TypeName(ctrl) = "ComboBox" Then
            With ctrl
                Call ComboBoxStyle(ctrl)
                Set BarBottom = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BarBottom")
                Call AddBarBottom(ctrl)
                Set BarTitle = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BarTitle")
                Call AddBarTitle(ctrl)
                Set BarIcon = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BarIcon")
                Call AddBarIcon(ctrl)
                Set BackGround = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "BackGround")
                Call AddBackGround(ctrl)
                .ControlTipText = .Tag
                .ZOrder (0)
                Set DropArrow = ctrl.Parent.Controls.Add("Forms.Label.1", .Name & "DropArrow")
                Call AddDropArrow(ctrl)
            End With
            Set tb = New ModernTextBox
            Set tb.ComboBox = ctrl
            Set tb.DropArrow = DropArrow
            Set tb.mForm = mForm
            ctBox.Add tb
            
        ElseIf TypeName(ctrl) = "MultiPage" Then
            Set tb = New ModernTextBox
            Set tb.mPage = ctrl
            Set tb.mForm = mForm
            ctBox.Add tb
            
        ElseIf TypeName(ctrl) = "Frame" Then
            Set tb = New ModernTextBox
            Set tb.mFrame = ctrl
            Set tb.mForm = mForm
            ctBox.Add tb
        End If
    Next

End Sub

Sub TextBoxStyle(ctrl As control)

    With ctrl
        .BackStyle = fmBackStyleTransparent
        .BorderStyle = fmBorderStyleSingle
        .BorderStyle = fmBorderStyleNone
        .SelectionMargin = False
        .Font.Name = m_FontName
        .ForeColor = m_ForeColor
        .Font.Size = m_FontSize
        .Height = 24
    End With
    
End Sub

Sub ComboBoxStyle(ctrl As control)
    With ctrl
        .BackStyle = fmBackStyleTransparent
        .BorderStyle = fmBorderStyleSingle
        .BorderStyle = fmBorderStyleNone
        .SelectionMargin = False
        .Font.Name = m_FontName
        .ForeColor = m_ForeColor
        .ShowDropButtonWhen = fmShowDropButtonWhenNever
        .Font.Size = m_FontSize
        .Height = 24
    End With
End Sub

Sub AddBarBottom(ctrl As control)
    With BarBottom
        .Height = 1
        .Width = ctrl.Width
        .Left = ctrl.Left
        .BackColor = m_TitleColor
        .Top = ctrl.Top + 19
        .ZOrder (0)
    End With
End Sub

Sub AddBarTitle(ctrl As control)
    With BarTitle
        .Height = ctrl.Height
        .Width = ctrl.Width
        .Left = ctrl.Left + 2
        .Caption = ctrl.Tag
        .ForeColor = m_TitleColor
        .Font.Name = m_FontName
        .Font.Size = m_FontSize
        .BackStyle = fmBackStyleTransparent
        .Top = ctrl.Top
        .ZOrder (0)
    End With
End Sub

Sub AddBackGround(ctrl As control)
    With BackGround
        .Height = 22 '24
        .Width = ctrl.Width
        .BackColor = m_BackGroundColor
        .Font.Size = m_FontSize
        .Top = ctrl.Top - 4
        .Left = ctrl.Left
        .ZOrder (1)
    End With
End Sub

Sub AddBarIcon(ctrl As control)
    With BarIcon
        .Font.Name = "Segoe MDL2 Assets"
        .Font.Size = 14
        If ctrl.ControlTipText <> "" Then .Caption = ChrW(ctrl.ControlTipText)
        .Width = 20
        .Height = 20
        .ForeColor = m_TitleColor
        .Top = ctrl.Top + 2
        .Left = ctrl.Left - .Width
        .BackStyle = fmBackStyleTransparent
        .ZOrder (1)
    End With
End Sub

Sub AddDropArrow(ctrl As control)
    With DropArrow
        .Font.Name = "Webdings"
        .Caption = "6"
        .Height = ctrl.Height
        .Width = .Height
        .Left = ctrl.Width + ctrl.Left - .Width + 8
        .BackStyle = fmBackStyleTransparent
        .ForeColor = m_TitleColor
        .BorderStyle = fmBorderStyleNone
        .Top = ctrl.Top + 1
        .Font.Size = m_FontSize
        .ZOrder (0)
    End With
End Sub

Sub SetForm(form As MSForms.UserForm)
    Set tb = New clsTextBox
    Set tb.mForm = form
    ctBox.Add tb
End Sub

Private Sub mFrame_Click()
    Call BoxExit
End Sub

Private Sub mPage_Click(ByVal Index As Long)
    Call BoxExit
End Sub

Private Sub mPage_MouseDown(ByVal Index As Long, ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    Call BoxExit
End Sub

Private Sub TextBox_Change()
    Call TextBoxEnter
End Sub

Private Sub Textbox_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    Call TextBoxEnter
End Sub

Private Sub Textbox_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    Call TextBoxEnter
End Sub

Private Sub txtCaption_Click()
    Call BoxExit
End Sub

Sub TextBoxEnter()

    Call BoxExit
    Dim ctrl As control
    
    For Each ctrl In mForm.Controls
        If TypeName(ctrl) = "TextBox" And ctrl.Name = Textbox.Name Then
            With mForm.Controls(Textbox.Name & "BarBottom")
                .BackColor = m_EnterColor
                .Height = 1.2
            End With
            
            With mForm.Controls(Textbox.Name & "BarTitle")
                .ForeColor = m_EnterColor
                .Top = Textbox.Top - 17
                .Font.Size = 8
                .Left = Textbox.Left
            End With
            
            With mForm.Controls(Textbox.Name & "BarIcon")
                .ForeColor = m_EnterColor
            End With
        End If
    Next
    
End Sub

Sub BoxExit()

    Dim ctrl As control
    For Each ctrl In mForm.Controls
        If TypeName(ctrl) = "TextBox" Or TypeName(ctrl) = "ComboBox" Then
            If Len(ctrl) = 0 Then
                With mForm.Controls(ctrl.Name & "BarBottom")
                    .BackColor = m_TitleColor
                    .Height = 1
                End With
                With mForm.Controls(ctrl.Name & "BarTitle")
                    .ForeColor = m_TitleColor
                    .Top = ctrl.Top
                    .Left = ctrl.Left + 2
                    .Font.Size = m_FontSize
                End With
                With mForm.Controls(ctrl.Name & "BarIcon")
                    .ForeColor = m_TitleColor
                End With
                     
            Else
                With mForm.Controls(ctrl.Name & "BarBottom")
                    .BackColor = m_TitleColor
                    .Height = 1
                End With
                With mForm.Controls(ctrl.Name & "BarTitle")
                    .ForeColor = m_TitleColor
                End With
                     
                With mForm.Controls(ctrl.Name & "BarIcon")
                    .ForeColor = m_TitleColor
                End With
            End If
        End If

        If TypeName(ctrl) = "ComboBox" Then
            With mForm.Controls(ctrl.Name & "DropArrow")
                .ForeColor = m_TitleColor
            End With
        End If
    Next
End Sub

Sub ComboBoxEnter()
    Call BoxExit
    Dim ctrl As control
    For Each ctrl In mForm.Controls

        If TypeName(ctrl) = "ComboBox" And ctrl.Name = ComboBox.Name Then
                
            With mForm.Controls(ComboBox.Name & "BarBottom")
                .BackColor = m_EnterColor
                .Height = 1.2
            End With
            With mForm.Controls(ComboBox.Name & "BarTitle")
                .ForeColor = m_EnterColor
                .Top = ComboBox.Top - 17
                .Font.Size = 8
                .Left = ComboBox.Left
            End With
                
            With mForm.Controls(ComboBox.Name & "BarIcon")
                .ForeColor = m_EnterColor
            End With
                
            With mForm.Controls(ComboBox.Name & "DropArrow")
                .ForeColor = m_EnterColor
            End With
        End If
    Next
     
End Sub

Private Sub ComboBox_Change()
    Call ComboBoxEnter
End Sub

Private Sub ComboBox_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    Call ComboBoxEnter
End Sub

Private Sub ComboBox_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    Call ComboBoxEnter
End Sub

Private Sub DropArrow_Click()
    Call BoxExit
    Dim ComboName As String
    Dim ctrl As control
    
    For Each ctrl In mForm.Controls
        If TypeName(ctrl) = "ComboBox" Then
            ComboName = Mid(DropArrow.Name, 1, Len(DropArrow.Name) - 9)
            If ComboName = ctrl.Name Then
                With mForm.Controls(ComboName)
                    .DropDown
                    With mForm.Controls(ComboName & "BarBottom")
                        .BackColor = m_EnterColor
                        .Height = 1.2
                    End With
                     
                    With mForm.Controls(ComboName & "BarTitle")
                        .ForeColor = m_EnterColor
                        .Top = mForm.Controls(ComboName).Top - 17
                        .Font.Size = 8
                        .Left = mForm.Controls(ComboName).Left
                    End With
                End With
                With DropArrow
                    .ForeColor = m_EnterColor
                End With
            End If
        End If
    Next
End Sub

Private Sub DropArrow_MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    'Call MouseMoveIcon
End Sub

Private Sub mForm_Click()
    Call BoxExit
End Sub
