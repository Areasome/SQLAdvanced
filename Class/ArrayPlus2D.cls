VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ArrayPlus2D"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Enum ErrCodes
    ErrColumnDoesNotExist = 5000
    ErrParameterNotArray = 5001
    ErrIncorrectColumnNumber = 5002
    ErrIncorrectRowNumber = 5003
    ErrInvalidArrayPosition = 5004
    ErrIncorrectNumberofRows = 5005
    ErrIncorrectNumberofColumns = 5006
    ErrParameterArrayEmpty = 5007
    ErrNotArray = 5008
    ErrNot2DArray = 5009
    ErrArrayNotSet = 5010
End Enum

Private m_Data As Variant

Public Property Get RowStart() As Long

    If IsArraySet = True Then
        RowStart = LBound(m_Data, 1)
    End If
    
End Property

Public Property Get RowEnd() As Long

    If IsArraySet = True Then
        RowEnd = UBound(m_Data, 1)
    End If
    
End Property

Public Property Get RowCount() As Long

    If IsArraySet = True Then
        RowCount = UBound(m_Data, 1) - LBound(m_Data, 1) + 1
    End If
    
End Property

Public Property Get ColumnStart() As Long

    If IsArraySet = True Then
        ColumnStart = LBound(m_Data, 2)
    End If
    
End Property

Public Property Get ColumnEnd() As Long

    If IsArraySet = True Then
        ColumnEnd = UBound(m_Data, 2)
    End If
    
End Property

Public Property Get ColumnCount() As Long

    If IsArraySet = True Then
        ColumnCount = UBound(m_Data, 2) - LBound(m_Data, 2) + 1
    End If
    
End Property

Public Property Get Data() As Variant

    Data = m_Data
    
End Property

Public Property Let Data(ByRef NewValue As Variant)
    
    ' If one value then convert to an array
    If IsEmpty(NewValue) = True Or IsArray(NewValue) = False Then
        ReDim m_Data(1 To 1, 1 To 1)
        m_Data(1, 1) = NewValue
    ElseIf IsArray(NewValue) Then
        If CheckDimensions(NewValue) <> 2 Then
            Err.Raise ErrCodes.ErrNot2DArray, "Let Data Property" _
                , "The array to be assigned to the data property must be a two-dimensional array."
        End If
        m_Data = NewValue
    End If

End Property

Public Property Get GetValue(ByVal RowIndex As Long, ByVal ColumnIndex As Long)
    
    GetValue = m_Data(RowIndex, ColumnIndex)
    
End Property

Public Property Let SetValue(ByVal RowIndex As Long, ByVal ColumnIndex As Long, ByVal Data As Variant)
    
    m_Data(RowIndex, ColumnIndex) = Data

End Property

Public Sub AddFromRange(ByVal Rng As Range _
                        , Optional RemoveHeader As Boolean = False _
                        , Optional HeaderCount As Long = 1 _
                        , Optional RemoveHeaderLeft As Boolean = False _
                        , Optional HeaderLeftCount As Long = 1)
    
    ' Coverts the range to an array.   The main purpose of this sub is to remove the header fromthe original data.
    ' If not removing the header then use the "data" property to assign the range to the array.
    If RemoveHeader = True Or RemoveHeaderLeft = True Then
        ' Get the new size for the rows based on removeHeader being true or false
        Dim lRowCount As Long, lRowOffset As Long
        lRowCount = IIf(RemoveHeader = True, Rng.Rows.Count - HeaderCount, Rng.Rows.Count)
        lRowOffset = IIf(RemoveHeader = True, HeaderCount, 0)
        
        ' Get the new size for the rows based on removeHeaderLeft being true or false
        Dim lColumnCount As Long, lColumnOffset As Long
        lColumnCount = IIf(RemoveHeaderLeft = True, Rng.Columns.Count - HeaderLeftCount, Rng.Columns.Count)
        lColumnOffset = IIf(RemoveHeaderLeft = True, HeaderLeftCount, 0)
    
        ' Remove top and/or left header
        Set Rng = Rng.Offset(lRowOffset, lColumnOffset).Resize(lRowCount, lColumnCount)
    End If
    
    ' Return the range data to the array
    m_Data = Rng.Value
    
