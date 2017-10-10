select categoria from categoria;

select
    L.nombre as Nombre_Local,  
    P.nombre as Nombre_Producto, 
    count(Co.IDProducto) as Ventas_realizadas,
    max(concat(Cl.nombre, ' ', Cl.apellido)) as Persona_realizo_más_compras,
    max(Pa.FechaPago) as Fecha_último_pago,
    case 
        when max(Pa.FechaPago) > date_add(NOW(), INTERVAL -1 MONTH) then concat('Se realizó hace ', DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)), ' días')
        when (max(Pa.FechaPago) <= date_add(NOW(), INTERVAL -1 MONTH) and max(Pa.FechaPago) > date_add(NOW(), INTERVAL -1 YEAR)) then concat('Se realizó hace ', if(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago))%30 = 0, concat(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago))/30, ' meses'), concat(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) DIV 30, ' meses y ', DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)) % 30, ' días')))
        else FROM_DAYS(DATEDIFF(CURRENT_DATE, max(Pa.FechaPago)))
                end as Informe_último_pago
    from producto P 
        inner join compra Co on P.IDProducto = Co.IDProducto
        inner join local L on L.IDLocal = P.IDLocal
        inner join pago Pa on Pa.IDPago = Co.IDPago
        inner join cliente Cl on Cl.IDCliente = Co.IDCliente
        group by Co.IDProducto;