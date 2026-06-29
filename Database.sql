DROP DATABASE IF EXISTS DBPROJECT;
CREATE DATABASE DBPROJECT;
USE DBPROJECT;

-- Membership - normal entity
CREATE TABLE MembershipType (
    MembershipID INT PRIMARY KEY,                
    Type VARCHAR(255) NOT NULL,                   
    ExclusiveChefAvailable BOOLEAN              
);

-- CLIENT - Normal entity
CREATE TABLE Client (
    ClientID INT PRIMARY KEY,                    
    FirstName VARCHAR(150) NOT NULL,              
    LastName VARCHAR(150) NOT NULL,               
    Email VARCHAR(100) NOT NULL,                  
    Phone VARCHAR(12),                           
    Address VARCHAR(100),                                                    
    MembershipID INT,                             
    EventReminder BOOLEAN,                        -- additional feature
    FOREIGN KEY (MembershipID) REFERENCES MembershipType (MembershipID)  
);

-- Referral program - normal entity
CREATE TABLE ReferralProgram (
    ReferralID INT PRIMARY KEY,                    
    ClientID INT NOT NULL,                         
    ReferredClientID INT NOT NULL,                 
    ReferralDate DATE NOT NULL,                     
    ExclusiveChefAccess BOOLEAN,                   
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID), 
    FOREIGN KEY (ReferredClientID) REFERENCES Client (ClientID) 
);

-- instructor - normal entity
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,               
    FirstName VARCHAR(150) NOT NULL,            
    LastName VARCHAR(150) NOT NULL,             
    Specialty VARCHAR(50),                      
    Certification VARCHAR(100)                  
);

-- brand - normal entity
CREATE TABLE Brand (
    BrandID INT PRIMARY KEY,                    
    BrandName VARCHAR(100) NOT NULL              
);

-- workshop - normal entity
CREATE TABLE Workshop (
    WorkshopID INT PRIMARY KEY,                  
    WorkshopType VARCHAR(100) NOT NULL,         
    Date DATE NOT NULL,                           
    Capacity INT NOT NULL,                     
    InstructorID INT NOT NULL,                   
    DifficultyLevel VARCHAR(50),                 
    Price DECIMAL(10, 2),                       
    BrandID INT NULL,                            -- can be NULL if no brand cause its not compulsary
    FOREIGN KEY (InstructorID) REFERENCES Instructor (InstructorID), 
    FOREIGN KEY (BrandID) REFERENCES Brand (BrandID) ON DELETE SET NULL 
);

CREATE TABLE Seminar (
    SeminarID INT PRIMARY KEY,                  
    Activity VARCHAR(100) NOT NULL,         
    Date DATE NOT NULL,                       
    SpecialDeals VARCHAR(50),                
    Price DECIMAL(10, 2), 
    InstructorID INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructor (InstructorID)             
);

-- Equipment Table -normal Entity
CREATE TABLE Equipment (
    EquipID INT PRIMARY KEY,
    EquipmentName VARCHAR(255) NOT NULL,
    RentalFee DECIMAL(10, 2)
);    

CREATE TABLE Item (
	ItemID INT PRIMARY KEY,
    ItemType VARCHAR(50)
);
    
-- Merchandise Table - normal Entity
CREATE TABLE Merchandise (
    MerchandiseID INT PRIMARY KEY,
    MerchName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    LimitedEditionStock INT,
    ItemID INT,
    FOREIGN KEY (ItemID) REFERENCES Item (ItemID) 
);

-- package - normal entity
CREATE TABLE Package (
    PackageID INT PRIMARY KEY,
    PackageType VARCHAR(100) NOT NULL,
    SessionCount INT,
    Price DECIMAL(10, 2),
    ItemID INT,
    FOREIGN KEY (ItemID) REFERENCES Item (ItemID)
);

CREATE TABLE PointAllocation (
	PointAllocationID INT PRIMARY KEY,
    PointsWorth INT,
    ActivityID INT,
    ActivityType VARCHAR(50)
);
   
-- loyaltypoints - normal entity
CREATE TABLE LoyaltyPoint (
    TransactionID INT PRIMARY KEY,
    ClientID INT NOT NULL,
    PointsEarned INT,
    PointsRedeemed INT,
    PointsRemaining INT,
    ItemID INT,
    PointAllocationID INT,
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID),
	FOREIGN KEY (ItemID) REFERENCES Item (ItemID)
);

-- privatesession - normal entity
CREATE TABLE PrivateSession (
    SessionID INT PRIMARY KEY,
    ClientID INT NOT NULL,
    InstructorID INT NOT NULL,
    Date DATE NOT NULL,
    Activity VARCHAR(255),
    Price DECIMAL(10, 2),
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor (InstructorID)
);

-- feedback - normal entity
CREATE TABLE ClientFeedback (
    FeedbackID INT PRIMARY KEY,
    ClientID INT NOT NULL,
    Rating INT NOT NULL,
    Feedback TEXT,
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID)
);

-- attendance - associative entity for workshop and seminar
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    ClientID INT NOT NULL,
    EventID INT NOT NULL,            -- workshopID or seminarID
    EventType VARCHAR(50) NOT NULL, -- 'Workshop' or 'Seminar'
    AttendanceDate DATE NOT NULL,
    WorkshopID INT,
    SeminarID INT,
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID)
);

-- clientequipmentrental - associative entity
CREATE TABLE ClientEquipmentRental (
    RentalID INT PRIMARY KEY,
    ClientID INT NOT NULL,
    EquipID INT NOT NULL,
    RentalDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID),
    FOREIGN KEY (EquipID) REFERENCES Equipment (EquipID)
);

-- inserting values into tables
INSERT INTO MembershipType (MembershipID, Type, ExclusiveChefAvailable) -- 5 rows
VALUES
    (101, 'Individual Plan', FALSE),
    (204, 'Group Family Plan', FALSE),
    (305, 'Group Friends Plan', FALSE),
    (409, 'Group Corporate Plan', FALSE), 
    (512, 'Exclusive Chef', TRUE); -- Hidden, referral-only tier.
    
