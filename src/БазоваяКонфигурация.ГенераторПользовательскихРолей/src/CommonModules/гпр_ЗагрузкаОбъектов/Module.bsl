///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2024, ООО 1С-Рарус
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ПраваДоступаРоли(ИмяРоли) Экспорт
	
	// Получим шаблон для заполнения результата загрузки
	Результат = ПараметрыРоли();
	
	// Выгрузим объекты основного расширения
	ПолноеИмяРоли = СтрШаблон("Роль.%1", ИмяРоли);
	
	Роль = Метаданные.Роли.Найти(ИмяРоли);
	РасширениеРоли = Роль.РасширениеКонфигурации();
	ИмяРасширения = "";
	Если РасширениеРоли <> Неопределено Тогда
		ИмяРасширения = РасширениеРоли.Имя;
	КонецЕсли;
	
	КаталогФайловКонфигурации = ФайлыКонфигурации(Результат.ТекстОшибки, ПолноеИмяРоли, ИмяРасширения);
	
	Если Не ПустаяСтрока(Результат.ТекстОшибки) Тогда
		Возврат Результат;
	КонецЕсли;
		
	// Прочитаем права доступа роли
	ПрочитатьРоль(ИмяРоли, КаталогФайловКонфигурации, Результат, ИмяРасширения);
	
	Возврат Результат;
	
КонецФункции

