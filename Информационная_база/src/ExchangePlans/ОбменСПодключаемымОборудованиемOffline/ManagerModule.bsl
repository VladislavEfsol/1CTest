#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция должна возвращать:
// Истина, в том случае, если корреспондент поддерживает сценарий обмена, 
// в котором текущая ИБ работает в локальном режиме, 
// а корреспондент в модели сервиса. 
// 
// Ложь – если такой сценарий обмена не поддерживается.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции // КорреспондентВМоделиСервиса()

#КонецЕсли