# aisc-csv
CSV files extracted from the AISC shapes database MS Excel spreadsheet, separated into US and SI versions, and pre-processed for easier integration into other software.
Property descriptions and applicable units are described in the source Excel spreadsheet.

Pre-processing:
- Numbers are formatted as decimal.
- Long-dashes (empty data) are replaced with blank cells.
- Property "tan(α)" is renamed to "tan(a)".

## Version 15.0 database disclaimer
The data in the v15.0 folder was copied from the "AISC Shapes Database v15.0", which has the following disclaimer:

> The information presented in this spreadsheet has been prepared following recognized principles of design and construction. While it is believed to be accurate, this information should not be used or relied upon for any specific application without competent professional examination and verification of its accuracy, suitability and applicability by a licensed engineer or architect. The publication of this information is not a representation or warranty on the part of the American Institute of Steel Construction, its officers, agents, employees or committee members, or of any other person named herein, that this information is suitable for any general or particular use, or of freedom from infringement of any patent or patents. All representations or warranties, express or implied, other than as stated above, are specifically disclaimed. Anyone making use of the information presented in this publication assumes all liability arising from such use.
> 
> Caution must be exercised when relying upon standards and guidelines developed by other bodies and incorporated by reference herein since such material may be modified or amended from time to time subsequent to the printing of this edition. The American Institute of Steel Construction bears no responsibility for such material other than to refer to it and incorporate it by reference at the time of the initial publication of this edition.
