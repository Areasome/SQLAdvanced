VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SQLPlus"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ----------------------------------------------------------------
' Procedure Name: SQLPlus
' Purpose: Query data with sql
' Procedure Kind: Class
' Procedure Access: Public
' Author: Areasome
' Date: 2023/2/16
' ----------------------------------------------------------------
Option Explicit

Private Type SQLConnectionStrings
    Provider As String
    DataSource As String
    Extended As String
    HDR As Byte
    IMEX As Byte
    FMT As String
    CharacterSet As String
    ConnectionString As String
End Type

Private Type ADO
    Connection As Object
    Recordset As Object
    
    ExecuteString As String
    ExecuteResult As Variant
    
    DataFolder As String
    DataName As String
    DataExtension As String
End Type

Dim tSQLConns As SQLConnectionStrings
Dim tADO As ADO

Public Property Get ExecuteResult() As Variant

    ExecuteResult = tADO.ExecuteResult

End Property

Public Property Get ExecuteString() As String

    ExecuteString = tADO.ExecuteString

End Property

Public Property Let ExecuteString(ByVal strNewValue As String)

    tADO.ExecuteString = strNewValue

End Property

Public Property Let ExecuteResult(ByVal varNewValue As Variant)

    tADO.ExecuteResult = varNewValue

End Property

Public Property Let HDR(ByVal bytNewValue As Byte)

    tSQLConns.HDR = bytNewValue
    
End Property

Public Property Let IMEX(ByVal bytNewValue As Byte)

    tSQLConns.IMEX = bytNewValue
    
End Property

Public Property Let FMT(ByVal strNewValue As String)

    tSQLConns.FMT = strNewValue
    
End Property

Public Property Let CharacterSet(ByVal strNewValue As String)

    tSQLConns.CharacterSet = strNewValue
    
End Property

