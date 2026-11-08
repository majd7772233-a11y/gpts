@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul
title ADB - Send files to Android

set "ADB=C:\ADB\adb.exe"
if not exist "%ADB%" (
    echo [ERROR] Could not find ADB at: %ADB%
    echo Check that C:\ADB\adb.exe exists.
    pause
    exit /b 1
)

set "TEMP_TAG=%RANDOM%_%RANDOM%"
set "GUI_B64=%TEMP%\ADB_Send_File_%TEMP_TAG%.b64"
set "GUI_SCRIPT=%TEMP%\ADB_Send_File_%TEMP_TAG%.ps1"
set "ADB_PATH=%ADB%"

>"%GUI_B64%" (
    echo 77u/JEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9ICdTdG9wJwpBZGQtVHlwZSAtQXNzZW1ibHlOYW1l
    echo IFN5c3RlbS5XaW5kb3dzLkZvcm1zCkFkZC1UeXBlIC1Bc3NlbWJseU5hbWUgU3lzdGVtLkRyYXdp
    echo bmcKW1N5c3RlbS5XaW5kb3dzLkZvcm1zLkFwcGxpY2F0aW9uXTo6RW5hYmxlVmlzdWFsU3R5bGVz
    echo KCkKCiRtb2RlID0gJGVudjpBREJfR1VJX01PREUKJHJlc3VsdEZpbGUgPSAkZW52OkFEQl9HVUlf
    echo UkVTVUxUCiRhZGIgPSAkZW52OkFEQl9QQVRICgpmdW5jdGlvbiBXcml0ZS1TZWxlY3Rpb24oW3N0
    echo cmluZ10kdmFsdWUpIHsKICAgICR1dGY4ID0gW1N5c3RlbS5UZXh0LlVURjhFbmNvZGluZ106Om5l
    echo dygkZmFsc2UpCiAgICBbU3lzdGVtLklPLkZpbGVdOjpXcml0ZUFsbFRleHQoJHJlc3VsdEZpbGUs
    echo ICR2YWx1ZSwgJHV0ZjgpCn0KCmlmICgkbW9kZSAtZXEgJ0ZpbGVzJykgewogICAgJGRpYWxvZyA9
    echo IE5ldy1PYmplY3QgU3lzdGVtLldpbmRvd3MuRm9ybXMuT3BlbkZpbGVEaWFsb2cKICAgICRkaWFs
    echo b2cuVGl0bGUgPSAnQ2hvb3NlIG9uZSBvciBtb3JlIGZpbGVzIHRvIHNlbmQgdG8gdGhlIHNlbGVj
    echo dGVkIEFuZHJvaWQgbG9jYXRpb24nCiAgICAkZGlhbG9nLk11bHRpc2VsZWN0ID0gJHRydWUKICAg
    echo ICRkaWFsb2cuQ2hlY2tGaWxlRXhpc3RzID0gJHRydWUKICAgICRkaWFsb2cuUmVzdG9yZURpcmVj
    echo dG9yeSA9ICR0cnVlCiAgICAkZGlhbG9nLkZpbHRlciA9ICdBbGwgZmlsZXMgKCouKil8Ki4qJwog
    echo ICAgaWYgKCRkaWFsb2cuU2hvd0RpYWxvZygpIC1lcSBbU3lzdGVtLldpbmRvd3MuRm9ybXMuRGlh
    echo bG9nUmVzdWx0XTo6T0spIHsKICAgICAgICBXcml0ZS1TZWxlY3Rpb24gKCRkaWFsb2cuRmlsZU5h
    echo bWVzIC1qb2luIFtFbnZpcm9ubWVudF06Ok5ld0xpbmUpCiAgICB9CiAgICAkZGlhbG9nLkRpc3Bv
    echo c2UoKQogICAgZXhpdCAwCn0KCmlmICgkbW9kZSAtZXEgJ1B1c2hGaWxlcycpIHsKICAgICRzZXJp
    echo YWwgPSAkZW52OkFEQl9TRUxFQ1RFRF9ERVZJQ0UKICAgICRkZXN0aW5hdGlvbiA9ICRlbnY6QURC
    echo X1NFTEVDVEVEX0RFU1RJTkFUSU9OCiAgICAkZmlsZXMgPSBbU3lzdGVtLklPLkZpbGVdOjpSZWFk
    echo QWxsTGluZXMoJHJlc3VsdEZpbGUsIFtTeXN0ZW0uVGV4dC5FbmNvZGluZ106OlVURjgpCiAgICAk
    echo c3VjY2Vzc0NvdW50ID0gMAogICAgJGZhaWxlZENvdW50ID0gMAogICAgZm9yZWFjaCAoJGZpbGUg
    echo aW4gJGZpbGVzKSB7CiAgICAgICAgaWYgKFtzdHJpbmddOjpJc051bGxPcldoaXRlU3BhY2UoJGZp
    echo bGUpKSB7IGNvbnRpbnVlIH0KICAgICAgICBpZiAoLW5vdCBbU3lzdGVtLklPLkZpbGVdOjpFeGlz
    echo dHMoJGZpbGUpKSB7CiAgICAgICAgICAgIFdyaXRlLUhvc3QgIltFUlJPUl0gRmlsZSBub3QgZm91
    echo bmQ6ICRmaWxlIgogICAgICAgICAgICAkZmFpbGVkQ291bnQrKwogICAgICAgICAgICBjb250aW51
    echo ZQogICAgICAgIH0KICAgICAgICBXcml0ZS1Ib3N0ICcnCiAgICAgICAgV3JpdGUtSG9zdCAnLS0t
    echo LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
    echo JwogICAgICAgIFdyaXRlLUhvc3QgIltTRU5ESU5HXSAkZmlsZSIKICAgICAgICBXcml0ZS1Ib3N0
    echo ICJbVE9dICAgICAgJGRlc3RpbmF0aW9uIgogICAgICAgIFdyaXRlLUhvc3QgJy0tLS0tLS0tLS0t
    echo LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLScKICAgICAg
    echo ICAmICRhZGIgLXMgJHNlcmlhbCBwdXNoIC1wICRmaWxlICRkZXN0aW5hdGlvbgogICAgICAgICRw
    echo dXNoQ29kZSA9ICRMQVNURVhJVENPREUKICAgICAgICBpZiAoJHB1c2hDb2RlIC1lcSAwKSB7CiAg
    echo ICAgICAgICAgIFdyaXRlLUhvc3QgJ1tTVUNDRVNTXSBUaGlzIGZpbGUgd2FzIHRyYW5zZmVycmVk
    echo LicKICAgICAgICAgICAgJHN1Y2Nlc3NDb3VudCsrCiAgICAgICAgfSBlbHNlIHsKICAgICAgICAg
    echo ICAgV3JpdGUtSG9zdCAiW0VSUk9SXSBBREIgcHVzaCBmYWlsZWQgZm9yIHRoaXMgZmlsZS4gRXhp
    echo dCBjb2RlOiAkcHVzaENvZGUiCiAgICAgICAgICAgICRmYWlsZWRDb3VudCsrCiAgICAgICAgfQog
    echo ICAgfQogICAgV3JpdGUtSG9zdCAnJwogICAgV3JpdGUtSG9zdCAnPT09PT09PT09PT09PT09PT09
    echo PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09JwogICAgV3JpdGUtSG9z
    echo dCAiVHJhbnNmZXIgc3VtbWFyeTogJHN1Y2Nlc3NDb3VudCBzdWNjZWVkZWQsICRmYWlsZWRDb3Vu
    echo dCBmYWlsZWQuIgogICAgV3JpdGUtSG9zdCAnPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
    echo PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09JwogICAgaWYgKCRmYWlsZWRDb3VudCAtZ3Qg
    echo MCkgeyBleGl0IDEgfQogICAgaWYgKCRzdWNjZXNzQ291bnQgLWVxIDApIHsgZXhpdCAyIH0KICAg
    echo IGV4aXQgMAp9CgokZm9ybSA9IE5ldy1PYmplY3QgU3lzdGVtLldpbmRvd3MuRm9ybXMuRm9ybQok
    echo Zm9ybS5TdGFydFBvc2l0aW9uID0gJ0NlbnRlclNjcmVlbicKJGZvcm0uU2l6ZSA9IE5ldy1PYmpl
    echo Y3QgU3lzdGVtLkRyYXdpbmcuU2l6ZSg5MDAsIDU2MCkKJGZvcm0uTWluaW11bVNpemUgPSBOZXct
    echo T2JqZWN0IFN5c3RlbS5EcmF3aW5nLlNpemUoODIwLCA1MDApCiRmb3JtLkZvbnQgPSBOZXctT2Jq
    echo ZWN0IFN5c3RlbS5EcmF3aW5nLkZvbnQoJ1NlZ29lIFVJJywgOSkKJGZvcm0uQmFja0NvbG9yID0g
    echo W1N5c3RlbS5EcmF3aW5nLkNvbG9yXTo6RnJvbUFyZ2IoMjQ4LCAyNDksIDI1MikKJGZvcm0uTWF4
    echo aW1pemVCb3ggPSAkZmFsc2UKJGZvcm0uTWluaW1pemVCb3ggPSAkZmFsc2UKCiRoZWFkaW5nID0g
    echo TmV3LU9iamVjdCBTeXN0ZW0uV2luZG93cy5Gb3Jtcy5MYWJlbAokaGVhZGluZy5Mb2NhdGlvbiA9
    echo IE5ldy1PYmplY3QgU3lzdGVtLkRyYXdpbmcuUG9pbnQoMTgsIDE0KQokaGVhZGluZy5TaXplID0g
    echo TmV3LU9iamVjdCBTeXN0ZW0uRHJhd2luZy5TaXplKDg0NSwgMzApCiRoZWFkaW5nLkZvbnQgPSBO
    echo ZXctT2JqZWN0IFN5c3RlbS5EcmF3aW5nLkZvbnQoJ1NlZ29lIFVJIFNlbWlib2xkJywgMTIpCmlm
    echo ICgkbW9kZSAtZXEgJ0RldmljZScpIHsKICAgICRmb3JtLlRleHQgPSAnQ2hvb3NlIEFEQiBkZXZp
    echo Y2UnCiAgICAkaGVhZGluZy5UZXh0ID0gJ0Nob29zZSB0aGUgQW5kcm9pZCBkZXZpY2UgdG8gdXNl
    echo IGZvciB0aGlzIHRyYW5zZmVyJwp9IGVsc2UgewogICAgJGZvcm0uVGV4dCA9ICdDaG9vc2Ugc2F2
    echo ZSBkZXN0aW5hdGlvbicKICAgICRoZWFkaW5nLlRleHQgPSAn2KfYrtiq2LEg2YXZg9in2YYg2K3Z
    echo gdi4INin2YTZhdmE2YEg2LnZhNmJINin2YTZh9in2KrZgScKfQokZm9ybS5Db250cm9scy5BZGQo
    echo JGhlYWRpbmcpCgokbGlzdCA9IE5ldy1PYmplY3QgU3lzdGVtLldpbmRvd3MuRm9ybXMuTGlzdFZp
    echo ZXcKJGxpc3QuTG9jYXRpb24gPSBOZXctT2JqZWN0IFN5c3RlbS5EcmF3aW5nLlBvaW50KDE4LCA1
    echo NSkKJGxpc3QuU2l6ZSA9IE5ldy1PYmplY3QgU3lzdGVtLkRyYXdpbmcuU2l6ZSg4NDUsIDM5MCkK
    echo JGxpc3QuQW5jaG9yID0gJ1RvcCxCb3R0b20sTGVmdCxSaWdodCcKJGxpc3QuVmlldyA9IFtTeXN0
    echo ZW0uV2luZG93cy5Gb3Jtcy5WaWV3XTo6RGV0YWlscwokbGlzdC5GdWxsUm93U2VsZWN0ID0gJHRy
    echo dWUKJGxpc3QuR3JpZExpbmVzID0gJHRydWUKJGxpc3QuTXVsdGlTZWxlY3QgPSAkZmFsc2UKJGxp
    echo c3QuSGlkZVNlbGVjdGlvbiA9ICRmYWxzZQokbGlzdC5IZWFkZXJTdHlsZSA9IFtTeXN0ZW0uV2lu
    echo ZG93cy5Gb3Jtcy5Db2x1bW5IZWFkZXJTdHlsZV06Ok5vbmNsaWNrYWJsZQppZiAoJG1vZGUgLWVx
    echo ICdEZXZpY2UnKSB7CiAgICBbdm9pZF0kbGlzdC5Db2x1bW5zLkFkZCgnRGV2aWNlIHNlcmlhbCAv
    echo IElQJywgMjUwKQogICAgW3ZvaWRdJGxpc3QuQ29sdW1ucy5BZGQoJ1N0YXR1cycsIDEwNSkKICAg
    echo IFt2b2lkXSRsaXN0LkNvbHVtbnMuQWRkKCdEZXZpY2UgZGV0YWlscycsIDQ3MCkKfSBlbHNlIHsK
    echo ICAgIFt2b2lkXSRsaXN0LkNvbHVtbnMuQWRkKCfZhdmD2KfZhiDYp9mE2K3Zgdi4JywgMzAwKQog
    echo ICAgW3ZvaWRdJGxpc3QuQ29sdW1ucy5BZGQoJ0FuZHJvaWQgcGF0aCcsIDMzMCkKICAgIFt2b2lk
    echo XSRsaXN0LkNvbHVtbnMuQWRkKCdTdG9yYWdlJywgMTkwKQp9CiRmb3JtLkNvbnRyb2xzLkFkZCgk
    echo bGlzdCkKCiRzdGF0dXMgPSBOZXctT2JqZWN0IFN5c3RlbS5XaW5kb3dzLkZvcm1zLkxhYmVsCiRz
    echo dGF0dXMuTG9jYXRpb24gPSBOZXctT2JqZWN0IFN5c3RlbS5EcmF3aW5nLlBvaW50KDE4LCA0NTQp
    echo CiRzdGF0dXMuU2l6ZSA9IE5ldy1PYmplY3QgU3lzdGVtLkRyYXdpbmcuU2l6ZSg2MDAsIDI0KQok
    echo c3RhdHVzLkFuY2hvciA9ICdCb3R0b20sTGVmdCcKJHN0YXR1cy5Gb3JlQ29sb3IgPSBbU3lzdGVt
    echo LkRyYXdpbmcuQ29sb3JdOjpGcm9tQXJnYig3NSwgODUsIDk5KQokZm9ybS5Db250cm9scy5BZGQo
    echo JHN0YXR1cykKCiRyZWZyZXNoID0gTmV3LU9iamVjdCBTeXN0ZW0uV2luZG93cy5Gb3Jtcy5CdXR0
    echo b24KJHJlZnJlc2guVGV4dCA9ICdSZWZyZXNoJwokcmVmcmVzaC5TaXplID0gTmV3LU9iamVjdCBT
    echo eXN0ZW0uRHJhd2luZy5TaXplKDkyLCAzMikKJHJlZnJlc2guTG9jYXRpb24gPSBOZXctT2JqZWN0
    echo IFN5c3RlbS5EcmF3aW5nLlBvaW50KDU2MCwgNDg2KQokcmVmcmVzaC5BbmNob3IgPSAnQm90dG9t
    echo LFJpZ2h0JwokZm9ybS5Db250cm9scy5BZGQoJHJlZnJlc2gpCgokdXNlID0gTmV3LU9iamVjdCBT
    echo eXN0ZW0uV2luZG93cy5Gb3Jtcy5CdXR0b24KJHVzZS5UZXh0ID0gJ1VzZSBzZWxlY3RlZCcKJHVz
    echo ZS5TaXplID0gTmV3LU9iamVjdCBTeXN0ZW0uRHJhd2luZy5TaXplKDEzMiwgMzIpCiR1c2UuTG9j
    echo YXRpb24gPSBOZXctT2JqZWN0IFN5c3RlbS5EcmF3aW5nLlBvaW50KDY2MCwgNDg2KQokdXNlLkFu
    echo Y2hvciA9ICdCb3R0b20sUmlnaHQnCiR1c2UuRW5hYmxlZCA9ICRmYWxzZQokZm9ybS5Db250cm9s
    echo cy5BZGQoJHVzZSkKCiRjYW5jZWwgPSBOZXctT2JqZWN0IFN5c3RlbS5XaW5kb3dzLkZvcm1zLkJ1
    echo dHRvbgokY2FuY2VsLlRleHQgPSAnQ2FuY2VsJwokY2FuY2VsLlNpemUgPSBOZXctT2JqZWN0IFN5
    echo c3RlbS5EcmF3aW5nLlNpemUoODIsIDMyKQokY2FuY2VsLkxvY2F0aW9uID0gTmV3LU9iamVjdCBT
    echo eXN0ZW0uRHJhd2luZy5Qb2ludCg4MDAsIDQ4NikKJGNhbmNlbC5BbmNob3IgPSAnQm90dG9tLFJp
    echo Z2h0JwokZm9ybS5Db250cm9scy5BZGQoJGNhbmNlbCkKJGZvcm0uQ2FuY2VsQnV0dG9uID0gJGNh
    echo bmNlbAokZm9ybS5BY2NlcHRCdXR0b24gPSAkdXNlCgpmdW5jdGlvbiBHZXQtRGV2aWNlUm93cyB7
    echo CiAgICAkcm93cyA9IEAoKQogICAgJG91dHB1dCA9IEAoJiAkYWRiIGRldmljZXMgLWwgMj4kbnVs
    echo bCkKICAgIGZvcmVhY2ggKCRsaW5lIGluICRvdXRwdXQpIHsKICAgICAgICAkdHJpbW1lZCA9IChb
    echo c3RyaW5nXSRsaW5lKS5UcmltKCkKICAgICAgICBpZiAoW3N0cmluZ106OklzTnVsbE9yV2hpdGVT
    echo cGFjZSgkdHJpbW1lZCkpIHsgY29udGludWUgfQogICAgICAgIGlmICgkdHJpbW1lZCAtbWF0Y2gg
    echo J15MaXN0IG9mIGRldmljZXMgYXR0YWNoZWQnKSB7IGNvbnRpbnVlIH0KICAgICAgICBpZiAoJHRy
    echo aW1tZWQgLW1hdGNoICdeKFwqfGFkYiBzZXJ2ZXJ8ZXJyb3I6fGNhbm5vdCApJykgeyBjb250aW51
    echo ZSB9CiAgICAgICAgJHBhcnRzID0gJHRyaW1tZWQgLXNwbGl0ICdccysnLCAzCiAgICAgICAgaWYg
    echo KCRwYXJ0cy5Db3VudCAtbHQgMikgeyBjb250aW51ZSB9CiAgICAgICAgJGRldGFpbHMgPSAnJwog
    echo ICAgICAgIGlmICgkcGFydHMuQ291bnQgLWdlIDMpIHsgJGRldGFpbHMgPSAkcGFydHNbMl0gfQog
    echo ICAgICAgICRyb3dzICs9IFtwc2N1c3RvbW9iamVjdF1AeyBTZXJpYWwgPSAkcGFydHNbMF07IFN0
    echo YXRlID0gJHBhcnRzWzFdOyBEZXRhaWxzID0gJGRldGFpbHMgfQogICAgfQogICAgcmV0dXJuICRy
    echo b3dzCn0KCmZ1bmN0aW9uIFJlZnJlc2gtRGV2aWNlUm93cyB7CiAgICAkbGlzdC5CZWdpblVwZGF0
    echo ZSgpCiAgICAkbGlzdC5JdGVtcy5DbGVhcigpCiAgICAkcm93cyA9IEAoR2V0LURldmljZVJvd3Mp
    echo CiAgICBmb3JlYWNoICgkZGV2aWNlIGluICRyb3dzKSB7CiAgICAgICAgJGl0ZW0gPSBOZXctT2Jq
    echo ZWN0IFN5c3RlbS5XaW5kb3dzLkZvcm1zLkxpc3RWaWV3SXRlbShbc3RyaW5nXSRkZXZpY2UuU2Vy
    echo aWFsKQogICAgICAgIFt2b2lkXSRpdGVtLlN1Ykl0ZW1zLkFkZChbc3RyaW5nXSRkZXZpY2UuU3Rh
    echo dGUpCiAgICAgICAgW3ZvaWRdJGl0ZW0uU3ViSXRlbXMuQWRkKFtzdHJpbmddJGRldmljZS5EZXRh
    echo aWxzKQogICAgICAgICRpdGVtLlRhZyA9ICRkZXZpY2UKICAgICAgICBpZiAoJGRldmljZS5TdGF0
    echo ZSAtbmUgJ2RldmljZScpIHsKICAgICAgICAgICAgJGl0ZW0uRm9yZUNvbG9yID0gW1N5c3RlbS5E
    echo cmF3aW5nLkNvbG9yXTo6R3JheQogICAgICAgIH0KICAgICAgICBbdm9pZF0kbGlzdC5JdGVtcy5B
    echo ZGQoJGl0ZW0pCiAgICB9CiAgICAkbGlzdC5FbmRVcGRhdGUoKQogICAgJHJlYWR5ID0gQCgkcm93
    echo cyB8IFdoZXJlLU9iamVjdCB7ICRfLlN0YXRlIC1lcSAnZGV2aWNlJyB9KS5Db3VudAogICAgaWYg
    echo KCRyb3dzLkNvdW50IC1lcSAwKSB7CiAgICAgICAgJHN0YXR1cy5UZXh0ID0gJ05vIEFEQiBkZXZp
    echo Y2VzIGRldGVjdGVkLiBDb25uZWN0IGEgZGV2aWNlLCB0aGVuIGNsaWNrIFJlZnJlc2guJwogICAg
    echo fSBlbHNlIHsKICAgICAgICAkc3RhdHVzLlRleHQgPSAiJHJlYWR5IHJlYWR5IGRldmljZShzKS4g
    echo U2VsZWN0IG9uZSB3aXRoIHN0YXR1cyAnZGV2aWNlJy4iCiAgICB9CiAgICAkdXNlLkVuYWJsZWQg
    echo PSAkZmFsc2UKfQoKaWYgKCRtb2RlIC1lcSAnRGV2aWNlJykgewogICAgJHJlZnJlc2guVmlzaWJs
    echo ZSA9ICR0cnVlCiAgICBSZWZyZXNoLURldmljZVJvd3MKICAgICRyZWZyZXNoLkFkZF9DbGljayh7
    echo IFJlZnJlc2gtRGV2aWNlUm93cyB9KQogICAgJGxpc3QuQWRkX1NlbGVjdGVkSW5kZXhDaGFuZ2Vk
    echo KHsKICAgICAgICAkdXNlLkVuYWJsZWQgPSAkZmFsc2UKICAgICAgICBpZiAoJGxpc3QuU2VsZWN0
    echo ZWRJdGVtcy5Db3VudCAtZ3QgMCkgewogICAgICAgICAgICAkZGV2aWNlID0gJGxpc3QuU2VsZWN0
    echo ZWRJdGVtc1swXS5UYWcKICAgICAgICAgICAgaWYgKCRkZXZpY2UuU3RhdGUgLWVxICdkZXZpY2Un
    echo KSB7CiAgICAgICAgICAgICAgICAkdXNlLkVuYWJsZWQgPSAkdHJ1ZQogICAgICAgICAgICAgICAg
    echo JHN0YXR1cy5UZXh0ID0gJ1JlYWR5OiAnICsgJGRldmljZS5TZXJpYWwKICAgICAgICAgICAgfSBl
    echo bHNlIHsKICAgICAgICAgICAgICAgICRzdGF0dXMuVGV4dCA9ICdUaGlzIGRldmljZSBpcyBub3Qg
    echo cmVhZHk6ICcgKyAkZGV2aWNlLlN0YXRlCiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICB9KQog
    echo ICAgJHVzZS5BZGRfQ2xpY2soewogICAgICAgIGlmICgkbGlzdC5TZWxlY3RlZEl0ZW1zLkNvdW50
    echo IC1ndCAwKSB7CiAgICAgICAgICAgICRkZXZpY2UgPSAkbGlzdC5TZWxlY3RlZEl0ZW1zWzBdLlRh
    echo ZwogICAgICAgICAgICBpZiAoJGRldmljZS5TdGF0ZSAtZXEgJ2RldmljZScpIHsKICAgICAgICAg
    echo ICAgICAgIFdyaXRlLVNlbGVjdGlvbiAoW3N0cmluZ10kZGV2aWNlLlNlcmlhbCkKICAgICAgICAg
    echo ICAgICAgICRmb3JtLkRpYWxvZ1Jlc3VsdCA9IFtTeXN0ZW0uV2luZG93cy5Gb3Jtcy5EaWFsb2dS
    echo ZXN1bHRdOjpPSwogICAgICAgICAgICAgICAgJGZvcm0uQ2xvc2UoKQogICAgICAgICAgICB9CiAg
    echo ICAgICAgfQogICAgfSkKICAgICRsaXN0LkFkZF9Eb3VibGVDbGljayh7IGlmICgkdXNlLkVuYWJs
    echo ZWQpIHsgJHVzZS5QZXJmb3JtQ2xpY2soKSB9IH0pCn0gZWxzZWlmICgkbW9kZSAtZXEgJ0Rlc3Rp
    echo bmF0aW9uJykgewogICAgJHJlZnJlc2guVmlzaWJsZSA9ICRmYWxzZQogICAgJGRlc3RpbmF0aW9u
    echo cyA9IEAoCiAgICAgICAgW3BzY3VzdG9tb2JqZWN0XUB7IExhYmVsID0gJ9io2LfYp9mC2KkgU0Qg
    echo LSDZhdis2YTYryDYp9mE2YPYp9mF2YrYsdinICjYp9mE2LHYptmK2LPZiiknOyBQYXRoID0gJy9z
    echo dG9yYWdlLzMxNjUtNjQzNC9EQ0lNL0NhbWVyYS8nOyBUeXBlID0gJ0V4dGVybmFsIFNEIENhcmQn
    echo IH0sCiAgICAgICAgW3BzY3VzdG9tb2JqZWN0XUB7IExhYmVsID0gJ9io2LfYp9mC2KkgU0QgLSDY
    echo rNiw2LEg2KfZhNio2LfYp9mC2Kkg2YXYqNin2LTYsdipJzsgUGF0aCA9ICcvc3RvcmFnZS8zMTY1
    echo LTY0MzQvJzsgVHlwZSA9ICdFeHRlcm5hbCBTRCBDYXJkJyB9LAogICAgICAgIFtwc2N1c3RvbW9i
    echo amVjdF1AeyBMYWJlbCA9ICfYp9mE2KrYrtiy2YrZhiDYp9mE2K/Yp9iu2YTZiiAtINin2YTYrNiw
    echo 2LEg2YXYqNin2LTYsdipJzsgUGF0aCA9ICcvc2RjYXJkLyc7IFR5cGUgPSAnSW50ZXJuYWwgc3Rv
    echo cmFnZScgfSwKICAgICAgICBbcHNjdXN0b21vYmplY3RdQHsgTGFiZWwgPSAn2KfZhNiq2K7YstmK
    echo 2YYg2KfZhNiv2KfYrtmE2YogLSBEQ0lNL0NhbWVyYSc7IFBhdGggPSAnL3NkY2FyZC9EQ0lNL0Nh
    echo bWVyYS8nOyBUeXBlID0gJ0ludGVybmFsIHN0b3JhZ2UnIH0KICAgICkKICAgIGZvcmVhY2ggKCRk
    echo ZXN0aW5hdGlvbiBpbiAkZGVzdGluYXRpb25zKSB7CiAgICAgICAgJGl0ZW0gPSBOZXctT2JqZWN0
    echo IFN5c3RlbS5XaW5kb3dzLkZvcm1zLkxpc3RWaWV3SXRlbShbc3RyaW5nXSRkZXN0aW5hdGlvbi5M
    echo YWJlbCkKICAgICAgICBbdm9pZF0kaXRlbS5TdWJJdGVtcy5BZGQoW3N0cmluZ10kZGVzdGluYXRp
    echo b24uUGF0aCkKICAgICAgICBbdm9pZF0kaXRlbS5TdWJJdGVtcy5BZGQoW3N0cmluZ10kZGVzdGlu
    echo YXRpb24uVHlwZSkKICAgICAgICAkaXRlbS5UYWcgPSAkZGVzdGluYXRpb24KICAgICAgICBbdm9p
    echo ZF0kbGlzdC5JdGVtcy5BZGQoJGl0ZW0pCiAgICB9CiAgICAkc3RhdHVzLlRleHQgPSAn2KfZhNmF
    echo 2LPYp9ixINin2YTYo9mI2YQg2YfZiCDYp9mE2KfZgdiq2LHYp9i22Yog2KfZhNmF2YjYtdmJINio
    echo 2YcuINin2YbZgtixINmF2LHYqtmK2YYg2KPZiCDYp9iu2KrYsSDYq9mFINin2LbYuti3IFVzZSBz
    echo ZWxlY3RlZC4nCiAgICAkbGlzdC5BZGRfU2VsZWN0ZWRJbmRleENoYW5nZWQoewogICAgICAgICR1
    echo c2UuRW5hYmxlZCA9ICgkbGlzdC5TZWxlY3RlZEl0ZW1zLkNvdW50IC1ndCAwKQogICAgICAgIGlm
    echo ICgkbGlzdC5TZWxlY3RlZEl0ZW1zLkNvdW50IC1ndCAwKSB7CiAgICAgICAgICAgICRzdGF0dXMu
    echo VGV4dCA9ICRsaXN0LlNlbGVjdGVkSXRlbXNbMF0uVGFnLlBhdGgKICAgICAgICB9CiAgICB9KQog
    echo ICAgJHVzZS5BZGRfQ2xpY2soewogICAgICAgIGlmICgkbGlzdC5TZWxlY3RlZEl0ZW1zLkNvdW50
    echo IC1ndCAwKSB7CiAgICAgICAgICAgICRkZXN0aW5hdGlvbiA9ICRsaXN0LlNlbGVjdGVkSXRlbXNb
    echo MF0uVGFnCiAgICAgICAgICAgIFdyaXRlLVNlbGVjdGlvbiAoW3N0cmluZ10kZGVzdGluYXRpb24u
    echo UGF0aCkKICAgICAgICAgICAgJGZvcm0uRGlhbG9nUmVzdWx0ID0gW1N5c3RlbS5XaW5kb3dzLkZv
    echo cm1zLkRpYWxvZ1Jlc3VsdF06Ok9LCiAgICAgICAgICAgICRmb3JtLkNsb3NlKCkKICAgICAgICB9
    echo CiAgICB9KQogICAgJGxpc3QuQWRkX0RvdWJsZUNsaWNrKHsgaWYgKCR1c2UuRW5hYmxlZCkgeyAk
    echo dXNlLlBlcmZvcm1DbGljaygpIH0gfSkKfSBlbHNlIHsKICAgICRmb3JtLkNsb3NlKCkKfQoKJGNh
    echo bmNlbC5BZGRfQ2xpY2soewogICAgJGZvcm0uRGlhbG9nUmVzdWx0ID0gW1N5c3RlbS5XaW5kb3dz
    echo LkZvcm1zLkRpYWxvZ1Jlc3VsdF06OkNhbmNlbAogICAgJGZvcm0uQ2xvc2UoKQp9KQpbdm9pZF0k
    echo Zm9ybS5TaG93RGlhbG9nKCkKJGZvcm0uRGlzcG9zZSgpCg==
)
certutil.exe -f -decode "%GUI_B64%" "%GUI_SCRIPT%" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Could not prepare the graphical selection interface.
    set "EXIT_CODE=1"
    goto :FINISH
)