INSERT INTO Client (ClientID, FirstName, LastName, Email, Phone, Address, MembershipID, EventReminder) -- 35 rows
VALUES
    (1001, 'Ahmad', 'Ali', 'ahmad.ali@gmail.com', '0112345678', '123 Broadway Ave', 101, TRUE), -- Individual Plan
    (1002, 'Mei', 'Tan', 'mei.tan@gmail.com', '0123456789', '45 Park Ave', 101, FALSE), -- Individual Plan
    (1003, 'Rajesh', 'Nair', 'rajesh.nair@gmail.com', '0134567890', '88 5th Ave', 204, TRUE), -- Family Plan
    (1004, 'Emily', 'Jones', 'emily.jones@gmail.com', '0145678901', '22 Wall St', 204, FALSE), -- Family Plan
    (1005, 'Faridah', 'Yusuf', 'faridah.yusuf@gmail.com', '0156789012', '77 Madison Ave', 305, TRUE), -- Friends Plan
    (1006, 'Hiroshi', 'Yamamoto', 'hiroshi.yamamoto@gmail.com', '0167890123', '10 Times Square', 305, FALSE), -- Friends Plan
    (1007, 'Maria', 'Garcia', 'maria.garcia@gmail.com', '0178901234', '33 Liberty St', 409, TRUE), -- Corporate Plan
    (1008, 'Wong', 'Wei', 'wong.wei@gmail.com', '0189012345', '99 Lexington Ave', 409, FALSE), -- Corporate Plan
    (1009, 'Yusuf', 'Khan', 'yusuf.khan@gmail.com', '0190123456', '55 Central Park W', 512, TRUE), -- Exclusive Chef
    (1010, 'Aishah', 'Rahman', 'aishah.rahman@gmail.com', '0112345679', '100 42nd St', 101, FALSE), -- Individual Plan
    (1011, 'Chen', 'Wei', 'chen.wei@gmail.com', '0123456798', '56 Riverside Dr', 101, TRUE), -- Individual Plan
    (1012, 'Carlos', 'Santos', 'carlos.santos@gmail.com', '0134567980', '76 Amsterdam Ave', 204, FALSE), -- Family Plan
    (1013, 'Sophia', 'Kim', 'sophia.kim@gmail.com', '0145679801', '23 East Broadway', 204, TRUE), -- Family Plan
    (1014, 'Omar', 'Hassan', 'omar.hassan@gmail.com', '0156789013', '12 West End Ave', 305, TRUE), -- Friends Plan
    (1015, 'Aya', 'Kobayashi', 'aya.kobayashi@gmail.com', '0167890134', '78 Hudson St', 305, FALSE), -- Friends Plan
    (1016, 'Ethan', 'Brown', 'ethan.brown@gmail.com', '0178901345', '99 Fulton St', 409, TRUE), -- Corporate Plan
    (1017, 'Liam', 'Martinez', 'liam.martinez@gmail.com', '0189013456', '120 Battery Pl', 409, FALSE), -- Corporate Plan
    (1018, 'Fatima', 'Abdullah', 'fatima.abdullah@gmail.com', '0190123467', '60 Water St', 512, TRUE), -- Exclusive Chef
    (1019, 'Hassan', 'Ali', 'hassan.ali@gmail.com', '0112345789', '77 Bowery St', 101, FALSE), -- Individual Plan
    (1020, 'Amina', 'Khan', 'amina.khan@gmail.com', '0123457890', '30 Orchard St', 101, TRUE), -- Individual Plan
    (1021, 'Samuel', 'Johnson', 'samuel.johnson@gmail.com', '0134567891', '15 Eldridge St', 204, TRUE), -- Family Plan
    (1022, 'Nina', 'Petrov', 'nina.petrov@gmail.com', '0145678902', '99 Spring St', 204, FALSE), -- Family Plan
    (1023, 'Arjun', 'Kapoor', 'arjun.kapoor@gmail.com', '0156789014', '40 Canal St', 305, TRUE), -- Friends Plan
    (1024, 'Sakura', 'Takahashi', 'sakura.takahashi@gmail.com', '0167890125', '88 Broadway', 305, FALSE), -- Friends Plan
    (1025, 'Gabriel', 'Rodriguez', 'gabriel.rodriguez@gmail.com', '0178901236', '33 Prince St', 409, TRUE), -- Corporate Plan
    (1026, 'Lucas', 'Evans', 'lucas.evans@gmail.com', '0189012347', '120 Wall St', 409, FALSE), -- Corporate Plan
    (1027, 'Zara', 'Ahmed', 'zara.ahmed@gmail.com', '0190123458', '80 Broadway', 512, TRUE), -- Exclusive Chef
    (1028, 'Anna', 'Volkova', 'anna.volkova@gmail.com', '0112345670', '18 Chelsea St', 101, TRUE), -- Individual Plan
    (1029, 'Ahmed', 'Mahmood', 'ahmed.mahmood@gmail.com', '0123456781', '25 Astoria Blvd', 101, FALSE), -- Individual Plan
    (1030, 'Chang', 'Lee', 'chang.lee@gmail.com', '0134567892', '32 Queens Plaza', 204, TRUE), -- Family Plan
    (1031, 'Diana', 'Hernandez', 'diana.hernandez@gmail.com', '0145678903', '19 Lexington Ave', 204, FALSE), -- Family Plan
    (1032, 'Akira', 'Ito', 'akira.ito@gmail.com', '0156789015', '75 Canal St', 305, TRUE), -- Friends Plan
    (1033, 'Miguel', 'Torres', 'miguel.torres@gmail.com', '0167890126', '43 Mulberry St', 305, FALSE), -- Friends Plan
    (1034, 'Eva', 'Schmidt', 'eva.schmidt@gmail.com', '0178901347', '55 Pearl St', 409, TRUE), -- Corporate Plan
    (1035, 'Mohamed', 'Fahmy', 'mohamed.fahmy@gmail.com', '0189013458', '66 Franklin St', 512, TRUE), -- Exclusive Chef
    (1036, 'Ben', 'Warren', 'ben.warren@gmail.com', '0198827762', '77 Franklin St', NULL, FALSE),    -- client have no membership 
    (1037, 'Miranda', 'Bailey', 'mir.bailey@gmail.com', '0112213334', '97 Queens St', NULL, TRUE),
    (1038, 'Meridith', 'Grey', 'mer.grey@gmail.com', '0196574256', '12 Franklin Ave', NULL, FALSE),
    (1039, 'Derek', 'Shepherd', 'der.shep@gmail.com', '0165542311', '93 Astor St', NULL, TRUE),
    (1040, 'Amelia', 'Shepherd', 'amelia.shep@gmail.com', '0147861435', '5 Strawberry St', NULL, FALSE),
    (1041, 'Lucas', 'Adams', 'luke.adams@gmail.com', '0176518345', '53 Blueberry Ave', NULL, TRUE),
    (1042, 'Mika', 'Yasuda', 'mika.yas@gmail.com', '0287512862', '5 Strawberry St', NULL, FALSE),
    (1043, 'Jules', 'Millin', 'jules.mil@gmail.com', '0156226715', '20 Peral Blvd', NULL, FALSE),
    (1044, 'Travis', 'Montgomery', 'travis.mont@gmail.com', '0131245678', '5 Apple Ave', NULL, TRUE);
    
    
INSERT INTO ReferralProgram (ReferralID, ClientID, ReferredClientID, ReferralDate, ExclusiveChefAccess) -- 7 rows
VALUES
    (101, 1009, 1001, '2023-03-15', TRUE),  -- Exclusive Chef referred an Individual Plan client
    (102, 1018, 1012, '2022-06-20', TRUE),  -- Exclusive Chef referred a Family Plan client
    (103, 1027, 1020, '2023-05-05', TRUE),  -- Exclusive Chef referred an Individual Plan client
    (104, 1011, 1023, '2023-07-12', FALSE), -- Non-Exclusive Chef referred an Individual Plan client
    (105, 1014, 1028, '2023-04-25', FALSE), -- Non-Exclusive Chef referred an Individual Plan client
    (106, 1035, 1031, '2022-11-10', TRUE),  -- Exclusive Chef referred a Family Plan client 
    (107, 1011, 1034, '2023-09-19', FALSE); -- Non-Exclusive Chef referred a Family Plan client

INSERT INTO Instructor (InstructorID, FirstName, LastName, Specialty, Certification)
VALUES
    (301, 'Nathan', 'Grayson', 'Pastry', 'Certified Pastry Chef'),
    (302, 'Lena', 'Wells', 'Grilling', 'Certified Grill Master'),
    (303, 'Tariq', 'Abdul', 'Malaysian Cuisine', 'Certified Malaysian Culinary Specialist'),
    (304, 'Olivia', 'Moore', 'Cake Decorating', 'Professional Cake Decorator Certification'),
    (305, 'Aiden', 'Black', 'BBQ', 'BBQ Master Certification'),
    (306, 'Sophia', 'Knight', 'Vegan Cuisine', 'Plant-Based Chef Certification'),
    (307, 'Max', 'Evans', 'Breadmaking', 'Certified Artisan Bread Baker'),
    (308, 'Isabella', 'Griffith', 'French Pastry', 'Diplôme de Cuisine'),
    (309, 'Kai', 'Harrison', 'Sushi', 'Certified Sushi Chef'),
    (310, 'Chloe', 'Chang', 'Dim Sum', 'Certified Dim Sum Master'),
    (311, 'Ethan', 'Scott', 'Tandoor Cooking', 'Certified Tandoor Chef'),
    (312, 'Maya', 'Liu', 'Chinese Street Food', 'Certified Street Food Specialist'),
    (313, 'Rafael', 'Martinez', 'Spanish Tapas', 'Certified Spanish Culinary Expert'),
    (314, 'Leila', 'Davis', 'Middle Eastern Cooking', 'Certified Middle Eastern Chef'),
    (315, 'Amir', 'Fahad', 'Seafood', 'Seafood Specialist Certification');

INSERT INTO Brand (BrandID, BrandName)
VALUES
    (1, 'Gourmet Gurus'),              --  young professionals
    (2, 'Master Chef Club'),           -- designed for retirees and senior enthusiasts
    (3, 'All');  -- to enjoy both brands

