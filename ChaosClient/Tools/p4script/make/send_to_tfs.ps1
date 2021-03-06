param(
[string]$output_folder=$(throw "Parameter missing: output_folder") ,
[string]$apk_path=$(throw "Parameter missing: apk_path ") ,
[string]$root=$(throw "Parameter missing: root ") ,
[string]$tfs_fold=$(throw "Parameter missing: tfs_fold ") ,
[bool]$encrypted = $false
)
Write-Host $output_folder
Write-Host $apk_path

#开始拷贝文件
net use J: "\\tencent.com\tfs\跨部门项目\POLAR项目组" /persistent:yes Lily1234 /USER:wallacewu
$fold = "\\tencent.com\tfs\跨部门项目\POLAR项目组" + $tfs_fold + (Get-Date -format yyyy-MM-dd).ToString() + "\" + $root
if (Test-Path $fold)
{
    
}
else
{
    new-item -path $fold  -type "directory"
}
$pcfold = $fold + "\PC\"
$pc_files = $pcfold + '*'
if (Test-Path $pcfold) {
    remove-Item $pc_files -force -recurse
} 

new-item -path $pcfold  -type "directory" -force

$androidfold = $fold + "\Android\"
$old_apk = $androidfold + '*'
if (Test-Path $androidfold) {
    remove-Item $androidfold -force -recurse
}
new-item -path $androidfold  -type "directory" -force

#$apks = Get-ChildItem $androidfold

#if ($encrypted)
#{
	#foreach($apk in $apks)
	#{
		#if ( $apk.Name.IndexOf('encrypted') -ne -1)
		#{
			#Remove-Item $apk.FullName -Force
		#}
	#}
#}
#else
#{
	#foreach($apk in $apks)
	#{
		#if ( $apk.Name.IndexOf('encrypted') -eq -1)
		#{
			#Remove-Item $apk.FullName -Force
		#}
	#}
#}


Write-Host "Copying pc files ..."
# Alias for 7-zip
if (-not (test-path "C:\Program Files\7-Zip\7z.exe")) {throw "C:\Program Files\7-Zip\7z.exe needed"}
set-alias sz "C:\Program Files\7-Zip\7z.exe"
 
# directories to use
$from = $output_folder + "*"

# Zip-file name
if($encrypted)
{
	$zipfile = $pcfold + 'pc_encrypted.zip'
}
else
{
	$zipfile = $pcfold + 'pc.zip'
}

# Create zip-file
sz a -tzip -r -mmt "$zipfile" $from > $out

Write-Host "copy pc.zip done,start copy apk"

if($encrypted)
{
	$apk_end = '_encrypted.apk'
}
else
{
	$apk_end = '.apk'
}
$newApkName = "PolarClient_"+(Get-Date -format yyyy-MM-dd-HH-mm).ToString() + $apk_end
$newfullpath =  $androidfold + $newApkName
Copy-Item $apk_path -Destination $newfullpath
Write-Host "Done"