End Sub

' Purpose: Retrieves one or more rows and converts them to a column
Public Function ConvertRowsToColumns(ByVal RowIndex As Long, Optional ByVal NumberOfRows As Long = 1) As Variant
    
    If RowIndex - 1 + NumberOfRows > RowEnd Then
        Err.Raise ErrCodes.ErrIncorrectNumberofRows, "GetColumnsFromRows" _
            , "The number of rows reads past the number of rows in the array. Please change the row or NumberOfRows parameter values."
    End If
    
    Dim result As Variant
    ReDim result(1 To ColumnEnd, 1 To NumberOfRows)
    
    Dim lLastRow As Long
    lLastRow = ((RowIndex - 1) + NumberOfRows)
    
    Dim lCurrentRow As Long
    lCurrentRow = RowStart
    
    Dim i As Long, j As Long
    For i = RowIndex To lLastRow
        For j = 1 To ColumnEnd
            result(j, lCurrentRow) = m_Data(i, j)
        Next
    Next
    
    ConvertRowsToColumns = result
    
End Function


' Purpose: Retrieves one or more columns and converts them to a row
Public Function ConvertColumnsToRows(ByVal ColumnIndex As Long, Optional ByVal NumberOfColumns As Long = 1) As Variant
    
    If ColumnIndex - 1 + NumberOfColumns > ColumnEnd Then
        Err.Raise ErrCodes.ErrIncorrectNumberofColumns, "GetRowsFromColumns" _
            , "The number of columns reads past the number of columns in the array. Please change the column or NumberOfColumns parameter values."
    End If

    Dim result As Variant
    ReDim result(ColumnStart To NumberOfColumns, RowStart To RowEnd)
    
    Dim lLastColumn As Long
    lLastColumn = ((ColumnIndex - 1) + NumberOfColumns)
    
    Dim lCurrentColumn As Long
    lCurrentColumn = ColumnStart
    
    Dim i As Long, j As Long
    For j = ColumnIndex To lLastColumn
        For i = RowStart To RowEnd
            result(lCurrentColumn, i) = m_Data(i, j)
        Next
        lCurrentColumn = lCurrentColumn + 1
    Next
    
    ConvertColumnsToRows = result
    
End Function

' Purpose: Retrieves one or more rows
Public Function GetRows(ByVal RowIndex As Long, Optional ByVal NumberOfRows As Long = 1) As Variant
        
    If RowIndex - 1 + NumberOfRows > RowCount Then
        Err.Raise ErrCodes.ErrIncorrectNumberofRows, "GetRows" _
            , "The number of rows reads past the number of rows in the array. Please change the row or NumberOfRows parameter values."
    End If
    
    If NumberOfRows < 1 Then
        Err.Raise ErrCodes.ErrIncorrectNumberofRows, "GetRows" _
            , "The NumberOfRows must be one or greater. Please change the NumberOfRows parameter value."
    End If
    
    Dim result As Variant
    ReDim result(RowStart To NumberOfRows, ColumnStart To ColumnEnd)
    
    Dim lLastRow As Long
    lLastRow = ((RowIndex - 1) + NumberOfRows)
    
    Dim lCurrentRow As Long
    lCurrentRow = RowStart
    
    Dim i As Long, j As Long
    For i = RowIndex To lLastRow
        For j = ColumnStart To ColumnEnd
            result(lCurrentRow, j) = m_Data(i, j)
        Next
        lCurrentRow = lCurrentRow + 1
    Next
    
    GetRows = result
    
End Function