INSERT INTO Workshop (WorkshopID, WorkshopType, Date, Capacity, InstructorID, DifficultyLevel, Price, BrandID) 
VALUES
    (201, 'Pastry', '2023-11-10', 18, 301, 'Easy', 50.00, 1), 
    (202, 'Grilling', '2023-12-05', 15, 302, 'Medium', 75.00, 2),  
    (203, 'Malaysian Cuisine', '2024-06-15', 20, 303, 'Advanced', 150.00, 3),   
    (204, 'Cake Decorating', '2024-07-01', 16, 304, 'Easy', 40.00, NULL), 
    (205, 'BBQ', '2024-08-10', 18, 305, 'Medium', 80.00, 1),  
    (206, 'Vegan Cuisine', '2024-07-18', 20, 306, 'Difficult', 120.00, 2), 
    (207, 'Breadmaking', '2024-06-22', 19, 307, 'Medium', 70.00, NULL),  
    (208, 'French Pastry', '2024-08-05', 15, 308, 'Advanced', 130.00, 3), 
    (209, 'Sushi Making', '2024-07-28', 17, 309, 'Difficult', 100.00, 1),  
    (210, 'Dim Sum', '2024-08-18', 20, 310, 'Medium', 90.00, 2),  
    (211, 'Tandoor Cooking', '2024-06-10', 20, 311, 'Advanced', 140.00, 3),  
    (212, 'Chinese Street Food', '2023-11-15', 18, 312, 'Easy', 60.00, 1),
    (213, 'Spanish Tapas', '2024-08-01', 16, 313, 'Medium', 85.00, 2),  
    (214, 'Middle Eastern Cooking', '2024-06-30', 18, 314, 'Difficult', 110.00, 3),     
    (215, 'Seafood Masterclass', '2024-07-25', 20, 315, 'Advanced', 160.00, NULL),  -- highest revenue
    (216, 'BBQ and Grilling', '2023-12-10', 18, 302, 'Medium', 85.00, 2),  
    (217, 'Vegan Pastry', '2024-05-25', 16, 306, 'Medium', 95.00, NULL),  
    (218, 'Italian Pasta', '2024-04-18', 17, 303, 'Medium', 85.00, 1),  
    (219, 'French Gourmet', '2024-03-22', 18, 308, 'Advanced', 150.00, 3),  
    (220, 'Dim Sum Extravaganza', '2024-06-28', 20, 310, 'Advanced', 120.00, 1),  
    (221, 'Street Food', '2024-06-12', 15, 312, 'Easy', 50.00, 2),  
    (222, 'Advanced BBQ', '2024-07-20', 18, 305, 'Advanced', 130.00, 2), 
    (223, 'Tandoori Fusion', '2024-08-15', 19, 311, 'Difficult', 140.00, 3),  
    (224, 'Baking for Beginners', '2024-05-30', 16, 307, 'Easy', 45.00, 1),  
    (225, 'Spanish Cooking', '2024-04-02', 18, 313, 'Medium', 80.00, NULL), 
    (226, 'Pasta Making', '2024-06-18', 17, 302, 'Medium', 75.00, 2),  
    (227, 'Mediterranean Specialties', '2024-05-10', 20, 314, 'Advanced', 130.00, 3),  
    (228, 'Culinary Arts Basics', '2022-12-01', 15, 301, 'Easy', 50.00, 1),  
    (229, 'Advanced Vegan Cooking', '2024-06-08', 18, 306, 'Difficult', 120.00, 2),  
    (230, 'Sushi Masterclass', '2024-06-20', 16, 309, 'Advanced', 140.00, 1),  
    (231, 'Baking & Desserts', '2024-07-05', 20, 308, 'Medium', 90.00, NULL),  
    (232, 'Gourmet Seafood', '2024-08-03', 19, 315, 'Advanced', 150.00, NULL),  
    (233, 'Sushi and Sashimi', '2022-09-05', 18, 309, 'Advanced', 110.00, 3), 
    (234, 'Baking Mastery', '2022-11-20', 20, 307, 'Difficult', 120.00, NULL), 
    (235, 'Gourmet BBQ', '2022-08-25', 17, 305, 'Advanced', 140.00, 2),  
    (236, 'Dim Sum Masterclass', '2022-07-10', 16, 310, 'Advanced', 130.00, 3); 

-- Seminars in 2022
INSERT INTO Seminar (SeminarID, Activity, Date, SpecialDeals, Price, InstructorID)      -- make an associative entity
VALUES
    (401, 'Cooking Demonstrations', '2022-06-15', 'Exclusive Chef members', 100.00, 301),
    (402, 'Ingredient Testing', '2022-07-01', 'Individual & Group members', 80.00, 302),
    (403, 'Recipes Analysis', '2022-07-15', NULL, 60.00, 305),
    (404, 'Culinary Education', '2022-08-10', 'Exclusive Chef members', 120.00, 303),
    (405, 'Skills Workshop', '2022-09-05', 'Individual & Group members', 90.00, 304),
    (406, 'Food Presentations', '2022-10-20', NULL, 75.00, 306),
    (407, 'Pastry Making', '2022-11-15', 'Exclusive Chef members', 110.00, 307),
    (408, 'Cooking Demonstrations', '2022-12-01', 'Individual & Group members', 85.00, 308),

-- 2023
    (409, 'Cooking Demonstrations', '2023-01-10', 'Exclusive Chef members', 100.00, 309),
    (410, 'Ingredient Testing', '2023-02-12', 'Individual & Group members', 80.00, 310),
    (411, 'Recipes Analysis', '2023-03-01', NULL, 65.00, 312),
    (412, 'Culinary Education', '2023-04-18', 'Exclusive Chef members', 120.00, 311),
    (413, 'Skills Workshop', '2023-05-05', 'Individual & Group members', 95.00, 313),
    (414, 'Food Presentations', '2023-06-12', NULL, 75.00, 314),
    (415, 'Grilling Techniques', '2023-07-20', 'Exclusive Chef members', 115.00, 315),
    (416, 'Cooking Demonstrations', '2023-08-01', 'Individual & Group members', 85.00, 301),

-- 2024
    (417, 'Cooking Demonstrations', '2024-05-12', 'Exclusive Chef members', 105.00, 302),
    (418, 'Ingredient Testing', '2024-07-10', 'Individual & Group members', 90.00, 303),
    (419, 'Recipes Analysis', '2024-08-15', NULL, 70.00, 304),
    (420, 'Culinary Education', '2024-06-25', 'Exclusive Chef members', 125.00, 305),
    (421, 'Skills Workshop', '2024-04-20', 'Individual & Group members', 95.00, 306),
    (422, 'Food Presentations', '2024-03-05', NULL, 80.00, 310),
    (423, 'Pastry Making', '2024-01-10', 'Exclusive Chef members', 110.00, 312),
    (424, 'Cooking Demonstrations', '2024-07-29', 'Individual & Group members', 85.00, 315);

INSERT INTO Equipment (EquipID, EquipmentName, RentalFee)
VALUES 
    (01, 'Knife', 15.00),
    (02, 'Board', 5.00),
    (03, 'Bowl', 8.50),
    (04, 'Cups', 4.00),
    (05, 'Pan', 12.00),
    (06, 'Baking Sheet', 6.50),
    (07, 'Blender', 20.00),
    (08, 'Mixer', 30.00),
    (09, 'Pin', 3.50),
    (010, 'Saucepan', 10.00),
    (011, 'Wok', 18.00),
    (012, 'Grater', 4.50),
    (013, 'Tongs', 2.50),
    (014, 'Shears', 7.00),
    (015, 'Colander', 5.50),
    (016, 'Skillet', 14.00),
    (017, 'Strainer', 6.00),
    (018, 'Ladle', 3.00),
    (019, 'Whisk', 3.50),
    (020, 'Peeler', 2.00);
 
 INSERT INTO Item (ItemID, ItemType) VALUES
	(5001, 'Apron'),
    (5002, 'Cookbook'),
    (5003, 'Mug'),
    (5004, 'Kitchen Towel'),
    (5006, 'Chef Hat'),
    (5007, 'Notebook'),
    (5008, 'Spatula'),
    (5009, 'Bottle'),
    (5010, 'Keychain'),
    (5011, 'KnifeSet'),
    (6001, 'Beginner Package'),
    (6002, 'Intermediate Package'),
    (6003, 'Advanced Package'),
    (6004, 'Private Sessions'),
    (6005, 'Unlimited Workshops');
    