// Получение списка объектов, которые связаны с передаваемым через реквизиты.
// Параметры:
//	ВидОбъекта	-	ПеречислениеСсылка.гпр_ВидыМетаданных	- Вид объекта объекта, по которому ищем ссылки реквизиты.
//	ИмяОбъекта	-	Строка	- Имя текущего объекта для поиска связанных объектов.
//
// Возвращаемое значение:
//  Соответствие - Список объектов, которые связаны с указанным объектом
//
Функция СвязанныеОбъекты(ВидОбъекта, ИмяОбъекта) Экспорт
	
	СписокОбъектов = Новый Соответствие();
	
	Если ВидОбъекта = Перечисления.гпр_ВидыМетаданных.Подсистема Тогда
		
		Возврат СписокОбъектов;
		
	КонецЕсли;	
	
	// Получим подчиненные объекты
	ПодчиненныеРеквизиты = гпр_РаботаСКонфигурациейСервер.ДоступныеГруппыПодчиненныхЭлементовПоВидуОбъекта(ВидОбъекта);
	ИмяВидаОбъекта = Перечисления.гпр_ВидыМетаданных.ИмяМетаданныхПоВидуМетаданных(ВидОбъекта);
	
	// Получим список реквизитов для поиска
	РеквизитыПоиска = СписокТиповРеквизитовДляПоискаСвязанныхОбъектов();
	
	// Получим по подчиненным реквизитам все ссылки
	Для Каждого РеквизитОбъекта Из ПодчиненныеРеквизиты Цикл
		
		ЭтоРеквизитОбъекта = (РеквизитыПоиска.Найти(РеквизитОбъекта.ТипРеквизита) <> Неопределено);
		ЭтоРеквизитТабличнойЧасти = (РеквизитыПоиска.Найти(РеквизитОбъекта.РеквизитРеквизита) <> Неопределено);
		
		Если Не ЭтоРеквизитОбъекта И Не ЭтоРеквизитТабличнойЧасти Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭтоРеквизитОбъекта Тогда
			
			КоллекцияРеквизитов = Метаданные[ИмяВидаОбъекта][ИмяОбъекта][РеквизитОбъекта.ИмяТипаРеквизита];
			ПолучитьОбъектыПоСсылкам(КоллекцияРеквизитов, СписокОбъектов);
			
		Иначе
			
			ТабличныеЧасти = Метаданные[ИмяВидаОбъекта][ИмяОбъекта][РеквизитОбъекта.ИмяТипаРеквизита];
			ИмяРеквизитов = Перечисления.гпр_ТипыРеквизитовОбъекта.ИмяГруппыРеквизитовПоТипу(РеквизитОбъекта.РеквизитРеквизита);
			Для Каждого РеквизитыРеквизита Из ТабличныеЧасти Цикл
				
				КоллекцияРеквизитов = ТабличныеЧасти[РеквизитыРеквизита.Имя][ИмяРеквизитов];
				ПолучитьОбъектыПоСсылкам(КоллекцияРеквизитов, СписокОбъектов);
					
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Найдем по общим реквизитам, которые используются в объекте
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		
		ЗначениеСостава = ОбщийРеквизит.Состав.Найти(Метаданные[ИмяВидаОбъекта][ИмяОбъекта]);
		Если (НЕ ЗначениеСостава = Неопределено) И 
			(ЗначениеСостава.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать
			ИЛИ ОбщийРеквизит.АвтоИспользование = Метаданные.СвойстваОбъектов.АвтоИспользованиеОбщегоРеквизита.Использовать
			И ЗначениеСостава.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто) Тогда
		
			ДобавитьНовыйТипОбъекта(ОбщийРеквизит.ПолноеИмя(), СписокОбъектов);
			
			// А так же тип реквизита
			ДобавитьТипыОбъекта(ОбщийРеквизит.Тип, СписокОбъектов);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Движения по регистрам
	Если ВидОбъекта = Перечисления.гпр_ВидыМетаданных.Документ Тогда
		
		Для Каждого Регистр Из Метаданные.Документы[ИмяОбъекта].Движения Цикл
			
			ДобавитьНовыйТипОбъекта(Регистр.ПолноеИмя(), СписокОбъектов);
			
		КонецЦикла;
		
	ИначеЕсли ВидОбъекта = Перечисления.гпр_ВидыМетаданных.ЖурналДокументов Тогда
		
		Для Каждого Документ Из Метаданные.ЖурналыДокументов[ИмяОбъекта].РегистрируемыеДокументы Цикл
			
			ДобавитьНовыйТипОбъекта(Документ.ПолноеИмя(), СписокОбъектов);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИмяВидовОбъектов = МенеджерОбъекта(ВидОбъекта);
	Попытка
		
		// У объекта должна быть функция ДополнительныеСвязанныеОбъекты()
		// С массивом объектов в формате: "Докумен.ПоступлениеТоваров"
		ДополнительныйСписокОбъектов = ИмяВидовОбъектов[ИмяОбъекта].ДополнительныеСвязанныеОбъекты(); 
		
	Исключение
		
		ДополнительныйСписокОбъектов = Новый Массив;
		
	КонецПопытки;
	
	Для Каждого ТекущийОбъект Из ДополнительныйСписокОбъектов Цикл
		
		ДобавитьНовыйТипОбъекта(ТекущийОбъект, СписокОбъектов);
		
	КонецЦикла;
	
	Возврат СписокОбъектов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ФайлыКонфигурации(ТекстОшибки, ИмяОбъекта = Неопределено, ИмяРасширения = "")
	
	КаталогВыгрузки = "";
	РежимВыгрузкиКонфигурации = Константы.гпр_РежимВыгрузкиКонфигурации.Получить();
	
	Если Не ЗначениеЗаполнено(РежимВыгрузкиКонфигурации) Тогда
		
		ТекстОшибки = НСтр("ru = 'Установите режим доступа к файлам конфигурации через форму настроек ""Настройки""'");
		Возврат КаталогВыгрузки;
		
	КонецЕсли;
	
	Если РежимВыгрузкиКонфигурации = Перечисления.гпр_РежимыВыгрузкиКонфигурации.КонфигурацияВыгруженаВКаталог Тогда
		
		КаталогВыгрузки = Константы.гпр_КаталогВыгрузкиКонфигурации.Получить();
		
		Если Не ЗначениеЗаполнено(КаталогВыгрузки) Тогда
			
			ТекстОшибки = НСтр("ru = 'Укажите каталог файлов конфигурации через форму настроек ""Настройки""'");
			
		КонецЕсли;
		
		КаталогВыгрузки = КаталогВыгрузки + ПолучитьРазделительПутиСервера();
		
	ИначеЕсли РежимВыгрузкиКонфигурации = Перечисления.гпр_РежимыВыгрузкиКонфигурации.КонфигурацияНеВыгруженаВКаталог Тогда
		
		КаталогВыгрузки = СтрШаблон("%1%2", КаталогВременныхФайлов(), "Base");
		УдалитьФайлы(КаталогВыгрузки);
		СоздатьКаталог(КаталогВыгрузки);
		
		ПутьБазы = СтрокаСоединенияИнформационнойБазы();
		ПутьБазыДляКоманды = "";
		
		Если СтрНачинаетсяС(ПутьБазы, "File=") Тогда
			
			// База файловая
			ПутьБазыДляКоманды = СтрШаблон("/f ""%1""", Сред(ПутьБазы, 7, СтрДлина(ПутьБазы) - 8));
			
		ИначеЕсли СтрНачинаетсяС(ПутьБазы, "Srvr=") Тогда
			
			// База серверная
			ЧастиПути = СтрРазделить(СтрокаСоединенияИнформационнойБазы(), """;");
			ПутьБазыДляКоманды = СтрШаблон("/s %1\%2", ЧастиПути[1], ЧастиПути[4]);
			
		Иначе
			
			ТекстОшибки = НСтр("ru = 'Для выполнения операции необходимо выгрузить конфигурацию в файлы и указать каталог в форме настроек ""Настройки""'");
			Возврат "";
			
		КонецЕсли;
		
		ВыгрузитьТолькоОбъект = ИмяОбъекта <> Неопределено;
		ПутьКФайлуОбъекта = СтрШаблон("%1%2ОбъектВыгрузки.txt", КаталогВыгрузки, ПолучитьРазделительПутиСервера());
		
		Если ВыгрузитьТолькоОбъект Тогда
			
			ТекстРоли = Новый ТекстовыйДокумент;
			ТекстРоли.ДобавитьСтроку(ИмяОбъекта);
			ТекстРоли.Записать(ПутьКФайлуОбъекта);
			
		КонецЕсли;
		
		ПараметрыКомандыВыгрузитьКонфигурацию = ПараметрыКомандыВыгрузитьКонфигурацию();
		ПараметрыКомандыВыгрузитьКонфигурацию.ПутьКБазе = ПутьБазыДляКоманды;
		ПараметрыКомандыВыгрузитьКонфигурацию.КаталогВыгрузки = КаталогВыгрузки;
		ПараметрыКомандыВыгрузитьКонфигурацию.ИмяПользователя = Константы.гпр_ПользовательБазы.Получить();;
		ПараметрыКомандыВыгрузитьКонфигурацию.ПарольПользователя = Константы.гпр_ПарольПользователя.Получить();
		ПараметрыКомандыВыгрузитьКонфигурацию.ВыгрузитьТолькоОбъект = ВыгрузитьТолькоОбъект;
		ПараметрыКомандыВыгрузитьКонфигурацию.ПутьКФайлуОбъекта = ПутьКФайлуОбъекта;
		ПараметрыКомандыВыгрузитьКонфигурацию.ИмяРасширения = ИмяРасширения;
		КодВозвратаКоманды = Неопределено;
		ЗапуститьПриложение(
			КомандаВыгрузитьКонфигурацию(ПараметрыКомандыВыгрузитьКонфигурацию),
			,
			Истина,
			КодВозвратаКоманды
		);
		
		КаталогВыгрузки = КаталогВыгрузки + ПолучитьРазделительПутиСервера();
		
		Если КодВозвратаКоманды <> 0 Тогда
			
			ЧтениеФайла = Новый ЧтениеТекста();
			ЧтениеФайла.Открыть(КаталогВыгрузки + "Report.txt");
			ТекстОшибки = ЧтениеФайла.Прочитать();
			ЧтениеФайла.Закрыть();
			Возврат "";
			
		КонецЕсли;
		
		ИмяРасширения = "";
		
	КонецЕсли;
	
	Возврат КаталогВыгрузки;
	
КонецФункции

Функция КомандаВыгрузитьКонфигурацию(ПараметрыКоманды)
	
	РазделительПутиСервера = ПолучитьРазделительПутиСервера();
	ШаблонКоманды = Новый Массив();
	ШаблонКоманды.Добавить(СтрШаблон("""%1""", ПутьКИсполняемомуФайлу()));
	ШаблонКоманды.Добавить("designer");
	ШаблонКоманды.Добавить(ПараметрыКоманды.ПутьКБазе);
	
	Если Не ПустаяСтрока(ПараметрыКоманды.ИмяПользователя) Тогда
		
		ШаблонКоманды.Добавить(СтрШаблон("/N""%1""", ПараметрыКоманды.ИмяПользователя));
		
		Если Не ПустаяСтрока(ПараметрыКоманды.ПарольПользователя) Тогда
			
			ШаблонКоманды.Добавить(СтрШаблон("/P""%1""", ПараметрыКоманды.ПарольПользователя));
			
		КонецЕсли;
		
	КонецЕсли;
	
	ШаблонКоманды.Добавить("/DumpConfigToFiles " + ПараметрыКоманды.КаталогВыгрузки);
	
	Если ПараметрыКоманды.ВыгрузитьТолькоОбъект Тогда
		
		ШаблонКоманды.Добавить("-Format Hierarchical -listFile " + ПараметрыКоманды.ПутьКФайлуОбъекта);
		
	Иначе
		
		ШаблонКоманды.Добавить("-Right");
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ПараметрыКоманды.ИмяРасширения) Тогда
		ШаблонКоманды.Добавить("-Extension " + ПараметрыКоманды.ИмяРасширения);
	КонецЕсли;
	ШаблонКоманды.Добавить(
		СтрШаблон("/DumpResult %1%2Out.txt ", ПараметрыКоманды.КаталогВыгрузки, РазделительПутиСервера)
	);
	ШаблонКоманды.Добавить("/DisableStartupMessages");
	ШаблонКоманды.Добавить("/DisableStartupDialogs");
	ШаблонКоманды.Добавить(
		СтрШаблон("/Out %1%2Report.txt ", ПараметрыКоманды.КаталогВыгрузки, РазделительПутиСервера)
	);
	Возврат СтрСоединить(ШаблонКоманды, " ");
	
