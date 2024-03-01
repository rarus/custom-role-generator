
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция КартинкаРеквизита(ТипРеквизита) Экспорт
	
	Возврат гпр_РаботаСКонфигурациейСерверПовтИсп.КартинкиРеквизитов().Получить(ТипРеквизита);
	
КонецФункции

Функция ИмяГруппыРеквизитовПоТипу(ТипРеквизита) Экспорт
	
	Возврат гпр_РаботаСКонфигурациейСерверПовтИсп.ИменаГруппСТипамиРеквизитов().Получить(ТипРеквизита);
	
КонецФункции

Функция ИмяРеквизитовПоТипуРасширения(ТипРеквизита) Экспорт
	
	Возврат гпр_РаботаСКонфигурациейСерверПовтИсп.ИменаРеквизитовСТипамиРасширений().Получить(ТипРеквизита);
	
КонецФункции

Функция ТипРеквизитаПоИмениОбъектаРасширения(ИмяРеквизита) Экспорт
	
	
	Возврат гпр_РаботаСКонфигурациейСерверПовтИсп.ТипыРеквизитовПоИмениОбъектаРасширения().Получить(ИмяРеквизита);
	
КонецФункции

#КонецОбласти

#КонецЕсли