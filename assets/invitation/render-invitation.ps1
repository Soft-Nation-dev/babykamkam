Add-Type -AssemblyName System.Drawing

$assetDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$backgroundPath = Join-Path $assetDir 'vintage-background-v1.png'
$outputPath = Join-Path $assetDir 'invitation-v1.png'
$webOutputPath = Join-Path $assetDir 'invitation-v1-web.jpg'

$source = [System.Drawing.Image]::FromFile($backgroundPath)
$bitmap = New-Object System.Drawing.Bitmap($source.Width, $source.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$bitmap.SetResolution(144, 144)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$graphics.DrawImage($source, 0, 0, $source.Width, $source.Height)

$burgundy = [System.Drawing.Color]::FromArgb(112, 29, 56)
$deepBurgundy = [System.Drawing.Color]::FromArgb(80, 20, 39)
$gold = [System.Drawing.Color]::FromArgb(154, 116, 38)
$ink = [System.Drawing.Color]::FromArgb(76, 53, 47)

$burgundyBrush = New-Object System.Drawing.SolidBrush($burgundy)
$deepBrush = New-Object System.Drawing.SolidBrush($deepBurgundy)
$goldBrush = New-Object System.Drawing.SolidBrush($gold)
$inkBrush = New-Object System.Drawing.SolidBrush($ink)
$goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(150, $gold), 1.4)

function New-Font([string]$family, [float]$size, [System.Drawing.FontStyle]$style = [System.Drawing.FontStyle]::Regular) {
  return New-Object System.Drawing.Font($family, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
}

function Draw-Centered([string]$text, [System.Drawing.Font]$font, [System.Drawing.Brush]$brush, [float]$y) {
  $format = New-Object System.Drawing.StringFormat
  $format.Alignment = [System.Drawing.StringAlignment]::Center
  $format.LineAlignment = [System.Drawing.StringAlignment]::Near
  $graphics.DrawString($text, $font, $brush, [System.Drawing.RectangleF]::new(100, $y, $bitmap.Width - 200, 130), $format)
  $format.Dispose()
}

$eyebrowFont = New-Font 'Georgia' 23 ([System.Drawing.FontStyle]::Bold)
$parentsFont = New-Font 'Palatino Linotype' 38 ([System.Drawing.FontStyle]::Bold)
$requestFont = New-Font 'Georgia' 27 ([System.Drawing.FontStyle]::Italic)
$titleFont = New-Font 'Palatino Linotype' 54 ([System.Drawing.FontStyle]::Bold)
$belovedFont = New-Font 'Georgia' 25 ([System.Drawing.FontStyle]::Italic)
$nameFont = New-Font 'Monotype Corsiva' 78 ([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Italic)
$surnameFont = New-Font 'Palatino Linotype' 35 ([System.Drawing.FontStyle]::Bold)
$dateFont = New-Font 'Georgia' 33 ([System.Drawing.FontStyle]::Bold)
$timeFont = New-Font 'Georgia' 27 ([System.Drawing.FontStyle]::Bold)
$labelFont = New-Font 'Georgia' 19 ([System.Drawing.FontStyle]::Bold)
$venueFont = New-Font 'Georgia' 28 ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font 'Georgia' 24
$rsvpFont = New-Font 'Georgia' 23 ([System.Drawing.FontStyle]::Bold)
$hashtagFont = New-Font 'Georgia' 28 ([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Italic)

Draw-Centered 'W I T H   J O Y F U L   H E A R T S' $eyebrowFont $goldBrush 230
Draw-Centered 'Engr. & Mrs. Asogwa' $parentsFont $deepBrush 278
Draw-Centered 'warmly invite you to celebrate the' $requestFont $inkBrush 328

$graphics.DrawLine($goldPen, 338, 388, 486, 388)
$graphics.DrawLine($goldPen, 606, 388, 754, 388)
Draw-Centered '❦' (New-Font 'Georgia' 17) $goldBrush 371

Draw-Centered 'CHILD DEDICATION' $titleFont $burgundyBrush 417
Draw-Centered 'of their beloved daughter' $belovedFont $inkBrush 485
Draw-Centered 'Anaya' $nameFont $deepBrush 521
Draw-Centered 'K A M S I Y O C H U K W U' $surnameFont $burgundyBrush 606

$graphics.DrawLine($goldPen, 220, 672, 872, 672)
Draw-Centered 'Sunday · 13 December 2026' $dateFont $deepBrush 704
Draw-Centered 'RECEPTION  ·  2:00 PM' $timeFont $goldBrush 755
$graphics.DrawLine($goldPen, 220, 806, 872, 806)

Draw-Centered 'V E N U E' $labelFont $goldBrush 838
Draw-Centered "K'ville" $venueFont $deepBrush 875
Draw-Centered 'No. 16 Ituku Street, Upper Chime' $bodyFont $inkBrush 918
Draw-Centered 'New Haven' $bodyFont $inkBrush 953

Draw-Centered 'R S V P' $labelFont $goldBrush 1005
Draw-Centered '0706 492 0604  ·  0812 025 5042' $rsvpFont $inkBrush 1042
Draw-Centered '#BabyKamkam' $hashtagFont $burgundyBrush 1094

$bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$encoderParameters = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParameters.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]93)
$bitmap.Save($webOutputPath, $jpegEncoder, $encoderParameters)
$encoderParameters.Dispose()

@($eyebrowFont, $parentsFont, $requestFont, $titleFont, $belovedFont, $nameFont, $surnameFont, $dateFont, $timeFont, $labelFont, $venueFont, $bodyFont, $rsvpFont, $hashtagFont, $burgundyBrush, $deepBrush, $goldBrush, $inkBrush, $goldPen, $graphics, $bitmap, $source) | ForEach-Object { if ($_ -is [System.IDisposable]) { $_.Dispose() } }

Write-Output $outputPath
Write-Output $webOutputPath
