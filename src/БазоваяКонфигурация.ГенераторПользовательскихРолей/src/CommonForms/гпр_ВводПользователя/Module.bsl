///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2025, ООО 1С-Рарус
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Получим пользователей ИБ
	СписокПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	// В информационной базе нет пользователей, тогда нет смысла предлагать выбор.
	Если СписокПользователей.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СписокВыбораПользователей = Элементы.гпр_ПользовательБазы.СписокВыбора;
	
	Для Каждого ТекущийПользователь Из СписокПользователей Цикл
		СписокВыбораПользователей.Добавить(ТекущийПользователь.Имя);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьБезЗаписиНастроек
		И Не ЗначениеЗаполнено(НаборКонстант.гпр_ПользовательБазы) Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		ОбработчикОповещения = Новый ОписаниеОповещения("ЗавершениеВопросаОЗакрытииНастроек", ЭтотОбъект);
		ПоказатьВопрос(
			ОбработчикОповещения,
			НСтр("ru = 'Закрытие формы приведет к отмене установки расширения. Продолжить?'"),
			РежимДиалогаВопрос.ДаНет);
		Возврат;
	ИначеЕсли ЗакрытьБезЗаписиНастроек Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройки(Команда)
	
	Записать();
	ЗакрытьБезЗаписиНастроек = Истина;
	Закрыть();
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗавершениеВопросаОЗакрытииНастроек(Ответ, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗакрытьБезЗаписиНастроек = Истина;
		Результат = Новый Структура();
		Результат.Вставить("ПрерватьУстановкуРасширения", Истина);
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
