CREATE TABLE Cafes
(
    CafeId            INT IDENTITY    NOT NULL,
	Name              VARCHAR(50)     NOT NULL,
	Description       VARCHAR(200)    NOT NULL,
	Location          VARCHAR(30)     NOT NULL,
	CONSTRAINT PK_Cafes
	    PRIMARY KEY (CafeId)
);