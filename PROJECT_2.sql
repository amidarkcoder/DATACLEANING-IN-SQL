---SHOWING THE TOTAL TABLE
SELECT *
FROM SUSANTA..[Housing ]
---STANDARDIZE DATE FORMAT
select SaleDate, convert(date,saledate)
from SUSANTA..[Housing ]
update SUSANTA..[Housing ]
set SaleDate = convert(date,saledate)
---POPULATE PROPERTY ADDRESS DATA	
---CHECK THE NULL VALUES IN PROPERTYADDRESS
select *
from SUSANTA..[Housing ]
WHERE propertyaddress is null
order by ParcelID
---MAKE A JOIN STATEMENT FOR CHANGE THE VALUE IN COLUMNS
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from SUSANTA..[Housing ] as a 
join SUSANTA..[Housing ] as b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null
---UPDATE NULL VALUES IN TABLE
update a 
set PropertyAddress = isnull(a.propertyaddress,b.PropertyAddress)
from SUSANTA..[Housing ] as a 
join SUSANTA..[Housing ] as b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null
---BREAKEING ADDRESS IN CITY, PIN
select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(propertyaddress)) as address
from SUSANTA..[Housing ]
alter table housing
add propertysplitaddress nvarchar(255);
update [Housing ]
set propertysplitaddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
alter table housing
add propertyaddress_city nvarchar(255);
update [Housing ]
set propertyaddress_city =SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(propertyaddress))
---split oweraddress
select
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from SUSANTA..[Housing ]
---UPDATE TABLE ADDING COLUMNS IN TABLE
alter table housing
add ownersplitaddress nvarchar(255);
update [Housing ]
set ownersplitaddress =parsename(replace(OwnerAddress,',','.'),3)
alter table housing
add owner_city nvarchar(255);
update [Housing ]
set owner_city =parsename(replace(OwnerAddress,',','.'),2)
alter table housing
add owner_state nvarchar(255);
update [Housing ]
set owner_state = parsename(replace(OwnerAddress,',','.'),1)
----REMOVE DUPLICATES
WITH row_num_table AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY
                parcelid,
                propertyaddress,
                saleprice,
                saledate,
                legalreference
            ORDER BY
                uniqueid
        ) AS row_num
    FROM
        SUSANTA..[Housing ]
)
select *
from row_num_table
where row_num >1
---DELETE UNUSED COLUMNS
alter table susanta..[housing ] 
drop column owneraddress,taxdistrict,propertyaddress,saledate,SOLDASVACANT
----SHOWING THE FINAL TABLE
SELECT *
FROM SUSANTA..[Housing ]

                      