Public Property Let DataSource(ByVal strNewValue As String)

    On Error GoTo DataSource_Error
    tSQLConns.DataSource = strNewValue
    '// Get data name with data source
    tADO.DataName = Right(tSQLConns.DataSource, Len(tSQLConns.DataSource) - InStrRev(tSQLConns.DataSource, "\"))
    '// Get folder name with data source
    tADO.DataFolder = Replace(tSQLConns.DataSource, tADO.DataName, "")
    '// Get data extension with data name
    tADO.DataExtension = LCase(Right(tADO.DataName, Len(tADO.DataName) - InStrRev(tADO.DataName, ".")))
    
    On Error GoTo 0
    Exit Property
    
DataSource_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure DataSource, line " & Erl & "."
    Call CloseConnection
    
End Property

' TODO: SQL query fileds to a new excel
' TODO: SQL query fileds to file
' TODO: SQL query fileds to csv file

Public Sub Connection()

    On Error GoTo Connection_Error
    '// HDR=Yes; indicates that the first row contains columnnames, not data.
    '// HDR=No; indicates the opposite.
    '// The state is enabled by default
    Dim strHDR As String
    If tSQLConns.HDR = 0 Then
        strHDR = "HDR=YES;"
    ElseIf tSQLConns.HDR = 1 Then
        strHDR = "HDR=NO;"
    End If
    
    '// Use this one when you want to treat all data in the file as text,
    '// overriding Excels column type "General" to guess what type of data is in the column.
    '// IMEX=1; tells the driver to always read "intermixed" (numbers, dates, strings etc) data columns as text.
    '// Note that this option might affect excel sheet write access negative.
    '// The state is enabled by default
    Dim strIMEX As String
    If tSQLConns.IMEX = 0 Then
        strIMEX = "IMEX=1;"
    ElseIf tSQLConns.IMEX = 1 Then
        strIMEX = ""
    End If
    
    '// The delimiter can be specified in the registry at the following location:
    '// HKEY_LOCAL_MACHINE \ SOFTWARE \ Microsoft \ Jet \ 4.0 \ Engines \ Text
    '// Format = TabDelimited or Format = Delimited(;)
    Dim strFMT As String
    If tSQLConns.FMT <> "" Then
        strFMT = "FMT=Delimited(" & tSQLConns.FMT & ");"
    End If
    
    '============================================================
    Dim strCharacterSet As String
    If tSQLConns.CharacterSet <> "" Then
        strCharacterSet = "CharacterSet=" & tSQLConns.CharacterSet & ";"
    End If
    
    Select Case Application.Version * 1
        Case Is <= 11
            tSQLConns.Provider = "Provider=Microsoft.JET.OLEDB.4.0;"
        Case Is >= 12
            tSQLConns.Provider = "Provider=Microsoft.ACE.OLEDB.12.0;"
    End Select
    
    Select Case tADO.DataExtension
        Case Is = "xls"
            tSQLConns.Extended = "Extended Properties=""Excel 8.0;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tSQLConns.DataSource & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & _
                                         strCharacterSet & """"
        Case Is = "xlsx"
            tSQLConns.Extended = "Extended Properties=""Excel 12.0 Xml;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tSQLConns.DataSource & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & _
                                         strCharacterSet & """"
        Case Is = "xlsb"
            tSQLConns.Extended = "Extended Properties=""Excel 12.0;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tSQLConns.DataSource & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & _
                                         strCharacterSet & """"
        Case Is = "xlsm"
            tSQLConns.Extended = "Extended Properties=""Excel 12.0 Macro;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tSQLConns.DataSource & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & _
                                         strCharacterSet & """"
        Case Is = "csv"
            tSQLConns.Extended = "Extended Properties=""text;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tADO.DataFolder & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & _
                                         strCharacterSet & """"
        Case Is = "txt"
            tSQLConns.Extended = "Extended Properties=""Text;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tADO.DataFolder & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & _
                                         strCharacterSet & """"
    End Select
    Debug.Print CStr(Now()) & " ADODB Connection string: " & Chr(10) & tSQLConns.ConnectionString
    
    '// Connection to Microsoft OLEDB
    tADO.Connection.Open tSQLConns.ConnectionString
    
    '// Error for conn failed
    If tADO.Connection.State <> 1 Then
        GoTo Connection_Error
    Else
        Debug.Print CStr(Now()) & " Connection success..."
    End If
    
    On Error GoTo 0
    Exit Sub

Connection_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure Connection, line " & Erl & "."
    Call CloseConnection
    
End Sub

Public Sub Query()
    
    On Error GoTo Query_Error
    If tADO.ExecuteString = "" Then Exit Sub
    Set tADO.Recordset = tADO.Connection.Execute(tADO.ExecuteString)
    
    On Error GoTo 0
    Exit Sub

Query_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure Query, line " & Erl & "."
    Call CloseConnection
    
End Sub

Public Sub ExecuteToArray(ByRef Data As Variant, Optional Header As Boolean = False)

    On Error GoTo ExecuteToArray_Error
    If tADO.ExecuteString = "" Then Exit Sub
    
    Dim arrData As Variant
    Dim arrHeader As Variant
    Dim i As Long, y As Long
    
    If Header Then
        arrData = tADO.Recordset.GetRows
        ReDim arrHeader(0 To tADO.Recordset.Fields.Count - 1, 0 To UBound(arrData, 2) + 1)
        For i = 0 To tADO.Recordset.Fields.Count - 1
            arrHeader(i, 0) = tADO.Recordset.Fields(i).Name
        Next i
        For i = 0 To UBound(arrData, 2)
            For y = 0 To tADO.Recordset.Fields.Count - 1
                arrHeader(y, i + 1) = arrData(y, i)
            Next
        Next
        Data = arrHeader
        tADO.ExecuteResult = arrHeader
    Else
        Data = tADO.Recordset.GetRows
        tADO.ExecuteResult = Data
    End If
    
    Debug.Print CStr(Now()) & " Execute data success..."
    
    On Error GoTo 0
    Exit Sub

ExecuteToArray_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure ExecuteToArray, line " & Erl & "."
    Call CloseConnection
    
End Sub

Public Sub ExecuteToRange(ByVal Rng As Range, Optional Header As Boolean = False)
    
    On Error GoTo ExecuteToRange_Error
    '// Error for sql query string is empty
    If tADO.ExecuteString = "" Then Exit Sub
    'Set tADO.Recordset = tADO.Connection.Execute(tADO.ExecuteString)
    
    '// Write data with header
    If Header Then
        Dim i As Integer, n As Integer
        For i = 0 To tADO.Recordset.Fields.Count - 1
            Rng.Offset(0, i).Value = tADO.Recordset.Fields(i).Name
        Next
        Rng.Offset(1, 0).CopyFromRecordset tADO.Recordset
    Else
        Rng.CopyFromRecordset tADO.Recordset
    End If
    Debug.Print CStr(Now()) & " Execute data success..."
    
    On Error GoTo 0
    Exit Sub

ExecuteToRange_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure ExecuteToRange, line " & Erl & "."
    Call CloseConnection
    
End Sub

Public Sub CreateSchema(Optional strNewKey As String = Empty, Optional strNewValue As String = Empty)
'// https://docs.microsoft.com/en-us/sql/odbc/microsoft/schema-ini-file-text-file-driver?view=sql-server-ver16

    On Error GoTo CreateSchema_Error
    '// Define constants manually
    Const ForReading = 1, ForWriting = 2, ForAppending = 8
    Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0

    Dim fso As Object
    Set fso = CreateObject("Scripting.FilesystemObject")
    
    Dim strPath As String
    strPath = tADO.DataFolder & "\Schema.ini"
    
    If fso.FileExists(strPath) Then
        Open strPath For Output As #1: Close #1 '// Clear text contents
    Else
        fso.CreateTextFile (strPath)
    End If
    
    Dim ts As Object
    Set ts = fso.OpenTextFile(strPath, ForWriting, True, TristateFalse)
    
    ts.WriteLine "[" & tADO.DataName & "]"
    ts.WriteLine "ColNameHeader=True"
    ts.WriteLine "Format=CSVDelimited"
    ts.WriteLine "MaxScanRows=0"
        
    If strNewKey <> Empty And strNewValue <> Empty Then
        Dim arrKey As Variant
        Dim arrVal As Variant
        Dim i As Integer
        arrKey = Split(strNewKey, ",")
        arrVal = Split(strNewValue, ",")
        
        For i = 0 To UBound(arrKey)
            ts.WriteLine "Col" & i + 1 & "=" & """" & arrKey(i) & """" & " " & arrVal(i)
        Next
    End If
    
    ts.Close
    Set fso = Nothing
    Set ts = Nothing

    On Error GoTo 0
    Exit Sub

CreateSchema_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure CreateSchema, line " & Erl & "."
    Call CloseConnection
    
End Sub

Public Sub CloseConnection()
    
    On Error GoTo CloseConnection_Error
    tADO.Recordset.Close
    tADO.Connection.Close
    Set tADO.Recordset = Nothing
    Set tADO.Connection = Nothing
    Debug.Print CStr(Now()) & " Close connection..."
    
    On Error GoTo 0
    Exit Sub

CloseConnection_Error:
    Debug.Print CStr(Now()) & " Close connection..."
    
End Sub

Private Sub Class_Initialize()

    If tADO.Connection Is Nothing Then
        Set tADO.Connection = CreateObject("ADODB.Connection")
    End If
    
    If tADO.Recordset Is Nothing Then
        Set tADO.Recordset = CreateObject("ADODB.Recordset")
    End If

End Sub