КонецФункции

Функция ПараметрыКомандыВыгрузитьКонфигурацию()
	
	Результат = Новый Структура();
	Результат.Вставить("ПутьКБазе", "");
	Результат.Вставить("ИмяПользователя", "");
	Результат.Вставить("ПарольПользователя", "");
	Результат.Вставить("КаталогВыгрузки", "");
	Результат.Вставить("ВыгрузитьТолькоОбъект", Ложь);
	Результат.Вставить("ПутьКФайлуОбъекта", "");
	Результат.Вставить("ИмяРасширения", "");
	Возврат Результат;
	
КонецФункции

Функция ПутьКИсполняемомуФайлу()
	
	Возврат КаталогПрограммы() + ?(ЭтоWindows(), "1cv8.exe", "1cv8");
	
КонецФункции

Функция ЭтоWindows()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Возврат СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	
КонецФункции

#Область ВыбгрузкаРоли

Функция ПараметрыРоли()
	
	ДанныеРоли = Новый Структура();
	ДанныеРоли.Вставить("УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию", Ложь);
	ДанныеРоли.Вставить("УстанавливатьПраваДляНовыхобъектов", Ложь);
	ДанныеРоли.Вставить("НеЗависимыеПраваПодчиненныхРеквизитов", Ложь);
	ДанныеРоли.Вставить("ПраваДоступа", ОписаниеПравДоступа());
	ДанныеРоли.Вставить("ОграниченияДоступаКДанным", ОписаниеОграниченийДоступаКДанным());
	ДанныеРоли.Вставить("ШаблоныОграниченийДоступа", ОписаниеШаблоновОграничений());
	ДанныеРоли.Вставить("ТекстОшибки", "");
	
	Возврат ДанныеРоли;
	
