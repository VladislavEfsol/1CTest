#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// См. ОтчетыУНФ.ИнициализироватьНастройкиОтчета.
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПрограммноеИзменениеФормыОтчета = Истина;
	НастройкиОтчета.Вставить("РежимПериода", "ЗаПериод");
	
	НастройкиВариантов["Основной"].Рекомендуемый = Истина;
	
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

// См. ОбщиеФормы.ФормаОтчетаУНФ.ОбновитьНастройкиНаФорме.
Процедура ОбновитьНастройкиНаФорме(НастройкиОтчета, НастройкиСКД, Форма) Экспорт
	
	ДобавитьНастройкуПоСчетам(НастройкиСКД, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаОстатки", ТаблицаОстатки());
	
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить(
	"ВнешниеНаборыДанных",
	ПоместитьВоВременноеХранилище(ВнешниеНаборыДанных));
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(
	КомпоновщикНастроек,
	СхемаКомпоновкиДанных,
	ДокументРезультат,
	ДанныеРасшифровки,
	СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Деньги,Контрагенты,Покупатели,Заказы,Счета,Оплаты'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "Контрагент",
	"Справочник.Контрагенты",,, Истина);
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "СчетНаОплату",
	"Документ.ЗаказПокупателя",,, Истина);
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "СчетНаОплату",
	"Документ.СчетНаОплату",,, Истина);
	
КонецПроцедуры

Функция ТаблицаОстатки()
	
	ПериодОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СтПериод");
	ПоСчетам = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПоСчетам");
	СписокДокументов = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СписокДокументов");
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.Значение.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.Значение.ДатаОкончания);
	Запрос.УстановитьПараметр("ПоСчетам", ПоСчетам.Значение);
	
	Если УстановленПериодЗаВсеВремя(ПериодОтчета) Тогда
		Запрос.Текст = ТекстЗапросаСуммаКОплатеОсталосьОплатить(Ложь);
	Иначе
		Запрос.Текст = СтрШаблон(
		"%1
		|;
		|%2",
		ТекстЗапросаСчетаНаОплату(),
		ТекстЗапросаСуммаКОплатеОсталосьОплатить(Истина));
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

Функция УстановленПериодЗаВсеВремя(ПериодОтчета)
	
	Если ЗначениеЗаполнено(ПериодОтчета.Значение.ДатаНачала) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПериодОтчета.Значение.ДатаОкончания) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ТекстЗапросаСуммаКОплатеОсталосьОплатить(ОтбиратьПоСчетамНаОплату)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОплатаСчетовИЗаказовОбороты.СчетНаОплату КАК СчетНаОплату,
	|	ОплатаСчетовИЗаказовОбороты.Организация КАК Организация,
	|	ОплатаСчетовИЗаказовОбороты.СуммаОборот КАК СуммаСчета,
	|	ОплатаСчетовИЗаказовОбороты.СуммаОборот - ОплатаСчетовИЗаказовОбороты.СуммаАвансаОборот - ОплатаСчетовИЗаказовОбороты.СуммаОплатыОборот КАК ОсталосьОплатить
	|ИЗ
	|	РегистрНакопления.ОплатаСчетовИЗаказов.Обороты(
	|			,
	|			,
	|			,
	|			ВЫБОР
	|					КОГДА &ПоСчетам
	|						ТОГДА СчетНаОплату ССЫЛКА Документ.СчетНаОплату
	|					ИНАЧЕ СчетНаОплату ССЫЛКА Документ.ЗаказПокупателя
	|				КОНЕЦ
	|				И &ОтборСчетаНаОплату) КАК ОплатаСчетовИЗаказовОбороты";
	
	Если ОтбиратьПоСчетамНаОплату Тогда
		Результат = СтрЗаменить(ТекстЗапроса, "И &ОтборСчетаНаОплату",
		"И СчетНаОплату В (ВЫБРАТЬ ВТ_СчетаНаОплату.СчетНаОплату ИЗ ВТ_СчетаНаОплату)");
	Иначе
		Результат = СтрЗаменить(ТекстЗапроса, "И &ОтборСчетаНаОплату", "");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаСчетаНаОплату()
	
	Возврат
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОплатаСчетовИЗаказов.СчетНаОплату КАК СчетНаОплату
	|ПОМЕСТИТЬ ВТ_СчетаНаОплату
	|ИЗ
	|	РегистрНакопления.ОплатаСчетовИЗаказов КАК ОплатаСчетовИЗаказов
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &КонецПериода = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ОплатаСчетовИЗаказов.Период >= &НачалоПериода
	|			ИНАЧЕ ОплатаСчетовИЗаказов.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ПоСчетам
	|				ТОГДА ОплатаСчетовИЗаказов.СчетНаОплату ССЫЛКА Документ.СчетНаОплату
	|			ИНАЧЕ ОплатаСчетовИЗаказов.СчетНаОплату ССЫЛКА Документ.ЗаказПокупателя
	|		КОНЕЦ";
	
КонецФункции

Процедура ДобавитьНастройкуПоСчетам(НастройкиСКД, Форма)
	
	ИмяНастройки = "ПоСчетам";
	ЗначениеРеквизита = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяНастройки).Значение;
	
	Стр = Форма.ПоляНастроек.ПолучитьЭлементы().Добавить();
	Стр.Тип = "Параметр";
	Стр.Поле = ИмяНастройки;
	Стр.ТипЗначения = Новый ОписаниеТипов("Булево");
	Стр.ВидЭлемента = "Поле";
	Стр.Реквизиты = Новый Структура;
	Стр.Элементы = Новый Структура;
	Стр.ДополнительныеПараметры = Новый Структура;
	Стр.Реквизиты.Вставить(ИмяНастройки, ЗначениеРеквизита);
	МассивРеквизитов = Новый Массив;
	Для Каждого ОписаниеРеквизита Из Стр.Реквизиты Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(ОписаниеРеквизита.Ключ, Стр.ТипЗначения,, Стр.Заголовок));
	КонецЦикла;
	Стр.Создан = Истина;
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Форма[ИмяНастройки] = ЗначениеРеквизита;
	НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра(Стр.Поле, ЗначениеРеквизита);
	Элемент = Форма.Элементы.Добавить(ИмяНастройки, Тип("ПолеФормы"), Форма.Элементы.ГруппаПараметрыЭлементы);
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.ВидФлажка = ВидФлажка.Тумблер;
	Элемент.ПутьКДанным = ИмяНастройки;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	Элемент.ОдинаковаяШиринаЭлементов = Ложь;
	Элемент.ФорматРедактирования = "БЛ='По заказам'; БИ='По счетам'";
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПараметрПриИзменении");
	Стр.Элементы.Вставить(Элемент.Имя, Элемент.ПутьКДанным);

КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#КонецЕсли