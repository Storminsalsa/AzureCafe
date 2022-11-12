SET IDENTITY_INSERT Cafes ON

MERGE INTO Cafes AS Target
USING (VALUES
    (1,  'Visual Sandwich',             'Your favorite sandwiches since version 2003',                             'Building 18'),
    (2,  'PizzaPoint',                  'Wood fired pizzas',                                                       'Building 7'),
    (3,  'Seafood#',                    'Classic Chicago Dogs and Italian Beef',                                   'Building 4'),
    (4,  'Sushi Server',                'You love sushi.  Need we say more',                                       'Building 25'),
    (5,  'OneNoodle',                   'Asian stir fry bowls made to order',                                      'Building 18'),
    (6,  'Spaghetti Development Kit',   'Build your own pasta creations',                                          'Building 3'),
    (7,  'Ice Cream Explorer',          'Surf your favorite flavors of ice cream and frozen yogurt',               'Building 9'),
    (8,  'GrillHub',                    'Open source grilled favorites',                                           'Building 31')
)
AS Source (CafeId, Name, Description, Location)
ON Target.CafeId = Source.CafeId
    WHEN MATCHED THEN
        UPDATE
		    SET
			Name = Source.Name,
			Description = Source.Description,
			Location = Source.Location
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (CafeId, Name, Description, Location)
        VALUES (CafeId, Name, Description, Location);

DECLARE @nextCafeId INT;
SELECT @nextCafeId = (
        SELECT max(CafeId)
            FROM Cafes
	) ;


DBCC CHECKIDENT (Cafes, RESEED, @nextCafeId)

SET IDENTITY_INSERT Cafes OFF

SET IDENTITY_INSERT MenuItems ON

MERGE INTO MenuItems AS Target
USING (VALUES
    (1,  1, 'Hot Ham and Cheese',       'Black forest ham and swiss cheese served on a pretzel roll',                           8.00),    
    (2,  1, 'Turkey and Gouda',         'Oven roasted turkey with gouda cheese on cibatta',                                     9.00),
    (3,  1, 'Classic Club',             'Black forest ham, oven roasted turkey, New York sharp cheddar and bacon on sourdough', 10.50),
    (10,  2, 'Cheese Pizza',            'Classic cheese pizza',                                                    7.00),
    (11,  2, 'Pepperoni',               'Classic pepperoni pizza',                                                 8.00),
    (12,  2, 'Sausage and Mushroom',    'Classic suasage and mushroom',                                            8.00),
    (13,  2, 'Margherita',              'Basil and tomatoes',                                                      8.00),
    (14,  2, 'Seafood',                 'Shrimp and crab meat',                                                   11.00),
    (15,  2, 'Combination',             'Pepperoni, Sausage and mushroom',                                        10.00),
    (81,  8, 'Classic Hamburger',       'Hamburger',                                            10.00),
    (82,  8, 'Classic Cheeseburger',    'Cheeseburer',                                        10.00),
    (83,  8, 'Bacon Cheeseburger',      'Bacon Cheeseburger',                                        10.00),
    (84,  8, 'Mushroom and Swiss',      'Muchroom and swiss',                                        10.00)
)
AS Source (ItemId, CafeId, Name, Description, Price)
ON Target.ItemId = Source.ItemId
    WHEN MATCHED THEN
        UPDATE
		    SET
            CafeId = Source.CafeId,
			Name = Source.Name,
			Description = Source.Description,
			Price = Source.Price
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (ItemId, CafeId, Name, Description, Price)
        VALUES (ItemId, CafeId, Name, Description, Price);


DECLARE @nextMenuItemId INT;
SELECT @nextMenuItemId = (
        SELECT max(ItemId)
            FROM MenuItems
	) ;


DBCC CHECKIDENT (MenuItems, RESEED, @nextMenuItemId)

SET IDENTITY_INSERT MenuItems OFF

DECLARE @today DATE;
SET @today = GetDate()


INSERT INTO CafeReviews (CafeId, ReviewDate, ReviewerName, Rating, Comments) VALUES 
    (1, DATEADD(day, -14, @today), 'Kendra', 5, 'Very good sandwich'),
    (1, DATEADD(day, -10, @today), 'Scott', 5, 'So good I ate ordered a second one'),
    (1, DATEADD(day, -8, @today), 'Pine', 4, 'Pretty good but I have had better'),
    (1, DATEADD(day, -3, @today), 'Bill', 3, 'Too much mayo on my sandwich!');

INSERT INTO CafeReviews (CafeId, ReviewDate, ReviewerName, Rating, Comments) VALUES 
    (2, DATEADD(day, -23, @today), 'Barb', 5, 'This is my go to spot for lunch when on campus'),
    (2, DATEADD(day, -15, @today), 'Kraig', 5, 'Really liked the margherita pizza'),
    (2, DATEADD(day, -10, @today), 'David', 3, 'We''ve got way better pizza in Chicago'),
    (2, DATEADD(day, -6, @today), 'Steven', 5, 'Much better than what we have back in Scotland');

INSERT INTO CafeReviews (CafeId, ReviewDate, ReviewerName, Rating, Comments) VALUES 
    (2, DATEADD(day, -21, @today), 'Maggie', 4, 'Pretty good burger'),
    (2, DATEADD(day, -14, @today), 'Kyle', 5, 'The double is the only way to go'),
    (2, DATEADD(day, -9, @today), 'James', 3, 'They put mustard on my burger and I hate mustard'),
    (2, DATEADD(day, -2, @today), 'Cam', 3, 'We know how to make burgers in Kansas City.  We could teach you');


 