КонецФункции

Функция ОписаниеПравДоступа()
	
	ПараметрыОписанияРоли = Новый ТаблицаЗначений();
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ВидОбъекта",
		Новый ОписаниеТипов("ПеречислениеСсылка.гпр_ВидыМетаданных"));
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ИмяОбъекта",
		Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200)));
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ТипРеквизита",
		Новый ОписаниеТипов("ПеречислениеСсылка.гпр_ТипыРеквизитовОбъекта"));
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ИмяРеквизита",
		Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200)));
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ИмяРеквизитаТабличнойЧасти",
		Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200)));
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ПравоДоступа",
		Новый ОписаниеТипов("ПеречислениеСсылка.гпр_ПраваДоступа"));
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ЗначениеПраваДоступа",
		Новый ОписаниеТипов("Булево"));
	ПараметрыОписанияРоли.Колонки.Добавить(
		"ИдентификаторСтроки",
		Новый ОписаниеТипов("УникальныйИдентификатор"));
	
	Возврат ПараметрыОписанияРоли;	
	
КонецФункции

Функция ОписаниеОграниченийДоступаКДанным()
	
	ПараметрыОграниченийДоступа = Новый ТаблицаЗначений();
	ПараметрыОграниченийДоступа.Колонки.Добавить(
		"ИдентификаторСтроки",
		Новый ОписаниеТипов("УникальныйИдентификатор"));
	ПараметрыОграниченийДоступа.Колонки.Добавить(
		"Поля",
		Новый ОписаниеТипов("Строка"));
	ПараметрыОграниченийДоступа.Колонки.Добавить(
		"ОграничениеДоступа",
		Новый ОписаниеТипов("Строка"));
	
	Возврат ПараметрыОграниченийДоступа;
	
КонецФункции

Функция ОписаниеШаблоновОграничений()
	
	ПараметрыШаблоновОграничений = Новый ТаблицаЗначений();
	ПараметрыШаблоновОграничений.Колонки.Добавить(
		"ИмяШаблона",
		Новый ОписаниеТипов("Строка"));
	ПараметрыШаблоновОграничений.Колонки.Добавить(
		"ШаблонОграничения",
		Новый ОписаниеТипов("СправочникСсылка.гпр_ШаблоныОграничений"));
	
	Возврат ПараметрыШаблоновОграничений;
	
КонецФункции

