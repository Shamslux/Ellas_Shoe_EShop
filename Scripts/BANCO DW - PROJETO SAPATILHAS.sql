--***************************************************************************************--
--***************************************	ELLAS_DW   **********************************--
--***************************************************************************************--

---------------------- CRIANDO O DW--------------------------------------------------------

CREATE DATABASE ELLAS_DW
GO

----------------------CONECTANDO-SE AO BANCO DW--------------------------------------------

USE ELLAS_DW
GO

--***************************************************************************************--
--***************************************	DIMENSÕES   *********************************--
--***************************************************************************************--

--=============================================================================--
---------------------------------- TB_DIM_CLIENTE -------------------------------
--=============================================================================--

CREATE TABLE TB_DIM_CLIENTE (
	SK_CLIENTE					INT IDENTITY(1,1)		NOT NULL
	, NK_CLIENTE				INT						NOT NULL
	, NM_NOME					VARCHAR(150)			NOT NULL
	, NM_SEXO					VARCHAR(50)				NOT NULL
	, QT_IDADE					INT						NOT NULL
	, TX_EMAIL					VARCHAR(150)			NOT NULL
	, NM_CPF					VARCHAR(50)				NOT NULL
	, NM_RG						VARCHAR(50)				NOT NULL
	, NM_RUA					VARCHAR(150)			NOT NULL
	, NM_BAIRRO					VARCHAR(150)			NOT NULL
	, NM_CIDADE					VARCHAR(150)			NOT NULL
	, NM_ESTADO					VARCHAR(50)				NOT NULL
	, NM_REGIAO					VARCHAR(50)				NOT NULL
	, NM_CEP					VARCHAR(50)				NOT NULL
	, NM_FAIXA_ETARIA			VARCHAR(50)				NOT NULL					
)
GO
-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_DIM_PRODUTO -------------------------------
--=============================================================================--

CREATE TABLE TB_DIM_PRODUTO (
	SK_PRODUTO					INT IDENTITY(1,1)		NOT NULL
	, NK_CODIGO					VARCHAR(15)				NOT NULL
	, NM_NOME					VARCHAR(150)			NOT NULL
	, NM_MODELO					VARCHAR(150)			NOT NULL
	, NM_MARCA					VARCHAR(150)			NOT NULL
	, NM_NUMERO_PE				VARCHAR(10)				NOT NULL
	, NM_COR					VARCHAR(50)				NOT NULL
	, NM_FORNECEDOR				VARCHAR(150)			NOT NULL
)
GO
-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_DIM_FRETE -------------------------------
--=============================================================================--

CREATE TABLE TB_DIM_FRETE (
	SK_FRETE					INT IDENTITY(1,1)		NOT NULL
	, NK_FRETE					INT						NOT NULL
	, NM_TRANSP					VARCHAR(50)				NOT NULL
)
GO
-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_DIM_NOTA_FISCAL ---------------------------
--=============================================================================--

CREATE TABLE TB_DIM_NOTA_FISCAL (
	SK_NOTA_FISCAL				INT IDENTITY(1,1)		NOT NULL
	, NK_NOTA					INT						NOT NULL
	, NM_FORMA_PAGAMENTO		VARCHAR(50)				NOT NULL
	, FK_ITEM					INT						NOT NULL
)
GO
-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_DIM_FORNECIMENTO --------------------------
--=============================================================================--

CREATE TABLE TB_DIM_FORNECIMENTO (
	SK_FORNECIMENTO				INT IDENTITY(1,1)		NOT NULL
	, NK_FORNECIMENTO			INT						NOT NULL
	, NM_TRANSP					VARCHAR(50)				NOT NULL
	, NM_FORNECEDOR				VARCHAR(150)			NOT NULL
)
GO
-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_DIM_FORNECEDOR ----------------------------
--=============================================================================--

CREATE TABLE TB_DIM_FORNECEDOR (
	SK_FORNECEDOR				INT IDENTITY(1,1)		NOT NULL
	, NK_FORNECEDOR				INT						NOT NULL
	, NM_NOME					VARCHAR(150)			NOT NULL
	, NM_RUA					VARCHAR(150)			NOT NULL
	, NM_BAIRRO					VARCHAR(150)			NOT NULL
	, NM_CIDADE					VARCHAR(150)			NOT NULL
	, NM_ESTADO					VARCHAR(50)				NOT NULL
	, NM_REGIAO					VARCHAR(50)				NOT NULL
	, NM_CEP					VARCHAR(50)				NOT NULL
)
GO
-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_DIM_TEMPO ---------------------------------
--=============================================================================--