echo ============================================================
echo          ADB - Send files to your Android device
echo ============================================================
echo.
set /p "PHONE_IP=Enter phone IP:port to connect (or press Enter to skip): "
if defined PHONE_IP (
    echo.
    echo [1] Connecting to %PHONE_IP% ...
    "%ADB%" connect "%PHONE_IP%"
) else (
    echo.
    echo [1] Using the existing ADB connections ...
)

echo.
echo [2] Current ADB devices:
"%ADB%" devices -l
echo.

echo [3] Choose the device in the graphical window ...
set "ADB_GUI_MODE=Device"
set "ADB_GUI_RESULT=%TEMP%\ADB_Selected_Device_%TEMP_TAG%.txt"
if exist "%ADB_GUI_RESULT%" del "%ADB_GUI_RESULT%" >nul 2>&1
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%GUI_SCRIPT%"
if not exist "%ADB_GUI_RESULT%" (
    echo [CANCELLED] No ADB device was selected.
    set "EXIT_CODE=2"
    goto :FINISH
)
set "DEVICE_SERIAL="
set /p "DEVICE_SERIAL="<"%ADB_GUI_RESULT%"
if not defined DEVICE_SERIAL (
    echo [ERROR] Could not read the selected device.
    set "EXIT_CODE=1"
    goto :FINISH
)

