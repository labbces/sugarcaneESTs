# SugarcaneESTs
Transcript expression across diverse EST libraries from PMID:1461397

## Methods

Sugarcane ESTs were downloaded from NCBI, separated by library and then expression values (counts per transcript per library) were computed for each transcript in each library with Salmon 1.8.0 against the SUCEST transcript assembly.

Counts were transformed into Counts Per Thousand (CPT).

### Source of EST data

All EST data presented here comes from teh SUCEST project from the early 2000s.

| EST library name | Biosample NCBI | Tissue | 
| AD1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168687  | seedlings inoculated with Gluconacetobacter diazotroficans |
| AM1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168688  | Apical meristem and tissues surrounding of mature plants |
| AM2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168689  | Apical meristem and tissues surrounding of immature plants |
| CL1 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168690  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress |
| CL2 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168691  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 
| CL3 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168692  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress |
| CL4 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168693  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress |
| CL5 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168694  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 
| CL6  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168695  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress | 
| CL7  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168696  | Pool of sugarcane calli submitted to low (4oC) and high (37 C) temperature stress |
| FL1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168697  | Inflorescence at begining of development (1cm-long) |
| FL2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168720  | Developed inflorescence (20cm-long) without rachis |
| FL3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168721  | Base of developing inflorescence (5cm-long) | 
| FL4  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168698  | Developed inflorescence and rachis (20cm-long) |
| FL5  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168722  | Developed inflorescence (20cm-long) without rachis |
| FL6  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168723  | Developed inflorescence (20cm-long) without rachis |
| FL8  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168699  | Developing inflorescence and rachis (10cm-long) |
| HR1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168700  | seedlings inoculated with Herbaspirilum rubrisubalbicans |
| LB1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168701  | Lateral buds from field grown adult plants |
| LB2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168702  | Lateral buds from plants adult plants growing in greenhouse |
| LR1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168703  | Leaf roll from field grown adult plants (large insert library) |
| LR2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168704  | Leaf roll from field grown adult plants (small insert library) |
| LV1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168705  | Etiolated leaves from in vitro grown sedlings |
| RT1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168708  | Root tips (0.3cm-long) from adult plants |
| RT2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168709  | Root tips(0.3cm-long) from adult plants |
| RT3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168710  | Root apex from adult plants | 
| RZ1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168711  | Shoot-root transition zone from young plants (large insert library) |
| RZ2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168712  | Shoot-root transition zone from young plants (small insert library) |
| RZ3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168713  | Shoot-root transition zone from adult plants |
| SB1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168714  | Stalk Bark from adult plants |
| SD1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168715  | Developing seeds (large insert library) | 
| SD2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168716  | Developing seeds (small insert library) |
| ST1  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168717  | First apical stalk internodes of adult plants |
| ST2  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168718  | Fourth apical stalk internodes of adult plants |
| ST3  | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168719  | Fourth apical stalk internodes of adult plants |
| NR1 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168706  | Pool of sugarcane tissues |
| NR2 | https://www.ncbi.nlm.nih.gov/biosample/SAMN00168707  | Pool of sugarcane tissues | 