Процедура ПрочитатьРоль(ИмяРоли, КаталогКонфигурации, ДанныеРоли, ИмяРасширения)
	
	Если ПустаяСтрока(ИмяРасширения) Тогда
		ПутьКРоли = СтрШаблон("%1\Roles\%2\Ext\Rights.xml", КаталогКонфигурации, ИмяРоли);
	Иначе
		ПутьКРоли = СтрШаблон("%1\%2\Roles\%3\Ext\Rights.xml", КаталогКонфигурации, ИмяРасширения, ИмяРоли);
	КонецЕсли;
	
	// Прочтем роль из файла
	Попытка
		ЧтениеТекста = Новый ЧтениеТекста();
		ЧтениеТекста.Открыть(ПутьКРоли, КодировкаТекста.UTF8);
		ТекстРоли = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
	Исключение
		ДанныеРоли.ТекстОшибки = СтрШаблон(НСтр("ru='Не удалось получить данные о роли ""%1""'"), ИмяРоли);
		Возврат;
	КонецПопытки;
	
	// Заполним данными роли структуры
	Попытка
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстРоли);
		ОписаниеРоли = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Исключение
		Версия = СтрНайти(ТекстРоли, "version=" + Символ(34), , СтрНайти(ТекстРоли, "Rights"));
		ВерсияКонец = СтрНайти(ТекстРоли, Символ(34), , Версия + 9) + 1;
		ВерсияXML = Сред(ТекстРоли, Версия, ВерсияКонец - Версия);
		ТекстРоли = СтрЗаменить(ТекстРоли, ВерсияXML, "version=""2.11""");
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстРоли);
		ОписаниеРоли = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();		
	КонецПопытки;
	
	ДанныеРоли.УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию = ОписаниеРоли.setForAttributesByDefault;
	ДанныеРоли.УстанавливатьПраваДляНовыхобъектов = ОписаниеРоли.setForNewObjects;
	ДанныеРоли.НеЗависимыеПраваПодчиненныхРеквизитов = ОписаниеРоли.independentRightsOfChildObjects;
	
	// Права доступа
	ПрочитатьПраваДоступаРоли(ДанныеРоли, ОписаниеРоли);

	// Шаблоны ограничений
	ПрочитатьШаблоныОграниченийРоли(ДанныеРоли, ОписаниеРоли);
	
КонецПроцедуры

