# √删除无效路径
# ×支持在后面添加 / 打开子目录
# ×如果路径包含 *，支持检索子目录
function open {
    if($args.Length -eq 0){
        Write-Warning "Please provide a path.";
        return;
    }
    $t_args = $args | Where-Object {
        !$_.ToString().StartsWith("-")
    }
    $t = ("*" + ($t_args -join "*") + "*")
    CheckPath
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
            if($args -contains "--code") {
                if(Get-Command code-insiders -errorAction SilentlyContinue) {
                    code-insiders $item.FullName
                    return
                }
                if(Get-Command code -errorAction SilentlyContinue) {
                    code $item.FullName
                    return
                }
            }
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
    CheckPath
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
    CheckPath
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
    CheckPath
    $raw = Get-Content $HOME/psconfig/quickopen.txt;
    if($raw.Length -eq 0) {
        return
    }
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

function CheckPath {
    if(!((Test-Path $HOME/psconfig/quickopen.txt) -eq $true)) {
        if(!((Test-Path $HOME/psconfig) -eq $true)) {
            mkdir $HOME/psconfig
        }
        New-Item $HOME/psconfig/quickopen.txt -ItemType File
    }
}

# function ParsePath ($str) {
#     $obj = New-Object System.Object;
#     Add-Member -InputObject $obj -Name type -Value 
#     if()
# }