INSERT INTO Merchandise (MerchandiseID, MerchName, Price, Stock, LimitedEditionStock, ItemID)
VALUES 
    (501, 'Apron', 20.00, 50, 10, 5001),
    (502, 'Cookbook', 30.00, 30, NULL, 5002),
    (503, 'Mug', 12.50, 60, NULL, 5003),
    (504, 'Kitchen Towel', 8.00, 100, NULL, 5004),
    (506, 'Chef Hat', 15.00, 40, 5, 5006),
    (507, 'Notebook', 10.00, 80, NULL, 5007),
    (508, 'Spatula', 7.50, 70, 10, 5008),
    (509, 'Bottle', 25.00, 50, NULL, 5009),
    (510, 'Keychain', 5.00, 120, NULL, 5010),
    (511, 'KnifeSet', 60.00, 15, NULL, 5011);

INSERT INTO Package (PackageID, PackageType, SessionCount, Price, ItemID)    -- session count includes workshop/private sessions
VALUES
    (601, 'Beginner Package', 3, 75.00, 6001),
    (602, 'Intermediate Package', 5, 120.00, 6002),
    (603, 'Advanced Package', 8, 180.00, 6003),
    (604, 'Private Sessions', 10, 250.00, 6004),
    (605, 'Unlimited Workshops', NULL, 500.00, 6005);
    
INSERT INTO LoyaltyPoint (TransactionID, ClientID, PointsEarned, PointsRedeemed, PointsRemaining, ItemID)
VALUES
    (701, 1005, 120, 20, 100, 5001),
    (702, 1012, 140, 10, 130, 5007),
    (703, 1007, 100, 10, 90, 5007),
    (704, 1025, 80, 60, 20, 5011),
    (705, 1018, 100, 5, 95, 5010),
    (706, 1030, 160, 120, 40, 6002),
    (707, 1015, 160, 75, 85, 6001),
    (708, 1003, 120, 120, 0, 6002),
    (709, 1022, 100, 15, 85, 5006),
    (710, 1010, 180, 30, 150, 5002),
    (711, 1028, 140, 10, 130, 5007),
    (712, 1009, 40, 5, 35, 5010),
    (713, 1033, 120, 25, 95, 5009),
    (714, 1017, 100, 20, 80, 5001),
    (715, 1020, 140, 30, 110, 5002),
    (716, 1001, 180, 30, 150, 5002),
    (717, 1035, 140, 60, 80, 5011),
    (718, 1008, 120, 5, 115, 5010),
    (719, 1019, 120, 60, 60, 5011),
    (720, 1027, 140, 120, 20, 6002),
    (721, 1002, 110, 75, 35, 6001),
    (722, 1004, 90, 60, 30, 5011),
    (723, 1006, 90, 10, 80, 5007),
    (724, 1011, 130, 15, 115, 5006),
    (725, 1014, 130, 30, 100, 5002),
    (726, 1016, 90, 10, 80, 5007),
    (727, 1013, 130, 120, 10, 6002),
    (728, 1024, 90, 25, 65, 5009),
    (729, 1021, 90, 20, 70, 5001),
    (730, 1023, 70, 30, 40, 5002),
    (731, 1026, 90, 75, 15, 6001),
    (732, 1029, 30, 10, 20, 5007),
    (733, 1031, 70, 5, 65, 5010),
    (734, 1034, 70, 60, 10, 5011),
    (735, 1032, 50, 30, 20, 5002);
    
INSERT INTO PrivateSession (SessionID, ClientID, InstructorID, Date, Activity, Price)
VALUES
    (801, 1005, 301, '2024-11-01', 'Baking Basics', 120.00),
    (802, 1012, 303, '2024-11-05', 'Sushi Making', 150.00),
    (803, 1007, 305, '2024-10-15', 'Italian Cuisine', 200.00),
    (804, 1025, 307, '2024-09-20', 'Knife Skills', 100.00),
    (805, 1018, 309, '2024-11-10', 'Pastry Workshop', 170.00),
    (806, 1030, 302, '2024-08-05', 'Grilling Techniques', 110.00),
    (807, 1015, 310, '2024-07-18', 'Seafood Specialties', 130.00),
    (808, 1003, 314, '2024-06-25', 'Plant-Based Cooking', 90.00),
    (809, 1022, 313, '2024-09-12', 'Dessert Plating', 140.00),
    (810, 1010, 304, '2024-10-02', 'French Pastries', 180.00),
    (811, 1028, 311, '2024-07-01', 'Pasta Perfection', 160.00),
    (812, 1009, 315, '2024-08-20', 'Advanced Sauces', 175.00),
    (813, 1033, 301, '2024-06-30', 'Bread Baking', 80.00),
    (814, 1017, 306, '2024-09-05', 'Culinary Basics', 50.00),
    (815, 1020, 308, '2024-10-25', 'Mediterranean Feast', 150.00),
    (816, 1001, 303, '2024-08-10', 'Street Food', 70.00),
    (817, 1035, 304, '2024-07-22', 'Sushi Making', 150.00),
    (818, 1008, 305, '2024-09-30', 'Vegan Desserts', 120.00),
    (819, 1019, 310, '2024-10-12', 'Dim Sum Delights', 200.00),
    (820, 1027, 311, '2024-08-18', 'Gourmet Sauces', 180.00);

INSERT INTO ClientFeedback (FeedbackID, ClientID, Rating, Feedback)
VALUES
    (901, 1005, 5, 'Amazing experience! Learned a lot.'),
    (902, 1012, 4, 'Great workshop, but room was a bit crowded.'),
    (903, 1007, 5, 'The instructor was fantastic and very patient.'),
    (904, 1025, 3, 'It was okay, but the equipment was slightly worn.'),
    (905, 1018, 4, 'Fun session, but wish it was longer.'),
    (906, 1030, 5, 'The private session exceeded my expectations!'),
    (907, 1015, 2, 'Not enough hands-on time during the workshop.'),
    (908, 1003, 4, 'Good experience overall. Would recommend.'),
    (909, 1022, 3, 'The speaker was knowledgeable, but the pace was too fast.'),
    (910, 1010, 5, 'Loved the sushi-making session!'),
    (911, 1028, 4, 'Well-organized workshop. Great instructor.'),
    (912, 1009, 5, 'Fantastic pastry session!'),
    (913, 1033, 2, 'The session felt rushed and poorly planned.'),
    (914, 1017, 5, 'The hands-on approach was very effective.'),
    (915, 1020, 3, 'The session was decent but lacked advanced tips.'),
    (916, 1001, 4, 'The seminar was very informative. Would attend again.'),
    (917, 1035, 5, 'Best culinary workshop I have attended!'),
    (918, 1008, 3, 'The tools provided were not in great condition.'),
    (919, 1019, 4, 'Great instructor but the session was too short.'),
    (920, 1027, 5, 'The dessert plating session was amazing!');

