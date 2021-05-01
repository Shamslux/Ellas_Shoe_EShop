---------------------CRIANDO O BANCO DE DADOS-------------------------------------

CREATE DATABASE ELLAS_OLTP
GO

-----------------------CONECTANDO-SE AO BANCO CRIADO-------------------------------
USE ELLAS_OLTP
GO
------------------CRIANDO AS TABELAS COM BASE NO QUE ESTÁ NA MODELAGEM LÓGICA---------

CREATE TABLE CLIENTE (
	PK_CLIENTE 					INT 					NOT NULL
	, NM_NOME 					VARCHAR(150) 			NOT NULL
	, NM_SEXO 					CHAR(1) 				NOT NULL
	, DT_NASCIMENTO 			DATE					NOT NULL
	, TX_EMAIL 					VARCHAR(100) 			NOT NULL UNIQUE
	, NM_CPF 					VARCHAR(20) 			NOT NULL UNIQUE
	, NM_RG						VARCHAR(20)				NOT NULL UNIQUE
)
GO

CREATE TABLE ENDERECO_CLIENTE (
	PK_ENDERECO_C				INT						IDENTITY(1,1) PRIMARY KEY
	, NM_RUA					VARCHAR(150)			NOT NULL
	, NM_BAIRRO					VARCHAR(100)			NOT NULL
	, NM_CIDADE					VARCHAR(100)			NOT NULL
	, NM_ESTADO					CHAR(2)					NOT NULL
	, NM_REGIAO					VARCHAR(50)				NOT NULL
	, NM_CEP					VARCHAR(20)				NOT NULL
	, FK_CLIENTE				INT						NOT NULL
)
GO

CREATE TABLE TELEFONE_CLIENTE (
	PK_TELEFONE_C				INT						IDENTITY(1,1) PRIMARY KEY
	, NM_TIPO					CHAR(3)					NOT NULL
	, NM_NUMERO					VARCHAR(11)				NOT NULL
	, FK_CLIENTE				INT						NOT NULL
)
GO
-------------------------------------------------------------------------
CREATE TABLE PRODUTO (
	PK_CODIGO					VARCHAR(15)				NOT NULL
	, NM_NOME					VARCHAR(150)			NOT NULL
	, NM_MODELO					VARCHAR(50)				NOT NULL
	, NM_MARCA					VARCHAR(50)				NOT NULL
	, FK_NUMERO_PE				INT						NOT NULL
	, FK_COR					INT						NOT NULL
	, FK_FORNECEDOR				INT						NOT NULL
	, FK_PRECO					INT						NOT NULL
)
GO


CREATE TABLE NUMERO_PE (
	PK_NUMERO_PE				INT						NOT NULL
	, NM_NUMERO					CHAR(2)					NOT NULL
)
GO

CREATE TABLE COR (
	PK_COR						INT						NOT NULL
	, NM_COR					VARCHAR(15)				NOT NULL
)
GO

CREATE TABLE PRECO (
	PK_PRECO					INT						NOT NULL
	, VL_PRECO					NUMERIC(10,2)			NOT NULL
)
GO
--------------------------------------------------------------------------
CREATE TABLE ESTOQUE (
	PK_ESTOQUE					INT						NOT NULL
	, DT_ENTRADA				DATE					NOT NULL
	, DT_SAIDA					DATE					NOT NULL
	, QT_QUANTIDADE				INT						NOT NULL
)
GO

CREATE TABLE PRODUTO_ESTOQUE (
	PK_PE						INT						NOT NULL
	, FK_CODIGO					VARCHAR(15)				NOT NULL
	, FK_ESTOQUE				INT						NOT NULL
)
GO


--------------------------------------------------------------------------
CREATE TABLE FORNECEDOR (
	PK_FORNECEDOR				INT						NOT NULL
	, NM_NOME					VARCHAR(100)			NOT NULL
)
GO

CREATE TABLE ENDERECO_FORNECEDOR (
	PK_ENDERECO_F				INT						IDENTITY(1,1) PRIMARY KEY
	, NM_RUA					VARCHAR(150)			NOT NULL
	, NM_BAIRRO					VARCHAR(100)			NOT NULL
	, NM_CIDADE					VARCHAR(100)			NOT NULL
	, NM_ESTADO					CHAR(2)					NOT NULL
	, NM_REGIAO					VARCHAR(50)				NOT NULL
	, NM_CEP					VARCHAR(9)				NOT NULL
	, FK_FORNECEDOR				INT						NOT NULL 
)
GO

