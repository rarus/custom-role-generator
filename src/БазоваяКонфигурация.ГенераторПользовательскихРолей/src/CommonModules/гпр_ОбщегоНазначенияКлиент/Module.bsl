///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2025, ООО 1С-Рарус
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by-sa/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура УстановитьЗначениеДляДетей(Родитель, ИмяКолонки)Экспорт
	
	Для Каждого Дочка Из Родитель.ПолучитьЭлементы() Цикл
		
		Дочка[ИмяКолонки] = Родитель[ИмяКолонки];
		
		УстановитьЗначениеДляДетей(Дочка, ИмяКолонки);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти