# VBA Snippet

整理了我在VBA项目中使用的函数模块和类库，在 Windows Excel 2013及以上中测试过，但应该适用于 2007+版本。

# Examples

## ArrayPlus2D

对VBA 2D数组增加现代化方法，包括过滤、排序和切片等功能。

### AddFromRange

```vb
' 添加单元格数据到数组
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:B5")

' 删除数组标题行(从第一行起)
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:B5"), RemoveHeader:=True, HeaderCount:=1

' 删除数组标题列(从第一列第一行起)
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:B5"), RemoveHeaderLeft:=True, HeaderLeftCount:=1
```

### AppendColumns

```vb
' 在数组指定列后面插入2D数组数据
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:B5")

Dim brr As Variant
brr = Range("C1:D5").Value
arr.AppendColumns 2, brr
```

### AppendRows

```vb
' 在数组指定行后面插入2D数组数据
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:B5")

Dim brr As Variant
brr = Range("C1:D5").Value
arr.AppendRows 2, brr
```

### Clear

```vb
' 清除数组数据
arr.Clear
```

### Clone

```vb
' 复制数组对象
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:B5")

Dim brr As Variant
arr.Clone brr
```

### RowStart、ColumnStart

```vb
' 获取数组上下标
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:B5")

MsgBox arr.ColumnStart   ' --> 1
MsgBox arr.ColumnEnd	 ' --> 2
MsgBox arr.ColumnCount	 ' --> 2

MsgBox arr.RowStart		 ' --> 1
MsgBox arr.RowEnd		 ' --> 5
MsgBox arr.RowCount		 ' --> 5
```

### ConvertColumnsToRows

```vb
' 将数组列转换行
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

Dim brr As Variant
brr = arr.ConvertColumnsToRows(1, 4)	' 第一列开始,共转换4列
```

### ConvertRowsToColumns

```vb
' 将数组行转换成列
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

Dim brr As Variant
brr = arr.ConvertRowsToColumns(1, 5)	' 第1行开始,共转换5行
```

### Data

```vb
' 打印数组第一个元素
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")
MsgBox arr.Data(1, 1)
```

### FindFirstIndexRow

```vb
' 查找元素出现在数组中的第一个行索引
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

' 查找2，在数组在第3列，第一行开始范围内，第一次出现的行索引
MsgBox arr.FindFirstIndexRow("2", 3, 1, vbTextCompare) ' --> 3
```

### GetColumns

```vb
' 取得列数据
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

Dim brr As Variant
brr = arr.GetColumns(1, 2)	' 获取2列数据，从第1列开始
```

### GetRows

```vb
' 取得行数据
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

Dim brr As Variant
brr = arr.GetRows(1, 2)		' 获取2行数据，从第1行开始
```

### GetValue

```vb
' 打印数组第一个元素
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")
MsgBox arr.GetValue(1, 1)
```

### InsertBlankColumns

```vb
' 插入数组空白列
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")
arr.InsertBlankColumns 1, 2		' 从第1列开始插入2列空白列
```

### InsertBlankRows

```vb
' 插入数组空白行'
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")
arr.InsertBlankRows 1, 2	' 从第1行开始插入2列空白行
```

### PrintColumnsToRange

```vb
' 数组列输出到单元格
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

' 从第1列开始，共2列输入到单元格F1，不转置
arr.PrintColumnsToRange Range("F1"), 1, 2, False	
```

### PrintRowsToRange

```vb
' 数组列输出到单元格
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

' 从第1行开始，共2行输入到单元格F1，不转置
arr.PrintRowsToRange Range("F1"), 1, 2, False	
```

### PrintToRange

```vb
' 数组列输出到单元格
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

' 数组输出到单元格，不转置
arr.PrintToRange Range("F1"), 1, 2, False	
```

### RemoveColumns

```vb
' 删除数组列
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

' 从第1列开始，删除2列
arr.RemoveColumns 1, 2
```

### RemoveRows

```vb
' 删除数组行
Dim arr As New ArrayPlus2D
arr.AddFromRange Range("A1:D5")

' 从第1行开始，删除2行
arr.RemoveRows 1, 2
```