CREATE TABLE TELEFONE_FORNECEDOR (
	PK_TELEFONE_F				INT						IDENTITY(1,1) PRIMARY KEY
	, NM_NUMERO					VARCHAR(11)				NOT NULL
	, FK_FORNECEDOR				INT						NOT NULL
)
GO


---------------------------------------------------------------------
CREATE TABLE FRETE_CLIENTE (
	PK_FRETE_C					INT						NOT NULL
	, NM_TRANSP					VARCHAR(100)			NOT NULL
	, NM_REGIAO					VARCHAR(50)				NOT NULL
	, VL_VALOR					NUMERIC(10,2)			NOT NULL
	, QT_PRAZO_DIA				INT						NOT NULL
	, FK_CLIENTE				INT						NOT NULL
	, FK_NOTA					INT						NOT NULL
)
GO

CREATE TABLE FRETE_FORNECEDOR (
	PK_FRETE_F					INT						NOT NULL
	, NM_TRANSP					VARCHAR(100)			NOT NULL
	, VL_VALOR					NUMERIC(10,2)			NOT NULL
	, QT_PRAZO_DIA				INT						NOT NULL
	, FK_CODIGO					VARCHAR(15)				NOT NULL
	, FK_FORNECEDOR				INT						NOT NULL
)
GO
----------------------------------------------------------------------
CREATE TABLE NOTA_FISCAL (
	PK_NOTA						INT						NOT NULL
	, DT_DATA_COMPRA			DATETIME				NOT NULL
	, VL_TOTAL_COMPRA			NUMERIC(10,2)			NOT NULL
	, FK_FORMA_PAGAMENTO		INT						NOT NULL
	, FK_CLIENTE				INT						NOT NULL
)
GO

CREATE TABLE NOTA_FISCAL_TESTE (
	PK_NOTA						INT						NOT NULL
	, DT_DATA_COMPRA			DATETIME				NOT NULL
	, VL_TOTAL_COMPRA			NUMERIC(10,2)			
	, FK_FORMA_PAGAMENTO		INT						NOT NULL
	, FK_CLIENTE				INT						NOT NULL
)
GO

CREATE TABLE FORMA_PAGAMENTO (
	PK_FORMA_PAGAMENTO			INT						NOT NULL
	, NM_FORMA_PAGAMENTO		VARCHAR(50)				NOT NULL
)
GO

CREATE TABLE ITEM_NOTA (
		PK_ITEM_NOTA			INT						NOT NULL
		, FK_CODIGO				VARCHAR(15)				NOT NULL
		, FK_NOTA				INT						NOT NULL
		, QT_QUANTIDADE			INT						NOT NULL
		, FK_PRECO				INT						NOT NULL
		, VL_TOTAL_COMPRA		NUMERIC(10,2)			NOT NULL
)
GO


CREATE TABLE ITEM_NOTA_TESTE (
		PK_ITEM_NOTA			INT						NOT NULL
		, FK_CODIGO				VARCHAR(15)				NOT NULL
		, FK_NOTA				INT						NOT NULL
		, QT_QUANTIDADE			INT						NOT NULL
		, FK_PRECO				INT						
		, VL_TOTAL_COMPRA		NUMERIC(10,2)			
)
GO

-----------------------TABELA AUXILIAR PARA CARGA DOS TELEFONES DE CLIENTES----------------------------------------
CREATE TABLE AUX_TELEFONE_C (
		PK_AUX_TC				INT						IDENTITY(1,1) PRIMARY KEY
		, NM_TIPO				CHAR(3)					
		, NM_TIPO2				CHAR(3)
		, NM_TIPO3				CHAR(3)	
		, NM_NUMERO				VARCHAR(11)				
		, NM_NUMERO2			VARCHAR(11)
		, NM_NUMERO3			VARCHAR(11)
		, PK_CLIENTE			INT
)
GO

------------------CHAVES PRIMÁRIAS--------------------------------------------------
ALTER TABLE CLIENTE ADD CONSTRAINT PK_CLIENTE 
PRIMARY KEY(PK_CLIENTE)
GO

/* ALTER TABLE ENDERECO_CLIENTE ADD CONSTRAINT PK_ENDERECO_CLIENTE 
PRIMARY KEY(PK_ENDERECO_C)
GO */

/* ALTER TABLE TELEFONE_CLIENTE ADD CONSTRAINT PK_TELEFONE_CLIENTE 
PRIMARY KEY(PK_TELEFONE_C)
GO */

