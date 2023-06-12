use master;
	drop  table nombre
	
	DECLARE @nombre1 varchar(20),
		@nombre2 varchar(20),
            	@long int,
            	@contador int,
        	@caracter varchar(1),
            	@sql nvarchar(2000),
		@sql2 nvarchar(2000),
        	@columna varchar(2),
		@variable int,
		@i int,
		@var varchar(2),
		@parametros nvarchar(100),
		@apoyo varchar(20),
		@resultado int

            
	set @nombre1= 'MARTHA'
	SELECT @nombre2='MARTA'
	--crear tabla con palabras---
	SELECT @sql ='create table nombre ('

	SELECT @long = len(@nombre1)
    set @contador=1
    while @contador <= @long
    BEGIN
    	set @caracter=LEFT(@nombre1,1)
        SELECT @nombre1=RIGHT(@nombre1,Len(@nombre1)-1)
        SET @columna=concat(@caracter , cast(@contador as varchar(1)))
        SELECT @sql=concat(@sql,@columna,' int,')
        --print @sql
    	set @contador=@contador+1
    END
    set @sql=LEFT(@sql,Len(@sql)-1)
    set @sql=concat(@sql,')')
	EXEC sp_executesql @sql 
    
    SELECT @long = len(@nombre2)
    set @contador=1
    while @contador <= @long
    BEGIN
    	set @caracter=LEFT(@nombre2,1)
        SELECT @nombre2=RIGHT(@nombre2,Len(@nombre2)-1)
        --SET @columna=concat(@caracter , cast(@contador as varchar))
        PRINT @caracter
        ---------------------------------
        SELECT top 1 @columna= COLUMN_NAME
   		FROM INFORMATION_SCHEMA.COLUMNS
    	WHERE TABLE_NAME='NOMBRE'
    	AND ORDINAL_POSITION>=@contador
        and LEFT(COLUMN_NAME,1)=@caracter
    	ORDER BY ORDINAL_POSITION
        SET @sql =CONCAT('insert into nombre(',@columna,') values(1)')
        EXEC sp_executesql @sql
        print @columna
    	set @contador=@contador+1
    END
    
    SELECT @long= COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME='NOMBRE'
    SET @sql=''
    SET @contador=1
    WHILE @contador<=@long
    BEGIN
    	SELECT @apoyo=Concat('sum(isnull(',COLUMN_NAME,',0))+')
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME='nombre'
        and ordinal_position=@contador
        SET @sql=concat(@sql,@apoyo)
        SET @contador = @contador +1
    END
    
    SET @sql = LEFT(@sql ,len(@sql)-1)
    SET @sql = concat('select @resultadoSUM=',@sql,' ','from nombre')
    SET @parametros = N'@resultadoSUM int OUTPUT';
    EXECUTE sp_executesql @sql, @parametros, @resultadoSUM=@resultado OUTPUT;
    print @resultado
--DROP TABLE nombre
    
    
    SELECT top 1 COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME='NOMBRE'
    AND ORDINAL_POSITION>=1
    and LEFT(COLUMN_NAME,1)=@caracter
    ORDER BY ORDINAL_POSITION

	    
--contador de la cantidad de columnas
create table suma(
datos int
);
set @variable=(select count(column_name) 
				from information_schema.columns
				where table_name='nombre')
set @i=1
while @i<=@variable
begin
	set @var =(select column_name from INFORMATION_SCHEMA.COLUMNS where table_name='nombre' and ORDINAL_POSITION=@i) 
	set @sql = 'SELECT cast(sum('+@var+') as int) FROM nombre'
	set @sql2 = 'INSERT INTO suma(datos) VALUES (('+@sql+'));'
	EXEC sp_executesql @sql2
	set @i=@i+1
end
--comparacion de cadenas--
if exists (select * from suma where datos is null)
	print 'No son iguales.'
else
	print 'Son iguales'
