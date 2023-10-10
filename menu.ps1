function main {
    Clear-Host
    Write-Host "1 - Création de VM"
    Write-Host "2 - Suppression de VM"
    Write-Host "3 - Liste de VM"
    $userchoice = Read-Host "Votre choix ?"

    switch ($userchoice) {
        '1' {
            Write-Host "Vous avez choisi la création de VM."
            # Lancer le script testproceed.ps1
            ./testproceed.ps1
        }
        '2' {
            Write-Host "Vous avez choisi la suppression de VM."
            
            
        }
        '3' {
            Write-Host "Vous avez choisi la liste de VM."
            Get-VM
        }
        default {
            Write-Host "Choix invalide. Veuillez sélectionner une option valide (1, 2 ou 3)."
        }
    }
}


main
