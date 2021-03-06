/* CRIANDO A STAGING AREA */

CREATE DATABASE ELLAS_STAGE
GO

/* CONECTANDO-SE AO BANCO */

USE ELLAS_STAGE
GO

-----------------------CRIANDO AS TABELAS-----------------------------

CREATE TABLE ST_PRODUTO (
	PK_CODIGO					VARCHAR(15)				NOT NULL
	, NM_NOME					VARCHAR(150)			NOT NULL
	, NM_MODELO					VARCHAR(150)			NOT NULL
	, NM_MARCA					VARCHAR(150)			NOT NULL
	, NM_NUMERO_PE				VARCHAR(10)				NOT NULL
	, NM_COR					VARCHAR(50)				NOT NULL
	, NM_FORNECEDOR				VARCHAR(150)			NOT NULL
)
GO
---------------------------------------------------------------------
CREATE TABLE ST_CLIENTE (
	PK_CLIENTE					INT						NOT NULL
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
---------------------------------------------------------------------
CREATE TABLE ST_NOTA_FISCAL (
	PK_NOTA						INT						NOT NULL
	, NM_FORMA_PAGAMENTO		VARCHAR(50)				NOT NULL
	, FK_ITEM					INT						NOT NULL
)
GO
---------------------------------------------------------------------
CREATE TABLE ST_FRETE (
	PK_FRETE					INT						NOT NULL
	, NM_TRANSP					VARCHAR(50)				NOT NULL
)
GO
-----------------------------------------------------------------------
CREATE TABLE ST_FORNECIMENTO (
	PK_FORNECIMENTO				INT						NOT NULL
	, NM_TRANSP					VARCHAR(50)				NOT NULL
	, NM_FORNECEDOR				VARCHAR(150)			NOT NULL
)
GO
-------------------------------------------------------------------------
CREATE TABLE ST_FORNECEDOR (
	PK_FORNECEDOR				INT						NOT NULL
	, NM_NOME					VARCHAR(150)			NOT NULL
	, NM_RUA					VARCHAR(150)			NOT NULL
	, NM_BAIRRO					VARCHAR(150)			NOT NULL
	, NM_CIDADE					VARCHAR(150)			NOT NULL
	, NM_ESTADO					VARCHAR(50)				NOT NULL
	, NM_REGIAO					VARCHAR(50)				NOT NULL
	, NM_CEP					VARCHAR(50)				NOT NULL
)
GO
------------------------------------------------------------------------
CREATE TABLE ST_FATO_COMPRA (
	FK_CODIGO					VARCHAR(15)				NOT NULL
	, FK_CLIENTE				INT						NOT NULL
	, FK_FRETE					INT						NOT NULL
	, FK_NOTA					INT						NOT NULL
	, DT_DATA_COMPRA			DATE					NOT NULL
	, VL_VALOR_ITEM				NUMERIC(10,2)			NOT NULL
	, QT_QUANTIDADE				INT						NOT NULL
	, VL_FRETE_CONSUMIDOR		NUMERIC(10,2)			NOT NULL
	, QT_PRAZO_DIAS				INT						NOT NULL 
)
GO
------------------------------------------------------------------------
CREATE TABLE ST_FATO_LOGISTICA (
	FK_CODIGO					VARCHAR(15)		NOT NULL
	, FK_FORNECEDOR				INT				NOT NULL
	, FK_FORNECIMENTO			INT				NOT NULL
	, DT_SAIDA					DATE			NOT NULL
	, DT_ENTRADA				DATE			NOT NULL
	, QT_QUANTIDADE				INT				NOT NULL
	, NM_COD_ESTOQUE			INT				NOT NULL
	, VL_FRETE_FORNECEDOR		NUMERIC(10,2)	NOT NULL
	, QT_PRAZO_DIA_FORNECEDOR	INT				NOT NULL
)
GO
---------------------SELECTS DE INSERT----------------------------------

-- PRODUTO

INSERT INTO	ELLAS_STAGE.dbo.ST_PRODUTO
SELECT	    P.PK_CODIGO
		    , P.NM_NOME
			, P.NM_MODELO
			, P.NM_MARCA
			, N.NM_NUMERO AS NM_NUMERO_PE
			, C.NM_COR
			, F.NM_NOME AS NM_FORNECEDOR
FROM	     ELLAS_OLTP.dbo.PRODUTO						P
INNER	JOIN ELLAS_OLTP.dbo.NUMERO_PE					N
  ON P.FK_NUMERO_PE = N.PK_NUMERO_PE
INNER	JOIN ELLAS_OLTP.dbo.COR							C 
  ON P.FK_COR = C.PK_COR
INNER	JOIN ELLAS_OLTP.dbo.FORNECEDOR					F
  ON P.FK_FORNECEDOR = F.PK_FORNECEDOR
GO
-----------------------------------------------------------------------

-- CLIENTE

INSERT INTO ELLAS_STAGE.dbo.ST_CLIENTE
SELECT		C.PK_CLIENTE
			, C.NM_NOME
			, CASE C.NM_SEXO
			WHEN 'M' THEN 'Masculino'
			WHEN 'F' THEN 'Feminino'
			END AS NM_SEXO
			, (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(C.DT_NASCIMENTO,'yyyyMMdd'))  /10000 AS QT_IDADE
			, C.TX_EMAIL
			, C.NM_CPF
			, C.NM_RG
			, E.NM_RUA
			, E.NM_BAIRRO
			, E.NM_CIDADE
			, E.NM_ESTADO
			, E.NM_REGIAO
			, E.NM_CEP
			, CASE WHEN (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(C.DT_NASCIMENTO,'yyyyMMdd'))  /10000 < 18 THEN 'Menor de 18 anos'
       WHEN (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(C.DT_NASCIMENTO,'yyyyMMdd'))  /10000 BETWEEN 18 AND 30 THEN  '18 - 30 anos'
	   WHEN (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(C.DT_NASCIMENTO,'yyyyMMdd'))  /10000 BETWEEN 31 AND 40 THEN  '31 - 40 anos'
	   WHEN (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(C.DT_NASCIMENTO,'yyyyMMdd'))  /10000 BETWEEN 41 AND 50 THEN  '41 - 50 anos'
	   WHEN (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(C.DT_NASCIMENTO,'yyyyMMdd'))  /10000 BETWEEN 51 AND 65 THEN  '51 - 65 anos'
       ELSE  '+65 ANOS' END AS 'NM_FAIXA_ETARIA'
FROM		 ELLAS_OLTP.dbo.CLIENTE								C
INNER	JOIN ELLAS_OLTP.dbo.ENDERECO_CLIENTE					E
  ON C.PK_CLIENTE = E.FK_CLIENTE
GO
-----------------------------------------------------------------------------------------------------------------------------------------

-- NOTA FISCAL

INSERT INTO ELLAS_STAGE.dbo.ST_NOTA_FISCAL
SELECT		N.PK_NOTA
			, F.NM_FORMA_PAGAMENTO
			, I.PK_ITEM_NOTA AS FK_ITEM
FROM		 ELLAS_OLTP.dbo.ITEM_NOTA				I
INNER	JOIN ELLAS_OLTP.dbo.NOTA_FISCAL				N
  ON I.FK_NOTA = N.PK_NOTA
INNER	JOIN ELLAS_OLTP.dbo.FORMA_PAGAMENTO			F  
  ON N.FK_FORMA_PAGAMENTO = F.PK_FORMA_PAGAMENTO
GO
-------------------------------------------------------------------------------------------------------------------------------------------

-- FRETE DOS CLIENTES 

INSERT INTO ELLAS_STAGE.dbo.ST_FRETE
SELECT		F.PK_FRETE_C AS PK_FRETE
			, F.NM_TRANSP
FROM		ELLAS_OLTP.dbo.FRETE_CLIENTE			F
GO
--------------------------------------------------------------------------

-- FORNECIMENTO

INSERT INTO ELLAS_STAGE.dbo.ST_FORNECIMENTO
SELECT		F.PK_FRETE_F AS PK_FORNECIMENTO
			, F.NM_TRANSP
			, X.NM_NOME AS NM_FORNECEDOR
FROM		 ELLAS_OLTP.dbo.FRETE_FORNECEDOR		F 
INNER	JOIN ELLAS_OLTP.dbo.FORNECEDOR				X
  ON F.FK_FORNECEDOR = X.PK_FORNECEDOR 
GO
------------------------------------------------------------------------------

-- FORNECEDOR

INSERT INTO ELLAS_STAGE.dbo.ST_FORNECEDOR
SELECT		F.PK_FORNECEDOR
			, F.NM_NOME
			, E.NM_RUA
			, E.NM_BAIRRO
			, E.NM_CIDADE
			, E.NM_ESTADO
			, E.NM_REGIAO
			, E.NM_CEP
FROM		 ELLAS_OLTP.dbo.FORNECEDOR				F
INNER	JOIN ELLAS_OLTP.dbo.ENDERECO_FORNECEDOR		E
  ON F.PK_FORNECEDOR = E.FK_FORNECEDOR
GO
-------------------------------------------------------------------------------
-- FATO DE COMPRAS

INSERT INTO ELLAS_STAGE.dbo.ST_FATO_COMPRA
SELECT		I.FK_CODIGO
			, F.FK_CLIENTE
			, F.PK_FRETE_C AS FK_FRETE
			, N.PK_NOTA AS FK_NOTA
			, CAST(N.DT_DATA_COMPRA AS DATE) AS DT_DATA_COMPRA
			, I.VL_TOTAL_COMPRA AS VL_VALOR_ITEM
			, I.QT_QUANTIDADE
			, F.VL_VALOR AS VL_FRETE_CONSUMIDOR
			, F.QT_PRAZO_DIA AS QT_PRAZO_DIAS
FROM		 ELLAS_OLTP.dbo.FRETE_CLIENTE		    F		
INNER	JOIN ELLAS_OLTP.dbo.ITEM_NOTA				I 
  ON F.FK_NOTA = I.FK_NOTA
INNER	JOIN ELLAS_OLTP.dbo.NOTA_FISCAL				N
  ON I.FK_NOTA = N.PK_NOTA
GO   
--------------------------------------------------------------------------------

-- FATO LOG??STICA
INSERT INTO ELLAS_STAGE.dbo.ST_FATO_LOGISTICA
SELECT		P.PK_CODIGO AS FK_CODIGO
			, P.FK_FORNECEDOR
			, X.PK_FRETE_F AS FK_FORNECIMENTO
			, E.DT_SAIDA
			, E.DT_ENTRADA
			, E.QT_QUANTIDADE
			, Y.FK_ESTOQUE AS NM_COD_ESTOQUE
			, X.VL_VALOR AS VL_FRETE_FORNECEDOR
			, X.QT_PRAZO_DIA AS QT_PRAZO_DIA_FORNECEDOR
FROM		 ELLAS_OLTP.dbo.PRODUTO							P
INNER	JOIN ELLAS_OLTP.dbo.FRETE_FORNECEDOR				X
  ON P.FK_FORNECEDOR = X.FK_FORNECEDOR					
INNER	JOIN ELLAS_OLTP.dbo.PRODUTO_ESTOQUE					Y
  ON P.PK_CODIGO = Y.FK_CODIGO
INNER	JOIN ELLAS_OLTP.dbo.ESTOQUE							E
  ON Y.FK_ESTOQUE = E.PK_ESTOQUE
GO


SELECT		I.FK_CODIGO
			, F.FK_CLIENTE
			, F.PK_FRETE_C AS FK_FRETE
			, N.PK_NOTA AS FK_NOTA
			, CAST(N.DT_DATA_COMPRA AS DATE) AS DT_DATA_COMPRA
			, I.VL_TOTAL_COMPRA AS VL_VALOR_ITEM
			, I.QT_QUANTIDADE
			, F.VL_VALOR AS VL_FRETE_CONSUMIDOR
			, F.QT_PRAZO_DIA AS QT_PRAZO_DIAS
			, COUNT(*)		 AS CONTAGEM
FROM		 ELLAS_OLTP.dbo.FRETE_CLIENTE		    F		
INNER	JOIN ELLAS_OLTP.dbo.ITEM_NOTA				I 
  ON F.FK_NOTA = I.FK_NOTA
INNER	JOIN ELLAS_OLTP.dbo.NOTA_FISCAL				N
  ON I.FK_NOTA = N.PK_NOTA
GROUP BY I.FK_CODIGO, F.PK_FRETE_C, F.FK_CLIENTE, N.PK_NOTA, CAST(N.DT_DATA_COMPRA AS DATE), I.VL_TOTAL_COMPRA, I.QT_QUANTIDADE, F.VL_VALOR, F.QT_PRAZO_DIA
GO   