CREATE TABLE TB_DIM_TEMPO
(
	SK_TEMPO						INT PRIMARY KEY IDENTITY(1,1)			
	, DT_DATA						DATE									
	, NM_DIA						CHAR(2)									
	, NM_DIA_SEMANA					VARCHAR(10)								
	, NM_NUMERO_MES					CHAR(2)									
	, NM_MES						VARCHAR(10)								
	, NM_QUARTO						TINYINT									
	, NM_NOME_QUARTO				VARCHAR(10)								
	, NM_ANO						CHAR(4)									
	, NM_ESTACAO_ANO				VARCHAR(20)								
	, NM_FIM_SEMANA					CHAR(3)									
	, DT_DATA_COMPLETA				VARCHAR(10)								
)
GO
----------------PROGRAMAÇÃO DA TB_DIM_TEMPO-----------------------------
		-------------------------------
		--CARREGANDO A DIMENSÃO TEMPO--
		-------------------------------

		--EXIBINDO A DATA ATUAL

		PRINT CONVERT(VARCHAR,GETDATE(),113) 

		--ALTERANDO O INCREMENTO PARA INÍCIO EM 5000
		--PARA A POSSIBILIDADE DE DATAS ANTERIORES

		DBCC CHECKIDENT (TB_DIM_TEMPO, RESEED, 50000) 

		--INSERÇÃO DE DADOS NA DIMENSÃO

		DECLARE    @DATAINICIO DATETIME 
				 , @DATAFIM DATETIME 
				 , @DATA DATETIME
		 		  
		PRINT GETDATE() 

				SELECT @DATAINICIO = '1/1/1950' 
					, @DATAFIM = '1/1/2050'

				SELECT @DATA = @DATAINICIO 

		WHILE @DATA < @DATAFIM 
		 BEGIN 
	
			INSERT INTO TB_DIM_TEMPO 
			( 
				  DT_DATA, 
				  NM_DIA,
				  NM_DIA_SEMANA, 
				  NM_NUMERO_MES,
				  NM_MES, 
				  NM_QUARTO,
				  NM_NOME_QUARTO, 
				  NM_ANO 
		
			) 
			SELECT @DATA AS DATA, DATEPART(DAY,@DATA) AS NM_DIA, 

				 CASE DATEPART(DW, @DATA) 
            
					WHEN 1 THEN 'Domingo'
					WHEN 2 THEN 'Segunda' 
					WHEN 3 THEN 'Terça' 
					WHEN 4 THEN 'Quarta' 
					WHEN 5 THEN 'Quinta' 
					WHEN 6 THEN 'Sexta' 
					WHEN 7 THEN 'Sábado' 
             
				END AS NM_DIA_SEMANA,

				 DATEPART(MONTH,@DATA) AS NM_MES, 

				 CASE DATENAME(MONTH,@DATA) 
			
					WHEN 'January' THEN 'Janeiro'
					WHEN 'February' THEN 'Fevereiro'
					WHEN 'March' THEN 'Março'
					WHEN 'April' THEN 'Abril'
					WHEN 'May' THEN 'Maio'
					WHEN 'June' THEN 'Junho'
					WHEN 'July' THEN 'Julho'
					WHEN 'August' THEN 'Agosto'
					WHEN 'September' THEN 'Setembro'
					WHEN 'October' THEN 'Outubro'
					WHEN 'November' THEN 'Novembro'
					WHEN 'December' THEN 'Dezembro'
		
				END AS NM_NOME_MES,
		 
				 DATEPART(qq,@DATA) NM_QUARTO, 

				 CASE DATEPART(qq,@DATA) 
					WHEN 1 THEN 'Primeiro' 
					WHEN 2 THEN 'Segundo' 
					WHEN 3 THEN 'Terceiro' 
					WHEN 4 THEN 'Quarto' 
				END AS NM_NOME_QUARTO 
				, DATEPART(YEAR,@DATA) NM_ANO
	
			SELECT @DATA = DATEADD(dd,1,@DATA)
		END

		UPDATE TB_DIM_TEMPO 
		SET NM_DIA = '0' + NM_DIA 
		WHERE LEN(NM_DIA) = 1 

		UPDATE TB_DIM_TEMPO 
		SET NM_NUMERO_MES = '0' + NM_NUMERO_MES 
		WHERE LEN(NM_NUMERO_MES) = 1 

		UPDATE TB_DIM_TEMPO 
		SET DT_DATA_COMPLETA = NM_ANO + NM_NUMERO_MES + NM_DIA 
		GO


		SELECT * FROM TB_DIM_TEMPO
		GO


		----------------------------------------------
		----------FINS DE SEMANA E ESTAÇÕES-----------
		----------------------------------------------

		DECLARE C_TEMPO CURSOR FOR	
			SELECT SK_TEMPO, DT_DATA_COMPLETA, NM_DIA_SEMANA, NM_ANO FROM TB_DIM_TEMPO
		DECLARE			
					@ID INT,
					@DATA varchar(10),
					@DIASEMANA VARCHAR(20),
					@ANO CHAR(4),
					@FIMSEMANA CHAR(3),
					@ESTACAO VARCHAR(15)
					
		OPEN C_TEMPO
			FETCH NEXT FROM C_TEMPO
			INTO @ID, @DATA, @DIASEMANA, @ANO
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
					 IF @DIASEMANA in ('Domingo','Sábado') 
						SET @FIMSEMANA = 'Sim'
					 ELSE 
						SET @FIMSEMANA = 'Não'

					--ATUALIZANDO ESTACOES

					IF @DATA BETWEEN CONVERT(CHAR(4),@ano)+'0923' 
					AND CONVERT(CHAR(4),@ANO)+'1220'
						SET @ESTACAO = 'Primavera'

					ELSE IF @DATA BETWEEN CONVERT(CHAR(4),@ano)+'0321' 
					AND CONVERT(CHAR(4),@ANO)+'0620'
						SET @ESTACAO = 'Outono'

					ELSE IF @DATA BETWEEN CONVERT(CHAR(4),@ano)+'0621' 
					AND CONVERT(CHAR(4),@ANO)+'0922'
						SET @ESTACAO = 'Inverno'

					ELSE -- @data between 21/12 e 20/03
						SET @ESTACAO = 'Verão'

					--ATUALIZANDO FINS DE SEMANA
	
					UPDATE TB_DIM_TEMPO SET NM_FIM_SEMANA = @FIMSEMANA
					WHERE SK_TEMPO = @ID

					--ATUALIZANDO

					UPDATE TB_DIM_TEMPO SET NM_ESTACAO_ANO = @ESTACAO
					WHERE SK_TEMPO = @ID
		
			FETCH NEXT FROM C_TEMPO
			INTO @ID, @DATA, @DIASEMANA, @ANO	
		END
		CLOSE C_TEMPO
		DEALLOCATE C_TEMPO
		GO

