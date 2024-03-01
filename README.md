[![GitHub License](https://img.shields.io/github/license/rarus/custom-role-generator)](https://github.com/rarus/custom-role-generator/tree/main?tab=CC-BY-SA-4.0-1-ov-file#CC-BY-SA-4.0-1-ov-file)
[![Download Badge](https://img.shields.io/badge/download-CustomRoleGenerator.cfe-blue)](https://github.com/rarus/custom-role-generator/releases/latest/download/CustomRoleGenerator.cfe)
[![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/rarus/custom-role-generator/total)](https://github.com/rarus/custom-role-generator/releases)
[![GitHub watchers](https://img.shields.io/github/watchers/rarus/custom-role-generator)](https://github.com/rarus/custom-role-generator)

# Предназначение инструмента

Инструмент предназначен для произвольной настройки ролей в конфигурациях на базе платформы `1С:Предприятие 8.3` в пользовательском режиме не требующие модификации конфигурации.

При внедрении на конкретном предприятии выясняются особенности его работы. Заложенный в конфигурацию набор ролей не предоставляет возможности решить любой возможный сценарий.
Что вынуждает вносить доработки в исходный код конфигурации и потребуется разработчик 1С.

Инструмент поможет
* Разработчикам - быстрее настроить права при внедрении на конкретном предприятии не ища подходящие для решения их задачи роли;
* Администраторам и безопасникам - изменить права доступа без модификации исходного кода конфигурации и без привлечения разработчиков.

Инструмент поставляется в виде расширения конфигурации.

После установки расширения станет доступен справочник `Пользовательские роли`. По команде на основании данных из справочника выполняется генерация расширения `Пользовательские роли`. Каждый элемент справочника соответствует новой роли в конфигурации.
Созданное расширение автоматически устанавливается в текущую базу данных. После установки расширения необходимо выполнить перезапуск предприятия и можно использовать новые роли из расширения.

Актуальная версия инструмента доступна в разделе [Релизы](https://github.com/rarus/custom-role-generator/releases).

# Основные возможности

[Читай в инструкции](./docs/README.md)

## Лицензия

Эта программа и сопроводительные материалы предоставляются в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Текст лицензии доступен по ссылке: https://creativecommons.org/licenses/by-sa/4.0/legalcode

## Участие в проекте

[Читай правила участия](CONTRIBUTING.md)
