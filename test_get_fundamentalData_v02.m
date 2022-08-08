

% connect to Bloomberg terminal

Connection = blp;

 


% path(path,'G:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib');
% path(path,'G:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib/m-files');

path(path,'H:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib');
path(path,'H:/Users/Bastiaan de Geeter/Documents/MATLAB/TA-lib/m-files');
path(path,'H:/Users/Bastiaan de Geeter/Documents/MATLAB/test_indicators/extra indicators and tools');

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



colMonthlyinfo = {'stock_id','dateStamp',fields{:}};               

              
 noCol=size(colMonthlyinfo,2); 
 
 for i=348:noStocks

    i 
    noStocks
    
    
    if ~strcmp(isin(i),'')
    tic
    dataBBG = history(Connection, stocks(i), fields, '1/1/2000', '3/1/2011', 'monthly');
    toc
    

    noDates = size(dataBBG,1);

    DBdata = cell(noDates,noCol);
    DBdata(:,1) = stocks(i); % bb ticker


     for k=1:noDates
        DBdata(k,2) = {datestr(dataBBG(k,1))}; %   date
     end

    DBdata(:,3:end) =   num2cell(dataBBG(:,2:end));


    fastinsert(connDB, 'dailystockdata.dbo.fundData', colMonthlyinfo ,DBdata ) ;     
    clear DBdata;
    end
 end