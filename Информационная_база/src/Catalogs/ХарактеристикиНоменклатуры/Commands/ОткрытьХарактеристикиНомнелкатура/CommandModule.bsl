
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды) 
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Владелец",ПараметрКоманды));
	ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник,,ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