ALTER TABLE PRODUTO ADD CONSTRAINT PK_PRODUTO
PRIMARY KEY(PK_CODIGO)
GO

ALTER TABLE NUMERO_PE ADD CONSTRAINT PK_NUMERO_PE
PRIMARY KEY(PK_NUMERO_PE)
GO

ALTER TABLE COR ADD CONSTRAINT PK_COR
PRIMARY KEY(PK_COR)
GO

ALTER TABLE PRECO ADD CONSTRAINT PK_PRECO
PRIMARY KEY(PK_PRECO)
GO

ALTER TABLE ESTOQUE ADD CONSTRAINT PK_ESTOQUE
PRIMARY KEY(PK_ESTOQUE)
GO

ALTER TABLE PRODUTO_ESTOQUE ADD CONSTRAINT PK_PRODUTO_ESTOQUE
PRIMARY KEY(PK_PE)
GO

ALTER TABLE FORNECEDOR ADD CONSTRAINT PK_FORNECEDOR
PRIMARY KEY(PK_FORNECEDOR)
GO

/* ALTER TABLE ENDERECO_FORNECEDOR ADD CONSTRAINT PK_ENDERECO_FORNECEDOR
PRIMARY KEY(PK_ENDERECO_F)
GO */

/* ALTER TABLE TELEFONE_FORNECEDOR ADD CONSTRAINT PK_TELEFONE_FORNECEDOR
PRIMARY KEY(PK_TELEFONE_F)
GO */

ALTER TABLE FRETE_CLIENTE ADD CONSTRAINT PK_FRETE_CLIENTE
PRIMARY KEY(PK_FRETE_C)
GO

ALTER TABLE FRETE_FORNECEDOR ADD CONSTRAINT PK_FRETE_FORNECEDOR
PRIMARY KEY(PK_FRETE_F)
GO

ALTER TABLE NOTA_FISCAL ADD CONSTRAINT PK_NOTA_FISCAL
PRIMARY KEY(PK_NOTA)
GO

ALTER TABLE FORMA_PAGAMENTO ADD CONSTRAINT PK_FORMA_PAGAMENTO
PRIMARY KEY(PK_FORMA_PAGAMENTO)
GO

ALTER TABLE ITEM_NOTA ADD CONSTRAINT PK_ITEM_NOTA
PRIMARY KEY(PK_ITEM_NOTA)
GO
-----------------CHAVES ESTRANGEIRAS-------------------------------------------------
ALTER TABLE ENDERECO_CLIENTE ADD CONSTRAINT FK_ENDERECO_CLIENTE
FOREIGN KEY(FK_CLIENTE) REFERENCES CLIENTE(PK_CLIENTE)
GO

ALTER TABLE TELEFONE_CLIENTE ADD CONSTRAINT FK_TELEFONE_CLIENTE
FOREIGN KEY(FK_CLIENTE) REFERENCES CLIENTE(PK_CLIENTE)
GO 

ALTER TABLE FRETE_CLIENTE ADD CONSTRAINT FK_FRETE_CLIENTE
FOREIGN KEY(FK_CLIENTE) REFERENCES CLIENTE(PK_CLIENTE)
GO

ALTER TABLE NOTA_FISCAL ADD CONSTRAINT FK_NOTA_FISCAL_CLIENTE
FOREIGN KEY(FK_CLIENTE) REFERENCES CLIENTE(PK_CLIENTE)
GO

ALTER TABLE PRODUTO ADD CONSTRAINT FK_PRODUTO_FORNECEDOR
FOREIGN KEY(FK_FORNECEDOR) REFERENCES FORNECEDOR(PK_FORNECEDOR)
GO

ALTER TABLE PRODUTO ADD CONSTRAINT FK_PRODUTO_COR
FOREIGN KEY(FK_COR) REFERENCES COR(PK_COR)
GO

ALTER TABLE PRODUTO ADD CONSTRAINT FK_PRODUTO_PRECO
FOREIGN KEY(FK_PRECO) REFERENCES PRECO(PK_PRECO)
GO

ALTER TABLE PRODUTO ADD CONSTRAINT FK_PRODUTO_NUMERO_PE
FOREIGN KEY(FK_NUMERO_PE) REFERENCES NUMERO_PE(PK_NUMERO_PE)
GO

