declare @x bigint

set @x = 100
WHILE (@x < 130)
   BEGIN
	select  @x, CONVERT(char,getDate(),@x)
	set @x = @x +1
end
