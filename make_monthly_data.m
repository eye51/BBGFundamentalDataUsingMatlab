% connect to (local) database

setdbprefs('DataReturnFormat','structure');
connDB = database('dbEye51','badge','kl0tez00i');

%
% get all available underlyings
%


Query ='Select stock From dailystockdata.dbo.stockData where date=''2010-01-27 00:00:00.0'' ';
dbd = exec(connDB, Query);
dbd = fetch(dbd);
stocks = dbd.Data.stock;
noStocks = size(stocks,1);


% connect to Bloomberg terminal

Connection = bloomberg;

% EQY_SH_OUT
% VOLUME_AVG_30D
% VOLUME_AVG_6M
% REL_SHR_PX_MOMENTUM
% RSI_30D
% BEST_TARGET_PRICE


fields = {  'EQY_SH_OUT', ...    
            'VOLUME_AVG_30D', ...
            'VOLUME_AVG_6M', ...
            'REL_SHR_PX_MOMENTUM', ...
            'RSI_30D', ...
            'BEST_TARGET_PRICE'};
        
% data2 = fetch(Connection, stocks(1), 'GETDATA', fields)

[d, sec] = history(Connection, stocks(1), ...
fields, '8/01/2000', '8/10/2011', 'monthly');

% 
% colIndentifyingInfo = {'BBG_id','ISIN','GICS', 'NAICS'};               
% 
% for i=1:noStocks
% 
%     
%     if strcmp(data2.ID_NAICS_CODE{i},'N.A.') 
%         data2.ID_NAICS_CODE{i}='-99.9';
%     end
%     
%     dataIndentifyingInfo = {stocks{i}, data2.ID_ISIN{i}, data2.GICS_SUB_INDUSTRY(i),str2double(data2.ID_NAICS_CODE{i})};
% 
% fastinsert(connDB, 'Identifiers', colIndentifyingInfo ,dataIndentifyingInfo ) ;  
% end