INSERT INTO Attendance (AttendanceID, ClientID, EventID, EventType, AttendanceDate) VALUES
    (1101, 1001, 417, 'Seminar', '2024-05-12'),  -- May Seminar
    (1102, 1020, 417, 'Seminar', '2024-05-12'),
    (1103, 1044, 417, 'Seminar', '2024-05-12'),
    (1104, 1030, 418, 'Seminar', '2024-07-10'),
    (1105, 1023, 418, 'Seminar', '2024-07-10'),
    (1106, 1042, 418, 'Seminar', '2024-07-10'),
    (1107, 1003, 419, 'Seminar', '2024-08-15'),
    (1108, 1043, 419, 'Seminar', '2024-08-15'),
    (1109, 1026, 419, 'Seminar', '2024-08-15'),
    (1110, 1032, 420, 'Seminar', '2024-06-25'),
    (1111, 1019, 420, 'Seminar', '2024-06-25'),
    (1112, 1017, 420, 'Seminar', '2024-06-25'),
    (1113, 1005, 421, 'Seminar', '2024-04-20'), -- April Seminar
    (1114, 1024, 421, 'Seminar', '2024-04-20'),
    (1115, 1027, 421, 'Seminar', '2024-04-20'),
    (1116, 1016, 422, 'Seminar', '2024-03-05'), -- March Seminar
    (1117, 1006, 422, 'Seminar', '2024-03-05'), 
    (1118, 1021, 422, 'Seminar', '2024-03-05'), 
    (1119, 1007, 423, 'Seminar', '2024-01-10'),  -- January Seminar
    (1120, 1018, 423, 'Seminar', '2024-01-10'),
    (1121, 1022, 423, 'Seminar', '2024-01-10'),
    (1122, 1008, 424, 'Seminar', '2024-07-29'),
    (1123, 1025, 424, 'Seminar', '2024-07-29'),
    (1124, 1028, 424, 'Seminar', '2024-07-29'),
    (1125, 1010, 417, 'Seminar', '2024-05-12'),
    (1126, 1002, 417, 'Seminar', '2024-05-12'),
    (1127, 1035, 417, 'Seminar', '2024-05-12'),
    (1128, 1011, 418, 'Seminar', '2024-07-10'),
    (1129, 1009, 418, 'Seminar', '2024-07-10'),
    (1130, 1033, 418, 'Seminar', '2024-07-10'),
    (1131, 1012, 419, 'Seminar', '2024-08-15'),
    (1132, 1034, 419, 'Seminar', '2024-08-15'),
    (1133, 1029, 419, 'Seminar', '2024-08-15'),
    (1134, 1013, 420, 'Seminar', '2024-06-25'),
    (1135, 1031, 420, 'Seminar', '2024-06-25'),
    (1136, 1004, 420, 'Seminar', '2024-06-25'),
    (1137, 1014, 421, 'Seminar', '2024-04-20'),
    (1138, 1004, 421, 'Seminar', '2024-04-20'),
    (1139, 1025, 421, 'Seminar', '2024-04-20'),
    (1140, 1015, 422, 'Seminar', '2024-03-05'),
    (1141, 1042, 422, 'Seminar', '2024-03-05'),
    (1142, 1032, 422, 'Seminar', '2024-03-05'),
    (1143, 1036, 417, 'Seminar', '2024-05-12'),
	(1144, 1003, 417, 'Seminar', '2024-05-12'),
	(1145, 1016, 417, 'Seminar', '2024-05-12'),
    (1146, 1037, 418, 'Seminar', '2024-07-10'),
    (1147, 1027, 418, 'Seminar', '2024-07-10'),
    (1148, 1044, 418, 'Seminar', '2024-07-10'),
    (1149, 1038, 419, 'Seminar', '2024-08-15'),
    (1150, 1033, 419, 'Seminar', '2024-08-15'),
    (1151, 1011, 419, 'Seminar', '2024-08-15'),
    (1152, 1039, 420, 'Seminar', '2024-06-25'),
    (1153, 1009, 420, 'Seminar', '2024-06-25'),
    (1154, 1012, 420, 'Seminar', '2024-06-25'),
    (1155, 1040, 423, 'Seminar', '2024-01-10'),
    (1156, 1002, 423, 'Seminar', '2024-01-10'),
    (1157, 1023, 423, 'Seminar', '2024-01-10'),
    (1158, 1041, 424, 'Seminar', '2024-07-29'), 
    (1159, 1006, 424, 'Seminar', '2024-07-29'), 
    (1160, 1020, 424, 'Seminar', '2024-07-29'), 
    
    -- workshop
    (1161, 1001, 214, 'Workshop', '2024-06-30'),
    (1162, 1002, 215, 'Workshop', '2024-07-25'),
    (1163, 1003, 216, 'Workshop', '2024-07-18'),
    (1164, 1004, 217, 'Workshop', '2024-05-25'),
    (1165, 1005, 218, 'Workshop', '2024-04-18'),  -- April Workshop
    (1166, 1006, 219, 'Workshop', '2024-03-22'),  -- March Workshop
    (1167, 1007, 220, 'Workshop', '2024-06-28'),
    (1168, 1008, 221, 'Workshop', '2024-06-12'),
    (1169, 1010, 222, 'Workshop', '2024-07-20'),
    (1170, 1011, 223, 'Workshop', '2024-08-15'),
    (1171, 1012, 224, 'Workshop', '2024-05-30'),
    (1172, 1013, 225, 'Workshop', '2024-04-02'),
    (1173, 1014, 226, 'Workshop', '2024-06-18'),
    (1174, 1015, 227, 'Workshop', '2024-05-10'),
    (1175, 1011, 214, 'Workshop', '2024-06-30'),
    (1176, 1001, 215, 'Workshop', '2024-07-25'),
    (1177, 1027, 216, 'Workshop', '2024-07-18'),
    (1178, 1023, 217, 'Workshop', '2024-05-25'),
    (1179, 1015, 218, 'Workshop', '2024-04-18'),
    (1180, 1003, 219, 'Workshop', '2024-03-22'),
    (1181, 1005, 215, 'Workshop', '2024-07-25'),
    (1182, 1020, 220, 'Workshop', '2024-06-28'),
    (1183, 1010, 221, 'Workshop', '2024-06-12'),
    (1184, 1021, 214, 'Workshop', '2024-06-30'),
    (1185, 1024, 214, 'Workshop', '2024-06-30'),
    (1186, 1012, 214, 'Workshop', '2024-06-30'),
    (1187, 1017, 214, 'Workshop', '2024-06-30'),
    (1188, 1031, 215, 'Workshop', '2024-07-25'),
    (1189, 1033, 216, 'Workshop', '2024-07-18'),
    (1190, 1032, 216, 'Workshop', '2024-07-18'),
    (1191, 1034, 216, 'Workshop', '2024-07-18'),
    (1192, 1010, 216, 'Workshop', '2024-07-18'),
    (1193, 1012, 216, 'Workshop', '2024-07-18'),
    (1194, 1021, 216, 'Workshop', '2024-07-18'),
    (1195, 1024, 215, 'Workshop', '2024-07-25'),
    (1196, 1014, 215, 'Workshop', '2024-07-25'),
    (1197, 1034, 215, 'Workshop', '2024-07-25'),
    (1198, 1001, 217, 'Workshop', '2024-05-25'),
    (1199, 1026, 217, 'Workshop', '2024-05-25'),
    (1200, 1013, 217, 'Workshop', '2024-05-25'),
    (1201, 1002, 217, 'Workshop', '2024-05-25'),
    (1202, 1001, 218, 'Workshop', '2024-04-18'),
    (1203, 1025, 218, 'Workshop', '2024-04-18'),
    (1204, 1014, 218, 'Workshop', '2024-04-18'),
    (1205, 1035, 218, 'Workshop', '2024-04-18'),
    (1206, 1019, 218, 'Workshop', '2024-04-18'),
    (1207, 1026, 218, 'Workshop', '2024-04-18'),
    (1208, 1017, 219, 'Workshop', '2024-03-22'),
    (1209, 1016, 219, 'Workshop', '2024-03-22'),
    (1210, 1017, 220, 'Workshop', '2024-06-28'),
    (1211, 1024, 220, 'Workshop', '2024-06-28'),
    (1212, 1022, 220, 'Workshop', '2024-06-28'),
    (1213, 1018, 221, 'Workshop', '2024-06-12'),
    (1214, 1028, 221, 'Workshop', '2024-06-12'),
    (1215, 1002, 221, 'Workshop', '2024-06-12'),
    (1216, 1006, 221, 'Workshop', '2024-06-12'),
    (1217, 1013, 222, 'Workshop', '2024-07-20'),
    (1218, 1015, 222, 'Workshop', '2024-07-20'),
    (1219, 1019, 222, 'Workshop', '2024-07-20'),
    (1230, 1020, 222, 'Workshop', '2024-07-20'),
    (1231, 1021, 223, 'Workshop', '2024-08-15'),
    (1232, 1015, 223, 'Workshop', '2024-08-15'),
    (1233, 1031, 223, 'Workshop', '2024-08-15'),
    (1234, 1014, 224, 'Workshop', '2024-05-30'),
    (1235, 1022, 224, 'Workshop', '2024-05-30'),
    (1236, 1023, 225, 'Workshop', '2024-04-02'),
    (1237, 1018, 225, 'Workshop', '2024-04-02'),
    (1238, 1001, 225, 'Workshop', '2024-04-02'),
    (1239, 1030, 225, 'Workshop', '2024-04-02'),
    (1240, 1012, 226, 'Workshop', '2024-06-18'),
    (1241, 1010, 226, 'Workshop', '2024-06-18'),
    (1242, 1024, 226, 'Workshop', '2024-06-18'),
    (1243, 1025, 227, 'Workshop', '2024-05-10'),
    (1244, 1005, 227, 'Workshop', '2024-05-10'),
    (1245, 1034, 227, 'Workshop', '2024-05-10'),
    (1246, 1030, 227, 'Workshop', '2024-05-10'),
    (1247, 1011, 228, 'Workshop', '2022-12-01'),
    (1248, 1001, 228, 'Workshop', '2022-12-01'),
    (1249, 1014, 228, 'Workshop', '2022-12-01'),
    (1250, 1010, 229, 'Workshop', '2024-06-08'),
    (1251, 1011, 229, 'Workshop', '2024-06-08'),
    (1252, 1006, 229, 'Workshop', '2024-06-08'),
    (1253, 1008, 229, 'Workshop', '2024-06-08'),
    (1254, 1033, 229, 'Workshop', '2024-06-08'),
    (1255, 1028, 229, 'Workshop', '2024-06-08'),
    (1256, 1004, 230, 'Workshop', '2024-06-20'),
    (1257, 1002, 230, 'Workshop', '2024-06-20'),
    (1258, 1032, 230, 'Workshop', '2024-06-20'),
    (1259, 1023, 230, 'Workshop', '2024-06-20'),
    (1260, 1029, 230, 'Workshop', '2024-06-20'),
    (1261, 1010, 230, 'Workshop', '2024-06-20'),
    (1262, 1003, 231, 'Workshop', '2024-07-05'),
    (1263, 1004, 231, 'Workshop', '2024-07-05'),
    (1264, 1010, 232, 'Workshop', '2024-08-03'),
    (1265, 1013, 232, 'Workshop', '2024-08-03'),
    (1266, 1016, 232, 'Workshop', '2024-08-03'),
    (1267, 1019, 232, 'Workshop', '2024-08-03'),
    (1268, 1022, 232, 'Workshop', '2024-08-03'),
    (1269, 1003, 233, 'Workshop', '2022-09-05'),
    (1270, 1005, 233, 'Workshop', '2022-09-05'),
    (1271, 1007, 234, 'Workshop', '2022-11-20'),
    (1272, 1008, 234, 'Workshop', '2022-11-20'),
    (1273, 1013, 234, 'Workshop', '2022-11-20'),
    (1274, 1019, 234, 'Workshop', '2022-11-20'),
    (1275, 1007, 235, 'Workshop', '2022-08-25'),
    (1276, 1001, 235, 'Workshop', '2022-08-25'),
    (1277, 1002, 236, 'Workshop', '2022-07-10'),
    (1278, 1004, 236, 'Workshop', '2022-07-10'),
    (1279, 1016, 236, 'Workshop', '2022-07-10'),
    (1280, 1008, 201, 'Workshop', '2023-11-10'), --
    (1281, 1011, 201, 'Workshop', '2023-11-10'),
    (1282, 1014, 201, 'Workshop', '2023-11-10'),
    (1283, 1015, 202, 'Workshop', '2023-12-05'),
    (1284, 1016, 202, 'Workshop', '2023-12-05'),
    (1285, 1020, 202, 'Workshop', '2023-12-05'),
    (1286, 1020, 203, 'Workshop', '2024-06-15'),
    (1287, 1021, 203, 'Workshop', '2024-06-15'),
    (1288, 1026, 204, 'Workshop', '2024-07-01'),
    (1289, 1027, 204, 'Workshop', '2024-07-01'),
    (1290, 1027, 205, 'Workshop', '2024-08-10'),
    (1291, 1028, 205, 'Workshop', '2024-08-10'),
    (1292, 1030, 205, 'Workshop', '2024-08-10'),
    (1293, 1035, 205, 'Workshop', '2024-08-10'),
    (1294, 1030, 206, 'Workshop', '2024-07-18'),
    (1295, 1035, 206, 'Workshop', '2024-07-18'),
    (1296, 1033, 207, 'Workshop', '2024-06-22'),
    (1297, 1028, 207, 'Workshop', '2024-06-22'),
    (1298, 1020, 208, 'Workshop', '2024-08-05'),
    (1299, 1026, 208, 'Workshop', '2024-08-05'),
    (1300, 1027, 208, 'Workshop', '2024-08-05'),
    (1301, 1030, 209, 'Workshop', '2024-07-28'),
    (1302, 1035, 209, 'Workshop', '2024-07-28'),
    (1303, 1006, 210, 'Workshop', '2024-08-18'),
    (1304, 1011, 210, 'Workshop', '2024-08-18'),
    (1305, 1015, 211, 'Workshop', '2024-06-10'),
    (1306, 1013, 211, 'Workshop', '2024-06-10'),
    (1307, 1012, 211, 'Workshop', '2024-06-10'),
    (1308, 1018, 212, 'Workshop', '2023-11-15'),
    (1309, 1033, 212, 'Workshop', '2023-11-15'),
    (1310, 1035, 213, 'Workshop', '2024-08-01'),
    (1311, 1030, 213, 'Workshop', '2024-08-01'),
    (1312, 1031, 213, 'Workshop', '2024-08-01'),
    (1313, 1028, 213, 'Workshop', '2024-08-01'),
    (1314, 1027, 213, 'Workshop', '2024-08-01');

    -- Example of equipment rental assignments for clients (only 1001 to 1035)