' Purpose: Retrieves one or more columns
Public Function GetColumns(ByVal ColumnIndex As Long, Optional ByVal NumberOfColumns As Long = 1) As Variant
    
    If ColumnIndex - 1 + NumberOfColumns > ColumnEnd Then
        Err.Raise ErrCodes.ErrIncorrectNumberofColumns, "GetColumns" _
            , "The number of columns reads past the number of columns in the array. Please change the column or NumberOfColumns parameter values."
    End If
    
    If ColumnIndex < ColumnStart Or ColumnIndex > ColumnEnd Then
        Err.Raise ErrCodes.ErrIncorrectColumnNumber, "GetColumns" _
            , "The column number is invalid as it does not exist in the array."
    End If
    
    Dim result As Variant
    ReDim result(RowStart To RowEnd, ColumnStart To NumberOfColumns)
    
    Dim lLastColumn As Long
    lLastColumn = ((ColumnIndex - 1) + NumberOfColumns)
    
    Dim lCurrentColumn As Long
    lCurrentColumn = ColumnStart
    
    Dim i As Long, j As Long
    For j = ColumnIndex To lLastColumn
        For i = RowStart To RowEnd
            result(i, lCurrentColumn) = m_Data(i, j)
        Next
        lCurrentColumn = lCurrentColumn + 1
    Next
    
    GetColumns = result
    
End Function

Public Sub PrintToRange(ByVal Rng As Range, Optional ByVal Transpose As Boolean = False)
    
    ' Writes the array to a given range
    If Transpose = True Then
        Rng.Resize(ColumnEnd, RowEnd).Value = ConvertColumnsToRows(1, ColumnCount)
    Else
        Rng.Resize(RowEnd, ColumnEnd).Value = m_Data
    End If
    
End Sub

Public Sub PrintRowsToRange(ByVal Rng As Range, ByVal RowIndex As Long _
                        , Optional ByVal NumberOfRows As Long = 1 _
                        , Optional ByVal Transpose As Boolean = False)

    If RowIndex < RowStart Or RowIndex > RowEnd Then
        Err.Raise ErrCodes.ErrIncorrectRowNumber, "WriteDataRowsToRange" _
            , "The row number does not exist in the array."
    End If
    
    If Transpose = True Then
        Rng.Resize(ColumnEnd, NumberOfRows).Value = ConvertRowsToColumns(RowIndex, NumberOfRows)
    Else
        Rng.Resize(NumberOfRows, ColumnEnd).Value = GetRows(RowIndex, NumberOfRows)
    End If

End Sub

Public Sub PrintColumnsToRange(ByVal Rng As Range, ByVal ColumnIndex As Long _
                                , Optional ByVal NumberOfColumns As Long = 1 _
                                , Optional ByVal Transpose As Boolean = False)

    If ColumnIndex < ColumnStart Or ColumnIndex > ColumnEnd Then
       Err.Raise ErrIncorrectColumnNumber, "WriteDataColumnsToRange" _
            , "The column number does not exist in the array."
    End If

    If Transpose = True Then
        Rng.Resize(NumberOfColumns, RowEnd).Value = ConvertColumnsToRows(ColumnIndex, NumberOfColumns)
    Else
        Rng.Resize(RowEnd, NumberOfColumns).Value = GetColumns(ColumnIndex, NumberOfColumns)
    End If

End Sub

Public Sub InsertBlankColumns(ByVal ColumnIndex As Long, Optional ByVal NumberOfColumns As Long = 1)

    ' If the ColumnIndex is greater than the number of columns then add new columns at the end
    If ColumnIndex > ColumnEnd + 1 Then
        ColumnIndex = ColumnEnd + 1
    End If
    
    ' Create the new array with the extra columns
    Dim result As Variant
    ReDim result(RowStart To RowEnd, ColumnStart To ColumnEnd + NumberOfColumns)

    ' Copy the columns before insert
    Dim i  As Long, y As Long
    For y = ColumnStart To ColumnIndex - 1
        For i = RowStart To RowEnd
            result(i, y) = m_Data(i, y)
        Next
    Next
    
    ' Copy the columns after insert
    For y = ColumnIndex To ColumnEnd
        For i = RowStart To RowEnd
            result(i, y + NumberOfColumns) = m_Data(i, y)
        Next
    Next
    
    m_Data = result
    
