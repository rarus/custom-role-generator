///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2024, ООО 1С-Рарус
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьУжеВыбранныеОбъекты(Параметры.УжеВыбранныеОбъекты);
	ЗаполнитьОбъекты();
	УстановитьТекущуюСтроку(Параметры.ДанныеТекущегоОбъекта);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбъектыКонфигурации

&НаКлиенте
Процедура ОбъектыКонфигурацииВыборОбъектаПриИзменении(Элемент)
	
	Если Элементы.ОбъектыКонфигурации.ТекущиеДанные.ВыборОбъекта = 2 Тогда
		
		Элементы.ОбъектыКонфигурации.ТекущиеДанные.ВыборОбъекта = 0;
		
	КонецЕсли;
	
	гпр_ОбщегоНазначенияКлиент.УстановитьЗначениеДляДетей(
		Элементы.ОбъектыКонфигурации.ТекущиеДанные,
		"ВыборОбъекта"
	);
	
	ВерхняяГруппировка = ВерхняяГруппировка(Элементы.ОбъектыКонфигурации.ТекущиеДанные);
	ВсегоПодчиненныхОбъектов = ПодчиненныеОбъекты(ВерхняяГруппировка).Количество();
	ВыбраноПодчиненныхОбъектов = ПодчиненныеОбъекты(ВерхняяГруппировка, Истина).Количество();
		
	Если ВыбраноПодчиненныхОбъектов = ВсегоПодчиненныхОбъектов Тогда
		
		ВерхняяГруппировка.ВыборОбъекта = 1;
		
	ИначеЕсли ВыбраноПодчиненныхОбъектов = 0 Тогда
		
		ВерхняяГруппировка.ВыборОбъекта = 0;
		
	Иначе
		
		ВерхняяГруппировка.ВыборОбъекта = 2;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	Закрыть(ВыбранныеОбъекты());

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьУжеВыбранныеОбъекты(УжеВыбранныеОбъекты)
	
	ОбъектыВДереве.Очистить();
	
	Для Каждого УжеВыбранныйОбъект Из УжеВыбранныеОбъекты Цикл
		
		ЗаполнитьЗначенияСвойств(ОбъектыВДереве.Добавить(), УжеВыбранныйОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъекты()
	
	ЗначениеОбъектовКонфигурации = РеквизитФормыВЗначение("ОбъектыКонфигурации");
	ДанныеДляЗаполнения = гпр_РаботаСКонфигурациейСервер.ОбъектыКонфигурации();

	Для Каждого ТекущийОбъект Из ДанныеДляЗаполнения Цикл

		РазделОбъектов = ЗначениеОбъектовКонфигурации.Строки.Добавить();
		РазделОбъектов.ВидОбъекта = ТекущийОбъект.Ключ;
		РазделОбъектов.ПредставлениеОбъекта = ТекущийОбъект.Значение.Получить("ПредставлениеМетаданных");
		РазделОбъектов.КартинкаОбъекта = Перечисления.гпр_ВидыМетаданных.КартинкаМетаданных(ТекущийОбъект.Ключ);

		ДобавитьОбъект(
			РазделОбъектов,
			ТекущийОбъект.Значение,
			РазделОбъектов.ВидОбъекта = Перечисления.гпр_ВидыМетаданных.Подсистема
		);
		
		УсловиеПоиска = Новый Структура("ВидОбъекта", РазделОбъектов.ВидОбъекта);
		ВсегоПодчиненныхОбъектов = ПодчиненныеОбъекты(РазделОбъектов).Количество();
		
		Если ОбъектыВДереве.НайтиСтроки(УсловиеПоиска).Количество() = ВсегоПодчиненныхОбъектов Тогда
			
			РазделОбъектов.ВыборОбъекта = 1;
			
		ИначеЕсли ОбъектыВДереве.НайтиСтроки(УсловиеПоиска).Количество() = 0 Тогда
			
			РазделОбъектов.ВыборОбъекта = 0;
			
		Иначе
			
			РазделОбъектов.ВыборОбъекта = 2;
			
		КонецЕсли;
		
		РазделОбъектов.Строки.Сортировать("ИмяОбъекта");
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ЗначениеОбъектовКонфигурации, "ОбъектыКонфигурации");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОбъект(Раздел, ТекущийОбъект, ЭтоПодсистема)

	Если ЭтоПодсистема И ТипЗнч(ТекущийОбъект) = Тип("КлючИЗначение") Тогда

		ТекущийОбъектМетаданных = ТекущийОбъект.Значение;

	Иначе

		ТекущийОбъектМетаданных = ТекущийОбъект;

	КонецЕсли;

	Для Каждого ОбъектМетаданных Из ТекущийОбъектМетаданных Цикл

		Если
			ОбъектМетаданных.Ключ = "ПредставлениеМетаданных"
			Или ОбъектМетаданных.Ключ = "Имя"
			Или ОбъектМетаданных.Ключ = "Синоним"
			Или ОбъектМетаданных.Ключ = "Представление"
		Тогда
			
			Продолжить;
			
		КонецЕсли;

		НовыйОбъект = Раздел.Строки.Добавить();

		НовыйОбъект.ВидОбъекта = Раздел.ВидОбъекта;

		НовыйОбъект.ПредставлениеОбъекта = ОбъектМетаданных.Значение.Имя;

		Если ЭтоПодсистема Тогда

			НовыйОбъект.ИмяОбъекта = СтрЗаменить(ОбъектМетаданных.Значение.Представление, "Подсистемы.", "");

		Иначе

			НовыйОбъект.ИмяОбъекта = ОбъектМетаданных.Значение.Имя;

		КонецЕсли;

		НовыйОбъект.КартинкаОбъекта = Раздел.КартинкаОбъекта;
		
		УсловиеПоиска = Новый Структура("ВидОбъекта,ИмяОбъекта", Раздел.ВидОбъекта, НовыйОбъект.ИмяОбъекта);
		
		Если ОбъектыВДереве.НайтиСтроки(УсловиеПоиска).Количество() > 0 Тогда
			
			НовыйОбъект.ВыборОбъекта = 1;
			
		Иначе
			
			НовыйОбъект.ВыборОбъекта = 0;
			
		КонецЕсли;

		Если ЭтоПодсистема Тогда

			ДобавитьОбъект(НовыйОбъект, ОбъектМетаданных, Истина);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПодчиненныеОбъекты(Родитель, ТолькоВыбранные = Ложь)
	
	Если ТипЗнч(Родитель) <> Тип("ДанныеФормыЭлементДерева") Тогда
		
		Дочки = Родитель.Строки;
		
	Иначе
		
		Дочки = Родитель.ПолучитьЭлементы();
		
	КонецЕсли;
	
	Если Дочки.Количество() = 0 Тогда
		
		Возврат Новый Массив();
		
	КонецЕсли;
	
	Результат = Новый Массив();
	
	Для Каждого Дочка Из Дочки Цикл
		
		Если Не ТолькоВыбранные Или Дочка.ВыборОбъекта = 1 Тогда
			
			Результат.Добавить(Дочка);
			
		КонецЕсли;
		
		Для Каждого ПодчиненныйДочке Из ПодчиненныеОбъекты(Дочка, ТолькоВыбранные) Цикл
			
			Результат.Добавить(ПодчиненныйДочке);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВерхняяГруппировка(Строка)
	
	Родитель = Строка.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		
		Возврат Строка;
		
	КонецЕсли;
	
	Возврат ВерхняяГруппировка(Родитель);
	
