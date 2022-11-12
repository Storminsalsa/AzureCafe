CREATE TABLE MenuItems
(
    ItemId            INT IDENTITY    NOT NULL,
	CafeId            INT             NOT NULL,
	Name              VARCHAR(30)     NOT NULL,
	Description       VARCHAR(128)    NOT NULL,
	Price             SMALLMONEY      NOT NULL,
	CONSTRAINT PK_MenuItems
	    PRIMARY KEY (ItemId),
	CONSTRAINT FK_MenuItems_CafeId FOREIGN KEY
	    (CafeId) REFERENCES Cafes (CafeId)
);