--***************************************************************************************--
--***************************************	FATOS   *************************************--
--***************************************************************************************--

-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_FAT_COMPRA -------------------------------
--=============================================================================--

CREATE TABLE TB_FAT_COMPRA (
	FK_SK_PRODUTO				INT						NOT NULL
	, FK_SK_CLIENTE				INT						NOT NULL
	, FK_SK_FRETE				INT						NOT NULL
	, FK_SK_NOTA				INT						NOT NULL
	, FK_SK_TEMPO				INT						NOT NULL
	, DT_DATA_COMPRA			DATE					NOT NULL
	, VL_VALOR_ITEM				NUMERIC(10,2)			NOT NULL
	, QT_QUANTIDADE				INT						NOT NULL
	, VL_FRETE_CONSUMIDOR		NUMERIC(10,2)			NOT NULL
	, QT_PRAZO_DIAS				INT						NOT NULL 
)
GO
-------------------------------------------------------------------------------------
--=============================================================================--
---------------------------------- TB_FAT_LOGISTICA -----------------------------
--=============================================================================--
CREATE TABLE TB_FAT_LOGISTICA (
	FK_SK_PRODUTO				INT				NOT NULL
	, FK_SK_FORNECEDOR			INT				NOT NULL
	, FK_SK_FORNECIMENTO		INT				NOT NULL
	, FK_SK_TEMPO				INT				NOT NULL
	, DT_SAIDA					DATE			NOT NULL
	, DT_ENTRADA				DATE			NOT NULL
	, QT_QUANTIDADE				INT				NOT NULL
	, NM_COD_ESTOQUE			INT				NOT NULL
	, VL_FRETE_FORNECEDOR		NUMERIC(10,2)	NOT NULL
	, QT_PRAZO_DIA_FORNECEDOR	INT				NOT NULL
)
GO
--***************************************************************************************--
--*********************************	CONSTRAINTS - PKs   *********************************--
--***************************************************************************************--

