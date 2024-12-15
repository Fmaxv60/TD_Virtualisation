###################################################################
#                       TD Virtualisation                         #
#   author : Maxime Violette maxime.violette@etu.unilasalle.fr    #
###################################################################

Add-Type -AssemblyName System.Windows.Forms

# Fonction pour créer une machine virtuelle
function Create-VM {
    param (
        [string]$VMName,
        [int]$RAM,
        [int]$Storage
    )

    # Création de la machine virtuelle avec VBoxManage
    VBoxManage createvm --name $VMName --register
    VBoxManage modifyvm $VMName --memory $RAM --acpi on --boot1 dvd
    VBoxManage createmedium disk --filename "$VMName.vdi" --size $Storage --format VDI
    VBoxManage storagectl $VMName --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach $VMName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VMName.vdi"

    [System.Windows.Forms.MessageBox]::Show("La machine virtuelle '$VMName' a été créée avec succès.", "Succès")
}

# Fonction pour démarrer une machine virtuelle
function Start-VM {
    param (
        [string]$VMName
    )

    VBoxManage startvm $VMName --type gui
    [System.Windows.Forms.MessageBox]::Show("La machine virtuelle '$VMName' a été démarrée.", "Succès")
}

# Fonction pour supprimer une machine virtuelle
function Delete-VM {
    param (
        [string]$VMName
    )

    VBoxManage unregistervm $VMName --delete
    [System.Windows.Forms.MessageBox]::Show("La machine virtuelle '$VMName' a été supprimée.", "Succès")
}

# Fonction pour cloner une machine virtuelle
function Clone-VM {
    param (
        [string]$SourceVMName,
        [string]$NewVMName
    )

    VBoxManage clonevm $SourceVMName --name $NewVMName --register
    [System.Windows.Forms.MessageBox]::Show("La machine virtuelle '$SourceVMName' a été clonée sous le nom '$NewVMName'.", "Succès")
}

# Fonction pour importer une VM depuis une image OVA
function Import-OVA {
    param (
        [string]$OVAPath,
        [string]$NewVMName,
        [string]$selectedVM
    )

    VBoxManage import $OVAPath --vsys 0 --vmname $NewVMName
    [System.Windows.Forms.MessageBox]::Show("La machine a été cloné (OVA) sous le nom '$NewVMName'.", "Succès")
}

# Fonction pour afficher la liste des machines virtuelles
function List-VMs {
    $vmList = VBoxManage list vms | ForEach-Object {
        $_ -match '"(.*?)"' | Out-Null
        $matches[1]
    }
    return $vmList
}

# Création de l'interface graphique
$form = New-Object System.Windows.Forms.Form
$form.Text = "VirtualBox Manager"
$form.Size = New-Object System.Drawing.Size(800, 800)
$form.StartPosition = "CenterScreen"

$groupBox1 = New-Object System.Windows.Forms.GroupBox
$groupBox1.Text = "Créer une VM"
$groupBox1.Size = New-Object System.Drawing.Size(350, 300)
$groupBox1.Location = New-Object System.Drawing.Point(20, 300)

$groupBox2 = New-Object System.Windows.Forms.GroupBox
$groupBox2.Text = "Cloner une VM"
$groupBox2.Size = New-Object System.Drawing.Size(350, 300)
$groupBox2.Location = New-Object System.Drawing.Point(400, 300)

# Champs de saisie pour le nom de la VM
$labelName = New-Object System.Windows.Forms.Label
$labelName.Text = "Nom de la VM :"
$labelName.Location = New-Object System.Drawing.Point(10, 20)
$groupBox1.Controls.Add($labelName)

$textBoxName = New-Object System.Windows.Forms.TextBox
$textBoxName.Location = New-Object System.Drawing.Point(120, 20)
$textBoxName.Width = 200
$groupBox1.Controls.Add($textBoxName)

# Champs de saisie pour la RAM
$labelRAM = New-Object System.Windows.Forms.Label
$labelRAM.Text = "RAM (MB) :"
$labelRAM.Location = New-Object System.Drawing.Point(10, 60)
$groupBox1.Controls.Add($labelRAM)

$textBoxRAM = New-Object System.Windows.Forms.TextBox
$textBoxRAM.Location = New-Object System.Drawing.Point(120, 60)
$textBoxRAM.Width = 200
$groupBox1.Controls.Add($textBoxRAM)

# Champs de saisie pour le stockage
$labelStorage = New-Object System.Windows.Forms.Label
$labelStorage.Text = "Stockage (MB) :"
$labelStorage.Location = New-Object System.Drawing.Point(10, 100)
$groupBox1.Controls.Add($labelStorage)

$textBoxStorage = New-Object System.Windows.Forms.TextBox
$textBoxStorage.Location = New-Object System.Drawing.Point(120, 100)
$textBoxStorage.Width = 200
$groupBox1.Controls.Add($textBoxStorage)

# Liste des VMs
$labelVMList = New-Object System.Windows.Forms.Label
$labelVMList.Text = "Liste des VMs :"
$labelVMList.Location = New-Object System.Drawing.Point(15, 10)
$form.Controls.Add($labelVMList)

$listBoxVMs = New-Object System.Windows.Forms.ListBox
$listBoxVMs.Location = New-Object System.Drawing.Point(15, 35)
$listBoxVMs.Size = New-Object System.Drawing.Size(300, 250)
$form.Controls.Add($listBoxVMs)

$listBoxVMs.Items.Clear()
    $vmList = List-VMs
    foreach ($vm in $vmList) {
        $listBoxVMs.Items.Add($vm)
    }

