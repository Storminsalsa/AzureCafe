CREATE TABLE CafeReviews 
(
    ReviewID           INT IDENTITY      NOT NULL,
	CafeId             INT               NOT NULL,
	ReviewDate         DATE              NOT NULL,
	ReviewerName       VARCHAR(30)       NOT NULL,
	Rating             SMALLINT          NOT NULL,
	Comments           VARCHAR(512)      NULL,
	[CommentsSentiment] VARCHAR(25) NULL, 
    [ReviewPhotoName] VARCHAR(50) NULL, 
    CONSTRAINT PK_CafeReviews 
	    PRIMARY KEY (ReviewId),
	CONSTRAINT FK_CafeReviews_CafeId FOREIGN KEY
	    (CafeId) REFERENCES Cafes (CafeId),
	CONSTRAINT CK_Rating
	    CHECK (Rating >= 1 AND Rating <= 5)
);
