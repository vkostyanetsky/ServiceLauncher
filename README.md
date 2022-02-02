# Запускатор служб

 [![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)

Скрипт на PowerShell для пакетного запуска или остановки заранее определенных служб Microsoft Windows. 

## Как пользоваться

Введите в текстовой файл список служб (см. [пример](Services.txt)), которые нужно запускать или останавливать с помощью скрипта. По одной на строку. Можно использовать шаблоны, понятные командлету Get-Service (подробности — в [документации](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-service?view=powershell-7) к языку).

Собственно, это всё. Вызовите Launcher.ps1 с параметром path (путь к текстовому файлу) и параметром start, чтобы запустить службы:

`powershell .\Launcher.ps1 -start -path "D:\Services.txt"`

Используйте параметр stop, чтобы остановить их:

`powershell .\Launcher.ps1 -stop -path "D:\Services.txt"`

Если не указан ни параметр start, ни параметр stop — скрипт сам решит, запускать или останавливать службы. Для этого он определит статус первой службы в списке: если она работает — все службы из списка будут остановлены, если выключена — скрипт попытается их запустить.

Второй скрипт, Disabler.ps1, тоже принимает путь к текстовому файлу в параметр path. Для каждой службы из списка в файле скрипт включит ручной режим запуска. Его удобно вызывать при первоначальной настройке, чтобы отключить автоматический запуск служб, которыми вы в дальнейшем планируете управлять с помощью Launcher.ps1.
## Возможные проблемы

### Скрипту нужны админские права?

Да. Если выполнить скрипт без прав администратора — он потребует их и, получив, перезапустит сам себя.

### Хочу расширить логику запуска и остановки. Куда смотреть?

В самый конец скрипта — там есть блок, начинающийся с `If ($start) {`. В первую ветку добавьте логику для запуска, во вторую — для остановки.

Например, у меня дополнительно вызываются `IISRESET /start` и `IISRESET /stop`.