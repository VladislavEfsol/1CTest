
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ТолькоЗакупки", Ложь);
	ОткрытьФорму("Обработка.РасчетПотребностей.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "РасчетПотребностейПроизводство", ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
