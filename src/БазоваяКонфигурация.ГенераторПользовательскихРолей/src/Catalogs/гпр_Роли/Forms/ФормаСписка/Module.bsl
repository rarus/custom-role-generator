
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьРасширение(Команда)
	
	Результат = СоздатьРасширениеВозможно();
	
	Если Результат.Ошибка Тогда
		
		ПоказатьПредупреждение(, Результат.ТекстОшибки);
		Возврат;
		
	КонецЕсли;
	
	Если НеобходимоУказатьПользователяИБ() Тогда
		
		// Заполним пользователя информационной базы.
		ОбработчикЗавершения = Новый ОписаниеОповещения("ЗавершитьВводПользователя", ЭтотОбъект);
		ФормаВводаПользователя = ОткрытьФорму(
			"ОбщаяФорма.гпр_ВводПользователя", ,
			ЭтотОбъект, , , ,
			ОбработчикЗавершения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		//@skip-check code-after-async-call
		Если ФормаВводаПользователя <> Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ПродолжитьФормированиеРасширения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкспортРолей(Команда)
	
	гпр_ИспортЭкспортРолейКлиент.СохранитьРолиНаДиск(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортРолей(Команда)
	
	гпр_ИспортЭкспортРолейКлиент.ЗагрузитьРоли(УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СоздатьРасширениеВозможно()
	
	Результат = Новый Структура("Ошибка,ТекстОшибки", Ложь, "");
	
	Если НетРолейДляВыгрузки() Тогда
		
		Результат.Ошибка = Истина;
		Результат.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки ролей.'");
		
	ИначеЕсли БезопасныйРежимВыключен() Тогда
		
		Результат.Ошибка = Истина;
		Результат.ТекстОшибки = НСтр("ru = 'У расширения включен безопасный режим. Для генерации расширения его необходимо отключить'");
		
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

&НаСервереБезКонтекста
Функция НетРолейДляВыгрузки()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	гпр_РолиПраваДоступа.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.гпр_Роли.ПраваДоступа КАК гпр_РолиПраваДоступа
		|ГДЕ
		|	НЕ гпр_РолиПраваДоступа.Ссылка.ПометкаУдаления"
	);
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервереБезКонтекста
Функция БезопасныйРежимВыключен()
	
	НайденныеРасширения = РасширенияКонфигурации.Получить(
		Новый Структура(
			"УникальныйИдентификатор",
			Метаданные.Справочники.гпр_Роли.РасширениеКонфигурации().УникальныйИдентификатор
		)
	);
	
	Если Не ЗначениеЗаполнено(НайденныеРасширения) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат НайденныеРасширения[0].БезопасныйРежим;
	
КонецФункции

&НаСервереБезКонтекста
Функция НеобходимоУказатьПользователяИБ()
	
	Возврат Константы.гпр_ФормироватьРасширениеРолейЧерезПустуюБазу.Получить() <> Истина
		И Не ЗначениеЗаполнено(Константы.гпр_ПользовательБазы.Получить());
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьВводПользователя(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("ПрерватьУстановкуРасширения") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПродолжитьФормированиеРасширения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьФормированиеРасширения()
	
	ОткрытьФорму("Справочник.гпр_Роли.Форма.ФормаОжиданияФормированияРасширения",, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