# Bouton pour actualiser la liste des VMs
$buttonRefresh = New-Object System.Windows.Forms.Button
$buttonRefresh.Text = "Actualiser la liste"
$buttonRefresh.Size = New-Object System.Drawing.Size(100, 30)
$buttonRefresh.Location = New-Object System.Drawing.Point(330, 34)
$buttonRefresh.Add_Click({
    $listBoxVMs.Items.Clear()
    $vmList = List-VMs
    foreach ($vm in $vmList) {
        $listBoxVMs.Items.Add($vm)
    }
})
$form.Controls.Add($buttonRefresh)

# Bouton pour créer une VM
$buttonCreate = New-Object System.Windows.Forms.Button
$buttonCreate.Text = "Créer VM"
$buttonCreate.Size = New-Object System.Drawing.Size(100, 30)
$buttonCreate.Location = New-Object System.Drawing.Point(10, 150)
$buttonCreate.Add_Click({
    $VMName = $textBoxName.Text
    $RAM = [int]$textBoxRAM.Text
    $Storage = [int]$textBoxStorage.Text

    if (-not $VMName -or -not $RAM -or -not $Storage) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez remplir tous les champs.", "Erreur")
        return
    }

    Create-VM -VMName $VMName -RAM $RAM -Storage $Storage
    $buttonRefresh.PerformClick()
})
$groupBox1.Controls.Add($buttonCreate)

# Bouton pour démarrer une VM
$buttonStart = New-Object System.Windows.Forms.Button
$buttonStart.Text = "Démarrer VM"
$buttonStart.Size = New-Object System.Drawing.Size(100, 30)
$buttonStart.Location = New-Object System.Drawing.Point(330, 74)
$buttonStart.Add_Click({
    $selectedVM = $listBoxVMs.SelectedItem

    if (-not $selectedVM) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez sélectionner une VM dans la liste.", "Erreur")
        return
    }

    Start-VM -VMName $selectedVM
})
$form.Controls.Add($buttonStart)

# Bouton pour supprimer une VM
$buttonDelete = New-Object System.Windows.Forms.Button
$buttonDelete.Text = "Supprimer VM"
$buttonDelete.Size = New-Object System.Drawing.Size(100, 30)
$buttonDelete.Location = New-Object System.Drawing.Point(330, 114)
$buttonDelete.Add_Click({
    $selectedVM = $listBoxVMs.SelectedItem

    if (-not $selectedVM) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez sélectionner une VM à supprimer.", "Erreur")
        return
    }

    $confirmation = [System.Windows.Forms.MessageBox]::Show("Êtes-vous sûr de vouloir supprimer la VM '$selectedVM' ?", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNo)

    if ($confirmation -eq [System.Windows.Forms.DialogResult]::Yes) {
        Delete-VM -VMName $selectedVM
        $listBoxVMs.Items.Remove($selectedVM)
    }
    $buttonRefresh.PerformClick()
})
$form.Controls.Add($buttonDelete)

# Champs pour le nouveau nom de la VM lors du clonage
$labelCloneName = New-Object System.Windows.Forms.Label
$labelCloneName.Text = "Nom de la nouvelle VM :"
$labelCloneName.Location = New-Object System.Drawing.Point(10, 20)
$groupBox2.Controls.Add($labelCloneName)

$textBoxCloneName = New-Object System.Windows.Forms.TextBox
$textBoxCloneName.Location = New-Object System.Drawing.Point(120, 20)
$textBoxCloneName.Width = 200
$groupBox2.Controls.Add($textBoxCloneName)

# Bouton pour cloner une VM
$buttonClone = New-Object System.Windows.Forms.Button
$buttonClone.Text = "Cloner VM"
$buttonClone.Size = New-Object System.Drawing.Size(100, 30)
$buttonClone.Location = New-Object System.Drawing.Point(10, 60)
$buttonClone.Add_Click({
    $selectedVM = $listBoxVMs.SelectedItem
    $newVMName = $textBoxCloneName.Text

    if (-not $selectedVM) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez sélectionner une VM à cloner.", "Erreur")
        return
    }

    if (-not $newVMName) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez entrer un nom pour la nouvelle VM.", "Erreur")
        return
    }

    Clone-VM -SourceVMName $selectedVM -NewVMName $newVMName
    $buttonRefresh.PerformClick()
})
$groupBox2.Controls.Add($buttonClone)

# Bouton pour importer une OVA
$buttonImportOVA = New-Object System.Windows.Forms.Button
$buttonImportOVA.Text = "Importer OVA"
$buttonImportOVA.Size = New-Object System.Drawing.Size(100, 30)
$buttonImportOVA.Location = New-Object System.Drawing.Point(120, 60)
$buttonImportOVA.Add_Click({
    $selectedVM = $listBoxVMs.SelectedItem
    $newVMName = $textBoxCloneName.Text

    $OVAPath = "C:\Users\violette_m\VirtualBox VMs\Export\" + $selectedVM + ".ova"

    if (-not $selectedVM) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez sélectionner une VM à cloner.", "Erreur")
        return
    }

    if (-not $newVMName) {
        [System.Windows.Forms.MessageBox]::Show("Veuillez entrer un nom pour la nouvelle VM.", "Erreur")
        return
    }

    if (!(Test-Path -Path $OVAPath)){
        VBoxManage export $selectedVM -o $OVAPath
    }

    Import-OVA -OVAPath $OVAPath -NewVMName $newVMName -selectedVM $selectedVM
    $buttonRefresh.PerformClick()
})
$groupBox2.Controls.Add($buttonImportOVA)

$form.Controls.Add($groupBox1)
$form.Controls.Add($groupBox2)

# Affichage de l'interface graphique
[void]$form.ShowDialog()
