
-- CLEANING DATA THROUGH SQL QURIES --


SELECT 
    *
FROM
    nashville_housing
;





-- DATE FORMAT UPDATE

SELECT 
    SALEDATE, STR_TO_DATE(SALEDATE, '%M %d, %Y') AS SALE_DATE
FROM
    nashville_housing;
    
    

    



-- POPLULATING EMPTY FIELDS IN PROPERTY ADRESS

SELECT 
    *
FROM
    nashville_housing
WHERE
    propertyaddress IS NULL
; 
 
SELECT 
    *
FROM
    nashville_housing
WHERE
    propertyaddress = ''
;
 
UPDATE nashville_housing 
SET 
    propertyaddress = CASE
        WHEN propertyaddress = '' THEN NULL
        ELSE propertyaddress
    END;

SELECT 
    parcelid, PropertyAddress, ownername
FROM
    nashville_housing
WHERE
    PropertyAddress IS NULL
ORDER BY ParcelID
;

SELECT 
    *
FROM
    nashville_housing a
        JOIN
    nashville_housing b ON a.PropertyAddress = b.PropertyAddress
        AND a.UniqueID != b.UniqueID
WHERE
    a.PropertyAddress IS NULL
;

SELECT
*
from nashville_housing
where PropertyAddress is null;

SELECT 
    ParcelID, PropertyAddress
FROM
    nashville_housing
GROUP BY ParcelID , PropertyAddress
HAVING COUNT(UniqueID) > 1;

SELECT 
    a.parcelid,
    a.propertyaddress,
    b.ParcelID,
    b.PropertyAddress,
    IFNULL(a.propertyaddress, b.propertyaddress)
FROM
    nashville_housing a
        JOIN
    nashville_housing b ON a.ownername = b.ownername
        AND a.UniqueID != b.UniqueID
WHERE
    a.PropertyAddress IS NULL;

UPDATE nashville_housing a
        JOIN
    nashville_housing b ON a.ownername = b.ownername
        AND a.UniqueID != b.UniqueID 
SET 
    a.propertyaddress = IFNULL(a.propertyaddress, b.propertyaddress)
WHERE
    a.PropertyAddress IS NULL;





-- BREAKING ADDRESS INTO 2 COLUMNS ( ADDRESS AND CITY)
SELECT 
    PropertyAddress
FROM
    nashville_housing;

SELECT 
    SUBSTRING_INDEX(propertyaddress, ',', 1),
    SUBSTRING_INDEX(propertyaddress, ',', - 1) AS data_after_comma
FROM
    nashville_housing;

alter table nashville_housing
add column propertysplitaddress varchar(255);

UPDATE nashville_housing 
SET 
    propertysplitaddress = SUBSTRING_INDEX(propertyaddress, ',', 1);


alter table nashville_housing
add column propertycityaddress varchar(255);

UPDATE nashville_housing 
SET 
    propertycityaddress = SUBSTRING_INDEX(propertyaddress, ',', - 1);
    
    
    

-- SEPERATING OWNER ADDRESS COLUMN INTO 3 SEPERATE COLUMNS (ADDRESS, CITY, STATE)


SELECT 
SUBSTRING_INDEX(REPLACE(OWNERADDRESS, ',','.'),'.',1),
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OWNERADDRESS, ',','.'),'.',2),'.',-1),
SUBSTRING_INDEX(REPLACE(OWNERADDRESS,',','.'),'.',-1)
FROM nashville_housing;

alter table nashville_housing
add column Owner_address varchar(255);

UPDATE nashville_housing 
SET 
Owner_address = SUBSTRING_INDEX(REPLACE(OWNERADDRESS, ',','.'),'.',1);

alter table nashville_housing
add column owner_city varchar(255);

UPDATE nashville_housing 
SET 
  owner_city =   SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OWNERADDRESS, ',','.'),'.',2),'.',-1);
    
alter table nashville_housing
add column owner_state varchar(255);

UPDATE nashville_housing 
SET 
   owner_state  = SUBSTRING_INDEX(REPLACE(OWNERADDRESS,',','.'),'.',-1);
    
    
    
    
    
    
-- CHANGE Y AND N TO YES AND NO IN SOLDASVACANT COLUMN

    SELECT DISTINCT
     (SoldAsVacant),COUNT(SoldAsVacant)
FROM
    nashville_housing
GROUP BY SoldAsVacant
;

UPDATE nashville_housing
SET SOLDASVACANT = CASE WHEN SOLDASVACANT = 'Y' THEN 'Yes' 
WHEN SOLDASVACANT = 'N' THEN 'No ' ELSE soldasvacant END;








-- REMOVING DUPLICATES

WITH ROWNUMCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY PARCELID, PROPERTYADDRESS, SALEDATE, SALEPRICE, LEGALREFERENCE
            ORDER BY UNIQUEID
        ) AS ROW_NUM
    FROM nashville_housing
)
DELETE nashville_housing
FROM nashville_housing
JOIN ROWNUMCTE ON nashville_housing.UNIQUEID = ROWNUMCTE.UNIQUEID
WHERE ROWNUMCTE.ROW_NUM > 1;







-- REMOVING COLUMNS

ALTER TABLE nashville_housing
DROP COLUMN SALEDATE;

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress;

ALTER TABLE nashville_housing
DROP COLUMN TaxDistrict;

ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress;
