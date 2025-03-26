cd "D:\Google Download"
log using "project.log", replace
use "TRD_Mnth.dta",clear
gen date=monthly(Trdmnt, "YM")
format date %tm
gen date_daily = dofm(date)
format date_daily %td
gen month=month(date_daily)
keep if mod(month, 3) == 0  
gen dateq=qofd(dofm(date))
format dateq %tq
drop Trdmnt
drop date
drop date_daily
drop month
rename dateq Accper
save "processed_TRD_Mnth.dta", replace

use "FI_T9.dta",clear
gen date=date(Accper, "YMD")
gen month=month(date)
keep if mod(month, 3) == 0 
keep if Typrep == "A"
format date %td
gen dateq=qofd(date)
format dateq %tq
drop Accper
drop date
drop month
rename dateq Accper
save "processed_FI_T9.dta", replace


use "FI_T5.dta",clear
gen date=date(Accper, "YMD")
gen month=month(date)
keep if mod(month, 3) == 0 
keep if Typrep == "A"
format date %td
gen dateq=qofd(date)
format dateq %tq
drop Accper
drop date
drop month
rename dateq Accper
save "processed_FI_T5.dta", replace

use "STK_MKT_STKBTAL.dta",clear
gen date=date(TradingDate, "YMD")
gen month=month(date)
gen year = year(date)
bysort Symbol year month (date): keep if _n == _N
keep if mod(month, 3) == 0 
format date %td
gen dateq=qofd(date)
format dateq %tq
drop TradingDate
drop date
drop month
drop year
rename dateq Accper
rename Symbol Stkcd
save "processed_STK_MKT_STKBTAL.dta", replace

use "processed_TRD_Mnth.dta",clear
merge 1:1 Accper Stkcd using "processed_FI_T9.dta"
gen PBratio=Mclsprc/F091001A
drop _merge
merge 1:1 Accper Stkcd using "processed_FI_T5.dta"
drop _merge
merge 1:1 Accper Stkcd using "processed_STK_MKT_STKBTAL.dta"
drop _merge
summarize PBratio, detail
centile PBratio, centile(5 95)
return list
local p5 = r(c_1)
local p95 = r(c_2)
drop if PBratio < `p5' | PBratio > `p95'
save "processed_dataset1.dta", replace

keep if Accper == tq(2010q4)
reg PBratio F050504C Volatility

use "TRD_Mnth.dta",clear
gen date=monthly(Trdmnt, "YM")
format date %tm 
gen dateq=qofd(dofm(date))
format dateq %tq
drop Trdmnt
rename date Trdmnt
rename dateq Accper
save "processed_TRD_Mnth_monthly.dta", replace

use "processed_dataset1.dta",clear
drop Volatility
drop F050504C
drop F091001A
drop ShortName_EN
drop Mretnd
drop Mclsprc
save "processed_pbratio.dta", replace

use "processed_pbratio.dta",clear
merge 1:m Accper Stkcd using "processed_TRD_Mnth_monthly.dta"
drop _merge
encode Stkcd, gen(Stkcd_num)
xtset Stkcd_num Trdmnt
gen PBratio_lastmonth=L.PBratio
drop if missing(PBratio_lastmonth)
bysort Trdmnt (PBratio_lastmonth): gen rank=_n
xtile PBratio_decile=PBratio_lastmonth,n(10)
bysort Trdmnt PBratio_decile: egen Mretnd_portfolio= mean(Mretnd)
save "processed_dataset2.dta", replace

use "processed_dataset2.dta",clear
collapse (mean) Mretnd, by(PBratio_decile)
graph bar Mretnd, over(PBratio_decile) ///
    title("Mean Monthly Returns for P/B Ratio Deciles") ///
    ylabel(, angle(0))
exit

