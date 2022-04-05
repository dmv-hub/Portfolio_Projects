--Cleaning data in SQL Portfolio Project--

SELECT * 
FROM Portfolio_Project.dbo.[Nashville Housing Data]


-- Standardize Date Format

ALTER TABLE [Nashville Housing Data]
ADD SaleDateConverted Date;

UPDATE [Nashville Housing Data]
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted 
FROM Portfolio_Project.dbo.[Nashville Housing Data]


--Populate Property Address Data


SELECT *
FROM Portfolio_Project.dbo.[Nashville Housing Data]
ORDER BY ParcelID


-- Identifying nulls by ParcellID
SELECT  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project.dbo.[Nashville Housing Data] a
JOIN Portfolio_Project.dbo.[Nashville Housing Data] b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

--Updating PropertyAdress Nulls by ParcelID
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project.dbo.[Nashville Housing Data] a
JOIN Portfolio_Project.dbo.[Nashville Housing Data] b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


-- Breaking out Addresses into Individual Colunmns (street address, city, state)


SELECT PropertyAddress
FROM Portfolio_Project.dbo.[Nashville Housing Data]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM Portfolio_Project.dbo.[Nashville Housing Data]


ALTER TABLE [Nashville Housing Data]
ADD Property_Address_Street NVARCHAR(255);

UPDATE [Nashville Housing Data]
SET Property_Address_Street = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [Nashville Housing Data]
ADD Property_Address_City NVARCHAR(255);

UPDATE [Nashville Housing Data]
SET Property_Address_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 





--Splitting Owner Address


SELECT OwnerAddress
FROM Portfolio_Project.dbo.[Nashville Housing Data]

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) AS Owner_Address_Street,
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) AS Owner_Address_City,
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1) AS Owner_Address_State
FROM Portfolio_Project.dbo.[Nashville Housing Data] 

ALTER TABLE [Nashville Housing Data]
ADD Owner_Address_Street NVARCHAR(255);

UPDATE [Nashville Housing Data]
SET Owner_Address_Street = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE [Nashville Housing Data]
ADD Owner_Address_City NVARCHAR(255);

UPDATE [Nashville Housing Data]
SET Owner_Address_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE [Nashville Housing Data]
ADD Owner_Address_State NVARCHAR(255);

UPDATE [Nashville Housing Data]
SET Owner_Address_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)



--Change Y and N to Yes and No in "SoldAsVacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolio_Project.dbo.[Nashville Housing Data]
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No' 
    ELSE SoldAsVacant
    END
FROM Portfolio_Project.dbo.[Nashville Housing Data]

UPDATE [Nashville Housing Data]
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No' 
    ELSE SoldAsVacant
    END



--Removing Duplicates
WITH RowNumCTE AS (
SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY ParcelID,
        PropertyAddress,
        SalePrice,
        SaleDate,
        LegalReference
        ORDER BY
        UniqueID
    ) row_num
FROM Portfolio_Project.dbo.[Nashville Housing Data]
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1



--Deleting Unused Columns

SELECT *
FROM Portfolio_Project.dbo.[Nashville Housing Data]

ALTER TABLE Portfolio_Project.dbo.[Nashville Housing Data]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio_Project.dbo.[Nashville Housing Data]
DROP COLUMN SaleDate


