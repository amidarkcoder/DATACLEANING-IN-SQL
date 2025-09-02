Data Cleaning and Transformation Summary
1. Standardizing the Date Format

The SaleDate column is converted from its original format to a standard date format.

The table is then updated with the new, standardized date values.

2. Handling Missing Property Addresses

The script first checks for NULL values in the PropertyAddress column.

It then uses a self-join on the ParcelID to find properties that have the same parcel ID but are missing an address. This assumes that properties with the same ParcelID should have the same address.

The NULL addresses are updated by populating them with the correct address found through the self-join.

3. Splitting Address Columns

The PropertyAddress column is split into two new columns:

propertysplitaddress (containing the street address)

propertyaddress_city (containing the city)

The script uses SUBSTRING and CHARINDEX functions to extract the relevant parts of the address string.

Similarly, the OwnerAddress column is split into three new columns:

ownersplitaddress (street address)

owner_city (city)

owner_state (state)

The PARSENAME function is used for this task, which is a convenient way to split a string based on a delimiter (after replacing commas with periods).

4. Removing Duplicate Rows

A Common Table Expression (CTE) named row_num_table is used to identify duplicate rows.

It uses the ROW_NUMBER() window function with a PARTITION BY clause on key columns (ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference) to assign a unique number to each row within a partition.

Rows with a row_num greater than 1 are identified as duplicates. The script selects these duplicates but doesn't show a DELETE statement, so it appears it was only for verification. To actually remove them, a DELETE statement targeting those rows would be needed.

5. Dropping Unused Columns

Several original columns are removed from the table to reduce redundancy and clutter after the new, split columns have been created.

The columns dropped are: OwnerAddress, TaxDistrict, PropertyAddress, SaleDate, and SoldAsVacant.
