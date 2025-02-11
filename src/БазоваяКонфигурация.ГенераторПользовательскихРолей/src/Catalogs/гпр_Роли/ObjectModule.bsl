///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2025, ООО 1С-Рарус
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЭтоГруппа И Не ЗначениеЗаполнено(ИдентификаторРоли) Тогда
		
		ИдентификаторРоли = Новый УникальныйИдентификатор();
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
	
		ИдентификаторРоли = Новый УникальныйИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Не ЭтоГруппа Тогда
		
		УбратьЛишниеСимволы(ИмяРолиВКонфигурации);
		ПроверитьИмяРоли(Отказ);
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ЭтоГруппа И гпр_РаботаСКонфигурациейСервер.НайденаРольПоИмени(Ссылка, ИмяРолиВКонфигурации) Тогда
		
		ВызватьИсключение НСтр("ru = 'Роль с таким именем в конфигурации уже существует.'");
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьИмяРоли(Отказ)
	
	Буквы = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ";
	Цифры = "1234567890";
	
	Если СтрНайти(Буквы + "_", ВРег(Лев(ИмяРолиВКонфигурации, 1))) = 0
		ИЛИ СтрРазделить(ВРег(ИмяРолиВКонфигурации), Буквы + Цифры + "_", Ложь).Количество() <> 0 Тогда
		
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю();
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "ИмяРолиВКонфигурации";
		Сообщение.Текст = НСтр("ru = 'Не верное имя! Имя должно состоять из одного слова, начинаться с буквы и не содержать символов кроме ""_"".'");
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УбратьЛишниеСимволы(ИмяРолиВКонфигурации)
	
	ИмяРолиВКонфигурации = СокрЛП(ИмяРолиВКонфигурации);
	ИмяРолиВКонфигурации = СтрЗаменить(ИмяРолиВКонфигурации," ", "");
	ИмяРолиВКонфигурации = СтрЗаменить(ИмяРолиВКонфигурации, Символы.НПП , "");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
