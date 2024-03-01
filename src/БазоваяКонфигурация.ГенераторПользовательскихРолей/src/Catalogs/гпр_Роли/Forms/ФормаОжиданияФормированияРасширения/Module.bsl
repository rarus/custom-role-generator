
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущееСостояние = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Начался процесс установки расширения. Пожалуйста дождитесь завершения.'")
		);
	ТолькоПросмотр = Истина;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПродолжитьОбновлениеРасширения", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перезапустить(Команда)
	
	ЗавершитьРаботуСистемы(, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПродолжитьОбновлениеРасширения()
	
	Результат = ОбновлениеРасширениеНаСервере();
	
	ТолькоПросмотр = Ложь;
	
	Если НЕ Результат.Успешно Тогда
		
		СообщениеОбОшибке = Новый Массив;
		СообщениеОбОшибке.Добавить(НСтр("ru = 'Расширение не установлено. При выполнении возникла ошибка:'"));
		СообщениеОбОшибке.Добавить(Результат.ТекстОшибки);
		ТекущееСостояние = Новый ФорматированнаяСтрока(СтрСоединить(СообщениеОбОшибке, Символы.ПС));
		Возврат;
		
	КонецЕсли;
	
	ТекущееСостояние = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Расширение успешно установлено. Для работы с новыми ролями необходимо перезапустить ""1С:Предприятие""'"));
	Элементы.Перезапустить.Видимость = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбновлениеРасширениеНаСервере()
	
	Попытка
		Результат = гпр_ВыгрузкаРасширенияСервер.ОбновлениеРасширение();
	Исключение
		Результат = Новый Структура();
		Результат.Вставить("Успешно", Ложь);
		ТекстОшибки = Новый Массив;
		ТекстОшибки.Добавить(ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ТекстОшибки.Добавить("");
		ТекстОшибки.Добавить(НСтр("ru='Подробности см. в Журнале регистрации'"));
		Результат.Вставить("ТекстОшибки", СтрСоединить(ТекстОшибки, Символы.ПС));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Установка расширения ""Пользовательские роли""'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти