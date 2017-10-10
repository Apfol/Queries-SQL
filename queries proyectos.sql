select categoria from categoria;

select 
    P.nombre as Nombre_Producto,
    L.nombre as Nombre_Local, 
    count(Co.IDProducto) as Ventas_realizadas,
    if(count(Co.IDProducto) <> 0, max(concat(Cl.nombre, ' ', Cl.apellido)), 'No registra') as Persona_realizo_más_compras,
    if(count(Co.IDProducto) <> 0, max(Pa.FechaPago), 'No registra') as Fecha_último_pago,
    case
        when max(Pa.FechaPago) > date_add(NOW(), INTERVAL -1 MONTH) then 
            concat('Se realizó hace ', DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)), 
                if(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) > 1, ' días', ' día'))
        when (max(Pa.FechaPago) <= date_add(NOW(), INTERVAL -1 MONTH) and max(Pa.FechaPago) > date_add(NOW(), INTERVAL -1 YEAR)) then 
            concat('Se realizó hace ', MONTH(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + 365)), 
                if(MONTH(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + 365)) > 1, ' meses y ', ' mes y '), 
                DAY(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + 365)), if(DAY(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + 365)) > 1, ' días', ' día'))
        when count(Co.IDProducto) = 0 then 'No registra'
        else 
            concat('Se realizó hace ', YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)))), 
                if(YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)))) > 1, ' años, ', ' año, '), 
                MONTH(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)))), 
                if(MONTH(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)))) > 1, ' meses y ', ' mes y '),
                 DAY(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)))), if(DAY(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)))), ' días', ' día'))
        end as Informe_último_pago
    from producto P 
        left join compra Co on P.IDProducto = Co.IDProducto
        left join local L on L.IDLocal = P.IDLocal
        left join pago Pa on Pa.IDPago = Co.IDPago
        left join cliente Cl on Cl.IDCliente = Co.IDCliente
        group by Co.IDProducto, L.nombre, P.nombre;