ALTER TABLE TB_DIM_CLIENTE ADD CONSTRAINT PK_DIM_CLIENTE 
PRIMARY KEY (SK_CLIENTE)
GO

ALTER TABLE TB_DIM_PRODUTO ADD CONSTRAINT PK_DIM_PRODUTO
PRIMARY KEY (SK_PRODUTO)
GO

ALTER TABLE TB_DIM_FRETE ADD CONSTRAINT PK_DIM_FRETE
PRIMARY KEY (SK_FRETE)
GO

ALTER TABLE TB_DIM_NOTA_FISCAL ADD CONSTRAINT PK_DIM_NOTA_FISCAL
PRIMARY KEY (SK_NOTA_FISCAL)
GO

ALTER TABLE TB_DIM_FORNECIMENTO ADD CONSTRAINT PK_DIM_FORNECIMENTO
PRIMARY KEY (SK_FORNECIMENTO)
GO

ALTER TABLE TB_DIM_FORNECEDOR ADD CONSTRAINT PK_DIM_FORNECEDOR
PRIMARY KEY (SK_FORNECEDOR)
GO

ALTER TABLE TB_FAT_COMPRA ADD CONSTRAINT PK_FAT_COMPRA
PRIMARY KEY (FK_SK_PRODUTO, FK_SK_CLIENTE, FK_SK_FRETE, FK_SK_NOTA, FK_SK_TEMPO)
GO

ALTER TABLE TB_FAT_LOGISTICA ADD CONSTRAINT PK_FAT_LOGISTICA
PRIMARY KEY (FK_SK_PRODUTO, FK_SK_FORNECEDOR, FK_SK_FORNECIMENTO, FK_SK_TEMPO)
GO
--***************************************************************************************--
--*********************************	CONSTRAINTS - FKs   *********************************--
--***************************************************************************************--

--=============================================================================--
--------------------------- TB_FAT_COMPRA - FOREIGN KEYS ------------------------
--=============================================================================--
ALTER TABLE TB_FAT_COMPRA ADD CONSTRAINT FK_FAT_COMPRA#FK_SK_PRODUTO 
FOREIGN KEY (FK_SK_PRODUTO) REFERENCES ELLAS_DW.dbo.TB_DIM_PRODUTO (SK_PRODUTO)
GO

ALTER TABLE TB_FAT_COMPRA ADD CONSTRAINT FK_FAT_COMPRA#FK_SK_CLIENTE 
FOREIGN KEY (FK_SK_CLIENTE) REFERENCES ELLAS_DW.dbo.TB_DIM_CLIENTE (SK_CLIENTE)
GO

ALTER TABLE TB_FAT_COMPRA ADD CONSTRAINT FK_FAT_COMPRA#FK_SK_FRETE 
FOREIGN KEY (FK_SK_FRETE) REFERENCES ELLAS_DW.dbo.TB_DIM_FRETE (SK_FRETE)
GO

ALTER TABLE TB_FAT_COMPRA ADD CONSTRAINT FK_FAT_COMPRA#FK_SK_NOTA
FOREIGN KEY (FK_SK_NOTA) REFERENCES ELLAS_DW.dbo.TB_DIM_NOTA_FISCAL (SK_NOTA_FISCAL)
GO

ALTER TABLE TB_FAT_COMPRA ADD CONSTRAINT FK_FAT_COMPRA#FK_SK_TEMPO
FOREIGN KEY (FK_SK_TEMPO) REFERENCES ELLAS_DW.dbo.TB_DIM_TEMPO (SK_TEMPO)
GO
--=============================================================================--
--------------------------- TB_FAT_LOGISTICA - FOREIGN KEYS ---------------------
--=============================================================================--
ALTER TABLE TB_FAT_LOGISTICA ADD CONSTRAINT FK_FAT_LOGISTICA#FK_SK_PRODUTO 
FOREIGN KEY (FK_SK_PRODUTO) REFERENCES ELLAS_DW.dbo.TB_DIM_PRODUTO (SK_PRODUTO)
GO

