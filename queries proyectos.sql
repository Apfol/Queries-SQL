select 
    P.nombre as Nombre_Producto, 
    L.nombre as Nombre_Local, 
    (select count(Co.IDCompra) from compra Co where Co.IDProducto = P.IDProducto) as Ventas_realizadas,
    if(count(Co.IDProducto) <> 0, concat('$', sum(P.Precio)), 'No registra') as Total_ventas,
    if(count(Co.IDProducto) <> 0, max(Pa.FechaPago), 'No registra') as Fecha_último_pago,
    case
        when max(Pa.FechaPago) > date_add(NOW(), INTERVAL -1 MONTH) then 
            concat('Se realizó hace ', DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)), 
                if(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) > 1, ' días', ' día'))
        when (max(Pa.FechaPago) <= date_add(NOW(), INTERVAL -1 MONTH) and max(Pa.FechaPago) > date_add(NOW(), INTERVAL -1 YEAR)) then 
            concat('Se realizó hace ', MONTH(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + 365)), 
                if(MONTH(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + 365)) > 1, ' meses y ', ' mes y '), 
                DAY(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + TO_DAYS(CURRENT_DATE))), if(DAY(FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) + 365)) > 1, ' días', ' día'))
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
    group by Co.IDProducto, L.IDLocal, P.IDProducto
    order by Ventas_realizadas DESC;


select P.nombre, max(C) from (select count(Co.IDProducto) as C from producto P 
    inner join compra Co on Co.IDProducto = P.IDProducto
    inner join cliente Cl on Cl.IDCliente = Co.IDCliente group by Co.IDProducto, Cl.nombre) as t1,
    producto P, compra Co where P.IDProducto = Co.IDProducto group by P.nombre;

select P.nombre, count(Co.IDProducto), Cl.nombre as C from producto P 
    inner join compra Co on Co.IDProducto = P.IDProducto and Co.IDProducto = 1
    inner join cliente Cl on Cl.IDCliente = Co.IDCliente group by Co.IDProducto, Cl.nombre;


select P.nombre, 
    (select count(Co.IDCompra) from compra Co where Co.IDProducto = P.IDProducto)
    from producto P;