КонецФункции

&НаСервере
Функция ВыбранныеОбъекты()

	ВыбранныеСтроки = РеквизитФормыВЗначение("ОбъектыКонфигурации")
		.Строки
		.НайтиСтроки(Новый Структура("ВыборОбъекта", 1), Истина);

	Результат = Новый Массив();
	
	Для Каждого ВыбранняСтрока Из ВыбранныеСтроки Цикл
		
		Если ПустаяСтрока(ВыбранняСтрока.ИмяОбъекта) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(Новый Структура("Ключ,Значение", ВыбранняСтрока.ИмяОбъекта, ВыбранняСтрока.ВидОбъекта));
		
	КонецЦикла;

	Возврат Результат;

КонецФункции

&НаСервере
Процедура УстановитьТекущуюСтроку(ДанныеТекущегоОбъекта)
	
	Если ДанныеТекущегоОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторСтроки = 0;
	ПрекратитьПоиск = Ложь;
	НайтиСтрокуДерева(
		ОбъектыКонфигурации.ПолучитьЭлементы(),
		ДанныеТекущегоОбъекта,
		ИдентификаторСтроки,
		ПрекратитьПоиск
	);
	Элементы.ОбъектыКонфигурации.ТекущаяСтрока = ИдентификаторСтроки;
	
КонецПроцедуры

&НаСервере
Процедура НайтиСтрокуДерева(КоллекцияЭлементовДерева, ТекущиеДанные, ИдентификаторСтроки, ПрекратитьПоиск)

	Для Каждого СтрокаДерева Из КоллекцияЭлементовДерева Цикл
		Если ПрекратитьПоиск Тогда
			Возврат;
		КонецЕсли;

		Если СтрокаДерева.ВидОбъекта = ТекущиеДанные.ВидОбъекта И СтрокаДерева.ИмяОбъекта = ТекущиеДанные.ИмяОбъекта Тогда
			ИдентификаторСтроки = СтрокаДерева.ПолучитьИдентификатор();
			ПрекратитьПоиск = Истина;
			Возврат;
		КонецЕсли;

		КоллекцияЭлементов = СтрокаДерева.ПолучитьЭлементы();

		Если КоллекцияЭлементов.Количество() > 0 Тогда
			НайтиСтрокуДерева(КоллекцияЭлементов, ТекущиеДанные, ИдентификаторСтроки, ПрекратитьПоиск);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти