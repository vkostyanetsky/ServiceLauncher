# Запускатор служб

Скрипт на PowerShell для пакетного запуска или остановки заранее определенных служб Microsoft Windows. 

У меня на сайте есть [заметка](https://kostyanetsky.ru/notes/service-launcher/) про этот скрипт.

## Как пользоваться

Введите в Services.txt список служб, которые нужно запускать или останавливать с помощью скрипта. По одной на строку. Можно использовать шаблоны, понятные командлету Get-Service (подробности — в [документации](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-service?view=powershell-7) к языку).

Собственно, это всё. Вызовите Launcher.ps1 с параметром start, чтобы запустить службы:

`.\Launcher.ps1 -start`

Используйте параметр stop, чтобы остановить их:

`.\Launcher.ps1 -stop`

## Возможные проблемы

### Скрипту нужны админские права?

Да. Если выполнить Launcher.ps1 без прав администратора — скрипт потребует их и перезапустит сам себя.

### Хочу расширить логику запуска и остановки. Куда смотреть?

В самый конец файла — там есть блок, начинающийся с `If ($start) {`. В первую ветку добавьте логику для запуска, во вторую — для остановки.

Например, у меня дополнительно вызываются `IISRESET /start` и `IISRESET /stop`.