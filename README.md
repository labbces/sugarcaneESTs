# SugarcaneESTs
Transcript expression across diverse EST libraries from PMID:1461397

## Methods

Sugarcane ESTs were downloaded from NCBI, separated by library and then expression values (counts per transcript per library) were computed for each transcript in each library with Salmon 1.8.0 against the SUCEST transcript assembly.

Counts were transformed into Counts Per Thousand (CPT).

### Source of EST data

All EST data presented here comes from teh SUCEST project from the early 2000s.

| EST library name | Biosample NCBI | Tissue | Number of sequences |  
| --- | --- | --- | --- |
| AD1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168687  | seedlings inoculated with Gluconacetobacter diazotroficans | 14629 |
| AM1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168688  | Apical meristem and tissues surrounding of mature plants | 10813 |
| AM2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168689  | Apical meristem and tissues surrounding of immature plants | 13325 | 
| CL1 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168690  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 193 |
| CL2 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168691  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 66 |
| CL3 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168692  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 753 |
| CL4 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168693  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 1377 | 
| CL5 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168694  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 461 |
| CL6  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168695  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 5482 | 
| CL7  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168696  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 609 |
| FL1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168697  | Inflorescence at begining of development (1cm-long) | 15277 |
| FL2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168720  | Developed inflorescence (20cm-long) without rachis | 58 | 
| FL3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168721  | Base of developing inflorescence (5cm-long) | 10692 |
| FL4  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168698  | Developed inflorescence and rachis (20cm-long) | 13912 |
| FL5  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168722  | Developed inflorescence (20cm-long) without rachis | 7713 | 
| FL6  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168723  | Developed inflorescence (20cm-long) without rachis | 235 | 
| FL8  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168699  | Developing inflorescence and rachis (10cm-long) | 4629 |
| HR1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168700  | seedlings inoculated with Herbaspirilum rubrisubalbicans | 9684 |
| LB1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168701  | Lateral buds from field grown adult plants | 5867 |
| LB2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168702  | Lateral buds from plants adult plants growing in greenhouse | 8910 |
| LR1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168703  | Leaf roll from field grown adult plants (large insert library) | 11651 |
| LR2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168704  | Leaf roll from field grown adult plants (small insert library) | 3409 |
| LV1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168705  | Etiolated leaves from in vitro grown sedlings | 4543 |
| RT1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168708  | Root tips (0.3cm-long) from adult plants | 7211 |
| RT2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168709  | Root tips(0.3cm-long) from adult plants | 10559 |
| RT3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168710  | Root apex from adult plants | 7421 |
| RZ1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168711  | Shoot-root transition zone from young plants (large insert library) | 2820 |
| RZ2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168712  | Shoot-root transition zone from young plants (small insert library) | 5019 |
| RZ3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168713  | Shoot-root transition zone from adult plants | 12806 | 
| SB1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168714  | Stalk Bark from adult plants | 13151 |
| SD1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168715  | Developing seeds (large insert library) | 8542 |
| SD2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168716  | Developing seeds (small insert library) |8470 |
| ST1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168717  | First apical stalk internodes of adult plants | 6906 |
| ST2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168718  | Fourth apical stalk internodes of adult plants | 261 |
| ST3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168719  | Fourth apical stalk internodes of adult plants | 8911 |
| NR1 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168706  | Pool of sugarcane tissues | 287 |
| NR2 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168707  | Pool of sugarcane tissues | 264 |