End Sub

Public Sub AppendColumns(ByVal ColumnIndex As Long, ByRef NewColumns As Variant)
    
    ' Check that the NewColumns array is not empty
    If IsEmpty(NewColumns) Then
        Err.Raise ErrCodes.ErrParameterArrayEmpty, "InsertColumns" _
            , "The NewColumns array parameter is empty. It Should be a 2D array"
    End If
    
    ' Check the NewColumns array is 2D
    If CheckDimensions(NewColumns) <> 2 Then
        Err.Raise ErrCodes.ErrNot2DArray, "InsertColumns" _
            , "The NewColumns array parameter must be a two-dimensional array."
    End If
    
    ' Check that the NewColumns array has the correct number of rows
    If UBound(NewColumns, 1) < RowEnd Then
        Err.Raise ErrCodes.ErrIncorrectNumberofColumns, "InsertColumns" _
            , "There are not enough rows in the NewColumns array parameter. There must be the same number as in the main Array."
    End If
    
    ' Check that the insert column is valid
    If ColumnIndex < 1 Then
        Err.Raise ErrCodes.ErrInvalidArrayPosition, "InsertColumns" _
            , "The ColumnIndex for the array is invalid. Please use a valid column number."
    End If
    
    ' If the ColumnIndex is greater than the number of columns then add the new columns to the end of the array.
    If ColumnIndex > ColumnEnd + 1 Then
        ColumnIndex = ColumnEnd + 1
    End If
    
    Dim lNewColumnCount As Long
    lNewColumnCount = UBound(NewColumns, 2)
    
    ' Create the new array with the extra columns
    Dim result As Variant
    ReDim result(RowStart To RowEnd, ColumnStart To ColumnEnd + lNewColumnCount)
    
    ' Copy the new column data to the new array
    Dim i As Long, y As Long, lCurrentColumn As Long
    lCurrentColumn = ColumnIndex
    
    For y = ColumnStart To lNewColumnCount
        For i = RowStart To RowEnd
            result(i, lCurrentColumn) = NewColumns(i, y)
        Next
        lCurrentColumn = lCurrentColumn + 1
    Next
    
    ' Copy the columns before insert position
    For y = ColumnStart To ColumnIndex - 1
        For i = RowStart To RowEnd
            result(i, y) = m_Data(i, y)
        Next
    Next
    
    ' Copy the columns after the ColumnIndex
    For y = ColumnIndex To ColumnEnd
        For i = RowStart To RowEnd
            result(i, y + lNewColumnCount) = m_Data(i, y)
        Next
    Next
    
    m_Data = result
    
End Sub

Public Sub InsertBlankRows(ByVal RowIndex As Long, Optional ByVal NumberOfRows As Long = 1)
    
    ' If the RowIndex is greater than the number of rows then add new rows at the end
    If RowIndex > RowEnd + 1 Then
        RowIndex = RowEnd + 1
    End If
    
    ' Create the new array with the extra rows
    Dim result As Variant
    ReDim result(RowStart To RowEnd + NumberOfRows, ColumnStart To ColumnEnd)
    
    ' Copy the rows before insert
    Dim i As Long, y As Long
    For i = RowStart To RowIndex - 1
        For y = ColumnStart To ColumnEnd
            result(i, y) = m_Data(i, y)
        Next
    Next
    
    ' Copy the rows after insert
    For i = RowIndex To RowEnd
        For y = ColumnStart To ColumnEnd
            result(i + NumberOfRows, y) = m_Data(i, y)
        Next
    Next
    
    m_Data = result
    
End Sub

