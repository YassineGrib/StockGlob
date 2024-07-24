# تحديد اسم مثيل LocalDB
$localDBInstance = "MSSQLLocalDB"

# تشغيل مثيل LocalDB إذا لم يكن قيد التشغيل
$localDBStatus = sqlcmd -L | Select-String -Pattern $localDBInstance

if ($localDBStatus -eq $null) {
    Write-Host "تشغيل مثيل LocalDB..."
    & sqllocaldb start $localDBInstance
}

# الانتظار قليلاً للتأكد من أن المثيل قد بدأ
Start-Sleep -Seconds 5

# العثور على اسم الـ pipe
$pipeName = sqlcmd -S "np:\\.\pipe\LOCALDB#*\\tsql\\query" -Q "SELECT @@SERVERNAME" 2>&1 | Select-String -Pattern "LOCALDB#"

# التحقق من العثور على اسم الـ pipe
if ($pipeName -ne $null) {
    # تنسيق اسم الـ pipe
    $pipeName = $pipeName.ToString().Trim()

    # تشغيل أمر sqlcmd باستخدام اسم الـ pipe
    Write-Host "تشغيل السكربت باستخدام pipe: np:\\.\pipe\$pipeName\tsql\query"
    sqlcmd -S "np:\\.\pipe\$pipeName\\tsql\\query" -i CreateDatabase.sql
} else {
    Write-Host "لم يتم العثور على اسم الـ pipe."
}