ALTER TABLE ENDERECO_FORNECEDOR ADD CONSTRAINT FK_ENDERECO_FORNECEDOR
FOREIGN KEY(FK_FORNECEDOR) REFERENCES FORNECEDOR(PK_FORNECEDOR)
GO

ALTER TABLE TELEFONE_FORNECEDOR ADD CONSTRAINT FK_TELEFONE_FORNECEDOR
FOREIGN KEY(FK_FORNECEDOR) REFERENCES FORNECEDOR(PK_FORNECEDOR)
GO

ALTER TABLE FRETE_FORNECEDOR ADD CONSTRAINT FK_FRETE_FORNECEDOR
FOREIGN KEY(FK_FORNECEDOR) REFERENCES FORNECEDOR(PK_FORNECEDOR)
GO

ALTER TABLE FRETE_FORNECEDOR ADD CONSTRAINT FK_FRETE_FORNECEDOR_PRODUTO
FOREIGN KEY(FK_CODIGO) REFERENCES PRODUTO(PK_CODIGO)
GO

ALTER TABLE NOTA_FISCAL ADD CONSTRAINT FK_NOTA_FISCAL_FORMA_PAGAMENTO
FOREIGN KEY(FK_FORMA_PAGAMENTO) REFERENCES FORMA_PAGAMENTO(PK_FORMA_PAGAMENTO)
GO

ALTER TABLE PRODUTO_ESTOQUE ADD CONSTRAINT FK_PRODUTO_ESTOQUE_PRODUTO
FOREIGN KEY(FK_CODIGO) REFERENCES PRODUTO(PK_CODIGO)
GO

ALTER TABLE PRODUTO_ESTOQUE ADD CONSTRAINT FK_PRODUTO_ESTOQUE_ESTOQUE
FOREIGN KEY(FK_ESTOQUE) REFERENCES ESTOQUE(PK_ESTOQUE)
GO

ALTER TABLE FRETE_CLIENTE ADD CONSTRAINT FK_FRETE_CLIENTE_NOTA_FISCAL
FOREIGN KEY(FK_NOTA) REFERENCES NOTA_FISCAL(PK_NOTA)
GO

ALTER TABLE ITEM_NOTA ADD CONSTRAINT FK_ITEM_NOTA_NOTA_FISCAL
FOREIGN KEY(FK_NOTA) REFERENCES NOTA_FISCAL(PK_NOTA)
GO

ALTER TABLE ITEM_NOTA ADD CONSTRAINT FK_ITEM_NOTA_PRECO
FOREIGN KEY(FK_PRECO) REFERENCES PRECO(PK_PRECO)
GO
----------------------------------------------------------------------------------


/*SELECT C.PK_CLIENTE
	   , E.NM_RUA
	   , T.NM_NUMERO
FROM CLIENTE                           C
INNER	JOIN ENDERECO_CLIENTE          E
 ON C.PK_CLIENTE = E.FK_CLIENTE
INNER	JOIN TELEFONE_CLIENTE          T
 ON C.PK_CLIENTE = T.FK_CLIENTE
 GO*/
 
 /* UNION ALL PARA LIDAR COM A AUX_TELEFONE_C */
 
SELECT * FROM (SELECT PK_CLIENTE
	   , NM_TIPO
	   , NM_NUMERO
FROM ELLAS_OLTP.dbo.AUX_TELEFONE_C
UNION	ALL
SELECT PK_CLIENTE
	   , NM_TIPO2
	   , NM_NUMERO2
FROM ELLAS_OLTP.dbo.AUX_TELEFONE_C
UNION	ALL
SELECT PK_CLIENTE
	   , NM_TIPO3
	   , NM_NUMERO3
FROM ELLAS_OLTP.dbo.AUX_TELEFONE_C) A
WHERE NM_TIPO IS NOT NULL
GO

SELECT * FROM ENDERECO_CLIENTE
GO

SELECT * FROM TELEFONE_CLIENTE
GO

SELECT * FROM TELEFONE_FORNECEDOR
GO

SELECT * FROM CLIENTE
GO

SELECT * FROM PRODUTO
GO

SELECT * FROM PRECO
GO

SELECT * FROM ENDERECO_CLIENTE
GO

SELECT * FROM NOTA_FISCAL_TESTE
GO

SELECT * FROM ITEM_NOTA_TESTE
GO

SELECT * FROM ITEM_NOTA
GO

SELECT * FROM FRETE_CLIENTE
GO





/* SELECT QUE CALCULA OS ITENS DAS NOTAS */

