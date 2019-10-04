
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПрочитатьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОтветПередЗакрытием", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьНаСервере();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьНастройки()
	
	ВключатьПодписьДляНовыхСообщений = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиЭлектроннойПочты", "ВключатьПодписьДляНовыхСообщений", Ложь);
	ВключатьПодписьПриОтветеИлиПересылке = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиЭлектроннойПочты", "ВключатьПодписьПриОтветеИлиПересылке", Ложь);
	
	ПрочитатьНастройкиПодписьФорматированныйДокумент();
	ПрочитатьНастройкиПодписьПриОтветеФорматированныйДокумент();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиПодписьФорматированныйДокумент()
	
	ПодписьHTML = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиЭлектроннойПочты", "ПодписьHTML", "");
	КартинкиПодписи = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиЭлектроннойПочты", "КартинкиПодписи", Новый Структура);
	
	Если ПустаяСтрока(ПодписьHTML) Тогда
		ПодписьПоУмолчанию = Символы.ПС + Символы.ПС + "---------------------------------" + Символы.ПС;
		ПодписьHTML = Новый ФорматированнаяСтрока(ПодписьПоУмолчанию);
		ПодписьФорматированныйДокумент.УстановитьФорматированнуюСтроку(ПодписьHTML);
	Иначе
		ПодписьФорматированныйДокумент.УстановитьHTML(ПодписьHTML, КартинкиПодписи);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиПодписьПриОтветеФорматированныйДокумент()
	
	ПодписьПриОтветеHTML = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиЭлектроннойПочты", "ПодписьПриОтветеHTML", "");
	КартинкиПодписиПриОтвете = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиЭлектроннойПочты", "КартинкиПодписиПриОтвете", Новый Структура);
	
	Если ПустаяСтрока(ПодписьПриОтветеHTML) Тогда
		ПодписьПоУмолчанию = Символы.ПС + Символы.ПС + "---------------------------------" + Символы.ПС;
		ПодписьПриОтветеHTML = Новый ФорматированнаяСтрока(ПодписьПоУмолчанию);
		ПодписьПриОтветеФорматированныйДокумент.УстановитьФорматированнуюСтроку(ПодписьПриОтветеHTML);
	Иначе
		ПодписьПриОтветеФорматированныйДокумент.УстановитьHTML(ПодписьПриОтветеHTML, КартинкиПодписиПриОтвете);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветПередЗакрытием(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрытьНаСервере();
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	СохранитьНастройкуВключатьПодписьДляНовыхСообщений();
	СохранитьНастройкуВключатьПодписьПриОтветеИлиПересылке();
	СохранитьНастройкуПодписьФорматированныйДокумент();
	СохранитьНастройкуПодписьПриОтветеФорматированныйДокумент();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуВключатьПодписьДляНовыхСообщений()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"ВключатьПодписьДляНовыхСообщений",
	ВключатьПодписьДляНовыхСообщений,,,
	Истина);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуВключатьПодписьПриОтветеИлиПересылке()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"ВключатьПодписьПриОтветеИлиПересылке",
	ВключатьПодписьПриОтветеИлиПересылке,,,
	Истина);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПодписьФорматированныйДокумент()
	
	ПодписьHTML = "";
	КартинкиПодписи = Новый Структура;
	ПодписьФорматированныйДокумент.ПолучитьHTML(ПодписьHTML, КартинкиПодписи);
	
	Если СтрНайти(НРег(ПодписьHTML), "e1c://") <> 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не поддерживается копирование и вставка форматированного текста с картинками.'");
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"ПодписьHTML",
	ПодписьHTML,,,
	Истина);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"КартинкиПодписи",
	КартинкиПодписи,,,
	Истина);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"ПодписьПростойТекст",
	ПодписьФорматированныйДокумент.ПолучитьТекст(),,,
	Истина);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПодписьПриОтветеФорматированныйДокумент()
	
	ПодписьПриОтветеHTML = "";
	КартинкиПодписиПриОтвете = Новый Структура;
	ПодписьПриОтветеФорматированныйДокумент.ПолучитьHTML(ПодписьПриОтветеHTML, КартинкиПодписиПриОтвете);
	
	Если СтрНайти(НРег(ПодписьПриОтветеHTML), "e1c://") <> 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не поддерживается копирование и вставка форматированного текста с картинками.'");
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"ПодписьПриОтветеHTML",
	ПодписьПриОтветеHTML,,,
	Истина);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"КартинкиПодписиПриОтвете",
	КартинкиПодписиПриОтвете,,,
	Истина);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
	"НастройкиЭлектроннойПочты",
	"ПодписьПриОтветеПростойТекст",
	ПодписьПриОтветеФорматированныйДокумент.ПолучитьТекст(),,,
	Истина);
	
КонецПроцедуры

#КонецОбласти
