Clear-Host
$Name = "AmazonSSMAgent"
$Service = Get-Service -display $Name -ErrorAction SilentlyContinue
If (-Not $Service) {
  If (Test-Path -Path C:\chef\cache\EC2Install) {
    Remove-item C:\chef\cache\EC2*.*
    Remove-item C:\chef\cache\EC2Install -recurse
  }
  Add-Type -AssemblyName System.IO.Compression.FileSystem
            function Unzip
            {
              param([string]$zipfile, [string]$outpath)
              [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
            }
            Invoke-WebRequest -Uri https://s3.amazonaws.com/ec2-downloads-windows/EC2Config/EC2Install.zip -UseBasicParsing -OutFile C:\chef\cache\EC2Install.zip
            Unzip C:\chef\cache\EC2Install.zip C:\chef\cache\EC2Install
            $Name = "Ec2Config"
            $Service = Get-Service -display $Name -ErrorAction SilentlyContinue
            If (-Not $Service) {
                C:\chef\cache\EC2Install\EC2Install.exe /install /quiet /norestart
            } else {
                C:\chef\cache\EC2Install\EC2Install.exe /repair /quiet /norestart
            }
}
Else {
  'SSM Agent Service exists'
}