Процедура ПрочитатьПраваДоступаРоли(ДанныеРоли, ОписаниеРоли)
	
	УстановитьВсеОбъекты = (ДанныеРоли.УстанавливатьПраваДляНовыхобъектов
		ИЛИ ДанныеРоли.УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию);
	
	Если УстановитьВсеОбъекты Тогда
		
		ЗаполнитьПравамиВсехОбъектов(ДанныеРоли);
			
	КонецЕсли;
	
	Для Каждого ТекущийОбъект Из ОписаниеРоли.object Цикл
		
		// Работаем только с объектами, роли конфигурации нельзя добавить в роль расширения
		Если СтрНачинаетсяС(ТекущийОбъект.Name, "Configuration.")  Тогда
			Продолжить;
		КонецЕсли;
		
		НазваниеОбъекта = СтрРазделить(ТекущийОбъект.Name, ".");
		
		// Рассматриваем только объекты
		Если НазваниеОбъекта.Количество() < 2 Тогда
			Продолжить;
		КонецЕсли;
		
		// Определим основные для нас параметры
		ДанныеОбъекта = ДанныеОбъектаПравРоли();
		ДанныеОбъекта.ВидОбъекта = 
			Перечисления.гпр_ВидыМетаданных.ВидОбъектаПоИмениМетаданныхРасширения(НазваниеОбъекта[0]);
		ЭтоПодсистема = (ДанныеОбъекта.ВидОбъекта = Перечисления.гпр_ВидыМетаданных.Подсистема);
		
		Если ЭтоПодсистема Тогда
			НомерПодсистемы = 1;
			ЧастиПодсистем = Новый Массив;
			Пока НомерПодсистемы < НазваниеОбъекта.Количество() Цикл
				ЧастиПодсистем.Добавить(НазваниеОбъекта[НомерПодсистемы]);
				НомерПодсистемы = НомерПодсистемы + 2;
			КонецЦикла;
			ДанныеОбъекта.ИмяОбъекта = СтрСоединить(ЧастиПодсистем, ".");
		Иначе
			ДанныеОбъекта.ИмяОбъекта = НазваниеОбъекта[1];
		КонецЕсли;
		
		// Есть табличная часть
		Если НазваниеОбъекта.Количество() = 4 И НЕ ЭтоПодсистема Тогда
			
			ДанныеОбъекта.ТипРеквизита =
				Перечисления.гпр_ТипыРеквизитовОбъекта.ТипРеквизитаПоИмениОбъектаРасширения(НазваниеОбъекта[2]);
			ДанныеОбъекта.ИмяРеквизита = НазваниеОбъекта[3];
			
		КонецЕсли;
		 
		// Проверим наличие реквизита табличной части
		Если НазваниеОбъекта.Количество() = 6 И НЕ ЭтоПодсистема Тогда
			
			ДанныеОбъекта.ИмяРеквизитаТабличнойЧасти = НазваниеОбъекта[5];
			
		КонецЕсли;	 
		
		// Сами права доступа объета
		Для Каждого ТекущееПраво Из ТекущийОбъект.right Цикл
			
			НеДобавлятьПраво = (ТекущееПраво.value <> Истина И ТекущееПраво.restrictionByCondition.Количество() = 0);
			ПравоДоступа = ПравоДоступаПоИмени(ТекущееПраво.name);
			СтрокаПрава = Неопределено;
			
			Если УстановитьВсеОбъекты Тогда
				
				УсловиеПоиска = Новый Структура();
				Для Каждого КлючИЗначение Из ДанныеОбъекта Цикл
					УсловиеПоиска.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				КонецЦикла;
				УсловиеПоиска.Вставить("ПравоДоступа", ПравоДоступа);
				НайденныеСтроки = ДанныеРоли.ПраваДоступа.НайтиСтроки(УсловиеПоиска);
				
				Если НеДобавлятьПраво Тогда
				
					Для Каждого ТекущийРеквизит Из НайденныеСтроки Цикл
						
						ДанныеРоли.ПраваДоступа.Удалить(ТекущийРеквизит);
						
					КонецЦикла;
					Продолжить;
					
				ИначеЕсли НайденныеСтроки.Количество() > 0 Тогда
					СтрокаПрава = НайденныеСтроки[0];
					СтрокаПрава.ЗначениеПраваДоступа = ТекущееПраво.value;
				КонецЕсли;
				
			ИначеЕсли НеДобавлятьПраво Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			// Добавим право доступа в таблицу
			Если СтрокаПрава = Неопределено Тогда
				СтрокаПрава = ДанныеРоли.ПраваДоступа.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПрава, ДанныеОбъекта);
				СтрокаПрава.ПравоДоступа = ПравоДоступа;
				СтрокаПрава.ЗначениеПраваДоступа = ТекущееПраво.value;
				СтрокаПрава.ИдентификаторСтроки = Новый УникальныйИдентификатор();
			КонецЕсли;
			
			// РЛС
			Для Каждого ТекущееОграничение Из ТекущееПраво.restrictionByCondition Цикл
				
				Если ТекущееОграничение.field.Количество() = 0 Тогда
					Поля = НСтр("ru='<Прочие поля>'");
				Иначе
					ДобавлениеПолей = Новый Массив;
					Для Каждого Поле Из ТекущееОграничение.field Цикл
						СписокПолей = СтрРазделить(Поле, ".");
						Для Индекс = 0 По СписокПолей.Количество() - 1 Цикл
							СписокПолей[Индекс] = РеквизитПоИмени(СписокПолей[Индекс]);
						КонецЦикла;
						ДобавлениеПолей.Добавить(СтрСоединить(СписокПолей, "."));
					КонецЦикла;
					Поля = СтрСоединить(ДобавлениеПолей, ",");
				КонецЕсли;
				
				СтрокаОграничений = ДанныеРоли.ОграниченияДоступаКДанным.Добавить();
				СтрокаОграничений.ИдентификаторСтроки = СтрокаПрава.ИдентификаторСтроки;
				СтрокаОграничений.Поля = Поля;
				СтрокаОграничений.ОграничениеДоступа = ТекущееОграничение.condition;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПрочитатьШаблоныОграниченийРоли(ДанныеРоли, ОписаниеРоли)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	гпр_ШаблоныОграничений.Ссылка КАК Шаблон,
	|	гпр_ШаблоныОграничений.Наименование КАК ИмяШаблона
	|ИЗ
	|	Справочник.гпр_ШаблоныОграничений КАК гпр_ШаблоныОграничений";
	
	СписокШаблонов = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекущийШаблон Из ОписаниеРоли.restrictionTemplate Цикл
		
		// Проверим, что шаблон с таким именем ранее был добавлен
		УсловиеПоиска = Новый Структура("ИмяШаблона", ТекущийШаблон.name);
		
		Если ДанныеРоли.ШаблоныОграниченийДоступа.НайтиСтроки(УсловиеПоиска).Количество() > 0 Тогда
			
			Продолжить;
			
		КонецЕсли;	
		
		НовыйШаблон = ДанныеРоли.ШаблоныОграниченийДоступа.Добавить();
		НовыйШаблон.ИмяШаблона = ТекущийШаблон.name;
		
		// Проверим, что данному шаблону есть элемент справочника
		НайденныеШаблоны = СписокШаблонов.НайтиСтроки(УсловиеПоиска);
		
		Если НайденныеШаблоны.Количество() > 0 Тогда
			НовыйШаблон.ШаблонОграничения = НайденныеШаблоны[0].Шаблон;
		Иначе
			// Создадим шаблон
			ШаблонОграничения = Справочники.гпр_ШаблоныОграничений.СоздатьЭлемент();
			ШаблонОграничения.Заполнить(Неопределено);
			ШаблонОграничения.УстановитьНовыйКод();
			ШаблонОграничения.Наименование = ТекущийШаблон.name;
			ШаблонОграничения.ТекстШаблона = ТекущийШаблон.condition;
			ШаблонОграничения.ОбменДанными.Загрузка = Истина;
			ШаблонОграничения.Записать();
			НовыйШаблон.ШаблонОграничения = ШаблонОграничения.Ссылка;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеОбъектаПравРоли()
	
	ДанныеОбъекта = Новый Структура();
	ДанныеОбъекта.Вставить("ВидОбъекта", Перечисления.гпр_ВидыМетаданных.ПустаяСсылка());
	ДанныеОбъекта.Вставить("ИмяОбъекта", "");
	ДанныеОбъекта.Вставить("ИмяРеквизита",  "");
	ДанныеОбъекта.Вставить("ТипРеквизита",  Перечисления.гпр_ТипыРеквизитовОбъекта.ПустаяСсылка());
	ДанныеОбъекта.Вставить("ИмяРеквизитаТабличнойЧасти",  "");

	Возврат ДанныеОбъекта;	
	
