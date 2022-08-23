VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SQLAdvanced"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ----------------------------------------------------------------
' Procedure Name: SQLAdvanced
' Purpose: Query data with sql
' Procedure Kind: Class
' Procedure Access: Public
' Author: Areasome
' Date: 2022/7/29
' ----------------------------------------------------------------
Option Explicit

Private Type SQLConnectionStrings
    Provider As String
    DataSource As String
    Extended As String
    HDR As Byte
    IMEX As Byte
    FMT As String
    ConnectionString As String
End Type

Private Type ADO
    Connection As Object
    Recordset As Object
    
    ExcuteString As String
    ExcuteResult As Variant
    
    DataFolder As String
    DataName As String
    DataExtension As String
End Type

Dim tSQLConns As SQLConnectionStrings
Dim tADO As ADO

Public Property Get ExcuteResult() As Variant

    ExcuteResult = tADO.ExcuteResult

End Property

Public Property Get ExcuteString() As String

    ExcuteString = tADO.ExcuteString

End Property

Public Property Let ExcuteString(ByVal strNewValue As String)

    tADO.ExcuteString = strNewValue

End Property

Public Property Let ExcuteResult(ByVal varNewValue As Variant)

    tADO.ExcuteResult = varNewValue

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

Public Property Let DataSource(ByVal strNewValue As String)

    On Error GoTo DataSource_Error
    tSQLConns.DataSource = strNewValue
    ' Get data name with data source
    tADO.DataName = Right(tSQLConns.DataSource, Len(tSQLConns.DataSource) - InStrRev(tSQLConns.DataSource, "\"))
    ' Get folder name with data source
    tADO.DataFolder = Replace(tSQLConns.DataSource, tADO.DataName, "")
    ' Get data extension with data name
    tADO.DataExtension = LCase(Right(tADO.DataName, Len(tADO.DataName) - InStrRev(tADO.DataName, ".")))
    
    On Error GoTo 0
    Exit Property
    
DataSource_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure DataSource, line " & Erl & "."

End Property

' TODO: sql query fields to array
Public Sub ExecuteToArray()
    
    On Error GoTo ExecuteToArray_Error
    ' Error for sql query string is empty
    If tADO.ExcuteString = "" Then Exit Sub
    
    ' Run the SQL query and return the query result to array
    tADO.ExcuteResult = Empty
    Set tADO.Recordset = tADO.Connection.Execute(tADO.ExcuteString)
    tADO.ExcuteResult = tADO.Recordset.GetRows
    Debug.Print CStr(Now()) & " Excute data success..."
    
    On Error GoTo 0
    Exit Sub

ExecuteToArray_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure ExecuteToArray, line " & Erl & "."

End Sub

' TODO: SQL query fileds to excel range
Public Sub ExcuteToRange(ByVal Rng As Range, Optional Header As Boolean = False)
    
    On Error GoTo ExcuteToRange_Error
    ' Error for sql query string is empty
    If tADO.ExcuteString = "" Then Exit Sub
    Set tADO.Recordset = tADO.Connection.Execute(tADO.ExcuteString)
    
    ' Write data with header
    If Header Then
        Dim i As Integer, n As Integer
        For i = 0 To tADO.Recordset.Fields.Count - 1
            Rng.Offset(0, i).Value = tADO.Recordset.Fields(i).Name
        Next
        Rng.Offset(1, 0).CopyFromRecordset tADO.Recordset
    Else
        Rng.CopyFromRecordset tADO.Recordset
    End If
    Debug.Print CStr(Now()) & " Excute data success..."
    
    On Error GoTo 0
    Exit Sub

ExcuteToRange_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure ExcuteToRange, line " & Erl & "."

End Sub

' TODO: SQL query fileds to a new excel
' TODO: SQL query fileds to file
' TODO: SQL query fileds to csv file

Public Sub Connection()

    On Error GoTo Connection_Error    
    ' HDR=Yes; indicates that the first row contains columnnames, not data.
    ' HDR=No; indicates the opposite.
    ' The state is enabled by default
    Dim strHDR As String
    If tSQLConns.HDR = 0 Then
        strHDR = "HDR=YES;"
    ElseIf tSQLConns.HDR = 1 Then
        strHDR = "HDR=NO;"
    End If
    
    ' Use this one when you want to treat all data in the file as text,
    ' overriding Excels column type "General" to guess what type of data is in the column.
    ' IMEX=1; tells the driver to always read "intermixed" (numbers, dates, strings etc) data columns as text.
    ' Note that this option might affect excel sheet write access negative.
    ' The state is enabled by default
    Dim strIMEX As String
    If tSQLConns.IMEX = 0 Then
        strIMEX = "IMEX=1;"
    ElseIf tSQLConns.IMEX = 1 Then
        strIMEX = ""
    End If
    
    ' The delimiter can be specified in the registry at the following location:
    ' HKEY_LOCAL_MACHINE \ SOFTWARE \ Microsoft \ Jet \ 4.0 \ Engines \ Text
    ' Format = TabDelimited or Format = Delimited(;)
    Dim strFMT As String
    If tSQLConns.FMT <> "" Then
        strFMT = "FMT=Delimited(" & tSQLConns.FMT & ");"
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
                                         strIMEX & """"
        Case Is = "xlsx"
            tSQLConns.Extended = "Extended Properties=""Excel 12.0 Xml;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tSQLConns.DataSource & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & """"
        Case Is = "xlsb"
            tSQLConns.Extended = "Extended Properties=""Excel 12.0;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tSQLConns.DataSource & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & """"
        Case Is = "xlsm"
            tSQLConns.Extended = "Extended Properties=""Excel 12.0 Macro;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tSQLConns.DataSource & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & """"
        Case Is = "csv"
            tSQLConns.Extended = "Extended Properties=""text;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tADO.DataFolder & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & """"
        Case Is = "txt"
            tSQLConns.Extended = "Extended Properties=""Text;"
            tSQLConns.ConnectionString = tSQLConns.Provider & _
                                         "Data Source=" & tADO.DataFolder & ";" & _
                                         tSQLConns.Extended & _
                                         strHDR & _
                                         strIMEX & _
                                         strFMT & """"
    End Select
    Debug.Print CStr(Now()) & " ADODB Connection string: " & Chr(10) & tSQLConns.ConnectionString
    
    ' Connection to Microsoft OLEDB
    tADO.Connection.Open tSQLConns.ConnectionString
    
    ' Error for conn failed
    If tADO.Connection.State <> 1 Then
        GoTo Connection_Error
    Else
        Debug.Print CStr(Now()) & " Connection success..."
    End If
    
    On Error GoTo 0
    Exit Sub

Connection_Error:
    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure Connection, line " & Erl & "."
    
End Sub

Public Sub CreateSchema(Optional strNewKey As String = Empty, Optional strNewValue As String = Empty)
' https://docs.microsoft.com/en-us/sql/odbc/microsoft/schema-ini-file-text-file-driver?view=sql-server-ver16

    On Error GoTo CreateSchema_Error
    ' Define constants manually
    Const ForReading = 1, ForWriting = 2, ForAppending = 8
    Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0

    Dim fso As Object
    Set fso = CreateObject("Scripting.FilesystemObject")
    
    Dim strPath As String
    strPath = tADO.DataFolder & "\Schema.ini"
    
    If fso.FileExists(strPath) Then
        Open strPath For Output As #1: Close #1 ' Clear text contents
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

End Sub

Private Sub Class_Initialize()

    If tADO.Connection Is Nothing Then
        Set tADO.Connection = CreateObject("ADODB.Connection")
    End If
    
    If tADO.Recordset Is Nothing Then
        Set tADO.Recordset = CreateObject("ADODB.Recordset")
    End If
    
End Sub
