///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2025, ООО 1С-Рарус
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет подготовку содержимого файла с ролями в формате json.
// 
// Параметры:
//  Роли - Массив из СправочникСсылка.гпр_Роли - Роли для выгрузки;
// 
// Возвращаемое значение:
//  Строка - Адрес во временном хранилище, с даннымим ролей в формате json
Функция СохранитьРоли(Роли) Экспорт
	
	Возврат ПоместитьВоВременноеХранилище(
		ДвоичныеДанные(
			СтрокаВФорматеJSON(
				ДанныеРолейКВыгрузке(
					Роли
				)
			)
		)
	);
	
КонецФункции

// Разбор файла с ролями в формате json и запись данных в базу.
// 
// Параметры:
//  АдресФайла - Строка - Адрес файла во временном хранилище
Процедура ЗагрузитьРоли(АдресФайла) Экспорт
	
	Файл = ПолучитьИзВременногоХранилища(АдресФайла); // ДвоичныеДанные
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.ОткрытьПоток(Файл.ОткрытьПотокДляЧтения());
	
	Результат = СериализаторXDTO.ПрочитатьJSON(ЧтениеJSON, Тип("ФиксированныйМассив"));
	ЧтениеJSON.Закрыть();
	
	Для Каждого Роль Из Результат Цикл // СправочникОбъект.гпр_Роли
		
		Роль.УстановитьНовыйКод();
		
		Если ТипЗнч(Роль) = Тип("СправочникОбъект.гпр_Роли") Тогда
			
			Роль.Родитель = Неопределено;
			
		КонецЕсли;
		
		Роль.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает имя роли для сохранения как имя файла.
//
// Параметры:
//  Роль -СправочникСсылка.гпр_Роли - выбранная роль.
//
// Возвращаемое значение:
//  Строка - имя роли в конфигураторе.
//
Функция ИмяРоли(Роль) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Роль);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	гпр_Роли.ИмяРолиВКонфигурации
	|ИЗ
	|	Справочник.гпр_Роли КАК гпр_Роли
	|ГДЕ
	|	гпр_Роли.Ссылка = &Ссылка";
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса[0].ИмяРолиВКонфигурации;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеРолейКВыгрузке(Роли)
	
	ДанныеРолей = ДанныеРолей(Роли);
	
	Если ДанныеРолей.Пустой() Тогда
		
		ВызватьИсключение "Нет данных для экспорта";
		
	КонецЕсли;
	
	ВыборкаРолей = ДанныеРолей.Выбрать();
	Результат = Новый Массив();
	
	Пока ВыборкаРолей.Следующий() Цикл
		
		Результат.Добавить(ВыборкаРолей.Ссылка.ПолучитьОбъект());
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

Функция ДанныеРолей(Роли)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ШаблоныОграниченийДоступа.ШаблонОграничения КАК ШаблонОграничения
		|ПОМЕСТИТЬ Шаблоны
		|ИЗ
		|	Справочник.гпр_Роли.ШаблоныОграниченийДоступа КАК ШаблоныОграниченийДоступа
		|ГДЕ
		|	ШаблоныОграниченийДоступа.Ссылка В (&Роли)
		|СГРУППИРОВАТЬ ПО
		|	ШаблоныОграниченийДоступа.ШаблонОграничения
		|;
		|
		|ВЫБРАТЬ
		|	гпр_Роли.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.гпр_Роли КАК гпр_Роли
		|ГДЕ
		|	гпр_Роли.Ссылка В (&Роли)
		|	И НЕ гпр_Роли.ЭтоГруппа
		|	
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Шаблоны.ШаблонОграничения
		|ИЗ
		|	Шаблоны КАК Шаблоны"
	);
	Запрос.УстановитьПараметр("Роли", Роли);
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СтрокаВФорматеJSON(КЗаписи)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, КЗаписи);
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

Функция ДвоичныеДанные(Данные)
	
	Поток = Новый ПотокВПамяти();
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(Данные);
	ТекстовыйДокумент.Записать(Поток);
	
	Возврат Поток.ЗакрытьИПолучитьДвоичныеДанные();
	
КонецФункции

#КонецОбласти