echo.
echo [SELECTED DEVICE] %DEVICE_SERIAL%
"%ADB%" -s "%DEVICE_SERIAL%" get-state
if errorlevel 1 (
    echo [ERROR] The selected device disconnected or is not authorized.
    set "EXIT_CODE=1"
    goto :FINISH
)

echo.
echo [4] Choose the destination in the graphical window ...
set "ADB_GUI_MODE=Destination"
set "ADB_GUI_RESULT=%TEMP%\ADB_Selected_Destination_%TEMP_TAG%.txt"
if exist "%ADB_GUI_RESULT%" del "%ADB_GUI_RESULT%" >nul 2>&1
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%GUI_SCRIPT%"
if not exist "%ADB_GUI_RESULT%" (
    echo [CANCELLED] No destination was selected.
    set "EXIT_CODE=2"
    goto :FINISH
)
set "DESTINATION="
set /p "DESTINATION="<"%ADB_GUI_RESULT%"
if not defined DESTINATION (
    echo [ERROR] Could not read the selected destination.
    set "EXIT_CODE=1"
    goto :FINISH
)

echo.
echo [SELECTED DESTINATION] %DESTINATION%

rem Do not rely on `sm list-volumes` formatting: test the actual mount path.
if /i "%DESTINATION:~0,19%"=="/storage/3165-6434/" (
    echo.
    echo Checking the actual SD Card path: /storage/3165-6434 ...
    "%ADB%" -s "%DEVICE_SERIAL%" shell test -d /storage/3165-6434
    if errorlevel 1 (
        echo [ERROR] ADB cannot access /storage/3165-6434 on this device.
        echo This is a path-access check, not a check of Android's volume-list output.
        echo The card may be mounted under a different path or access may be restricted.
        echo Diagnostic listing of /storage:
        "%ADB%" -s "%DEVICE_SERIAL%" shell ls -la /storage
        set "EXIT_CODE=1"
        goto :FINISH
    )
    echo [OK] SD Card path exists.
)

