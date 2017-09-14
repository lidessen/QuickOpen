function open {
    # 删除无效路径
    # 支持在后面添加 / 打开子目录
    # 如果路径包含 *，支持检索子目录
    $t = ("*" + ($args -join "*") + "*")
    $s = Get-Item (Get-Content $HOME/psconfig/quickopen.txt)
    foreach ($item in $s) {
        if ($item.Name -like $t){
            if($item.PsIsContainer){
                explorer.exe $item.FullName;
            }else{
                explorer.exe $item.Directory.Parent.FullName;
            }
        }
    }
}

function pin {
    $s = (Get-Content $HOME/psconfig/quickopen.txt)
    $t = New-Object System.Collections.ArrayList
    
    $Add = ($args -join " ")

    foreach ($item in $s) {
        $t.Add($item) | Out-Null
    }

    if($Add){
        $t.Add($Add) | Out-Null
    }
    Set-Content -Path $HOME/psconfig/quickopen.txt -Value $t;
}

function unpin {
    $s = (Get-Content $HOME/psconfig/quickopen.txt)
    $t = New-Object System.Collections.ArrayList
    
    $Remove = ($args -join " ")

    foreach ($item in $s) {
        $t.Add($item) | Out-Null
    }

    if($Remove){
        $t.Remove($Remove) | Out-Null
    }
    Set-Content -Path $HOME/psconfig/quickopen.txt -Value $t;
}

function pined {
    $t = ("*" + ($args -join "*") + "*")
    if($t){ 
        $s = Get-Item (Get-Content $HOME/psconfig/quickopen.txt)
        foreach ($item in $s) {
            if ($item.Name -like $t){
                $item.FullName;
            }
        }
    }
    else{
        Write-Host -ForegroundColor 2 (Get-Content $HOME/psconfig/quickopen.txt)
    }
}