INSERT INTO ClientEquipmentRental (RentalID, ClientID, EquipID, RentalDate, ReturnDate) VALUES
    (1201, 1001, 01, '2024-06-15', '2024-06-17'), 
    (1202, 1002, 02, '2024-06-18', '2024-06-20'),
    (1203, 1003, 03, '2024-06-25', '2024-06-28'),
    (1204, 1004, 04, '2024-07-10', '2024-07-12'),
    (1205, 1005, 05, '2024-07-25', '2024-07-27'),
    (1206, 1006, 06, '2024-06-30', '2024-07-02'),
    (1207, 1007, 07, '2024-07-18', '2024-07-20'),
    (1208, 1008, 08, '2024-07-01', '2024-07-03'),
    (1209, 1009, 09, '2024-06-28', '2024-07-01'),
    (1210, 1010, 10, '2024-06-12', '2024-06-15'),
    (1211, 1011, 11, '2024-07-20', '2024-07-22'),
    (1212, 1012, 12, '2024-08-01', '2024-08-03'),
    (1213, 1013, 13, '2024-07-18', '2024-07-20'),
    (1214, 1014, 14, '2024-07-05', '2024-07-07'),
    (1215, 1015, 15, '2024-06-22', '2024-06-24'),
    (1216, 1016, 16, '2024-06-25', '2024-06-27'),
    (1217, 1017, 17, '2024-07-05', '2024-07-07'),
    (1218, 1018, 18, '2024-08-05', '2024-08-07'),
    (1219, 1019, 19, '2024-06-15', '2024-06-17'),
    (1220, 1020, 20, '2024-06-30', '2024-07-02'),
    (1221, 1021, 01, '2024-06-12', '2024-06-14'),
    (1222, 1022, 02, '2024-07-18', '2024-07-20'),
    (1223, 1023, 03, '2024-08-10', '2024-08-12'),
    (1224, 1024, 04, '2024-06-28', '2024-07-01'),
    (1225, 1025, 05, '2024-06-20', '2024-06-22'),
    (1226, 1026, 06, '2024-06-25', '2024-06-27'),
    (1227, 1027, 07, '2024-08-01', '2024-08-03'),
    (1228, 1028, 08, '2024-07-05', '2024-07-07'),
    (1229, 1029, 09, '2024-06-12', '2024-06-14'),
    (1230, 1030, 10, '2024-06-28', '2024-07-01'),
    (1231, 1031, 11, '2024-07-10', '2024-07-12'),
    (1232, 1032, 12, '2024-07-20', '2024-07-22'),
    (1233, 1033, 13, '2024-08-05', '2024-08-07'),
    (1234, 1034, 14, '2024-06-25', '2024-06-27'),
    (1235, 1035, 15, '2024-07-10', '2024-07-12');
    
    