Sub AppendRows(ByVal RowIndex As Long, ByRef NewRows As Variant)
    
    ' Check that the newRows array is not empty
    If IsEmpty(NewRows) Then
        Err.Raise ErrCodes.ErrParameterArrayEmpty, "InsertRows" _
            , "The newRows array parameter is empty. It should be a 2D array"
    End If
    ' Check the newRows array is 2D
    If CheckDimensions(NewRows) <> 2 Then
           Err.Raise ErrCodes.ErrNot2DArray, "InsertRows" _
                , "The NewRows array parameter must be a two-dimensional array."
    End If
    ' Check that the newRows array has the correct number of columns
    If UBound(NewRows, 2) < ColumnEnd Then
        Err.Raise ErrCodes.ErrIncorrectNumberofRows, "InsertRows" _
            , "There are not enough columnsw in the NewRows array parameter. There must be the same number as in the main Array."
    End If
    ' Check that the RowIndex is greater than the number of rows then add the new rows to the end of the array.
    If RowIndex < 1 Then
        Err.Raise ErrCodes.ErrInvalidArrayPosition, "InsertRows" _
            , "The RowIndex for the array is invalid. Please use a valid row number."
    End If
    
    ' If the RowIndex is greater than the number of rows then add the new rows to the end of the array.
    If RowIndex > RowEnd + 1 Then
        RowIndex = RowEnd + 1
    End If
    
    Dim lNewRowCount As Long
    lNewRowCount = UBound(NewRows, 1)
    
    ' Create the new array with the extra rows
    Dim result As Variant
    ReDim result(RowStart To RowEnd + lNewRowCount, ColumnStart To ColumnEnd)
    
    ' Copy the new row data to the new array
    Dim i As Long, y As Long, lCurrentRow As Long
    lCurrentRow = RowIndex
    
    For i = RowStart To lNewRowCount
        For y = ColumnStart To ColumnEnd
            result(lCurrentRow, y) = NewRows(i, y)
        Next
        lCurrentRow = lCurrentRow + 1
    Next
    
    ' Copy the rows before insert position
    For i = RowStart To RowIndex - 1
        For y = ColumnStart To ColumnEnd
            result(i, y) = m_Data(i, y)
        Next
    Next
    
    ' Copy the rows after the Rowindex
    For i = RowIndex To RowEnd
        For y = ColumnStart To ColumnEnd
            result(i + lNewRowCount, y) = m_Data(i, y)
        Next
    Next
    
    m_Data = result
    
End Sub

Public Sub RemoveColumns(ByVal ColumnIndex As Long, Optional ByVal NumberOfColumns As Long = 1)
    
    If ColumnIndex < 1 Or ColumnIndex > ColumnEnd Then
        Err.Raise ErrCodes.ErrIncorrectColumnNumber, "RemoveColumns" _
            , "The ColumnIndex column number for the array is invalid. Please use a valid column number."
    End If
    
    If ColumnIndex = 1 And NumberOfColumns >= ColumnEnd Then
        Err.Raise ErrCodes.ErrIncorrectNumberofColumns, "RemoveColumns" _
            , "The values you have passed as parameters will delete all the columns. At least one column must be left in the array."
    End If
    
    ' If the number of columns is greater than the columns to be deleted the set the number to the max possible
    If ColumnIndex - 1 + NumberOfColumns > ColumnEnd Then
        NumberOfColumns = ColumnEnd - ColumnIndex + 1
    End If
    
    ' Create the new array with one less column
    Dim result As Variant
    ReDim result(RowStart To RowEnd, ColumnStart To ColumnEnd - NumberOfColumns)
    
    ' Copy the columns before deleted column
    Dim i As Long, y As Long
    For y = ColumnStart To ColumnIndex - 1
        For i = RowStart To RowEnd
            result(i, y) = m_Data(i, y)
        Next
    Next
    
    ' Copy the rows after deleted ColumnIndex
    For y = ColumnIndex + NumberOfColumns To ColumnEnd
        For i = RowStart To RowEnd
            result(i, y - NumberOfColumns) = m_Data(i, y)
        Next
    Next
    
    m_Data = result
    
End Sub

