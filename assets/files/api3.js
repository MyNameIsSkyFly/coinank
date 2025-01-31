const apiHost = "https://coinank.com"
const getLiqHeatMap = (params)=>{
    let {exchangeName, symbol, interval} = params
    return fetch(`${apiHost}/api/liqMap/getLiqHeatMap?exchangeName=${exchangeName}&symbol=${symbol}&interval=${interval}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}

const fetchKline = (params)=>{

    let {exchange, symbol, interval, side, ts, size, exchangeType} = params;
    let query = `exchange=${exchange}&symbol=${symbol}&interval=${interval}&side=${side}&ts=${ts}&size=${size}`
    if(exchangeType){
        query+=`&exchangeType=${exchangeType}`
    }
    return fetch(`${apiHost}/api/kline/list?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );

}

const fetchSpotTickers = (params) =>{

    let {baseCoin} = params;
    let query = `baseCoin=${baseCoin}`
    return fetch(`${apiHost}/api/tickers/getSpotTickers?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}

const fetchContractTickers = (params) => {
    let {baseCoin} = params;
    let query = `baseCoin=${baseCoin}`
    return fetch(`${apiHost}/api/tickers?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}


const fetchCategoryData = (params) => {
    let {type, category} = params;
    let query = `page=1&size=50&sortBy=${type}&sortType=descend&tag=${category}`
    return fetch(`${apiHost}/api/instruments/agg?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}

const fetchSpotCategoryData = (params) => {
    let {type, category} = params;
    let query = `page=1&size=50&sortBy=${type}&sortType=descend&tag=${category}`
    return fetch(`${apiHost}/api/instruments/spotAgg?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}