INSERT INTO PointAllocation (PointAllocationID, PointsWorth, ActivityID, ActivityType) VALUES
	(9001, 20, 201, 'Workshop'), 
    (9002, 20, 202, 'Workshop'),  
    (9003, 20, 203, 'Workshop'),   
    (9004, 20, 204, 'Workshop'), 
    (9005, 20, 205, 'Workshop'),  
    (9006, 20, 206, 'Workshop'), 
    (9007, 20, 207, 'Workshop'),  
    (9008, 20, 208, 'Workshop'), 
    (9009, 20, 209, 'Workshop'),  
    (9010, 20, 210, 'Workshop'),  
    (9011, 20, 211, 'Workshop'),  
    (9012, 20, 212, 'Workshop'),
    (9013, 20, 213, 'Workshop'),  
    (9014, 20, 214, 'Workshop'),     
    (9015, 20, 215, 'Workshop'),  
    (9016, 20, 216, 'Workshop'),  
    (9017, 20, 217, 'Workshop'), 
    (9018, 20, 218, 'Workshop'),  
    (9019, 20, 219, 'Workshop'),   
    (9020, 20, 220, 'Workshop'), 
    (9021, 20, 221, 'Workshop'),  
    (9022, 20, 222, 'Workshop'), 
    (9023, 20, 223, 'Workshop'),  
    (9024, 20, 224, 'Workshop'), 
    (9025, 20, 225, 'Workshop'),  
    (9026, 20, 226, 'Workshop'),  
    (9027, 20, 227, 'Workshop'),  
    (9028, 20, 228, 'Workshop'),
    (9029, 20, 229, 'Workshop'),  
    (9030, 20, 230, 'Workshop'),     
    (9031, 20, 231, 'Workshop'),  
    (9032, 20, 232, 'Workshop'),
    (9033, 20, 233, 'Workshop'),  
    (9034, 20, 234, 'Workshop'),     
    (9035, 20, 235, 'Workshop'),  
    (9036, 20, 236, 'Workshop'),
    (9037, 10, 1201, 'Rental'), 
    (9038, 10, 1202, 'Rental'),  
    (9039, 10, 1203, 'Rental'),   
    (9040, 10, 1204, 'Rental'), 
    (9041, 10, 1205, 'Rental'),  
    (9042, 10, 1206, 'Rental'), 
    (9043, 10, 1207, 'Rental'),  
    (9044, 10, 1208, 'Rental'), 
    (9045, 10, 1209, 'Rental'),  
    (9046, 10, 1210, 'Rental'),  
    (9047, 10, 1211, 'Rental'),  
    (9048, 10, 1212, 'Rental'),
    (9049, 10, 1213, 'Rental'),  
    (9050, 10, 1214, 'Rental'),     
    (9051, 10, 1215, 'Rental'),  
    (9052, 10, 1216, 'Rental'),  
    (9053, 10, 1217, 'Rental'), 
    (9054, 10, 1218, 'Rental'),  
    (9055, 10, 1219, 'Rental'),   
    (9056, 10, 1220, 'Rental'), 
    (9057, 10, 1221, 'Rental'),  
    (9058, 10, 1222, 'Rental'), 
    (9059, 10, 1223, 'Rental'),  
    (9060, 10, 1224, 'Rental'), 
    (9061, 10, 1225, 'Rental'),  
    (9062, 10, 1226, 'Rental'),  
    (9063, 10, 1227, 'Rental'),  
    (9064, 10, 1228, 'Rental'),
    (9065, 10, 1229, 'Rental'),  
    (9066, 10, 1230, 'Rental'),     
    (9067, 10, 1231, 'Rental'),  
    (9068, 10, 1232, 'Rental'),
    (9069, 10, 1233, 'Rental'),  
    (9070, 10, 1234, 'Rental'),     
    (9071, 10, 1235, 'Rental'),
    (9072, 30, 801, 'PrivateSession'), 
    (9073, 30, 802, 'PrivateSession'),  
    (9074, 30, 803, 'PrivateSession'),   
    (9075, 30, 804, 'PrivateSession'), 
    (9076, 30, 805, 'PrivateSession'),  
    (9077, 30, 806, 'PrivateSession'), 
    (9078, 30, 807, 'PrivateSession'),  
    (9079, 30, 808, 'PrivateSession'), 
    (9080, 30, 809, 'PrivateSession'),  
    (9081, 30, 810, 'PrivateSession'),  
    (9082, 30, 811, 'PrivateSession'),  
    (9083, 30, 812, 'PrivateSession'),
    (9084, 30, 813, 'PrivateSession'),  
    (9085, 30, 814, 'PrivateSession'),     
    (9086, 30, 815, 'PrivateSession'),  
    (9087, 30, 816, 'PrivateSession'),  
    (9088, 30, 817, 'PrivateSession'), 
    (9089, 30, 818, 'PrivateSession'),  
    (9090, 30, 819, 'PrivateSession'),   
    (9091, 30, 820, 'PrivateSession'); 

    -- insert values for attendance table and the rest
    -- crete associative table for seminar 
    -- part c reports

-- No 4 
WITH WorkshopRevenue AS (
    SELECT 
        Workshop.WorkshopID, 
        Workshop.WorkshopType, 
        Workshop.Price, 
        COUNT(Attendance.AttendanceDate) AS TotalRegistered,
        COUNT(Attendance.AttendanceDate) * Workshop.Price AS Revenue
    FROM Workshop
    JOIN Attendance ON Workshop.WorkshopID = Attendance.EventID
    GROUP BY Workshop.WorkshopID, Workshop.WorkshopType, Workshop.Price
)
SELECT 
	WorkshopID, 
    WorkshopType,
    TotalRegistered, 
    Price, 
    Revenue
FROM WorkshopRevenue
WHERE Revenue = (SELECT MAX(Revenue) FROM WorkshopRevenue);

-- No 5
SELECT 
	CONCAT(Client.FirstName, ' ', Client.LastName) AS ClientName, 
    Attendance.AttendanceDate
FROM Client
JOIN Attendance ON Client.ClientID=Attendance.ClientID
WHERE EventID LIKE "4%"
ORDER BY Client.ClientID ASC, Attendance.AttendanceDate ASC;

-- No 6
SELECT 
	Client.ClientID, 
    MembershipType.Type AS MembershipType, 
    LoyaltyPoint.PointsEarned, 
    COUNT(Attendance.AttendanceDate) AS NumberOfSeminarAttended
FROM Client
JOIN Attendance ON Client.ClientID=Attendance.ClientID
JOIN MembershipType ON Client.MembershipID=MembershipType.MembershipID
JOIN LoyaltyPoint ON Client.ClientID=LoyaltyPoint.ClientID
WHERE EventID LIKE "4%"
AND (
AttendanceDate LIKE "2024-06%"
OR AttendanceDate LIKE "2024-07%"
OR AttendanceDate LIKE "2024-08%"
)
GROUP BY Client.ClientID, 
MembershipType.Type, 
LoyaltyPoint.PointsEarned
ORDER BY Client.ClientID ASC;

-- No 7
SELECT 
	Workshop.WorkshopID, 
    COUNT(Attendance.AttendanceDate) AS TotalRegistered, 
    Workshop.DifficultyLevel, 
    Brand.BrandName
FROM Workshop
JOIN Attendance ON Workshop.WorkshopID=Attendance.EventID
LEFT JOIN Brand ON Workshop.BrandID=Brand.BrandID -- Can't just join because some brandid null
GROUP BY Workshop.WorkshopID, 
Workshop.DifficultyLevel, 
Brand.BrandName
ORDER BY Workshop.WorkshopID ASC;

-- No 8
SELECT 
	Instructor.InstructorID,
	CONCAT(Instructor.FirstName, ' ', Instructor.LastName) AS InstructorName, 
    Instructor.Specialty,
    (SELECT COUNT(DISTINCT Workshop.WorkshopID)
     FROM Workshop
     WHERE Workshop.InstructorID = Instructor.InstructorID
     AND Workshop.Date LIKE '2024%') AS WorkshopsConducted,
     Workshop.WorkshopID,
    COUNT(Attendance.AttendanceDate) AS TotalAttended
FROM Instructor
JOIN Workshop ON Instructor.InstructorID=Workshop.InstructorID
JOIN Attendance ON Workshop.WorkshopID=Attendance.EventID
WHERE Workshop.Date LIKE '2024%'
GROUP BY Instructor.InstructorID,
InstructorName,
Instructor.Specialty,
Workshop.WorkshopID
ORDER BY Instructor.InstructorID ASC, Workshop.WorkshopID ASC;

