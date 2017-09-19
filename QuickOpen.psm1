# √删除无效路径
# ×支持在后面添加 / 打开子目录
# ×如果路径包含 *，支持检索子目录
function open {
    if($args.Length -eq 0){
        Write-Warning "Please provide a path.";
        return;
    }
    $t = ("*" + ($args -join "*") + "*")
    $raw = Get-Content $HOME/psconfig/quickopen.txt;
    $s = New-Object System.Collections.ArrayList;
    foreach ($item in $raw) {
        if(Test-Path $item){
            $s.Add($item) | Out-Null;
        }
    }
    $s = Get-Item ($s) -Force
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
    if($args.Length -eq 0){
        Write-Warning "Please provide a path.";
        return;
    }
    $s = (Get-Content $HOME/psconfig/quickopen.txt)
    $t = New-Object System.Collections.ArrayList
    
    $Add = ($args -join " ")

    if(Test-Path $Add){
        foreach ($item in $s) {
            $t.Add($item) | Out-Null
        }
    
        $t.Add($Add) | Out-Null
        Set-Content -Path $HOME/psconfig/quickopen.txt -Value $t;
    }
}

function unpin {
    if($args.Length -eq 0){
        Write-Warning "Please provide a path.";
        return;
    }
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
    $raw = Get-Content $HOME/psconfig/quickopen.txt;
    $s = New-Object System.Collections.ArrayList;
    foreach ($item in $raw) {
        if(Test-Path $item){
            $s.Add($item) | Out-Null;
        }
    }
    if(-not ($raw.Length -eq $s.Length)){
        Set-Content -Path $HOME/psconfig/quickopen.txt -Value $s;
    }
    $t = ("*" + ($args -join "*") + "*")
    if($t){
        $s = Get-Item ($s) -Force
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

# function ParsePath ($str) {
#     $obj = New-Object System.Object;
#     Add-Member -InputObject $obj -Name type -Value 
#     if()
# }
