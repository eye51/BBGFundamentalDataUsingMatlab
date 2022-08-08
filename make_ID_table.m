% connect to (local) database

setdbprefs('DataReturnFormat','structure');
connDB = database('dailydata', '', '');

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

% GICS_SUB_INDUSTRY
% ID_NAICS_CODE
% ID_ISIN


fields = {  'GICS_SUB_INDUSTRY', ...
            'ID_ISIN', ...
            'ID_NAICS_CODE'};
        
data2 = fetch(Connection, stocks, 'GETDATA', fields)


colIndentifyingInfo = {'BBG_id','ISIN','GICS', 'NAICS'};               

for i=1:noStocks

    
    if strcmp(data2.ID_NAICS_CODE{i},'N.A.') 
        data2.ID_NAICS_CODE{i}='-99.9';
    end
    
    dataIndentifyingInfo = {stocks{i}, data2.ID_ISIN{i}, data2.GICS_SUB_INDUSTRY(i),str2double(data2.ID_NAICS_CODE{i})};

fastinsert(connDB, 'Identifiers', colIndentifyingInfo ,dataIndentifyingInfo ) ;  
end