КонецФункции

Функция ПравоДоступаПоИмени(ИмяПраваДоступа)
	
	Возврат гпр_РаботаСКонфигурациейСерверПовтИсп.ПравоДоступаПоИмениЗагрузки().Получить(ИмяПраваДоступа);
	
КонецФункции

Функция РеквизитПоИмени(ИмяРеквизита)
	
	Реквизит = гпр_РаботаСКонфигурациейСерверПовтИсп.РеквизитыОбъектовЗагрузки().Получить(ИмяРеквизита);
	
	Возврат ?(Реквизит = Неопределено, ИмяРеквизита, Реквизит);
	
КонецФункции

Процедура ЗаполнитьПравамиВсехОбъектов(ДанныеРоли)
	
	ОбъектыКонфигурации = гпр_РаботаСКонфигурациейСерверПовтИсп.ОбъектыКонфигурации();
	
	// Добавим права доступа по всем объектам
	Для Каждого ТекущийВидОбъекта Из ОбъектыКонфигурации Цикл
		
		ЭтоПодсистема = ТекущийВидОбъекта.Ключ = Перечисления.гпр_ВидыМетаданных.Подсистема;
		ПраваДоступаОбъекта = гпр_РаботаСКонфигурациейСервер.ДоступныеВидуОбъектаПраваДоступа(ТекущийВидОбъекта.Ключ);
		
		Для Каждого ТекущийОбъект Из ТекущийВидОбъекта.Значение Цикл
			
			Если ТекущийОбъект.Ключ = "ПредставлениеМетаданных" Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЭтоПодсистема Тогда
				ИмяОбъекта = СтрЗаменить(ТекущийОбъект.Значение.Представление, "Подсистемы.", "");
			Иначе
				ИмяОбъекта = ТекущийОбъект.Значение.Имя;
			КонецЕсли;
			
			Если ДанныеРоли.УстанавливатьПраваДляНовыхОбъектов Тогда
					
				ДобавитьПраваДоступаОбъекта(
					ДанныеРоли.ПраваДоступа,
					ТекущийВидОбъекта.Ключ,
					ТекущийОбъект,
					ИмяОбъекта,
					ПраваДоступаОбъекта);

			КонецЕсли;
			
			Если ДанныеРоли.УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию Тогда
				
			ОписаниеРеквизитов = гпр_ВыгрузкаРасширенияСервер.ОписаниеОбъекта(
					ТекущийВидОбъекта.Ключ, 
					ИмяОбъекта);
					
				// Теперь все описания занесем в таблицу вывода
				Для Каждого ТекущийРеквизит Из ОписаниеРеквизитов Цикл
					
					НоваяСтрока = ДанныеРоли.ПраваДоступа.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущийРеквизит);
					НоваяСтрока.ВидОбъекта = ТекущийВидОбъекта.Ключ;
					НоваяСтрока.ИмяОбъекта = ИмяОбъекта;
					НоваяСтрока.ЗначениеПраваДоступа = Истина;
					НоваяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор();
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ДанныеРоли.ПраваДоступа.Индексы.Добавить("ВидОбъекта,ИмяОбъекта,ИмяРеквизита,ТипРеквизита,ИмяРеквизитаТабличнойЧасти,ПравоДоступа");
	
КонецПроцедуры

Процедура ДобавитьПраваДоступаОбъекта(ПраваДоступа, ВидОбъекта, ТекущийОбъект, ИмяОбъекта, ПраваДоступаОбъекта)
	
	Для Каждого СтрокаПрава Из ПраваДоступаОбъекта Цикл
		
		НоваяСтрока = ПраваДоступа.Добавить();
		НоваяСтрока.ВидОбъекта = ВидОбъекта;
		НоваяСтрока.ИмяОбъекта = ИмяОбъекта;
		НоваяСтрока.ПравоДоступа = СтрокаПрава.Значение;
		НоваяСтрока.ЗначениеПраваДоступа = Истина;
		НоваяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор();
		
	КонецЦикла;
	
	Если ВидОбъекта = Перечисления.гпр_ВидыМетаданных.Подсистема Тогда
		
		Для Каждого ПодчиненнаяПодсистема Из ТекущийОбъект.Значение Цикл
			
			Если ТипЗнч(ПодчиненнаяПодсистема.Значение) <> Тип("Структура") Тогда
				Продолжить;
			КонецЕсли;
			
			ИмяОбъектаПодчиненной = СтрЗаменить(ПодчиненнаяПодсистема.Значение.Представление, "Подсистемы.", "");
			
			ДобавитьПраваДоступаОбъекта(
				ПраваДоступа,
				ВидОбъекта,
				ПодчиненнаяПодсистема,
				ИмяОбъектаПодчиненной,
				ПраваДоступаОбъекта);
				
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СвязанныеОбъекты

