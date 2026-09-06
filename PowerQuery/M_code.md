# Verbatim Power Query (M) Code Reference

The following M scripts are extracted directly from the semantic model partitions and query definitions in `orignal made by me.SemanticModel/definition/`.

---

## 1. `Sales` Table Partition

```powerquery
let
    Source = Csv.Document(
        File.Contents("C:\Users\sbixb\Downloads\Global+Electronics+Retailer\Sales.csv"),
        [Delimiter=",", Columns=9, Encoding=1252, QuoteStyle=QuoteStyle.None]
    ),

    #"Promoted Headers" = Table.PromoteHeaders(
        Source,
        [PromoteAllScalars=true]
    ),

    #"Changed Types" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"Order Number", Int64.Type},
            {"Line Item", Int64.Type},
            {"CustomerKey", Int64.Type},
            {"StoreKey", Int64.Type},
            {"ProductKey", Int64.Type},
            {"Quantity", Int64.Type},
            {"Currency Code", type text}
        }
    ),

    #"Fixed Order Date" = Table.TransformColumns(
        #"Changed Types",
        {
            {
                "Order Date",
                each
                    if _ = null or Text.Trim(Text.From(_)) = "" then
                        null
                    else
                        try
                            Date.FromText(
                                Text.Trim(Text.From(_)),
                                [Format="M/d/yyyy", Culture="en-US"]
                            )
                        otherwise null,
                type nullable date
            }
        }
    ),

    #"Fixed Delivery Date" = Table.TransformColumns(
        #"Fixed Order Date",
        {
            {
                "Delivery Date",
                each
                    if _ = null or Text.Trim(Text.From(_)) = "" then
                        null
                    else
                        try
                            Date.FromText(
                                Text.Trim(Text.From(_)),
                                [Format="M/d/yyyy", Culture="en-US"]
                            )
                        otherwise null,
                type nullable date
            }
        }
    )
in
    #"Fixed Delivery Date"
```

---

## 2. `Products` Table Partition

```powerquery
let
    Source = Csv.Document(File.Contents("C:\Users\sbixb\Downloads\Global+Electronics+Retailer\Products.csv"),[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"ProductKey", Int64.Type}, {"Product Name", type text}, {"Brand", type text}, {"Color", type text}, {"Unit Cost USD", type text}, {"Unit Price USD", type text}, {"SubcategoryKey", Int64.Type}, {"Subcategory", type text}, {"CategoryKey", Int64.Type}, {"Category", type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Unit Cost USD", Text.Trim, type text}, {"Unit Price USD", Text.Trim, type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Trimmed Text","$","",Replacer.ReplaceText,{"Unit Cost USD", "Unit Price USD"})
in
    #"Replaced Value"
```

---

## 3. `Customers` Table Partition

```powerquery
let
    Source = Csv.Document(File.Contents("C:\Users\sbixb\Downloads\Global+Electronics+Retailer\Customers.csv"),[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"CustomerKey", Int64.Type}, {"Gender", type text}, {"Name", type text}, {"City", type text}, {"State Code", type text}, {"State", type text}, {"Zip Code", Int64.Type}, {"Country", type text}, {"Continent", type text}, {"Birthday", type date}})
in
    #"Changed Type"
```

---

## 4. `Stores` Table Partition

```powerquery
let
    Source = Csv.Document(File.Contents("C:\Users\sbixb\Downloads\Global+Electronics+Retailer\Stores.csv"),[Delimiter=",", Columns=5, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"StoreKey", Int64.Type}, {"Country", type text}, {"State", type text}, {"Square Meters", Int64.Type}, {"Open Date", type text}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Changed Type",{{"Open Date", type date}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type1", "Channel", each if [StoreKey] = 0 then "Online" else "Physical Store")
in
    #"Added Custom"
```

---

## 5. `Exchange_Rates` Table Partition

```powerquery
let
    Source = Csv.Document(File.Contents("C:\Users\sbixb\Downloads\Global+Electronics+Retailer\Exchange_Rates.csv"),[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Date", type text}, {"Currency", type text}, {"Exchange", type number}})
in
    #"Changed Type"
```

---

## 6. `Errors in Customers` Error Handling Query

```powerquery
let
    Source = Customers,
    #"Detected Type Mismatches" = let
        tableWithOnlyPrimitiveTypes = Table.SelectColumns(Source, Table.ColumnsOfType(Source, {type nullable number, type nullable text, type nullable logical, type nullable date, type nullable datetime, type nullable datetimezone, type nullable time, type nullable duration})),
        recordTypeFields = Type.RecordFields(Type.TableRow(Value.Type(tableWithOnlyPrimitiveTypes))),
        fieldNames = Record.FieldNames(recordTypeFields),
        fieldTypes = List.Transform(Record.ToList(recordTypeFields), each [Type]),
        pairs = List.Transform(List.Positions(fieldNames), (i) => {fieldNames{i}, (v) => if v = null or Value.Is(v, fieldTypes{i}) then v else error [Message = "The type of the value does not match the type of the column.", Detail = v], fieldTypes{i}})
    in
        Table.TransformColumns(Source, pairs),
    #"Added Index" = Table.AddIndexColumn(#"Detected Type Mismatches", "Row Number" ,1),
    #"Kept Errors" = Table.SelectRowsWithErrors(#"Added Index", {"CustomerKey", "Gender", "Name", "City", "State Code", "State", "Zip Code", "Country", "Continent", "Birthday"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Kept Errors", {"Row Number", "CustomerKey", "Gender", "Name", "City", "State Code", "State", "Zip Code", "Country", "Continent", "Birthday"})
in
    #"Reordered Columns"
```
