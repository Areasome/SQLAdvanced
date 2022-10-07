Attribute VB_Name = "ModernTextBoxSetting"
Option Explicit

Public m_FontName As String            '// TextBox font name
Public m_FontSize As Integer           '// TextBox font size
Public m_ForeColor As String           '// TextBox Fore color
Public m_EnterColor As String          '// When textbox enter color
Public m_TitleColor As String          '// Title and bottom line color
Public m_BackGroundColor As String     '// Background color

Public Sub ColorSetting(ByVal ForeColor As String, ByVal EnterColor As String, _
                        ByVal TitleColor As String, Optional ByVal BackGroundColor As String, _
                        Optional ByVal FontName As String = "Tahoma", Optional ByVal FontSize As Integer = 10)

    m_ForeColor = ForeColor
    m_EnterColor = EnterColor
    m_TitleColor = TitleColor
    m_BackGroundColor = BackGroundColor
    m_FontName = FontName
    m_FontSize = FontSize

End Sub