Функция СписокТиповРеквизитовДляПоискаСвязанныхОбъектов()
	
	СписокРеквизитовОбъекта = Новый Массив;
	СписокРеквизитовОбъекта.Добавить(Перечисления.гпр_ТипыРеквизитовОбъекта.Реквизит);
	СписокРеквизитовОбъекта.Добавить(Перечисления.гпр_ТипыРеквизитовОбъекта.Измерение);
	СписокРеквизитовОбъекта.Добавить(Перечисления.гпр_ТипыРеквизитовОбъекта.Ресурс);
	СписокРеквизитовОбъекта.Добавить(Перечисления.гпр_ТипыРеквизитовОбъекта.РеквизитТабличнойЧасти);
	СписокРеквизитовОбъекта.Добавить(Перечисления.гпр_ТипыРеквизитовОбъекта.СтандартныйРеквизит);
	
	Возврат СписокРеквизитовОбъекта;
	
КонецФункции

Процедура ПолучитьОбъектыПоСсылкам(РеквизитыОбъекта, СписокОбъектов)
	
	Для Каждого Реквизит Из РеквизитыОбъекта Цикл
		
		// Теперь добавим каждый тип и добавим в список
		ДобавитьТипыОбъекта(Реквизит.Тип, СписокОбъектов);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьТипыОбъекта(ТипОбъекта, СписокОбъектов)
	
	Для Каждого ТекущийТипРеквизита Из ТипОбъекта.Типы() Цикл
		
		ТипРеквизита = Метаданные.НайтиПоТипу(ТекущийТипРеквизита);
		
		Если ТипРеквизита = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавитьНовыйТипОбъекта(ТипРеквизита.ПолноеИмя(), СписокОбъектов);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьНовыйТипОбъекта(ТипОбъекта, СписокОбъектов)
	
	ЧастиТипРеквизита = СтрРазделить(ТипОбъекта, ".");
	
	Если ЧастиТипРеквизита.Количество() <> 2 Тогда
		// Это простой тип или "Любая ссылка"
		Возврат;
	КонецЕсли;
	
	// Найдем вид типа реквизита
	ИмяВидаОбъекта = ИмяВидаОбъектаБезПрефиксов(ЧастиТипРеквизита[0]);
	ИмяОбъекта = ЧастиТипРеквизита[1];
	
	Если ИмяВидаОбъекта = "Характеристика" Тогда
		
		// Внесем все типы данной характеристики
		ДобавитьТипыОбъекта(Метаданные.ПланыВидовХарактеристик[ИмяОбъекта].Тип, СписокОбъектов);
		Возврат;
		
	ИначеЕсли ИмяВидаОбъекта = "ОпределяемыйТип" Тогда
		
		ДобавитьТипыОбъекта(Метаданные.ОпределяемыеТипы[ИмяОбъекта].Тип, СписокОбъектов);
		Возврат;
		
	КонецЕсли;
	
	ВидОбъекта = ВидОбъектаПоИмени(ИмяВидаОбъекта);
	
	Если ВидОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Добавим в список объектов текущий если ранее не был добавлен
	Если СписокОбъектов.Получить(ИмяОбъекта) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокОбъектов.Вставить(ИмяОбъекта, ВидОбъекта);
	
	Если ВидОбъекта = Перечисления.гпр_ВидыМетаданных.ПланВидовХарактеристик Тогда
		
		ДобавитьТипыОбъекта(Метаданные.ПланыВидовХарактеристик[ИмяОбъекта].Тип, СписокОбъектов);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВидОбъектаПоИмени(ИмяВидаОбъекта)
	
	Возврат гпр_РаботаСКонфигурациейСерверПовтИсп.ВидМетаданныхПоИмениВЕдинственномЧисле().Получить(ИмяВидаОбъекта);
	
КонецФункции

Функция ИмяВидаОбъектаБезПрефиксов(ИмяВидаОбъекта)
	
	Результат = СтрЗаменить(ИмяВидаОбъекта, "Ссылка", "");
	Результат = СтрЗаменить(Результат, "Объект", "");
	Результат = СтрЗаменить(Результат, "НаборЗаписей", "");
	Результат = СтрЗаменить(Результат, "МенеджерЗначения", "");
	Результат = СтрЗаменить(Результат, "КлючЗначения", "");
	Результат = СтрЗаменить(Результат, "Менеджер", "");

	Возврат Результат;
	
КонецФункции

Функция МенеджерОбъекта(ВидОбъекта)
	
	Возврат гпр_РаботаСКонфигурациейСерверПовтИсп.МенеджерОбъектаПоВидуМетаданных().Получить(ВидОбъекта);
	
КонецФункции

#КонецОбласти

#КонецОбласти