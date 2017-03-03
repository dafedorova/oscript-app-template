///////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями 
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Использовать logos
#Использовать tempfiles

///////////////////////////////////////////////////////////////////

Перем ИсполнителиКоманд;
Перем РегистраторКоманд;
Перем ДополнительныеПараметры;

///////////////////////////////////////////////////////////////////

Процедура ЗарегистрироватьКоманды(Знач Парсер) Экспорт
	
	КомандыИРеализация = Новый Соответствие;
	РегистраторКоманд.ПриРегистрацииКомандПриложения(КомандыИРеализация);

	Для Каждого КлючИЗначение Из КомандыИРеализация Цикл

		ДобавитьКоманду(КлючИЗначение.Ключ, КлючИЗначение.Значение, Парсер);

	КонецЦикла;
	
КонецПроцедуры // ЗарегистрироватьКоманды

Процедура РегистраторКоманд(Знач ОбъектРегистратор) Экспорт
	
	ИсполнителиКоманд = Новый Соответствие;	
	РегистраторКоманд = ОбъектРегистратор;
	ДополнительныеПараметры = Новый Структура;

	ДополнительныеПараметры.Вставить("Лог", Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы()));
	// ДополнительныеПараметры.Вставить("УдалятьВременныеФайлы", Ложь);

КонецПроцедуры // РегистраторКоманд

Функция ПолучитьКоманду(Знач ИмяКоманды) Экспорт
	
	КлассРеализации = ИсполнителиКоманд[ИмяКоманды];
	Если КлассРеализации = Неопределено Тогда

		ВызватьИсключение "Неверная операция. Команда '" + ИмяКоманды + "' не предусмотрена.";

	КонецЕсли;
	
	Возврат КлассРеализации;
	
КонецФункции // ПолучитьКоманду

Функция ВыполнитьКоманду(Знач ИмяКоманды, Знач ПараметрыКоманды) Экспорт
	
	// УстановитьРежимОтладкиПриНеобходимости(ПараметрыКоманды);
	// УстановитьРежимУдаленияВременныхФайлов(ПараметрыКоманды);
	// УстановитьБазовыйКаталогВременныхФайлов(ПараметрыКоманды);
	
	Команда = ПолучитьКоманду(ИмяКоманды);
	КодВозврата = Команда.ВыполнитьКоманду(ПараметрыКоманды, ДополнительныеПараметры);
	
	// УдалитьВременныеФайлыПриНеобходимости();
	
	Возврат КодВозврата;

КонецФункции // ВыполнитьКоманду

Процедура ПоказатьСправкуПоКомандам(ИмяКоманды = Неопределено) Экспорт

	ПараметрыКоманды = Новый Соответствие;
	Если ИмяКоманды <> Неопределено Тогда

		ПараметрыКоманды.Вставить("Команда", ИмяКоманды);

	КонецЕсли;

	ВыполнитьКоманду("help", ПараметрыКоманды);

КонецПроцедуры // ПоказатьСправкуПоКомандам

Процедура ДобавитьКоманду(Знач ИмяКоманды, Знач КлассРеализации, Знач Парсер)
	
	Попытка
		РеализацияКоманды = Новый(КлассРеализации);
		РеализацияКоманды.ЗарегистрироватьКоманду(ИмяКоманды, Парсер);
		ИсполнителиКоманд.Вставить(ИмяКоманды, РеализацияКоманды);
	Исключение
		ДополнительныеПараметры.Лог.Ошибка("Не удалось выполнить команду %1 для класса %2", ИмяКоманды, КлассРеализации);
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

///////////////////////////////////////////////////////////////////

Функция РезультатыКоманд() Экспорт

	РезультатыКоманд = Новый Структура;
	РезультатыКоманд.Вставить("Успех", 0);
	РезультатыКоманд.Вставить("НеверныеПараметры", 5);
	РезультатыКоманд.Вставить("ОшибкаВремениВыполнения", 1);
	
	Возврат РезультатыКоманд;

КонецФункции // РезультатыКоманд

Функция КодВозвратаКоманды(Знач Команда) Экспорт

	Возврат Число(Команда);

КонецФункции // КодВозвратаКоманды

///////////////////////////////////////////////////////////////////

// Процедура УдалитьВременныеФайлыПриНеобходимости()
	
// 	Если ДополнительныеПараметры.УдалятьВременныеФайлы Тогда
		
// 		ВременныеФайлы.Удалить();
		
// 	КонецЕсли;
	
// КонецПроцедуры // УдалитьВременныеФайлыПриНеобходимости

// Процедура УстановитьРежимОтладкиПриНеобходимости(Знач ПараметрыКоманды)
	
// 	Если ПараметрыКоманды["-verbose"] = "on" ИЛИ ПараметрыКоманды["-debug"] = "on" Тогда
		
// 		ДополнительныеПараметры.Лог.УстановитьУровень(УровниЛога.Отладка);
		
// 	КонецЕсли;
	
// КонецПроцедуры // УстановитьРежимОтладкиПриНеобходимости

// Процедура УстановитьРежимУдаленияВременныхФайлов(Знач ПараметрыКоманды)
	
// 	Если ПараметрыКоманды["-debug"] = "on" Тогда
		
// 		ДополнительныеПараметры.УдалятьВременныеФайлы = Истина;
		
// 	КонецЕсли;
	
// КонецПроцедуры // УстановитьРежимУдаленияВременныхФайлов

// Процедура УстановитьБазовыйКаталогВременныхФайлов(Знач ПараметрыКоманды)
	
// 	Если ЗначениеЗаполнено(ПараметрыКоманды["-tempdir"]) Тогда
		
// 		БазовыйКаталог  = ПараметрыКоманды["-tempdir"];
// 		Если Не (Новый Файл(БазовыйКаталог).Существует()) Тогда
			
// 			СоздатьКаталог(БазовыйКаталог);
			
// 		КонецЕсли;
		
// 		ВременныеФайлы.БазовыйКаталог = БазовыйКаталог;
		
// 	КонецЕсли;
	
// КонецПроцедуры // УстановитьБазовыйКаталогВременныхФайлов
