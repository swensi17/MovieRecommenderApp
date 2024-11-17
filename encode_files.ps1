# Пути к файлам
$certificatePath = "Sajida Parveen.p12"
$profilePath = "00008130-001C6C100151001C.mobileprovision"

# Кодируем сертификат
if (Test-Path $certificatePath) {
    Write-Host "`nEncoding certificate..."
    $certificateBase64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($certificatePath))
    Set-Content -Path "certificate_base64.txt" -Value $certificateBase64
    Write-Host "Certificate encoded and saved to certificate_base64.txt"
} else {
    Write-Host "Certificate file not found at: $certificatePath"
}

# Кодируем профиль
if (Test-Path $profilePath) {
    Write-Host "`nEncoding provisioning profile..."
    $profileBase64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($profilePath))
    Set-Content -Path "profile_base64.txt" -Value $profileBase64
    Write-Host "Profile encoded and saved to profile_base64.txt"
} else {
    Write-Host "Profile file not found at: $profilePath"
}

Write-Host "`nDone! Please check certificate_base64.txt and profile_base64.txt for the encoded values."