echo.
echo Creating destination folder if necessary ...
"%ADB%" -s "%DEVICE_SERIAL%" shell mkdir -p "%DESTINATION%"
if errorlevel 1 (
    echo [ERROR] Could not create or access the selected destination.
    set "EXIT_CODE=1"
    goto :FINISH
)

echo.
echo [5] Choose one or more files from your computer ...
set "ADB_GUI_MODE=Files"
set "SELECTED_FILES_LIST=%TEMP%\ADB_Selected_Files_%TEMP_TAG%.txt"
set "ADB_GUI_RESULT=%SELECTED_FILES_LIST%"
if exist "%SELECTED_FILES_LIST%" del "%SELECTED_FILES_LIST%" >nul 2>&1
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%GUI_SCRIPT%"
if not exist "%SELECTED_FILES_LIST%" (
    echo [CANCELLED] No files were selected.
    set "EXIT_CODE=2"
    goto :FINISH
)
for %%A in ("%SELECTED_FILES_LIST%") do if %%~zA==0 (
    echo [CANCELLED] No files were selected.
    set "EXIT_CODE=2"
    goto :FINISH
)

echo.
echo ============================================================
echo Device:      %DEVICE_SERIAL%
echo Destination: %DESTINATION%
echo ============================================================
echo.
echo [6] Sending selected files. ADB output will appear live below ...
echo.
set "ADB_SELECTED_DEVICE=%DEVICE_SERIAL%"
set "ADB_SELECTED_DESTINATION=%DESTINATION%"
set "ADB_GUI_MODE=PushFiles"
set "ADB_GUI_RESULT=%SELECTED_FILES_LIST%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%GUI_SCRIPT%"
set "PUSH_RESULT=%ERRORLEVEL%"
if "%PUSH_RESULT%"=="0" (
    echo.
    echo [SUCCESS] All selected files were transferred successfully.
    set "EXIT_CODE=0"
) else (
    echo.
    echo [WARNING] One or more files could not be transferred. See results above.
    set "EXIT_CODE=%PUSH_RESULT%"
)

goto :FINISH

:FINISH
if defined GUI_B64 del "%GUI_B64%" >nul 2>&1
if defined GUI_SCRIPT del "%GUI_SCRIPT%" >nul 2>&1
if defined ADB_GUI_RESULT del "%ADB_GUI_RESULT%" >nul 2>&1
if defined SELECTED_FILES_LIST del "%SELECTED_FILES_LIST%" >nul 2>&1
echo.
pause
if not defined EXIT_CODE set "EXIT_CODE=1"
exit /b %EXIT_CODE%