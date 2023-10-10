$isoFile = "C:\Users\aboubakeur.trichine\Downloads\SERVER_EVAL_x64FRE_en-us.iso"#le chemin vers le fichier ISO
$vmName = 'MaVm'# le nom de la VM
$pass = 'Ab/21'#le mot de passe administrateur
# Fonction pour afficher une animation de chargement
function Show-LoadingAnimation {
    $animation = "/-\|"
    $index = 0
    while ($true) {
        Write-Host -NoNewLine $animation[$index]
        $index = ($index + 1) % $animation.Length
        Start-Sleep -Milliseconds 100
        Write-Host -NoNewLine "`b"  # Efface le dernier caractère
    }
}
# Affiche un message avant de commencer l'animation
Write-Host "Création de la VM en cours..."
# Démarre l'animation
$loading = [System.Threading.Tasks.Task]::Run({
    Show-LoadingAnimation
})

 #appel aux script pour créer une nouvelle VM à partir de l'image ISO spécifiée
.\New-VMFromWindowsImage.ps1 -SourcePath $isoFile -Edition 'Windows Server 2022 Standard Evaluation (Desktop Experience)' -VMName $vmName -VHDXSizeBytes 120GB -AdministratorPassword $pass  -Version 'Server2022Standard' -MemoryStartupBytes 2GB -VMProcessorCount 4

$sess = .\New-VMSession.ps1 -VMName $vmName -AdministratorPassword $pass# appel le scrpte pour créer une session de gestion à distance vers la VM 

#activer la gestion à distance vers la VM
.\Enable-RemoteManagementViaSession.ps1 -Session $sess

# exécute des commandes à l'intérieur de la VM en utilisant la session de gestion à distance
Invoke-Command -Session $sess {
    # Arrête l'animation une fois la création terminée
    $loading.Dispose()
 
    echo "salut, Abou! (from $env:COMPUTERNAME)"

    # Install chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Install 7-zip
    choco install 7zip -y
    choco install mariadb.install
    choco install mariadb
    choco install iis.administration -y
}
#ferme la session de gestion à distance avec la VM.
Remove-PSSession -Session $sess