ALTER TABLE TB_FAT_LOGISTICA ADD CONSTRAINT FK_FAT_LOGISTICA#FK_SK_FORNECEDOR
FOREIGN KEY (FK_SK_FORNECEDOR) REFERENCES ELLAS_DW.dbo.TB_DIM_FORNECEDOR (SK_FORNECEDOR)
GO

ALTER TABLE TB_FAT_LOGISTICA ADD CONSTRAINT FK_FAT_LOGISTICA#FK_SK_FORNECIMENTO 
FOREIGN KEY (FK_SK_FORNECIMENTO) REFERENCES ELLAS_DW.dbo.TB_DIM_FORNECIMENTO(SK_FORNECIMENTO)
GO

ALTER TABLE TB_FAT_LOGISTICA ADD CONSTRAINT FK_FAT_LOGISTICA#FK_SK_TEMPO
FOREIGN KEY (FK_SK_TEMPO) REFERENCES ELLAS_DW.dbo.TB_DIM_TEMPO (SK_TEMPO)
--***************************************************************************************--
--*********************************	INSERT DAS FATOS  ***********************************--
--***************************************************************************************--

--=============================================================================--
--------------------------- TB_FAT_COMPRA - INSERT ------------------------------
--=============================================================================--

INSERT INTO ELLAS_DW.dbo.TB_FAT_COMPRA
SELECT	dp.SK_PRODUTO				AS FK_SK_PRODUTO
		, dc.SK_CLIENTE				AS FK_SK_CLIENTE
		, df.SK_FRETE				AS FK_SK_FRETE
		, dn.SK_NOTA_FISCAL			AS FK_SK_NOTA
		, dt.SK_TEMPO				AS FK_SK_TEMPO
		, ft.DT_DATA_COMPRA
		, ft.VL_VALOR_ITEM
		, ft.QT_QUANTIDADE
		, ft.VL_FRETE_CONSUMIDOR
		, ft.QT_PRAZO_DIAS
FROM ELLAS_STAGE.dbo.ST_FATO_COMPRA						ft
INNER	JOIN ELLAS_DW.dbo.TB_DIM_PRODUTO				dp
  ON	ft.FK_CODIGO = dp.NK_CODIGO
INNER	JOIN ELLAS_DW.dbo.TB_DIM_CLIENTE				dc
  ON	ft.FK_CLIENTE = dc.NK_CLIENTE
INNER	JOIN ELLAS_DW.dbo.TB_DIM_FRETE					df
  ON	ft.FK_FRETE = df.NK_FRETE
INNER	JOIN ELLAS_DW.dbo.TB_DIM_NOTA_FISCAL			dn
  ON 	ft.FK_NOTA = dn.NK_NOTA
INNER	JOIN ELLAS_DW.dbo.TB_DIM_TEMPO					dt
  ON	ft.DT_DATA_COMPRA = dt.DT_DATA
GO

--=============================================================================--
--------------------------- TB_FAT_LOGISTICA - INSERT ------------------------------
--=============================================================================--

INSERT INTO ELLAS_DW.dbo.TB_FAT_LOGISTICA
SELECT	distinct dp.SK_PRODUTO				AS FK_SK_PRODUTO
		, df.SK_FORNECEDOR			AS FK_SK_FORNECEDOR
		, dx.SK_FORNECIMENTO		AS FK_SK_FORNECIMENTO
		, dt.SK_TEMPO				AS FK_SK_TEMPO
		, ft.DT_SAIDA
		, ft.DT_ENTRADA
		, ft.QT_QUANTIDADE
		, ft.NM_COD_ESTOQUE
		, ft.VL_FRETE_FORNECEDOR
		, ft.QT_PRAZO_DIA_FORNECEDOR
FROM	ELLAS_STAGE.dbo.ST_FATO_LOGISTICA				ft
INNER	JOIN ELLAS_DW.dbo.TB_DIM_PRODUTO				dp
  ON ft.FK_CODIGO = dp.NK_CODIGO
INNER	JOIN ELLAS_DW.dbo.TB_DIM_FORNECEDOR				df
  ON ft.FK_FORNECEDOR = df.NK_FORNECEDOR
INNER	JOIN ELLAS_DW.dbo.TB_DIM_FORNECIMENTO			dx
  ON ft.FK_FORNECIMENTO = dx.NK_FORNECIMENTO
INNER	JOIN ELLAS_DW.dbo.TB_DIM_TEMPO					dt
  ON ft.DT_SAIDA = dt.DT_DATA
GO
------------------------------------------------------------

