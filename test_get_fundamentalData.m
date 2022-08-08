
 


% path(path,'G:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib');
% path(path,'G:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib/m-files');

path(path,'G:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib');
path(path,'G:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib/m-files');
path(path,'G:/Users/Bastiaan de Geeter/Documents/MATLAB/test_indicators/extra indicators and tools');

setdbprefs('DataReturnFormat','structure');

% Connect to DataBase
connDB = database('dbEye51','','');



% columns for storing results


colPatternInfo = {'stock_id','startDate','endDate','lengthPattern', ...
                  'rank', 'patternNR','patternfreq', ...
                  'probabilityCCup','probabilityCCdown', ...
                  'probabilityOCup','probabilityOCdown','directionID'};               


%
% get all available underlyings
%


Query ='Select * From dailystockdata.dbo.Identifiers';
dbd = exec(connDB, Query);
dbd = fetch(dbd);
stocks = dbd.Data.BBG_id;
isin= dbd.Data.ISIN;
noStocks = size(stocks,1);



fields = {  'CURR_ENTP_VAL', ...
            'CF_CASH_FROM_OPER', ...
            'EBITDA', ...
            'IS_INC_BEF_XO_ITEM', ...
            'CUR_MKT_CAP', ...
            'DIVIDEND_YIELD', ...
            'DVD_PAYOUT_RATIO', ...
            'BS_CUR_ASSET_REPORT', ...
            'BS_TOT_NON_CUR_ASSET', ...
            'BS_CUR_LIAB', ...
            'NON_CUR_LIAB', ...
            'BEST_PX_SALES_RATIO', ...
            'PE_RATIO', ...
            'PX_TO_BOOK_RATIO', ...
            'PX_TO_TANG_BOOK_VAL_PER_SH', ...
            'VOLATILITY_30D', ...
            'EQY_RAW_BETA', ...
            'RSI_14D'};

fund = 'KPN NA Equity';

% data = fetch(Connection, Index,'GETDATA', 'INDX_MEMBERS');
data2 = fetch(Connection, fund, 'GETDATA', fields)
data1 = fetch(Connection, fund, 'GETDATA', 'BEST_EPS',{'BEST_DATA_SOURCE_OVERRIDE'},{'BST'})

data3 = fetch(Connection, fund, 'GETDATA', 'BEST_EPS',{'BEST_DATA_SOURCE_OVERRIDE','BEST_CONSOLIDATED_OVERRIDE','BEST_FPERIOD_OVERRIDE'},{'BST','C','2010Y'})

data3 = fetch(Connection, fund, 'GETDATA', 'BEST_EPS',{'BEST_DATA_SOURCE_OVERRIDE','BEST_CONSOLIDATED_OVERRIDE','BEST_FPERIOD_OVERRIDE'},{'BST','C','2011Y'})


%data = fetch(Connection, fund, 'GETDATA', 'BEST_EPS','', 'BEST_DATA_SOURCE_OVERRIDE=,BEST_CONSOLIDATED_OVERRIDE,BEST_FPERIOD_OVERRIDE')

% '"BEST_DATA_SOURCE_OVERRIDE,BEST_CONSOLIDATED_OVERRIDE,BEST_FPERIOD_OVERRIDE","BST,C,2010Y"'