SELECT I.PK_ITEM_NOTA
	   , I.FK_CODIGO
	   , I.FK_NOTA
	   , I.QT_QUANTIDADE
	   , I.FK_PRECO
	   , P.VL_PRECO * I.QT_QUANTIDADE AS VL_TOTAL_COMPRA


FROM ITEM_NOTA_TESTE			I
INNER	JOIN PRECO				P
 ON I.FK_PRECO = PK_PRECO
 GO
 --------------------------------------------------------
 /* SELECT QUE CALCULA O TOTAL DAS NOTAS FISCAIS */

SELECT N.PK_NOTA
	    , N.DT_DATA_COMPRA 
		, I.VL_TOTAL_COMPRA 
FROM NOTA_FISCAL_TESTE			N
INNER	JOIN (SELECT FK_NOTA, SUM(VL_TOTAL_COMPRA) AS VL_TOTAL_COMPRA 
			  FROM ITEM_NOTA
			  GROUP BY FK_NOTA) AS I
 ON I.FK_NOTA = N.PK_NOTA
GO

----------------------INSERT NA TABELA FINAL DE ITEM_NOTA---------------------------------------------------------
INSERT INTO ELLAS_OLTP.dbo.ITEM_NOTA
SELECT I.PK_ITEM_NOTA
	   , I.FK_CODIGO
	   , I.FK_NOTA
	   , I.QT_QUANTIDADE
	   , I.FK_PRECO
	   , P.VL_PRECO * I.QT_QUANTIDADE AS VL_TOTAL_COMPRA


FROM ITEM_NOTA_TESTE			I
INNER	JOIN PRECO				P
 ON I.FK_PRECO = PK_PRECO
 GO

 SELECT * FROM ITEM_NOTA
 GO
 -----------------------INSERT NA TABELA FINAL DE NOTA_FISCAL----------------------------------------------------------
 INSERT INTO ELLAS_OLTP.dbo.NOTA_FISCAL
 SELECT N.PK_NOTA
	    , N.DT_DATA_COMPRA 
		, I.VL_TOTAL_COMPRA
		, N.FK_FORMA_PAGAMENTO
		, N.FK_CLIENTE
FROM NOTA_FISCAL_TESTE			N
INNER	JOIN (SELECT FK_NOTA, SUM(VL_TOTAL_COMPRA) AS VL_TOTAL_COMPRA 
			  FROM ITEM_NOTA
			  GROUP BY FK_NOTA) AS I
 ON I.FK_NOTA = N.PK_NOTA
GO

SELECT * FROM NOTA_FISCAL
ORDER BY 2
GO

SELECT * FROM ITEM_NOTA
ORDER BY 3
GO


SELECT * FROM ENDERECO_CLIENTE
GO

SELECT * FROM FRETE_FORNECEDOR
GO

SELECT * FROM ESTOQUE
GO

SELECT * FROM PRODUTO_ESTOQUE
GO

SELECT FK_CODIGO
FROM PRODUTO_ESTOQUE FC
WHERE NOT EXISTS (
SELECT PK_CODIGO
FROM PRODUTO PK
WHERE FC.FK_CODIGO = PK.PK_CODIGO)
GO




/* Código do Stack Overflow que usei para deduzir o que precisava para resolver o problema de somar os valores
totais das notas fiscais */

/*SELECT f.TradeID, f.PricingSecurityID, s.TotalQuantity
  FROM FollowingTableStructure AS f
  JOIN (SELECT PricingSecurityID, SUM(Quantity) AS TotalQuantity
          FROM FollowingTableStructure
         GROUP BY PricingSecurityId
       ) AS s ON f.PricingSecurityID = s.PricingSecurityID /*

-- INSERT DA ITEM_NOTA

/*INSERT INTO ELLAS_OLTP.dbo.ITEM_NOTA
SELECT I.PK_ITEM_NOTA
	   , I.FK_CODIGO
	   , I.FK_NOTA
	   , I.QT_QUANTIDADE
	   , I.FK_PRECO
	   , P.VL_PRECO * I.QT_QUANTIDADE AS VL_TOTAL_COMPRA


FROM ITEM_NOTA_TESTE			I
INNER	JOIN PRECO				P
 ON I.FK_PRECO = PK_PRECO
 GO*/

/* INTERNET STUFFS */

/*
-- disable all constraints
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- enable all constraints
exec sp_MSforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all" */

-- Drop all FKs from tables!

/* DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;

PRINT @sql;
-- EXEC sp_executesql @sql; */