Public Sub RemoveRows(ByVal RowIndex As Long, Optional ByVal NumberOfRows As Long = 1)
    
    If RowIndex < 1 Or RowIndex > RowEnd Then
        Err.Raise ErrCodes.ErrIncorrectRowNumber, "RemoveRows" _
            , "The RowIndex for the array is invalid. Please use a valid row number."
    End If
    
    If RowIndex - 1 + NumberOfRows > RowEnd Then
        Err.Raise ErrCodes.ErrIncorrectNumberofRows, "RemoveRows" _
            , "The number of rows to delete from the RowIndex is greater than the actual number of rows in the array."
    End If
    
    ' Create the new array with one less RemoveRows
    Dim result As Variant
    ReDim result(RowStart To RowEnd - NumberOfRows, ColumnStart To ColumnEnd)
    
    ' Copy the rows before deleted RowIndex
    Dim i As Long, y As Long
    For i = RowStart To RowIndex - 1
        For y = ColumnStart To ColumnEnd
            result(i, y) = m_Data(i, y)
        Next
    Next
    
    ' Copy the rows after deleted RowIndex
    For i = RowIndex + NumberOfRows To RowEnd
        For y = ColumnStart To ColumnEnd
            result(i - NumberOfRows, y) = m_Data(i, y)
        Next
    Next
    
    m_Data = result
    
End Sub

Public Function FindFirstIndexRow(ByVal SearchItem As Variant _
                                , Optional ByVal ColumnIndex As Long = 1 _
                                , Optional ByVal StartPosition As Long = 1 _
                                , Optional ByVal CompareType As VbCompareMethod = vbTextCompare) As Long

    If ColumnIndex > ColumnEnd Or ColumnIndex < 1 Then
        Err.Raise ErrCodes.ErrColumnDoesNotExist, "FindFirstIndexRow" _
            , "The column supplied does not exist in the array."
    End If
    
    If StartPosition > RowEnd Then
        Err.Raise ErrCodes.ErrIncorrectRowNumber, "FindFirstIndexRow" _
            , "The StartPosition is not a valid row in the array."
    End If

    FindFirstIndexRow = -1
    
    ' If found then return the index
    Dim i As Long
    For i = StartPosition To RowEnd
        If StrComp(m_Data(i, ColumnIndex), SearchItem, CompareType) = 0 Then
            FindFirstIndexRow = i
            Exit For
        End If
    Next

End Function