-- No 9
WITH 
WorkshopActivities AS (
    SELECT
        Attendance.ClientID,
        Workshop.WorkshopType AS ItemInvolved,
        Attendance.AttendanceDate AS ActivityDate,
        PointAllocation.PointsWorth,
        'Workshop' AS ActivityType
    FROM PointAllocation
    JOIN Attendance ON PointAllocation.ActivityID = Attendance.EventID
    JOIN Workshop ON Attendance.EventID = Workshop.WorkshopID
    WHERE PointAllocation.ActivityType = 'Workshop'
),
RentalActivities AS (
    SELECT
        ClientEquipmentRental.ClientID,
        Equipment.EquipmentName AS ItemInvolved,
        ClientEquipmentRental.RentalDate AS ActivityDate,
        PointAllocation.PointsWorth,
        'Rental' AS ActivityType
    FROM PointAllocation
    JOIN ClientEquipmentRental ON PointAllocation.ActivityID = ClientEquipmentRental.RentalID
    JOIN Equipment ON ClientEquipmentRental.EquipID = Equipment.EquipID
    WHERE PointAllocation.ActivityType = 'Rental'
),
PrivateSessionActivities AS (
    SELECT
        PrivateSession.ClientID,
        PrivateSession.Activity AS ItemInvolved,
        PrivateSession.Date AS ActivityDate,
        PointAllocation.PointsWorth,
        'PrivateSession' AS ActivityType
    FROM PointAllocation
    JOIN PrivateSession ON PointAllocation.ActivityID = PrivateSession.SessionID
    WHERE PointAllocation.ActivityType = 'PrivateSession'
),
AllActivities AS (
    SELECT * FROM WorkshopActivities
    UNION ALL
    SELECT * FROM RentalActivities
    UNION ALL
    SELECT * FROM PrivateSessionActivities
)
SELECT
    Client.ClientID,
    CONCAT(Client.FirstName, ' ', Client.LastName) AS ClientName,
    MembershipType.Type AS MembershipType,
    AllActivities.ActivityType,
    AllActivities.ItemInvolved,
    AllActivities.ActivityDate,
    AllActivities.PointsWorth AS PointsEarned
FROM Client
LEFT JOIN MembershipType ON Client.MembershipID = MembershipType.MembershipID
LEFT JOIN AllActivities ON Client.ClientID = AllActivities.ClientID
ORDER BY MembershipType.Type, Client.ClientID, AllActivities.ActivityType;

-- Part D
-- Report 1 to show the total number of workshops, seminars, and private sessions an instructor has conducted
SELECT 
    Instructor.InstructorID, 
    CONCAT(Instructor.FirstName, ' ', Instructor.LastName) AS InstructorName, 
    COUNT(DISTINCT Workshop.WorkshopID) AS WorkshopsConducted, 
    COUNT(DISTINCT Seminar.SeminarID) AS SeminarsConducted, 
    COUNT(DISTINCT PrivateSession.SessionID) AS PrivateSessions
FROM Instructor
LEFT JOIN Workshop ON Workshop.InstructorID = Instructor.InstructorID
LEFT JOIN Seminar ON Seminar.InstructorID = Instructor.InstructorID
LEFT JOIN PrivateSession ON PrivateSession.InstructorID = Instructor.InstructorID
GROUP BY Instructor.InstructorID
ORDER BY WorkshopsConducted DESC;

-- Report 2 to know what people rate each activity and to know which to improve first
SELECT 
    CASE
        WHEN Feedback LIKE '%workshop%' OR Feedback LIKE '%Workshop%' THEN 'Workshop'
        WHEN Feedback LIKE '%session%' OR Feedback LIKE '%Session%' THEN 'Private Session'
        WHEN Feedback LIKE '%equipment%' OR Feedback LIKE '%Equipment%' OR Feedback LIKE '%tool%' OR Feedback LIKE '%Tool%' THEN 'Equipment'
        WHEN Feedback LIKE '%seminar%' OR Feedback LIKE '%Seminar%' OR Feedback LIKE '%speaker%' OR Feedback LIKE '%Speaker%' THEN 'Seminar'
        ELSE 'Others'
    END AS FeedbackCategory,
    COUNT(*) AS NumberOfFeedback,
    AVG(Rating) AS AverageRating
FROM ClientFeedback
GROUP BY FeedbackCategory;

-- Report 3 to assess the success of referral program
WITH 
OverallAverage AS (
    SELECT AVG(AttendanceCount) AS OverallAverageAttendance
    FROM (
        SELECT 
            Client.ClientID,
            COUNT(Attendance.AttendanceID) AS AttendanceCount
        FROM Client
        LEFT JOIN Attendance ON Client.ClientID = Attendance.ClientID
        GROUP BY Client.ClientID
    ) AS OverallAverage
),

ReferredClientAttendance AS (
    SELECT 
        ReferralProgram.ClientID AS ReferrerID,
        ReferralProgram.ReferredClientID,
        COUNT(Attendance.AttendanceID) AS AttendanceCount
    FROM ReferralProgram
    JOIN Attendance ON ReferralProgram.ReferredClientID = Attendance.ClientID
    GROUP BY ReferralProgram.ClientID, ReferralProgram.ReferredClientID
)

SELECT 
    ReferredClientAttendance.ReferrerID,
    ReferredClientAttendance.ReferredClientID,
    ReferredClientAttendance.AttendanceCount AS ReferredClientAttendance,
    OverallAverage.OverallAverageAttendance,
    CASE 
        WHEN ReferredClientAttendance.AttendanceCount > OverallAverage.OverallAverageAttendance THEN 'Above Average'
        WHEN ReferredClientAttendance.AttendanceCount < OverallAverage.OverallAverageAttendance THEN 'Below Average'
        ELSE 'Average'
    END AS AttendanceComparison
FROM ReferredClientAttendance
JOIN OverallAverage
ORDER BY ReferredClientAttendance.ReferrerID, ReferredClientAttendance.ReferredClientID;

-- Report 4 to see the patterns in clients booking private session
SELECT 
    Month(Date) AS Month,
    COUNT(SessionID) AS NumberOfSessions,
    SUM(Price) AS MonthlyRevenue
FROM PrivateSession
GROUP BY Month
ORDER BY Month ASC;

-- Report 5 to analyze revenue per activity and membership type to know where to focus on
SELECT 
    MembershipType.Type AS MembershipType,
    COUNT(DISTINCT Client.ClientID) AS TotalClients,
    SUM(Workshop.Price * (SELECT COUNT(*) FROM Attendance WHERE Attendance.ClientID = Client.ClientID AND Attendance.EventType = 'Workshop')) AS TotalWorkshopRevenue,
    SUM(PrivateSession.Price * (SELECT COUNT(*) FROM PrivateSession WHERE PrivateSession.ClientID = Client.ClientID)) AS TotalPrivateSessionRevenue,
    SUM(Equipment.RentalFee * (SELECT COUNT(*) FROM ClientEquipmentRental WHERE ClientEquipmentRental.ClientID = Client.ClientID)) AS TotalEquipmentRentalRevenue,
    SUM(Workshop.Price * (SELECT COUNT(*) FROM Attendance WHERE Attendance.ClientID = Client.ClientID AND Attendance.EventType = 'Workshop')) +
    SUM(PrivateSession.Price * (SELECT COUNT(*) FROM PrivateSession WHERE PrivateSession.ClientID = Client.ClientID)) +
    SUM(Equipment.RentalFee * (SELECT COUNT(*) FROM ClientEquipmentRental WHERE ClientEquipmentRental.ClientID = Client.ClientID)) AS TotalRevenue,
    (
        SUM(Workshop.Price * (SELECT COUNT(*) FROM Attendance WHERE Attendance.ClientID = Client.ClientID AND Attendance.EventType = 'Workshop')) +
        SUM(PrivateSession.Price * (SELECT COUNT(*) FROM PrivateSession WHERE PrivateSession.ClientID = Client.ClientID)) +
        SUM(Equipment.RentalFee * (SELECT COUNT(*) FROM ClientEquipmentRental WHERE ClientEquipmentRental.ClientID = Client.ClientID))
    ) / COUNT(DISTINCT Client.ClientID) AS AverageRevenuePerClient
    FROM MembershipType
JOIN Client ON MembershipType.MembershipID = Client.MembershipID
LEFT JOIN Attendance ON Client.ClientID = Attendance.ClientID AND Attendance.EventType = 'Workshop'
LEFT JOIN Workshop ON Attendance.EventID = Workshop.WorkshopID
LEFT JOIN PrivateSession ON Client.ClientID = PrivateSession.ClientID
LEFT JOIN ClientEquipmentRental ON Client.ClientID = ClientEquipmentRental.ClientID
JOIN Equipment ON ClientEquipmentRental.EquipID = Equipment.EquipID
GROUP BY MembershipType.Type
ORDER BY TotalRevenue DESC;