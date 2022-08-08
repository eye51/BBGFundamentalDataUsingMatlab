% connect to (local) database

setdbprefs('DataReturnFormat','structure');
connDB = database('dbEye51','','');

%
% get all available underlyings
%


Query ='Select * From dailystockdata.dbo.Identifiers';
dbd = exec(connDB, Query);
dbd = fetch(dbd);
stocks = dbd.Data.BBG_id;
isin= dbd.Data.ISIN;
noStocks = size(stocks,1);


% connect to Bloomberg terminal

Connection = blp;

% EQY_SH_OUT
% VOLUME_AVG_30D
% VOLUME_AVG_6M
% REL_SHR_PX_MOMENTUM
% RSI_30D
% BEST_TARGET_PRICE


fields = {  'EQY_SH_OUT', ...               % no_shares_outstanding
            'VOLUME_AVG_30D', ...           % avg_volume_30D
            'VOLUME_AVG_6M', ...            % avg_volume_6M
            'REL_SHR_PX_MOMENTUM', ...      % price_momentum
            'RSI_30D', ...                  % RSI_30D
            'BEST_TARGET_PRICE', ...        % estimated_target_price
            'PCT_INSIDER_SHARES_OUT'};      % insider_holding
        
% data2 = fetch(Connection, stocks(1), 'GETDATA', fields)

dataBBG = history(Connection, stocks(1), ...
fields, '1/1/2000', '3/1/2011', 'monthly');


colMonthlyinfo = {'stock_id','dateStamp','no_shares_outstanding','avg_volume_30D', ...
                  'avg_volume_6M', 'price_momentum','RSI_30D', ...
                  'estimated_target_price','insider_holding'};               

              
 noCol=size(colMonthlyinfo,2); % id of security is also needed, one extra field necessary
 
 for i=841:noStocks

    i 
    noStocks
    
    
    if ~strcmp(isin(i),'')
    tic
    dataBBG = history(Connection, stocks(i), fields, '1/1/2000', '8/1/2011', 'monthly');
    toc
    

    noDates = size(dataBBG,1);

    DBdata = cell(noDates,noCol);
    DBdata(:,1) = stocks(i); % bb ticker


     for k=1:noDates
        DBdata(k,2) = {datestr(dataBBG(k,1))}; %   date
     end

    DBdata(:,3:end) =   num2cell(dataBBG(:,2:end));


    fastinsert(connDB, 'dailystockdata.dbo.MonthlyData', colMonthlyinfo ,DBdata ) ;     
    clear DBdata;
    end
 end
 
     
     %     if strcmp(data2.ID_NAICS_CODE{i},'N.A.') 
%         data2.ID_NAICS_CODE{i}='-99.9';
%     end
%     
%     dataIndentifyingInfo = {stocks{i}, data2.ID_ISIN{i}, data2.GICS_SUB_INDUSTRY(i),str2double(data2.ID_NAICS_CODE{i})};
% 
% fastinsert(connDB, 'Identifiers', colIndentifyingInfo ,dataIndentifyingInfo ) ;  
% end