' TODO: AddFilter
'Public Sub AddFilter(ByVal SearchItem As Variant _
'                    , Optional ByVal Operator As String = "=" _
'                    , Optional ByVal ColumnIndex As Long = 1 _
'                    , Optional ByVal StartPosition As Long = 1)
'
'    If ColumnIndex > ColumnEnd Or ColumnIndex < 1 Then
'        Err.Raise ErrCodes.ErrColumnDoesNotExist, "Filter" _
'            , "The column supplied does not exist in the array."
'    End If
'
'    If StartPosition > RowEnd Then
'        Err.Raise ErrCodes.ErrIncorrectRowNumber, "Filter" _
'            , "The StartPosition is not a valid row in the array."
'    End If
'
'    Dim i As Long, y As Long
'    Dim index As Long
'
'    Dim result() As Variant
'    ReDim result(1 To 1, ColumnStart To ColumnEnd)
'
'    Select Case Operator
'
'        ' Equal: checks if two values are equal. It is also used as an assignment operator
'        Case "="
'            For i = StartPosition To RowEnd
'                If m_Data(i, ColumnIndex) = SearchItem Then
'                    For y = ColumnStart To ColumnEnd
'                        index = UBound(result)
'                        Dim arrRows As Variant
'                        arrRows = GetRows(i)
'                        Call InsertBlankRows(index)
'                        'ReDim Preserve result(1 To index, ColumnStart To ColumnEnd)
'                        result(index, y) = m_Data(i, y)
'                    Next
'                    'index = index + 1
'                End If
'            Next
'
'        ' Less than: This operator is used to subtract numbers
'        Case "<"
'            For i = StartPosition To RowEnd
'                If m_Data(i, ColumnIndex) < SearchItem Then
'                    ReDim Preserve result(1 To index, ColumnStart To ColumnEnd)
'                    For y = ColumnStart To ColumnEnd
'                        result(index, y) = m_Data(i, y)
'                    Next
'                    index = index + 1
'                End If
'            Next
'        ' Greater than: This operator is used to multiply numbers
'        Case ">"
'            For i = StartPosition To RowEnd
'                If m_Data(i, ColumnIndex) > SearchItem Then
'                    ReDim Preserve result(1 To index, ColumnStart To ColumnEnd)
'                    For y = ColumnStart To ColumnEnd
'                        result(index, y) = m_Data(i, y)
'                    Next
'                    index = index + 1
'                End If
'            Next
'        ' Not equal to: This operator is used to divide numbers
'        Case "<>"
'            For i = StartPosition To RowEnd
'                If m_Data(i, ColumnIndex) <> SearchItem Then
'                    ReDim Preserve result(1 To index, ColumnStart To ColumnEnd)
'                    For y = ColumnStart To ColumnEnd
'                        result(index, y) = m_Data(i, y)
'                    Next
'                    index = index + 1
'                End If
'            Next
'        ' Less than or equal to:
'        Case "<="
'            For i = StartPosition To RowEnd
'                If m_Data(i, ColumnIndex) <= SearchItem Then
'                    ReDim Preserve result(1 To index, ColumnStart To ColumnEnd)
'                    For y = ColumnStart To ColumnEnd
'                        result(index, y) = m_Data(i, y)
'                    Next
'                    index = index + 1
'                End If
'            Next
'        ' Greater than or equal to
'        Case ">="
'            For i = StartPosition To RowEnd
'                If m_Data(i, ColumnIndex) >= SearchItem Then
'                    ReDim Preserve result(1 To index, ColumnStart To ColumnEnd)
'                    For y = ColumnStart To ColumnEnd
'                        result(index, y) = m_Data(i, y)
'                    Next
'                    index = index + 1
'                End If
'            Next
'        ' ***********
'        Case "Like"
'            For i = StartPosition To RowEnd
'                If m_Data(i, ColumnIndex) Like SearchItem Then
'                    ReDim Preserve result(1 To index, ColumnStart To ColumnEnd)
'                    For y = ColumnStart To ColumnEnd
'                        result(index, y) = m_Data(i, y)
'                    Next
'                    index = index + 1
'                End If
'            Next
'    End Select
'
'    m_Data = result
'
'End Sub

Public Sub Reverse()
    
    ' Reverses the array.
    ' If you want the array in descending order then sort and reverse.
    Dim lRow As Long: lRow = RowEnd
    Dim lColumns As Long: lColumns = ColumnEnd
    
    Dim result As Variant
    ReDim result(1 To lRow, 1 To lColumns)
    
    Dim i  As Long, y As Long
    Dim index As Long: index = 1
    
    For i = index To 1 Step -1
        For y = 1 To lColumns
            Reset(index, y) = m_Data(i, y)
        Next
        index = index + 1
    Next
    
    m_Data = result
    
End Sub

Public Function IsArraySet() As Boolean
    
    IsArraySet = IIf(IsEmpty(m_Data) = True, False, True)
    
End Function

Public Sub Clone(ByRef Destination As Variant)
    
    Set Destination = Me
    
End Sub

Public Sub Clear()
    
    m_Data = Empty
    
End Sub

Private Function CheckDimensions(ByRef NewValue As Variant) As Long
    
    ' Return the number of dimensions of a array
    If IsArray(NewValue) = False Then
       Err.Raise ErrCodes.ErrIncorrectNumberofColumns, "CheckDimensions" _
            , "The parameter is not a valid array."
    End If

    On Error GoTo CheckDimensions_Error
    Dim lDimensions As Long
    Dim i As Long: i = 0
    
    Do
        i = i + 1
        lDimensions = UBound(NewValue, i)
    Loop While True
    
    On Error GoTo 0
    Exit Function

CheckDimensions_Error:
    CheckDimensions = i - 1

End Function
